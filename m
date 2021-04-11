Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4350835B4BA
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 15:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhDKNoE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 09:44:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:47254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235560AbhDKNn7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:43:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C53F8B1C3;
        Sun, 11 Apr 2021 13:43:35 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/7] bcache: reduce redundant code in bch_cached_dev_run()
Date:   Sun, 11 Apr 2021 21:43:10 +0800
Message-Id: <20210411134316.80274-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
References: <20210411134316.80274-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

In bch_cached_dev_run(), free(env[1])|free(env[2])|free(buf)
show up three times. This patch introduce out tag in
which free(env[1])|free(env[2])|free(buf) are only called
one time. If we need to call free() when errors occur,
we can set error code to ret, and then goto out tag directly.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 03e1fe4de53d..2b6d6e9cd680 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1052,6 +1052,7 @@ static int cached_dev_status_update(void *arg)
 
 int bch_cached_dev_run(struct cached_dev *dc)
 {
+	int ret = 0;
 	struct bcache_device *d = &dc->disk;
 	char *buf = kmemdup_nul(dc->sb.label, SB_LABEL_SIZE, GFP_KERNEL);
 	char *env[] = {
@@ -1064,19 +1065,15 @@ int bch_cached_dev_run(struct cached_dev *dc)
 	if (dc->io_disable) {
 		pr_err("I/O disabled on cached dev %s\n",
 		       dc->backing_dev_name);
-		kfree(env[1]);
-		kfree(env[2]);
-		kfree(buf);
-		return -EIO;
+		ret = -EIO;
+		goto out;
 	}
 
 	if (atomic_xchg(&dc->running, 1)) {
-		kfree(env[1]);
-		kfree(env[2]);
-		kfree(buf);
 		pr_info("cached dev %s is running already\n",
 		       dc->backing_dev_name);
-		return -EBUSY;
+		ret = -EBUSY;
+		goto out;
 	}
 
 	if (!d->c &&
@@ -1097,15 +1094,13 @@ int bch_cached_dev_run(struct cached_dev *dc)
 	 * only class / kset properties are persistent
 	 */
 	kobject_uevent_env(&disk_to_dev(d->disk)->kobj, KOBJ_CHANGE, env);
-	kfree(env[1]);
-	kfree(env[2]);
-	kfree(buf);
 
 	if (sysfs_create_link(&d->kobj, &disk_to_dev(d->disk)->kobj, "dev") ||
 	    sysfs_create_link(&disk_to_dev(d->disk)->kobj,
 			      &d->kobj, "bcache")) {
 		pr_err("Couldn't create bcache dev <-> disk sysfs symlinks\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	dc->status_update_thread = kthread_run(cached_dev_status_update,
@@ -1114,7 +1109,11 @@ int bch_cached_dev_run(struct cached_dev *dc)
 		pr_warn("failed to create bcache_status_update kthread, continue to run without monitoring backing device status\n");
 	}
 
-	return 0;
+out:
+	kfree(env[1]);
+	kfree(env[2]);
+	kfree(buf);
+	return ret;
 }
 
 /*
-- 
2.26.2

