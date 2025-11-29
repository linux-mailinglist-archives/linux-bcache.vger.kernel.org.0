Return-Path: <linux-bcache+bounces-1296-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3B20C93AA9
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:04:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11CEA3A7B57
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 184A9287254;
	Sat, 29 Nov 2025 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KvKEnGEd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7DD286D72
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406930; cv=none; b=ZJbDBXRSpB6NOtZFzWvFqDPOhD6bqp0Zzat8J1re3Ad9ePSvHHN+yf5qlgfCW9Pnjo49Ga7gR3TRzm2/mtlujqHfDj+e295m2RZ1rT9RZB9h8GxdKV2k7qcegGPjJF4NmSjXYKeKOhvK4hxTG4ntBTpYe8Wlo6D8EzZyiESpfY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406930; c=relaxed/simple;
	bh=FvdW5UGbfZbg4/JUFTbGCNNccxPDUjVX1PnGr5SdWKY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XMeVN1MFT5b8f2wudp5tdfbJm57Mz6IZlXNdDDt75lVbJyEjWMKeWBdQZyi4PrZAPEMnQ5FQp1Z6qOgG4qK/0vy8meV/GjAkBU+28EwxObw0GpqdkoQ1EcTOKT2WqhK+b7bNT23akdGDLlvEMrlwIKmObVUv+P/Ruyg4BEf47To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KvKEnGEd; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso1910732b3a.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406928; x=1765011728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=KvKEnGEdxZOSVJvpCWC96O0Ouki17yejWWuNkFLSgXJESMxTCcKV3R5H8SiECddFGo
         LGgoM6c3NM3wzleQDd4n6wah6ACk6oVNxDv2pALM/R6draIEob3rNiwrBDCvcUdHN0RH
         R8vThgv664gFfv65bawW5akKeAjAD2zYwPHiksE6BWz6TnsFp1Pt5nhsENWIrUBd1f4p
         HxXvsQVMYFo/IBJdJop0L94t24qoYhCNG8Y5+RtCoE+xOE1KEdWdLKJc6UfrCHrze9vz
         iNUNPYBy1qMNiCvKkwQNvBtxWKyMISN8HzFWXwaANoc5YEux1i8a9BOfNudlqzRF3QF8
         Zmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406928; x=1765011728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqwLZMa4ASc5Rs++C65X8rlK3EmN43I2MLDa5i9050U=;
        b=EDCZuCRA+0k3DqW+prJaWSjsiuXo5PLkMsZprdpFZ37E72agHHknzMliAnO3rb1JPl
         VANPPXInoL8Ab+JTKwz2oWFTzks24t77z5ujesM/COKe6VnXYb6zuStyC5huXczqO5Ln
         8jrb99fpPS0SHHPBEp5k0BRoGSLnro5DJ06q1p7czwIyE92XZd6bbYl78NOodEXyQEDr
         KE5BNFeQfipwXNM0qMgoU0kI5WNN8e+0eeCh90xfCZwAQBG15DMt/5kJR86zJ9MHxI9Q
         8+gnw1rQvK49BxKjG3SsC+POcOuc7KAatXjbp5C6FrVTsFRDR0BtOrollleEOz8DctAr
         2TWA==
X-Forwarded-Encrypted: i=1; AJvYcCUP5uP0Cecqj4jYF5kv3TaKkRtR4Fej6mOxLRofO8crLCi1gPSYys3vVSHfLfluyak/oPn3FxhT9q0UbY4=@vger.kernel.org
X-Gm-Message-State: AOJu0YytEq90aTmUJxi+L9pum/zYV/DIIH86iPr8psYnfjCQY24oQ9S1
	jvCYgeGzvnZKp62yEK4cod3caI3j3etQmdiwfDjIKACF7DZMwcgMP0LQ
X-Gm-Gg: ASbGncu6NkycyhAvU5AJsYJHPwAaK+hxiS35QB7fxqulpVRca7awS+0SoOZ782hXJhI
	b+YxrmBo/ljDAiuL2aBc+48PNE9C4lrXAHQTuWpoS4e9G5HQme6htqSvjns1It9j+YyBaMIUJ2W
	/RDjFn2XsDtggstGkNDXaKA4sDlO5EsNv+YdSpnRb69LQgYq3mnP+r804tHFD4qNghGmo/i8zAH
	tXxfR/mtASZE52VK4ZEUXYyh5A7nL6V4KlPn8bvtUb+BzX5hTg8g9UnoUXROaD1lt41avi0m+iO
	VaPPsPWBiEz5ymNUpHSqEtPx925iAgWTYgcsySFR6ajXcsmVWjuhsylgffbE6XOt+q9kX1ImNU2
	YKAtxXCsbKASsaqLTLW4eJouTwW61hmEPUQy6GuLm/LDY5g9cXK+5cAc6B395xU9a9cRhUkJpLg
	ykFz/eFkvkgb7Ln2wL2uQ3rDYHfA==
X-Google-Smtp-Source: AGHT+IFpam2VF00mu2rmyIi1m2lRR+Kb7w2Y0p3kOg5DIMgR5i6hM310V7yybDkza8FyIBCJgjbVWA==
X-Received: by 2002:a05:7022:4186:b0:119:e55a:9bf8 with SMTP id a92af1059eb24-11cb3ef2761mr13917973c88.20.1764406927773;
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:07 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 7/9] fs/ntfs3: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:20 +0800
Message-Id: <20251129090122.2457896-8-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
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


