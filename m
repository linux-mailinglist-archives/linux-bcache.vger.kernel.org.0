Return-Path: <linux-bcache+bounces-1220-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E76FBE8520
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Oct 2025 13:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01B831884CE5
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Oct 2025 11:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D704C343D62;
	Fri, 17 Oct 2025 11:27:52 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACB03128AF;
	Fri, 17 Oct 2025 11:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700472; cv=none; b=IpQi0vmZnoBR1BjdKte24k8LlDfbEcCrznsEARVn/NZOTElDgVbNnx2QkV3frq5RAxl5vnLW7uplSdWMijGOwXQvnyI0l67bx1oWxRgUY5TVL7soMxQFuSbo5ot0CFDlDSCNtbe4lJObB1Lop1TNMt5Zx6tNAbcbWOONasgiuwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700472; c=relaxed/simple;
	bh=CZcskr+Q9AEsDHbjtdq1XBShG4uAg9MXPyQ/K0Y4S+E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a5MOsJToqMU20yTb4tq9Z7SkYfp6QkaTDfhe2vJiEQ0+unCMWFykzIANCtVmHrA81ih0915UKrooz1BaoxZu5Ya3NFYxBjLY959vTieAALCjVKZNUqYa9hHbdKZGU3JGCo8ItcITg9ml6xWsCS1cqfTQp6LRXk1IcOdCHgiXtlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4cca3f60ab4c11f0a38c85956e01ac42-20251017
X-CID-CACHE: Type:Local,Time:202510171913+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:ff31d857-3f8a-407a-94ca-39d25e20bf34,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:67b192479dfb68beb5b2e4b1047cc656,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850,TC:nil,Content:0|50,EDM:5,IP:nil
	,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4cca3f60ab4c11f0a38c85956e01ac42-20251017
X-User: tanze@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1600226422; Fri, 17 Oct 2025 19:27:44 +0800
From: tanze <tanze@kylinos.cn>
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	john.g.garry@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	tanze <tanze@kylinos.cn>
Subject: [PATCH v1] bcache: Use vmalloc_array() to improve code
Date: Fri, 17 Oct 2025 19:27:39 +0800
Message-Id: <20251017112739.244021-1-tanze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251017111306.239064-1-tanze@kylinos.cn>
References: <20251017111306.239064-1-tanze@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove array_size() calls and replace vmalloc(), Due to vmalloc_array() is optimized better,
uses fewer instructions, and handles overflow more concisely[1].

Signed-off-by: tanze <tanze@kylinos.cn>
---
Please ignore the previous email, a simple formatting error 
has been corrected in this one.

Thanks
---
 drivers/md/bcache/sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..7bb5605ad7fb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1061,8 +1061,7 @@ SHOW(__bch_cache)
 		uint16_t q[31], *p, *cached;
 		ssize_t ret;
 
-		cached = p = vmalloc(array_size(sizeof(uint16_t),
-						ca->sb.nbuckets));
+		cached = p = vmalloc_array(ca->sb.nbuckets, sizeof(uint16_t));
 		if (!p)
 			return -ENOMEM;
 
-- 
2.25.1


