Return-Path: <linux-bcache+bounces-233-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB58835664
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3897B22728
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4E9376F7;
	Sun, 21 Jan 2024 15:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzlPBqwt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B0B38385;
	Sun, 21 Jan 2024 15:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851433; cv=none; b=g2XTBd6dUxEZqeWOL32j2mi0mjI1u1a2/3eayzXzlufdC38ZjXkxfCQMA0KzRZnE/oZfUYYF8RuC30b3qTpe3HnME+AbWbvZUCmOJrI6LmoM55o1suFHIrFpCvXyVrBmwi/z5EA8mM52oGxWBg7UC28IdboU+ipk2nSdyCCHYPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851433; c=relaxed/simple;
	bh=tijDl2hnuKm9WbAUqkhD9/1J1vuoq4jZt7ycAR0fs4A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sLNcmpoAx+RGZEjPnpngMS0aK6d3Ooh1juxfDIUhW646INANFx0WkGulKjVY3JWVSvyF6j3xYcpbQ0K7u4qmnAiMgm9Wgtg79QZ+A9uVn3t+2X9EkvI6YXO1yrhELO8x6oUmboMoWjV7IyjI1oXgYIpDETicw8peREnF3zgmskU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gzlPBqwt; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28b93b04446so606646a91.0;
        Sun, 21 Jan 2024 07:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851431; x=1706456231; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iygKgI5ZDiaIj0nQgrBOB8aT9sAvWiPz2NR8vE+U8Qg=;
        b=gzlPBqwtr5Kvk1cTFJjZPdDKmd0HoQob82qtmF8u4L0VYypR6kNKzCrAFKvVee948z
         8MB7cpNxF5S6e9jFSLrXBjPyKQ+6mO661vEQuD8/1vSgOitDhvmUgazyYl0Ok8q4Bmw5
         DHIwJ9DGeCFeekJh+wFe8NqJzs5W1Bb4mz1mHNs2Cun8hCp2K7OMlR8+uvDr/uf2ntaM
         wuPys2cFJFJlgafiQTrAYkDsDXJ5KL1Zaev3hUTv6b+dwsycG38t0a9x5Kht72c97mSj
         v1tag6EpyHwqXPYlfWEABw/2GqUqE3u6rrOPimEXhkcF+4i+u5phzNzdz/aLekS7vkXo
         a+DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851431; x=1706456231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iygKgI5ZDiaIj0nQgrBOB8aT9sAvWiPz2NR8vE+U8Qg=;
        b=ZzVxGJ8MLMwRzBc59NjWTxXw/SxfuvstyymQIAz6nifwMnw/myp62zRjXcBScYusfE
         rX/WVqn4aRXQrM+YHnQ3HJE7Q8C8/9D+MlkGq2tgP5+rABJaTCxxORqMImz2xMd3Bked
         ZcwPIqDRDIjGO0zpK/H1JwthArU/KsOd4ATbSuhg+PIP0mQnUYLCvWQ5R7o/itjV/60O
         cLOsN9BYzsMzUrv9sT7En8f44tw3oQgg5gJiwoszKH+ol+3H3bCcpx88fUF4wv2C7PCV
         ebz7EZ68ZMWdSEpGL1LN7dn2Jo4KZmHA6go/bAqLdsbfH3jTx5nHraxYXK5gjF+FZ8d5
         noeQ==
X-Gm-Message-State: AOJu0Yw5Qt5xkgpbZH8RicdMzY1NNTP0r6LBhSGke+BhP555xleSFfIR
	DGkpUvOVPXhiZ2nOimeGkWqYzvax+S9jWy9xPh5x/2vnfiaGrO3Y
X-Google-Smtp-Source: AGHT+IGIdIgbXNxq7W6wY/eMqCNBhWI4UxT+2S/K6rteLkQcBYPfChzZQxgBkWOWB7WfemwzzXQXwA==
X-Received: by 2002:a17:90a:c098:b0:28e:3dcc:7381 with SMTP id o24-20020a17090ac09800b0028e3dcc7381mr3733782pjs.0.1705851431249;
        Sun, 21 Jan 2024 07:37:11 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:37:10 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 4/5] bcachefs: Optimize number of comparisons in heap_sift_down
Date: Sun, 21 Jan 2024 23:36:48 +0800
Message-Id: <20240121153649.2733274-5-visitorckw@gmail.com>
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

Optimize the heap_sift_down() macro, resulting in a significant
reduction of approximately 50% in the number of comparisons for large
random inputs, while maintaining identical results.

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
| 10000 |     239233       |     142673       |   1219 us |   1000 us |
| 20000 |     518498       |     305394       |   2564 us |   1904 us |
| 30000 |     812864       |     476594       |   4197 us |   3203 us |
| 40000 |    1117553       |     651737       |   5666 us |   4290 us |
| 50000 |    1430128       |     830600       |   7156 us |   5574 us |
| 60000 |    1746128       |    1012201       |   8862 us |   7036 us |
| 70000 |    2066099       |    1196653       |  10454 us |   8111 us |
| 80000 |    2394593       |    1383311       |  11993 us |   9602 us |
| 90000 |    2727097       |    1572381       |  13501 us |  10718 us |
| 100000|    3059841       |    1763083       |  15325 us |  11776 us |

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
This patch has undergone unit testing and micro benchmarking using the
following code [1].

[1]:
static long long int cmp_count = 0;

typedef HEAP(u32) heap;

int mycmp(heap *h, u32 a, u32 b)
{
    cmp_count++;
    if (a < b)
        return -1;
    if (a > b)
        return 1;
    return 0;
}

int check_heap(heap *h, int (*cmp)(heap *, u32, u32))
{
    size_t i;

    for (i = 0; i < h->used / 2; i++) {
        if (i * 2 + 1 < h->used)
            if (cmp(h, h->data[i], h->data[i * 2 + 1]) > 0)
                return -1;
        if (i * 2 + 2 < h->used)
            if (cmp(h, h->data[i], h->data[i * 2 + 2]) > 0)
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
            heap_add(&myheap, get_random_u32(), mycmp, NULL);
            if (check_heap(&myheap, mycmp))
                return -1;
        }
        for (i = 0; i < N; i++) {
            heap_pop(&myheap, x, mycmp, NULL);
            if (check_heap(&myheap, mycmp))
                return -1;
        }
        free_heap(&myheap);
    }

	/* Micro-benchmark. */
	for (N = 10000; N <= 100000; N += 10000) {
		cmp_count = 0;
        init_heap(&myheap, N, GFP_KERNEL);

        start = ktime_get();
        for (i = 0; i < N; i++)
            heap_add(&myheap, get_random_u32(), mycmp, NULL);
        for (i = 0; i < N; i++)
            heap_pop(&myheap, x, mycmp, NULL);
        end = ktime_get();
		delta = ktime_us_delta(end, start);
        printk(KERN_INFO "time: %lld\n", delta);
        printk(KERN_INFO "comparisons: %lld\n", cmp_count);
        free_heap(&myheap);
    }

    return 0;
}

 fs/bcachefs/util.h | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index c75fc31915d3..be22eb63084b 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -131,17 +131,20 @@ do {									\
 
 #define heap_sift_down(h, i, cmp, set_backpointer)			\
 do {									\
-	size_t _c, _j = i;						\
+	size_t _j, _k;							\
 									\
-	for (; _j * 2 + 1 < (h)->used; _j = _c) {			\
-		_c = _j * 2 + 1;					\
-		if (_c + 1 < (h)->used &&				\
-		    cmp(h, (h)->data[_c], (h)->data[_c + 1]) >= 0)	\
-			_c++;						\
-									\
-		if (cmp(h, (h)->data[_c], (h)->data[_j]) >= 0)		\
-			break;						\
-		heap_swap(h, _c, _j, set_backpointer);			\
+	for (_j = i; _k = _j * 2 + 1, _k + 1 < (h)->used;) {		\
+		if (cmp(h, (h)->data[_k], (h)->data[_k + 1]) >= 0)	\
+			_k++;						\
+		_j = _k;						\
+	}								\
+	if (_j * 2 + 2 == (h)->used)					\
+		_j = _j * 2 + 1;					\
+	while (_j != i && cmp(h, (h)->data[i], (h)->data[_j]) <= 0)	\
+		_j = (_j - 1) / 2;					\
+	for (_k = _j; _j != i;) {					\
+		_j = (_j - 1) / 2;					\
+		heap_swap(h, _j, _k, set_backpointer);			\
 	}								\
 } while (0)
 
-- 
2.25.1


