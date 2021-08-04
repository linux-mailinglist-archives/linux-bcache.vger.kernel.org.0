Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718F03DFEEC
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhHDKFo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235066AbhHDKFo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:05:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32BAC0613D5;
        Wed,  4 Aug 2021 03:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=NWGaQ8EeTZRE7jOsnl40NWYULu0YrSIOzslX48aChUU=; b=N2U1fMSy3pgbLVeSVM0BoA1Xx6
        Ry3zTFl3YVaPObK0cagZhV9snGs3e3opGUkDQSDYIrysTVhW+Rifx2ZJmKETOV+YvlSk3N9bIE97t
        9K9jN1/HR0v9+LygVQGZfAHS7XAbs/hfhXoR1kKJNeQ3OOa+Zb86kf9nzMgyfvIJmg4+I61IZOxf9
        2oxZj+Ww3DlOWO3vrWhMMbHqcZ0xB7x1j42BE5yxC3YP+C20J/FYOLDuMJG4QnJuq2iT6WdPDeUb1
        jP92eOghvJ/HmZJFGY/v3dsuGKnENcvnWDEsueNZJHLt5JBcukU53RwrIZPeXcH0QpcQfdNvotK3P
        mCnP/kXQ==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDja-005fRH-4d; Wed, 04 Aug 2021 10:03:04 +0000
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
Subject: [PATCH 08/15] virtio_blk: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:27 +0200
Message-Id: <20210804095634.460779-9-hch@lst.de>
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
 drivers/block/virtio_blk.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 4b49df2dfd23..767b4f72a54d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -166,11 +166,8 @@ static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
 
-	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		kfree(page_address(req->special_vec.bv_page) +
-		      req->special_vec.bv_offset);
-	}
-
+	if (req->rq_flags & RQF_SPECIAL_PAYLOAD)
+		kfree(bvec_virt(&req->special_vec));
 	blk_mq_end_request(req, virtblk_result(vbr));
 }
 
-- 
2.30.2

