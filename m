Return-Path: <linux-bcache+bounces-1356-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA46D16C40
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 07:09:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF88B3015EE2
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 06:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5806835CBA4;
	Tue, 13 Jan 2026 06:09:46 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB24A41;
	Tue, 13 Jan 2026 06:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768284586; cv=none; b=iocUYCoQ2b+0q1LgX+EA/+zwXSAFdfh07yShCtO7GgxBX9hhr3zd7iyR99xxmUbKOizB8Ns/K3bjGXKZemDYlrySUlVCS2sThAGAPMK4aqWjwnKML3+Y9ic6AcLiCL/DVMoqvqf8GknW31rB5mJvBqNfA2bpsEp+Lc+Ir0nqhos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768284586; c=relaxed/simple;
	bh=QrBh7daSFNi/7EAFHUTPme5aIJrX7Un9PEk4Q/kgSnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Iutg4etMApiPk1si6OwTiGLd2ljUl1WWNJT9ezpEHcglRmnfIyOCIGV3JzK2nirPcT6mDsfj0LPYdVKkowAkeXtdxxSiyfkAJZSicr8Rb4+O3kDIIcUBNjOC7zQpBjVnapM6NuFz+O7+OqTYU+shOkszN9udKOOD07xdilqFpKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205E2C116C6;
	Tue, 13 Jan 2026 06:09:43 +0000 (UTC)
From: colyli@fnnas.com
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Coly Li <colyli@fnnas.com>,
	Christoph Hellwig <hch@infradead.org>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Date: Tue, 13 Jan 2026 14:09:39 +0800
Message-ID: <20260113060940.46489-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

This reverts commit 53280e398471f0bddbb17b798a63d41264651325.

The above commit tries to address the race in bio chain handling,
but it seems in detached_dev_end_io() simply using bio_endio() to
replace bio->bi_end_io() may introduce potential regression.

This patch revert the commit, let's wait for better fix from Shida.

Signed-off-by: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Shida Zhang <zhangshida@kylinos.cn>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7a..af345dc6fde1 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio_endio(bio);
+	bio->bi_end_io(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio_endio(bio);
+		bio->bi_end_io(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		detached_dev_end_io(bio);
+		bio->bi_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.47.3


