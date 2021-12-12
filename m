Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF0471BCE
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhLLRGw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:52 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39828 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhLLRGw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:52 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 721471F3B9;
        Sun, 12 Dec 2021 17:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LP6/XLbv7kTkGWGEx8tzk0T4zs+C9KDWlqh2LgilVvU=;
        b=TSVr0MdITeXMwVSXVMmA5mygJlCClSvo6Q/F/M0b2V/HA7AVatxeRaQsCtywi8TwYb1+Ru
        0yQaB1iLDQDouPPRi1aL0tMwMaIgqs/A3qZTIR9J904ndxwTjQjCXMOSmUTfoFSOv/tjk+
        qqZkuzfCSmwjMDJExvPDMM0jNpr9CDg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328811;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LP6/XLbv7kTkGWGEx8tzk0T4zs+C9KDWlqh2LgilVvU=;
        b=FM0IoSUlvmGR4jxZJrnwo03yg1CN6I/EXeO/S9//OmCiPx7eTtCl5CQKxi2QrkMhPnqOFT
        pwkj5i4pv9bXcsAA==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 18969A3B88;
        Sun, 12 Dec 2021 17:06:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v13 12/12] bcache: add sysfs interface register_nvdimm_meta to register NVDIMM meta device
Date:   Mon, 13 Dec 2021 01:05:52 +0800
Message-Id: <20211212170552.2812-13-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/super.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 45b69ddc9cfa..2b9cde44879b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2405,10 +2405,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2522,6 +2530,24 @@ static void register_device_async(struct async_reg_args *args)
 	queue_delayed_work(system_wq, &args->reg_work, 10);
 }
 
+#if defined(CONFIG_BCACHE_NVM_PAGES)
+static ssize_t register_nvdimm_meta(struct kobject *k, struct kobj_attribute *attr,
+				    const char *buffer, size_t size)
+{
+	ssize_t ret = size;
+
+	struct bch_nvmpg_ns *ns = bch_register_namespace(buffer);
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
@@ -2864,6 +2890,9 @@ static int __init bcache_init(void)
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
2.31.1

