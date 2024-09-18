Return-Path: <linux-bcache+bounces-726-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7E197BAC2
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4562D1F285D1
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473AB189F41;
	Wed, 18 Sep 2024 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CeDgi91S"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFC3189BAC
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654764; cv=none; b=KlwDBDq0GgKfRuAdhfRZSoiszjKk8Xrf/rNKzXmrEod1fYTbP8CN6XIof6FPZVhoek4L6l2LiLSCvu7ku5T3ufYI4Ineikg3tphVbf/+HVddkYnv/zy7D2CwDoSenEbnrSVGS9oL5kLd3Ncl9ELEtI62QIAyPJvyZWtkwLnIGks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654764; c=relaxed/simple;
	bh=VLXexvB5xOFks2PgsfgM+N0lQgH8W4ID6OXaYy2fUrI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kGX3w+uLA7UxW9M+zzoLnxSk6PQ+IKcy417wn6UaYyKBJb+gjc4/Q63F8qKD67nGe04WduqSBphlIXmLuEJ/LmTcBlU0/uTrJpT6SNogKbSceLElqFis1CY+uXhFc1JDV0tqdfib3cOraS1gyRstxmDccjsWDWtoAOJ4nB63tjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CeDgi91S; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cbUtm5WprPjz08SnW/Ys9oOg4o7q9TuKMEC1OuMigdk=;
	b=CeDgi91SrzcSP22d5q5fM6DkAwgWSE9IivmIKe2TK/e0ksM9JFecn1U8JxIPBNBNqBzu92
	5vjOAWKyGK4ZPLZRhwcf3UytLdQGtnQV5nR/UanP2KvrKATqjDIsAxRVKz16oN/h+vH2z8
	ucqWxoxI3RgOMSnV3u0xdorsUDxu+L0=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	dan.j.williams@intel.com,
	gregory.price@memverge.com,
	John@groves.net,
	Jonathan.Cameron@Huawei.com,
	bbhushan2@marvell.com,
	chaitanyak@nvidia.com,
	rdunlap@infradead.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH v2 8/8] block: Init for CBD(CXL Block Device) module
Date: Wed, 18 Sep 2024 10:18:21 +0000
Message-Id: <20240918101821.681118-9-dongsheng.yang@linux.dev>
In-Reply-To: <20240918101821.681118-1-dongsheng.yang@linux.dev>
References: <20240918101821.681118-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

CBD (CXL Block Device) provides two usage scenarios: single-host and
multi-hosts.

(1) Single-host scenario, CBD can use a pmem device as a cache for block
devices, providing a caching mechanism specifically designed for
persistent memory.

+-----------------------------------------------------------------+
|                         single-host                             |
+-----------------------------------------------------------------+
|                                                                 |
|                                                                 |
|                                                                 |
|                                                                 |
|                                                                 |
|                        +-----------+     +------------+         |
|                        | /dev/cbd0 |     | /dev/cbd1  |         |
|                        |           |     |            |         |
|  +---------------------|-----------|-----|------------|-------+ |
|  |                     |           |     |            |       | |
|  |      /dev/pmem0     | cbd0 cache|     | cbd1 cache |       | |
|  |                     |           |     |            |       | |
|  +---------------------|-----------|-----|------------|-------+ |
|                        |+---------+|     |+----------+|         |
|                        ||/dev/sda ||     || /dev/sdb ||         |
|                        |+---------+|     |+----------+|         |
|                        +-----------+     +------------+         |
+-----------------------------------------------------------------+

(2) Multi-hosts scenario, CBD also provides a cache while taking
advantage of shared memory features, allowing users to access block
devices on other nodes across different hosts.

As shared memory is supported in CXL3.0 spec, we can transfer data via
CXL shared memory. CBD use CXL shared memory to transfer data between
node-1 and node-2.

This scenario require your shared memory device support Hardware-consistency
as CXL 3.0 described, and CONFIG_CBD_MULTIHOST to be enabled.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/Kconfig        |   2 +
 drivers/block/Makefile       |   2 +
 drivers/block/cbd/Kconfig    |  45 +++++++
 drivers/block/cbd/Makefile   |   3 +
 drivers/block/cbd/cbd_main.c | 224 +++++++++++++++++++++++++++++++++++
 5 files changed, 276 insertions(+)
 create mode 100644 drivers/block/cbd/Kconfig
 create mode 100644 drivers/block/cbd/Makefile
 create mode 100644 drivers/block/cbd/cbd_main.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 5b9d4aaebb81..1f6376828af9 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -219,6 +219,8 @@ config BLK_DEV_NBD
 
 	  If unsure, say N.
 
+source "drivers/block/cbd/Kconfig"
+
 config BLK_DEV_RAM
 	tristate "RAM block device support"
 	help
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 101612cba303..8be2a39f5a7c 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -39,4 +39,6 @@ obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
 obj-$(CONFIG_BLK_DEV_UBLK)			+= ublk_drv.o
 
+obj-$(CONFIG_BLK_DEV_CBD)	+= cbd/
+
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/cbd/Kconfig b/drivers/block/cbd/Kconfig
new file mode 100644
index 000000000000..16ffcca058c5
--- /dev/null
+++ b/drivers/block/cbd/Kconfig
@@ -0,0 +1,45 @@
+config BLK_DEV_CBD
+	tristate "CXL Block Device (Experimental)"
+	depends on DEV_DAX && FS_DAX
+	help
+	  CBD allows you to register a persistent memory device as a CBD transport.
+	  You can use this persistent memory as a data cache to improve your block
+	  device performance. Additionally, if you enable CBD_MULTIHOST, cbd allows
+	  you to access block devices on a remote host as if they were local disks.
+
+	  Select 'y' to build this module directly into the kernel.
+	  Select 'm' to build this module as a loadable kernel module.
+
+	  If unsure say 'N'.
+
+config CBD_CRC
+	bool "Enable CBD checksum"
+	default N
+	depends on BLK_DEV_CBD
+	help
+	  When CBD_CRC is enabled, all data sent by CBD will include
+	  a checksum. This includes a data checksum, a submit entry checksum,
+	  and a completion entry checksum. This ensures the integrity of the
+	  data transmitted through the CXL memory device.
+
+config CBD_DEBUG
+	bool "Enable CBD debug"
+	default N
+	depends on BLK_DEV_CBD
+	help
+	  When CBD_DEBUG is enabled, cbd module will print more messages
+	  for debugging. But that will affact performance, so do not use it
+	  in production case.
+
+config CBD_MULTIHOST
+	bool "multi-hosts CXL Dlock Device"
+	default N
+	depends on BLK_DEV_CBD
+	help
+	  When CBD_MULTIHOST is enabled, cbd allows the use of a shared memory device
+	  as a cbd transport. In this mode, the blkdev and backends on different
+	  hosts can be connected through the shared memory device, enabling cross-node
+	  disk access.
+
+	  IMPORTANT: This Require your shared memory device support Hardware-consistency
+	  as CXL 3.0 described.
diff --git a/drivers/block/cbd/Makefile b/drivers/block/cbd/Makefile
new file mode 100644
index 000000000000..ee61f7e2b978
--- /dev/null
+++ b/drivers/block/cbd/Makefile
@@ -0,0 +1,3 @@
+cbd-y := cbd_main.o cbd_transport.o cbd_channel.o cbd_host.o cbd_backend.o cbd_handler.o cbd_blkdev.o cbd_queue.o cbd_segment.o cbd_cache.o
+
+obj-$(CONFIG_BLK_DEV_CBD) += cbd.o
diff --git a/drivers/block/cbd/cbd_main.c b/drivers/block/cbd/cbd_main.c
new file mode 100644
index 000000000000..066596ca9b82
--- /dev/null
+++ b/drivers/block/cbd/cbd_main.c
@@ -0,0 +1,224 @@
+/*
+ * Copyright(C) 2024, Dongsheng Yang <dongsheng.yang@linux.dev>
+ */
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/blk-mq.h>
+#include <linux/blkdev.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/bio.h>
+#include <linux/module.h>
+#include <linux/blk-mq.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <net/genetlink.h>
+
+#include <linux/types.h>
+
+#include "cbd_internal.h"
+
+struct workqueue_struct	*cbd_wq;
+
+enum {
+	CBDT_REG_OPT_ERR		= 0,
+	CBDT_REG_OPT_FORCE,
+	CBDT_REG_OPT_FORMAT,
+	CBDT_REG_OPT_PATH,
+	CBDT_REG_OPT_HOSTNAME,
+};
+
+static const match_table_t register_opt_tokens = {
+	{ CBDT_REG_OPT_FORCE,		"force=%u" },
+	{ CBDT_REG_OPT_FORMAT,		"format=%u" },
+	{ CBDT_REG_OPT_PATH,		"path=%s" },
+	{ CBDT_REG_OPT_HOSTNAME,	"hostname=%s" },
+	{ CBDT_REG_OPT_ERR,		NULL	}
+};
+
+static int parse_register_options(
+		char *buf,
+		struct cbdt_register_options *opts)
+{
+	substring_t args[MAX_OPT_ARGS];
+	char *o, *p;
+	int token, ret = 0;
+
+	o = buf;
+
+	while ((p = strsep(&o, ",\n")) != NULL) {
+		if (!*p)
+			continue;
+
+		token = match_token(p, register_opt_tokens, args);
+		switch (token) {
+		case CBDT_REG_OPT_PATH:
+			if (match_strlcpy(opts->path, &args[0],
+				CBD_PATH_LEN) == 0) {
+				ret = -EINVAL;
+				break;
+			}
+			break;
+		case CBDT_REG_OPT_FORCE:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->force = (token != 0);
+			break;
+		case CBDT_REG_OPT_FORMAT:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->format = (token != 0);
+			break;
+		case CBDT_REG_OPT_HOSTNAME:
+			if (match_strlcpy(opts->hostname, &args[0],
+				CBD_NAME_LEN) == 0) {
+				ret = -EINVAL;
+				break;
+			}
+			break;
+		default:
+			pr_err("unknown parameter or missing value '%s'\n", p);
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+static ssize_t transport_unregister_store(const struct bus_type *bus, const char *ubuf,
+				      size_t size)
+{
+	u32 transport_id;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (sscanf(ubuf, "transport_id=%u", &transport_id) != 1)
+		return -EINVAL;
+
+	ret = cbdt_unregister(transport_id);
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+static ssize_t transport_register_store(const struct bus_type *bus, const char *ubuf,
+				      size_t size)
+{
+	struct cbdt_register_options opts = { 0 };
+	char *buf;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	buf = kmemdup(ubuf, size + 1, GFP_KERNEL);
+	if (IS_ERR(buf)) {
+		pr_err("failed to dup buf for adm option: %d", (int)PTR_ERR(buf));
+		return PTR_ERR(buf);
+	}
+	buf[size] = '\0';
+
+	ret = parse_register_options(buf, &opts);
+	if (ret < 0) {
+		kfree(buf);
+		return ret;
+	}
+	kfree(buf);
+
+	ret = cbdt_register(&opts);
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+static BUS_ATTR_WO(transport_unregister);
+static BUS_ATTR_WO(transport_register);
+
+static struct attribute *cbd_bus_attrs[] = {
+	&bus_attr_transport_unregister.attr,
+	&bus_attr_transport_register.attr,
+	NULL,
+};
+
+static const struct attribute_group cbd_bus_group = {
+	.attrs = cbd_bus_attrs,
+};
+__ATTRIBUTE_GROUPS(cbd_bus);
+
+const struct bus_type cbd_bus_type = {
+	.name		= "cbd",
+	.bus_groups	= cbd_bus_groups,
+};
+
+static void cbd_root_dev_release(struct device *dev)
+{
+}
+
+struct device cbd_root_dev = {
+	.init_name =    "cbd",
+	.release =      cbd_root_dev_release,
+};
+
+static int __init cbd_init(void)
+{
+	int ret;
+
+	cbd_wq = alloc_workqueue(CBD_DRV_NAME, WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!cbd_wq)
+		return -ENOMEM;
+
+	ret = device_register(&cbd_root_dev);
+	if (ret < 0) {
+		put_device(&cbd_root_dev);
+		goto destroy_wq;
+	}
+
+	ret = bus_register(&cbd_bus_type);
+	if (ret < 0)
+		goto device_unregister;
+
+	ret = cbd_blkdev_init();
+	if (ret < 0)
+		goto bus_unregister;
+
+	return 0;
+
+bus_unregister:
+	bus_unregister(&cbd_bus_type);
+device_unregister:
+	device_unregister(&cbd_root_dev);
+destroy_wq:
+	destroy_workqueue(cbd_wq);
+
+	return ret;
+}
+
+static void cbd_exit(void)
+{
+	cbd_blkdev_exit();
+	bus_unregister(&cbd_bus_type);
+	device_unregister(&cbd_root_dev);
+
+	destroy_workqueue(cbd_wq);
+}
+
+MODULE_AUTHOR("Dongsheng Yang <dongsheng.yang@linux.dev>");
+MODULE_DESCRIPTION("CXL(Compute Express Link) Block Device");
+MODULE_LICENSE("GPL v2");
+module_init(cbd_init);
+module_exit(cbd_exit);
-- 
2.34.1


