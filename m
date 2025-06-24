Return-Path: <linux-bcache+bounces-1146-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56DE3AE64C7
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 14:25:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D4D8407B4A
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 12:22:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC24291C1C;
	Tue, 24 Jun 2025 12:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+/7tgfB"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050B291C08
	for <linux-bcache@vger.kernel.org>; Tue, 24 Jun 2025 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750767587; cv=none; b=BwxUVJpprgCerJlOjm41xBRBBlYNdHCNJvNHk9v7hwYPy+T26LZ6+Lt+QrNRf5grExZtcrVTeKYInU9SwnUzpFP8rVBdnfadUhiLDwM1xe/XbYsF9z+RfP21CnIFYgDQei+8czK2F9fGd17G8T5wPoqy4Nu1kJUjqT8Bd6FtD4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750767587; c=relaxed/simple;
	bh=nkpZQEUWYuT5bBL04+eFmXegPvD2AWBxLkY4xLnD5b8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WeEkdBfuzPlHGyscjfbT/EZNPNkfqAOkzy9dtqwfinABD6xBMMq1dBacxh82K7dZG0WkYJ6UNErBYgAXsdUXhRSlIq95sAwtF9FhXFNSgJr7ovv4wlONw4NyjedmIvIFoyKUHfU8OYyG9xHMiZBvz2w3jsuW1fNlzoVMw3iHh64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+/7tgfB; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7490702fc7cso242054b3a.1
        for <linux-bcache@vger.kernel.org>; Tue, 24 Jun 2025 05:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750767585; x=1751372385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q1fiBFRY+GWV5uJ1K5TE6uOkIYds7kkiyH+4DeScdak=;
        b=k+/7tgfBEklJZLMSA1S+28yxj01IFQJq2osAwZV0BC9uMioHLknswKDkG7VB9aQs/U
         klL/jCXKlv2FTOfk6LbZBosTTkV4CYTqOAp3U185T4PHPCzs72CvNZHqH6ovQW/v39rp
         rzd0E8lvRV6ZuQQ6FzZbOiq5pnOtrFNWNUgMChynXrN+8/UOk6J0r4kT2UghQqaaP50V
         13ldN5js89vkwcFl6rO+Czpxa90MUNJk524K/fSr9YUlRSJC3Dmx9BN7cNV6VvTbE0b5
         zm92OL9pfsvk2c84wjbhIuNxZi8nZTl+i9+4BzCGlkhMpuAspegAjfPfAINtpBylixwG
         Ndjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750767585; x=1751372385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q1fiBFRY+GWV5uJ1K5TE6uOkIYds7kkiyH+4DeScdak=;
        b=nwHzL+2Hc1ffCrM7n45BYNHIJO6G9z0MJK7bNt2I+ynNLXFcEEjDYtG6djH9Qkj3qK
         flc8Mjv+rNhnlKM69wHwjkBIBP4figcgOJw8P4AgxNW5XERM8yXWAn67+7k0xZMhBcMY
         ZJ8klHS/o3KyMJG5ztQcHGTqjBgrzwRQhnT+mJRi5lpYGHG5EcP4PZwSbK1o5JaPhiVw
         blTlaTAGqvzUJX51VZDr1m7yBbc76V76fdMfoYQAy9wlYD68xQEJK9WzEON/74ZGPQAw
         mYx9WjZqIAHqJzrXzUnRZJ0SfgLEZG05Ztxtoz+C65rSMrZQzMaUsBY3sCcAuQi8M2R3
         6IhA==
X-Gm-Message-State: AOJu0YwuIPxhUhnRh2H3bUeLgdQ/oC4n0x7CMim1DiF1iMhlSWx0U9Ds
	clkwXy1fJgrG15MxwcOPLshB+aW4XDVdtFIBG0MJ/F3XVuZVMnxe89+Zh0Hz+ziozgCwFA==
X-Gm-Gg: ASbGncvj1iVd+aRtleDmTVCUA/2kLTqaNOieeUyW8rteey9S43QY34W967FwEiHQWj3
	k2/vSCHIk/eOhRz3zwwCnb6qTissp2tyRGjdBoFi15M4MHdlEWqkh4o1qVqqP4iGorZ18iASqHn
	hjwaMSUvf0PCcYE7It2oT/0iN9W7F6Q1tpucP0+32CDiwmbZtDyVxuJy38y5AqUaxvkyf2nvBNT
	K13i9FI+aL567dz2ArtRTccjTS2VO/kRCo/RDw1tZDzZ9txTH9Yews3/iVyqX/bmXG3C7EctV2m
	Pemul3Xg9Lin+GVN/Bi1afPuzXJw3Lt3HZgsloIbJ6CmDqPx3xf2IOpYdratS67K5acLCRBu/u6
	P
X-Google-Smtp-Source: AGHT+IGqkJpE+RmMeDIaeAWBt339Xrf7xpy2xJFBNLMmE0uIDQlHesayxe/DGV+MEC+WmxK99ctJRQ==
X-Received: by 2002:a05:6a21:a342:b0:21f:53a9:b72c with SMTP id adf61e73a8af0-22026e9c88cmr24790891637.38.1750767584771;
        Tue, 24 Jun 2025 05:19:44 -0700 (PDT)
Received: from honor14.localdomain ([221.216.116.116])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8851337sm1693550b3a.126.2025.06.24.05.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 05:19:44 -0700 (PDT)
From: Shaoxiong Li <dahefanteng@gmail.com>
To: colyli@kernel.org
Cc: linux-bcache@vger.kernel.org
Subject: [PATCH] bcache-tools: fix strncpy compiler warning in replace_line()
Date: Tue, 24 Jun 2025 20:19:40 +0800
Message-ID: <20250624121940.8738-1-dahefanteng@gmail.com>
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


