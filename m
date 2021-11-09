Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45044A5AF
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Nov 2021 05:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238761AbhKIEQF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Nov 2021 23:16:05 -0500
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:37683
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S236991AbhKIEQF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Nov 2021 23:16:05 -0500
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewAXH0NT9YlhzlsAAA--.417S2;
        Tue, 09 Nov 2021 12:13:11 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: fix NULL pointer reference in cached_dev_detach_finish
Date:   Tue,  9 Nov 2021 12:13:04 +0800
Message-Id: <20211109041304.87225-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewAXH0NT9YlhzlsAAA--.417S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw1kKrW7try3tFyrKFWkCrg_yoW8tFWUpr
        Z7XFyUJFWvqw48Ww42yr47uryrta4DAFyfuw1Fya1Y9ryfW347trW5Xas8A3yUJrW7Wa1I
        yw45Kr4UZFykWaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 0259d4498ba484("bcache: move calc_cached_dev_sectors to proper
place on backing device detach") tries to fix calc_cached_dev_sectors
when bcache device detaches, but now we have:

cached_dev_detach_finish
    ...
    bcache_device_detach(&dc->disk);
        ...
        closure_put(&d->c->caching);
        d->c = NULL; [*explicitly set dc->disk.c to NULL*]
    list_move(&dc->list, &uncached_devices);
    calc_cached_dev_sectors(dc->disk.c); [*passing a NULL pointer*]
    ...

Upper codeflows shows how bug happens, this patch fix the problem by
caching dc->disk.c beforehand, and cache_set won't be freed under us
because c->caching closure at least holds a reference count and closure
callback __cache_set_unregister only being called by bch_cache_set_stop
which using closure_queue(&c->caching), that means c->caching closure
callback for destroying cache_set won't be trigger by previous
closure_put(&d->c->caching).
So at this stage(while cached_dev_detach_finish is calling) it's safe to
access cache_set dc->disk.c.

Fixes: 0259d4498ba484("bcache: move calc_cached_dev_sectors to proper place on backing device detach")
Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4a9a65dff95e..3d9bc7cd27f8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1139,6 +1139,7 @@ static void cancel_writeback_rate_update_dwork(struct cached_dev *dc)
 static void cached_dev_detach_finish(struct work_struct *w)
 {
 	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
+	struct cache_set *c = dc->disk.c;
 
 	BUG_ON(!test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags));
 	BUG_ON(refcount_read(&dc->count));
@@ -1156,7 +1157,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
-	calc_cached_dev_sectors(dc->disk.c);
+	calc_cached_dev_sectors(c);
 
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
-- 
2.31.1

