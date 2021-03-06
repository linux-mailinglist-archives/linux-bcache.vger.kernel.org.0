Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84C9832F7E5
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Mar 2021 03:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCFCod (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 5 Mar 2021 21:44:33 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12701 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCFCoM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Mar 2021 21:44:12 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Dspll23CTzlSgl;
        Sat,  6 Mar 2021 10:41:55 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Sat, 6 Mar 2021
 10:44:00 +0800
To:     <colyli@suse.de>, <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        lihaotian <lihaotian9@huawei.com>, <kent.overstreet@gmail.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] bcache: reduce redundant code in bch_cached_dev_run()
Message-ID: <84551e06-0a99-218f-a3b7-2694e1804d6e@huawei.com>
Date:   Sat, 6 Mar 2021 10:43:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


In bch_cached_dev_run(), free(env[1])|free(env[2])|free(buf)
show up three times. This patch introduce out tag in
which free(env[1])|free(env[2])|free(buf) are only called
one time. If we need to call free() when errors occur,
we can set error code to ret, and then goto out tag directly.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 drivers/md/bcache/super.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 71691f32959b..1a8748050087 100644
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
2.19.1


