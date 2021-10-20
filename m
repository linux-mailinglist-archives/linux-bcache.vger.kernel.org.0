Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE2C434E07
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTOkz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37086 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTOkz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:55 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C2A421981;
        Wed, 20 Oct 2021 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGjvB+AFfZlZs5YQXg9JNOZ8jel3eqMmAiBl4b4jZmM=;
        b=h3NxgQzwT6dWvRI1McEWSJlsX4775pgzEuh8rN11DEgKHpNnvkVWDs7dTO5VTP4i6hF6Q+
        xQl8IrVRSHChwf51ILytJ+v34k1oPCoF27w3/qw5DYBc/8ijDuYdCM2p4ck4nUa/joprFX
        8Qkq8KMYJkG6/476LaMzScohAA3hRio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740720;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGjvB+AFfZlZs5YQXg9JNOZ8jel3eqMmAiBl4b4jZmM=;
        b=sv6RrSahgn8/wyrg7hdkSnKjp/6BUSEHaGPIBHZJnOp4yKgaE8CXVfdY3qLXxg6PYydGlP
        +jQfm8AjWI5I53Cg==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id DEA1EA3BA2;
        Wed, 20 Oct 2021 14:38:37 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 7/8] bcache: use bvec_kmap_local in bch_data_verify
Date:   Wed, 20 Oct 2021 22:38:11 +0800
Message-Id: <20211020143812.6403-8-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Using local kmaps slightly reduces the chances to stray writes, and
the bvec interface cleans up the code a little bit.

Also switch from page_address to bvec_kmap_local for cbv to be on the
safe side and to avoid pointlessly poking into bvec internals.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/debug.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index e803cad864be..6230dfdd9286 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -127,21 +127,20 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 
 	citer.bi_size = UINT_MAX;
 	bio_for_each_segment(bv, bio, iter) {
-		void *p1 = kmap_atomic(bv.bv_page);
+		void *p1 = bvec_kmap_local(&bv);
 		void *p2;
 
 		cbv = bio_iter_iovec(check, citer);
-		p2 = page_address(cbv.bv_page);
+		p2 = bvec_kmap_local(&cbv);
 
-		cache_set_err_on(memcmp(p1 + bv.bv_offset,
-					p2 + bv.bv_offset,
-					bv.bv_len),
+		cache_set_err_on(memcmp(p1, p2, bv.bv_len),
 				 dc->disk.c,
 				 "verify failed at dev %pg sector %llu",
 				 dc->bdev,
 				 (uint64_t) bio->bi_iter.bi_sector);
 
-		kunmap_atomic(p1);
+		kunmap_local(p2);
+		kunmap_local(p1);
 		bio_advance_iter(check, &citer, bv.bv_len);
 	}
 
-- 
2.31.1

