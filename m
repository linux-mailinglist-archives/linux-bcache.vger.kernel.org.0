Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F51245242
	for <lists+linux-bcache@lfdr.de>; Sat, 15 Aug 2020 23:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHOVoV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 Aug 2020 17:44:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:54988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgHOVnr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 Aug 2020 17:43:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 564B9AB3E;
        Sat, 15 Aug 2020 09:24:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: share register sysfs with async register
Date:   Sat, 15 Aug 2020 17:23:49 +0800
Message-Id: <20200815092349.48842-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Previously the experimental async registration uses a separate sysfs
file register_async. Now the async registration code seems working well
for a while, we can do furtuher testing with it now.

This patch changes the async bcache registration shares the same sysfs
file /sys/fs/bcache/register (and register_quiet). Async registration
will be default behavior if BCACHE_ASYNC_REGISTRATION is set in kernel
configure. By default, BCACHE_ASYNC_REGISTRATION is not configured yet.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1bbdc410ee3c..61abd6499a11 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2449,7 +2449,6 @@ static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 
 kobj_attribute_write(register,		register_bcache);
 kobj_attribute_write(register_quiet,	register_bcache);
-kobj_attribute_write(register_async,	register_bcache);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
 
 static bool bch_is_open_backing(struct block_device *bdev)
@@ -2572,6 +2571,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
 	ssize_t ret;
+	bool async_registration = false;
+
+#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
+	async_registration = true;
+#endif
 
 	ret = -EBUSY;
 	err = "failed to reference bcache module";
@@ -2625,7 +2629,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		goto out_blkdev_put;
 
 	err = "failed to register device";
-	if (attr == &ksysfs_register_async) {
+
+	if (async_registration) {
 		/* register in asynchronous way */
 		struct async_reg_args *args =
 			kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
@@ -2888,9 +2893,6 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
-#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
-		&ksysfs_register_async.attr,
-#endif
 		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
-- 
2.26.2

