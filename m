Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE52B45DD9
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfFNNPd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:15:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:46262 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727996AbfFNNPd (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:15:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 12CA2AE07;
        Fri, 14 Jun 2019 13:15:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 25/29] bcache: add pendings_cleanup to stop pending bcache device
Date:   Fri, 14 Jun 2019 21:13:54 +0800
Message-Id: <20190614131358.2771-26-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If a bcache device is in dirty state and its cache set is not
registered, this bcache device will not appear in /dev/bcache<N>,
and there is no way to stop it or remove the bcache kernel module.

This is an as-designed behavior, but sometimes people has to reboot
whole system to release or stop the pending backing device.

This sysfs interface may remove such pending bcache devices when
write anything into the sysfs file manually.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 026e2df358c3..16ed617183f7 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2291,9 +2291,13 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size);
+static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
+					 struct kobj_attribute *attr,
+					 const char *buffer, size_t size);
 
 kobj_attribute_write(register,		register_bcache);
 kobj_attribute_write(register_quiet,	register_bcache);
+kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
 
 static bool bch_is_open_backing(struct block_device *bdev)
 {
@@ -2418,6 +2422,56 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	goto out;
 }
 
+
+struct pdev {
+	struct list_head list;
+	struct cached_dev *dc;
+};
+
+static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
+					 struct kobj_attribute *attr,
+					 const char *buffer,
+					 size_t size)
+{
+	LIST_HEAD(pending_devs);
+	ssize_t ret = size;
+	struct cached_dev *dc, *tdc;
+	struct pdev *pdev, *tpdev;
+	struct cache_set *c, *tc;
+
+	mutex_lock(&bch_register_lock);
+	list_for_each_entry_safe(dc, tdc, &uncached_devices, list) {
+		pdev = kmalloc(sizeof(struct pdev), GFP_KERNEL);
+		if (!pdev)
+			break;
+		pdev->dc = dc;
+		list_add(&pdev->list, &pending_devs);
+	}
+
+	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
+		list_for_each_entry_safe(c, tc, &bch_cache_sets, list) {
+			char *pdev_set_uuid = pdev->dc->sb.set_uuid;
+			char *set_uuid = c->sb.uuid;
+
+			if (!memcmp(pdev_set_uuid, set_uuid, 16)) {
+				list_del(&pdev->list);
+				kfree(pdev);
+				break;
+			}
+		}
+	}
+	mutex_unlock(&bch_register_lock);
+
+	list_for_each_entry_safe(pdev, tpdev, &pending_devs, list) {
+		pr_info("delete pdev %p", pdev);
+		list_del(&pdev->list);
+		bcache_device_stop(&pdev->dc->disk);
+		kfree(pdev);
+	}
+
+	return ret;
+}
+
 static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 {
 	if (code == SYS_DOWN ||
@@ -2536,6 +2590,7 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
+		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
 
-- 
2.16.4

