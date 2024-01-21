Return-Path: <linux-bcache+bounces-230-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9DDD83565B
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:37:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7557B21F1C
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221653770A;
	Sun, 21 Jan 2024 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bIOJk50/"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B23C37702;
	Sun, 21 Jan 2024 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851422; cv=none; b=Fwco7426CbeNXmrK4FI11SB5FPgBtXw+SrSzj3QRra4dAGX3vzM6BOJgCJKjkpsdyLYbuAdMA4g8fnsEHR6mQT783ZGZY7eK1D1mXlrtML9Q8l09KpDJx6M92xU12XqeghY3QPEhH74D5+eFCnK66UoYq0UyDvpsNFxC2x+44Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851422; c=relaxed/simple;
	bh=F2S6WYJX/d0/D0HlTXYXOZ5EKWmUIRf6nsWTG7vHf00=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BxIP8scvzY3B0IWxjYB8wlgJ1910BRsZvmDkHIy9MzR2VZB36irNavJ8AvuwanvUfKpXlV8vKw4cXyWqxFYTstdOgvEv5Uweg1ukaxcEIk6ggB/kphJKsI8NeZVQEQuwkgwlBIxANFWHGwuJa40TcponaZRwuKB+HNkU1W5PYFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bIOJk50/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1d3b84173feso6781785ad.1;
        Sun, 21 Jan 2024 07:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851420; x=1706456220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dLlh0MVCcmdBauFIBsS5gCwpIFl7Oy5O74VPwVPzmOA=;
        b=bIOJk50/4cJbXL0TWiUIBnrTIF47s029IhoymVaincNjb4iWfdoERUcpzhpNf8mWX2
         MTe2MmKAXtZ3Kk5LiFy+G+Dn93YpxO6gbPUA9oxDCUWXaNgDrac53fivD8jmq5oZ8xF1
         8+d3STlb495K4Om7LBCHIz5xJaNnh0G5wt7qPyllI4NURF30RQRRIcyN1ZdMHm3h4ie6
         PAHFirqMaO366u8hF3Vy/+V6fJnieTH2OvK36V35fvbhBxvUEOzsI1ZyGm1r0XWhR2Mq
         4moVshbdU0CQPDMLD6/zMpA1tiOq/Rx6fuyF1hkpwDrv+mILnjjRHCcJRIQA4kCfV1Cp
         7U2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851420; x=1706456220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dLlh0MVCcmdBauFIBsS5gCwpIFl7Oy5O74VPwVPzmOA=;
        b=xEKJGDhjSfCgfiuXvo0eJdEZU3PFxqumG9OUN0twqmA1xGA4x+OZvDBALkKnoi0ngq
         OCt1MGZga2/e7glj2wiXFCnSg8QRVMQsPVpJQXLKP8u9Nwv2qjU0/1MzwN/9+WZlBPlt
         T/7IdeiS+zuEdspycVFqbjH/lrPWTJitGe63HLm1/vmZUcGb6fJFm4jr5vIXLhmCX0kQ
         PdX/2Kof3KLRzVckk5O3usjYmadG1V4GwKmELyerTAlWyH4BE0CuJ8bxFGHNpyDCama0
         dwjSHQO+mL+YABYHcykVTx0aPJ+zZOsSws0rSw6mbn5+9Tf8qR5UKLmmyuUsH7UG3w8w
         gVCA==
X-Gm-Message-State: AOJu0YwESkbuLjvMC3jcPf8b3rrQic9N6+PISpkPh7SdS6sJV2cGs9Ev
	ETVZkNWlQGMdE3XDThd9uqgOyamZ1W/vdaECq/LYGVvxxO3iYPI9
X-Google-Smtp-Source: AGHT+IFK80cqD5kDScW3aeShBmpheDZ8RdnJZlICoPR6ox7z5ef7doIKv7RuHqsgBBo46v7ZHK1raQ==
X-Received: by 2002:a17:90b:3443:b0:290:4cc1:5051 with SMTP id lj3-20020a17090b344300b002904cc15051mr3596335pjb.2.1705851419911;
        Sun, 21 Jan 2024 07:36:59 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:36:59 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 1/5] bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
Date: Sun, 21 Jan 2024 23:36:45 +0800
Message-Id: <20240121153649.2733274-2-visitorckw@gmail.com>
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

Currently, eytzinger0_sort employs the textbook version of heapsort,
where during the heapify process, each level requires two comparisons
to determine the maximum among three elements. In contrast, the
bottom-up heapsort, during heapify, only compares two children at each
level until reaching a leaf node. Then, it backtracks from the leaf
node to find the correct position. Since heapify typically continues
until very close to the leaf node, the standard heapify requires about
2*log2(n) comparisons, while the bottom-up variant only needs log2(n)
comparisons.

The experimental data presented below is based on an array generated
by get_random_u32().

|   N   | comparisons(old) | comparisons(new) | time(old) | time(new) |
|-------|------------------|------------------|-----------|-----------|
| 10000 |     235381       |     136615       |  25545 us |  20366 us |
| 20000 |     510694       |     293425       |  31336 us |  18312 us |
| 30000 |     800384       |     457412       |  35042 us |  27386 us |
| 40000 |    1101617       |     626831       |  48779 us |  38253 us |
| 50000 |    1409762       |     799637       |  62238 us |  46950 us |
| 60000 |    1721191       |     974521       |  75588 us |  58367 us |
| 70000 |    2038536       |    1152171       |  90823 us |  68778 us |
| 80000 |    2362958       |    1333472       | 104165 us |  78625 us |
| 90000 |    2690900       |    1516065       | 116111 us |  89573 us |
| 100000|    3019413       |    1699879       | 133638 us | 100998 us |

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
    size_t N, i, L, R;
	ktime_t start, end;
	s64 delta;
    u32 *arr;

	for (N = 10000; N <= 100000; N += 10000) {
		arr = kmalloc_array(N, sizeof(u32), GFP_KERNEL);
		cmp_count = 0;

		for (i = 0; i < N; i++)
			arr[i] = get_random_u32();
		
		start = ktime_get();
		eytzinger0_sort(arr, N, sizeof(u32), mycmp, NULL);
		end = ktime_get();

		delta = ktime_us_delta(end, start);
        printk(KERN_INFO "time: %lld\n", delta);
		printk(KERN_INFO "comparisons: %lld\n", cmp_count);

		for (int i = 0; i < N; i++) {
            L = 2 * i + 1;
            R = 2 * i + 2;
            if (L < N && arr[i] < arr[L])
                goto err;
            if (R < N && arr[i] > arr[R])
                goto err;
        }

		kfree(arr);
	}
    return 0;

err:
    kfree(arr);
    return -1;
}

 fs/bcachefs/util.c | 50 +++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index c2ef7cddaa4f..bbc83b43162e 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -911,7 +911,7 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 		     int (*cmp_func)(const void *, const void *, size_t),
 		     void (*swap_func)(void *, void *, size_t))
 {
-	int i, c, r;
+	int i, j, k;
 
 	if (!swap_func) {
 		if (size == 4 && alignment_ok(base, 4))
@@ -924,17 +924,22 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 
 	/* heapify */
 	for (i = n / 2 - 1; i >= 0; --i) {
-		for (r = i; r * 2 + 1 < n; r = c) {
-			c = r * 2 + 1;
-
-			if (c + 1 < n &&
-			    do_cmp(base, n, size, cmp_func, c, c + 1) < 0)
-				c++;
-
-			if (do_cmp(base, n, size, cmp_func, r, c) >= 0)
-				break;
-
-			do_swap(base, n, size, swap_func, r, c);
+		/* Find the sift-down path all the way to the leaves. */
+		for (j = i; k = j * 2 + 1, k + 1 < n;)
+			j = do_cmp(base, n, size, cmp_func, k, k + 1) > 0 ? k : k + 1;
+
+		/* Special case for the last leaf with no sibling. */
+		if (j * 2 + 2 == n)
+			j = j * 2 + 1;
+
+		/* Backtrack to the correct location. */
+		while (j != i && do_cmp(base, n, size, cmp_func, i, j) >= 0)
+			j = (j - 1) / 2;
+
+		/* Shift the element into its correct place. */
+		for (k = j; j != i;) {
+			j = (j - 1) / 2;
+			do_swap(base, n, size, swap_func, j, k);
 		}
 	}
 
@@ -942,17 +947,22 @@ void eytzinger0_sort(void *base, size_t n, size_t size,
 	for (i = n - 1; i > 0; --i) {
 		do_swap(base, n, size, swap_func, 0, i);
 
-		for (r = 0; r * 2 + 1 < i; r = c) {
-			c = r * 2 + 1;
+		/* Find the sift-down path all the way to the leaves. */
+		for (j = 0; k = j * 2 + 1, k + 1 < i;)
+			j = do_cmp(base, n, size, cmp_func, k, k + 1) > 0 ? k : k + 1;
 
-			if (c + 1 < i &&
-			    do_cmp(base, n, size, cmp_func, c, c + 1) < 0)
-				c++;
+		/* Special case for the last leaf with no sibling. */
+		if (j * 2 + 2 == i)
+			j = j * 2 + 1;
 
-			if (do_cmp(base, n, size, cmp_func, r, c) >= 0)
-				break;
+		/* Backtrack to the correct location. */
+		while (j && do_cmp(base, n, size, cmp_func, 0, j) >= 0)
+			j = (j - 1) / 2;
 
-			do_swap(base, n, size, swap_func, r, c);
+		/* Shift the element into its correct place. */
+		for (k = j; j;) {
+			j = (j - 1) / 2;
+			do_swap(base, n, size, swap_func, j, k);
 		}
 	}
 }
-- 
2.25.1


