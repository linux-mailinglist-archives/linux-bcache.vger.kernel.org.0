Return-Path: <linux-bcache+bounces-1271-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 915FAC91349
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 688F634D0A4
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3607A2FA0EF;
	Fri, 28 Nov 2025 08:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce9ysQET"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1572F9DBE
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318791; cv=none; b=F35zs+j4gUJGpCoJjwnml2rJ2T54Eatkfn/B9J2cqTTxZr4d/RE1bwcD2aVjtPt3vaq3uFNuII3AaUxUqjW6SyAjdq/iaB2EGqaurOpyhF4be0R0cQ3xCl+eiyKfxog8XXvE9T+/+TSaN92vStTIWwlyCJfxF248TYMUuVPQ4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318791; c=relaxed/simple;
	bh=eIesZROL2LjNY0DrQ6P8R8b1cwhdKxEhWtmo1wbXnYQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Lk4SzM2AssnHlEWGciG+qyvsCDvhCU6dC/9GVcRadH+RsGdEHP0K7OgsaZg36ycGzy2+P51WVAGMcqh5J+BZtflbpnpTFEs9LLacwjn7J3en4pr88PTkgj1TV8WK2ScDHk5N0/C/fy3vy4tq4+jvnnyHedXmEyIto2Nuat9+WZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce9ysQET; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so1826094b3a.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318788; x=1764923588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=ce9ysQETKpds31mQlC/gwbVsfJvDaNd+gtcQa/DCXl7VkYjf1HLWaPhHsipNj+B4Rp
         rrj5KrI+u7YYGxr0HrmM/ZZ7Dv6R0fnJRYF6g5VRxqneCfn0sYkgTcYKSBkJY5PP0CRN
         C0TMBq5qEvlPFfHZ7+ndX4282E9/EnTc6IwZ2vhF/jIBI/A8CxkhIxf23jCs3A6DcIQW
         15uPeYgKnsVoObyd2m0PLj2iA00v4frkuEyUm9Rb2akgidbrTHI5JeDxZ54VSR1eoryc
         hpfQh1VTtH5Y/D9koUbayRviINOw8Kn5PHKXECaa3ceQKiQ2Mqp3mwPpJfqIiJwQRITw
         m9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318788; x=1764923588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PAlkzqFb5MzFCJaoNDunPaLLzQJH14gDGKiKCNGaT3E=;
        b=OAj1WhSaR0dGegp8d95SoQYyi1KvNyKWFWThIYs6YQcjQagmDUhpyP+EnGL4bWOvqA
         /mLnyJAKgXkYvKroPeC6urNUxnELTWTLHHlISG3Znxsq0EWxlkiq+VLIUlYIC2v3AZC1
         XmPR9ZXM51Wov+rhser76xLqeFxXAwmCzQ21quSwbVreVL3TnNqkMGmVb264CUMkw5f+
         jEqx2hUS7jV6nY4AodUrKiFDm/rSuEP9ITAO5rMcwVKKO9va52EvdpUlUMScZSihdE1+
         tKVOSLCfYvOMnxWQhfudzfY+NbbWuGLV4vEPQKZ1H+q85OuIkkjlxRsZqfvxX7Z0KVyD
         sIRg==
X-Forwarded-Encrypted: i=1; AJvYcCW4puTp8WmVLO9RgGBkOrDK3w/W1R08ps3XBKaLY3+ZdiBwOfaRiUQl349SHDgqLc2x5ORyq8bfi2lhuKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDLKKJmd5SLVrekqxPpt65uygGK589+UHIeSzpx1WK81ADLOdJ
	vLpb+ditQCN3Hg0xkQjX0vKUhxyRBWg7DS7UBmi9PtXnB0rqpEVnM56V
X-Gm-Gg: ASbGnct/RMK4TXjo9wmzqyh5HLzYy1fDUk36iyJZEbSCH4E0LLk+Unc/4mt5wwygY8X
	DKwxKMShML5cuAlI3A0K8+ZRO57VaQZgCGv+y0rHu9Js2ncy9QisKcp0bWixM7461tm+9Quz02G
	YXMs1e28czH5E8J3SzdUCeJP+ZCGkRnJtRFtHtrZNDN1vBl3fXx7DRng1WXuwd2sEyY3+OEIe9c
	/hT4jTnuJsd/h9QO5XVIwVs+e0Jy6W9RsMtW0gBpi2Ekt2Sl1rp/4O47NHwr9veyvv9ZVyMSPqX
	kYTZQEt3m1xyLwMmuDwVM97RQtHpPvXMSHYsfoR3ZwkTPBZv5LYKn2Fww45u1vbJU+0G5ugEagX
	4mdnR9EgJeyZcYTOQWUwgtVtjNh43D2D5o7gwIzxeaydWxJpAZMzC6IDuqE9JTp+tZxwS3HaMnE
	SojDPXq2QoYN1CrnZF8jVgowsvbw==
X-Google-Smtp-Source: AGHT+IFIaFCQuKpxcLcZ63tEcOt0hGjrfoUQN9LWUQ2kBfICDUhGuL68J3zsB+mI5c6KDSWUdB+sFw==
X-Received: by 2002:a05:7022:670f:b0:11a:4016:4491 with SMTP id a92af1059eb24-11c9d84c6f8mr17988575c88.24.1764318788462;
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:08 -0800 (PST)
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
Subject: [PATCH v2 06/12] gfs2: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:13 +0800
Message-Id: <20251128083219.2332407-7-zhangshida@kylinos.cn>
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
 fs/gfs2/lops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 9c8c305a75c..0073fd7c454 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -487,8 +487,7 @@ static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
 	new = bio_alloc(prev->bi_bdev, nr_iovecs, prev->bi_opf, GFP_NOIO);
 	bio_clone_blkg_association(new, prev);
 	new->bi_iter.bi_sector = bio_end_sector(prev);
-	bio_chain(new, prev);
-	submit_bio(prev);
+	bio_chain_and_submit(prev, new);
 	return new;
 }
 
-- 
2.34.1


