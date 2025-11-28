Return-Path: <linux-bcache+bounces-1274-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D6EA1C91385
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:37:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D07873AEB7A
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5571B2FD1C1;
	Fri, 28 Nov 2025 08:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6Xjpoll"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200A72FD1B5
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318807; cv=none; b=nUm3TKd6771uAXFdclqT5G1fyRYKBR+Spg0+6VuOHVyF6qKYm9k5ny9JOcmNo1xF9oWJ+4urW7FCLeVh3Kn7kPFOdW4U3vyZX1kg3MGgsEHea8nfmbyKdHIcW0wU+VHSTsJQujMMdXOH+h3EjXFdrrDibYbnyfIX6zRHRhHNgMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318807; c=relaxed/simple;
	bh=FvdW5UGbfZbg4/JUFTbGCNNccxPDUjVX1PnGr5SdWKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kfG47DfZvmzEgUPLr3AOYDmqpEDeoqNFH5p4HO5Tcbqf5vreIqnDGB1IpZ21+dR869PzzDYE1obBTLEgobMNMHMu0kgVY4l165hburiiebG84pmlf/3/E4p5b12DOQASkxI5pI5Zv6+aV2DiWfgGBGLBAK4fi+xsoQ9eF72m2jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6Xjpoll; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7ad1cd0db3bso1331586b3a.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318803; x=1764923603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=j6XjpollDF9Iut3S1/uQErW/2sxW+N8CcUuDQzoQmuMybl717nTrXj6cfh71xPIO1w
         cGg8gj6xtBy2Ha1Ja4mMXDmjmI7QzWx9DM8uwwKGdOHgnR0FX74S3KCkjjWoKza/s5/p
         HpFHgxXY2jPJW0EPQL5Uq2BqUB62xBYhJ7bT6voop8KXn8iT4Q9H95YS0g5VyWeYL5VU
         sHSMB4UDkm0SEwN8SZoAptZVrTACvmWXwzyOUb8r2sITYgQQXgy15E+fR5gP/fsgWg7t
         2zITSEaQcTvwmuF04dJhuLJC2Qralkm5ouuqwz4FN6aTisgmPHPNHCtNwaAoytwmClQg
         Z2/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318803; x=1764923603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=ELm16sBlcQmH2j1piT6jj3hVnGiyTi0So3ijRQbd+WXrir9IdZ2ahRxPy2nVJkzf1j
         2ptxmMT1uM7x0uDHhuOFVSKsC4+BYRgoZmR/71OGdDDAG0gdZSV+Gvm0+r5C+ukY+Grf
         +ZmR/usaHAEMBm5S18vq50lgNSal2CGD5RjLV2ZiVrY+2ZSB89MbReSK+oExHdVyzAKy
         JnjYpRb59WsV6X6OvOaZirmc3pkKpvXKPAJALb5OPMhAzW5LLWo6qnzUvUTLEF0EGS78
         jVGenFmbcE52i9Lq1uEd8f3qD29749sYna8tbJu+dAbfzkLEN9mWdo+sct4VRHTDQn5t
         1KiQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3MzAvWdnYgoBjoqCxNzmUeQKmkrIImwdEUbAfYCQjbZV4RQ31RofgJwf7ncOwm/32wOYgNe8/xfqeW7U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw95iQKUGTKRDlGBfJNxmykvL/vBmTCNShsqyVurPg86ZNE1VB7
	kbc8uJKy8Uv/Vh7R0+/kCJ6gYe/zTHqe9VfAmPXCd/Zyc4/KxVMKity5
X-Gm-Gg: ASbGncvE6UUhwS9tUv2qm1uXjUpsCtLdTBacgekJ01k71+xekzlaCjoAgs/fWwei+O+
	f4Hid8Q7c1/Lcogng/iQALkgmd6nYAdgY3AEPRDeqNXYXRrVWlw3W5rohGggwI+O0aDk41ja4Kv
	tst2Z25EUF0WE1GhmTWdoMgA00qPKTZgtmWNaNy48Pa3qV106ywc+SEzpzHR4BJPxSNn7+1errd
	mbt5PPqEALkTni3UQL06wBOp7biKPgqIyo0milv4OtNDUf2rLjLMpIabkrLR6St6yF/RZjce4H5
	/SnEtDSMYQ6qRx13mQvKkD2JF086fJPa3dhaOrC385QWtOXsPAVqMnCmNH1apAnULrHSytfYl7J
	X96VkjmpL25C7dch0FbpjT3gU+2smvMB2xq1rkTgv3z6JgkVHwwKce6/kNVPe8CPYfdTyYFSb+0
	9aaaP62yFrLkuxIyUdsTgttmuVGw==
X-Google-Smtp-Source: AGHT+IHfWqQfXtBplCGUlpvV4df9l3L0Dj70ayVkP4asUXlu5VvYmL6fwPY6gq5t6aD4a2b+6FhgOg==
X-Received: by 2002:a05:7022:2487:b0:119:e56b:98a1 with SMTP id a92af1059eb24-11cb3ecc3f2mr9865235c88.8.1764318803303;
        Fri, 28 Nov 2025 00:33:23 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:23 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 09/12] fs/ntfs3: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:16 +0800
Message-Id: <20251128083219.2332407-10-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/ntfs3/fsntfs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254..35685ee4ed2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1514,11 +1514,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
 		new = bio_alloc(bdev, nr_pages - page_idx, op, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		while (len) {
@@ -1611,11 +1607,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		len = (u64)clen << cluster_bits;
 new_bio:
 		new = bio_alloc(bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		for (;;) {
-- 
2.34.1


