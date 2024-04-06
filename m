Return-Path: <linux-bcache+bounces-377-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4246B89AC46
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 18:51:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F358C281E50
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Apr 2024 16:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 827B64C627;
	Sat,  6 Apr 2024 16:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrX741L5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A554902;
	Sat,  6 Apr 2024 16:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712422125; cv=none; b=Yd5Mu6tkGWEfbeOIJxQKX1UDMf0lOsnZ0GfuhOn/6D8Y4RCqkOGqOU6PcTigFBGGWunirfNpc7mKhFGDwbTyuMD7TjKqn8BDbK9VINo0lStroqacBrCGKusfTcDoiEm/eirz6zus0FsO6wgXIk+bfHv8engYKOeYJsdkG9qmy2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712422125; c=relaxed/simple;
	bh=jbKOXPA+Gl6IpPqMVqcysMX060d8McJnMIlICl/F5mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r4GVd9LCDBLIQqHwHpKGZ6MUGl3yLMZKUy5PHyufeqkZy7wLaq2emPT+iSoVmyRvjXamSraJVh6GffvYf89DUE3UxZWHzTwyDjRnHl+GQkR3JzI6i38Q9FcTuQ6Ndd+TxpJG2ZwmCw+l8TNE7jdAZRmxOZ2Yp9U6mGZTsAGP7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrX741L5; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5d862e8b163so659577a12.1;
        Sat, 06 Apr 2024 09:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712422123; x=1713026923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mVBRW4eof9PowDsAk296tfYzBeUuniogKOiljPXuw18=;
        b=hrX741L59lUj8Vi/FNMYjJI8iArVQ+BQoOFyI+L0SmWkUPf6+p/CgOMP4x2ztjG0Kr
         JwEpez10N4+yf4KY8Hq3qFIAstBAForyUi4Uto/I3RiN5TZiuOXRxApXanIMKs/2mx0t
         rB4c1uOYzvATfuWPPftg7qQAeN/uY/OrURAxYDuutPuZ5I3FCFc5aBcxOZ7bcIHBEaL/
         6ZnE7W4U0jxFB9O5PIP+c3n9bbOFKNOUlGKgDsoqzWDvDJyut0cj61Ln7ejHIlndX7TZ
         AwDVyQq7gcmo2uwKilDJNXSAPuprUJzkg0rYAHeK+JVR3t7DvqRudyMkYpswPPRW3ZGH
         Eq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712422123; x=1713026923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mVBRW4eof9PowDsAk296tfYzBeUuniogKOiljPXuw18=;
        b=fV14PHpQ5MZWmcRZh5QYlpSdckeowxPchGL+JWnjPSLQD03P7eu0oQUW5AA5SWs/Jl
         ipZPJEVkVY+oF/t1FHntM/4INwMW1IYOdK3V5uF4OrTAaH/K2k+GFW4nc+wsTVetRzA+
         39Mhi1CilPYjAXxF6TVjGGOlHneJUC/rDjjZzIag2jbxE2HRN7+7NUumj1dk8PRmgK8s
         snDIm8Jp3MUn+kk4iqhmODkLFQEHkcGf28uau3OwLnepR4aRH2D/UsHCFoKitSv2tRHw
         MXTr7rP8OlNJgeodU7R5GnKMoIXO0uKM+VtMeuYHFJ4nUkNQV8yiLohM4CaozMtdIf9P
         JMYA==
X-Forwarded-Encrypted: i=1; AJvYcCXy2effRe2SvKkfo3fhmc3d8hYocKmmTEvEEeOX2VdBd4/b3JkqQoZ9eFrQtcrndzLKd3+b3wybi3G7nbeg3c+j9vLtarQZWLKrTbVC9OxP5rqkGsnSV+cCGgE5loOlzazMkhy3ly/c6gOzjzA+aoTAy47xKU76nHbNtS/DFdm20YqX3HUtPyBkjLOxIynKt5U3gpUp64sGXhkkuNF2kDKxbxQ2QvzonEJA01c/
X-Gm-Message-State: AOJu0YztkSvx30amtW3QjMTIu5+FF8OPRFZ/pIkaS9FgUy9Uqb5W/VzV
	Yd31G0jvOmdPf+D7At/x/C5zJwS230izUuKZbXgRt+bNs1o/vJFo
X-Google-Smtp-Source: AGHT+IERmlFQH0vffhtfBW7h0zEYLfp3+ry7ehJ/YlP1A2Hxhl1UdWDOsD2vemJY5geJTKGS8TJGYA==
X-Received: by 2002:a17:902:cecf:b0:1dd:85eb:b11 with SMTP id d15-20020a170902cecf00b001dd85eb0b11mr5562644plg.1.1712422123243;
        Sat, 06 Apr 2024 09:48:43 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902a3ce00b001e2b8c91f04sm3665068plb.22.2024.04.06.09.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Apr 2024 09:48:42 -0700 (PDT)
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
Subject: [PATCH v3 13/17] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
Date: Sun,  7 Apr 2024 00:47:23 +0800
Message-Id: <20240406164727.577914-14-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240406164727.577914-1-visitorckw@gmail.com>
References: <20240406164727.577914-1-visitorckw@gmail.com>
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
---
 include/linux/min_heap.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 3086612d7cd5..fe037eb5952e 100644
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


