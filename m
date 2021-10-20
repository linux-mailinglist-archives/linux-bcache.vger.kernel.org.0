Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6D3434E09
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJTOk5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55192 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhJTOk5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:57 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3C7131FD4B;
        Wed, 20 Oct 2021 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znhlH9MUxbdWEjUMUQIHGlUqwVbwKpH7OgNygEAPUxM=;
        b=XBjZR5zqbZLvWkGSSznUzGVS7o0JSG8nUxdHzlGxOs4COuQsKqqg0y0cfaAQckEXZLNuIt
        tWvXv6/edF01mBFFE+FXmVxygHHRyha/sTBh88MZSAQCBc5TQx8ZG/I9ACGyvmC3vTxU5G
        cZ3a2mxvxlLkVEEyYtUNX9Sv0hy5Q2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740722;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=znhlH9MUxbdWEjUMUQIHGlUqwVbwKpH7OgNygEAPUxM=;
        b=FBK4h4GjaefbG4iNvI5SWq6LRGRYXIt/t4kiMHQbbGMFZvqIBBORQc3nGPUBPSWaYgHUt+
        uApRL2G2Qd7wfpBA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 68D82A3B85;
        Wed, 20 Oct 2021 14:38:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 8/8] bcache: remove bch_crc64_update
Date:   Wed, 20 Oct 2021 22:38:12 +0800
Message-Id: <20211020143812.6403-9-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

bch_crc64_update is an entirely pointless wrapper around crc64_be.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c   | 2 +-
 drivers/md/bcache/request.c | 2 +-
 drivers/md/bcache/util.h    | 8 --------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 183a58c89377..88c573eeb598 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -141,7 +141,7 @@ static uint64_t btree_csum_set(struct btree *b, struct bset *i)
 	uint64_t crc = b->key.ptr[0];
 	void *data = (void *) i + 8, *end = bset_bkey_last(i);
 
-	crc = bch_crc64_update(crc, data, end - data);
+	crc = crc64_be(crc, data, end - data);
 	return crc ^ 0xffffffffffffffffULL;
 }
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 64ce5788f80c..3f10f8248304 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -46,7 +46,7 @@ static void bio_csum(struct bio *bio, struct bkey *k)
 	bio_for_each_segment(bv, bio, iter) {
 		void *d = kmap(bv.bv_page) + bv.bv_offset;
 
-		csum = bch_crc64_update(csum, d, bv.bv_len);
+		csum = crc64_be(csum, d, bv.bv_len);
 		kunmap(bv.bv_page);
 	}
 
diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index bca4a7c97da7..50d1dc69d970 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -550,14 +550,6 @@ static inline uint64_t bch_crc64(const void *p, size_t len)
 	return crc ^ 0xffffffffffffffffULL;
 }
 
-static inline uint64_t bch_crc64_update(uint64_t crc,
-					const void *p,
-					size_t len)
-{
-	crc = crc64_be(crc, p, len);
-	return crc;
-}
-
 /*
  * A stepwise-linear pseudo-exponential.  This returns 1 << (x >>
  * frac_bits), with the less-significant bits filled in by linear
-- 
2.31.1

