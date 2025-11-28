Return-Path: <linux-bcache+bounces-1269-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F54C912D4
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:34:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A0F84E275D
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB99A2F5A0A;
	Fri, 28 Nov 2025 08:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SI4ktECW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20B2F12CB
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318781; cv=none; b=Am/mtv/xAqgUNAIMD+8Wc86qABqCJBSAZmhtD4byYSg21zNhOoTFUqAr8IdvlTLJXIkLI01ivucME9+Fjju7l/emME6wNCpqw7xEWGBaL9k0o5rz5uCMopddVXfGe0ehFNbKBTAtvOxKCulgFzxBV50psjnJhQPVftL01KoATKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318781; c=relaxed/simple;
	bh=XfGf+/4TH9UT7Q+DEbtJ2829MlGgMcgOkxUS/OB2JNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gl/Y5EUPV0w9RUyxHsfN4UxQPWvA0KS+uTOdtzX39wMbQl6sibZ/uzKAoZx5hKjqA51OGWPH51acEqIJlopwjXBOQw/8A0yrV9UpPDl+mSo/OnrPqVAqQGP0+BoTE86d2LwwPN7e6sKd22Pcqvmc4e6SwcuDxJ4GxixOedsuafU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SI4ktECW; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso1827489b3a.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318778; x=1764923578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=SI4ktECWGAdxQ/h5ju+9D467iQ0/b5onxBwTSANKtpdW6BDsrTCOBt0Z2whVC1Kgc6
         SqxC9/yrtDlAggVPK64cjH8kfhOzaGrZ22JS17I7r32M+F/OOlRvLkW9VmrFlWdD9BQi
         cd1dIhzw76SZZqIIZBA55GnPK92aV9L3rFxGG87UGo6p7jPJJvEACSIdXqbPgIIAoWXm
         dpzrjxLacGVnjfljRCZozEBRW8Srq7qH4WQAk2301BB7dH1yjlKEIYl+H49ja7BuNBTu
         4msQwv/o6Lclgz2gjm+b7vK17E6S1wuf2ciylRy+pf7mRsGXYNvw0hyiuerrllb/+E4l
         NaCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318778; x=1764923578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hgav++xVu99AZZZMA2bV1F+Nxhf+A3QsmIfb5iyDR/M=;
        b=i6EDmcTCu5gULPKhlCDDWvy2MdTuusmSpt+xQ1psQVSx49sDmfNmG9va85Tw1sdGUe
         Bm3Mf9BJm7cTDkKYC/wnsheSXzLR1gIvSyJ006+ujX/yOfVXw3KAHtJjztaDs5/34JQI
         avk+f8ARpTV3NNv7fiaIMpa7laBweelMZ7ctbqTNjoG40R/5cIH1RoGf/Xt60QP7Q5MA
         x0CfbSUgJVWH0yU9+ZOPOGITNCoeT12WEAzHhMLCt8nYnhC/Y8yqX1abm2Mx1K8/5YNB
         Yy11dOuVr5XfMURD400O4sZ3nBTikCR6wEDsmU8o3U/zTpHNIqFXMnnw5eALSJoPQptD
         w4gQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCsYGYBQQ8agkvm4ERUS10Pg0OSWLXC2zT4Zb9SKqWUgYjmmvzYQ6wXyZa58PTAB8NceYdyoIjG92oGzQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVWwjxQOY0qrUaNKmUrS88b1j3HDJrWwosf4xorZOjf69RNyQh
	TbOMEjARF+zcznZVNUrWNhRlasV8GtbDjLtXmpVIW6cy6PQAMeLYeTzi
X-Gm-Gg: ASbGnctAMTAXKKZvFvJD4nCZvOsaaJJHMQYKwsMMS3OV/SsrhRbuwsGA70iaMPl/SLK
	SL0oUUEyObSDCaPOqkX+ZS6IOSpY+n9YiSN/1kkWIs+ha4lpNOqdnwdtzZB2nrwBHYuvd8M3jNs
	a+WYbHWMmSMwXAR/smAL/k9LyaeVUL6/l0qheHrlj6MZsesVyRHAKwiA1f6wN0E3kgL54OfGi3N
	ypzdVTydPalxGyyvQsO4L00k4uU8AYjk5Lc8gKP5E/OePmrOJoYmdmUtWNI1Rx4gsd8CLIbiZOy
	Pk4iXfsG+G8vhWNEZNMnaG1wvs90YX5ewijg2LtOtBJCoMMYSS3gJS2V/GSe5J6UY9fAJQPlrK8
	iK9NKyqcMuSQtTM36asjzw+CdkkLyHMwAlM+W0AlPiGKZ1nI0AOd8pIkwg44FfEjDtK475dX2p6
	P2r3m7ZggBaLzJ0BFL4MF9hvzkpw==
X-Google-Smtp-Source: AGHT+IHuO0sAEeNowy1+oe3IeEgaIYQcRN0FMbygDOiWMPQmdT1sBtyBJY7y0vyzVSrhuxE7eNWdhQ==
X-Received: by 2002:a05:7022:5f0c:b0:11b:88a7:e1b0 with SMTP id a92af1059eb24-11c9d8539f7mr12036129c88.26.1764318777892;
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:57 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 04/12] block: prohibit calls to bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:11 +0800
Message-Id: <20251128083219.2332407-5-zhangshida@kylinos.cn>
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

Now that all potential callers of bio_chain_endio have been
eliminated, completely prohibit any future calls to this function.

Suggested-by: Ming Lei <ming.lei@redhat.com>
Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index aa43435c15f..2473a2c0d2f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -323,8 +323,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/**
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
+	BUG_ON(1);
 	bio_endio(bio);
 }
 
-- 
2.34.1


