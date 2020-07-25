Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89B622D73F
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgGYMDD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:03:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:52300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbgGYMDD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:03:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 96049AB55;
        Sat, 25 Jul 2020 12:03:09 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 09/25] bcache: add read_super_common() to read major part of super block
Date:   Sat, 25 Jul 2020 20:00:23 +0800
Message-Id: <20200725120039.91071-10-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Later patches will introduce feature set bits to on-disk super block and
increase super block version. Current code in read_super() which reads
common part of super block for version BCACHE_SB_VERSION_CDEV and version
BCACHE_SB_VERSION_CDEV_WITH_UUID will be shared with the new version.

Therefore this patch moves the reusable part into read_super_common(),
this preparation patch will make later patches more simplier and only
focus on new feature set bits.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 111 +++++++++++++++++++++-----------------
 1 file changed, 63 insertions(+), 48 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 05ad1cd9f329..b5b81b92b2ef 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -59,6 +59,67 @@ struct workqueue_struct *bch_journal_wq;
 
 /* Superblock */
 
+static const char *read_super_common(struct cache_sb *sb,  struct block_device *bdev,
+				     struct cache_sb_disk *s)
+{
+	const char *err;
+	unsigned int i;
+
+	sb->nbuckets	= le64_to_cpu(s->nbuckets);
+	sb->bucket_size	= le16_to_cpu(s->bucket_size);
+
+	sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
+	sb->nr_this_dev	= le16_to_cpu(s->nr_this_dev);
+
+	err = "Too many buckets";
+	if (sb->nbuckets > LONG_MAX)
+		goto err;
+
+	err = "Not enough buckets";
+	if (sb->nbuckets < 1 << 7)
+		goto err;
+
+	err = "Bad block/bucket size";
+	if (!is_power_of_2(sb->block_size) ||
+	    sb->block_size > PAGE_SECTORS ||
+	    !is_power_of_2(sb->bucket_size) ||
+	    sb->bucket_size < PAGE_SECTORS)
+		goto err;
+
+	err = "Invalid superblock: device too small";
+	if (get_capacity(bdev->bd_disk) <
+	    sb->bucket_size * sb->nbuckets)
+		goto err;
+
+	err = "Bad UUID";
+	if (bch_is_zero(sb->set_uuid, 16))
+		goto err;
+
+	err = "Bad cache device number in set";
+	if (!sb->nr_in_set ||
+	    sb->nr_in_set <= sb->nr_this_dev ||
+	    sb->nr_in_set > MAX_CACHES_PER_SET)
+		goto err;
+
+	err = "Journal buckets not sequential";
+	for (i = 0; i < sb->keys; i++)
+		if (sb->d[i] != sb->first_bucket + i)
+			goto err;
+
+	err = "Too many journal buckets";
+	if (sb->first_bucket + sb->keys > sb->nbuckets)
+		goto err;
+
+	err = "Invalid superblock: first bucket comes before end of super";
+	if (sb->first_bucket * sb->bucket_size < 16)
+		goto err;
+
+	err = NULL;
+err:
+	return err;
+}
+
+
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 			      struct cache_sb_disk **res)
 {
@@ -133,55 +194,9 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 		break;
 	case BCACHE_SB_VERSION_CDEV:
 	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
-		sb->nbuckets	= le64_to_cpu(s->nbuckets);
-		sb->bucket_size	= le16_to_cpu(s->bucket_size);
-
-		sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
-		sb->nr_this_dev	= le16_to_cpu(s->nr_this_dev);
-
-		err = "Too many buckets";
-		if (sb->nbuckets > LONG_MAX)
-			goto err;
-
-		err = "Not enough buckets";
-		if (sb->nbuckets < 1 << 7)
-			goto err;
-
-		err = "Bad block/bucket size";
-		if (!is_power_of_2(sb->block_size) ||
-		    sb->block_size > PAGE_SECTORS ||
-		    !is_power_of_2(sb->bucket_size) ||
-		    sb->bucket_size < PAGE_SECTORS)
-			goto err;
-
-		err = "Invalid superblock: device too small";
-		if (get_capacity(bdev->bd_disk) <
-		    sb->bucket_size * sb->nbuckets)
-			goto err;
-
-		err = "Bad UUID";
-		if (bch_is_zero(sb->set_uuid, 16))
-			goto err;
-
-		err = "Bad cache device number in set";
-		if (!sb->nr_in_set ||
-		    sb->nr_in_set <= sb->nr_this_dev ||
-		    sb->nr_in_set > MAX_CACHES_PER_SET)
-			goto err;
-
-		err = "Journal buckets not sequential";
-		for (i = 0; i < sb->keys; i++)
-			if (sb->d[i] != sb->first_bucket + i)
-				goto err;
-
-		err = "Too many journal buckets";
-		if (sb->first_bucket + sb->keys > sb->nbuckets)
-			goto err;
-
-		err = "Invalid superblock: first bucket comes before end of super";
-		if (sb->first_bucket * sb->bucket_size < 16)
+		err = read_super_common(sb, bdev, s);
+		if (err)
 			goto err;
-
 		break;
 	default:
 		err = "Unsupported superblock version";
-- 
2.26.2

