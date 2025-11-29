Return-Path: <linux-bcache+bounces-1298-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D938C93AC1
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:05:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 132933A9031
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F7228727F;
	Sat, 29 Nov 2025 09:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWAD7FOh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0396328BAB1
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406940; cv=none; b=PHavIRrwTL9sZ1uz1n6FUciedUlJR/7AiKY1TwHL1wEyqQn1iH0CR8h0vxakCz0sdrhP+PYl2ltuUTxb6fwSgyrJNUKI1UhB0MOSA46ByPZfjxar+90/faRvQM/+Hkmq/TifGhFlrG8rAS4++ypiVSzjzPx4dz0hpSIvHJfDsWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406940; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EIX7S9zsVhKzizBpEptHkyyZM45oL9XHk0W4GvFY0nXthJyt92DuFU18iWKcriZckMvIbdnsuJ3yHZERSjw3eIuWO4Ex0dwrXlWsFZzN1gSyxqCojZ88BQop1TkH8UNafdLfneoCnWBjAFS3+RUNQGh55FJXOwKzLrLvyVASSSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWAD7FOh; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bd1ce1b35e7so1833215a12.0
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406937; x=1765011737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=LWAD7FOhwxa9hK+N/TjbMpaozNTbYaOFlFfBFIkFx3IRXMvFPQxK0dBvqeuprMX8hQ
         WtWIKhyhJdL7tgKbRz4kjA9XtQ0xCyuZ7Us8cRZuTSRdyYizUVED7L6DNAzm15FBB5+X
         G5asqaq3DDVlM/G0dBAPwI0DSmb1ll6qtEwsg2iCDXZi+WJJDMh8w+iMQwrmlH1fUp0M
         ZU8ghg2rx/1HT1LpWHFAMP66d0PvkRhjwjyR9UzTcYnZTtVjAi+zUY+A8WK5JSkbXJwd
         i6e5F7qsIkGgfsqQ4oj8zEgP7PtrSoMRVbyWUr+snjj7SZqW95SR+gLU9WacDEe61W7m
         +8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406937; x=1765011737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=U/ib6lznJo8BuJrUgDmAsY/roUjn6Gf1vUyXdN6yUUIY02fWHcfEFKrSwMRXWAkUOD
         VUuzIh4Exp8faGuqfhSuBPt/l16jFt1fCHkApyOel2OsrObFhfTfhP1eBUgG3weAx/4O
         pUdwmoKG2Bfdsum5knZlqnzCW4+Gc7jX7ocLlFPcuv47t/5Qfgz+FzEjh11/S/KJWiib
         lHFyDjq2H4ugq9DNr1OEQkh7roBddNamZKL3eYK8+VjyZMeI++6M9PNntEroH14XRpZq
         H04sQFAoPCG5+nPHahsN0JLIEhFjSbh39KosfEs6R+EX6STjdmp4S//KLRNBdUyfRuHv
         5bEw==
X-Forwarded-Encrypted: i=1; AJvYcCV40y1839OPbtvUH0eYUTyAfs+pIN/Fx6TyFTZGpAup/Sxp27bVMhnG8MdiqOhgNI2VQTbsO2m89q6e6hY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEt8tUDTd1Zy/RmZUs2GQ+yjMsdTInG5zNJI3jmJd8l6u74r5J
	aEhP2hYDHdvmSbuiiUX8qnoi8QmFrAia4KPOusZSs1P64uDZYJYPfWwA
X-Gm-Gg: ASbGncszNRr9AxemcrudHYnvR9ZVOO6x+bIFenR1jXZsCKyIlZ4KS3rwdRABwlBH9ez
	Sv1nKuWeHpjiqBgaS6UZaPqAD2SdoL6kzcXbfMQ0F5ydcAqAj01fMx1l/ioOnpUwUZFUkhxLs3H
	MvqF9B7JqYJAFOq9qi8fw5PqySza4y2zzH+XiRET5zAMIoHy5lGTQy17Sg3K88xS4hV1IG/LhJ+
	1LIUuf8Hi66KKrUYBQcr5yBwfxtzUn8STn6YfHUXkTNEOrkwqrskibxDTvOABBRQHuldqbjAY+/
	NO4kcfTqzhJ/+gu6GMUA+8WM+WoLrSDvc4RCgDyItoy2Ymz+xWxiTpgOqp/93B0c8UhWQEROj2a
	bvUCtnZsJUlIpJMX491BITxdty3sol0z1CwsYkeYVpcFZzeHLHprWPc52pxO/ys+4cffdPg8oVz
	rg4un6v3KBFWY0Gqv+XknSidjYbo2ESora5jmo
X-Google-Smtp-Source: AGHT+IHpE1uuYkahAmmHKZA5JS6JfSHwBl8orO/VCsXf8iMEXJ8J7PutjW87+hKd6ib1GUoYGhEBPQ==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17984181c88.28.1764406937164;
        Sat, 29 Nov 2025 01:02:17 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:16 -0800 (PST)
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
Subject: [PATCH v3 9/9] nvdimm: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:22 +0800
Message-Id: <20251129090122.2457896-10-zhangshida@kylinos.cn>
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
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1


