Return-Path: <linux-bcache+bounces-1329-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B649FCA2354
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 03:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9DE6F300EB6D
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 02:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C980B302148;
	Thu,  4 Dec 2025 02:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lso3dq6X"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1BC2FF16F
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 02:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764816507; cv=none; b=tLXcko97cfrtME5/YlCfUK6OdHMNzOyxc8Ntvmp5+TnceJyCZgVYConRyS8quByFL5fFnxgOk0kdzC8FVs/Jls3e/4IjpO2hPy81+LBOAC7lwkIyf77PC8PL2Z65q2+f3Z4NW30IkP7Qygc3mgv+vi9JrWirol9JeUcOp/tunr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764816507; c=relaxed/simple;
	bh=KDrm5Wl7SwMy/FVrOjYy2K/P2b0W6LVDtJkcurNDtq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Uwvn5HVAvvKPMUTLWgqa9Wqr95kQTXTWOh3q7AEmIBu3vD1gh3q5miZHY3ES/RqnqWtLZQFwnoLT8i6ddGv65ZQF3swM3hzo1fBMXoDzZAeyU7QWTF6AMmQVFRJ1Vyqa2rjVijCNcd0bPDVvctTnGSwqZjfhCDK5k82OQz9M8yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lso3dq6X; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so507999b3a.1
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2025 18:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764816502; x=1765421302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NLLZx+mFtUT/k/qGnCVEA9+fBUA5GMxbqrpW9T4NgE=;
        b=lso3dq6XMltP2n7vWp4NPUbzMAfBgjugOkewORA9IYtCLD0Qm7p3CdpvoETtMh9a+m
         MBvF8Yj44J5+J63A82m8WTed8Ns0OJvb3ulg1dS8O/y6HXaeRmlf242bY1FHExZo0OMV
         Htn1K2T3RcTBkWyxFn1PAb0dimTUEfsVMQyoegLDXHKnvehNYaHjYR2bHAcB/I/1+gst
         urR1i0OWxp8pppG02FU8OoX3e4JUMqYGurXta/+tUadZAKNXYmPzusDBXpqMVW7bKYLl
         lRyTF7Bx4Sy6Bf674MWmNaPGM3iZS+e5EfojPWCaT6LD9v1gv2U4I7uj/zRpzKG1tjUf
         IS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764816502; x=1765421302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NLLZx+mFtUT/k/qGnCVEA9+fBUA5GMxbqrpW9T4NgE=;
        b=pZqtw05Rlqv4Zq3WFyI0JeaGnHodwt7ETHkZmsfE88CDD33u+zSJrJ0XuolPLIYGel
         aZQslIgN3WPDBhxwkS/yDdeomxfV0E+48oXMaEKZ2tIqn2A6iuuFmC0qNW/0eav/4nWv
         88wazI93uINjh9IM0ULt4tI42HVEdo7tFJIBJf6Zxqj3iYiAEzy1GKNLMq47/ZpD+tIa
         gdmNIjoQ4FgNU71FyZmujqUdS0SVVzRHmDjPtepY7cNLIOpfpM8ecUQG2BvsH3/vZ4nF
         Cyor09NCQpihu6X1Rc8HicJQIlXGuI7+ouU56MNM62pMqDtztyBsAykR1sji6HKSOoJ9
         v1GQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF6wkIYk+Mu/HD4f7hlzWp6Y8YzaB/d9v5SKs+7U674yHG4nEERtTcgJ9HSPqNSSp1pMfe1SMEFA7nyqs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4YluYmwaGcGzpaSjEfawnNohxsNF5zre+4zeonPO/HnU9qYTc
	NzvcFm+p6j19gRCIXYP5YP8HifdmgzwqjXyMH2P4w8jAnJ/bGegZfzhG
X-Gm-Gg: ASbGnctRjUrxmEJtw2CnyX5svRxVKEbOaxncBLNKk64Zg8NNV1EL4H/bvItZF2sWoLr
	37FB7NsQgvbXWyoYT8ZS6PqMHEbXmhasfYf4zKV/psSR5dJq0PQLN4UdOH0qxvmw+2l0Bl+c7ZO
	eQe7emtWr3Q7EVgQgbLQFFOmUPgr1OCk9EilSDoBprfR38omQQkT84Fn1ualDmaC9hbvF5b8ywE
	T7ltbUG/RU3GjL6/l2iAvbYE0crqeLUq5EoR++sOadX1eESLZuIOBWCOBbVRJaig8j8QxHP067W
	F0m7aQQb67A20pjqU/XnNDpgN9rbqtrVECJiOPH9jlvcvf4oD24s6fLr15EfRazM+v2Tz1hvG+i
	nZCu6kkvUBTR7jeNem4mi7DV/7wFAOgbt2q0zdnGJ5XGP3KcFDvGNHtOy/ZuFZx6fv/hGm8B8Jl
	svYZuwhh3fCNp7lsgHe/tv5jP3oQ==
X-Google-Smtp-Source: AGHT+IGYitTygcS9mzGlf9GhlZLT0eKknjI9LuN1aruThHXctHluTBM9GZL0ssswaZE5KQJhhrzPjA==
X-Received: by 2002:a05:7022:fd04:b0:11a:a20a:4413 with SMTP id a92af1059eb24-11df0c3c92emr3346889c88.31.1764816501932;
        Wed, 03 Dec 2025 18:48:21 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm1838847c88.5.2025.12.03.18.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 18:48:21 -0800 (PST)
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
	starzhangzsd@gmail.com
Subject: [PATCH v5 2/3] block: prohibit calls to bio_chain_endio
Date: Thu,  4 Dec 2025 10:47:47 +0800
Message-Id: <20251204024748.3052502-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204024748.3052502-1-zhangshida@kylinos.cn>
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
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
index b3a79285c27..cfb751dfcf5 100644
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
+	BUG();
 }
 
 /**
-- 
2.34.1


