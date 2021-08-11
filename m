Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DCE3E9686
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhHKRFr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:05:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58684 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhHKRFr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:05:47 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A3A4E20195;
        Wed, 11 Aug 2021 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efsOw98AEBFshxhhH9/n3GRQdv2ksVkqaTCb57JSsqU=;
        b=FRR4OFK3s6fk7teQ4WATZ3QEJHo5och1ZjfgFXygxnp8Rc/ube6zMpRQGu2Go5USA+MmjH
        Utk0j9944xnayK9aiIeVUCxOLL1RHlsbT8KKcuJ1jdIazbWH4LiMgfw+Q8EV4uq45Z2KdZ
        S3K9brjiqqkxdvENy5sG7fkVDCve07Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701521;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=efsOw98AEBFshxhhH9/n3GRQdv2ksVkqaTCb57JSsqU=;
        b=tZa4CLdOvovYtOXexaq9cWlVntxJgOGmy71E79JNPrcVmpTagz5+uNMhYuXlOlJ+eej4Ta
        LVmrvUAu1ZQY9xBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 9AC0AA3D61;
        Wed, 11 Aug 2021 17:05:16 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v12 12/12] bcache: add sysfs interface register_nvdimm_meta to register NVDIMM meta device
Date:   Thu, 12 Aug 2021 01:02:24 +0800
Message-Id: <20210811170224.42837-13-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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
index 24734250d005..434739594baf 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2403,10 +2403,18 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2520,6 +2528,24 @@ static void register_device_async(struct async_reg_args *args)
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
@@ -2855,6 +2881,9 @@ static int __init bcache_init(void)
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

