Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB07D315EC3
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhBJFJ4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:40752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231128AbhBJFJr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7E1AB0D1;
        Wed, 10 Feb 2021 05:08:38 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 19/20] bcache: add sysfs interface register_nvdimm_meta to register NVDIMM meta device
Date:   Wed, 10 Feb 2021 13:07:41 +0800
Message-Id: <20210210050742.31237-20-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds a sysfs interface register_nvdimm_meta to register
NVDIMM meta device. The sysfs interface file only shows up when
CONFIG_BCACHE_NVM_PAGES=y. Then a NVDIMM name space formatted by
bcache-tools can be registered into bcache by e.g.,
  echo /dev/pmem0 > /sys/fs/bcache/register_nvdimm_meta

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/super.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 57c96c16ee16..61fd5802a627 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2415,10 +2415,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 					 struct kobj_attribute *attr,
 					 const char *buffer, size_t size);
+#ifdef CONFIG_BCACHE_NVM_PAGES
+static ssize_t register_nvdimm_meta(struct kobject *k,
+				    struct kobj_attribute *attr,
+				    const char *buffer, size_t size);
+#endif
 
 kobj_attribute_write(register,		register_bcache);
 kobj_attribute_write(register_quiet,	register_bcache);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
+#ifdef CONFIG_BCACHE_NVM_PAGES
+kobj_attribute_write(register_nvdimm_meta, register_nvdimm_meta);
+#endif
 
 static bool bch_is_open_backing(dev_t dev)
 {
@@ -2532,6 +2540,24 @@ static void register_device_async(struct async_reg_args *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
 
+#ifdef CONFIG_BCACHE_NVM_PAGES
+static ssize_t register_nvdimm_meta(struct kobject *k, struct kobj_attribute *attr,
+				    const char *buffer, size_t size)
+{
+	ssize_t ret = size;
+
+	struct bch_nvm_namespace *ns = bch_register_namespace(buffer);
+
+	if (IS_ERR(ns)) {
+		pr_err("register nvdimm namespace %s for meta device failed.\n",
+			buffer);
+		ret = -EINVAL;
+	}
+
+	return size;
+}
+#endif
+
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
@@ -2867,6 +2893,9 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
+#ifdef CONFIG_BCACHE_NVM_PAGES
+		&ksysfs_register_nvdimm_meta.attr,
+#endif
 		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
-- 
2.26.2

