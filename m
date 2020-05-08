Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B2E1CB4B9
	for <lists+linux-bcache@lfdr.de>; Fri,  8 May 2020 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgEHQPz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 8 May 2020 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgEHQPw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 8 May 2020 12:15:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40DBC05BD43;
        Fri,  8 May 2020 09:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=n4BlxfAoE46GqdVKTfjn1wvj9x7W8SFFzAKjtn35NUg=; b=lKQHfrZQB3GVXEMVIOYmIOeirj
        k6P+pmqjWE7FwNcOkwYPsn3MPHj0sFH9E4w1meppGWuplBMsBFB47fPwsB91XmikKZdgEXhbDSe05
        qSkL/o0Nz+2+InxXUotF0J6zcJPmxpHWCv0LmD3xmPzS+lsH69Aq5k8bunTPRPCxcQObZqYj9DrsX
        4SB+yfX4bveVlF1PogC1UTcjZFFu6mOHsqvu6w3jlW0WH0EXwyAN6SMo8BbYEl4VlmKKi8dkdhydM
        gzLg53434yA02j2ouHixP58m9ko79Q8MVeC4r3z6LWlBHCIiQP/kTaSnFwOrdfIaSt0ZbIbUOHmdb
        LqIMRQJQ==;
Received: from [2001:4bb8:180:9d3f:90d7:9df8:7cd:3504] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jX5fA-0004jV-Eh; Fri, 08 May 2020 16:15:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.ibm.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com,
        linux-block@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org
Subject: [PATCH 09/15] lightnvm: stop using ->queuedata
Date:   Fri,  8 May 2020 18:15:11 +0200
Message-Id: <20200508161517.252308-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508161517.252308-1-hch@lst.de>
References: <20200508161517.252308-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/lightnvm/core.c      | 1 -
 drivers/lightnvm/pblk-init.c | 2 +-
 drivers/lightnvm/pblk.h      | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
index db38a68abb6c0..85c5490cdfd2e 100644
--- a/drivers/lightnvm/core.c
+++ b/drivers/lightnvm/core.c
@@ -400,7 +400,6 @@ static int nvm_create_tgt(struct nvm_dev *dev, struct nvm_ioctl_create *create)
 	}
 
 	tdisk->private_data = targetdata;
-	tqueue->queuedata = targetdata;
 
 	mdts = (dev->geo.csecs >> 9) * NVM_MAX_VLBA;
 	if (dev->geo.mdts) {
diff --git a/drivers/lightnvm/pblk-init.c b/drivers/lightnvm/pblk-init.c
index 9a967a2e83dd7..bec904ec0f7c0 100644
--- a/drivers/lightnvm/pblk-init.c
+++ b/drivers/lightnvm/pblk-init.c
@@ -49,7 +49,7 @@ struct bio_set pblk_bio_set;
 
 static blk_qc_t pblk_make_rq(struct request_queue *q, struct bio *bio)
 {
-	struct pblk *pblk = q->queuedata;
+	struct pblk *pblk = bio->bi_disk->private_data;
 
 	if (bio_op(bio) == REQ_OP_DISCARD) {
 		pblk_discard(pblk, bio);
diff --git a/drivers/lightnvm/pblk.h b/drivers/lightnvm/pblk.h
index 86ffa875bfe16..ed364afaed0d8 100644
--- a/drivers/lightnvm/pblk.h
+++ b/drivers/lightnvm/pblk.h
@@ -1255,7 +1255,7 @@ static inline int pblk_boundary_ppa_checks(struct nvm_tgt_dev *tgt_dev,
 				continue;
 		}
 
-		print_ppa(tgt_dev->q->queuedata, ppa, "boundary", i);
+		print_ppa(tgt_dev->disk->private_data, ppa, "boundary", i);
 
 		return 1;
 	}
-- 
2.26.2

