Return-Path: <linux-bcache+bounces-1138-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03588AD9FB5
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 22:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA3003B802C
	for <lists+linux-bcache@lfdr.de>; Sat, 14 Jun 2025 20:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8918B2E8896;
	Sat, 14 Jun 2025 20:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MQShtxQp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B1F2E7F11;
	Sat, 14 Jun 2025 20:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749932675; cv=none; b=mkXriSITcwm3HglnPrJb6TwaEfWBAmBOffhI2zCgA+Q2kuCwOpymnM6nqYjlhboHaAz+RsRAwa9RgMZEg40v4fnVJPOwxRpClO0x7W3Pec8+eX0Rs72bw50WT2AbywfPGeTBaAShJUXKslMYlNyGHBLoRynihz3RV8vLqMIu8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749932675; c=relaxed/simple;
	bh=/nPUNYT0M9vpqDN2YDJhl+LtGIFZwutUWruPsgjSrZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WSi8NhxI/GeJh/mxRm9hgI5/Xb54sUJuFS8yMY6saNDDqTH5eSbS0VhOs9qWACdqtAKiEDlNxJcR/hOdSy9we3zTLhDHudvaRsTKn/HeKmTPIv6+jucOF01xk26CyibUSvP5oayIPJGfLAucK6aSjPO5sAMEe7l/a15s1TJky1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MQShtxQp; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7489dfb71a8so745357b3a.1;
        Sat, 14 Jun 2025 13:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749932673; x=1750537473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BeLfvqj/4d+vVfQI829QhhRWfMlVlhJ0oopKK5Rq8XM=;
        b=MQShtxQpH1bX/qrZKnIPRpsBg5/Q4YBHR1EVC0qmx1xYO7tfMKEQ9QW9fiWMuXnpsv
         LVLLnnX3w+L4SHIztjrwJG3eNeFrT9dfUDupn/e1IQOJf2sFi6BUHRaRPmR/PjznW616
         rXiMS+8xYs9MntkAwXqrbShHlRt+oOjZAAK9W6VC8ahlyPR58TqQkEPwsK7I/bLdGaND
         SmdY+BlZ6Ha+QXn2z8juGapoYE2T8rHAjhFgjJZnG5Je4PgIcW8reb54/fMsoluFQGQx
         oxsAAVPo01qR5DknBKeOR5npSl8klIwErijsvkYM/fNe8Knhyd0Ba3hiR9K/phlA9Ff9
         FaJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749932673; x=1750537473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BeLfvqj/4d+vVfQI829QhhRWfMlVlhJ0oopKK5Rq8XM=;
        b=xOBtdUtwXLs0AI/yabb8oC6d0nI5D97VCthrzNYncgmyzHJZUmBBSMTmejHJJXEfIJ
         ecei9bXlJwpQMJshEGKBWLnHYsPLDdyiRoKD0e3mtMlfuRPJ0m0vVLB+i6I71LcQnkhB
         IygzYc0eA2Gr5m6zA8tHmGzfQJ9Y1Ov8xnKV9EIESIrIa/xdCbC7o5p3nZkK4LEAMZZ6
         3okcC9F8fAEdMm3Xsw2rF+SUHgAM78OdrSygezVskb2hfLVHejucdLiZ63R+22L9FGVH
         QGnxjHv8AWSNepppZhsas3aPEgCudMJtowsHcvWQuGlowfV0dOxnB/bi/KxgKG7oQNpT
         LBWQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1duL68Qzbq8vwqFuX5MCKHuuJhhUVYmotgCUoFLD4qzPfuvdQE9GvAOOPAyITeBcpyV8nIp/AEOIZUjk=@vger.kernel.org, AJvYcCWFeuR2OuNjaSYrxe5ONgYjyAuB5RSxIGtKqgML00RtXnZdLOUAoAMLTTQ9+R+d0yhle60If9pZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwjFTrAJXuC+rEfEMTt6v3eoXtM4QO8Pih7MRCB7oxckmPzEFDO
	srhBp5mEEXR1WwlWpiQX6o3MwtUc14ZDkehF8YMAScHtYj14e9WTUzvr
X-Gm-Gg: ASbGncszHPbcSHmvMWnEGRSOZSfm7WyylZyoEGRi40esyrbeAUwC17vaxAdb7Sz79fx
	wQmiv34AGzTBp1tCuQZ03Un5HRBZVK7kuTKTzSYu32Lk+az4Z8VHV4pUtm1Zg/sV3iZ9EDhCRwR
	h1Jn5tW3q7IiuSUgTkzap4TUrl30ZFNuRvt1BaE1nHzgMZEZHOuNdyRd9dvjD3kZbS+pree152I
	kQwI61ziZWTmfe4futE9B6K43r3AbPHFDdoEj5i+UQFUelnPjiznB8K0J3/SoC6K8Hu6YEKWNPu
	xnrXVqudg8sn7MssDR7fj3koQVnkHFZeG+RDRtZtIF2HxE1vPRAXArWxGklxiG+HlEl4ipb0dbH
	s6Lnn4Q2Wz04j/y0Eq1W8ZHLyuHg=
X-Google-Smtp-Source: AGHT+IEX1VdCB0tSnpuHFmmxai4lc5c2Hfil5CzoES0bMZ28X1GSLrHf67e2/uSKtVP7/y6myFqe/w==
X-Received: by 2002:a05:6a00:2186:b0:748:33f3:8da8 with SMTP id d2e1a72fcca58-7489cfc2976mr4323401b3a.5.1749932673105;
        Sat, 14 Jun 2025 13:24:33 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d738esm3863351b3a.177.2025.06.14.13.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 13:24:32 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: akpm@linux-foundation.org,
	colyli@kernel.org,
	kent.overstreet@linux.dev,
	robertpang@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	jserv@ccns.ncku.edu.tw,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] bcache: Remove unnecessary select MIN_HEAP
Date: Sun, 15 Jun 2025 04:23:53 +0800
Message-Id: <20250614202353.1632957-4-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250614202353.1632957-1-visitorckw@gmail.com>
References: <20250614202353.1632957-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After reverting the transition to the generic min heap library, bcache
no longer depends on MIN_HEAP. The select entry can be removed to
reduce code size and shrink the kernel's attack surface.

This change effectively reverts the bcache-related part of commit
92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap
API functions").

This is part of a series of changes to address a performance
regression caused by the use of the generic min_heap implementation.

As reported by Robert, bcache now suffers from latency spikes, with
P100 (max) latency increasing from 600 ms to 2.4 seconds every 5
minutes. These regressions degrade bcache's effectiveness as a
low-latency cache layer and lead to frequent timeouts and application
stalls in production environments.

Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 drivers/md/bcache/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index d4697e79d5a3..b2d10063d35f 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -5,7 +5,6 @@ config BCACHE
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
 	select CRC64
 	select CLOSURES
-	select MIN_HEAP
 	help
 	Allows a block device to be used as cache for other devices; uses
 	a btree for indexing and the layout is optimized for SSDs.
-- 
2.34.1


