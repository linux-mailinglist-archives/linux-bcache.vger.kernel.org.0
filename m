Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C383DFED0
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237363AbhHDKDn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbhHDKDk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:03:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86645C0613D5;
        Wed,  4 Aug 2021 03:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=U8gl0ibigZuBxb1er2grGKX+goE9BthZJ/OF371A9bI=; b=wR11HIuSQMK44FHP61z8T70PBH
        PaVhFcTxwWOPc4pnZqyPEGVj9JzDzsXU4ilPRj8HNgVDJbT2PVl5B84w1V3kPeuIUfFt8yZ37Ho0z
        z01UKj/pwAhZEXcFNMlkYG9yjqd8rXxJc/QGiWBEZ7DrYfFC8yviuXRDsKYeDUm0P/BsTD/Q8A4at
        t0ie4dglmKF0awtMLfFDuviTiAVKBik4jaEW7q1/2w8cSPQ1sAkKQgIHt4rukLpaJ4dKNAJwjN65s
        lhBAaD+jrqWHjJb39cHqz5p/o38APHJLiXsCYIV9VX7QkP+OPbv5oOHfANZ0i57CwDry/qW3UzBCE
        wY3JGlEw==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDi1-005fHw-82; Wed, 04 Aug 2021 10:01:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 06/15] squashfs: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:25 +0200
Message-Id: <20210804095634.460779-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use bvec_virt instead of open coding it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/squashfs/block.c        | 7 +++----
 fs/squashfs/lz4_wrapper.c  | 2 +-
 fs/squashfs/lzo_wrapper.c  | 2 +-
 fs/squashfs/xz_wrapper.c   | 2 +-
 fs/squashfs/zlib_wrapper.c | 2 +-
 fs/squashfs/zstd_wrapper.c | 2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 855f0e87066d..2db8bcf7ff85 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -49,8 +49,7 @@ static int copy_bio_to_actor(struct bio *bio,
 
 		bytes_to_copy = min_t(int, bytes_to_copy,
 				      req_length - copied_bytes);
-		memcpy(actor_addr + actor_offset,
-		       page_address(bvec->bv_page) + bvec->bv_offset + offset,
+		memcpy(actor_addr + actor_offset, bvec_virt(bvec) + offset,
 		       bytes_to_copy);
 
 		actor_offset += bytes_to_copy;
@@ -177,7 +176,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 			goto out_free_bio;
 		}
 		/* Extract the length of the metadata block */
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		length = data[offset];
 		if (offset < bvec->bv_len - 1) {
 			length |= data[offset + 1] << 8;
@@ -186,7 +185,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 				res = -EIO;
 				goto out_free_bio;
 			}
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length |= data[0] << 8;
 		}
 		bio_free_pages(bio);
diff --git a/fs/squashfs/lz4_wrapper.c b/fs/squashfs/lz4_wrapper.c
index 233d5582fbee..b685b6238316 100644
--- a/fs/squashfs/lz4_wrapper.c
+++ b/fs/squashfs/lz4_wrapper.c
@@ -101,7 +101,7 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	while (bio_next_segment(bio, &iter_all)) {
 		int avail = min(bytes, ((int)bvec->bv_len) - offset);
 
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
diff --git a/fs/squashfs/lzo_wrapper.c b/fs/squashfs/lzo_wrapper.c
index 97bb7d92ddcd..cb510a631968 100644
--- a/fs/squashfs/lzo_wrapper.c
+++ b/fs/squashfs/lzo_wrapper.c
@@ -76,7 +76,7 @@ static int lzo_uncompress(struct squashfs_sb_info *msblk, void *strm,
 	while (bio_next_segment(bio, &iter_all)) {
 		int avail = min(bytes, ((int)bvec->bv_len) - offset);
 
-		data = page_address(bvec->bv_page) + bvec->bv_offset;
+		data = bvec_virt(bvec);
 		memcpy(buff, data + offset, avail);
 		buff += avail;
 		bytes -= avail;
diff --git a/fs/squashfs/xz_wrapper.c b/fs/squashfs/xz_wrapper.c
index e80419aed862..68f6d09bb3a2 100644
--- a/fs/squashfs/xz_wrapper.c
+++ b/fs/squashfs/xz_wrapper.c
@@ -146,7 +146,7 @@ static int squashfs_xz_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			stream->buf.in = data + offset;
 			stream->buf.in_size = avail;
diff --git a/fs/squashfs/zlib_wrapper.c b/fs/squashfs/zlib_wrapper.c
index bcb881ec47f2..a20e9042146b 100644
--- a/fs/squashfs/zlib_wrapper.c
+++ b/fs/squashfs/zlib_wrapper.c
@@ -76,7 +76,7 @@ static int zlib_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			stream->next_in = data + offset;
 			stream->avail_in = avail;
diff --git a/fs/squashfs/zstd_wrapper.c b/fs/squashfs/zstd_wrapper.c
index b7cb1faa652d..0015cf8b5582 100644
--- a/fs/squashfs/zstd_wrapper.c
+++ b/fs/squashfs/zstd_wrapper.c
@@ -94,7 +94,7 @@ static int zstd_uncompress(struct squashfs_sb_info *msblk, void *strm,
 			}
 
 			avail = min(length, ((int)bvec->bv_len) - offset);
-			data = page_address(bvec->bv_page) + bvec->bv_offset;
+			data = bvec_virt(bvec);
 			length -= avail;
 			in_buf.src = data + offset;
 			in_buf.size = avail;
-- 
2.30.2

