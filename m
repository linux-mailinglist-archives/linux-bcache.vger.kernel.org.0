Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4E722D74A
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgGYMDP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:03:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:52442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727023AbgGYMDP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 08845AF17;
        Sat, 25 Jul 2020 12:03:23 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/25] bcache: move bucket related code into read_super_common()
Date:   Sat, 25 Jul 2020 20:00:28 +0800
Message-Id: <20200725120039.91071-15-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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
index 62534f44c6dc..214d50903375 100644
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

