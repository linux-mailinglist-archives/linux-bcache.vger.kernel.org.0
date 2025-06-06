Return-Path: <linux-bcache+bounces-1100-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49958ACFD5E
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 09:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18A6116D420
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Jun 2025 07:20:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A7B1C1F0D;
	Fri,  6 Jun 2025 07:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cSX8vD0g"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776163596A
	for <linux-bcache@vger.kernel.org>; Fri,  6 Jun 2025 07:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194412; cv=none; b=ODkUxoq/b6GH/SHK0wP9gY7MfSsO0YR6x9CWmcUFZF+H1ccVkgFo9UQefkKXmlnLwumCCXI4TemLuLp8K8B/rJEvX3YBixfooIg7mkq+LmaZRMTyTBVFhXrUmwXt+W5NHvXxRqEXed9z7W3tpl59KsHXD5rXIxXLVaczvrrMt2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194412; c=relaxed/simple;
	bh=vHbKT1MD1VaoBNh9+BxESHsf/sdK9ht+V6jwPej5ffI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e2bcMVSuw9N7iN2k24/yzgmhuFi05uWmL1x2LOL6NFFmWgg2byuIJ1h60oplfPWimsA1uqYFpO/NxZZZ06kUDWiqIWXxb7vzUsotoWP4Tms2WKvx1PNpkOMZI3n8zSYlerAHZnn/rqIAbWts6lRQWnE03mRxKpB/21+CrmcxKlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cSX8vD0g; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-231d13ac4d4so25977235ad.3
        for <linux-bcache@vger.kernel.org>; Fri, 06 Jun 2025 00:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749194410; x=1749799210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SgC8YrGUQDVQj0g4t9I/zb70Y6sizfUJjyOBFiuUq3U=;
        b=cSX8vD0gaKVS2njwe3jqzswbrFfWFs/1vtxYo3mLtpxr0IT8Th6/+/ILtvVoMykeFM
         BuEhh0uV6WwQl/HYUBhoqFeLWa3YF6tddpkE8BFiqz7osDnaLP2er/IMgDwLvDqj9GeF
         GS3fkBaJo8Fxg0rq4tsDgPS1rfmZc+BrXGkzkpxJmwHdr8ZL/kjUIKLVU7yQ3fwAMt6n
         W0V7oAkVbdTyIlbFrhAdHimGco02ugqm5ZpIwqbweDeMIh1v9MjVjS188qRJsbUOApKu
         fVrPgfCw6WsR9V/iGVhvE+5XBuVJXKxJBzY6MVzZAFQNSPWhFQ8QkyNmS/bnll3K3pw8
         B0kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749194410; x=1749799210;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SgC8YrGUQDVQj0g4t9I/zb70Y6sizfUJjyOBFiuUq3U=;
        b=eM4BabflcjxueJEPggs4G41MuAJd7f/gqOZMBPhyzV+W2kwNz0c0q/+GMf3qPBX2Hb
         z2xz2vbZ+41bSq4T+8SO2/MCS84RjyF0ZPH2UyRGt9X1/Y1RLdn7hV9pLb/CEmlfcLFr
         vsxZcC4yRRy1b+JEoU1TbXcib87V5JURuwnTkovZZZHWVZWXJzUZCyDMzQqw8Zv8h0rI
         QZ5sGGTTVqlbF6uUWRjwg1kECgLrZWDtEp+xRQw4JAm8Q5KTcHiChM0A2Pk/6045BLmt
         0DaXM3J0Opp0Wub2HjnPFhqE9hkqu0Hra/2NTLlrv8tAudm0+9AP5wxSYv1Zc7yJ5DiD
         hUGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4x6ELSl7GsRuEsS1z4ULHvoHbdJzdW425xtQf7lYfz1hFvXvPBxsDBVl0bbvvYCpUhSdAT901PKeMdC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPEDRGjhoNui2re+tjCSd02FU9C8Igll+XkBNisjxCpQf+Hqjy
	5JaR3EobQqEqKZTqPPJIRdn4WEKKHfA/nQm7GxIqi5VMbkNiF8AEYg1fzZ+ngHU/cf6LahSnN9i
	7GuPW0ot+wQFc2VEWh3osHQ==
X-Google-Smtp-Source: AGHT+IG1+wjJ7yrhtZNuquWHE9HuGSagMnLH4mYKY7TfIB9as3412JCt9dU9U1aMasyGztIvZp6BW7uzmFrP67pt
X-Received: from plsp1.prod.google.com ([2002:a17:902:bd01:b0:235:e981:9ff4])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:dac5:b0:234:be9b:539a with SMTP id d9443c01a7336-23601dc02c2mr36100025ad.40.1749194410685;
 Fri, 06 Jun 2025 00:20:10 -0700 (PDT)
Date: Fri,  6 Jun 2025 00:19:42 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250606071959.1685079-1-robertpang@google.com>
Subject: [PATCH 0/3] bcache: Fix the tail IO latency regression due to the use
 of lib min_heap
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"

This patch series reverts bcache to its original top-down heap sifting strategy
for LRG cache replacement, which fixes a tail I/O latency regression.

Discussion: https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2a6jmxuzt2hvbw65t@gznwsae5653d/T/#me50a9ddd0386ce602b2f17415e02d33b8e29f533

Robert Pang (3):
  lib min_heap: refactor min_heap to allow the alternative sift-down
    function to be used
  lib min_heap: add alternative APIs that use the conventional top-down
    strategy to sift down elements
  bcache: Fix the tail IO latency regression due to the use of lib
    min_heap

 drivers/md/bcache/alloc.c |  14 ++--
 include/linux/min_heap.h  | 135 ++++++++++++++++++++++++++++++++------
 lib/min_heap.c            |  31 ++++++---
 3 files changed, 145 insertions(+), 35 deletions(-)

-- 
2.50.0.rc1.591.g9c95f17f64-goog


