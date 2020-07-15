Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D63F22047B
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 07:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgGOFqV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 01:46:21 -0400
Received: from [195.135.220.15] ([195.135.220.15]:38334 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbgGOFqU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 01:46:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 14E8FAC20;
        Wed, 15 Jul 2020 05:46:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v2 01/17] bcache: add comments to mark member offset of struct cache_sb_disk
Date:   Wed, 15 Jul 2020 13:45:56 +0800
Message-Id: <20200715054612.6349-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715054612.6349-1-colyli@suse.de>
References: <20200715054612.6349-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds comments to mark each member of struct cache_sb_disk,
it is helpful to understand the bcache superblock on-disk layout.

Signed-off-by: Coly Li <colyli@suse.de>
---
 include/uapi/linux/bcache.h | 39 +++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index 9a1965c6c3d0..afbd1b56a661 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -158,33 +158,33 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
 #define BDEV_DATA_START_DEFAULT		16	/* sectors */
 
 struct cache_sb_disk {
-	__le64			csum;
-	__le64			offset;	/* sector where this sb was written */
-	__le64			version;
+/*000*/	__le64			csum;
+/*008*/	__le64			offset;	/* sector where this sb was written */
+/*010*/	__le64			version;
 
-	__u8			magic[16];
+/*018*/	__u8			magic[16];
 
-	__u8			uuid[16];
+/*028*/	__u8			uuid[16];
 	union {
-		__u8		set_uuid[16];
+/*038*/		__u8		set_uuid[16];
 		__le64		set_magic;
 	};
-	__u8			label[SB_LABEL_SIZE];
+/*048*/	__u8			label[SB_LABEL_SIZE];
 
-	__le64			flags;
-	__le64			seq;
-	__le64			pad[8];
+/*068*/	__le64			flags;
+/*070*/	__le64			seq;
+/*078*/	__le64			pad[8];
 
 	union {
 	struct {
 		/* Cache devices */
-		__le64		nbuckets;	/* device size */
+/*0b8*/		__le64		nbuckets;	/* device size */
 
-		__le16		block_size;	/* sectors */
-		__le16		bucket_size;	/* sectors */
+/*0c0*/		__le16		block_size;	/* sectors */
+/*0c2*/		__le16		bucket_size;	/* sectors */
 
-		__le16		nr_in_set;
-		__le16		nr_this_dev;
+/*0c4*/		__le16		nr_in_set;
+/*0c6*/		__le16		nr_this_dev;
 	};
 	struct {
 		/* Backing devices */
@@ -198,14 +198,15 @@ struct cache_sb_disk {
 	};
 	};
 
-	__le32			last_mount;	/* time overflow in y2106 */
+/*0c8*/	__le32			last_mount;	/* time overflow in y2106 */
 
-	__le16			first_bucket;
+/*0cc*/	__le16			first_bucket;
 	union {
-		__le16		njournal_buckets;
+/*0ce*/		__le16		njournal_buckets;
 		__le16		keys;
 	};
-	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+/*0d0*/	__le64			d[SB_JOURNAL_BUCKETS];	/* journal buckets */
+/*8d0*/
 };
 
 struct cache_sb {
-- 
2.26.2

