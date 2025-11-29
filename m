Return-Path: <linux-bcache+bounces-1292-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AA065C93A67
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B29934E4209
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A60BD279917;
	Sat, 29 Nov 2025 09:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QiV5+N+K"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A49627B4FA
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406911; cv=none; b=eaMJ0WISEk/YgHP+vOd1n2s9zMpdvLVEB38WJB17NcJv9j+dty4i1S4NDGKLH18G7AvC8oE4AHjZeM8/rQn2w1EZpGEdTl7CK+T15SWYkWzjtiRt3rvzD2Nv4GQkbi5ghNr50ax7jt9Na4CacKqinMiuUjOC4s4QU12B1tcmXaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406911; c=relaxed/simple;
	bh=b80xEn7EdjxWTN/ci1ysQxp/kAR6AhTP55Nuwyj6diA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l8e9ZtKzBKj7hqZugGy3PtWNACa6Rh4h1tnHZuEv5cL+I5obH9yeacHQFh4NPxh6ws9aPttF1W0N77cBToaFtQOirvSGVUuh8Qv0o509FcrKDCQCnlOZDCTH4E62JsOHzXpIaIf0avA7o/p+iUXrswz8UzhW1HDCwc80VPay7Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QiV5+N+K; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7ba55660769so2181663b3a.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:01:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406909; x=1765011709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fxHcLru6xJPrGlRM61sm3BLmSBVukho7BhSnyNPRbc=;
        b=QiV5+N+K8rvRLBeotMRxe/ceAipnmm4/K5XqUM9OFWx31hIlK6IZHh5SfP6vTbIT3z
         Z+HDEC8rJrsSImM8J/c3LXbLeMkemS5zgfgijEuileBY7KOVDiMbG5dSZYXtpkuV38is
         dXgCZD8NV0h3nnw/ZdQhxhkVbwOLDCAvObTBfh9MxNTN+js7T6IUtvvtL+lBf4h1xFyi
         sZHodfUm50tGwTYUEMPTjRJ1JrzOGkXJ+AMJ1viFrI0uBKsOI4WI/bkgqn7nFOFQ2ifn
         uDArfq6uqsHHo8Ts8Yna3i45vAnZ7mqN9kaEXwvif4nYBAq/6KE/UlXA8mR/DZaGWX8D
         rF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406909; x=1765011709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1fxHcLru6xJPrGlRM61sm3BLmSBVukho7BhSnyNPRbc=;
        b=vJyYOrpDX2wjX9Ze5g3PPo0LsjjgxD0K93nZ1biObH89PB1RmbPhEsSsf/4EKMkohQ
         4RN6nOH5IjdiTO5GXhoJgfMU4lxNlaLBdKdzjjOQLOImLnS7nLC9Z46Ik1wXj8o/4Nm1
         NYqT69VYH/AzclFvIwO29UziM9/b420YZ8AfakG4ppDND6EXNCpGYRBD8SD94TSLvW2W
         OntYRGiXoLhYjVMa9Jy1AxSRbbyV9QMVpL0i6NK2XfYiBETc1d89ucrTVERxybijJhKW
         OH5BgxycUw6Ku5zHnCRsiVx+NC0ye2zN+8COVup9n7xqwMyx8Rgb8eWlIBiGitAi18T6
         aoIA==
X-Forwarded-Encrypted: i=1; AJvYcCVTxjZ6Bp5OlTRZ9m6m5wSrrae1SXWCvzgGlSAdfU+iqJTqaZHBRnbOY6aOqIORs0rVqukoaLdnQN1kCS0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwkjxYbbEBuffa/KrudT2bnphuxQmFM+ao7d70wqs3DsB0dStnj
	F+AIxrqTys3aZ0m5FaNkzV+cWaP7PylnrzgVQRvJyTaW+fFGYLgOiFdK
X-Gm-Gg: ASbGnctVHYAKQOFVhIZ8uaaTHe6FimOAt/1b1s6FdE34ZdyR2pW1J31+WbDnyWniULw
	sCUnf1vT9Be6OsDzoA0ryxBh1/sicl+kQ50OlSJUJneBmtuhyX0E3KlrfICTFBkrEYrrmu4rgs0
	SVp8KBhSpX9kaYN4tT+BjFWbQCrHXjmF2XNgMBXZZj/Az8vIGSv2MSE24I8MBGWMYbQTRuzOuux
	n/lUq7ruuNk9m3LXWrxYIkEcri2lvii1ASnBW598Nwoe9GD+2vkXIetz59nr3kPbEuRPAawvjrz
	6lDVPDlwyNJdyahtxWs3Nxl1aYzRoWNOR0ttxgI8qVDeDq5QDui8fTZa7+mr/uu7lYrWBw0yqKj
	JbkDQBD286BgZZ7ReI/a90xYCgL/0QtmuEjpg6MFyRPsOG7pV+93WF82jD5P22Cd9XClthYanJJ
	Xv70L32WGrP++osIULpjL3e9AuJg==
X-Google-Smtp-Source: AGHT+IFEuvilLkDJGqcsWwCIedr283xueadWd1RQPKrotWNJSiN6yvq7rXU8DgdpE+SxH743dNudrQ==
X-Received: by 2002:a05:7022:221a:b0:11a:2698:87c8 with SMTP id a92af1059eb24-11c9d710498mr16125897c88.1.1764406909336;
        Sat, 29 Nov 2025 01:01:49 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:48 -0800 (PST)
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
Subject: [PATCH v3 3/9] block: prevent race condition on bi_status in __bio_chain_endio
Date: Sat, 29 Nov 2025 17:01:16 +0800
Message-Id: <20251129090122.2457896-4-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1b5e4577f4c..097c1cd2054 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
+	if (bio->bi_status)
+		cmpxchg(&parent->bi_status, 0, bio->bi_status);
+
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1


