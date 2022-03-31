Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22FD4EDEF4
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Mar 2022 18:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbiCaQmS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 31 Mar 2022 12:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238497AbiCaQmR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 31 Mar 2022 12:42:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C061C1EDC;
        Thu, 31 Mar 2022 09:40:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 055E168AFE; Thu, 31 Mar 2022 18:40:25 +0200 (CEST)
Date:   Thu, 31 Mar 2022 18:40:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qian Cai <quic_qiancai@quicinc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: cleanup bio_kmalloc v2
Message-ID: <20220331164024.GA30404@lst.de>
References: <20220308061551.737853-1-hch@lst.de> <YkXYMGGbk/ZTbGaA@qian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YkXYMGGbk/ZTbGaA@qian>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This should fix it:

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index 930eb530fa622..fed99bb3df3be 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -72,6 +72,13 @@ static int copy_bio_to_actor(struct bio *bio,
 	return copied_bytes;
 }
 
+static void squashfs_bio_free(struct bio *bio)
+{
+	bio_free_pages(bio);
+	bio_uninit(bio);
+	kfree(bio);
+}
+
 static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 			     struct bio **biop, int *block_offset)
 {
@@ -118,9 +125,7 @@ static int squashfs_bio_read(struct super_block *sb, u64 index, int length,
 	return 0;
 
 out_free_bio:
-	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	squashfs_bio_free(bio);
 	return error;
 }
 
@@ -183,8 +188,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 			data = bvec_virt(bvec);
 			length |= data[0] << 8;
 		}
-		bio_free_pages(bio);
-		bio_put(bio);
+		squashfs_bio_free(bio);
 
 		compressed = SQUASHFS_COMPRESSED(length);
 		length = SQUASHFS_COMPRESSED_SIZE(length);
@@ -217,8 +221,7 @@ int squashfs_read_data(struct super_block *sb, u64 index, int length,
 	}
 
 out_free_bio:
-	bio_free_pages(bio);
-	bio_put(bio);
+	squashfs_bio_free(bio);
 out:
 	if (res < 0) {
 		ERROR("Failed to read block 0x%llx: %d\n", index, res);
