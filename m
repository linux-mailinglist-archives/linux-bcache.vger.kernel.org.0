Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287E83DFF34
	for <lists+linux-bcache@lfdr.de>; Wed,  4 Aug 2021 12:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhHDKMS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 4 Aug 2021 06:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237586AbhHDKLC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 4 Aug 2021 06:11:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5A3C0617A0;
        Wed,  4 Aug 2021 03:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GMfM9EsZUBHncaik750rjQrck1K0EDt7Zyd8DyDsQR8=; b=tr+JWjNanWktxua2tu8KBEVQPM
        VyctgS15pe259rzKfF5Cnl9zsGOZwGuYm9KKXEG9KkVU/OXjXmoutUxD3KtVa1hc7sIzDOL0xBHg6
        ouWKg49YE/w0a3I/5CyE5im2/IkgIt5h36qDG6iEVKLdm0bYYEaWZQNNpQ3/ly3BhHTT+VGChTRSA
        t1t4AV538fKbiuL2Yzgst/hi/JUFHCOzwHqdzg8ut46IDHJ3Z60UfyB0/ffmOuu7Ku3k+weyK559G
        73X58xMPec7XJUSNLOyS/qJ7yYdzHQEljjfYG426vMaByMMBIZ1fvI2CSO1n9hwhGNLZQ/aY/Dvn+
        uR6ZApew==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBDoj-005g7I-Ho; Wed, 04 Aug 2021 10:08:23 +0000
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
Subject: [PATCH 15/15] nvme: use bvec_virt
Date:   Wed,  4 Aug 2021 11:56:34 +0200
Message-Id: <20210804095634.460779-16-hch@lst.de>
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
 drivers/nvme/host/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dfd9dec0c1f6..02ce94b2906b 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -968,12 +968,11 @@ void nvme_cleanup_cmd(struct request *req)
 {
 	if (req->rq_flags & RQF_SPECIAL_PAYLOAD) {
 		struct nvme_ctrl *ctrl = nvme_req(req)->ctrl;
-		struct page *page = req->special_vec.bv_page;
 
-		if (page == ctrl->discard_page)
+		if (req->special_vec.bv_page == ctrl->discard_page)
 			clear_bit_unlock(0, &ctrl->discard_page_busy);
 		else
-			kfree(page_address(page) + req->special_vec.bv_offset);
+			kfree(bvec_virt(&req->special_vec));
 	}
 }
 EXPORT_SYMBOL_GPL(nvme_cleanup_cmd);
-- 
2.30.2

