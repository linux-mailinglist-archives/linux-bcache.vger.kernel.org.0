Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91DF26DBC2
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Sep 2020 14:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgIQMkg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Sep 2020 08:40:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49912 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbgIQMkQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Sep 2020 08:40:16 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 08:40:10 EDT
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7EAB13B5571B7F534558;
        Thu, 17 Sep 2020 20:22:55 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 17 Sep 2020 20:22:49 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next v2] bcache: Convert to DEFINE_SHOW_ATTRIBUTE
Date:   Thu, 17 Sep 2020 20:23:26 +0800
Message-ID: <20200917122326.99080-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.

As inode->iprivate equals to third parameter of
debugfs_create_file() which is NULL. So it's equivalent
to original code logic.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
v2: based on linux-next(20200917), and can be applied to
    mainline cleanly now.

 drivers/md/bcache/closure.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 0164a1fe9..d8d9394a6 100644
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
2.23.0

