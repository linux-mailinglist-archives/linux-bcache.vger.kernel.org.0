Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B033DFEC3
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbhHDKDK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbhHDKDI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:03:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B09C0617A1;
        Wed,  4 Aug 2021 03:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=38PP0nqE1Rr5Q2SngGpX8SaabB796rszA7pe5/OYcCE=; b=NZVo6Syey+ucG1T/H4GNaod0LQ
        R3HS7TqZ5afkR+W+LPQJkznZOdAp8uReL+jaUNSYRPcVYrEd+QKJpXhyMJeIOUpxn6c6kg6oOcnrj
        ycZVGqV90IGpgWJAdd/4RU4VedNIa+ouNFQPdggcsnOZH0MibUQDRqjnN6Klph1gOoqn8Oowgd+90
        SKSpiLwMFkfPxHoVq1iUv+bgY8YaLlGZCl1KwsC1LwwnnIhdy0CzjMqtFV9iC0vVxrqjp46rQonBS
        dvE79Kmj5hVeLSHgBE3iwZOdeXA8BcSCT2lsyusJ9iEyY1RsgiF6m8nRVF5xP1/KOWT5fQu+V9TFA
        MzZrJ0rg==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDhE-005fC7-4b; Wed, 04 Aug 2021 10:00:43 +0000
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
Subject: [PATCH 05/15] dm-integrity: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:24 +0200
Message-Id: <20210804095634.460779-6-hch@lst.de>
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
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 20f2510db1f6..a9ea361769a7 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1819,7 +1819,7 @@ static void integrity_metadata(struct work_struct *w)
 				unsigned this_len;
 
 				BUG_ON(PageHighMem(biv.bv_page));
-				tag = lowmem_page_address(biv.bv_page) + biv.bv_offset;
+				tag = bvec_virt(&biv);
 				this_len = min(biv.bv_len, data_to_process);
 				r = dm_integrity_rw_tag(ic, tag, &dio->metadata_block, &dio->metadata_offset,
 							this_len, dio->op == REQ_OP_READ ? TAG_READ : TAG_WRITE);
@@ -2006,7 +2006,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 					unsigned tag_now = min(biv.bv_len, tag_todo);
 					char *tag_addr;
 					BUG_ON(PageHighMem(biv.bv_page));
-					tag_addr = lowmem_page_address(biv.bv_page) + biv.bv_offset;
+					tag_addr = bvec_virt(&biv);
 					if (likely(dio->op == REQ_OP_WRITE))
 						memcpy(tag_ptr, tag_addr, tag_now);
 					else
-- 
2.30.2

