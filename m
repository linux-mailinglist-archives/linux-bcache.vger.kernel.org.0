Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3404F11513A
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 14:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLFNna (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 08:43:30 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45291 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLFNna (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 08:43:30 -0500
Received: by mail-pf1-f194.google.com with SMTP id 2so3357679pfg.12;
        Fri, 06 Dec 2019 05:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=r1n5pvqLG2z6eBpv3libroUGed6tLBBxHVt4i5CbkMg=;
        b=BvtZ6v/KAbAE1G23ShR8R/onH0EbwGsbCdIZyTcqVoVpP2x0wYJy1c1ScTeqpLY542
         hYruSoVX0lAsq+Zf0jFUAms0t6XpJ1DDKaUE8gpXrgXQIsLm5SILHzrt0eg3UtRxUQ+M
         LDEsaUA4DpyA/uJERYx6H5KsegMS6aRtweNy7Z8gFu9tHp3lMLNDYeLO3Az6kODH/k2K
         /XX+DTAYze38hr6b4Pv2Q7S4vm9Ssm0cp9CdPBH7gNzGLI9XwxpFHoyVZTDRcTm3ep47
         paLnXGxEzoC3PYqrTryTe2705gRc0dN0FrgpBpCXUfIMoIj1M2js9tiJIzWvXLuYzdIx
         87PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r1n5pvqLG2z6eBpv3libroUGed6tLBBxHVt4i5CbkMg=;
        b=gk7edtRVuYX0GemOAX4UYY3oAkaQ7ogkpNSx/eLDG4F4On0GlcJ25iRTH6DLV7n0zl
         JYzB8v2TN/YQQZprBSV5ixK8kyczxUa3yX4oNTcHTFPh4yXFCGSH+6HtziD9x74W21yq
         pyp3fLIaiUdlak7XBvh94ndkGDrrdX4urjAqxBjCXCVUMhoFqSKroe2PA0/702sD7iji
         g3bHYAwadSoJe+WsnrBMue9fnjbt+/FblOHvw/ckx7iycX+Jo6p064GWGc/O3RzJ+yjG
         Ei5CPFnu0BHDW3yN+E1fsTjfpVvRdyeaAzUMoDaJvrxnrVXYUH6jOyIzdIp76Mh4Uoa0
         qhaw==
X-Gm-Message-State: APjAAAWAo6rZ4G/T4x1l9cWwW/RLxOvmdURJYe3F1eJlrJTSS8MNDOjB
        rlxD+M1meqvFTs18JQpP8AvrpiuJRxQ=
X-Google-Smtp-Source: APXvYqw4SVt4XXbvzo+F0UIJa3Z8CxgI+x9x9WcadfupHaqHRA+LVzyRfltVNvxP0K/Ff6LIUiDUqw==
X-Received: by 2002:a63:d544:: with SMTP id v4mr3462664pgi.288.1575639809712;
        Fri, 06 Dec 2019 05:43:29 -0800 (PST)
Received: from workstation.localdomain ([170.178.178.163])
        by smtp.gmail.com with ESMTPSA id x7sm16297631pfa.107.2019.12.06.05.43.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Dec 2019 05:43:29 -0800 (PST)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org,
        Liang Chen <liangchen.linux@gmail.com>
Subject: [PATCH v2 2/2] [PATCH] bcache: __write_super to handle page sizes other than 4k
Date:   Fri,  6 Dec 2019 21:43:14 +0800
Message-Id: <1575639794-30056-1-git-send-email-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.7.5
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
 drivers/md/bcache/super.c | 56 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a573ce1d85aa..a40eb6335cb8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -207,15 +207,43 @@ static void write_bdev_super_endio(struct bio *bio)
 	closure_put(&dc->sb_write);
 }
 
-static void __write_super(struct cache_sb *sb, struct bio *bio)
+/*
+ * With 4k page size, the 4k super block will be read in at offset 0 of
+ * the cache page. But it's not the case with larger page sizes. For
+ * example, with 64k page size reading in a 4k size block will cause the
+ * cache page being divided into 16 equal sized buffers, and block 1
+ * to be put at offset 4K in the page.
+ * Thus locating the super block again is nessessary in order to be
+ * compatilbe with different page sizes. And the page is held since
+ * read_super, this __bread should not cause an extra io.
+ */
+static inline struct cache_sb *locate_bch_sb(struct block_device *bdev)
+{
+ 	struct cache_sb *s;
+	struct buffer_head *bh = __bread(bdev, 1, SB_SIZE);
+	if (!bh)
+		return NULL;
+	s = (struct cache_sb *)bh->b_data;
+
+	/* The page will still be held without this bh.*/
+	put_bh(bh);
+	return s;
+}
+
+static int __write_super(struct cache_sb *sb, struct bio *bio,
+			 struct block_device *bdev)
 {
-	struct cache_sb *out = page_address(bio_first_page_all(bio));
+	struct cache_sb *out;
 	unsigned int i;
 
+	out = locate_bch_sb(bdev);
+	if (!out)
+		goto out_locate;
+
 	bio->bi_iter.bi_sector	= SB_SECTOR;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
-	bch_bio_map(bio, NULL);
+	bch_bio_map(bio, out);
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -240,6 +268,11 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 		 sb->version, sb->flags, sb->seq);
 
 	submit_bio(bio);
+	return 0;
+
+out_locate:
+	pr_err("Couldn't locate super block, __write_super failed");
+	return -1;
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
@@ -263,8 +296,13 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	bio->bi_private = dc;
 
 	closure_get(cl);
-	/* I/O request sent to backing device */
-	__write_super(&dc->sb, bio);
+	/* I/O request sent to backing device
+	 * Needs to put the clouser explicitly if __write_super failed,
+	 * because the bio is not submitted and write_bdev_super_endio
+	 * will not have a chance to put the closure.
+	 */
+	if(__write_super(&dc->sb, bio, dc->bdev))
+		closure_put(cl);
 
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
@@ -312,7 +350,13 @@ void bcache_write_super(struct cache_set *c)
 		bio->bi_private = ca;
 
 		closure_get(cl);
-		__write_super(&ca->sb, bio);
+		/* Needs to put the clouser explicitly if __write_super failed,
+		 * because the bio is not submitted and write_super_endio
+		 * will not have a chance to put the closure.
+		 */
+		if(__write_super(&ca->sb, bio, ca->bdev))
+			closure_put(cl);
+
 	}
 
 	closure_return_with_destructor(cl, bcache_write_super_unlock);
-- 
2.17.0

