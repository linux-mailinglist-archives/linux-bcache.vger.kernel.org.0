Return-Path: <linux-bcache+bounces-100-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 589EE8054BD
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 13:40:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D95C51F20CD4
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 12:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B162F65ED9;
	Tue,  5 Dec 2023 12:38:52 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F90E1A1;
	Tue,  5 Dec 2023 04:38:47 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Sl0Sw2TvYz4f3lW2;
	Tue,  5 Dec 2023 20:38:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 050481A0C85;
	Tue,  5 Dec 2023 20:38:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDnNw7GGW9lr8E8Cw--.35507S12;
	Tue, 05 Dec 2023 20:38:44 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	roger.pau@citrix.com,
	colyli@suse.de,
	kent.overstreet@gmail.com,
	joern@lazybastard.org,
	miquel.raynal@bootlin.com,
	richard@nod.at,
	vigneshr@ti.com,
	sth@linux.ibm.com,
	hoeppner@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	clm@fb.com,
	josef@toxicpanda.com,
	dsterba@suse.com,
	nico@fluxnic.net,
	xiang@kernel.org,
	chao@kernel.org,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	agruenba@redhat.com,
	jack@suse.com,
	konishi.ryusuke@gmail.com,
	willy@infradead.org,
	akpm@linux-foundation.org,
	hare@suse.de,
	p.raghav@samsung.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org,
	linux-ext4@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-nilfs@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next RFC 08/14] btrfs: use bdev apis
Date: Tue,  5 Dec 2023 20:37:22 +0800
Message-Id: <20231205123728.1866699-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDnNw7GGW9lr8E8Cw--.35507S12
X-Coremail-Antispam: 1UD129KBjvJXoW3JFW5WF1UtFWDury7AFyfXrb_yoW3Kr45pr
	W7CF95trWUJrn8Ww4kWw4kAw1Sq3sFvay8CF9xGw4Ska45t3sYgFyvy34Fqa4Fkry8JF97
	XF4UtFWxuF1IkF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Wrv_Gr1UMI
	IYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E
	14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	oxhLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

On the one hand covert to use folio while reading bdev inode, on the
other hand prevent to access bd_inode directly.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 fs/btrfs/disk-io.c | 68 ++++++++++++++++++++--------------------------
 fs/btrfs/volumes.c | 17 ++++++------
 fs/btrfs/zoned.c   | 12 ++++----
 3 files changed, 42 insertions(+), 55 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 9317606017e2..cfe7ea417760 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3597,28 +3597,24 @@ ALLOW_ERROR_INJECTION(open_ctree, ERRNO);
 static void btrfs_end_super_write(struct bio *bio)
 {
 	struct btrfs_device *device = bio->bi_private;
-	struct bio_vec *bvec;
-	struct bvec_iter_all iter_all;
-	struct page *page;
-
-	bio_for_each_segment_all(bvec, bio, iter_all) {
-		page = bvec->bv_page;
+	struct folio_iter fi;
 
+	bio_for_each_folio_all(fi, bio) {
 		if (bio->bi_status) {
 			btrfs_warn_rl_in_rcu(device->fs_info,
 				"lost page write due to IO error on %s (%d)",
 				btrfs_dev_name(device),
 				blk_status_to_errno(bio->bi_status));
-			ClearPageUptodate(page);
-			SetPageError(page);
+			folio_clear_uptodate(fi.folio);
+			folio_set_error(fi.folio);
 			btrfs_dev_stat_inc_and_print(device,
 						     BTRFS_DEV_STAT_WRITE_ERRS);
 		} else {
-			SetPageUptodate(page);
+			folio_mark_uptodate(fi.folio);
 		}
 
-		put_page(page);
-		unlock_page(page);
+		folio_put(fi.folio);
+		folio_unlock(fi.folio);
 	}
 
 	bio_put(bio);
@@ -3628,9 +3624,8 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 						   int copy_num, bool drop_cache)
 {
 	struct btrfs_super_block *super;
-	struct page *page;
+	struct folio *folio;
 	u64 bytenr, bytenr_orig;
-	struct address_space *mapping = bdev->bd_inode->i_mapping;
 	int ret;
 
 	bytenr_orig = btrfs_sb_offset(copy_num);
@@ -3651,16 +3646,15 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 		 * Drop the page of the primary superblock, so later read will
 		 * always read from the device.
 		 */
-		invalidate_inode_pages2_range(mapping,
-				bytenr >> PAGE_SHIFT,
+		invalidate_bdev_range(bdev, bytenr >> PAGE_SHIFT,
 				(bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
 	}
 
-	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
-	if (IS_ERR(page))
-		return ERR_CAST(page);
+	folio = bdev_read_folio_gfp(bdev, bytenr >> PAGE_SHIFT, GFP_NOFS);
+	if (IS_ERR(folio))
+		return ERR_CAST(folio);
 
-	super = page_address(page);
+	super = folio_address(folio);
 	if (btrfs_super_magic(super) != BTRFS_MAGIC) {
 		btrfs_release_disk_super(super);
 		return ERR_PTR(-ENODATA);
@@ -3717,7 +3711,6 @@ static int write_dev_supers(struct btrfs_device *device,
 			    struct btrfs_super_block *sb, int max_mirrors)
 {
 	struct btrfs_fs_info *fs_info = device->fs_info;
-	struct address_space *mapping = device->bdev->bd_inode->i_mapping;
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 	int i;
 	int errors = 0;
@@ -3730,7 +3723,7 @@ static int write_dev_supers(struct btrfs_device *device,
 	shash->tfm = fs_info->csum_shash;
 
 	for (i = 0; i < max_mirrors; i++) {
-		struct page *page;
+		struct folio *folio;
 		struct bio *bio;
 		struct btrfs_super_block *disk_super;
 
@@ -3755,9 +3748,10 @@ static int write_dev_supers(struct btrfs_device *device,
 				    BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE,
 				    sb->csum);
 
-		page = find_or_create_page(mapping, bytenr >> PAGE_SHIFT,
-					   GFP_NOFS);
-		if (!page) {
+		folio = bdev_find_or_create_folio(device->bdev,
+						  bytenr >> PAGE_SHIFT,
+						  GFP_NOFS);
+		if (IS_ERR(folio)) {
 			btrfs_err(device->fs_info,
 			    "couldn't get super block page for bytenr %llu",
 			    bytenr);
@@ -3766,9 +3760,9 @@ static int write_dev_supers(struct btrfs_device *device,
 		}
 
 		/* Bump the refcount for wait_dev_supers() */
-		get_page(page);
+		folio_get(folio);
 
-		disk_super = page_address(page);
+		disk_super = folio_address(folio);
 		memcpy(disk_super, sb, BTRFS_SUPER_INFO_SIZE);
 
 		/*
@@ -3782,8 +3776,8 @@ static int write_dev_supers(struct btrfs_device *device,
 		bio->bi_iter.bi_sector = bytenr >> SECTOR_SHIFT;
 		bio->bi_private = device;
 		bio->bi_end_io = btrfs_end_super_write;
-		__bio_add_page(bio, page, BTRFS_SUPER_INFO_SIZE,
-			       offset_in_page(bytenr));
+		bio_add_folio_nofail(bio, folio, BTRFS_SUPER_INFO_SIZE,
+				     offset_in_folio(folio, bytenr));
 
 		/*
 		 * We FUA only the first super block.  The others we allow to
@@ -3819,7 +3813,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 		max_mirrors = BTRFS_SUPER_MIRROR_MAX;
 
 	for (i = 0; i < max_mirrors; i++) {
-		struct page *page;
+		struct folio *folio;
 
 		ret = btrfs_sb_log_location(device, i, READ, &bytenr);
 		if (ret == -ENOENT) {
@@ -3834,27 +3828,23 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 		    device->commit_total_bytes)
 			break;
 
-		page = find_get_page(device->bdev->bd_inode->i_mapping,
-				     bytenr >> PAGE_SHIFT);
-		if (!page) {
+		folio = bdev_get_folio(device->bdev, bytenr >> PAGE_SHIFT);
+		if (!folio) {
 			errors++;
 			if (i == 0)
 				primary_failed = true;
 			continue;
 		}
 		/* Page is submitted locked and unlocked once the IO completes */
-		wait_on_page_locked(page);
-		if (PageError(page)) {
+		folio_wait_locked(folio);
+		if (folio_test_error(folio)) {
 			errors++;
 			if (i == 0)
 				primary_failed = true;
 		}
 
-		/* Drop our reference */
-		put_page(page);
-
-		/* Drop the reference from the writing run */
-		put_page(page);
+		/* Drop our reference and the reference from the writing run */
+		folio_put_refs(folio, 2);
 	}
 
 	/* log error, force error return */
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1cc6b5d5eb61..3930495aebd1 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1230,16 +1230,16 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 
 void btrfs_release_disk_super(struct btrfs_super_block *super)
 {
-	struct page *page = virt_to_page(super);
+	struct folio *folio = virt_to_folio(super);
 
-	put_page(page);
+	folio_put(folio);
 }
 
 static struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
 						       u64 bytenr, u64 bytenr_orig)
 {
 	struct btrfs_super_block *disk_super;
-	struct page *page;
+	struct folio *folio;
 	void *p;
 	pgoff_t index;
 
@@ -1257,15 +1257,14 @@ static struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev
 		return ERR_PTR(-EINVAL);
 
 	/* pull in the page with our super */
-	page = read_cache_page_gfp(bdev->bd_inode->i_mapping, index, GFP_KERNEL);
+	folio = bdev_read_folio_gfp(bdev, index, GFP_KERNEL);
+	if (IS_ERR(folio))
+		return ERR_CAST(folio);
 
-	if (IS_ERR(page))
-		return ERR_CAST(page);
-
-	p = page_address(page);
+	p = folio_address(folio);
 
 	/* align our pointer to the offset of the super block */
-	disk_super = p + offset_in_page(bytenr);
+	disk_super = p + offset_in_folio(folio, bytenr);
 
 	if (btrfs_super_bytenr(disk_super) != bytenr_orig ||
 	    btrfs_super_magic(disk_super) != BTRFS_MAGIC) {
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 12066afc235c..77d5f906ff16 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -120,8 +120,6 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 		return -ENOENT;
 	} else if (full[0] && full[1]) {
 		/* Compare two super blocks */
-		struct address_space *mapping = bdev->bd_inode->i_mapping;
-		struct page *page[BTRFS_NR_SB_LOG_ZONES];
 		struct btrfs_super_block *super[BTRFS_NR_SB_LOG_ZONES];
 		int i;
 
@@ -129,15 +127,15 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
 			u64 zone_end = (zones[i].start + zones[i].capacity) << SECTOR_SHIFT;
 			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
 						BTRFS_SUPER_INFO_SIZE;
-
-			page[i] = read_cache_page_gfp(mapping,
+			struct folio *folio = bdev_read_folio_gfp(bdev,
 					bytenr >> PAGE_SHIFT, GFP_NOFS);
-			if (IS_ERR(page[i])) {
+
+			if (IS_ERR(folio)) {
 				if (i == 1)
 					btrfs_release_disk_super(super[0]);
-				return PTR_ERR(page[i]);
+				return PTR_ERR(folio);
 			}
-			super[i] = page_address(page[i]);
+			super[i] = folio_address(folio);
 		}
 
 		if (btrfs_super_generation(super[0]) >
-- 
2.39.2


