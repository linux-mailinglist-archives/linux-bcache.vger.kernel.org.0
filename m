Return-Path: <linux-bcache+bounces-836-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 22413A03C77
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A07A160D05
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 804EA1EE7DA;
	Tue,  7 Jan 2025 10:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XcQFUZ/h"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301471EBFEB
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245908; cv=none; b=b381QsSRl5zjbyU06Xvqa1Tl3FI9ZW+d+0YzV7rlzZ1CloSFd92VYcxfwXG8+U5PwrTmuSFTvnuF0DQzbBYltTp4O30zGvRm7yrqHvtPlyqELbtfkIv9pA7w6iWkTy74HnKHikmayWrN9cnSphCbraGfoY90tH5N87LDNxtq3R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245908; c=relaxed/simple;
	bh=18XVdKsOBkJz2/pT4zU2r10WgwIc7yTToepo8R6d7iQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NU5ZCN3rTlgmRhvw6R2DeRklMQBgDCLy7ScvyAfRSroVX366B70i0Hx16ubW8ipr+npDuFySG9W9Uysf+YvWzfDkmb/jfTB2slKiQNy5XY73Bmolmw1o9cco7/PmPdE//iHXUGsdByd7t2xXwvXcvWxiIec2Oo0qklbaOqq2tkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XcQFUZ/h; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi9WsBBML0UJPwzRgYAfQ6+/QyzWCMV5t0rXx+a3Cc8=;
	b=XcQFUZ/hPEGoARiTHdcd61LQfjN31v6oSHnfDPdblnAX9lYUyaNt9vinFTebLOaNQfspIU
	Ng00887niSFwYWuHmG3HU0zfrBeAIA4H5ovhH4IZrfrXzA/gIqnhx89rtfUkm1unGAwpPj
	X6ujT1CrEAUj4krlFo814f7F37et0NI=
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
Subject: [PATCH v3 8/8] block: Init for CBD(CXL Block Device)
Date: Tue,  7 Jan 2025 10:30:24 +0000
Message-Id: <20250107103024.326986-9-dongsheng.yang@linux.dev>
In-Reply-To: <20250107103024.326986-1-dongsheng.yang@linux.dev>
References: <20250107103024.326986-1-dongsheng.yang@linux.dev>
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
 MAINTAINERS                  |   7 ++
 drivers/block/Kconfig        |   2 +
 drivers/block/Makefile       |   2 +
 drivers/block/cbd/Kconfig    |  89 ++++++++++++++
 drivers/block/cbd/Makefile   |  14 +++
 drivers/block/cbd/cbd_main.c | 230 +++++++++++++++++++++++++++++++++++
 6 files changed, 344 insertions(+)
 create mode 100644 drivers/block/cbd/Kconfig
 create mode 100644 drivers/block/cbd/Makefile
 create mode 100644 drivers/block/cbd/cbd_main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 910305c11e8a..a8728304cca1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5198,6 +5198,13 @@ S:	Odd Fixes
 F:	Documentation/devicetree/bindings/arm/cavium-thunder2.txt
 F:	arch/arm64/boot/dts/cavium/thunder2-99xx*
 
+CBD (CXL Block Device)
+M:	Dongsheng Yang <dongsheng.yang@linux.dev>
+R:	Gu Zheng <cengku@gmail.com>
+L:	linux-block@vger.kernel.org
+S:	Maintained
+F:	drivers/block/cbd/
+
 CBS/ETF/TAPRIO QDISCS
 M:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
 L:	netdev@vger.kernel.org
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index a97f2c40c640..62e18d5d62e2 100644
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
index 1105a2d4fdcb..617d2f97c88a 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -42,4 +42,6 @@ obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
 obj-$(CONFIG_BLK_DEV_UBLK)			+= ublk_drv.o
 
+obj-$(CONFIG_BLK_DEV_CBD)	+= cbd/
+
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/cbd/Kconfig b/drivers/block/cbd/Kconfig
new file mode 100644
index 000000000000..f7987e7afdf0
--- /dev/null
+++ b/drivers/block/cbd/Kconfig
@@ -0,0 +1,89 @@
+config BLK_DEV_CBD
+	tristate "CXL Block Device (Experimental)"
+	depends on DEV_DAX && FS_DAX
+	help
+	  CBD (CXL Block Device) provides a mechanism to register a persistent
+	  memory device as a transport layer for block devices. By leveraging CBD,
+	  you can use persistent memory as a high-speed data cache, significantly
+	  enhancing the performance of block storage devices by reducing latency
+	  for frequent data access.
+
+	  When CBD_MULTIHOST is enabled, the module extends functionality to
+	  support shared access to block devices across multiple hosts. This
+	  enables you to access and manage block devices located on remote hosts
+	  as though they are local disks, a feature valuable in distributed
+	  environments where data accessibility and performance are critical.
+
+	  Usage options:
+	  - Select 'y' to build the CBD module directly into the kernel, making
+	    it immediately available at boot.
+	  - Select 'm' to build it as a loadable kernel module. The module will
+	    be called "cbd" and can be loaded or unloaded as needed.
+
+	  Note: This feature is experimental and should be tested thoroughly
+	  before use in production environments.
+
+	  If unsure, say 'N'.
+
+config CBD_CHANNEL_CRC
+	bool "Enable CBD channel checksum"
+	default n
+	depends on BLK_DEV_CBD
+	help
+	  Enabling CBD_CHANNEL_CRC adds a checksum (CRC) to control elements within
+	  the CBD transport, specifically in `cbd_se` (submit entry) and `cbd_ce`
+	  (completion entry) structures. This checksum is used to validate the
+	  integrity of `cbd_se` and `cbd_ce` control structures themselves, ensuring
+	  they remain uncorrupted during transmission. However, the CRC added by
+	  this option does not cover the actual data content associated with these
+	  entries.
+
+	  For complete data integrity, including the content managed by `cbd_se`
+	  and `cbd_ce`, consider enabling CBD_CHANNEL_DATA_CRC.
+
+config CBD_CHANNEL_DATA_CRC
+	bool "Enable CBD channel data checksum"
+	default n
+	depends on BLK_DEV_CBD
+	help
+	  Enabling CBD_CHANNEL_DATA_CRC adds an additional data-specific CRC
+	  within both the `cbd_se` and `cbd_ce` structures, dedicated to verifying
+	  the integrity of the actual data content transmitted alongside the entries.
+	  When both CBD_CHANNEL_CRC and CBD_CHANNEL_DATA_CRC are enabled, each
+	  control entry (`cbd_se` and `cbd_ce`) will contain a CRC for its structure
+	  and a separate data CRC, ensuring full integrity checks on both control
+	  and data elements.
+
+config CBD_CACHE_DATA_CRC
+	bool "Enable CBD cache data checksum"
+	default n
+	depends on BLK_DEV_CBD
+	help
+	  In the CBD cache system, all cache keys are stored within a kset. Each
+	  kset inherently includes a CRC to ensure the integrity of its stored
+	  data, meaning that basic data integrity for all cache keys is enabled
+	  by default.
+
+	  Enabling CBD_CACHE_DATA_CRC, however, adds an additional CRC specifically
+	  within each `cache_key`, providing a checksum for the actual data content
+	  associated with each cache entry. This option ensures full data integrity
+	  for both cache keys and the cached data itself, offering an additional
+	  layer of protection against data corruption within the cache.
+
+config CBD_MULTIHOST
+	bool "Multi-host CXL Block Device"
+	default n
+	depends on BLK_DEV_CBD
+	help
+	  Enabling CBD_MULTIHOST allows CBD to support a multi-host environment,
+	  where a shared memory device serves as a CBD transport across multiple
+	  hosts. In this configuration, block devices (blkdev) and backends can
+	  be accessed and managed across nodes, allowing for cross-host disk
+	  access through a shared memory interface.
+
+	  This mode is particularly useful in distributed storage setups where
+	  multiple hosts need concurrent, high-speed access to the same storage
+	  resources.
+
+	  IMPORTANT: This Require your shared memory device support Hardware-consistency
+	  as described in CXL 3.0.
diff --git a/drivers/block/cbd/Makefile b/drivers/block/cbd/Makefile
new file mode 100644
index 000000000000..7069fd57b1ce
--- /dev/null
+++ b/drivers/block/cbd/Makefile
@@ -0,0 +1,14 @@
+CBD_CACHE_DIR := cbd_cache/
+
+cbd-y := cbd_main.o cbd_transport.o cbd_channel.o cbd_host.o \
+         cbd_backend.o cbd_handler.o cbd_blkdev.o cbd_queue.o \
+         cbd_segment.o \
+         $(CBD_CACHE_DIR)cbd_cache.o \
+         $(CBD_CACHE_DIR)cbd_cache_key.o \
+         $(CBD_CACHE_DIR)cbd_cache_segment.o \
+         $(CBD_CACHE_DIR)cbd_cache_req.o \
+         $(CBD_CACHE_DIR)cbd_cache_gc.o \
+         $(CBD_CACHE_DIR)cbd_cache_writeback.o \
+
+obj-$(CONFIG_BLK_DEV_CBD) += cbd.o
+
diff --git a/drivers/block/cbd/cbd_main.c b/drivers/block/cbd/cbd_main.c
new file mode 100644
index 000000000000..448577d8308f
--- /dev/null
+++ b/drivers/block/cbd/cbd_main.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright(C) 2024, Dongsheng Yang <dongsheng.yang@linux.dev>
+ */
+
+#include <linux/kernel.h>
+#include <linux/parser.h>
+
+#include "cbd_internal.h"
+#include "cbd_blkdev.h"
+
+struct workqueue_struct	*cbd_wq;
+
+enum {
+	CBDT_REG_OPT_ERR		= 0,
+	CBDT_REG_OPT_FORCE,
+	CBDT_REG_OPT_FORMAT,
+	CBDT_REG_OPT_PATH,
+	CBDT_REG_OPT_HOSTNAME,
+	CBDT_REG_OPT_HOSTID,
+};
+
+static const match_table_t register_opt_tokens = {
+	{ CBDT_REG_OPT_FORCE,		"force=%u" },
+	{ CBDT_REG_OPT_FORMAT,		"format=%u" },
+	{ CBDT_REG_OPT_PATH,		"path=%s" },
+	{ CBDT_REG_OPT_HOSTNAME,	"hostname=%s" },
+	{ CBDT_REG_OPT_HOSTID,		"hostid=%u" },
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
+		case CBDT_REG_OPT_HOSTID:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->host_id = token;
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
+	opts.host_id = UINT_MAX;
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
+	/*
+	 * Ensures that key structures do not exceed a single page in size,
+	 * using BUILD_BUG_ON checks to enforce this at compile-time.
+	 */
+	BUILD_BUG_ON(sizeof(struct cbd_transport_info) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(struct cbd_host_info) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(struct cbd_backend_info) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(struct cbd_blkdev_info) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(struct cbd_cache_seg_info) > PAGE_SIZE);
+	BUILD_BUG_ON(sizeof(struct cbd_channel_seg_info) > PAGE_SIZE);
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


