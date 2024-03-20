Return-Path: <linux-bcache+bounces-334-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6588813D2
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 15:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E78F81F23F40
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 14:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602F356772;
	Wed, 20 Mar 2024 14:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GObgr9Rp"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83B54EB33;
	Wed, 20 Mar 2024 14:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710946500; cv=none; b=TWJ9Gx3dleWiRTRCt4mQxs+62vbBJtUmYVe7iM/TdRjADONNyNAvnb2xWOki/LmN/Nso9vDzBrgSPSX7lyKb1/maYcBHa+Wod4EGNBSGx0iFkg69xsq4v7+Z7sM1PbMpy0ZDuTO9TkVHw76e9iiidXIui5R6iV6FsoHk9TKKkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710946500; c=relaxed/simple;
	bh=87oXCcVzX378JZ7P9KHFZTxbp5kTVN7ioJ6nxJ/kTRs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sPODTd6DSQ6UBv62fCqJsTZXQ6pOPhT4VIdo/UEaVPrcHG0ykwHgtBeCcJsbfsJ+KJ2sZTmzKcJNngKiMorbI7z2lmbRExs2UANMEmmlzk4SpUel3sGc/dy82G3ElKdQN7zBNsIZ6FY5KHVE/QeOpiRgEdGV76xPg1W5OuTjZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GObgr9Rp; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1dee6672526so6079395ad.1;
        Wed, 20 Mar 2024 07:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710946498; x=1711551298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6wlW/VG1bZr/fW5x2pRSDPzGgSGqgaQobdRLr7/yKpQ=;
        b=GObgr9RplSefgIPBiCrxRw2uf/gZUu4t1IPn100WhFP3AtkKuGaEGbhr3ZUYEez9uB
         tBOysu+U6G3uPp/yQB5JRC2UAsV9wY69BRQ1QpsLGSL2YN0BADvObmxYNomsaUQR9TWQ
         Nw0I1Yniu/rV2ivUFp9Bcbpv+xVsJPEQxVs1OM6cT0Sh+myCwfvRdBWMSS8fxDfmwCcK
         ohctW9IN6euEgRKM3KCbtGLZ9TgMfFx9Bh7MC8hrNRCNioQynotRBdHFUoA/wgOe6Ke4
         OyOf29mFg5N3zqbXvYzDEVHXVXpcLbFtcdaOYaFLLLy8IXmaL1JhTi7BZp2V+IBo/ZrK
         C9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710946498; x=1711551298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6wlW/VG1bZr/fW5x2pRSDPzGgSGqgaQobdRLr7/yKpQ=;
        b=tnZRrhYWdeboOOqkcka3FWRTWcYK2dj+Xex1YKON9x3xhMr2QMBvi30N+JZjJ1O6+Y
         LIEE0aX+SOzTR/ogYABxC/E2oEaQeAWO8LBcVVj9MogDMuZ6I78ahA/tIsPrsW9dlJT+
         8tFMrM6qbZQYQ8M3yMVngS71preugo3Zde42XUVmC3L9ke4tKAU0LcHfCdWx8Sp7OyxM
         V3XF6CPvMGGSOhtegTRxgIK7aiOsuZqr5f53D/hul8Av2K4lTJwuTL11VYNpKoDTRnqD
         yrJ6tC11P04Sq6T1515sUcGKs659SAWyAJb9FUelj1cKT7rvvK6WsBU9YUPB9QqASvIo
         QJTg==
X-Forwarded-Encrypted: i=1; AJvYcCWr0CtS90S2Bv6Q6eL6Ysru8OTG5GOiV1DufKZZ16cB1U0KlPh7rOgdv/WggqnXR6WWw0SqXd8mkV/wwvp12vuiErgEC3IU81dcO70ko904xeiB8Y0o6wGT+OudCiRD2IdFTsyY6RiswM3/ehZX3bHr4MFvHMyZVIVNFpFhEo9GPXvuYmEvIcfEIEPL7JyQZSa1bkugH/qInXTBFNIUNryWdZ0lpX67eU/mCg5C
X-Gm-Message-State: AOJu0YxJGcjyCgIphcVrKCFOlEtW3McCTS0iSlMfGVP/UoGsUX8dbDkU
	Vde+KJpkZiCxMmoriiOLxQ6MJMG3OXzr4vw2/xBjeGgjzsFsMCZv
X-Google-Smtp-Source: AGHT+IHPNXqxNRiHHdL94gEllLU3VLR0+ZSU1ayFv4vdbYAP2+XpkPoVncG1MrhmG5iQ5COCDdzKFQ==
X-Received: by 2002:a17:903:1c1:b0:1dd:7c4c:c6b6 with SMTP id e1-20020a17090301c100b001dd7c4cc6b6mr19250306plh.5.1710946498281;
        Wed, 20 Mar 2024 07:54:58 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id la11-20020a170902fa0b00b001dc30f13e6asm13719989plb.137.2024.03.20.07.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 07:54:57 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: bfoster@redhat.com,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 07/15] lib min_heap: Add min_heap_full()
Date: Wed, 20 Mar 2024 22:54:09 +0800
Message-Id: <20240320145417.336208-8-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320145417.336208-1-visitorckw@gmail.com>
References: <20240320145417.336208-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add min_heap_full() which returns a boolean value indicating whether
the heap has reached its maximum capacity.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 7c1fd1ddc71a..b1d874f4d536 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -66,6 +66,16 @@ void *__min_heap_peek(struct __min_heap *heap)
 #define min_heap_peek(_heap)	\
 	(__minheap_cast(_heap) __min_heap_peek(&(_heap)->heap))
 
+/* Check if the heap is full. */
+static __always_inline
+bool __min_heap_full(struct __min_heap *heap)
+{
+	return heap->nr == heap->size;
+}
+
+#define min_heap_full(_heap)	\
+	__min_heap_full(&(_heap)->heap)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1


