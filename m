Return-Path: <linux-bcache+bounces-853-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46681A7F33C
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 05:34:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1555D1793CE
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 03:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CD225F972;
	Tue,  8 Apr 2025 03:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JdZ758F6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5F825F78E;
	Tue,  8 Apr 2025 03:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744083241; cv=none; b=Z0UAgxaYA/BZcLXk8RagVYLw+p14OPnoCrLmFwDOIdEDvaCLn7D2X1J9SeaNdtdOrD9TUkxgNiAZm/v//W1u13EHpwWqZA6g6YxJ7HIE4sjXf3+xSeODpz5a4Kd4S6HPgBV9eOGigNYSiTtIb8NkRBO+XOhEcxIC8bqYvFE/y7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744083241; c=relaxed/simple;
	bh=YQ+b/bhi69UBQWKqRH5lunv3v2mmTjva+ZVRrFt+1qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1rHhOgF5mNbLpNN+BuX0TAg3eP7Qd16ZYNyK3wNNpQ9Q4Sd3rQnpckVNpvmIauSDFrOopHLv1FIl1MPa4L8vxPKq4RvA1kOYJJIbGnlw/JOoUZYpWHU8Waz5iaOgB9RdJGdhZ1F/y8av/epfDz1XRefkJ4gbl4tBlu4hDnF+uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JdZ758F6; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7c5e1b40f68so564671185a.1;
        Mon, 07 Apr 2025 20:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744083239; x=1744688039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/w/7RKMvsV/vR6GoA+QxM0o+xL/6IxF4Q5WJvbupo38=;
        b=JdZ758F6pQKaQIr+2EF0znIsTqP6d4awVcsELRI83RujY7fXmgdMWC3W7qyV/8MgBc
         2Mblnf7/863vd/lQgO3c6jdMUYVyFt2l7ejxhjVy/Y+tt4rLt0aa1DZ9GbfSiQX+WVP7
         CifEjnMFBIp9Z7MYXo1cClVjNlzBfAPOAw87wDdb9D3zl12G9fRCy0FyuML54Vb51qZP
         v0NUkiH58pZ3c0YleXKlqigrEekREte+FVNoQ4XxQZGfNfMlaBNa14UBeJnG4copN128
         3TsVFYRzZdr0R5rmQixjIibMRlo+M5eHVhB0Pe+ELbry2BsxVbZ5Do66N1zSPsEvRn0W
         KfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744083239; x=1744688039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/w/7RKMvsV/vR6GoA+QxM0o+xL/6IxF4Q5WJvbupo38=;
        b=p2INhLedrkVPz4yJ6ETOwna9HJx5t8sDvMpqtwsej1ULQpVwzd2q7FTUkkeLRefFAz
         QIUNBzQP8Wa59ww6gkcunsNdn+Fm5JvdE9GezRSLPeAObHBtRVT1FUxh6QnnanGKD1L3
         6zeHF+tgmZCGgQd7OvyD6RxarQjLKd1bE8aHGQwXQ27PeEweWT5OUWK8r+MnyKD/okv4
         kRczqpz7QSxnDwS96l9yLUcWnaqJn6QKkL8itjblzGzsqc5PxZNyJqnSgXkE8lsj7c5w
         CVNFejd/SlFtZLgpY5GUccePqzTH+mixrNNHlYx9OvaCgYKaEen1Iaj4oNi5+8POss9U
         p7RA==
X-Forwarded-Encrypted: i=1; AJvYcCV5TF/h8zlcqIM+h1oF4PcOncSbbKQ/ApOmwE438GSDcqnfzmZjAaXvDLggSWvfsDIRNxq+vjDTgYEvUtY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPKdtT4ERLTsn5/PBqsH+upPDTuLJGP4SFNj77X4/kBYlcnSkY
	M/GOKx6lCuQf9AzqhijlPkaR7ri39uJVpd8RBlToIeh0KxuQBvcP
X-Gm-Gg: ASbGncuW2WSObWYg3DDyGnw2+QI6vYF/jSxqXxVuI3w6wXxN2dFL3ZLI84kL4Wf3bjg
	Gj9Jwy3VdP6J2g2GpEHhNtFRow7HWScwC163HtFNJ461oELMeXISWIX9X+F8vRTlAzWZwxyKBsu
	8R5a0t3kSUBMxsSH4k4O9KK8UhWquQGSLdvkjg/o1B+QCWRfhZnQvA59+ME+9CNAXiSXDJ6+yAS
	6o2MdhHN9kysZoBLrATmmUzhT6oArvqkgMGIhdN4gFwat8hYQuq+AGcA/RGbyKt9DY+8D7cYi5Y
	ZMDrEiEx0iix3oQkFf+yyV5KR2hJc2bez5MwpVikX2WgMRvsRNcexoHHHgg=
X-Google-Smtp-Source: AGHT+IH4yoOkBSDU8zbVRjQJzoFeihuOwQlL7rWdsWi+rYAbSeqEbWnXNnqH6+54t740gKYG9q987Q==
X-Received: by 2002:a05:620a:424c:b0:7c5:4eee:5405 with SMTP id af79cd13be357-7c775ade724mr2027033085a.35.1744083238837;
        Mon, 07 Apr 2025 20:33:58 -0700 (PDT)
Received: from theriatric.mshome.net ([73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea82d48sm692759585a.101.2025.04.07.20.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 20:33:58 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	kernelmentees@lists.linuxfoundation.org,
	gshahrouzi@gmail.com
Subject: [PATCH 1/2] bcache: Fix undeclared symbol warning for bcache_is_reboot
Date: Mon,  7 Apr 2025 23:33:21 -0400
Message-ID: <20250408033322.401680-2-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408033322.401680-1-gshahrouzi@gmail.com>
References: <20250408033322.401680-1-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add extern declaration for bcache_is_reboot to bcache.h. Ensure proper
visibility for use across multiple files (super.c, sysfs.c) and follow
the declaration pattern for other forward declarations.

Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 drivers/md/bcache/bcache.h | 1 +
 drivers/md/bcache/sysfs.c  | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fac..531933351b8b8 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -1007,6 +1007,7 @@ extern struct workqueue_struct *bch_journal_wq;
 extern struct workqueue_struct *bch_flush_wq;
 extern struct mutex bch_register_lock;
 extern struct list_head bch_cache_sets;
+extern bool bcache_is_reboot;
 
 extern const struct kobj_type bch_cached_dev_ktype;
 extern const struct kobj_type bch_flash_dev_ktype;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e8f696cb58c05..47ef0167b9d23 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -17,8 +17,6 @@
 #include <linux/sort.h>
 #include <linux/sched/clock.h>
 
-extern bool bcache_is_reboot;
-
 /* Default is 0 ("writethrough") */
 static const char * const bch_cache_modes[] = {
 	"writethrough",
-- 
2.43.0


