Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01F53DFF23
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236822AbhHDKKK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236492AbhHDKKH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:10:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115DC0613D5;
        Wed,  4 Aug 2021 03:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=6DgUtwKNyR1a0g7YYdfnNpZ/CC1UQP+ErbVil3kCh1c=; b=hZg7Heuoi1cW7PM8NkA+rSJm9t
        I2KlL1Sq8tSDfak/FYjW0iTlFpdM5JzQt+VxoIwm3u6Cf0t5JALt5DeWfL4rLzTCjZs067eyLYZLM
        oAktJ5QR1BLAByF6wFWgdt4Vf1Khj9xH1AL98dEMW+T87DmVpV4fRP4C7bDFj9sy6O3iVhyU//xl6
        P6JCchl+81L6Iok4jXIyH34HXYiPyikdLQOYd+laX0rbeAjKMSfl89ueQtR3ycxjZ4FbfjSD8Ew5Y
        CAibi0DxATQ3bTiNdF5b7p1AIZ6NMjq/rlAWEiXu+FBq1odEVzUr/20Am2cHt5372vzKoxOhgZisY
        TVzqe11g==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDnx-005g2S-Sm; Wed, 04 Aug 2021 10:07:32 +0000
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
Subject: [PATCH 14/15] dcssblk: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:33 +0200
Message-Id: <20210804095634.460779-15-hch@lst.de>
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
 drivers/s390/block/dcssblk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 29180bdf0977..5be3d1c39a78 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -892,8 +892,7 @@ dcssblk_submit_bio(struct bio *bio)
 
 	index = (bio->bi_iter.bi_sector >> 3);
 	bio_for_each_segment(bvec, bio, iter) {
-		page_addr = (unsigned long)
-			page_address(bvec.bv_page) + bvec.bv_offset;
+		page_addr = (unsigned long)bvec_virt(&bvec);
 		source_addr = dev_info->start + (index<<12) + bytes_done;
 		if (unlikely((page_addr & 4095) != 0) || (bvec.bv_len & 4095) != 0)
 			// More paranoia.
-- 
2.30.2

