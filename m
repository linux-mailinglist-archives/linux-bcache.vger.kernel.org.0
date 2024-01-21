Return-Path: <linux-bcache+bounces-234-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B1EA835666
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF8A0282327
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11884376FE;
	Sun, 21 Jan 2024 15:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ucqf9o1m"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9482A383BA;
	Sun, 21 Jan 2024 15:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851437; cv=none; b=ezkxdlLcmJIhQZrZDI/mu1MAxAnrRFDMSEssSFLf75m5Sup2jKYuy6w2jb7wvf5dRnaAOcL6ePSDY+7kXNvSsPg8Vl6tmOFiv1X0IW8caZ/LQm6ouh7C6HbByA3r9BBfp03iElUi3Nc/huXKZDlFJ7hbtGw8A//oX3ZKFR4CHEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851437; c=relaxed/simple;
	bh=/VqrbHUIRmrLzrdN+YUUNaTaIebnWjB3AeI+d3LBsk4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tab9B317JCvR+flhM7eG0m/Om/QPW6BQZRD2fiVVhk3jHymM/qJbRIl/A4skEYah8dwShTH5aUbbVWd1cNBNHUKscRJ4YQ3WYP4QXGzV/cdIkpJoV9o16ZnWobsTUCAA8GK1vwukjxbu5JXjP7RuxO8ofGCtxbGaEe5HZo2N7IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ucqf9o1m; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5cdbc42f5efso194278a12.0;
        Sun, 21 Jan 2024 07:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851435; x=1706456235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l18zRlt2Y1RNd/KM4WSl1s19uASsIpnGpnt5xxTh/gA=;
        b=Ucqf9o1mFallL8saWFNH6iKgwij3WAxUv6o7wEPAcXxfsLK73YZ+D03lYeObvioHmF
         WKnrdpmC7zUD1Rj3hc/Catf+UX7BexD8vSjRK+zpLhQZG+d4jBhwFcnY6pGMpnypU8PV
         yb8/qB9HPto9KejvsALTKtWrFKLh2iILHnFN5oCUh6WLFCvhg/bFqwnobjVqa37eby9F
         IrEvc/KGD9CM4ZvxB/ZngpVjn2COxYY/UdlySyq/mES2JW95wwfXY10AqoZUO78bBBpe
         91PF0fYTTHW4yH5Sc1MVucXKTqsxspMZVxSakNdzI5NCeMwxkIafTAHMDJtVSDkACXaf
         PaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851435; x=1706456235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l18zRlt2Y1RNd/KM4WSl1s19uASsIpnGpnt5xxTh/gA=;
        b=JTjG3exd8qK1AGpVxq/Ib1YMcO6ng6PlYvLYEEVyi6UOGQxBFhWLhjkplWZvDT6YIT
         QxAnw9SBv8VvykOkMS8KnULab+GdeSaq+B868rL/W6lFR8bLVIEg+mo2jYNUUN3khf87
         Yj/qYkOpicW7HqoX0OqbN44R0XzGqcRtWz72iHpWlDUROEXpUGjEtFzrPW6snR3QT5eU
         6Bt9MxDsHP3VYZKxMEvZxupaGLiIc3CXf1SKsOxd+nQp0AbPh/EiPR2eSDuGLsxBSMgC
         XTFJlWg/CRONsc1wx8+qWr5dEuDdyYf39xPDFbKoBJ3SrY+qMCRyGWFue9Xcu8eIv7Rh
         RmDQ==
X-Gm-Message-State: AOJu0Yxy5Xi7Pi1rzZEyP63oo4xsPeOPpXZh+yipc1Jbb/xSM2rnAHTG
	fXjOsK50HjdlrmIwHIV0GxHmPSPu/hIamsxbUobeRQFlmEOUq7Se
X-Google-Smtp-Source: AGHT+IEj47iqSM/u5cnpFwEi+Tlit4Kq3eDjT8Fcn9cvyD2BTStrxajADI0G6lDHkblf2BuAGIFa5Q==
X-Received: by 2002:a17:902:ee05:b0:1d3:c5e4:b2f6 with SMTP id z5-20020a170902ee0500b001d3c5e4b2f6mr6021894plb.4.1705851434840;
        Sun, 21 Jan 2024 07:37:14 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:37:14 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 5/5] bcache: Optimize number of comparisons in heap_sift
Date: Sun, 21 Jan 2024 23:36:49 +0800
Message-Id: <20240121153649.2733274-6-visitorckw@gmail.com>
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

Optimize the heap_sift() macro, resulting in a significant reduction of
approximately 50% in the number of comparisons for large random inputs,
while maintaining identical results.

The current implementation performs two comparisons per level to
identify the maximum among three elements. In contrast, the proposed
bottom-up variation uses only one comparison per level to assess two
children until reaching the leaves. Then, it sifts up until the correct
position is determined.

Typically, the process of sifting down proceeds to the leaf level,
resulting in O(1) secondary comparisons instead of log2(n). This
optimization significantly reduces the number of costly indirect
function calls and improves overall performance.

The experimental data below is derived from first adding N elements
generated by get_random_u32() to the heap, and then performing heap_pop
until the heap is empty.

|   N   | comparisons(old) | comparisons(new) | time(old) | time(new) |
|-------|------------------|------------------|-----------|-----------|
| 10000 |     249215       |     164872       |   1253 us |    958 us |
| 20000 |     539766       |     350113       |   2693 us |   2059 us |
| 30000 |     843297       |     543037       |   4120 us |   3119 us |
| 40000 |    1159127       |     739595       |   5624 us |   4221 us |
| 50000 |    1482608       |     941655       |   7147 us |   5349 us |
| 60000 |    1808772       |    1144716       |   8754 us |   6786 us |
| 70000 |    2139443       |    1348878       |  10323 us |   8030 us |
| 80000 |    2478304       |    1560892       |  11934 us |   9061 us |
| 90000 |    2820532       |    1768678       |  13611 us |  10679 us |
| 100000|    3163503       |    1983806       |  15244 us |  11745 us |

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
This patch has undergone unit testing and micro benchmarking using the
following code [1].

[1]:
static long long int cmp_count = 0;

typedef DECLARE_HEAP(u32, heap);

int mycmp(u32 a, u32 b)
{
    cmp_count++;
    return a > b;
}

int check_heap(heap *h, int (*cmp)(u32, u32))
{
    size_t i;

    for (i = 0; i < h->used / 2; i++) {
        if (i * 2 + 1 < h->used)
            if (cmp(h->data[i], h->data[i * 2 + 1]))
                return -1;
        if (i * 2 + 2 < h->used)
            if (cmp(h->data[i], h->data[i * 2 + 2]))
                return -1;
    }
    return 0;
}

static int test(void)
{
    size_t N, i;
    u32 x;
    heap myheap;
    ktime_t start, end;
	s64 delta;

	/* Test for correctness. */
    for (N = 1000; N <= 10000; N += 1000) {
        init_heap(&myheap, N, GFP_KERNEL);
        for (i = 0; i < N; i++) {
            heap_add(&myheap, get_random_u32(), mycmp);
            if (check_heap(&myheap, mycmp))
                return -1;
        }
        for (i = 0; i < N; i++) {
            heap_pop(&myheap, x, mycmp);
            if (check_heap(&myheap, mycmp))
                return -1;
        }
        free_heap(&myheap);
    }

	/* Micro-benchmark. */
	for(N = 10000; N <= 100000; N += 10000) {
		cmp_count = 0;
        init_heap(&myheap, N, GFP_KERNEL);

        start = ktime_get();
        for (i = 0; i < N; i++)
            heap_add(&myheap, get_random_u32(), mycmp);
        for (i = 0; i < N; i++)
            heap_pop(&myheap, x, mycmp);
        end = ktime_get();
		delta = ktime_us_delta(end, start);
        printk(KERN_INFO "time: %lld\n", delta);
        printk(KERN_INFO "comparisons: %lld\n", cmp_count);
        free_heap(&myheap);
    }

    return 0;
}

 drivers/md/bcache/util.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index f61ab1bada6c..3aa74b0d7f0a 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -56,17 +56,20 @@ do {									\
 
 #define heap_sift(h, i, cmp)						\
 do {									\
-	size_t _r, _j = i;						\
+	size_t _j, _k;							\
 									\
-	for (; _j * 2 + 1 < (h)->used; _j = _r) {			\
-		_r = _j * 2 + 1;					\
-		if (_r + 1 < (h)->used &&				\
-		    cmp((h)->data[_r], (h)->data[_r + 1]))		\
-			_r++;						\
-									\
-		if (cmp((h)->data[_r], (h)->data[_j]))			\
-			break;						\
-		heap_swap(h, _r, _j);					\
+	for (_j = i; _k = 2 * _j + 1, _k + 1 < (h)->used;) {		\
+		if (cmp((h)->data[_k], (h)->data[_k + 1]))		\
+			_k++;						\
+		_j = _k;						\
+	}								\
+	if (_j * 2 + 2 == (h)->used)					\
+		_j = _j * 2 + 1;					\
+	while (_j != i && cmp((h)->data[_j], (h)->data[i]))		\
+		_j = (_j - 1) / 2;					\
+	for (_k = _j; _j != i;) {					\
+		_j = (_j - 1) / 2;					\
+		heap_swap(h, _j, _k);					\
 	}								\
 } while (0)
 
-- 
2.25.1


