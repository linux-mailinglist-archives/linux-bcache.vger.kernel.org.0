Return-Path: <linux-bcache+bounces-1116-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 193FAAD4519
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB66F188674A
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D52283138;
	Tue, 10 Jun 2025 21:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJLuQHBd"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173871401C;
	Tue, 10 Jun 2025 21:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592543; cv=none; b=a5/+BcdJo4Zw8dc80sHZpQDDHyWbMRwA46UugD1KNm0VcmyM0iGXt6Q/B/rgZZPX3/j0nfttxc0gUJIvoxGhclccc2881aidcT/Tk0zBsb/ce1ULvHR2tcV+c/qqAA5w1l/aDx531xxTOLi9WFUi1KgQBj3b/8p+yWfmkuFxX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592543; c=relaxed/simple;
	bh=7Kw7leYwnoZRD3Gzqb3C7xpXxDTPa1VJVS79XfwnghE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fngjOYrUhxqPYcMr2N+Myp4DbgJV/oFA1d0jo9RscyZsvpgfZbRgAhaoSC0jFQbrXmL/w/kg9imIuuhjwYV7ry52ahMB1ERXascPYILv5em8qQ5zNNje2wdcuHMQNxnfsornK10rCTHlhHBhPM8K+pB3SFnR2zznOUqckfTf53Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJLuQHBd; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7485bcb8b7cso1595119b3a.1;
        Tue, 10 Jun 2025 14:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592541; x=1750197341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xzzLX0zigjvsXV7HMCJnSlWCkuAr80/vdNSBICliE+E=;
        b=KJLuQHBdv/SpBc5OLkf4ayJcyCdiH32l31DZp3ouTwgcgvQ8Q4bjUpRVf5bOrJIqbj
         q5vY7OVU36v6z5ymXS6+If0toqaRihCRWkHyaZmzSBe911H8Rr8gHgOphWXeB2UReDw7
         YMrsy4T03vWgEINnEPHMJQpUD7skz5+DmiX1xUZoFZfXP0TDNJK01tqlQyMSPxMtfl3a
         +pbm05ZYpnJIj1W71TFCmB3rmiH3D3JVqTtGJVv7IAvmVFJ6md69qZeVI3fAoTbU1o3H
         0J2E/d9cv4dyuBrDrfslP6d68+CpaWZvfcvxSZP/UxLBpHx+5nvgYfRcZBO8h1lCi7mJ
         hrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592541; x=1750197341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xzzLX0zigjvsXV7HMCJnSlWCkuAr80/vdNSBICliE+E=;
        b=TRunw+TaGERP3ZCXawe8c4iZhy7ci7/Xa62flxIbXMPFeiKVdzYxvru9+kFu5Ep/vP
         2X+H/h6nmjrAhuoO3WJyE9qmuhhXQIusr4x1Y/FO3cn40oR4Yr7DOFAdhTYECzQkFGpN
         sFxWN/orMF3Z8RJFhYc7RmtNQFm5at1ml0hXduziq5sVHtTIyj7PTBIiZPViBJnAuxcy
         yYw2AAhCvhobXpgr3oEJXfqxgAOAP5kb4cwEKTFaivfGeWkDRS0BQ3YxKBhRyiV1cUUx
         RLbcq1l1UyZYSP91BiE5lnK36YrgNbV7JZ+npxxPymyvz+vRErgxPCWJZ6AmucYso4Qt
         vPbg==
X-Forwarded-Encrypted: i=1; AJvYcCVmPvuNFjwo4MW2nONTHFylFwRLrgKrGo7npBv3r4ib154v0EeIpqXIqXtKExDv/HarYH0M5BWI@vger.kernel.org, AJvYcCXbXaNzBGh2UBAV/Q15aiEdPMgXrKoUPUMLgrRNOZ9BYk3jHN6K0xjWv8oSRFQ7TeG9iTzvLiokksxAiHs=@vger.kernel.org, AJvYcCXpvfpUoCNiAusxKSmPj7vACyYS/Yy8mTMLp24YXsqdXOO6tStU8sKghtv02/BLRUldOS+A0iv1PBiD@vger.kernel.org
X-Gm-Message-State: AOJu0YxVVmuXgn1vWRgQnO/F+/vk7rQtWseVDQYDczFDUNzhiyRiyYTW
	d6RWzhImPviYWg9NBDs3v3Ov3PaGUX/5Okj4S9ubSj9swZ91IEwE3g9I
X-Gm-Gg: ASbGncs+8KxcroLpbldCCPppbL+7gQvpZZ5y4/AGYjI6TJdDiAe2XYrNn5MK3/6M5ne
	emX/Lb54mLou+9oi0+SJPemEI2PQibLC4nKfYmF0LdiMK+zmL9tFg8ye7ciVYp+GqE6d+kWQ/KA
	LsMjM5C+HmvziBSSBdjZuNGyRV4s74JVEcnuiQCKu3CcTLRpCdn1/mOTPHjzdLTe1O2NrKqUoRp
	fVCUHUk3XPqinmsRMN3FCngC3ySBC406dpOWQB1Nz/wpxlXQKe0iq7ATftzYB4raevC+gwyLok+
	zKW92ReGqh3FgVOKfHCN2PkVAhu42+qo7wt/n4vUBU9ZxQ1gg6VyX1IJJNH0w8oMvpYQdzdfGCU
	kRYMDwx6DartYECZO
X-Google-Smtp-Source: AGHT+IHuaOXKKB2sK17JiPq7MI/MRGPzkTbmX/Mg57tFKCaQI1mtQ9m3NGGKdrDgKrP2VcZJMKOXkQ==
X-Received: by 2002:a05:6a00:1951:b0:746:227c:a808 with SMTP id d2e1a72fcca58-7486ce3ba0bmr1660168b3a.24.1749592541250;
        Tue, 10 Jun 2025 14:55:41 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:55:40 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: corbet@lwn.net,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 0/8] Fix bcache regression with equality-aware heap APIs
Date: Wed, 11 Jun 2025 05:55:08 +0800
Message-Id: <20250610215516.1513296-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series introduces equality-aware variants of the min heap
API that use a top-down heapify strategy to improve performance when
many elements are equal under the comparison function. It also updates
the documentation accordingly and modifies bcache to use the new APIs
to fix a performance regression caused by the switch to the generic min
heap library.

In particular, invalidate_buckets_lru() in bcache suffered from
increased comparison overhead due to the bottom-up strategy introduced
in commit 866898efbb25 ("bcache: remove heap-related macros and switch
to generic min_heap"). The regression is addressed by switching to the
equality-aware variants and using the inline versions to avoid function
call overhead in this hot path.

Cc: stable@vger.kernel.org
---

To avoid duplicated effort and expedite resolution, Robert kindly
agreed that I should submit my already-completed series instead. Many
thanks to him for his cooperation and support.

Kuan-Wei Chiu (8):
  lib min_heap: Add equal-elements-aware sift_down variant
  lib min_heap: Add typedef for sift_down function pointer
  lib min_heap: add eqaware variant of min_heapify_all()
  lib min_heap: add eqaware variant of min_heap_pop()
  lib min_heap: add eqaware variant of min_heap_pop_push()
  lib min_heap: add eqaware variant of min_heap_del()
  Documentation/core-api: min_heap: Document _eqaware variants of
    min-heap APIs
  bcache: Fix the tail IO latency regression by using equality-aware min
    heap API

 Documentation/core-api/min_heap.rst |  20 +++++
 drivers/md/bcache/alloc.c           |  15 ++--
 include/linux/min_heap.h            | 131 +++++++++++++++++++++++-----
 lib/min_heap.c                      |  23 +++--
 4 files changed, 154 insertions(+), 35 deletions(-)

-- 
2.34.1


