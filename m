Return-Path: <linux-bcache+bounces-780-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D469BE2D7
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Nov 2024 10:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 580771C22F5A
	for <lists+linux-bcache@lfdr.de>; Wed,  6 Nov 2024 09:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEFBC1DCB2C;
	Wed,  6 Nov 2024 09:39:18 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-m10140.netease.com (mail-m10140.netease.com [154.81.10.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C51D9329
	for <linux-bcache@vger.kernel.org>; Wed,  6 Nov 2024 09:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.81.10.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885958; cv=none; b=A0kE0U8GWlvqoxIWtiVnhHHFKhyUu+KMgSLOxLNw56Q9fQJcb66wb0WzInveeonjoB+xkL0UUYZE65IA+kNqwAKpmnPZD+8KcuxyVmaZ9m75stKj3ZgA6mDZBIftvhQTyCJqIQDffJyYIRIj0i/b1cPNtVtvF13yONu6+eMcW94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885958; c=relaxed/simple;
	bh=VkU3b+1QXBrAsUafZGh1HLfMDAywJynmkJnIK9ipgYY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m1FVuiu5MXyNxTwxlRb7+M2QYWgMASvIF+GCbJ/06TLWoVcS/q5N5poBMYc9hxeq+K0f7h2/pMlFZKBeNAMG/dhewAg5V9qOsuqpVj4tvZO8kejC0zE6EwcmwBLYeRHV0XFMDnXRmp6XYyYU94TP1wx34Wk0gHwMaQZSfqatEXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn; spf=pass smtp.mailfrom=easystack.cn; arc=none smtp.client-ip=154.81.10.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=easystack.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id fcb52bc;
	Wed, 6 Nov 2024 14:09:46 +0800 (GMT+08:00)
From: mingzhe.zou@easystack.cn
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org,
	zoumingzhe@qq.com
Subject: [PATCH] bcache: fix io error during cache read race
Date: Wed,  6 Nov 2024 14:09:25 +0800
Message-Id: <20241106060925.900427-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSktDVk0ZHUNCHkJPGB5DSFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-HM-Tid: 0a930017e5a6022bkunmfcb52bc
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PUk6ESo4TDceThUtCxYoLwId
	OB4aCTBVSlVKTEhLQ0xISENMS0lPVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
	C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSUlMTjcG

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

In our production environment, bcache returned IO_ERROR(errno=-5).
These errors always happen during 1M read IO under high pressure
and without any message log. When the error occurred, we stopped
all reading and writing and used 1M read IO to read the entire disk
without any errors. Later we found that cache_read_races of cache_set
is non-zero.

If a large (1M) read bio is split into two or more bios, when one bio
reads dirty data, s->read_dirty_data will be set to true and remain.
If the bucket was reused while our subsequent read bio was in flight,
the read will be unrecoverable(cannot read data from backing).

This patch reassigns s->recoverable and s->read_dirty_data before
each cache read. When a race condition occurs, check whether it can
read from the backing device.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/request.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..e9cb3ad323d4 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -513,6 +513,7 @@ static void bch_cache_read_endio(struct bio *bio)
 		s->iop.status = bio->bi_status;
 	else if (!KEY_DIRTY(&b->key) &&
 		 ptr_stale(s->iop.c, &b->key, 0)) {
+		BUG_ON(s->recoverable && s->read_dirty_data);
 		atomic_long_inc(&s->iop.c->cache_read_races);
 		s->iop.status = BLK_STS_IOERR;
 	}
@@ -558,8 +559,9 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 
 	PTR_BUCKET(b->c, k, ptr)->prio = INITIAL_PRIO;
 
-	if (KEY_DIRTY(k))
-		s->read_dirty_data = true;
+	s->read_dirty_data = KEY_DIRTY(k) ? true : false;
+	/* Cache read errors are recoverable */
+	s->recoverable = true;
 
 	n = bio_next_split(bio, min_t(uint64_t, INT_MAX,
 				      KEY_OFFSET(k) - bio->bi_iter.bi_sector),
@@ -574,6 +576,7 @@ static int cache_lookup_fn(struct btree_op *op, struct btree *b, struct bkey *k)
 	n->bi_end_io	= bch_cache_read_endio;
 	n->bi_private	= &s->cl;
 
+
 	/*
 	 * The bucket we're reading from might be reused while our bio
 	 * is in flight, and we could then end up reading the wrong
-- 
2.34.1


