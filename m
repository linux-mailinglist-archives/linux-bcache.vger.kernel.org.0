Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1575D214DC1
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGEP4R (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 11:56:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:38044 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727790AbgGEP4R (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 11:56:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1FBB1AC37;
        Sun,  5 Jul 2020 15:56:16 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 03/16] bcache: add more accurate error information in read_super_basic()
Date:   Sun,  5 Jul 2020 23:55:48 +0800
Message-Id: <20200705155601.5404-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200705155601.5404-1-colyli@suse.de>
References: <20200705155601.5404-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The improperly set bucket or block size will trigger error in
read_super_basic(). For large bucket size, a more accurate error message
for invalid bucket or block size is necessary.

This patch disassembles the combined if() checks into multile single
if() check, and provide more accurate error message for each check
failure condition.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 88523be84887..d6082b68aa26 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -79,11 +79,20 @@ static const char * read_super_basic(struct cache_sb *sb,  struct block_device *
 	if (sb->nbuckets < 1 << 7)
 		goto err;
 
-	err = "Bad block/bucket size";
-	if (!is_power_of_2(sb->block_size) ||
-	    sb->block_size > PAGE_SECTORS ||
-	    !is_power_of_2(sb->bucket_size) ||
-	    sb->bucket_size < PAGE_SECTORS)
+	err = "Bad block size (not power of 2)";
+	if (!is_power_of_2(sb->block_size))
+		goto err;
+
+	err = "Bad block size (larger than page size)";
+	if (sb->block_size > PAGE_SECTORS)
+		goto err;
+
+	err = "Bad bucket size (not power of 2)";
+	if (!is_power_of_2(sb->bucket_size))
+		goto err;
+
+	err = "Bad bucket size (smaller than page size)";
+	if (sb->bucket_size < PAGE_SECTORS)
 		goto err;
 
 	err = "Invalid superblock: device too small";
-- 
2.26.2

