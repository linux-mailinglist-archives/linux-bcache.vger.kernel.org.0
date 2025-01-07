Return-Path: <linux-bcache+bounces-830-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAEB2A03C61
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 11:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB3F21886F7B
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2025 10:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5B71E573B;
	Tue,  7 Jan 2025 10:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JOLY4zWD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B95E1E9B02
	for <linux-bcache@vger.kernel.org>; Tue,  7 Jan 2025 10:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736245867; cv=none; b=gfJ/X4phfcJa1NhWhKnf1JKMu/m70iFpHuxnrNSDuBRo/OIul+BWfO01Rwi6sZzbP8BTu66XTNC2SNFje/q8R1i8QTtFyRWfRgT+71vf3t0EKY2tt+SkyFde9sf5hFpH7VItAKxClZn0SuEWEfeIg3iMv+Kl6UcPpxeULl0/O7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736245867; c=relaxed/simple;
	bh=Ogan0rk9zLkEhGV9TQjbBN8qTjyG08G1aUyyZ8opfKs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p5d1mcbI0aKDVVVtQqDZ/Avex6awI9JHjy0+mDwqMmUMmAGhqA+iVr8RhnJFX1CjQd91ACRPapvQYv/KbwEiaAPr1YOC5yw+cyvxn7nBML2ak+AhhaxcxFCiUQU60A9/WuvVHcsoUEjZqNmS5bugFmQBakmhBoANBP6ULepzuaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JOLY4zWD; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736245858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UiWyIy8kzLjoK2iDoA9tOEAZmb4l7ahHBZY+wwmOhDo=;
	b=JOLY4zWDERMqSn44Ya/jgkWsDRN0TEKEaxpVuqRCbIfP1K1zHvak7l4efsjYn0pW5fwWMh
	9x3QZb26yq4I7qASn8SbZgdGpSS1pAmrrDTG3StNnhPjJATF1v3ftKuHWVPAs0zWObLZHR
	gOJDUk43KZ6Uf9lBOT7ECTcKVpONKhs=
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
Subject: [PATCH v3 2/8] cbd: introduce cbd_host
Date: Tue,  7 Jan 2025 10:30:18 +0000
Message-Id: <20250107103024.326986-3-dongsheng.yang@linux.dev>
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

The "cbd_host" represents a host node. Each node needs to be registered
before it can use the "cbd_transport". After registration, the node's
information, such as its hostname, will be recorded in the "hosts" area
of this transport. Through this mechanism, we can know which nodes are
currently using each transport.

If a host dies without unregistering, we allow the user to clear this
host entry in the metadata.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_host.c | 227 +++++++++++++++++++++++++++++++++++
 drivers/block/cbd/cbd_host.h |  67 +++++++++++
 2 files changed, 294 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_host.c
 create mode 100644 drivers/block/cbd/cbd_host.h

diff --git a/drivers/block/cbd/cbd_host.c b/drivers/block/cbd/cbd_host.c
new file mode 100644
index 000000000000..da854ba1b747
--- /dev/null
+++ b/drivers/block/cbd/cbd_host.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "cbd_host.h"
+#include "cbd_blkdev.h"
+#include "cbd_backend.h"
+
+static ssize_t hostname_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_host_device *host_dev;
+	struct cbd_host_info *host_info;
+
+	host_dev = container_of(dev, struct cbd_host_device, dev);
+	host_info = cbdt_host_info_read(host_dev->cbdt, host_dev->id);
+	if (!host_info)
+		return 0;
+
+	if (host_info->state == CBD_HOST_STATE_NONE)
+		return 0;
+
+	return sprintf(buf, "%s\n", host_info->hostname);
+}
+static DEVICE_ATTR_ADMIN_RO(hostname);
+
+static void host_info_write(struct cbd_host *host);
+static void cbd_host_hb(struct cbd_host *host)
+{
+	host_info_write(host);
+}
+CBD_OBJ_HEARTBEAT(host);
+
+static struct attribute *cbd_host_attrs[] = {
+	&dev_attr_hostname.attr,
+	&dev_attr_alive.attr,
+	NULL
+};
+
+static struct attribute_group cbd_host_attr_group = {
+	.attrs = cbd_host_attrs,
+};
+
+static const struct attribute_group *cbd_host_attr_groups[] = {
+	&cbd_host_attr_group,
+	NULL
+};
+
+static void cbd_host_release(struct device *dev)
+{
+}
+
+const struct device_type cbd_host_type = {
+	.name		= "cbd_host",
+	.groups		= cbd_host_attr_groups,
+	.release	= cbd_host_release,
+};
+
+const struct device_type cbd_hosts_type = {
+	.name		= "cbd_hosts",
+	.release	= cbd_host_release,
+};
+
+static void host_info_write(struct cbd_host *host)
+{
+	mutex_lock(&host->info_lock);
+	host->host_info.alive_ts = ktime_get_real();
+	cbdt_host_info_write(host->cbdt, &host->host_info, sizeof(struct cbd_host_info),
+			     host->host_id);
+	mutex_unlock(&host->info_lock);
+}
+
+static int host_register_validate(struct cbd_transport *cbdt, char *hostname, u32 *host_id)
+{
+	struct cbd_host_info *host_info;
+	u32 host_id_tmp;
+	int ret;
+	u32 i;
+
+	if (cbdt->host)
+		return -EEXIST;
+
+	if (strlen(hostname) == 0) {
+		cbdt_err(cbdt, "hostname is empty\n");
+		return -EINVAL;
+	}
+
+	if (*host_id == UINT_MAX) {
+		ret = cbd_host_find_id_by_name(cbdt, hostname, host_id);
+		if (!ret)
+			goto host_id_found;
+
+		/* In single-host case, set the host_id to 0 */
+		if (cbdt_is_single_host(cbdt)) {
+			*host_id = 0;
+		} else {
+			ret = cbdt_get_empty_host_id(cbdt, host_id);
+			if (ret) {
+				cbdt_err(cbdt, "no available host id found.\n");
+				return -EBUSY;
+			}
+		}
+	}
+
+host_id_found:
+	if (*host_id >= cbdt->transport_info.host_num) {
+		cbdt_err(cbdt, "host_id: %u is too large, host_num: %u\n",
+			       *host_id, cbdt->transport_info.host_num);
+		return -EINVAL;
+	}
+
+	/* check for duplicated hostname */
+	ret = cbd_host_find_id_by_name(cbdt, hostname, &host_id_tmp);
+	if (!ret && (host_id_tmp != *host_id)) {
+		cbdt_err(cbdt, "duplicated hostname: %s with host: %u\n", hostname, i);
+		return -EINVAL;
+	}
+
+	host_info = cbdt_host_info_read(cbdt, *host_id);
+	if (host_info && cbd_host_info_is_alive(host_info)) {
+		pr_err("host id %u is still alive\n", *host_id);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+int cbd_host_register(struct cbd_transport *cbdt, char *hostname, u32 host_id)
+{
+	struct cbd_host *host;
+	int ret;
+
+	ret = host_register_validate(cbdt, hostname, &host_id);
+	if (ret)
+		return ret;
+
+	host = kzalloc(sizeof(struct cbd_host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->cbdt = cbdt;
+	host->host_id = host_id;
+	mutex_init(&host->info_lock);
+	INIT_DELAYED_WORK(&host->hb_work, host_hb_workfn);
+
+	host->host_info.state = CBD_HOST_STATE_RUNNING;
+	memcpy(host->host_info.hostname, hostname, CBD_NAME_LEN);
+
+	cbdt->host = host;
+
+	host_info_write(host);
+	queue_delayed_work(cbd_wq, &host->hb_work, 0);
+
+	return 0;
+}
+
+static bool host_backends_stopped(struct cbd_transport *cbdt, u32 host_id)
+{
+	struct cbd_backend_info *backend_info;
+	u32 i;
+
+	cbd_for_each_backend_info(cbdt, i, backend_info) {
+		if (!backend_info || backend_info->state != CBD_BACKEND_STATE_RUNNING)
+			continue;
+
+		if (backend_info->host_id == host_id) {
+			cbdt_err(cbdt, "backend %u is still on host %u\n", i, host_id);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static bool host_blkdevs_stopped(struct cbd_transport *cbdt, u32 host_id)
+{
+	struct cbd_blkdev_info *blkdev_info;
+	int i;
+
+	cbd_for_each_blkdev_info(cbdt, i, blkdev_info) {
+		if (!blkdev_info || blkdev_info->state != CBD_BLKDEV_STATE_RUNNING)
+			continue;
+
+		if (blkdev_info->host_id == host_id) {
+			cbdt_err(cbdt, "blkdev %u is still on host %u\n", i, host_id);
+			return false;
+		}
+	}
+
+	return true;
+}
+
+void cbd_host_unregister(struct cbd_transport *cbdt)
+{
+	struct cbd_host *host = cbdt->host;
+
+	if (!host) {
+		cbd_err("This host is not registered.");
+		return;
+	}
+
+	cancel_delayed_work_sync(&host->hb_work);
+	cbdt_host_info_clear(cbdt, host->host_id);
+	cbdt->host = NULL;
+	kfree(host);
+}
+
+int cbd_host_clear(struct cbd_transport *cbdt, u32 host_id)
+{
+	struct cbd_host_info *host_info;
+
+	host_info = cbdt_get_host_info(cbdt, host_id);
+	if (cbd_host_info_is_alive(host_info)) {
+		cbdt_err(cbdt, "host %u is still alive\n", host_id);
+		return -EBUSY;
+	}
+
+	if (host_info->state == CBD_HOST_STATE_NONE)
+		return 0;
+
+	if (!host_blkdevs_stopped(cbdt, host_id) ||
+			!host_backends_stopped(cbdt, host_id))
+		return -EBUSY;
+
+	cbdt_host_info_clear(cbdt, host_id);
+
+	return 0;
+}
diff --git a/drivers/block/cbd/cbd_host.h b/drivers/block/cbd/cbd_host.h
new file mode 100644
index 000000000000..859e1b9169d9
--- /dev/null
+++ b/drivers/block/cbd/cbd_host.h
@@ -0,0 +1,67 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CBD_HOST_H
+#define _CBD_HOST_H
+
+#include "cbd_internal.h"
+#include "cbd_transport.h"
+
+CBD_DEVICE(host);
+
+#define CBD_HOST_STATE_NONE		0
+#define CBD_HOST_STATE_RUNNING		1
+
+struct cbd_host_info {
+	struct cbd_meta_header meta_header;
+	u8			state;
+	u8			res;
+
+	u16			res1;
+	u32			res2;
+	u64			alive_ts;
+	char			hostname[CBD_NAME_LEN];
+};
+
+struct cbd_host {
+	u32			host_id;
+	struct cbd_transport	*cbdt;
+
+	struct cbd_host_device	*dev;
+
+	struct cbd_host_info	host_info;
+	struct mutex		info_lock;
+
+	struct delayed_work	hb_work; /* heartbeat work */
+};
+
+int cbd_host_register(struct cbd_transport *cbdt, char *hostname, u32 host_id);
+void cbd_host_unregister(struct cbd_transport *cbdt);
+int cbd_host_clear(struct cbd_transport *cbdt, u32 host_id);
+bool cbd_host_info_is_alive(struct cbd_host_info *info);
+
+#define cbd_for_each_host_info(cbdt, i, host_info)				\
+	for (i = 0;								\
+	     i < cbdt->transport_info.host_num &&				\
+	     (host_info = cbdt_host_info_read(cbdt, i));			\
+	     i++)
+
+static inline int cbd_host_find_id_by_name(struct cbd_transport *cbdt, char *hostname, u32 *host_id)
+{
+	struct cbd_host_info *host_info;
+	u32 i;
+
+	cbd_for_each_host_info(cbdt, i, host_info) {
+		if (!host_info)
+			continue;
+
+		if (strcmp(host_info->hostname, hostname) == 0) {
+			*host_id = i;
+			goto found;
+		}
+	}
+
+	return -ENOENT;
+found:
+	return 0;
+}
+
+#endif /* _CBD_HOST_H */
-- 
2.34.1


