Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34553A76BB
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Jun 2021 07:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFOFwI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Jun 2021 01:52:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57394 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhFOFwG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:52:06 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C9BE8219C5;
        Tue, 15 Jun 2021 05:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3Np6UpmqYzZ4kH5SUJzYj4UbsK192DUNvW0ehDEFvc=;
        b=0sdVN7Hz8iMI0Vf1UUB6ZRDa1Y58PjjZ2+7kehlOoG7SmjWCDwtmagBk14T+27yIVM4wpQ
        ltLn00X3kKRnNDA4p1bYMWpTgise7tFN6HLgcYWI1ahXzk6sKlArSAXQtgMf6I/c/cxj5W
        wO29l5Fd7ldSiSQFCQudC8iMg14/uTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736201;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C3Np6UpmqYzZ4kH5SUJzYj4UbsK192DUNvW0ehDEFvc=;
        b=WZ1JcYJie3OGdDArDpcqNs6cfA64enkm+26hb8dGdbuVnLImafTmQ6V+FA5fqNXyKTw/s5
        hjuekLxXWrKuy5Ag==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0B026A3BB7;
        Tue, 15 Jun 2021 05:49:59 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 14/14] bcache: add sysfs interface register_nvdimm_meta to register NVDIMM meta device
Date:   Tue, 15 Jun 2021 13:49:21 +0800
Message-Id: <20210615054921.101421-15-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
References: <20210615054921.101421-1-colyli@suse.de>
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
index 4d6666d03aa7..9d506d053548 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2439,10 +2439,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 static ssize_t bch_pending_bdevs_cleanup(struct kobject *k,
 					 struct kobj_attribute *attr,
 					 const char *buffer, size_t size);
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+static ssize_t register_nvdimm_meta(struct kobject *k,
+				    struct kobj_attribute *attr,
+				    const char *buffer, size_t size);
+#endif
 
 kobj_attribute_write(register,		register_bcache);
 kobj_attribute_write(register_quiet,	register_bcache);
 kobj_attribute_write(pendings_cleanup,	bch_pending_bdevs_cleanup);
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+kobj_attribute_write(register_nvdimm_meta, register_nvdimm_meta);
+#endif
 
 static bool bch_is_open_backing(dev_t dev)
 {
@@ -2556,6 +2564,24 @@ static void register_device_async(struct async_reg_args *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
 
+#if defined(CONFIG_BCACHE_NVM_PAGES)
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
+	return ret;
+}
+#endif
+
 static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			       const char *buffer, size_t size)
 {
@@ -2898,6 +2924,9 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+		&ksysfs_register_nvdimm_meta.attr,
+#endif
 		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
-- 
2.26.2

