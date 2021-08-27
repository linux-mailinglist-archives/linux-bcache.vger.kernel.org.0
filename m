Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46F3F9FCD
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 21:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhH0TTV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 15:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhH0TTS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:19:18 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0FFC061757;
        Fri, 27 Aug 2021 12:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=H0yjxWrLDkVEjbF/GZd7/ySZbiTiPqu2Q0a9C5B5DM0=; b=jBj7vgYH2nE65LB1og8tiXOxvP
        KBh0R2euadTs8h7IBajXUwNtbsjdFyOM2k7wI7W88Vg5sZeU2CTiHhGXdfgMellg8kXdWVImn8otO
        7gQNJqki565nGVNi4mzdZjvbLvVk28VP4QPb/0g9kyyZHcXPifRZmGLkjAmy9SwJHNSr70ec1Qd3i
        NRTaJtSv320J7Urutn2OyJaSDXn/c3eZ9fTMPhR2umPh8Murmbs3MGmibWqmyLLSz+Mt127usJXms
        UPbPmKYMwaJoNQEMvPVUaYIW8ltdAFibmpKu8cjuAfKGLHb1GY49vqvpX6WZxvV91ZRj3k8SYjiE6
        fyoI6w9g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhMh-00D5As-25; Fri, 27 Aug 2021 19:18:11 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        kbusch@kernel.org, sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 02/10] bcache: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:18:01 -0700
Message-Id: <20210827191809.3118103-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

This driver doesn't do any unwinding with blk_cleanup_disk()
even on errors after add_disk() and so we follow that
tradition.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/bcache/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff79..f0c32cdd6594 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1082,7 +1082,9 @@ int bch_cached_dev_run(struct cached_dev *dc)
 		closure_sync(&cl);
 	}
 
-	add_disk(d->disk);
+	ret = add_disk(d->disk);
+	if (ret)
+		goto out;
 	bd_link_disk_holder(dc->bdev, dc->disk.disk);
 	/*
 	 * won't show up in the uevent file, use udevadm monitor -e instead
@@ -1534,10 +1536,11 @@ static void flash_dev_flush(struct closure *cl)
 
 static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 {
+	int err = -ENOMEM;
 	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
 					  GFP_KERNEL);
 	if (!d)
-		return -ENOMEM;
+		goto err_ret;
 
 	closure_init(&d->cl, NULL);
 	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
@@ -1551,9 +1554,12 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	bcache_device_attach(d, c, u - c->uuids);
 	bch_sectors_dirty_init(d);
 	bch_flash_dev_request_init(d);
-	add_disk(d->disk);
+	err = add_disk(d->disk);
+	if (err)
+		goto err;
 
-	if (kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache"))
+	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache");
+	if (err)
 		goto err;
 
 	bcache_device_link(d, c, "volume");
@@ -1567,7 +1573,8 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	return 0;
 err:
 	kobject_put(&d->kobj);
-	return -ENOMEM;
+err_ret:
+	return err;
 }
 
 static int flash_devs_run(struct cache_set *c)
-- 
2.30.2

