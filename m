Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382DC42FED0
	for <lists+linux-bcache@lfdr.de>; Sat, 16 Oct 2021 01:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243618AbhJOXdR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 Oct 2021 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243548AbhJOXdE (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 Oct 2021 19:33:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C242C061762;
        Fri, 15 Oct 2021 16:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hYL8LO+ietZVLiEWE2oEBW5mwRVdCiTP81FH5yaWaJI=; b=f+ADLXwubj85qcYLZJoMkaccF0
        LA88l99fFG2x11Wj0W927MuLNzxH+aLXSi41Sta0kPK0c00mcuAfJRMhRo8O2/gVT8jFEkt0Zk4hr
        nRpIIyZaEygIxOu2Ir+1WF5xTs39HUTMf1P+eojMMuW0QLIF0wbil/OQxvEmzd64iDDxrFcmE+0yv
        kE8A86cACAhv+x1ja677g+NC4hNwoUKBXx1xqWEMK3YQiQVLgxdzr8G77MuSAupgfSMZX4TFT1Edb
        SbvQjQ/3HgQObpF99DOxhOoPdReW+f1FUge3qPoQJgqPVxOn1VIhcnU4ycnlt6M5auGj2buchrJJi
        DE0a5Yog==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mbWej-0095uz-9F; Fri, 15 Oct 2021 23:30:29 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
        kent.overstreet@gmail.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, roger.pau@citrix.com,
        geert@linux-m68k.org, ulf.hansson@linaro.org, tj@kernel.org,
        hare@suse.de, jdike@addtoit.com, richard@nod.at,
        anton.ivanov@cambridgegreys.com, johannes.berg@intel.com,
        krisman@collabora.com, chris.obbard@collabora.com,
        thehajime@gmail.com, zhuyifei1999@gmail.com, haris.iqbal@ionos.com,
        jinpu.wang@ionos.com, miquel.raynal@bootlin.com, vigneshr@ti.com,
        linux-mtd@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 4/9] bcache: add error handling support for add_disk()
Date:   Fri, 15 Oct 2021 16:30:23 -0700
Message-Id: <20211015233028.2167651-5-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
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

Acked-by: Coly Li <colyli@suse.de>
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

