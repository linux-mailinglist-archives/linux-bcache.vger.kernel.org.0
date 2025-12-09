Return-Path: <linux-bcache+bounces-1350-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E82ADCAF600
	for <lists+linux-bcache@lfdr.de>; Tue, 09 Dec 2025 10:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A2D7E300EF22
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Dec 2025 09:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D652877D4;
	Tue,  9 Dec 2025 09:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U92gp+DN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6689C27145F
	for <linux-bcache@vger.kernel.org>; Tue,  9 Dec 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765270939; cv=none; b=G5gpfxyUYrPYr4hnHiWpSDcetNvnv+B0r8b0eaEI6kWeVlYABShhCi6d2E39/HdH80WUM/VmETqhUeztV1YKhD61Vm99xAkohPbsCrmF1h4UIBdBIDkgxaO5Sjtj/Oqcx9nwNdFjM0qqFTaW+kCTktZTFGForiMXGlJp3UrS54s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765270939; c=relaxed/simple;
	bh=4CeP8091EqjUK9CskNSlEn27rcVvsb9klIf5F54UFj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LbhEiiO9IXyCcG6tKJzwolVGgGG5JMDybaiFMsoc5usMCvRwfj7AdPUN6XWmgz3U96rDC+7qEcao8BFtYGRXNPmTx4QfNuihgdeZhGlZHFc0YKyTh1rus+BRR7h3rMeAOSEnYAT7iINNu+xXEGSB/4H4zqYXm5gj+HSTZtCxjXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U92gp+DN; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-295548467c7so70396045ad.2
        for <linux-bcache@vger.kernel.org>; Tue, 09 Dec 2025 01:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765270936; x=1765875736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDKxCQi4WubAv8KgzENdDuZ74b0CZmQcA4s08IiUA3A=;
        b=U92gp+DNB8aTeJFSPPcFW8Df4V6N3KpXKzI/GvYks6SIJvxKwcc80tWL4mLkisWHBt
         eCRq+aaula5gnIpnnxwtzbAp9mF1TJ7+V4bKqooWAwb/SeninyaQRUPg5Mdr//IUeLSU
         o2dUxc/iPw+x+iaapBdd/mgRcOQ5Zg2CSil/WPOdxi2DeMH0OElgOyFem/icwi9Ux1JQ
         m1K6Qm2keAuKEJkALmQCx72EmnSq3d6/kwNVDx6GaNw7irCoh/H6nXrlY1Gmg2RF8xnm
         LTFayombFysbwPamMoNl5Oq8HMg/KLR1R8w1ecwdCHX7/rbO+hUvvmeaOmG9gMgcIjVL
         hlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765270936; x=1765875736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FDKxCQi4WubAv8KgzENdDuZ74b0CZmQcA4s08IiUA3A=;
        b=aLI3B3NtrqBYPZmYeygA6URKcaitXTkZO/W4X1qLnW+WUDHbKtRVjOozJylO7m4ITK
         Xwu42hZi8R+y0Ow1d/KUq8CKh8r6k88aHTbgzFTUiXw7sUXF0iJ6wJVYaYjQX/6ujd8O
         YsdpeesK3j35YC2dnqIOgRlUc5BoZwlyZ6+U0LCre6ySBXMZRylLAQxf4vbUpS2h0ms7
         Ez5R7/m74Ugi9S16IsADwakvseQbSvK6/OLRDxGQrNHl4HJO5gwXHL/gZhwzoMS9iATR
         1385WtuYNkzqJzilTHeUx6uDjpP5yRsS2xY9tZ8Kp5ppe6kexr96j+WRIGEnnMLXJaqF
         zBsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQtgc1wD3bVjsy9g/pDBTeS2+nc+q5fP5OQsNmXi0h/SxiH/zRwurZj1ZqcSjZ7Gt2asNukccLW7rsags=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcVX/7R23YzzkElxaRSfV6CGaWImNc9v7i7tX+GXzHRNodERek
	iNbLtYpvxUxzjcon2MmaMOML1ppav5zl/tK6gin8cbIGc+aMC9Q6MtdS
X-Gm-Gg: ASbGnctJenCokMulTNRorIdEJZbdnvYPh8Ct16kuS6WZfmvePOojjsCeWRAP97mxgpQ
	lhxwlLgEk+ZAtWwF+Sa7zVx1T6P4VLXhlxaHb+By19dVcgWJuQ2VtsJ9BO3xHCLgd+Tm4JoqcUi
	XZsmyixeO1E9tJ0RlkgxIwSdf8k51oKx8k9jXR1NGzs8BoIUMEc1LYX92lRZn9ltmpaX6ao7ZtL
	c56lfwoftZCmnRg54t07OKvGqYLt4JHoPw3xuwq8yPPaRG43Ue5CbaDuwrDp8t/RQZLZJjQkucz
	+buVmO9MejTU3M/5Fgk+Ric4xSOoTbzKDs07+D8i4yTClVIpXo6Xv+f7zLU+ozeCwPQO3uQVhXC
	P36bTF5U1O2uJaKxEW6NTCcJ9GDxKtM4IjB4U3TAM7gmmcDi+kkaqvxIKSh5Ca18B6YaDULMrQQ
	ncWJrAeVY/ZuDtLZg1IXDV3khe5g==
X-Google-Smtp-Source: AGHT+IH8UlmlQXv3ttCFRjc372AUW0Jx64eBzRuhm6/sFfQMDcgq/zQ1pavi1pYW8AOCCBSPo+vrzQ==
X-Received: by 2002:a05:7022:239c:b0:11b:9386:a3cf with SMTP id a92af1059eb24-11e032ef6f6mr8436937c88.48.1765270936449;
        Tue, 09 Dec 2025 01:02:16 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7576932sm69700982c88.4.2025.12.09.01.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 01:02:16 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com,
	colyli@fnnas.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 2/2] block: prohibit calls to bio_chain_endio
Date: Tue,  9 Dec 2025 17:01:57 +0800
Message-Id: <20251209090157.3755068-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209090157.3755068-1-zhangshida@kylinos.cn>
References: <20251209090157.3755068-1-zhangshida@kylinos.cn>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..d236ca35271 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 	return parent;
 }
 
+/*
+ * This function should only be used as a flag and must never be called.
+ * If execution reaches here, it indicates a serious programming error.
+ */
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	BUG();
 }
 
 /**
-- 
2.34.1


