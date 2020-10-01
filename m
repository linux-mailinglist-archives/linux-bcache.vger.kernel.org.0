Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B6E27F9B1
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 08:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725921AbgJAGvO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 02:51:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:33580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgJAGvN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 02:51:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 38294B02A;
        Thu,  1 Oct 2020 06:51:12 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 03/15] bcache: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu,  1 Oct 2020 14:50:44 +0800
Message-Id: <20201001065056.24411-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001065056.24411-1-colyli@suse.de>
References: <20201001065056.24411-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

As inode->iprivate equals to third parameter of
debugfs_create_file() which is NULL. So it's equivalent
to original code logic.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/closure.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 0164a1fe94a9..d8d9394a6beb 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -159,7 +159,7 @@ void closure_debug_destroy(struct closure *cl)
 
 static struct dentry *closure_debug;
 
-static int debug_seq_show(struct seq_file *f, void *data)
+static int debug_show(struct seq_file *f, void *data)
 {
 	struct closure *cl;
 
@@ -188,17 +188,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 	return 0;
 }
 
-static int debug_seq_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, debug_seq_show, NULL);
-}
-
-static const struct file_operations debug_ops = {
-	.owner		= THIS_MODULE,
-	.open		= debug_seq_open,
-	.read		= seq_read,
-	.release	= single_release
-};
+DEFINE_SHOW_ATTRIBUTE(debug);
 
 void  __init closure_debug_init(void)
 {
@@ -209,7 +199,7 @@ void  __init closure_debug_init(void)
 		 * about this.
 		 */
 		closure_debug = debugfs_create_file(
-			"closures", 0400, bcache_debug, NULL, &debug_ops);
+			"closures", 0400, bcache_debug, NULL, &debug_fops);
 }
 #endif
 
-- 
2.26.2

