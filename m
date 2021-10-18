Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC113431033
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 08:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhJRGMD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 02:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhJRGMD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 02:12:03 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA13BC06161C
        for <linux-bcache@vger.kernel.org>; Sun, 17 Oct 2021 23:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VVrTJ84Ur5QALOCLA9ZPJBIFqhZh/k1cuHJeacbGLF8=; b=ut+M/qe4N9i2/VjDDNZy03mwmL
        Dbp75k4D4A38wrU5AYoWgMyoQLIDrpTJoDQQ/AylNJknEK5U8bchhcvd1tlNi9pN04DvGZuJLeD7r
        KK5yo7Vy6TCbPKMcSNXL9GXGO59o9evXx0U+F1Gj5G+JXDluOtOUhOyHCU8KBVIfjdYHRUewAS9H5
        qf7ks98mhxxB1y54qipfupKlbhtdjVgpjcu6T5vsUGJQ+Oo0o57dS41tuoBSFc/KN8wWjiss1sXdF
        2siECimHm0TmQA4B6w+xA9S/mafk8I6SAEp8b5DTcIrC6xdE2EVFhnQkda5vln3l68yhTsPNfggU6
        rrwulGyg==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLqK-00EHjw-5h; Mon, 18 Oct 2021 06:09:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH 4/4] bcache: remove bch_crc64_update
Date:   Mon, 18 Oct 2021 08:09:34 +0200
Message-Id: <20211018060934.1816088-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018060934.1816088-1-hch@lst.de>
References: <20211018060934.1816088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

bch_crc64_update is an entirely pointless wrapper around crc64_be.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/btree.c   | 2 +-
 drivers/md/bcache/request.c | 2 +-
 drivers/md/bcache/util.h    | 8 --------
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 0595559de174a..93b67b8d31c3d 100644
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
index 64ce5788f80cb..3f10f82483047 100644
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
index b64460a762677..6274d6a17e5e7 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -548,14 +548,6 @@ static inline uint64_t bch_crc64(const void *p, size_t len)
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
2.30.2

