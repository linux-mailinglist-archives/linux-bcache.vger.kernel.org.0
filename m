Return-Path: <linux-bcache+bounces-299-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AF13880430
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 19:01:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7CFC81C2207F
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Mar 2024 18:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3397139AF3;
	Tue, 19 Mar 2024 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEMm69y7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACE339FCF;
	Tue, 19 Mar 2024 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871240; cv=none; b=hSRTQ766a5VWttQ9f+ri27GoPDfUpZG8IBuSDDUI7E/A44jDuP9CdcFnpV6al+IhbnjlUQH4vs55T0uLNf+GM18sn2DM0zziG7CYGC/ULeuje41VURggShI7YB71K7637i2sICjwSwKcMEKct/FsgGzlk6V6jbW0c5ys7NVxhqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871240; c=relaxed/simple;
	bh=1kcI5O448ZoSUJqM7Fwo+CLjTMdYaBqUzIGDOV4I8Wc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S3hXn+8w0FUKlfsAPr/cyLYhyTSS9qdU+QpRDWdu/3+JnSoYpRgXVvcPbhJcBeEHr0Irly4HDQ3yINfGxnJXM2jrnN4ubBgYBBoo79uFPl4q8LoxA4T8M3G+gUJz8/Ug+uihODZ6YHRkXm2sen/u3Q8Lz84x5CJ+b9aaY+waYL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEMm69y7; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dd8ee2441dso10459715ad.1;
        Tue, 19 Mar 2024 11:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710871238; x=1711476038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=HEMm69y7i6ACz6UE7aL6mGPM0xbrV/BwlkH60HlqnsFv6r5ZWNAeldoJCMrGtaw2I1
         4QPo+91OgKbtNrgtQ1lmg6r2IpWutWGxrMvRE9WW1QNhM8JJKtoijYkU195N+alCEIDf
         RTaDlpTUJGAyHmjdbJ544iS2ZCsa2sZi2DtRQViTeYBWJZTu8U7/RwpHPgP1E1XgJVFe
         MiCC4vuy4HVha1+OL3Lx+qI+t4qQ7/4x3CQXDr/RIUWviSbarjzfalBw3ksJq4NQK7n4
         YYH1Uqeh5FrIByg8u/xHO0SwL9KRG1M91bfg41c1GcljEVWSZq1tJ/F9mN0Y5EyZakxl
         32zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710871238; x=1711476038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wIY+iLTtXDqlHadPKUvUaL+ptK+GK0/HaTJmss4inJc=;
        b=Q5cDe4ekN4stQezggHtQm7EQgGowvfy/4HXuW0LtfCxODUbz0xYophAIS/BuSGU/oN
         dbM9SFFoSeOo9RFXUEBxBtve3/xZt0znwrzrhJ3/siOzBOC5Ft21aVLQX/eZBHvT+zie
         HBQvqoaG/upOr1Gvj/1A5928yE4AaiMTVuPwM3S6xFQRpWncnoNj0lUaA0dYddNpXfpO
         9MRUUzS3U1G55xFWVUQsO2i98/qZHBSgm6Ws8TSKuLJj/nbNla+M/1nhjjWG8qiDkKxa
         pwQBxHGurkv4IzGZQkW49voF9Z1PDhpb9GlYwTCQyCUXbldGaO//POvvDohbPjlYJMkO
         Jo3A==
X-Forwarded-Encrypted: i=1; AJvYcCVkzQrl6dPUMdL7WU3zRxd9ZEYwRYnGaiD645nA7X79UG6Id17f1WLvS9AWahl2X3AqHqRQnYHiA7aEkkEMfw5mhyWO4sUhWNAdUAqsVPoVoUzM287NpHfnSesiCH7CLnyJhrC++eCBb3DcPwY8xZ4CNuUac5YmbXAh0CAB8FkmTtf8UGgbOR7eSYQZaxNRA7ouJUDPL2q7sCGplGJ6VzbndOC4n9NzhmpX7R+q
X-Gm-Message-State: AOJu0YxaHl1fdAYDR9EqG+4RAOsAcvlwD2DXvMPdpvliTYhqfpO+KtU0
	OL1U4u9iYSN0YYeY5ZsLZTqqQsYZEn/qTJcJ3fUWhKgaEBlCTlPR
X-Google-Smtp-Source: AGHT+IEmG62jJmsoaRkrpL1XhfpAvR+sBzrjaRo0zakUg8127IT9z6Y2bZCHFDgurpvJ46NmFObQhQ==
X-Received: by 2002:a17:902:f547:b0:1dc:c28e:2236 with SMTP id h7-20020a170902f54700b001dcc28e2236mr3253079plf.2.1710871237779;
        Tue, 19 Mar 2024 11:00:37 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id u16-20020a17090341d000b001dd3bee3cd6sm5531359ple.219.2024.03.19.11.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 11:00:37 -0700 (PDT)
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
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 05/13] lib min_heap: Add min_heap_init()
Date: Wed, 20 Mar 2024 01:59:57 +0800
Message-Id: <20240319180005.246930-6-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240319180005.246930-1-visitorckw@gmail.com>
References: <20240319180005.246930-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add min_heap_init() for initializing heap with data, nr, and size.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 include/linux/min_heap.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index c3635a7fdb88..ed462f194b88 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -44,6 +44,18 @@ struct min_heap_callbacks {
 	void (*swp)(void *lhs, void *rhs);
 };
 
+/* Initialize a min-heap. */
+static __always_inline
+void __min_heap_init(struct __min_heap *heap, void *data, int size)
+{
+	heap->data = data;
+	heap->nr = 0;
+	heap->size = size;
+}
+
+#define min_heap_init(_heap, _data, _size)	\
+	__min_heap_init(&(_heap)->heap, _data, _size)
+
 /* Sift the element at pos down the heap. */
 static __always_inline
 void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
-- 
2.34.1


