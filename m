Return-Path: <linux-bcache+bounces-1148-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0463DAF08AB
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 04:48:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF58B427473
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jul 2025 02:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762FC148827;
	Wed,  2 Jul 2025 02:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPOjd2e7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8C38F77;
	Wed,  2 Jul 2025 02:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751424535; cv=none; b=fIeEr8xGcQKqgu+ap3bMka6/bmHpSesa1t6SnNICCNwHhnMhxVOfp3mimzqs7YSMh7OMkmjZB8KOmNNwDwRQb0FhRz3VR+LOaHxZqPOzCKbvObGAAJ7gm7r9RVCvbPTA0jmOpolrjl0GqT23Sb+2JcOTm49kcCNpvX0W7rXmzww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751424535; c=relaxed/simple;
	bh=JAAbqWGv4REQ2vnlHSGHaQ26VgMhGov5LdNX9WqxvLc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IZ7tJ941Wx7zUMxOfZv3NkDL5U4JCZFm2Jad82OGTMj9vX39VgRu8u5dVj2iUCFtDz5HoAUWqVVkVLJiuDG/bxGihMdBPelJ+GQRoDnfMmIISAh0b3gMzrGg5VceDgWK/LlOtGlk14dG5Q8QvyOHSLpvdVfeYRSMVHrncAPYFUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPOjd2e7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C90C4CEEB;
	Wed,  2 Jul 2025 02:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751424534;
	bh=JAAbqWGv4REQ2vnlHSGHaQ26VgMhGov5LdNX9WqxvLc=;
	h=From:To:Cc:Subject:Date:From;
	b=GPOjd2e7nUjWJRay1KXvbqTy4EMUZwOLlztOE7NpMBaUMmyE5oDBXLsO6DDf8TjKA
	 Hj5YLl59pnO6LCQf9HI8538A+YFToy+bF6LJg6E1wGNIVj/5TO+OfArTxShGAAs80S
	 EyoNc5YeUVxd/YsG9rLq8wooGzA9LZmRTG8tfauI/98x+x2x5fxNlIyC98XBQWm0nb
	 MBIh8CoFS97ZXnqptV78BDtWdE7SKIv4RnAWA49a0U4NhTIqtFnFtWNFV1iUv9pUOj
	 X0seTxwoaW7wPike5pWFiLaMJX71ocpbSUhrGyH1mmaAuTK0Y4gBZ6+tKvbs24dvap
	 AC6aZsJ02QKAA==
From: colyli@kernel.org
To: axboe@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	Coly Li <colyli@kernel.org>
Subject: [PATCH] bcache: Use a folio
Date: Wed,  2 Jul 2025 10:48:48 +0800
Message-Id: <20250702024848.343370-1-colyli@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Matthew Wilcox (Oracle) <willy@infradead.org>

Retrieve a folio from the page cache instead of a page.  Removes a
hidden call to compound_head().  Then be sure to call folio_put()
instead of put_page() to release it.  That doesn't save any calls
to compound_head(), just moves them around.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Coly Li <colyli@kernel.org>
---
 drivers/md/bcache/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2ea490b9d370..1492c8552255 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -168,14 +168,14 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 {
 	const char *err;
 	struct cache_sb_disk *s;
-	struct page *page;
+	struct folio *folio;
 	unsigned int i;
 
-	page = read_cache_page_gfp(bdev->bd_mapping,
-				   SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
-	if (IS_ERR(page))
+	folio = mapping_read_folio_gfp(bdev->bd_mapping,
+			SB_OFFSET >> PAGE_SHIFT, GFP_KERNEL);
+	if (IS_ERR(folio))
 		return "IO error";
-	s = page_address(page) + offset_in_page(SB_OFFSET);
+	s = folio_address(folio) + offset_in_folio(folio, SB_OFFSET);
 
 	sb->offset		= le64_to_cpu(s->offset);
 	sb->version		= le64_to_cpu(s->version);
@@ -272,7 +272,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	*res = s;
 	return NULL;
 err:
-	put_page(page);
+	folio_put(folio);
 	return err;
 }
 
@@ -1366,7 +1366,7 @@ static CLOSURE_CALLBACK(cached_dev_free)
 	mutex_unlock(&bch_register_lock);
 
 	if (dc->sb_disk)
-		put_page(virt_to_page(dc->sb_disk));
+		folio_put(virt_to_folio(dc->sb_disk));
 
 	if (dc->bdev_file)
 		fput(dc->bdev_file);
@@ -2216,7 +2216,7 @@ void bch_cache_release(struct kobject *kobj)
 		free_fifo(&ca->free[i]);
 
 	if (ca->sb_disk)
-		put_page(virt_to_page(ca->sb_disk));
+		folio_put(virt_to_folio(ca->sb_disk));
 
 	if (ca->bdev_file)
 		fput(ca->bdev_file);
@@ -2593,7 +2593,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (!holder) {
 		ret = -ENOMEM;
 		err = "cannot allocate memory";
-		goto out_put_sb_page;
+		goto out_put_sb_folio;
 	}
 
 	/* Now reopen in exclusive mode with proper holder */
@@ -2667,8 +2667,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
 out_free_holder:
 	kfree(holder);
-out_put_sb_page:
-	put_page(virt_to_page(sb_disk));
+out_put_sb_folio:
+	folio_put(virt_to_folio(sb_disk));
 out_blkdev_put:
 	if (bdev_file)
 		fput(bdev_file);
-- 
2.39.5


