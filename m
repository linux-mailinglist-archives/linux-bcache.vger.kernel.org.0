Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5176D3DFEDB
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhHDKEk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbhHDKEk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:04:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67631C0613D5;
        Wed,  4 Aug 2021 03:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OgN+TL2fi+1ZwR7PJxoMS2EK4Eu2vaMrEjV+dYXPObM=; b=jqeZ0Lxh+W2cclXMZXNwa2ndtK
        c8FElTE6VaKuvE87+FU9EPMjLAINUnTn1UZDhVkXSQt6HO+czDRw9JEod7R5qKU2vSDTc/aQHLTa3
        3zmXmwLGvez4nxjDXqqsb2x0LwmqB/Gcqey5G3Rs1kFKAD0Cwi03UIrEPBuqQefZECCpTNCY0QVy1
        qGiKEk07FqeB3BJOSmiOcsG1gQ/B3bCKa3cbabjOjyE/Hb9L3KLyWK5AaCgSYyF/UhlxhHwwbjDlz
        Sz6OlH7g9mkShsoIzFT9EAQt8FbzdDMgJdv9I4butvH9F/uOwHsZ3z0fLIpmhqo8kmb5GKCH4WbWF
        W2zNaDcQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDid-005fLT-QT; Wed, 04 Aug 2021 10:02:02 +0000
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
Subject: [PATCH 07/15] rbd: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:26 +0200
Message-Id: <20210804095634.460779-8-hch@lst.de>
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
 drivers/block/rbd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 6d596c2c2cd6..e65c9d706f6f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2986,8 +2986,7 @@ static bool is_zero_bvecs(struct bio_vec *bvecs, u32 bytes)
 	};
 
 	ceph_bvec_iter_advance_step(&it, bytes, ({
-		if (memchr_inv(page_address(bv.bv_page) + bv.bv_offset, 0,
-			       bv.bv_len))
+		if (memchr_inv(bvec_virt(&bv), 0, bv.bv_len))
 			return false;
 	}));
 	return true;
-- 
2.30.2

