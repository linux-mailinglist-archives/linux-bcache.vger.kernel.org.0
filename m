Return-Path: <linux-bcache+bounces-1132-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2564AD9579
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 21:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87A267AA6ED
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Jun 2025 19:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9853B293C55;
	Fri, 13 Jun 2025 19:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RqsPkmAd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5BE293C44;
	Fri, 13 Jun 2025 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749842389; cv=none; b=K58kenm948/DSiNeI/ZhDATPRzhHykeJgRnErX6HjeUj98nakmuUPI12S3+80bfeFLt9zxd2dppzKdP0ZsIuVeWKMhnijM2m++DbEXH7POEtls2PDaWmGdqoRcVpU1HZVx/vBaryR6djM1HGC/A9s5me4nDzB3k0Lc0yCrP3BJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749842389; c=relaxed/simple;
	bh=n2BDf5mMcnBKVe5dxBtOScq6uwxcfsr7fsdeqTPatNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PTIIv8565Wc56uQdYw3neNYmye1dcFfMIwiHf4gZHu7oaCPmCQl74Z+3jIV4fkThJAmpkos74UXum4BuwYXlCr3mXmMXCxvCvYO7bsBNfMplMrKj7n35/NwjJ8EJuQlO5DffWmdqDBJdbbwvZEc5fEKPCOdMlxtvC10KRqNbtc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RqsPkmAd; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=TkOFbauvzCXJHwA0lhC4SCDt9ja1fwf0WBrjpXqNJPQ=; b=RqsPkmAdtdKYrHJLBDSu5+zm+h
	uGK0oV1C7UKQcWF7PYpK95kJcT/1RnytI1KUhlGTFrVrQdB6m4raUZqXs8EK0e00ac+LklOHgOX8K
	pExcWT57uG4i6BComDySKqGVTtxLa+2cASmaZDQ+68gDauE9yRnqVP62IoU8+N3OT9EULlK6mywWx
	YdR+C6/Ddd9+H8Mg2MRBOlmdlRbZ7xKajKu3EOKwbLHk8OvIOSubcE3+cvPcMgeZDpgOr7VcpZGtX
	ExrMRKPvsAUPx8UASeASX80OHiJG4OLxReWR4FDnZlAXq602zGhFKfUVbG/xwJV6xBvvrVYanqwXX
	nC2UpO7g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uQ9wH-0000000DIaz-381b;
	Fri, 13 Jun 2025 19:19:45 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Coly Li <colyli@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH] bcache: Use a folio
Date: Fri, 13 Jun 2025 20:19:39 +0100
Message-ID: <20250613191942.3169727-1-willy@infradead.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Retrieve a folio from the page cache instead of a page.  Removes a
hidden call to compound_head().  Then be sure to call folio_put()
instead of put_page() to release it.  That doesn't save any calls
to compound_head(), just moves them around.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/md/bcache/super.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1efb768b2890..83c786a5cc47 100644
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
@@ -2215,7 +2215,7 @@ void bch_cache_release(struct kobject *kobj)
 		free_fifo(&ca->free[i]);
 
 	if (ca->sb_disk)
-		put_page(virt_to_page(ca->sb_disk));
+		folio_put(virt_to_folio(ca->sb_disk));
 
 	if (ca->bdev_file)
 		fput(ca->bdev_file);
@@ -2592,7 +2592,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (!holder) {
 		ret = -ENOMEM;
 		err = "cannot allocate memory";
-		goto out_put_sb_page;
+		goto out_put_sb_folio;
 	}
 
 	/* Now reopen in exclusive mode with proper holder */
@@ -2666,8 +2666,8 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
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
2.47.2


