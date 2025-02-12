Return-Path: <linux-bcache+bounces-842-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709B2A31E46
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 06:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB356188BD9C
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 05:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A01D1FAC57;
	Wed, 12 Feb 2025 05:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vr2katO5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF8B1FAC45
	for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2025 05:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739339494; cv=none; b=LwvQ6XPlQlhcHg72ZEh+0w7dD75GGOCa1vz5rHGX+nQTsbXw+JF2mhdIQMCaCLJOOOievV1omZuPRm2GUrDlpIriRYnx+50LcUzDwyYwkTsuZevAp6N8chX7Fv06X44Rcpj6yI3HcMrL8TdOJOsXlanBDAYGLyDiF+kw+nEl/SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739339494; c=relaxed/simple;
	bh=On50N8XfJtdyg85Pfpd+FFpaDhSZdWToldlk7/cR41A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oq8DXH6N2uN6p2SQZiiHLD7yqwPReuYZMWbf/NpxCOrwQr1vo3h8qfH58jzzzOVssNvMdBCYCgrhQInP7tPnHgli6u4J9eyL/DwYsV8/dTib7mLeMgRChxk+xYDpBG8soacPJwPbdioZsb8Fy3+JP3U/KjU9PAtNvltDygliJfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vr2katO5; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2f83a8afcbbso747755a91.1
        for <linux-bcache@vger.kernel.org>; Tue, 11 Feb 2025 21:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739339491; x=1739944291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=71OqmfUylbxT05XvE8URCg5FJ2nx2QDuN8fJlkXCpkg=;
        b=Vr2katO5u5cNU7b16TrS8GLgyo+TFbjpN7XMA9Xt4WUU7M4Ufo8+GW/ailixL2VuyX
         M1mVHFaDQ5O/yE5o/e2L+cS7o8hyOwtX/Fm9BLMEeAAuydIe7uitrkcG3oVWAx8xk1oh
         YFVjPzOFI6MnkppVAJTXmUJuLYheK6RevtyksHHdhTzTbw9oLVtSzfzsZbxOGL/AcEiU
         Oo7aZo7Vwud2VjA+zHRLeDwrdvi8mif8oGjrMrgBcmYrOk0tLYS7vGV5VBP/Kdjzs0i5
         uTC1LWyzffys83JcGpXiv7Da6j67bHX6vvW7yQ4UgctyG0aE2qpvkc/6So1AjQamI7bP
         RlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739339491; x=1739944291;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71OqmfUylbxT05XvE8URCg5FJ2nx2QDuN8fJlkXCpkg=;
        b=mAH3hl1BpguIvPJyC5F1EBRxVQfIEh0rbBlYayFh64SJdSp1xUL/fmSlq6pZ2lK9G0
         W+SC9dFai+PdulbdarFLyjKKDSwiyswEeR+h9c2nI84FU2Pw3Jrv5g/gCDdHh74HfqNu
         MPcS1vGtMIPnS/PmSzYXGLhAadYPWC+Xq4dnCdXHnxgltSdsUtl1aMriCP4k+vMWRtNo
         O0NoH1ae7OpKcitG7WIwZac2KnxsL7uhtRWh8bgrkOIZ9H/JmgYufNuEivY8K88pSnqA
         D9rwqqoQulNVvV51mCgFwKZ2u2vL89825qGFyzziZj0IrK/RXTihnFiXncIFHZ+a6u9h
         scSA==
X-Gm-Message-State: AOJu0YylKL729q0e50XJTbNptYQtP0retvfD1Zu4/SdYlctUDk+cKGOB
	eK9ZiejGr7Oll9l7xYOldrNDHHKG86LZv4xiOOis8OecQf47gyKC324z+Q==
X-Gm-Gg: ASbGncsRM4PK8Z+Yhj9WEJWY5eru8BRfPzBugLJI1HLII9UKeGwXRDNh4lRhYU24fAg
	41S/kJgwJN3l15zZWweAg3+SXQW2R+ekTWrR19ExYsHp22AnAoOp0HYqq0Uz9izezr09593yTrt
	42DgByUc2s3RyGo+tdJRH3uklXT+txoF2ph65xkO8agClda65c9BepsttiX09PsytDNJ95tBjKl
	2wXOcfm7BFVrJKM6eqMm3fXm1zJAPZYoKDTAsjvd7pY1oTOx7aVshbxIilu2gD/uzEI+VUZHwWf
	Czi/pIDQDreILU0VTmnq
X-Google-Smtp-Source: AGHT+IHM4+4hhNRJNw05QXTOYFlr5MNmEFCC9Xfv4wWF69RhLnJy0mpUohgmGGJc6Ek6ad9v4y1nig==
X-Received: by 2002:a17:90b:56c3:b0:2fa:562c:c1cf with SMTP id 98e67ed59e1d1-2faa05deecemr10137207a91.1.1739339491481;
        Tue, 11 Feb 2025 21:51:31 -0800 (PST)
Received: from localhost ([123.113.100.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf98d9fefsm640428a91.29.2025.02.11.21.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 21:51:31 -0800 (PST)
From: Julian Sun <sunjunchao2870@gmail.com>
To: linux-bcache@vger.kernel.org
Cc: colyli@kernel.org,
	kent.overstreet@linux.dev,
	Julian Sun <sunjunchao2870@gmail.com>
Subject: [PATCH] bcache: Use the lastest writeback_delay value when writeback thread is woken up
Date: Wed, 12 Feb 2025 13:51:26 +0800
Message-Id: <20250212055126.117092-1-sunjunchao2870@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When users reset writeback_delay value and woke up writeback
thread via sysfs interface, expect the writeback thread
to do actual writeback work, but in reality, the writeback
thread probably continue to sleep.

For example the following script set writeback_delay to 0 and
wake up writeback thread, but writeback thread just continue to
sleep:
echo 0 > /sys/block/bcache0/bcache/writeback_delay
echo 1 > /sys/block/bcache0/bcache/writeback_running

Using the lastest value when writeback thread is woken up can
urge it to do actual writeback work.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
---
 drivers/md/bcache/writeback.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index c1d28e365910..0d2d06aaacfe 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -825,8 +825,10 @@ static int bch_writeback_thread(void *arg)
 			while (delay &&
 			       !kthread_should_stop() &&
 			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
-			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags))
+			       !test_bit(BCACHE_DEV_DETACHING, &dc->disk.flags)) {
 				delay = schedule_timeout_interruptible(delay);
+				delay = min(delay, dc->writeback_delay * HZ);
+			}
 
 			bch_ratelimit_reset(&dc->writeback_rate);
 		}
-- 
2.39.5


