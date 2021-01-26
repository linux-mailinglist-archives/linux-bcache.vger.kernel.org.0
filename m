Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7F304095
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 15:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405853AbhAZOjC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 09:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405925AbhAZOiy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 09:38:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F3BC0611C2;
        Tue, 26 Jan 2021 06:38:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=qlbpHPBSE9cCG3MefejlTgLltST3iJlEyPkRgH8th2I=; b=uVO0bFF9AFcW0iYW9qVgIt1NEs
        NQO7wtP7U7+I3VLtupqYODY5VpSP22wTOv4B8VubukA6rtefpvuwW/BfSG1eObrfC4mNDRk0ZGwM7
        7KDJCqhgk0ex5JZChSQhUuHyUychF2vzMfqHNclLGG4GYbpqP8Vu7XaOmNkOLpNbIFM2P4KNYoaxH
        xjdliuz3nN1AZ9KgNF1r9uoRzaj74Ga3imNCDNfeyspINx6dZNVvGXtXOJ70ISs4TnY5QMBCJlcO3
        0kuYwbflb0XFCI5JCH2CY4WTxfgns81M/XWsEeq5LXlFBFKgS9g3vgY81JH0q21bNujyoifPjdtbl
        ai2xfOjw==;
Received: from [2001:4bb8:191:e347:5918:ac86:61cb:8801] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l4PSl-005kVC-34; Tue, 26 Jan 2021 14:37:15 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
Subject: [PATCH 3/3] block: inherit BIO_REMAPPED when cloning bios
Date:   Tue, 26 Jan 2021 15:33:08 +0100
Message-Id: <20210126143308.1960860-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126143308.1960860-1-hch@lst.de>
References: <20210126143308.1960860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Cloned bios are can be used to on the same device, in which case we need
to inherit the BIO_REMAPPED flag to avoid a double partition remap.  When
the cloned bios are used on another device, bio_set_dev will clear the flag.

Fixes: 309dca309fc3 ("block: store a block_device pointer in struct bio")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                 | 2 ++
 block/blk-crypto-fallback.c | 2 ++
 block/bounce.c              | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 99040a7e6656a1..dfd7740a32300a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -666,6 +666,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	bio_set_flag(bio, BIO_CLONED);
 	if (bio_flagged(bio_src, BIO_THROTTLED))
 		bio_set_flag(bio, BIO_THROTTLED);
+	if (bio_flagged(bio_src, BIO_REMAPPED))
+		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_opf = bio_src->bi_opf;
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 8f1e1817673115..50c225398e4d60 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -168,6 +168,8 @@ static struct bio *blk_crypto_clone_bio(struct bio *bio_src)
 	if (!bio)
 		return NULL;
 	bio->bi_bdev		= bio_src->bi_bdev;
+	if (bio_flagged(bio_src, BIO_REMAPPED))
+		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_opf		= bio_src->bi_opf;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
diff --git a/block/bounce.c b/block/bounce.c
index a22a8a1942b24f..fc55314aa4269a 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -247,6 +247,8 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 	if (!bio)
 		return NULL;
 	bio->bi_bdev		= bio_src->bi_bdev;
+	if (bio_flagged(bio_src, BIO_REMAPPED))
+		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_opf		= bio_src->bi_opf;
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
-- 
2.29.2

