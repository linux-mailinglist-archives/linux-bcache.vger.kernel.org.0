Return-Path: <linux-bcache+bounces-1312-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 15159C96516
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:05:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C784A4E0661
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:05:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A6C52FE04A;
	Mon,  1 Dec 2025 09:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vhl5GEBa"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CD2FF660
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579907; cv=none; b=RAsrT8qB8dbNlBMsngbArBwc3t4c5b7MRAkYzhuYXN3kwZi8SMISLLSooKVKRCzmu6pJV2lvOjajZm6eJFoZ1nFEAPptq2KWF+BQzWNxsVK7GB52Yh1zbNe1j9st0+ToIgCmMdQJr2yX0MAt99tBwO7faUFHGac75Yvj8IEWr4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579907; c=relaxed/simple;
	bh=9o7pMGLR+wHFQD17nhkv0K8NYO8+CXCbWzvTdLvv3IA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zp4/NJDfkG6n1+AqIAKdRvi6daNCccXiUjbHokYoitFgQgMI9zpv4vpeHjQarnTgJRWluePbvqCkWsvG/5sb3dWxvzG8WXeFTlh82Otm5mrdMyWqoH0EWXAFBrBF6eiAi9FIzgIy1EYWeZ/D6c3nIl6qiaU03v3Qg4oppcb4alQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vhl5GEBa; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so4727422b3a.2
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 01:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579904; x=1765184704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aw316iKTX/2VGJbIgc6JIwbU4eBfsa9UZDP5Ykz1NQ8=;
        b=Vhl5GEBa/6ceMPeelPbR6icywBTHZ0JJO6fJqxpJzIO/diC4ORggfcoswFxs5vsOIW
         GAxx9OV4MCvj3sWngrfu2LeSS3yzdvZxnaEZGgVa58E++ecYOwBnXomQK2yc7UYJMoz2
         82AZAuHRCIAMoa6uXMxkRsZgaoAqrfKbZ30T3XgmpUpMRlrZDi9bsZBd0jL38v5H1CUy
         FTTzWNaZiwYy/6wMYsDqGDyWPgXpY7qsVAcb5bR4ij73OW2EJM/xN0gLW9BrHJr/hYkF
         GC7HlFyjgg8qUr7VfOMLsHJvP+pUtGJOV7YgpA2EbVp4QWhMdA5kIiGdX5rWRlQATsbw
         J19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579904; x=1765184704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aw316iKTX/2VGJbIgc6JIwbU4eBfsa9UZDP5Ykz1NQ8=;
        b=DUAbmQztOYPa4h2DBmdlKYH5oquTTczn6zHG2DZIoLPGqrahnZJLvpGHuZkqxdnA+T
         Lmn6GZtDtwzHW6Fpka4opT9TFRuRXd88jJl7DR90qt/qDaF5FyvE/Lm/6Dhd6ZI65dJn
         BklpcNbk7HETJrUKGxL57YHhVOYLAZ/iMePsgQS6PnxAoHkBoBwfwutVNGNRCKIVTvAc
         sq03CYlOxzMK8uQisekRIANvLhDGEkC9wR/JxDR0Q+qe4In96nkFx4IvBdxD3kT1iWCT
         r3lQdlc6NGqY128Wpf/xZ2O+6W8io0lOd2AJb2ATdJ/Bg20ccAdysQTeT/YtVSTVvQnO
         oMhA==
X-Forwarded-Encrypted: i=1; AJvYcCUVszLIVLiJnI0V8OE/csAPWBV5w7GV44YqSa4WcXPILm/T4qNnWR1N83z2iqqlVp1jE/2gTtuOKYPcvi0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOB0HUkjo/ikWBFLvmYbHj+ILf1ymQkOro0/bAljQs8UVBHLJ
	GxT2Lc36HNNODpBVJm0h7fX0YwxmUKfqc1I0imesv3oN6XsLienHSiEl
X-Gm-Gg: ASbGnctCuo73vB/QIiIT0vrI+5z3bM+Y+FfrVqnK/clnPxw3QOdj2+cWA3rzuhHmKXj
	THFSX38S4lcv+8gxUXCyonQUbt8FL/P2U3UnCCqg3PA7g9mAfwYqlwpgEZU11jrKTzf7oE9ugAc
	yslxBZIWcxnqCxRXoIz7H3yst+Ukk7i09VHsxqoWSdJfqHC4EC4YIVbkEHJ7Z1gWQeXioivYp2i
	/m3V8H39I9YHsl2OmTvqZwClzUoUIWrZ0sCnjwu/acaOFU7yRxPNU8sRDmJUil+TT/yaRTkTA56
	jrH7pIuQi3IB8g46vT04ipt9jRN5Sje0SGOjD3+Xyai8bezmmWe1WZmCtGu8F3uvGjt7BwB7ucI
	eKhaiQ12BSL8biqbW54/lPW6MEzhxmHH6ONbkRKoAo/9o1R5KziEbUspOGVh19xR19HmQViBvpE
	ZYIW+KNSJNTUbQ5WdeOUx+nKITzw==
X-Google-Smtp-Source: AGHT+IGoGR2vvfoyHhoCGadAIM1tRSK0aixyW3oTcQUZl+ZTkQaaORwlprV0B52obn6Pxd8CCBZOyg==
X-Received: by 2002:a05:7022:e80e:b0:119:e569:f624 with SMTP id a92af1059eb24-11c9d84bf9fmr17998389c88.29.1764579903743;
        Mon, 01 Dec 2025 01:05:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm54908307c88.0.2025.12.01.01.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:05:03 -0800 (PST)
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
Subject: [PATCH v4 2/3] block: prohibit calls to bio_chain_endio
Date: Mon,  1 Dec 2025 17:04:41 +0800
Message-Id: <20251201090442.2707362-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251201090442.2707362-1-zhangshida@kylinos.cn>
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
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


