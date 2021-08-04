Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759453DFEB0
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237261AbhHDKCJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbhHDKCI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:02:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43347C0613D5;
        Wed,  4 Aug 2021 03:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=tt1taHmY3o8vbuA2AsPbb7cVrfeK82HOf8oIyKb3FTc=; b=hQD8KAYgeD+mcu3L+5xHSLBo6v
        KqojgNbYvl2wtrtH74G2n7RfNh4yKrQ6VFFH0zqcE312iaQ3rdaOtuiLLhlgi6inMl2tvjqN44r72
        8uFEgjIi2C8hWo+D6boAKH/PyxlyQ5HOTIkyPuBK6Mf0/D9MQC28Vfvk98Wd/tCkX5OPbz8e9hns7
        iFrSC8YNN3h2HIBA7MnCkr1wp7PIx30YO2pOm1Jvv0UyrDjAotS7zcZNT86qxhTcottNy1CIKwe7E
        eBqYoK9R7/9DBi0elNYmpi9Zu1wOHzahpeNqX2Mbv82BVMilP4Ziw9RJf0cJQZV2KmrCwCOqyBakx
        asS/u03g==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDga-005f7A-CF; Wed, 04 Aug 2021 09:59:54 +0000
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
Subject: [PATCH 04/15] dm-ebs: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:23 +0200
Message-Id: <20210804095634.460779-5-hch@lst.de>
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
 drivers/md/dm-ebs-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 71475a2410be..0c509dae0ff8 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -74,7 +74,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, int rw, struct bio_vec *bv, struct bv
 	if (unlikely(!bv->bv_page || !bv_len))
 		return -EIO;
 
-	pa = page_address(bv->bv_page) + bv->bv_offset;
+	pa = bvec_virt(bv);
 
 	/* Handle overlapping page <-> blocks */
 	while (bv_len) {
-- 
2.30.2

