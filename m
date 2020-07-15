Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033DB220F4C
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 16:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728393AbgGOOak (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 10:30:40 -0400
Received: from [195.135.220.15] ([195.135.220.15]:59540 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgGOOak (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 10:30:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14F6DAEFC;
        Wed, 15 Jul 2020 14:30:41 +0000 (UTC)
From:   colyli@suse.de
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 06/16] bcache: move bucket related code into read_super_common()
Date:   Wed, 15 Jul 2020 22:30:05 +0800
Message-Id: <20200715143015.14957-7-colyli@suse.de>
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

Setting sb->first_bucket and checking sb->keys indeed are only for cache
device, it does not make sense to do them in read_super() for backing
device too.

This patch moves the related code piece into read_super_common()
explicitly for cache device and avoid the confusion.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 9f273bd58507..e8a505ef766d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -66,12 +66,17 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 	const char *err;
 	unsigned int i;
 
+	sb->first_bucket= le16_to_cpu(s->first_bucket);
 	sb->nbuckets	= le64_to_cpu(s->nbuckets);
 	sb->bucket_size	= le16_to_cpu(s->bucket_size);
 
 	sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
 	sb->nr_this_dev	= le16_to_cpu(s->nr_this_dev);
 
+	err = "Too many journal buckets";
+	if (sb->keys > SB_JOURNAL_BUCKETS)
+		goto err;
+
 	err = "Too many buckets";
 	if (sb->nbuckets > LONG_MAX)
 		goto err;
@@ -155,7 +160,6 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	sb->flags		= le64_to_cpu(s->flags);
 	sb->seq			= le64_to_cpu(s->seq);
 	sb->last_mount		= le32_to_cpu(s->last_mount);
-	sb->first_bucket	= le16_to_cpu(s->first_bucket);
 	sb->keys		= le16_to_cpu(s->keys);
 
 	for (i = 0; i < SB_JOURNAL_BUCKETS; i++)
@@ -172,10 +176,6 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	if (memcmp(sb->magic, bcache_magic, 16))
 		goto err;
 
-	err = "Too many journal buckets";
-	if (sb->keys > SB_JOURNAL_BUCKETS)
-		goto err;
-
 	err = "Bad checksum";
 	if (s->csum != csum_set(s))
 		goto err;
-- 
2.26.2

