Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E112C54D1
	for <lists+linux-bcache@lfdr.de>; Thu, 26 Nov 2020 14:09:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389964AbgKZNHb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Nov 2020 08:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390005AbgKZNH2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Nov 2020 08:07:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514DEC061A04;
        Thu, 26 Nov 2020 05:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=K1Z4h4bY+Em7tTffAceNUsYLga3tYfdkZ7ZkqWnFlaA=; b=pVGb1ocNGrV+mNW2xDqIoyVwQd
        u7N5eYTAoYmMx5/fs9mSyZrLP7GGIrtq67w4AJX5gui8gqnSZd0N40u+34s59Qyi+HIDY11ZPeSgb
        o2Qycg7KmxwBip9xNvUfQgCgwu6UuFdOk20CABN5c9awGp3JHOaLZE15n93AjhATLdrZgqeXGYqBt
        wU0rzldf2iRhWAiHKqkFjiXzotSEp3ibcyb2Jr2myfNN4zlq5wCJdn0O1g1Z/1llL6LK+dSJHXZiv
        JKsyiVyIYqHIjpMbkrAiUP/oKiW68FZJEBE5hAKYB95B7C4f4DhPOv0elEfa6O/UQy0FxV+cUCdaQ
        Pq07vZog==;
Received: from [2001:4bb8:18c:1dd6:27b8:b8a1:c13e:ceb1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kiGzX-00046R-3X; Thu, 26 Nov 2020 13:07:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 32/44] block: move the partition_meta_info to struct block_device
Date:   Thu, 26 Nov 2020 14:04:10 +0100
Message-Id: <20201126130422.92945-33-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126130422.92945-1-hch@lst.de>
References: <20201126130422.92945-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Move the partition_meta_info to struct block_device in preparation for
killing struct hd_struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk.h               |  1 -
 block/genhd.c             |  3 ++-
 block/partitions/core.c   | 18 +++++++-----------
 fs/block_dev.c            |  1 +
 include/linux/blk_types.h |  2 ++
 include/linux/genhd.h     |  1 -
 init/do_mounts.c          |  7 ++++---
 7 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 3f801f6e86f8a1..0bd4b58bcbaf77 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -381,7 +381,6 @@ static inline void hd_struct_put(struct hd_struct *part)
 
 static inline void hd_free_part(struct hd_struct *part)
 {
-	kfree(part->info);
 	bdput(part->bdev);
 	percpu_ref_exit(&part->ref);
 }
diff --git a/block/genhd.c b/block/genhd.c
index 7bb45382658385..fe202a12eec096 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1002,7 +1002,8 @@ void __init printk_all_partitions(void)
 			       bdevt_str(part_devt(part), devt_buf),
 			       bdev_nr_sectors(part->bdev) >> 1,
 			       disk_name(disk, part->partno, name_buf),
-			       part->info ? part->info->uuid : "");
+			       part->bdev->bd_meta_info ?
+					part->bdev->bd_meta_info->uuid : "");
 			if (is_part0) {
 				if (dev->parent && dev->parent->driver)
 					printk(" driver: %s\n",
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 485777cea26bfa..224a22d82fb86f 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -275,8 +275,9 @@ static int part_uevent(struct device *dev, struct kobj_uevent_env *env)
 	struct hd_struct *part = dev_to_part(dev);
 
 	add_uevent_var(env, "PARTN=%u", part->partno);
-	if (part->info && part->info->volname[0])
-		add_uevent_var(env, "PARTNAME=%s", part->info->volname);
+	if (part->bdev->bd_meta_info && part->bdev->bd_meta_info->volname[0])
+		add_uevent_var(env, "PARTNAME=%s",
+			       part->bdev->bd_meta_info->volname);
 	return 0;
 }
 
@@ -422,13 +423,10 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 	p->policy = get_disk_ro(disk);
 
 	if (info) {
-		struct partition_meta_info *pinfo;
-
-		pinfo = kzalloc_node(sizeof(*pinfo), GFP_KERNEL, disk->node_id);
-		if (!pinfo)
+		err = -ENOMEM;
+		bdev->bd_meta_info = kmemdup(info, sizeof(*info), GFP_KERNEL);
+		if (!bdev->bd_meta_info)
 			goto out_bdput;
-		memcpy(pinfo, info, sizeof(*info));
-		p->info = pinfo;
 	}
 
 	dname = dev_name(ddev);
@@ -444,7 +442,7 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 
 	err = blk_alloc_devt(p, &devt);
 	if (err)
-		goto out_free_info;
+		goto out_bdput;
 	pdev->devt = devt;
 
 	/* delay uevent until 'holders' subdir is created */
@@ -481,8 +479,6 @@ static struct hd_struct *add_partition(struct gendisk *disk, int partno,
 		kobject_uevent(&pdev->kobj, KOBJ_ADD);
 	return p;
 
-out_free_info:
-	kfree(p->info);
 out_bdput:
 	bdput(bdev);
 out_free:
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 11e6a9a255845d..62fae6a0e8aa56 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -785,6 +785,7 @@ static void bdev_free_inode(struct inode *inode)
 	struct block_device *bdev = I_BDEV(inode);
 
 	free_percpu(bdev->bd_stats);
+	kfree(bdev->bd_meta_info);
 
 	kmem_cache_free(bdev_cachep, BDEV_I(inode));
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a690008f60cd92..2f8ede04e5a94c 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -49,6 +49,8 @@ struct block_device {
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
 	struct super_block	*bd_fsfreeze_sb;
+
+	struct partition_meta_info *bd_meta_info;
 } __randomize_layout;
 
 #define bdev_whole(_bdev) \
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 50d27f5d38e2af..30d7076155b4d2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -57,7 +57,6 @@ struct hd_struct {
 	struct device __dev;
 	struct kobject *holder_dir;
 	int policy, partno;
-	struct partition_meta_info *info;
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	int make_it_fail;
 #endif
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 5879edf083b318..368ccb71850126 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -79,8 +79,8 @@ static int match_dev_by_uuid(struct device *dev, const void *data)
 	const struct uuidcmp *cmp = data;
 	struct hd_struct *part = dev_to_part(dev);
 
-	if (!part->info ||
-	    strncasecmp(cmp->uuid, part->info->uuid, cmp->len))
+	if (!part->bdev->bd_meta_info ||
+	    strncasecmp(cmp->uuid, part->bdev->bd_meta_info->uuid, cmp->len))
 		return 0;
 	return 1;
 }
@@ -169,7 +169,8 @@ static int match_dev_by_label(struct device *dev, const void *data)
 	const char *label = data;
 	struct hd_struct *part = dev_to_part(dev);
 
-	if (!part->info || strcmp(label, part->info->volname))
+	if (!part->bdev->bd_meta_info ||
+	    strcmp(label, part->bdev->bd_meta_info->volname))
 		return 0;
 	return 1;
 }
-- 
2.29.2

