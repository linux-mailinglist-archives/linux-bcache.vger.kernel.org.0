Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E41221F2C
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgGPI7Q (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 04:59:16 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:47272 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbgGPI7P (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 04:59:15 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 86486E1183BEF558D6DE;
        Thu, 16 Jul 2020 16:59:13 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 16 Jul 2020 16:59:08 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Santosh Shilimkar <ssantosh@kernel.org>
CC:     <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] memory: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 16 Jul 2020 17:03:03 +0800
Message-ID: <20200716090303.13154-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Yongqiang Liu <liuyongqiang13@huawei.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
---
 drivers/memory/emif.c               | 22 ++--------------------
 drivers/memory/tegra/tegra124-emc.c | 14 +-------------
 2 files changed, 3 insertions(+), 33 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 58a82eea5..aab8ddad7 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -131,16 +131,7 @@ static int emif_regdump_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int emif_regdump_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, emif_regdump_show, inode->i_private);
-}
-
-static const struct file_operations emif_regdump_fops = {
-	.open			= emif_regdump_open,
-	.read_iter			= seq_read_iter,
-	.release		= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(emif_regdump);
 
 static int emif_mr4_show(struct seq_file *s, void *unused)
 {
@@ -150,16 +141,7 @@ static int emif_mr4_show(struct seq_file *s, void *unused)
 	return 0;
 }
 
-static int emif_mr4_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, emif_mr4_show, inode->i_private);
-}
-
-static const struct file_operations emif_mr4_fops = {
-	.open			= emif_mr4_open,
-	.read_iter			= seq_read_iter,
-	.release		= single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(emif_mr4);
 
 static int __init_or_module emif_debugfs_init(struct emif_data *emif)
 {
diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index 23c44429e..16628df1b 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -1059,19 +1059,7 @@ static int tegra_emc_debug_available_rates_show(struct seq_file *s,
 	return 0;
 }
 
-static int tegra_emc_debug_available_rates_open(struct inode *inode,
-						struct file *file)
-{
-	return single_open(file, tegra_emc_debug_available_rates_show,
-			   inode->i_private);
-}
-
-static const struct file_operations tegra_emc_debug_available_rates_fops = {
-	.open = tegra_emc_debug_available_rates_open,
-	.read_iter = seq_read_iter,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
+DEFINE_SHOW_ATTRIBUTE(tegra_emc_debug_available_rates);
 
 static int tegra_emc_debug_min_rate_get(void *data, u64 *rate)
 {
-- 
2.17.1

