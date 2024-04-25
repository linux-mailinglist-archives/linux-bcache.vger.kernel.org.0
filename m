Return-Path: <linux-bcache+bounces-418-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C3858B23ED
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 16:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FD151C21E0F
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Apr 2024 14:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BD5152E15;
	Thu, 25 Apr 2024 14:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZQ0CfyZH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2733F14AD22;
	Thu, 25 Apr 2024 14:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714054778; cv=none; b=dSOfh1OMFeb4TWQBJF19aL2thgCxkgX0Ym7Kts/h6thCblZYkYdN2PCgQIkudRhShnc/qLFAkvAEjX3LLg7WlPUr6PgPkAh+yvgqXWhbo7mQe910m77RFwGubl0EsqIAlfKrNLC75r1heaW0uzTPDv7QIN6Atj7Gh+sFX0ISZsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714054778; c=relaxed/simple;
	bh=T8bV4BnctbyRNeSPAOZwi+czorsklhrFY1lqJqcqucQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=plAUO/V/l1cMWC27jxSrqhymDnG1uLeVTbSdaXncXdnVK2BP4ca4lwoBWbdHEUA++QKAkKu3ma9kHRF/zPwPlgRlfW/xLVerLNeIysWyLJ+Adi3OhoZTTaGd7Od6sscEGmLuA7i7nbJmdmUlgU+cHBVFGtX9CfbS8IIrIL6MvFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZQ0CfyZH; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2af71daeec1so280007a91.0;
        Thu, 25 Apr 2024 07:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714054775; x=1714659575; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=ZQ0CfyZHjNknkxIgEEJvPpJbulMfVTC1E0QYQlYrR5iW4Zci6ZtLUpfsvygaltYCcw
         ScXidVa+iL3o/XqOZ3AcsFBw0RmfTqSIotT0CzyhtyLcPTEUAFlKRI0dzLDPc2NENFcU
         /ng73mVQe9j1OVV4pqPE61e866b8apHP9GCaMB7VcPllC19A/5eoREZuc/E2e3BBEKvJ
         366xdAI9BS0tMcyVXJMIDMOyCul0+F0yoP5PLjvmhG9/BhcCeLFWahUiDL8QOY8eGxN2
         icMP0ZJ70hWSQ0oeyuOfRKNQwH2AvcHVu2zV6kR0Wmb22NB+DPnzyO5KgBaJ0EReImJg
         92zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714054775; x=1714659575;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8RRhCYNi4OEA45vqDvulwCxtOU91F7rHv4uIJxFLbAA=;
        b=A33uGoEJBYdeT8U1x+PfozOTHBHHEJ1bd8F12MPzVteQBdfdj7sQrORDbySU872+Om
         Kt/6sp3Nb78Vlwmz6uF/2SNViKdDU3zMBdV+OLlGMrm9TfSrBIX9l0wVlZtpiyGUi6xJ
         1GsedqNRVUFN2bTDikNEIFNcyeI5fmdj4l6XFCZtTeXLED856kArZq0OY2LPTzne7cDJ
         9zlN1qSrhZ40JVfTBTjTu87oNE+9OXysmFsKmajOk0ZUW50IYftAIvcqT3rICXTGUuUq
         z6nnaPClLygzhnUh9/ZHQaFXobHnCaVdLe9zXa2KU5s7fpP1C1qv2H177AIi9MzU4eqv
         nSMA==
X-Forwarded-Encrypted: i=1; AJvYcCWLFIwtpJvjE0jWrm00XXgVLX548DCFjFe7Iw5nbe0Sg0NST063HB6NwLUcD1KiruUDX8DYJxSyiISABRs1nFIQ1u7vqjrBxC9B6Dor09q/G+30T8GOWY1QaZnVOu9lhtM1W3Xvmf4PxWdT80Ma164LH7cWMxNEv7bsjZndcT+4DWfFhJdcySCakB4oBJed9ZOwHaFs+5MOC/heWilSkVut7AJGODBTH/mfiQlv
X-Gm-Message-State: AOJu0Yzc8wWvSfgAazDyQWamKx0/JR5RuxqiyCPaJQ5zwU9yNQ7pWW7g
	Uv6Xej5hLIFUlLMMaqP/5tNKZ5GqbmU+HIardZ6olGvnAF68iyEI
X-Google-Smtp-Source: AGHT+IGBe8hgFGbuBC4ekuepdUwdxdD7VhNw1epIWU2Vo3BxbYXI3OtABFUKqTWAQLQkoTbbEGxrVA==
X-Received: by 2002:aa7:8d15:0:b0:6ec:f5d2:f641 with SMTP id j21-20020aa78d15000000b006ecf5d2f641mr6845273pfe.1.1714054775411;
        Thu, 25 Apr 2024 07:19:35 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id go20-20020a056a003b1400b006e6233563cesm13162397pfb.218.2024.04.25.07.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 07:19:34 -0700 (PDT)
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
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v4 13/16] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Thu, 25 Apr 2024 22:18:23 +0800
Message-Id: <20240425141826.840077-14-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240425141826.840077-1-visitorckw@gmail.com>
References: <20240425141826.840077-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update min_heap_push() to use min_heap_sift_up() rather than its origin
inline version.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Ian Rogers <irogers@google.com>
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index f907c694e852..78de60f6ef1c 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 		const struct min_heap_callbacks *func, void *args)
 {
 	void *data = heap->data;
-	void *child, *parent;
 	int pos;
 
 	if (WARN_ONCE(heap->nr >= heap->size, "Pushing on a full heap"))
@@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void *element, size_t elem_size,
 	heap->nr++;
 
 	/* Sift child at pos up. */
-	for (; pos > 0; pos = (pos - 1) / 2) {
-		child = data + (pos * elem_size);
-		parent = data + ((pos - 1) / 2) * elem_size;
-		if (func->less(parent, child, args))
-			break;
-		func->swp(parent, child, args);
-	}
+	__min_heap_sift_up(heap, elem_size, pos, func, args);
 
 	return true;
 }
-- 
2.34.1


