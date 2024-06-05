Return-Path: <linux-bcache+bounces-507-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 583318FC23E
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2024 05:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 572E01C22615
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2024 03:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E069D7345C;
	Wed,  5 Jun 2024 03:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EWO6naKT"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0C2207A;
	Wed,  5 Jun 2024 03:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717558917; cv=none; b=dXCW/1gbZbHnMXyohPkChRUZzIiPIzYwJwVlqqGP1wEtRHx7VG9yKQQ/dsprD5Z4T9JW1XzllkmOkD7L39B13Zd8sITUtMfpS7xJof8PF5xImAcmQdg/fDXqvu33CckzOXk+FJPc9v1uJ/ixy2CLBw4yQXb8+9Lc1kxmFpgHV0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717558917; c=relaxed/simple;
	bh=9c0gjMYAqxvtQn7aLIFBQnVk1OkShMwoxZgNanIbVts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ng1SGxAONOeMfZy6tFNduI4EgbO7I3lMwxcdMB6ybD9GQnS9RNg3yrmVFBWBSxZtof9J9DJWAjPUQTjwE4Ny9M5DGXf/gr1Mi57AeMMBbGwcXtqYrOObCf6okOUKrP+Bqxl7UKSkRYv6hdDke0UlM8FEICpfNkwRJf9KbC8FLfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EWO6naKT; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-656d8b346d2so4516567a12.2;
        Tue, 04 Jun 2024 20:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717558916; x=1718163716; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j063GnbcnSiG+5t9I1lfB7FjoGarg4y5JgKSos4DqMw=;
        b=EWO6naKTH95j8xnKK+py37N0mdPJxGyghd/CbuvczrnAR/RAuL7JJVvwV9rca6afl6
         ibh9nlT+sb3qYqFGdbH7gXYhKBv7UX3Lx4a9U/pjPdovFY5ueaAaq0GTMtbMgHHp+its
         9ZAc/hvZHkCeRGI5E03VvEptd29MY189N55wD0rC4cLhSsWsYMgdEEDPtuK1VXjuTz8c
         HkUfQ55WWryJxwm2f2cV95OXP5zjIcpOeHjtSZ2PJSRyWv2jRWQR78oqlInDgxZqZc5T
         JSq7Hc4+byOIIyvhT9UAaBfAuUhGZahyc3RZruCObQdbOBLx/3CpQbr68N7Kz9S7YO0J
         qVuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717558916; x=1718163716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j063GnbcnSiG+5t9I1lfB7FjoGarg4y5JgKSos4DqMw=;
        b=pLzTHgD9932ETknWIL/FPeKTkfXcMsNVrjdHqSOfx1gK/UwOR3e5xHEEJkAr0Pg3vl
         Z1cjmB3kfZYBxdIaX88S2oaAMeZbf0ko2ecVAJ10PyI0obL87GE3YXSDU+z2lkMCdSeV
         2Asjev7ydXDi60gMbhWypJAYd3t205k//5y+IDE4BT/e9attyu2mijd0pfuDoKw3i4oc
         qrKDNHSXKN7oagx2bW+n8punertzOiNtQ2jC40yb5fG7jieiuvaMixOUN7bh6ozqUPqI
         9KaaJfxtUG15JFSjcfqOddAUihUSSHPI6x1a7DgicmElTD5e/QIOt/69svJ1JK74Ux7U
         iHrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTjBagTVxFimb7OzsWI9SRoYkqN2D5obUS0fdJyc5G6JD2Sn2SoH9bdbZWK4cMnVZx36WDkFdpSPETT0CikWaHHbCb2OIEBsk3AAXMfqXIb66CFHLDRC6zGbMuDu8qUcIBS6knlovCiZ6m
X-Gm-Message-State: AOJu0YwRK5YbAusixGPEnQVefLNY0InjSRqpMoA8aznxgdD6GP2S+U9S
	lGBLFc0Z1QN3yoTzZB0DtU6nBKKRbBZEQmJJ5ZPBWp7z0UqDMkU6s5PWoVkR
X-Google-Smtp-Source: AGHT+IHR44CKnHUCQpTwDPAtiiHMVa9hZW7rkg4ZIG+Lu+JbdjIj5DMIAwQZv38pNCnkq/ROgXgh3g==
X-Received: by 2002:a05:6a21:6da9:b0:1af:a37e:367e with SMTP id adf61e73a8af0-1b2b6f81145mr2068514637.15.1717558915569;
        Tue, 04 Jun 2024 20:41:55 -0700 (PDT)
Received: from mari.. ([2804:431:cfd3:42f5:5d7e:7952:2a52:2cb2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f632416a1esm93861225ad.284.2024.06.04.20.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jun 2024 20:41:55 -0700 (PDT)
From: Marilene A Garcia <marilene.agarcia@gmail.com>
To: Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Marilene A Garcia <marilene.agarcia@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: Fix compiler warnings
Date: Wed,  5 Jun 2024 00:40:57 -0300
Message-Id: <20240605034057.2671663-1-marilene.agarcia@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It fixes the following compiler warnings by
using "/*" instead of "/**" in the comments

drivers/md/bcache/request.c:309: warning:
Function parameter or struct member 'bch_data_insert'
not described in 'CLOSURE_CALLBACK'

drivers/md/bcache/request.c:309: warning: expecting
prototype for bch_data_insert(). Prototype was for
CLOSURE_CALLBACK() instead

Signed-off-by: Marilene A Garcia <marilene.agarcia@gmail.com>
---
Hello,
These warnings happen using GCC compiler the command 'make W=1'.

Thank you.

 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..457b9605aff9 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -285,7 +285,7 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
 	}
 }
 
-/**
+/*
  * bch_data_insert - stick some data in the cache
  * @cl: closure pointer.
  *
-- 
2.34.1


