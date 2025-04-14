Return-Path: <linux-bcache+bounces-874-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCF8A8758A
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 03:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DAD4188C8DA
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Apr 2025 01:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 124DA1BC9F4;
	Mon, 14 Apr 2025 01:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CrSg4cpx"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D352A1A8F8A
	for <linux-bcache@vger.kernel.org>; Mon, 14 Apr 2025 01:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744595171; cv=none; b=X/YcA4962s734T+etcxDL2FubXVjs60FeWX2sWw8my2XWDcBHjyBIXv1GnAgK7Zs35v6H/Rzw2bqnlcdl3rKqLkrhUL92jTLLcPmNBZMV9KSr0pYEFKEQuDEs/d0mdJ6HTDLs9ic4TqykkiupkIyUkhN3Gp6Y5o1cfc8H5VFGqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744595171; c=relaxed/simple;
	bh=Ij+nQA+8RujoN7hiZEYeXEqqlyqHInUV/AL/W+TxWEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sj7J7pr1bykZeTHH5LzQdT40hcQdOFhQmH8rr8HNCoF+mR6HT4jondvaZepjUucK51w7nPY8xNDoAuBg8/aQsLqfUADzEpOa6/YelDzdKhL4bZY7sTuIOztiuoB3gAkDDT47vhNPZyp7NGHRcdS6DyEqmpQCzkyLvzHCIa766q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CrSg4cpx; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744595166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+lfN/jDmhx15H28wr+ZCKCFpi48AsJfaRSyB2d11d8=;
	b=CrSg4cpxZSZYNp3SKC0g7z3kvxtNwWAKZ4IXaWkyVsxL5lAyyB/oOPPMb8QXm3LwC25IaO
	8vGMpwW1mUD7/JTeBoo1hA43ON+W8hon9qzTaEDJiYpADcImlDoKPWIGBXRpFLaYJ4WWgB
	7caFwl1Dpqv+7dP+fZH5P7DhMCIe9ts=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: axboe@kernel.dk,
	hch@lst.de,
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
	nvdimm@lists.linux.dev,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [RFC PATCH 11/11] block: introduce pcache (persistent memory to be cache for block device)
Date: Mon, 14 Apr 2025 01:45:05 +0000
Message-Id: <20250414014505.20477-12-dongsheng.yang@linux.dev>
In-Reply-To: <20250414014505.20477-1-dongsheng.yang@linux.dev>
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This patch introduces the initial integration of `pcache`, a Linux kernel
block layer module that leverages persistent memory (PMem) as a high-performance
caching layer for traditional block devices (e.g., SSDs, HDDs).

- Persistent Memory as Cache:
   - `pcache` uses DAX-enabled persistent memory (e.g., `/dev/pmemX`) to provide
     fast, byte-addressable, non-volatile caching for block devices.
   - Supports both direct-mapped and vmap-based access depending on DAX capabilities.

- Modular Architecture:
   - `cache_dev`: represents a persistent memory device used as a cache.
   - `backing_dev`: represents an individual block device being cached.
   - `logic_dev`: exposes a block device (`/dev/pcacheX`) to userspace, serving as
     the frontend interface for I/O.
   - `cache`: implements core caching logic (hit/miss, writeback, GC, etc.).

Design Motivation:

`pcache` is designed to bridge the performance gap between slow-but-large storage
(HDDs, SATA/NVMe SSDs) and emerging byte-addressable persistent memory.
Compared to traditional block layer caching, `pcache` is persistent, low-latency, highly concurrent,
and more amenable to modern storage-class memory devices than legacy caching designs.

This patch finalizes the series by wiring up the initialization entry point
(`pcache_init()`), sysfs bus registration, root device handling, and Kconfig glue.

With this, the `pcache` subsystem is ready to load as a kernel module and serve
as a cache engine for block I/O.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 MAINTAINERS                   |   8 ++
 drivers/block/Kconfig         |   2 +
 drivers/block/Makefile        |   2 +
 drivers/block/pcache/Kconfig  |  16 +++
 drivers/block/pcache/Makefile |   4 +
 drivers/block/pcache/main.c   | 194 ++++++++++++++++++++++++++++++++++
 6 files changed, 226 insertions(+)
 create mode 100644 drivers/block/pcache/Kconfig
 create mode 100644 drivers/block/pcache/Makefile
 create mode 100644 drivers/block/pcache/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 00e94bec401e..5ee5879072b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18026,6 +18026,14 @@ S:	Maintained
 F:	drivers/leds/leds-pca9532.c
 F:	include/linux/leds-pca9532.h
 
+PCACHE (Pmem as cache for block device)
+M:	Dongsheng Yang <dongsheng.yang@linux.dev>
+M:	Zheng Gu <cengku@gmail.com>
+R:	Linggang Zeng <linggang.linux@gmail.com>
+L:	linux-block@vger.kernel.org
+S:	Maintained
+F:	drivers/block/pcache/
+
 PCI DRIVER FOR AARDVARK (Marvell Armada 3700)
 M:	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
 M:	Pali Rohár <pali@kernel.org>
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a97f2c40c640..27731dbed7f6 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -192,6 +192,8 @@ config BLK_DEV_LOOP_MIN_COUNT
 
 source "drivers/block/drbd/Kconfig"
 
+source "drivers/block/pcache/Kconfig"
+
 config BLK_DEV_NBD
 	tristate "Network block device support"
 	depends on NET
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 1105a2d4fdcb..40b96ccbd414 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -43,3 +43,5 @@ obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 obj-$(CONFIG_BLK_DEV_UBLK)			+= ublk_drv.o
 
 swim_mod-y	:= swim.o swim_asm.o
+
+obj-$(CONFIG_BLK_DEV_PCACHE)	+= pcache/
diff --git a/drivers/block/pcache/Kconfig b/drivers/block/pcache/Kconfig
new file mode 100644
index 000000000000..2dc77354a4b1
--- /dev/null
+++ b/drivers/block/pcache/Kconfig
@@ -0,0 +1,16 @@
+config BLK_DEV_PCACHE
+	tristate "Persistent memory for cache of Block Device (Experimental)"
+	depends on DEV_DAX && FS_DAX
+	help
+	  PCACHE provides a mechanism to use persistent memory (e.g., CXL persistent memory,
+	  DAX-enabled devices) as a high-performance cache layer in front of
+	  traditional block devices such as SSDs or HDDs.
+
+	  PCACHE is implemented as a kernel module that integrates with the block
+	  layer and supports direct access (DAX) to persistent memory for low-latency,
+	  byte-addressable caching.
+
+	  Note: This feature is experimental and should be tested thoroughly
+	  before use in production environments.
+
+	  If unsure, say 'N'.
diff --git a/drivers/block/pcache/Makefile b/drivers/block/pcache/Makefile
new file mode 100644
index 000000000000..0e7316ae20e1
--- /dev/null
+++ b/drivers/block/pcache/Makefile
@@ -0,0 +1,4 @@
+pcache-y := main.o cache_dev.o backing_dev.o segment.o meta_segment.o logic_dev.o cache.o cache_segment.o cache_key.o cache_req.o cache_writeback.o cache_gc.o
+
+obj-$(CONFIG_BLK_DEV_PCACHE) += pcache.o
+
diff --git a/drivers/block/pcache/main.c b/drivers/block/pcache/main.c
new file mode 100644
index 000000000000..d0430c64aff3
--- /dev/null
+++ b/drivers/block/pcache/main.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright(C) 2025, Dongsheng Yang <dongsheng.yang@linux.dev>
+ */
+
+#include <linux/capability.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/parser.h>
+
+#include "pcache_internal.h"
+#include "cache_dev.h"
+#include "logic_dev.h"
+
+enum {
+	PCACHE_REG_OPT_ERR		= 0,
+	PCACHE_REG_OPT_FORCE,
+	PCACHE_REG_OPT_FORMAT,
+	PCACHE_REG_OPT_PATH,
+};
+
+static const match_table_t register_opt_tokens = {
+	{ PCACHE_REG_OPT_FORCE,		"force=%u" },
+	{ PCACHE_REG_OPT_FORMAT,	"format=%u" },
+	{ PCACHE_REG_OPT_PATH,		"path=%s" },
+	{ PCACHE_REG_OPT_ERR,		NULL	}
+};
+
+static int parse_register_options(char *buf,
+		struct pcache_cache_dev_register_options *opts)
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
+		case PCACHE_REG_OPT_PATH:
+			if (match_strlcpy(opts->path, &args[0],
+				PCACHE_PATH_LEN) == 0) {
+				ret = -EINVAL;
+				break;
+			}
+			break;
+		case PCACHE_REG_OPT_FORCE:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->force = (token != 0);
+			break;
+		case PCACHE_REG_OPT_FORMAT:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->format = (token != 0);
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
+static ssize_t cache_dev_unregister_store(const struct bus_type *bus, const char *ubuf,
+				      size_t size)
+{
+	u32 cache_dev_id;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (sscanf(ubuf, "cache_dev_id=%u", &cache_dev_id) != 1)
+		return -EINVAL;
+
+	ret = cache_dev_unregister(cache_dev_id);
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+static ssize_t cache_dev_register_store(const struct bus_type *bus, const char *ubuf,
+				      size_t size)
+{
+	struct pcache_cache_dev_register_options opts = { 0 };
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
+	ret = cache_dev_register(&opts);
+	if (ret < 0)
+		return ret;
+
+	return size;
+}
+
+static BUS_ATTR_WO(cache_dev_unregister);
+static BUS_ATTR_WO(cache_dev_register);
+
+static struct attribute *pcache_bus_attrs[] = {
+	&bus_attr_cache_dev_unregister.attr,
+	&bus_attr_cache_dev_register.attr,
+	NULL,
+};
+
+static const struct attribute_group pcache_bus_group = {
+	.attrs = pcache_bus_attrs,
+};
+__ATTRIBUTE_GROUPS(pcache_bus);
+
+const struct bus_type pcache_bus_type = {
+	.name		= "pcache",
+	.bus_groups	= pcache_bus_groups,
+};
+
+static void pcache_root_dev_release(struct device *dev)
+{
+}
+
+struct device pcache_root_dev = {
+	.init_name =    "pcache",
+	.release =      pcache_root_dev_release,
+};
+
+static int __init pcache_init(void)
+{
+	int ret;
+
+	ret = device_register(&pcache_root_dev);
+	if (ret < 0) {
+		put_device(&pcache_root_dev);
+		goto err;
+	}
+
+	ret = bus_register(&pcache_bus_type);
+	if (ret < 0)
+		goto device_unregister;
+
+	ret = pcache_blkdev_init();
+	if (ret < 0)
+		goto bus_unregister;
+
+	return 0;
+
+bus_unregister:
+	bus_unregister(&pcache_bus_type);
+device_unregister:
+	device_unregister(&pcache_root_dev);
+err:
+
+	return ret;
+}
+
+static void pcache_exit(void)
+{
+	pcache_blkdev_exit();
+	bus_unregister(&pcache_bus_type);
+	device_unregister(&pcache_root_dev);
+}
+
+MODULE_AUTHOR("Dongsheng Yang <dongsheng.yang@linux.dev>");
+MODULE_DESCRIPTION("PMem for Cache of block device");
+MODULE_LICENSE("GPL v2");
+module_init(pcache_init);
+module_exit(pcache_exit);
-- 
2.34.1


