Return-Path: <linux-bcache+bounces-772-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FD19A5250
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 06:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7198B2821F4
	for <lists+linux-bcache@lfdr.de>; Sun, 20 Oct 2024 04:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6D218FC99;
	Sun, 20 Oct 2024 04:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTJOn/vE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A202E17548;
	Sun, 20 Oct 2024 04:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729396989; cv=none; b=dcJ0T8ljRjOFOpq9A7koRNtBUEJS8UQzCUyP669BnYfaq4rENqEJ4Phc8EhtnWbU8HPwGtErywDXrSCkBSHmHdoy30sduT7HFZmXrDzSIWUFAaIZ2u1a9edp2B+zBUkArRpH5Zel+RgaVY3zJOApKfgbFOospddn3xQcejYKiYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729396989; c=relaxed/simple;
	bh=6iG+P5m+bTysqxHfMQjYbIP6SmuhjAt2CP2aCR2eqWk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TcEj9rveGJVhOf4BhEZzzU94yqk/goOiZJskBtVpDaJkwBmH5hIQEK0wd1z3Bb3s1H3MDZ9UzGwWFcVM7ZQa3YEOM/+jafLIfsIeiklbXTvW1KRno1le1uEvw3A7rxwyCIQjUQVjv+u47QJFzQSRFcOcnHYgEfmP2UVeQnPTdh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mTJOn/vE; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2e30fb8cb07so2547498a91.3;
        Sat, 19 Oct 2024 21:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729396987; x=1730001787; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IpkOmRAz/DQoNyfUWCSgBoembbEPvsuuea47lWbGPwA=;
        b=mTJOn/vEEJGXKOvAGcSUpKf0vhG9ar1DRFgYlQLD72LnbJ7zMRKk0we3E8chgEEFSn
         0sfVmbAgmrlq3TkcPzS20VWJkRk7Z+vHo7uOBD3lXCm/O9mtlouKMDqs1YQQCFuSlq5t
         UxuwBBZ270QUeRKqjHtmIOtUkOvCqJj/6KD3mgPugMK1P0061RHd17cqycj4biE/9TxP
         K1NOQD39/R2qwPFuAxRTO1K51fdktMigSmfLO1WZDhJDJ64lrwGUelVitxdi95g3ooHj
         9OZ8EimhhvVbFaZj0JHkm5ZmJTEIwVbRvP7X5bHt3h9qq/lELQyAwYNYW8q0qmkzidG0
         uXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729396987; x=1730001787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IpkOmRAz/DQoNyfUWCSgBoembbEPvsuuea47lWbGPwA=;
        b=KrrSonqZRmZ3jbuOEx0EMxkfeVYgB/UVugvh3M3iGL+iWy+/VMjiHocR8G8Y3jKKqO
         DOvcI3FoBsPk/osSAaq3t2vjwU3mC5i9ZlbexRk37K7p7TKLy9e5ODCJ5mhZcT1k4L2F
         wNPiZwF0a5+5vkh3FE4ikmtjh8BTuiteALQicIBQF9Id4ZlS7SRl021y43XWIVCp8Ptr
         tJUXovaoHXoLFtXvMW8FiJToJTo/OqMaPF1PBRkZjv7TFSksnbbOI50G6N1RzOrMSDAE
         RsdTl/uWGYO0TLb/CIwQCiqAefSvvilnuaflvJiNUx6dndEJJZQMtZ4lB7qozrRYo9sH
         e4rg==
X-Forwarded-Encrypted: i=1; AJvYcCUCUXGTr7p/0WByCg/rpGCU9hWqOOqGyYsBP1NZOKkE5OYKNYje9lAqfaaWP2wJyubdGnO+Axw1b5laiT0=@vger.kernel.org, AJvYcCWShYuTxXL7FqHvUzUnBamDFkQxBo0ctgvEt/npnl0KII1PC5dl3O1EC4+lNV9R7ecJTxmdkKgMwkrDpVch4q352Q==@vger.kernel.org, AJvYcCWTeb68vmyII3qK5U8rjbbogAX8L2Fpt1u8LV2n5kJUXebl0/21a0Bnb57PbYLhbploiap62cl70eguh11K@vger.kernel.org, AJvYcCWy7zWxYZta7mKQ9efGRyTB0fR4lqAU65+XiILa38x5N4l4JUoltN1QyLDqxz0M4vqrhxVuh7PcR1ZN@vger.kernel.org, AJvYcCXloFor1PeS3uSluTr5Q0j+wGAVS4fWz82yJ5UP6PbaONsGvwbuu5Q/OCvq0hsNc7hVBUCmICiPvKIGlf4oJ8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPrBuDtRcAHz7NDV1eSsSFOhmrb9Kp5NkglSzcGTctRjiT5JoS
	7As5Zggt2U0Z3j8WiNQBdPmvgXwcUDFqFJHMiqcwQDSQJgNUYFHU
X-Google-Smtp-Source: AGHT+IHJf9nXrjmUo/+hBd+ZogFXKHjqpeJ0l0sVyl8/8bUCcHMXr+vmkofLASs6jl6dEFOEoGT9gw==
X-Received: by 2002:a17:90b:1a88:b0:2d8:dd14:79ed with SMTP id 98e67ed59e1d1-2e561900d44mr8457372a91.31.1729396986825;
        Sat, 19 Oct 2024 21:03:06 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e5ad3678d3sm633668a91.24.2024.10.19.21.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 21:03:06 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev,
	msakai@redhat.com,
	corbet@lwn.net,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	akpm@linux-foundation.org
Cc: mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	kan.liang@linux.intel.com,
	willy@infradead.org,
	jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 09/10] bcachefs: Update min_heap_callbacks to use default builtin swap
Date: Sun, 20 Oct 2024 12:01:59 +0800
Message-Id: <20241020040200.939973-10-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the swp function pointer in the min_heap_callbacks of bcachefs
with NULL, allowing direct usage of the default builtin swap
implementation. This modification simplifies the code and improves
performance by removing unnecessary function indirection.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 fs/bcachefs/clock.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/bcachefs/clock.c b/fs/bcachefs/clock.c
index 1fcfcb5fd44f..1f8e035d7119 100644
--- a/fs/bcachefs/clock.c
+++ b/fs/bcachefs/clock.c
@@ -14,17 +14,9 @@ static inline bool io_timer_cmp(const void *l, const void *r, void __always_unus
 	return (*_l)->expire < (*_r)->expire;
 }
 
-static inline void io_timer_swp(void *l, void *r, void __always_unused *args)
-{
-	struct io_timer **_l = (struct io_timer **)l;
-	struct io_timer **_r = (struct io_timer **)r;
-
-	swap(*_l, *_r);
-}
-
 static const struct min_heap_callbacks callbacks = {
 	.less = io_timer_cmp,
-	.swp = io_timer_swp,
+	.swp = NULL,
 };
 
 void bch2_io_timer_add(struct io_clock *clock, struct io_timer *timer)
-- 
2.34.1


