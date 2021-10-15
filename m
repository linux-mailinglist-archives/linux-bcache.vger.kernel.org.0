Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB242EEB5
	for <lists+linux-bcache@lfdr.de>; Fri, 15 Oct 2021 12:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbhJOKXx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 06:23:53 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:40068
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S230061AbhJOKXw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 06:23:52 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Oct 2021 06:23:51 EDT
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewCHjbHiVGlhJekCAA--.638S2;
        Fri, 15 Oct 2021 18:16:09 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: move calc_cached_dev_sectors to proper place on backing device detach
Date:   Fri, 15 Oct 2021 18:16:00 +0800
Message-Id: <20211015101600.91109-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewCHjbHiVGlhJekCAA--.638S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw1DAFyrAryfKr4xAFWrKrg_yoW8Gr4kpF
        Z7WFyxArW0qa10qws8Zr47uryFy34DtFZ7Zw17Aa1DuryxW343tr45Xay5uFWrXFWxWFWS
        yw45Wr4UZ3WDGaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Calculation of cache_set's cached sectors is done by travelling
cached_devs list as shown below:

static void calc_cached_dev_sectors(struct cache_set *c)
{
...
        list_for_each_entry(dc, &c->cached_devs, list)
                sectors += bdev_sectors(dc->bdev);

        c->cached_dev_sectors = sectors;
}

But cached_dev won't be unlinked from c->cached_devs list until we call
following list_move(&dc->list, &uncached_devices),
so previous fix in 'commit 46010141da6677b81cc77f9b47f8ac62bd1cbfd3
("bcache: recal cached_dev_sectors on detach")' is wrong, now we move 
it to its right palce.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff79..8543e6997770 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1154,9 +1154,9 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_lock(&bch_register_lock);
 
-	calc_cached_dev_sectors(dc->disk.c);
 	bcache_device_detach(&dc->disk);
 	list_move(&dc->list, &uncached_devices);
+	calc_cached_dev_sectors(dc->disk.c);
 
 	clear_bit(BCACHE_DEV_DETACHING, &dc->disk.flags);
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &dc->disk.flags);
-- 
2.31.1

