Return-Path: <linux-bcache+bounces-232-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CAC83565F
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EE793B217F1
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56AF376F0;
	Sun, 21 Jan 2024 15:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOD/BP01"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5543C381C1;
	Sun, 21 Jan 2024 15:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851429; cv=none; b=KePnUtvS6K+OxijZhAaTVkvZMrPPFMd3XGXik/y0G+Naa7w5BoPyDtJSyxZDB5K1WP054tXp9GsfJ68V5rSA0wVPErXzCS7cx049w1sgKtgBJMX1gMrtttgVSnaviQ98i5xGImY+iA+aOjzOPzeo9gAXyf1WDXy5YEIHmL835C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851429; c=relaxed/simple;
	bh=ZvDQ06JGuVeJWVozfqdeUmELQkKAXTvtxrmXADmelYo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cU80gy0Jp2T8hMIiouKcSIgIs1XgXqFD7hJpvwtwuDoumo0q5Dq2pLxCNn5++1GCXUT/oHhP8KYzS6XsejQuGNbEBtUzHg2E44ua9QQCwXbeEKMwDjvSGZnVJOkR8AsjscaDnfO5al0QHQ5AmrrW8aighVu9pfp/SoZ4BP7wQZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOD/BP01; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3ae9d1109so6079035ad.0;
        Sun, 21 Jan 2024 07:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851427; x=1706456227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9tvCyvHjEIJoBvqUMUvKN9uieNjlbwCtwNk5egfjBU=;
        b=SOD/BP01vqwt0JOkwqjHPAYZy5kczb+7uXQjUmUG2Wrx6b7yRB59zxCQP8jTGCaRXG
         2o34x6CbV7a0Zr4t7BSMDN5/uLBOwuUr+FlQG5uxDWgCngF/5PaMV3zRqvFHlVhDfBah
         7LuzqxONoMOeUiFsYITr0jGwWpscKMqDcmn9ajZ1EZNUYgOxWCMv6MqY8z7i7+XR9nFu
         /NKZgusbBGjqFiE4CfC7kX7P+KYe4WBcDIq8YTAGUeGnWVGSMFBaG7zaekdbJz+3BY9x
         crGS0sQN3/pfyUev0tOddLIL9KmUIegHxFjY04WKOWynBIVQ/LZXx0k7PivHB9ZaIP/p
         wXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851427; x=1706456227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9tvCyvHjEIJoBvqUMUvKN9uieNjlbwCtwNk5egfjBU=;
        b=BUEhoRCaVtd12+J3f/C8gQdZPUWYaQlTB2tunOZ741lCOsHH4UeNLjUyXpao38HB/r
         qP1HOVVzeWSXWF4F/PEtRGc6sHMq8mO2Y4+nwMPiy0K3eepCRC3p214ypYF64NvBB/8n
         dCqtJIj28mOG+iK6On/gd/PPNfDa06rWaTJXbOxWlnTCvB5vr5bhdaLdvwlwjT4c883Y
         6TmDsjvEN563fdlD0HnXAX7C2FLOacPx3pV8o/RJvgM2KyF8ycUYoUGcLJp6fL+BM6hM
         +RAqB2vrMOWcsUCeWFqFykpTuvpqq4exoes4iTunWAJqSoKOhfIBQrP03dsjcPBm3vSF
         MKpQ==
X-Gm-Message-State: AOJu0Yz3p7POWKtzE/2ZE3dsLPt4pBPTGml/Wt3YsCgndCyAvDqgcKsF
	FKou8yxdiSnvIkFJRASsEGktCxenbqw3vPVkLG2/69NmYhYsnzH9
X-Google-Smtp-Source: AGHT+IHT470V+lk0gVqTK0HU/uE8EnYN270KoYPZPNHsQJLGbF7XxIFT/uJP+4iHExMw1AiH3HL7Tg==
X-Received: by 2002:a17:902:ed41:b0:1d5:efd6:20f with SMTP id y1-20020a170902ed4100b001d5efd6020fmr6167217plb.1.1705851427577;
        Sun, 21 Jan 2024 07:37:07 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:37:07 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 3/5] bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
Date: Sun, 21 Jan 2024 23:36:47 +0800
Message-Id: <20240121153649.2733274-4-visitorckw@gmail.com>
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

This optimization reduces the average number of comparisons required
from 2*n*log2(n) - 3*n + o(n) to n*log2(n) + 0.37*n + o(n). When n is
sufficiently large, it results in approximately 50% fewer comparisons.

Currently, sort_cmp_size employs the textbook version of heapsort,
where during the heapify process, each level requires two comparisons
to determine the maximum among three elements. In contrast, the
bottom-up heapsort, during heapify, only compares two children at each
level until reaching a leaf node. Then, it backtracks from the leaf
node to find the correct position. Since heapify typically continues
until very close to the leaf node, the standard heapify requires about
2*log2(n) comparisons, while the bottom-up variant only needs log2(n)
comparisons.

Note: This patch depends on patch "bcachefs: Introduce parent function
for sort_cmp_size()".

The experimental data presented below is based on an array generated
by get_random_u32().

|   N   | comparisons(old) | comparisons(new) | time(old) | time(new) |
|-------|------------------|------------------|-----------|-----------|
| 10000 |     235498       |     136592       |  17954 us |  14834 us |
| 20000 |     510666       |     293254       |  23549 us |  18364 us |
| 30000 |     800461       |     457351       |  33361 us |  19493 us |
| 40000 |    1101317       |     626661       |  33672 us |  26810 us |
| 50000 |    1409743       |     799745       |  42634 us |  34694 us |
| 60000 |    1721165       |     974737       |  51414 us |  41367 us |
| 70000 |    2037972       |    1152111       |  63084 us |  49146 us |
| 80000 |    2362590       |    1333270       |  73802 us |  54715 us |
| 90000 |    2690155       |    1516148       |  82693 us |  63070 us |
| 100000|    3019730       |    1699757       |  88981 us |  70367 us |

Refs:
  BOTTOM-UP-HEAPSORT, a new variant of HEAPSORT beating, on an average,
  QUICKSORT (if n is not very small)
  Ingo Wegener
  Theoretical Computer Science, 118(1); Pages 81-98, 13 September 1993
  https://doi.org/10.1016/0304-3975(93)90364-Y

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
This patch has undergone unit testing and micro benchmarking using the
following code [1].

[1]:
static long long int cmp_count = 0;

static int mycmp(const void *a, const void *b, size_t size)
{
    u32 _a = *(u32 *)a;
	u32 _b = *(u32 *)b;

	cmp_count++;
	if (_a < _b)
		return -1;
	else if (_a > _b)
		return 1;
	else
		return 0;
}

static int test(void)
{
    size_t N, i;
	ktime_t start, end;
	s64 delta;
	u32 *arr;

	for (N = 10000; N <= 100000; N += 10000) {
		arr = kmalloc_array(N, sizeof(u32), GFP_KERNEL);
		cmp_count = 0;

		for (i = 0; i < N; i++)
			arr[i] = get_random_u32();
		
		start = ktime_get();
		sort_cmp_size(arr, N, sizeof(u32), mycmp, NULL);
		end = ktime_get();

		delta = ktime_us_delta(end, start);
        printk(KERN_INFO "time: %lld\n", delta);
		printk(KERN_INFO "comparisons: %lld\n", cmp_count);

		for (i = 0; i < N - 1; i++) {
			if (arr[i] > arr[i+1]) {
				kfree(arr);
				return -1;
			}
		}

		kfree(arr);
	}
    return 0;
}

 fs/bcachefs/util.c | 52 +++++++++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index f5bbf96df2ce..4dacb2b9a0a5 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -979,7 +979,8 @@ void sort_cmp_size(void *base, size_t num, size_t size,
 	  void (*swap_func)(void *, void *, size_t size))
 {
 	/* pre-scale counters for performance */
-	int i = (num/2 - 1) * size, n = num * size, c, r;
+	int i = (num / 2 - 1) * size, n = num * size, j, k;
+	const size_t lsbit = size & -size;
 
 	if (!swap_func) {
 		if (size == 4 && alignment_ok(base, 4))
@@ -992,28 +993,45 @@ void sort_cmp_size(void *base, size_t num, size_t size,
 
 	/* heapify */
 	for ( ; i >= 0; i -= size) {
-		for (r = i; r * 2 + size < n; r  = c) {
-			c = r * 2 + size;
-			if (c < n - size &&
-			    cmp_func(base + c, base + c + size, size) < 0)
-				c += size;
-			if (cmp_func(base + r, base + c, size) >= 0)
-				break;
-			swap_func(base + r, base + c, size);
+		/* Find the sift-down path all the way to the leaves. */
+		for (j = i; k = j * 2 + size, k + size < n;)
+			j = cmp_func(base + k, base + k + size, size) > 0 ? k : k + size;
+
+		/* Special case for the last leaf with no sibling. */
+		if (j * 2 + size * 2 == n)
+			j = j * 2 + size;
+
+		/* Backtrack to the correct location. */
+		while (j != i && cmp_func(base + i, base + j, size) >= 0)
+			j = parent(j, lsbit, size);
+
+		/* Shift the element into its correct place. */
+		for (k = j; j != i;) {
+			j = parent(j, lsbit, size);
+			swap_func(base + j, base + k, size);
 		}
 	}
 
 	/* sort */
 	for (i = n - size; i > 0; i -= size) {
 		swap_func(base, base + i, size);
-		for (r = 0; r * 2 + size < i; r = c) {
-			c = r * 2 + size;
-			if (c < i - size &&
-			    cmp_func(base + c, base + c + size, size) < 0)
-				c += size;
-			if (cmp_func(base + r, base + c, size) >= 0)
-				break;
-			swap_func(base + r, base + c, size);
+
+		/* Find the sift-down path all the way to the leaves. */
+		for (j = 0; k = j * 2 + size, k + size < i;)
+			j = cmp_func(base + k, base + k + size, size) > 0 ? k : k + size;
+
+		/* Special case for the last leaf with no sibling. */
+		if (j * 2 + size * 2 == i)
+			j = j * 2 + size;
+
+		/* Backtrack to the correct location. */
+		while (j && cmp_func(base, base + j, size) >= 0)
+			j = parent(j, lsbit, size);
+
+		/* Shift the element into its correct place. */
+		for (k = j; j;) {
+			j = parent(j, lsbit, size);
+			swap_func(base + j, base + k, size);
 		}
 	}
 }
-- 
2.25.1


