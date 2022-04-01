Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305D04EE775
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Apr 2022 06:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244915AbiDAE7I (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 1 Apr 2022 00:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244906AbiDAE7H (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 1 Apr 2022 00:59:07 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A63AF1E5;
        Thu, 31 Mar 2022 21:57:18 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D5FF268AFE; Fri,  1 Apr 2022 06:57:13 +0200 (CEST)
Date:   Fri, 1 Apr 2022 06:57:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
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
Subject: Re: [PATCH 4/5] block: turn bio_kmalloc into a simple kmalloc
 wrapper
Message-ID: <20220401045713.GA9057@lst.de>
References: <20220308061551.737853-1-hch@lst.de> <20220308061551.737853-5-hch@lst.de> <CGME20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42@eucas1p2.samsung.com> <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Mar 31, 2022 at 11:18:03PM +0200, Marek Szyprowski wrote:
> Hi Christoph,
> 
> On 08.03.2022 07:15, Christoph Hellwig wrote:
> > Remove the magic autofree semantics and require the callers to explicitly
> > call bio_init to initialize the bio.
> >
> > This allows bio_free to catch accidental bio_put calls on bio_init()ed
> > bios as well.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This patch, which landed in today's next-20220331 as commit 57c47b42f454 
> ("block: turn bio_kmalloc into a simple kmalloc wrapper"), breaks badly 
> all my test systems, which use squashfs initrd:

In addition to the revert, this is the patch I had already queued up:

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

