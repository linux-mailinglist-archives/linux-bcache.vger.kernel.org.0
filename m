Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE7C3DFE9E
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhHDKAp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbhHDKAo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:00:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5334CC0613D5;
        Wed,  4 Aug 2021 03:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=9PnIwd90XM6OC3TUiZ1/4ur9Fh/NQr+Mi1lLoOWKMW4=; b=wMA1ImSgUgljxEB/DVjr1OPNNo
        Vu5Yy/3EZNV5JPqg8zL7z1ZM9lYw8t8u6ky24W17xUAKc5X7SC4d9uiKIZTMSjdUMsssLldDF5QHX
        /p6onbdx/YKqkBVWMi+x+L4p/xB4/UtKHflV4J4VU14kBvsFru9TONqpuWBMmoYYCASYCkkqcmtKu
        CJYOtT8H18ngH3klzAGOhco6BP5TluC7i78I0VIylgcTaiVcOo9qpcwrUUc9V2MlXSBjOnpLxzF89
        Mr15Zbrkbbvs5usqWfIWvGQV0C7stOD86xyX9fCbce3CHbuux8zAh9CXoVOs4Zyuv+iJwcrQobKcL
        apSCm7jA==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDet-005ewi-MZ; Wed, 04 Aug 2021 09:58:15 +0000
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
Subject: [PATCH 02/15] block: use bvec_virt in bio_integrity_{process,free}
Date:   Wed,  4 Aug 2021 11:56:21 +0200
Message-Id: <20210804095634.460779-3-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use the bvec_virt helper to clean up the bio integrity processing a
little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 8f54d49dc500..6b47cddbbca1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -104,8 +104,7 @@ void bio_integrity_free(struct bio *bio)
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
-		kfree(page_address(bip->bip_vec->bv_page) +
-		      bip->bip_vec->bv_offset);
+		kfree(bvec_virt(bip->bip_vec));
 
 	__bio_integrity_free(bs, bip);
 	bio->bi_integrity = NULL;
@@ -163,13 +162,11 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 	struct bio_vec bv;
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	blk_status_t ret = BLK_STS_OK;
-	void *prot_buf = page_address(bip->bip_vec->bv_page) +
-		bip->bip_vec->bv_offset;
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
 	iter.seed = proc_iter->bi_sector;
-	iter.prot_buf = prot_buf;
+	iter.prot_buf = bvec_virt(bip->bip_vec);
 
 	__bio_for_each_segment(bv, bio, bviter, *proc_iter) {
 		void *kaddr = bvec_kmap_local(&bv);
-- 
2.30.2

