Return-Path: <linux-bcache+bounces-720-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 801CD97BAB0
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 12:19:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 973401C2235C
	for <lists+linux-bcache@lfdr.de>; Wed, 18 Sep 2024 10:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 580EA187868;
	Wed, 18 Sep 2024 10:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fmEPI8GT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E19183CDB
	for <linux-bcache@vger.kernel.org>; Wed, 18 Sep 2024 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726654736; cv=none; b=cRvQs1Ktf8mb7l8YNtL0+oLah0FPXy5FJ9ty3PRWnMYK/KqsHBNyNs4yRY3L/wECGlk/Pl3YmXmZlTqq83awz+FV1H6Rt4eNT/CbGUXRJVTy6FpX7visThMlwFev1XJBJ8dK6z7pA5FF+/pRnGErqli0EO8kw5WJCTVfr4Vr7mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726654736; c=relaxed/simple;
	bh=3Z9cqqwVNBgZGNzCsATLdcwnVncJcipLmol4c5UwyR4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dzyXyiRfPJjyAuG+yiA79Zo800rI4v4mSvV6rLVqIuopnvV+Awx9HS35xdScUXm3QANg18SwdtdBPNd4C9MXweyuARXoLFiyRlYch4jfUqy0wP5uR3w/JX5fjFh676ddcvwyCgy6qexuiY/YQx1KhYoILVgOJvBjOUcmDfYtNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fmEPI8GT; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726654732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8NF/WSkahAQpAxr8dlQx+eZwv0YPW32YvfGYGq2Rnzo=;
	b=fmEPI8GThz3nRX5Pnsv9KNNaxqFiVfEBV3CT0S+DYTdOjSRJlxoFT0tJpYwF9IZPu5txT4
	7bIvOq9xuvD2H8VrmSnB0jP/ZHXCYB7QzMeQfKXxVabyOAUU2Cv3f3cJzMk0fVAXsu20Ni
	7SpxbVEvYQlTgYaCo9FaAyMqj5IX6Xo=
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
Subject: [PATCH v2 2/8] cbd: introduce cbd_host
Date: Wed, 18 Sep 2024 10:18:15 +0000
Message-Id: <20240918101821.681118-3-dongsheng.yang@linux.dev>
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

The "cbd_host" represents a host node. Each node needs to be registered
before it can use the "cbd_transport". After registration, the node's
information, such as its hostname, will be recorded in the "hosts" area
of this transport. Through this mechanism, we can know which nodes are
currently using each transport.

If a host dies without unregistering, we allow the user to clear this
host entry in the metadata.

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/block/cbd/cbd_host.c | 129 +++++++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)
 create mode 100644 drivers/block/cbd/cbd_host.c

diff --git a/drivers/block/cbd/cbd_host.c b/drivers/block/cbd/cbd_host.c
new file mode 100644
index 000000000000..02f7ef52150d
--- /dev/null
+++ b/drivers/block/cbd/cbd_host.c
@@ -0,0 +1,129 @@
+#include "cbd_internal.h"
+
+static ssize_t cbd_host_name_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cbd_host_device *host;
+	struct cbd_host_info *host_info;
+
+	host = container_of(dev, struct cbd_host_device, dev);
+	host_info = host->host_info;
+
+	if (host_info->state == cbd_host_state_none)
+		return 0;
+
+	return sprintf(buf, "%s\n", host_info->hostname);
+}
+
+static DEVICE_ATTR(hostname, 0400, cbd_host_name_show, NULL);
+
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
+int cbd_host_register(struct cbd_transport *cbdt, char *hostname)
+{
+	struct cbd_host *host;
+	struct cbd_host_info *host_info;
+	u32 host_id;
+	int ret;
+
+	if (cbdt->host)
+		return -EEXIST;
+
+	if (strlen(hostname) == 0)
+		return -EINVAL;
+
+	ret = cbdt_get_empty_host_id(cbdt, &host_id);
+	if (ret < 0)
+		return ret;
+
+	host = kzalloc(sizeof(struct cbd_host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->host_id = host_id;
+	host->cbdt = cbdt;
+	INIT_DELAYED_WORK(&host->hb_work, host_hb_workfn);
+
+	host_info = cbdt_get_host_info(cbdt, host_id);
+	host_info->state = cbd_host_state_running;
+	memcpy(host_info->hostname, hostname, CBD_NAME_LEN);
+
+	host->host_info = host_info;
+	cbdt->host = host;
+
+	queue_delayed_work(cbd_wq, &host->hb_work, 0);
+
+	return 0;
+}
+
+int cbd_host_unregister(struct cbd_transport *cbdt)
+{
+	struct cbd_host *host = cbdt->host;
+	struct cbd_host_info *host_info;
+
+	if (!host) {
+		cbd_err("This host is not registered.");
+		return 0;
+	}
+
+	host->host_info->state = cbd_host_state_removing;
+	cancel_delayed_work_sync(&host->hb_work);
+	host_info = host->host_info;
+	memset(host_info->hostname, 0, CBD_NAME_LEN);
+	host_info->alive_ts = 0;
+	host_info->state = cbd_host_state_none;
+
+	cbdt->host = NULL;
+	kfree(cbdt->host);
+
+	return 0;
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
+	if (host_info->state == cbd_host_state_none)
+		return 0;
+
+	host_info->state = cbd_host_state_none;
+
+	return 0;
+}
-- 
2.34.1


