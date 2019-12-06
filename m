Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACCE5114DCB
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 09:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbfLFI4K (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 03:56:10 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34377 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfLFI4K (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 03:56:10 -0500
Received: by mail-pj1-f68.google.com with SMTP id j11so1359372pjs.1;
        Fri, 06 Dec 2019 00:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6Ss3QtZcDjjNjMVmzVt9+Rd5w/z8fKvAe110pSWx1O0=;
        b=Ddjhbs4cE6GzBEGCP53g36/q3g1cVmZB38V4NB7LzOdUSLpJdcMJnNtlG8Q3RFJFrV
         /fveGj452sacVGAnUU4Kx+2VWvjtvVe8QEobBk+I0cng0I3Ls2DsOuId1+ezpE5aXTH+
         xTZaEf3k2N02dwD5tFRQ1CgdskfFaoBOW4KlnkchukdNTpNUE0Gm1AT+Lfeu8lB6VF10
         IUWHpDJGfRjSqTJK2KjhOX8fCliqT4s2i8RiQwzc0oftWHhhpsMFLefBqwwapDmJCXDW
         a2SfLTf7ov9pOncBHAZ2Byafrfk6D09x3M0fu7xtuvFocp4nrME6iIBx3R/H0kbwps8f
         3VFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6Ss3QtZcDjjNjMVmzVt9+Rd5w/z8fKvAe110pSWx1O0=;
        b=qHVzSnfCHReYx+LCLsVdBZnVicO17v2Rfk5CYHQlhzXVHEhV6utFtyx7VXZ0tubYdc
         GF7He3tS7nhk40ekbehjsEBpxhTDdqqxgm9kcTwlCtYIt9yIfWKYM9llyufAx3fE9ZWw
         dRSmiIMf3iCzTnZ8xT6aDnPF6q75OcfCfw4kPFDdy1pybZXNvtH/blgb3B73iyHXb9ia
         tTjvhnF6Z27l0efCQM5SHdRvMaSQ0NpSWXgIVgmytpX15FYlusRw5psxUvyki1w3BblB
         pHnCJEofp/CVHHm5h+lQeVI4J1eU3vXdZpHHEKH+mswAwQZQB09guFPxa/ejCsYjkzJi
         7seQ==
X-Gm-Message-State: APjAAAVnq6yiWfO/U5snx1hvj/EstQTAS7T7j4JmfMEYJfF24XSQ4AxK
        RfBRgAuOKR84TDROqVYYguo=
X-Google-Smtp-Source: APXvYqxGD7sGHHQjspCqZa3sAiv/YiES/p3l0ywCzXx4EYKunT4mG3EYpQLdUilemREOwe3hdd8xOg==
X-Received: by 2002:a17:90b:d85:: with SMTP id bg5mr13771030pjb.99.1575622570011;
        Fri, 06 Dec 2019 00:56:10 -0800 (PST)
Received: from workstation.localdomain ([170.178.178.163])
        by smtp.gmail.com with ESMTPSA id u18sm14520599pgi.44.2019.12.06.00.56.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 00:56:09 -0800 (PST)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes other than 4k
Date:   Fri,  6 Dec 2019 16:55:43 +0800
Message-Id: <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.7.5
In-Reply-To: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

__write_super assumes super block data starts at offset 0 of the page
read in with __bread from read_super, which is not true when page size
is not 4k. We encountered the issue on system with 64K page size - commonly
 seen on aarch64 architecture.

Instead of making any assumption on the offset of the data within the page,
this patch calls __bread again to locate the data. That should not introduce
an extra io since the page has been held when it's read in from read_super,
and __write_super is not on performance critical code path.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 drivers/md/bcache/super.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a573ce1d85aa..a39450c9bc34 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -207,15 +207,27 @@ static void write_bdev_super_endio(struct bio *bio)
 	closure_put(&dc->sb_write);
 }
 
-static void __write_super(struct cache_sb *sb, struct bio *bio)
+static int __write_super(struct cache_sb *sb, struct bio *bio,
+			 struct block_device *bdev)
 {
-	struct cache_sb *out = page_address(bio_first_page_all(bio));
+	struct cache_sb *out;
 	unsigned int i;
+	struct buffer_head *bh;
+
+	/*
+	 * The page is held since read_super, this __bread * should not
+	 * cause an extra io read.
+	 */
+	bh = __bread(bdev, 1, SB_SIZE);
+	if (!bh)
+		goto out_bh;
+
+	out = (struct cache_sb *) bh->b_data;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
-	bch_bio_map(bio, NULL);
+	bch_bio_map(bio, bh->b_data);
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -239,7 +251,14 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	pr_debug("ver %llu, flags %llu, seq %llu",
 		 sb->version, sb->flags, sb->seq);
 
+	/* The page will still be held without this bh.*/
+	put_bh(bh);
 	submit_bio(bio);
+	return 0;
+
+out_bh:
+	pr_err("Couldn't read super block, __write_super failed");
+	return -1;
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
@@ -264,7 +283,8 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 
 	closure_get(cl);
 	/* I/O request sent to backing device */
-	__write_super(&dc->sb, bio);
+	if(__write_super(&dc->sb, bio, dc->bdev))
+		closure_put(cl);
 
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
@@ -312,7 +332,9 @@ void bcache_write_super(struct cache_set *c)
 		bio->bi_private = ca;
 
 		closure_get(cl);
-		__write_super(&ca->sb, bio);
+		if(__write_super(&ca->sb, bio, ca->bdev))
+			closure_put(cl);
+
 	}
 
 	closure_return_with_destructor(cl, bcache_write_super_unlock);
-- 
2.17.0

