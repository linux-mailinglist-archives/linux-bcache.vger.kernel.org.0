Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C07A44E197
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Nov 2021 06:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhKLFju (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Nov 2021 00:39:50 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:58596 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbhKLFjp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Nov 2021 00:39:45 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 89F571FD3C;
        Fri, 12 Nov 2021 05:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636695414; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gIhiSiAEjhx+n244TIAW8dQvcGqEwhML0u6Vs4i+dE=;
        b=pDd/WcsPjnkJz+fPtWLyyKwYd3PmDzYu5O7mtNN7+EUM+8YwxPIq7sOu20BfBWXpy/ygAV
        wJCbf4oA8/pO79uHNmnAh0wtzta9SRaJpIp8urN8/8qrze3dqYIBwgHTcG19ll7DB63mx0
        X3Syek+1wvdOBvtfDiz3MY69d3/6qZw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636695414;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6gIhiSiAEjhx+n244TIAW8dQvcGqEwhML0u6Vs4i+dE=;
        b=FGXuQ94HllFTb8HXDXEnOMfve60VEuYVMaZq01WH98z/d9UNKoHn3DmISMpujjv3+SUS2Z
        Y4KBgNXEcY/nsUAA==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 2064DA3B81;
        Fri, 12 Nov 2021 05:36:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Lin Feng <linf@wangsu.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: fix NULL pointer reference in cached_dev_detach_finish
Date:   Fri, 12 Nov 2021 13:36:29 +0800
Message-Id: <20211112053629.3437-2-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211112053629.3437-1-colyli@suse.de>
References: <20211112053629.3437-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Lin Feng <linf@wangsu.com>

Commit 0259d4498ba4 ("bcache: move calc_cached_dev_sectors to proper
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

Fixes: 0259d4498ba4 ("bcache: move calc_cached_dev_sectors to proper place on backing device detach")
Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 86b9e355c583..140f35dc0c45 100644
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

