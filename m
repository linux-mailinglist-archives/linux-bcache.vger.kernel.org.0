Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5244C86EF
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Mar 2022 09:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233521AbiCAIq6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Mar 2022 03:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiCAIqw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Mar 2022 03:46:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39429887A8;
        Tue,  1 Mar 2022 00:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PIwmC/45DWKh9veAl53jqG4nMVgnAvBfs+f+Iys/sgk=; b=cVatoR0ymAYV0qkd6qq/uvEU7K
        HeqFKc/bZ8QFoD5QhqdE7bmqU89/KWubNGPa/ji/9kVZhLy3IWZixcLVm81jA1WxOiX3NQ6Ws8bfw
        RU21nikvID52vLUrJZhRnsfVxQ+8uTeVc4/9CTSwTZv8J+EeUtokRLlfhJwM2nxlVIrHUd80/hvUc
        MxnOS6ZQ+zyc2D6yEqI0GLnZcFUuto+VxA8gnzeD1P2cbr0MkmRTJg/7LSLpsMdNxBwR5dvq8rUhW
        SfoDFXBbZ0ofT2yWnNUsPYT7s7x8WMigAenpsHcCYoaE1cQFo4zlpYkO8GDTgfNNIx62k+uFEemf4
        Vzj76smQ==;
Received: from [2.53.44.23] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nOy8x-00FfPs-7Z; Tue, 01 Mar 2022 08:46:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] squashfs: always use bio_kmalloc in squashfs_bio_read
Date:   Tue,  1 Mar 2022 10:45:49 +0200
Message-Id: <20220301084552.880256-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220301084552.880256-1-hch@lst.de>
References: <20220301084552.880256-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If a plain kmalloc that is not backed by a mempool is safe here for a
large read (and the actual page allocations), it must also be for a
small one, so simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/squashfs/block.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 622c844f6d118..4311a32218928 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -86,16 +86,11 @@ static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 	int error, i;
 	struct bio *bio;
 
-	if (page_count <= BIO_MAX_VECS) {
-		bio = bio_alloc(sb->s_bdev, page_count, REQ_OP_READ, GFP_NOIO);
-	} else {
-		bio = bio_kmalloc(GFP_NOIO, page_count);
-		bio_set_dev(bio, sb->s_bdev);
-		bio->bi_opf = REQ_OP_READ;
-	}
-
+	bio = bio_kmalloc(GFP_NOIO, page_count);
 	if (!bio)
 		return -ENOMEM;
+	bio_set_dev(bio, sb->s_bdev);
+	bio->bi_opf = REQ_OP_READ;
 
 	bio->bi_iter.bi_sector = block * (msblk->devblksize >> SECTOR_SHIFT);
 
-- 
2.30.2

