Return-Path: <linux-bcache+bounces-1123-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 078A9AD4533
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 23:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EAA417D09C
	for <lists+linux-bcache@lfdr.de>; Tue, 10 Jun 2025 21:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B84728A714;
	Tue, 10 Jun 2025 21:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAhvHlFl"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B528A1E7;
	Tue, 10 Jun 2025 21:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592565; cv=none; b=a1XoN5qfzuaAHO6L2I1CLoJo91NjIpDxQe0wMfzqUGW04UIFmBv/Y8pngpF1zoQcLdAR9nnzu0o8G51Re2WYtsHGAMUl5CbvwSmfplEK55ao4ceNNzuYEokTK8LTqCaIwtBnL41xZDd4TzB3ME9Wee/WV/u6VKrbTB4bWDSS0Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592565; c=relaxed/simple;
	bh=P4f9UyqY3XMRd7kyJ9Xc5lVXzggwFJyamBL2GuKNAuc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NaSMrxk6p2cCIO1MXlYD0pPil+qyqDmv9P1VvVUSCBXaXxo6QrtGZEyoE8V3AbQn15PA6UCSpdc2Jubo2VEU6s2xHRy7sYsXqPY+8SQP7YyyPT8TnqC0ITutdJB6cWYl5FOjOtmg8APq8Z/rDRBeCpKABR4KmUiBFeG1KNyEiiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAhvHlFl; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7481600130eso5867960b3a.3;
        Tue, 10 Jun 2025 14:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749592563; x=1750197363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQiG2QS349Zbsw1Gl+byeM8NPhOPj/a1U4vce7IWCWA=;
        b=CAhvHlFlX08SB9iy+WeNLfyYwOIcuBXix2DzGTXCfltr7nl2E/cKTn4H8okSJ/jL4b
         xFf+ZDA93E0jBT7l9mFNqKdTMhdXFzo/uE2BuvE7d5ixbqTYC3nbjXRiuzFFUCvV7XGl
         VenjNZWZzrtAtqde305dThKJokzuWCWjeQXceABZpimjW8ACcmfnXWT3+c4OnTXVfwCJ
         RE/vfJ7G3SZkv+cihHnw87pL/csuXubmi82hOyscqTsvhAtIP/zDQrKh7buSiSQ5VPlh
         O31QMNRiApiM4bQ2JPy0txsyp0wdXkesYnCyp6a1UZhY/vKNzYW1JGxHtGHd6iEhlFTs
         6Q9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592563; x=1750197363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQiG2QS349Zbsw1Gl+byeM8NPhOPj/a1U4vce7IWCWA=;
        b=tLrMoloBhiH0GZxBOsYALEzS5ZCeZjrJlUfpt8MPAIQ/3rcAvw9NwQu6xMh47zg0VE
         YdDeokCYis57rAf1IWRsBDpC0nAdzfZNVeMFl+I7xRivsmslNHc2/wR83OPU8JWajeCC
         zmpNbLoJc8Ostml4s3+W8dBUVt2vt24K0t01ZCsM7DMI1UU6g9peMra4o85WSAbCr53D
         qPPpqnVH0fB5IPXY30J4xMPNmGobgZh4O6jZv1vNgsPeriqkTs985He7+mLkXJw1Kll1
         bwemNc1dYf82WQNJTSuCNYtIMeFAITA0PiEAhJ66S9wnoDX/vXsEsHFlGPMdq7h0digR
         2oDA==
X-Forwarded-Encrypted: i=1; AJvYcCURKXKr8LmB8YkrZO54BBfvGdVCaUwrEB08wBaswK/8mvJW/6pva/8D7Ym0a0uZ2jehWLqYmxZnWk7dBAQ=@vger.kernel.org, AJvYcCW4Odm5Z+/Clou8XeLHkbnSzlJD4B6bFk7cboBGthzZa+guJ9Tm5QZ+IXWfFynFD5fbiGOVrTtldXpg@vger.kernel.org, AJvYcCXjJF/xvh2aTKK41kJtnm861Z3spKSKg5+uQ+K7iHyGyuhu48R6rQW7Wd7OiUCdw88q3d6tcd4h@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0KOLm8CO0iaoutzoHLcBe9Gt7lLSQuv6Q7AJSXw7mVUnzKk7L
	zR2dUnfQ35Wzj3FemM/CCWZilR/Vmi1lpWWfWRGLdmJJ4FKV2raLjLOY
X-Gm-Gg: ASbGncvVaOQ9xxV5r6i30pMtmGENLmZlCbbFZaSK/tRKXCXVMtMlz5HZ82FsvkCy3bY
	F4xB1nqCmIH37Vuf9lm4nfJBxlQEJ0hPE2PmdZp5vU5EkS0nUxOwHdI7wTqI1H86TbHIWFiKYN2
	gir9B8Sr7sPvHom9BGBnTWJH2osmu3A98HzztBUT1Mdh5DGld/6wfvSdWN/ZRrnYvkJGomNSSt6
	yAWpmy4WAVR5yHNM36aV38dqtgACS7kuHSVssVcA8LAIxdS2pooF7VYceyOeuRZMz0sjuYDClQr
	V6b8r1NojBFqnildX/McBv/uiq9J6RN99kRv7R5w4BUoxMS0ubXIHl3S0joKjvvof8ie6o+19xC
	fYv/hDoRutstbpgZ9
X-Google-Smtp-Source: AGHT+IGgnTbVwuFawaz+uk3VdqNa3Ux4CpdL5YEtdYtPi8oUtZ1UAFN4k98bv6I5ilgpOUIWb/NCXA==
X-Received: by 2002:a05:6a00:848:b0:73e:598:7e5b with SMTP id d2e1a72fcca58-7486facfb03mr491064b3a.1.1749592562718;
        Tue, 10 Jun 2025 14:56:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482af3a165sm8173936b3a.11.2025.06.10.14.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 14:56:02 -0700 (PDT)
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
Subject: [PATCH 7/8] Documentation/core-api: min_heap: Document _eqaware variants of min-heap APIs
Date: Wed, 11 Jun 2025 05:55:15 +0800
Message-Id: <20250610215516.1513296-8-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610215516.1513296-1-visitorckw@gmail.com>
References: <20250610215516.1513296-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for equality-aware variants of min-heap maintenance
functions, which use a top-down sift_down strategy. These variants,
suffixed with _eqaware, reduce the number of comparisons to O(1) in
workloads with many elements of equal priority and can be used as
drop-in replacements for their standard counterparts.

Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 Documentation/core-api/min_heap.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/core-api/min_heap.rst b/Documentation/core-api/min_heap.rst
index 9f57766581df..012c82038b46 100644
--- a/Documentation/core-api/min_heap.rst
+++ b/Documentation/core-api/min_heap.rst
@@ -30,6 +30,26 @@ more expensive. As with the non-inline versions, it is important to use the
 macro wrappers for inline functions instead of directly calling the functions
 themselves.
 
+Equality-Aware Heap Maintenance
+-------------------------------
+
+In some workloads, a large number of elements in the heap may be equal under
+the user-defined comparison function. For such cases, the standard
+``min_heap_sift_down()`` implementation, which uses the bottom-up heapify
+strategy, can be inefficient. While bottom-up heapify reduces the number of
+comparisons by approximately 50% for randomly ordered data, it may perform up
+to :math:`2 \times \log_2(n)` comparisons in the presence of many equal
+elements.
+
+To address this, equality-aware versions of heap maintenance APIs are provided.
+These versions use the traditional top-down heapify strategy, which performs
+better - sometimes requiring only :math:`\mathcal{O}(1)` comparisons - when
+many elements are equal.
+
+The equality-aware APIs are suffixed with ``_eqaware``, and serve as drop-in
+replacements for their standard counterparts when equal elements are expected.
+
+
 Data Structures
 ===============
 
-- 
2.34.1


