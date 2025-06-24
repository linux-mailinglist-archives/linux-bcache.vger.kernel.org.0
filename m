Return-Path: <linux-bcache+bounces-1145-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7E89AE6434
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 14:04:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1D084A3E8E
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 12:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3044527A445;
	Tue, 24 Jun 2025 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyGogrKu"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D33428ECEA
	for <linux-bcache@vger.kernel.org>; Tue, 24 Jun 2025 12:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766664; cv=none; b=CH4tXg4uZC8yauXc7p5ITMOIqB6TqkJAkQyD93jCeA0hyZ5oZP6Zj32g+h9VXKmH5jYptQsFBTKViyjTfWo7z8COpUB8VkCFOFd6awSCPgD3yPU8ePCLBO3VZ0Ntmk/np1zlnEHrUbKY6nL+okxEM33rQ6rntajqNjYRm/nRa7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766664; c=relaxed/simple;
	bh=nkpZQEUWYuT5bBL04+eFmXegPvD2AWBxLkY4xLnD5b8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nIOIAh9gmJXnNcbL9wQ4h3x1U3CsCyUTUFJq9ofr0t/LMzIJwGP7XVrkazXl+B/Fohg3drQnYbB7BbvNF1XJfJEAzhDZsqLfLnMeDyRBWToXhyLjeOC6HnFMPRo/G7j3xb0ARVYUa58EMil8S/jUVhVMts9rtgqdK08i+NilFyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyGogrKu; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2350b1b9129so38216245ad.0
        for <linux-bcache@vger.kernel.org>; Tue, 24 Jun 2025 05:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750766662; x=1751371462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q1fiBFRY+GWV5uJ1K5TE6uOkIYds7kkiyH+4DeScdak=;
        b=HyGogrKuFf57t/WhS8z2WIxyii3kmYr4ZbjFU2iyY0vph0x9j3ufRAWrDH8/N6MYGa
         93gjX7i8f95Hk58CKbTe2TO3NcJZePXru6H8SQ6a+4XG/8SIWYtzDil2VMSMTG/xJWKZ
         8I+G/4AS3IRr4PfWnDbYbkGQnjl2bvsPGkBdto3IKMLEhyrN/kzVkMvI35culzaehevq
         ktled0RmzTMEyXzTDggpui/peOMR6fhvxcZnRJ7bQ9yCDacMVwy721b81UOn3Mi8K+0n
         bvpsrpm7VjRPm7REKKd3z+8bbPQAhFb7cyJLWPpbmaSQlD5KdZ91JRB7a29UxIirCMiF
         K4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750766662; x=1751371462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q1fiBFRY+GWV5uJ1K5TE6uOkIYds7kkiyH+4DeScdak=;
        b=aPnjNfS/iKwDaVBz6tVs2QIjG20OfJM7MmoIWe1Y0fWMwakEsz3+aVLa63E0y7FY0K
         iFoEN5lprbSwAFghQ0Pjovw4YDfq18eGaX4ehuEiQAItlykz4t+I1OlNvelgUnTyjDdc
         UbcnLKR/KtfAIIGgP2u/hGxdccRzBBsk+mMVtqdcsx3Vq3n24J7xadk6LX/IoF4WtopN
         DwswvF5mgJ7I1PCN5zmAnbNPObMX9W37KnFHJcDHyjFqh20UUKniSbYDIwbPs6JJv/hV
         jbz97qAABOk15p8GJrkh3XEOvfcicFP3LuZJ2Wu+Q4JtawaduAPoHfSdV+Zdtv2C6oey
         gPYg==
X-Gm-Message-State: AOJu0YxqWZ0yzsB+b1f5uFJrwicXTSMXIP6tsdk3u8FnBg8QH+gtx0hH
	Y39nk2zK+nkuGPzWBAYa3dLEHFeLUGOry0sAbr59wnC01vX56EVizUhS
X-Gm-Gg: ASbGncthc6PV8329+0mnF62oYUYGf+3btcP93vDYjm4VA4GinghbD8WfFMgRdQT+iD0
	gdVW8bSeP3eajCV8ZZWwFsaNWITcAKgbHYQins9WfNZe5qSs9GQFM63BYT3mBqDvdWMHTgUQbv4
	S17YRo/WpRhuWPICSLrauSOfykF2cTj1SGKkYL9dzln+PI841MeIu4pY+qwV++yYXnnjoCOyJ+J
	43YA8VDA5R1lnRMC3Qh/TZ451CsHRThOt0ggEe1J4vUpgHhygGR9FBYMW8M6d6q6US2PMLlkHY7
	OjsrFIR3JCE6WY2cKVx71xaLOQkp5Iv0Tso1G0giVekdlFeIGMxnIXnBaLdM/pQRJ+nGeNEyCnZ
	5
X-Google-Smtp-Source: AGHT+IE3J8/aHZ+rLogeYHMGN7b0ddyQS3dRV4d8pfFpz4rkz4hbxWdBXYubaOuXivttLw6RlRFaAA==
X-Received: by 2002:a17:902:d547:b0:235:225d:3083 with SMTP id d9443c01a7336-237d977a543mr201996115ad.6.1750766661755;
        Tue, 24 Jun 2025 05:04:21 -0700 (PDT)
Received: from honor14.localdomain ([221.216.116.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d867c0d9sm104572835ad.177.2025.06.24.05.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 05:04:21 -0700 (PDT)
From: Shaoxiong Li <dahefanteng@gmail.com>
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org
Subject: [PATCH] bcache-tools: fix strncpy compiler warning in replace_line()
Date: Tue, 24 Jun 2025 20:04:17 +0800
Message-ID: <20250624120417.8310-1-dahefanteng@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strncpy() call in replace_line() was using strlen(src) as the size
parameter instead of the destination buffer size, causing a compiler
warning about potential string truncation. use snprintf() instead.

Signed-off-by: Shaoxiong Li <dahefanteng@gmail.com>
---
 bcache.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/bcache.c b/bcache.c
index f99d2dc..47d45e9 100644
--- a/bcache.c
+++ b/bcache.c
@@ -142,7 +142,7 @@ int setlabel_usage(void)
 	return EXIT_FAILURE;
 }
 
-int version_usagee(void)
+int version_usage(void)
 {
 	fprintf(stderr,
 		"Usage: version		display software version\n");
@@ -157,7 +157,7 @@ void replace_line(char **dest, const char *from, const char *to)
 
 	strcpy(sub, *dest);
 	while (1) {
-		char *tmp = strpbrk(sub, from);
+		char *tmp = strstr(sub, from);
 
 		if (tmp != NULL) {
 			strcpy(new, tmp);
@@ -166,7 +166,7 @@ void replace_line(char **dest, const char *from, const char *to)
 			break;
 	}
 	if (strlen(new) > 0) {
-		strncpy(new, to, strlen(to));
+		snprintf(new, sizeof(new), "%s", to);
 		sprintf(*dest + strlen(*dest) - strlen(new), new, strlen(new));
 	}
 }
@@ -453,7 +453,7 @@ int main(int argc, char **argv)
 		return set_label(devname, argv[2]);
 	} else if (strcmp(subcmd, "version") == 0) {
 		if (argc != 1)
-			return version_usagee();
+			return version_usage();
 		printf("bcache-tools %s\n", BCACHE_TOOLS_VERSION);
 
 		return 0;
-- 
2.43.0


