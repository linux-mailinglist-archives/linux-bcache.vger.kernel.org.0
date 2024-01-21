Return-Path: <linux-bcache+bounces-231-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F94183565D
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E29FC1F22E97
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9830381AB;
	Sun, 21 Jan 2024 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/uylxvv"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C9F3771F;
	Sun, 21 Jan 2024 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851425; cv=none; b=g136HdmKrKhwih3yT2cuEJv4ACBG9eDxwgWEdWXVjEhJP3Th6NKc7sNk4fOGwjD+Og8YhMV2TvDASOivdi98fUyXKUqP3WpRcPOj0QM3ybjluIjNGkiFrPYMgffljEDCNXkLVWeJirqV6idpOGAdBe9sdK5+ohQ84gLGKOJN+VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851425; c=relaxed/simple;
	bh=td7eYq5RRdZjgP7IOM9O5bSI3K4VazA2jQDoOaruLEY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lr8wtKlkoBRQR7rjvjrcSHLBVaqCznk8ECnXgImJ1hBfpD05Cm/S2HJIa9QUqWwiEIZvtuFktSEssvubqnt9vDV7+37NjEk/BoCayBjdox6nInu8iDyfPvLrO3L9u+A7gRFYzeYSGyk17Fy4/Hqkw2TSDfqaPqyDpERU7oKtlLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/uylxvv; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6d9b41a3cb7so828814b3a.0;
        Sun, 21 Jan 2024 07:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851424; x=1706456224; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pqHvvCphlALlajToOUOu8ABe7Bhki2MXmZlVOF4qBQ=;
        b=F/uylxvvWe45LqSORYN5ugmKL87jo+XNva6oXhtSANRpkM5TDGds2oAcUG5Ifa1P8a
         N8qZNUEZ4XG+FTo8srme4S9gcBHBGhDMb06F3wTk4tts5+HLQ26/bweMC5soMwABPDLP
         4IVCxBnYcQtnkQLOoUnUQbMqUuJM6G4NOVwArSxHw55WdNjsj3Wq+DfB/3aUoZ40XVBw
         NYysfNSdTQPLVHzijOmMTw4MxCS9sIsrugHqpwkMPjhC+oKWNUyS8OojSqjbzlNrqbU6
         3Q8wljLamC/soitqdk2h22wBcP0yC0tnzQvYildMNULop9qUZHU0gSputMlkRtrbaA4K
         TZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851424; x=1706456224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2pqHvvCphlALlajToOUOu8ABe7Bhki2MXmZlVOF4qBQ=;
        b=dvCPvYuHyKNvQTUsRhVIC4lFNFTaHWi/HwFQ1aRDujbKJ1EIDWjCj4YJ2C5XdtJeVD
         FPtp20wXhu9oY8H6myI8d68yP+oxsMrT1lXAf4MDVjcHvGCL8EN67bRuu1Pcba5FHXL8
         pY/FhwYJ13mU5tDnbOkmJb5PKhkBf/gm5VjlziFrXqnHsF5+1LyRSN/4qMRNFqIN9J8c
         4wCFpMIkHeOlvgl+OxMEanLpmwy0ZOboyTrvd6k6E4Q1wVb6KALs63qvu7h22pBtR3l3
         r6DJvveZ8FaqkHhgPW4nnjbJhhGV5KjzSx0TcA2JuMN4Hgt40wBZYrdOgRPdhTyma8lN
         QNjg==
X-Gm-Message-State: AOJu0YzAzHVQN0uViyhOO8RLZygQO7LCEwdEU3QrzFSbObkTs870a0b5
	yaNKVolek/BtOlwjfTd3J+DRoruea49EnZFcADUBgLgugNWTSKhi
X-Google-Smtp-Source: AGHT+IG+D6at0+cAHIsJd/0BlRcS+2PEbB1TO9MOrWa17WDiILOJxIBA0dyciguF6FOdTC2vq+MDJg==
X-Received: by 2002:a17:90a:c286:b0:290:19c1:103f with SMTP id f6-20020a17090ac28600b0029019c1103fmr3578520pjt.1.1705851423879;
        Sun, 21 Jan 2024 07:37:03 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:37:03 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 2/5] bcachefs: Introduce parent function for sort_cmp_size()
Date: Sun, 21 Jan 2024 23:36:46 +0800
Message-Id: <20240121153649.2733274-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240121153649.2733274-1-visitorckw@gmail.com>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When dealing with array indices, the parent's index can be obtained
using the formula (i - 1) / 2. However, when working with byte offsets,
this approach is not straightforward. To address this, we have
introduced a branch-free parent function that does not require any
division operations to calculate the parent's byte offset.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
This patch has undergone unit testing using the following code [1].

[1]:
static int test(void)
{
    size_t i, p, size, lsbit;

    for (i = 0; i < 10000; i++) {
        size = get_random_u32() % (1U << 10);
        lsbit = size & -size;
        i = get_random_u32() % (1U << 20) * size + size;
        p = parent(i, lsbit, size);
        if (p != (i / size - 1) / 2 * size)
            return -1;
    }

    return 0;
}

 fs/bcachefs/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index bbc83b43162e..f5bbf96df2ce 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -907,6 +907,13 @@ static inline void do_swap(void *base, size_t n, size_t size,
 		  size);
 }
 
+static inline size_t parent(size_t i, size_t lsbit, size_t size)
+{
+	i -= size;
+	i -= size & -(i & lsbit);
+	return i >> 1;
+}
+
 void eytzinger0_sort(void *base, size_t n, size_t size,
 		     int (*cmp_func)(const void *, const void *, size_t),
 		     void (*swap_func)(void *, void *, size_t))
-- 
2.25.1


