Return-Path: <linux-bcache+bounces-1344-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3162DCAB43F
	for <lists+linux-bcache@lfdr.de>; Sun, 07 Dec 2025 13:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D517630813E9
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Dec 2025 12:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451512E92A2;
	Sun,  7 Dec 2025 12:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zy7D1DXB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4BD2EA73D
	for <linux-bcache@vger.kernel.org>; Sun,  7 Dec 2025 12:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765110118; cv=none; b=Wl9hLA+W2o6DtG5cfL16qRU4tj0JmV9a5WaTWaFNqwJdeAerf5mEud/Oina6K2zmywM2PboZWvH0JYED1Kfg1zUz864723q/0jbVk89ONnOT0GhjZWitbjKCW68gi65YjdbNnoii9GbGDYb3QdKvpZLzaWLa+iwdV+VpckJG3Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765110118; c=relaxed/simple;
	bh=4CeP8091EqjUK9CskNSlEn27rcVvsb9klIf5F54UFj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=taCpMoApGenAjiHUzvURy5lcN6ayDaDxPz9+XiBhQavjAv/XDLMpUG4KcAKmaEUs1xdn846HplfKIX6LfhTBVzPImMLuBF40141aM5zKYiNyFVE8m2+jBuMVdUVhCnfqTANA9hTXgPiYYAaAUs6VpXqMospqiepoLy2BYpHqgzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zy7D1DXB; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso2800866b3a.0
        for <linux-bcache@vger.kernel.org>; Sun, 07 Dec 2025 04:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765110116; x=1765714916; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FDKxCQi4WubAv8KgzENdDuZ74b0CZmQcA4s08IiUA3A=;
        b=Zy7D1DXBBrOd+V5D73IJWoEvycklFwPBBKr6XzogyF6jQvf7ceG6VznuaXR/pHC60X
         KhP6cGgcU0WhaEQejhvkvbajUmWUvJg7VH7bo4BRPCbLsmM5ezWJhSZXC/DKmk7X6Rx0
         XG7+MHmqK95TWXjapl6YT9quA78X+FiY6N/fe91yUq/qNUaFX1EMrTbGuI585xYoHWIe
         B4emYF8X5v7q4+dvPz3Nsvj8LD8H2VhImgYL5Y7IHR44JrjaiD0mSC7ryygOyt8qaZI0
         PQ5tgcxOE+Vq6wjDgmiueuyPcKnCOrIptsPu9N58AhKaBn+Pqh8336YMFZ/Qxxxtzpjo
         R1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765110116; x=1765714916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FDKxCQi4WubAv8KgzENdDuZ74b0CZmQcA4s08IiUA3A=;
        b=Xl9w3vy44FfV5R+O/6w7/kYj7Y/PJHC1n4m/5fmJqOKvjlpLcQw6fFrp1TuPpGCokb
         YrjTjYLWL6XnpamOZEla0lqd02fYqzAnGgZZ3uhxXZaPGQ26WnUpL2QEVCGLvLKxhB4G
         Ql2zmYpJufk8GG/pKHioXcQnJy6TwkBHviF4Su4nftq8DQkdWube9Da0NSFRJf+8dQTk
         hhjgg3WYSL3ESHipY+945ixTMj/NRrvQd1/T0bUw5S3HJbnvJSt3RGFZFJslqg632pyx
         /6Na+l0OOfguNkzkI/W+a6TqlAS29mqxZAiSgWlHeV0OBFicYb99fCfabyGpiT6oj32g
         pvtw==
X-Forwarded-Encrypted: i=1; AJvYcCVx60h42NiQ80lTPdb9KS0TdPp00ZDRpUu0DrCAHvl3GukPR9Y7DRJabmKl/hP2lX1MGo3LltmEZ5sLiUo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbiTQhxPPWuwKwfdQBkEJgHEjVKhtwNfAhygqV55SHhxAGGWCW
	cg38zt3U9GoxW8HtQu5HOsT5XwKCdBbJa03DmBGfJgXbGbs9Yr1V6/9Y
X-Gm-Gg: ASbGncucf8V7m6ac1vk686Xx08Af/buaqwVNM8nAvGOt6FMJdV7qk9HybPaxI3wmMeH
	O1mfcDuKx6UKhRa0vArt5w+HInUHJnSwpvXqDnrkilXtHgCzsQjI3T2sDXfhmtYGTOoBv6Y8bk7
	n11yGfz8Si9ldCasI3KB3iCyGyZDXyoJw5mWedoNg7KId3dWkhVlZ3fWzjdwmvH3tYBmx2LNP9V
	f1IUL1P/q6yiQaRh8uc/C6tiz4OMnCBqsR1ZkluMjoHjSQ4Xvy5MpYAwBN6vh1PBymRb7OKC9FS
	4bGhYx9NdV86VUUbYKteqGDBM6pYTaIgzrtjAaef59j3O7T79qRJrTbMXo9c108jvo7ypjMh3UE
	tibc4Cfz+XvaWkbkNA9hGeS/K6/xiCc0eF1qUQPDgRfKSQTijvul5piJyk73hh4j5642eHNeUq3
	jw4dPgHL/ZK8Ei5Vx9cJxZ6BsNzA==
X-Google-Smtp-Source: AGHT+IEFoaufhtQhW9IvDY1RlPlNMuzHF+hZt/2aoSTSKZxkU4XhEbVtz7dv7vqUjHSWeE+D5TBt/w==
X-Received: by 2002:a05:7022:408:b0:119:e56b:98a7 with SMTP id a92af1059eb24-11e0326a1damr3443282c88.14.1765110115829;
        Sun, 07 Dec 2025 04:21:55 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm38598822c88.5.2025.12.07.04.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 04:21:55 -0800 (PST)
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
Subject: [PATCH v6 2/3] block: prohibit calls to bio_chain_endio
Date: Sun,  7 Dec 2025 20:21:25 +0800
Message-Id: <20251207122126.3518192-3-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251207122126.3518192-1-zhangshida@kylinos.cn>
References: <20251207122126.3518192-1-zhangshida@kylinos.cn>
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


