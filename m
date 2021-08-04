Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9223DFE8C
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 11:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237278AbhHDJ7x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 05:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhHDJ7x (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 05:59:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154C2C0613D5;
        Wed,  4 Aug 2021 02:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=UJrCb7CGT+ZAjfUzBrDvox/kj9NEI6DcJ2NjSWkF2zM=; b=sYPxayznDPwIRyL7nKUygoZD3k
        dt/bjMT5bAbfRZ13gnpvjc5NY9EksxP5d32LJBcepAgioku0FtN2VHK7R7M7Afs6OF/FfY8D4q2NS
        Ys9QfpkLm0yZEn2Yq8/JAyeP6uZhYAYHcOZgrcndDEeHPgfKy9aR+1m/S5KIqNBPJusPfmCvukDGK
        HDIiS0Sp1Dg5y6Sguy/uqGCvuCY2RruHbmHkNPU54WL6WooDs1ZFZ0+/VZCp4ENDmurNe1u3w4CYN
        wJPMT1dd8CyN11OgdFiYEiEIAngynUkdd6r9ITrs/sxLPRokEREfq2f3JisClKZP8l+gfo3TC+ru9
        p2MBCyUQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDeG-005eu2-Q4; Wed, 04 Aug 2021 09:57:31 +0000
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
Subject: [PATCH 01/15] bvec: add a bvec_virt helper
Date:   Wed,  4 Aug 2021 11:56:20 +0200
Message-Id: <20210804095634.460779-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210804095634.460779-1-hch@lst.de>
References: <20210804095634.460779-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Add a helper to get the virtual address for a bvec.  This avoids that
all callers need to know about the page + offset representation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/bvec.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f9fa43b940ff..0e9bdd42dafb 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -229,4 +229,16 @@ static inline void memzero_bvec(struct bio_vec *bvec)
 	memzero_page(bvec->bv_page, bvec->bv_offset, bvec->bv_len);
 }
 
+/**
+ * bvec_virt - return the virtual address for a bvec
+ * @bvec: bvec to return the virtual address for
+ *
+ * Note: the caller must ensure that @bvec->bv_page is not a highmem page.
+ */
+static inline void *bvec_virt(struct bio_vec *bvec)
+{
+	WARN_ON_ONCE(PageHighMem(bvec->bv_page));
+	return page_address(bvec->bv_page) + bvec->bv_offset;
+}
+
 #endif /* __LINUX_BVEC_H */
-- 
2.30.2

