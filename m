Return-Path: <linux-bcache+bounces-879-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 059AAA8A4CE
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 19:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 933183BC8DA
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Apr 2025 17:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126B11581EE;
	Tue, 15 Apr 2025 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mepAwsk4"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797272DFA4F
	for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744736412; cv=none; b=hviwpzcsRl4cwH+qUVfw6OI6pcwwgopMiO+nahASKaNJS8+3HvCVgbo3PZuySitx7fLc0KDOqWbbowZeBJUiil450R4r7oGxpzP/mFWh1xFsmp1ruQIJD7vhH8M6SKnoO2W91J/EoV9JeGkOBDyUpMYNy8AMCw9DwHynGTzJzKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744736412; c=relaxed/simple;
	bh=br7RtKW16h19laSRXigcqMs0RMv8e/9RomcwJ/PgoDo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sSw+NrM0IhlogsVIRy32TBQx2erl6Fe2mfo6+7uxxQtMp4uwmV3OtPuwxa/4Hw5ju37kHmFBfvNZpN+VGIFqHg99Bb4ZgBvXu5Ni/zUfH/hIBEe4JckzaasW35H55YwwBEPGp3IRABTgtC1BApXcs2B750bixpz7boEEma5zEn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mepAwsk4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--robertpang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22651aca434so47058045ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 10:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744736411; x=1745341211; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oodgjne3EPT+xkMjjQ2HIqlD3K9yIy6+W8glEElUHkQ=;
        b=mepAwsk4qLIR2kC23wJmjLBp713WNHlMZ7pSPUqR/CrpV9SeAeF7YRG5gxg1Sr9lZ5
         lIYDyfSBhf/dFqxEnnyccjeblfGvl1Zm5YMEAATKERZII2pG7qbf+lvKJO//voQjSNsx
         q/fmyv++fPzc+/z3PbCm7LeNIM+OS5bwq5v1i+js/8nFVuEKe/MKWZqTeOTGNw66qtV1
         IXWWp8cVefvNz968tZgSTc9V9fzBpPXI4OL1SHwA4xBawXJ9he4cUfiMfGXZ0Rp+h/Aj
         /ccmdI+ih/OdGhDsQQ1uK6ahmeE6xM8Cwo+kURIOjZGcnvgG/Ugj6HZ7TzugjM42O9zf
         OrdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744736411; x=1745341211;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oodgjne3EPT+xkMjjQ2HIqlD3K9yIy6+W8glEElUHkQ=;
        b=FfO3xCNAsyw5IfyQA4cwztjCA0Ke0D7JOUGfmxdZAVcG5qM2Z83mSelbPONlvoc5Rc
         5ExVVIiTMtXMDltpUbdCjJYutLwbp+WzJxx0mA1AxAVSvOquzVRpMQAMcg50QqukMRTQ
         yCL1bBbpo5jjZ2qRciHE118NH/DXlWWXIdNOPV09N4uWTH/sM4ttJZ1RPEPVc1NXwPop
         2th4lFZng8CZ21Fnt2SCgrJaOKVsJzMnKJTn8eu4BGHRRLn96c60g6nptSWdoB3XZ5fJ
         UDP3hKxPJ7/BLPAeNKzZt/cRoMfOtO/ybw6M+4UrOOLzRW6MuzlL/VBpXPH5rlsppBxo
         e5KA==
X-Forwarded-Encrypted: i=1; AJvYcCVpCJVQ3A9RRvOiQw/2/REz5WE9XMLGHRcVqY3u3FV98IQ5pnrcxfl/C7HPGkLtOG8oRgFfBasacIm0aE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZfgqrRmv+L/KxGV4RKu9SsTMgEq7bx6jSsUgqSxfLlgvDXqay
	pA236uGgSkrucTyIMRsdc+rTAp0BTjMUS/ZXE3vUApOdZtFZ4XG2nEjRjzbzSvlXlQ1BHAwmD4Z
	l6WXkjvHDJEFhQVTdBw==
X-Google-Smtp-Source: AGHT+IGFf8YynfwADXlRd5pSzBo8ah6MX2ZzNmveyj0LabwuA9cVP4qciAVgPiJJhLkcs6Q1MPtgFWb1z+5hY7HS
X-Received: from plyw11.prod.google.com ([2002:a17:902:d70b:b0:223:8233:a96c])
 (user=robertpang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ccc8:b0:224:10a2:cae1 with SMTP id d9443c01a7336-22bea4ffb3fmr241342215ad.37.1744736410719;
 Tue, 15 Apr 2025 10:00:10 -0700 (PDT)
Date: Tue, 15 Apr 2025 09:59:22 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.805.g082f7c87e0-goog
Message-ID: <20250415170002.334278-1-robertpang@google.com>
Subject: [PATCH] bcache: remove unused constants
From: Robert Pang <robertpang@google.com>
To: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org
Cc: Robert Pang <robertpang@google.com>
Content-Type: text/plain; charset="UTF-8"

Remove constants MAX_NEED_GC and MAX_SAVE_PRIO in btree.c that have been unused
since initial commit.

Signed-off-by: Robert Pang <robertpang@google.com>
---
 drivers/md/bcache/btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..f991be2bc44e 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -88,8 +88,6 @@
  * Test module load/unload
  */
 
-#define MAX_NEED_GC		64
-#define MAX_SAVE_PRIO		72
 #define MAX_GC_TIMES		100
 #define MIN_GC_NODES		100
 #define GC_SLEEP_MS		100
-- 
2.49.0.805.g082f7c87e0-goog


