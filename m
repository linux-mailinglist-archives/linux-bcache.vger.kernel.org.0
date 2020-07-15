Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0442220F44
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 16:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGOOaa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 10:30:30 -0400
Received: from [195.135.220.15] ([195.135.220.15]:59380 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgGOOaa (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 10:30:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4FB55AEFC;
        Wed, 15 Jul 2020 14:30:30 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 02/16] bcache: add more accurate error information in read_super_common()
Date:   Wed, 15 Jul 2020 22:30:01 +0800
Message-Id: <20200715143015.14957-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715143015.14957-1-colyli@suse.de>
References: <20200715143015.14957-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

The improperly set bucket or block size will trigger error in
read_super_common(). For large bucket size, a more accurate error message
for invalid bucket or block size is necessary.

This patch disassembles the combined if() checks into multiple single
if() check, and provide more accurate error message for each check
failure condition.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9fe0e4dcfd1b..e162941122d4 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -79,11 +79,20 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
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

