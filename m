Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADDD64BFDB5
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Feb 2022 16:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiBVPxS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Feb 2022 10:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiBVPw6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Feb 2022 10:52:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EEB54BCF;
        Tue, 22 Feb 2022 07:52:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=PMHViAJhEEv7jlvdbpFwU2YaZRdIC4g9mzG7ynUcv90=; b=wxABwN0ujck+tDQz82qITDMWOE
        6vVGG/pJNlX68EPkavkRShaHap7ajnipbIeG8oEgmOp1SZVHxB22EWHfYotsB0yPpaBK2ahW5GW+S
        8kzRGNNrOY11nvQqgiLNriwVitBtd8uzT0JMvcE41H5PSjci6aphpvknzw35Cx+hlhNDN1ZUx6DDU
        xSR8xlHPN9Fga+jfQTBEObFGdOtokX4iZgsSBa3+/oXytAveNQIir8hIJjYF5VsYUA06b1BxysoPk
        pX+cgXqME+0qSMx+zXD6Ohjhqpk2PuhzcbhrNQrhQui/bqnruaKtwABNcY2noAg2JjOqigijr4wgx
        +LtsvjUw==;
Received: from [2001:4bb8:198:f8fc:c22a:ebfc:be8d:63c2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nMXSi-00AQ1t-CM; Tue, 22 Feb 2022 15:52:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        Justin Sanders <justin@coraid.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Denis Efremov <efremov@linux.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Coly Li <colyli@suse.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-xtensa@linux-xtensa.org, linux-block@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bcache@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: [PATCH 09/10] drbd: use bvec_kmap_local in recv_dless_read
Date:   Tue, 22 Feb 2022 16:51:55 +0100
Message-Id: <20220222155156.597597-10-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220222155156.597597-1-hch@lst.de>
References: <20220222155156.597597-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_receiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 04e3ec12d8b49..fa00cf2ea9529 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2017,10 +2017,10 @@ static int recv_dless_read(struct drbd_peer_device *peer_device, struct drbd_req
 	D_ASSERT(peer_device->device, sector == bio->bi_iter.bi_sector);
 
 	bio_for_each_segment(bvec, bio, iter) {
-		void *mapped = kmap(bvec.bv_page) + bvec.bv_offset;
+		void *mapped = bvec_kmap_local(&bvec);
 		expect = min_t(int, data_size, bvec.bv_len);
 		err = drbd_recv_all_warn(peer_device->connection, mapped, expect);
-		kunmap(bvec.bv_page);
+		kunmap_local(mapped);
 		if (err)
 			return err;
 		data_size -= expect;
-- 
2.30.2

