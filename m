Return-Path: <linux-bcache+bounces-227-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 204AB82D085
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jan 2024 13:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C22971F21831
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jan 2024 12:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C684626;
	Sun, 14 Jan 2024 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="bRAx5uAs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-29.smtpout.orange.fr [80.12.242.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C0420EE
	for <linux-bcache@vger.kernel.org>; Sun, 14 Jan 2024 12:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from fedora.home ([92.140.202.140])
	by smtp.orange.fr with ESMTPA
	id Ozd6rsmrDIwxKOzd6rIDcl; Sun, 14 Jan 2024 13:30:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1705235422;
	bh=wwWONP9bo1w0znM3ZxH9vYALPKyLiU5MQ76GyS8w0gU=;
	h=From:To:Cc:Subject:Date;
	b=bRAx5uAsbztrq6HNaUIFHM4PsD8TISoybUJuyHs7ZUlEm10ylRs6N/Rk1Hir0olqF
	 JyNVQidn64ec884JPQI7+HSHmjzuQUxpjynqYEiKW0+AeaU0iLk5cQ5KAmxU5IkgWW
	 MAXcRSHNeyC5p9wsQxiFE7tK69br9NvUJnqvw9Tg+3bNpWOP/j2NjdQJHyMlc9HsGT
	 7f+umyckOa+kmUFVsyXPZNDrMlo4X7CqhBnACUtHw2l3CUM6d6Qw1hXaCaekQ5if7w
	 mp59wq+RDHiiBLAGZ1r1YHmXIaKe4rgX6LirqXP6M8vaJOQ8+SThAubwIcPrXQiabg
	 vhmTSgRu90t9A==
X-ME-Helo: fedora.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Jan 2024 13:30:22 +0100
X-ME-IP: 92.140.202.140
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: Remove usage of the deprecated ida_simple_xx() API
Date: Sun, 14 Jan 2024 13:30:16 +0100
Message-ID: <2f038df3860c2f44d5c7f5d06d03ca663cdbc651.1705235398.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/md/bcache/super.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index dc3f50f69714..a2eecd1db126 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -881,8 +881,8 @@ static void bcache_device_free(struct bcache_device *d)
 		bcache_device_detach(d);
 
 	if (disk) {
-		ida_simple_remove(&bcache_device_idx,
-				  first_minor_to_idx(disk->first_minor));
+		ida_free(&bcache_device_idx,
+			 first_minor_to_idx(disk->first_minor));
 		put_disk(disk);
 	}
 
@@ -926,8 +926,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	if (!d->full_dirty_stripes)
 		goto out_free_stripe_sectors_dirty;
 
-	idx = ida_simple_get(&bcache_device_idx, 0,
-				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
+	idx = ida_alloc_max(&bcache_device_idx, BCACHE_DEVICE_IDX_MAX - 1,
+			    GFP_KERNEL);
 	if (idx < 0)
 		goto out_free_full_dirty_stripes;
 
@@ -980,7 +980,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 out_bioset_exit:
 	bioset_exit(&d->bio_split);
 out_ida_remove:
-	ida_simple_remove(&bcache_device_idx, idx);
+	ida_free(&bcache_device_idx, idx);
 out_free_full_dirty_stripes:
 	kvfree(d->full_dirty_stripes);
 out_free_stripe_sectors_dirty:
-- 
2.43.0


