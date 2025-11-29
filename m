Return-Path: <linux-bcache+bounces-1291-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBB4C93A4F
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F2834E3633
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215772773FE;
	Sat, 29 Nov 2025 09:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvRXDnxg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9F12773C3
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406907; cv=none; b=gZMBBnWOEUowwj0ViPiSFIt4iynuG9D9D+Njhf6chCoiTIIYS4F2OQpfGD2DwxK4/nWkzGOKbb5vZ+ckIlXLeGJBUkOJj+41UYlSyTcEjvo8zEz5a3dlHibGXp4R9BL2PCpj7zSJakZRToWeZ8B+RlRHaU/vBZva5MGkNii1cPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406907; c=relaxed/simple;
	bh=jExYI2jaoXiycbQo0Q43ubPRMYOXkZVZRm5nOe4POx4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fOhfgU8rKMSNITWGp7ETCvyF/pT4pYDWX1iqkU16LmIkrhIrdVUj2VbL+HFx+uX70r4ogWH//S2eTNyJWU1fIo3fEi2FCa3j+vaPXUj/yyMyVe2/ZF9fISyr7TJCe57N+GdeYNlBiFmrEGQm5SCKj9YRTxzcllrqzVM+z8lQVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvRXDnxg; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3434700be69so3595897a91.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406905; x=1765011705; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=06c4CDfEOBNFQOCEh49v+FDqCuxNhXoe5zY9J+9QjgY=;
        b=TvRXDnxgYMTshHKZhCkNuQ8FV3gg1bdYMVAug+4q2m7RRIJFZP3bof47t8xMRAwQlt
         sfyTFiIZZuuha8Hz8Ne2dkWvL2hUjjM63zPUh8CuJYHc3B/Uteja/oe46MPZWoA3yZzB
         3LMMCQ/5opwPbW7tW1owwPc0eBfi+cxKVM2bujQFczwpyMq2T6/EULqBvibxevSUXKKz
         J9z7FyBAcYtD0q2gOfX6TLpbPu8zbiHkT5Pv7rnd0vqwnhda/51Qx5yEy9bse7VGr3ze
         ydw9cmZkHB2ELAbaa/CMzlg+Q7Q7MTh075eQ77AxuBGoXv01GceI/QVGQ4zUXSCDHSyT
         AhUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406905; x=1765011705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=06c4CDfEOBNFQOCEh49v+FDqCuxNhXoe5zY9J+9QjgY=;
        b=kFRQYjDR2ACUCnBxjNGiG2KtMo8/z0xt6BXqyHtXRhRRaqW1dAKPJkjbI3DSn2j0FQ
         NQdiA8vkxKLZ4dVQ69JTg+fqETHQ6wNgolmt/9SKbSRPJGaqUtidYCxDra+/lXgR2r3V
         2O2Q2DqOWiYPNgzMwoPD3tUuwt9+4ANwzsUTkmBrql9E5v0jHa6zs3Up6lUW/0RG5649
         3R+3WxOy3FmSMP6YiX4ClSjjaxbPIUfIyZjX78U4Wc3p1YnO4aUV/7kJ54ndZbaTGFi/
         hl/QYmOdOcllvV2rR187dn1/eZXS1CAK8LN1BjH6POAJqzvYpfyVfr27yZDx4GxwWM+T
         gsFg==
X-Forwarded-Encrypted: i=1; AJvYcCVZlrlDhki3rdG7ZD2XV1TdH3m2eIDswrr2o6bn0pR/U2S3d4RPSw4s1AsLRaj2nx6Pvq0ltEZx4LdsSDE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC+D21c+Gg3tM0Y9/WK98Zv8JtNTY9Opu3kLBQ5b15mYK1Ft0K
	HxtRwfxwiY1pRQ11a63daKeiqKfZrUbNQWnTxRhKjotHWtNQRwuAX0bx
X-Gm-Gg: ASbGncsMtpPbx+cqPlqIbhz3+acKWJBnpLVH+0HWLgSRpyDjzaCe3Qm7PvL2eSguceT
	HZG7hI62ToALQ/sQLhH2awEDrHKv65S3JBUnWzVa1Ci0Ep++83+GqHePvWCd4hOP5HxALDfpj8N
	wtLjLX5dyPIicqnwwJ6iZ1ZZfyjO/r8Sd0MHvZJPR62EphETEignlOv2gMwn0ParGPBepUExIId
	NW3/Y+AAEDgWBUoKFX8Ri7MYjzBvYy+3Ry1ZhLY/iGXX0RBV3qWm1UyQ56muKGK1uvUOjfRdmZQ
	1PlkBGzKiDwa5iNTBgQeT/JXwApf/bCbI9Ac/TSZKjh4EmXcEPmhNWDjjMB9TVdKXl4srCDQTYk
	5uk1+MJOdcSD2vj54NhkFYy4w9Jeyfdq4RgIiMFwTwX5cIai/kAQDBet7Usi3lE5tHY+aWhpczQ
	PYk1ushqY973AeXIvbxw/LtY41SQ==
X-Google-Smtp-Source: AGHT+IEFFhMF6u7tNXXwfE6dPq1pkaM+HsOKRV95Dom9e3MOSpru2Keq8NWtpHMva0MzTN1ZATf4vQ==
X-Received: by 2002:a05:7022:62aa:b0:11b:c1ab:bdd4 with SMTP id a92af1059eb24-11cbba4ab67mr12173129c88.38.1764406904816;
        Sat, 29 Nov 2025 01:01:44 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:44 -0800 (PST)
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
Subject: [PATCH v3 2/9] block: prohibit calls to bio_chain_endio
Date: Sat, 29 Nov 2025 17:01:15 +0800
Message-Id: <20251129090122.2457896-3-zhangshida@kylinos.cn>
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

Now that all potential callers of bio_chain_endio have been
eliminated, completely prohibit any future calls to this function.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..1b5e4577f4c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/**
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	BUG_ON(1);
 }
 
 /**
-- 
2.34.1


