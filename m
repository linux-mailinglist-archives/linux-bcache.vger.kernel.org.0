Return-Path: <linux-bcache+bounces-905-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16586A93ED0
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Apr 2025 22:21:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 571023B0986
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Apr 2025 20:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE70E2397B9;
	Fri, 18 Apr 2025 20:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hr8afw54"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF4878F29;
	Fri, 18 Apr 2025 20:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745007702; cv=none; b=Rp1jNJbtgzTtzRuj4JQoICZncPefNiqR0yc8QZQZ5x0rZf6/vh1DwsAmYwjBItXV8tLCxj/Mq9bvjx0+LlWmG1BWC5X/9geHiUZKnA2mxeE/5COAwGIzMhgof6UsFmoTC+5eVAgGcr5ND16SL98GMo1zJUrYsLLHIQX4yI6OLcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745007702; c=relaxed/simple;
	bh=ejGqMxBwLKw1sJ1i/ZxUZ+LGirhTccZnFytelkYVwuI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dnXC2pu+IsPiO7l4nReI0RuMJ/3t7sqUFbm6GO9YMVF6AyVlL3KOrGVYyOxh37FkDi+r68RURPcQ4MdmZ7n4f7GPL6vTUZL9wuT+UBRV1lrH5KIfrd1EhNdkhWcdX4Ysju5s8MQgs3ypYFusxcx/K8HH718NDzGA1tTyTU2CeMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hr8afw54; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3355AC4CEE2;
	Fri, 18 Apr 2025 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745007702;
	bh=ejGqMxBwLKw1sJ1i/ZxUZ+LGirhTccZnFytelkYVwuI=;
	h=From:To:Cc:Subject:Date:From;
	b=Hr8afw54ncK1nddacm/HaH2IvzmGtQ5de4Y5qp/hEL+zRmNWuh/LfCQ8plPxkLNoE
	 pSL4Fudc2BdNNtyuJCVv5VY5o1g5zyu5XKSxXSzF4P//LujEgf94L4hG9x71PHu453
	 ijQWTfRXk1TrTGHzpuUOtsc62SCbowj3vfdq93GF6T88W7OPVOd6KIg6i7bcQ9L0Ld
	 8KPHO5ISTv4NyLSgwYbjOzovGnFE+5wC8tNIaQUw87F5C4GlR6Z6ouCPpN9FhxPoxl
	 ZEa6+U/0lovUNfe/rAPivjy3InWKFLTN2ib4OgIkVvkqTwfFrsitolUV3bRS4n/cVF
	 CQTyqCVwnTLgQ==
From: Kees Cook <kees@kernel.org>
To: Coly Li <colyli@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH v2] md/bcache: Mark __nonstring look-up table
Date: Fri, 18 Apr 2025 13:21:36 -0700
Message-Id: <20250418202130.it.887-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; i=kees@kernel.org; h=from:subject:message-id; bh=ejGqMxBwLKw1sJ1i/ZxUZ+LGirhTccZnFytelkYVwuI=; b=owGbwMvMwCVmps19z/KJym7G02pJDBlMWwLKdu898ifiXN2Kdv+XT474Nf2vmMQ8YbH3tye3F wqocl2X6yhlYRDjYpAVU2QJsnOPc/F42x7uPlcRZg4rE8gQBi5OAZhIz2VGhu4Dylu4VB3jajO3 8jPOTfgpyvhh1f3Fjjv3bb4Vaq7L+4jhf1SKYETSp58Jy05ej3vJXDrj++6i9l9dIRzXTr122S6 6lAMA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

GCC 15's new -Wunterminated-string-initialization notices that the 16
character lookup table "zero_uuid" (which is not used as a C-String)
needs to be marked as "nonstring":

drivers/md/bcache/super.c: In function 'uuid_find_empty':
drivers/md/bcache/super.c:549:43: warning: initializer-string for array of 'char' truncates NUL terminator but destination lacks 'nonstring' attribute (17 chars into 16 available) [-Wunterminated-string-initialization]
  549 |         static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Add the annotation (since it is not used as a C-String), and switch the
initializer to an array of bytes.

Signed-off-by: Kees Cook <kees@kernel.org>
---
 v2: use byte array initializer (colyli)
 v1: https://lore.kernel.org/all/20250416220135.work.394-kees@kernel.org/
Cc: Coly Li <colyli@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-bcache@vger.kernel.org
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e42f1400cea9..a76ce92502ed 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -546,7 +546,8 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
 
 static struct uuid_entry *uuid_find_empty(struct cache_set *c)
 {
-	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
+	static const char zero_uuid[] __nonstring =
+		{ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
 
 	return uuid_find(c, zero_uuid);
 }
-- 
2.34.1


