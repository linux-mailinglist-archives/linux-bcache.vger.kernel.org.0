Return-Path: <linux-bcache+bounces-1219-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B1A7BE8441
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Oct 2025 13:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 086B51AA20CA
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Oct 2025 11:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3798D339B5F;
	Fri, 17 Oct 2025 11:13:31 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A8733CEB5;
	Fri, 17 Oct 2025 11:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760699611; cv=none; b=c8OT/IU+TCPtdbzJll8doVPnXG+PJMDeLZi3u+LtPVuvQewk/Sr2XHRnBXZ2EELQBY4QsUpNKn17XtQjriHqySXci/H41+l6PYyXTg5/2ArqWBMHwqc4P+2bAcwdsCcU7sIv36kzvXHUBU+O17QisP+mEcnSnvJ1Xfc08+0YKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760699611; c=relaxed/simple;
	bh=pVe4gvowe6cEX4qcxxhiwQ8fXaoqrK46FFb8SQNzMgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a/gT/zJX8lzxvSZWMzr2HMvyYpe3U6tS6awbNt3AED3qo85pXgC4gMUwIWSWBwg+u1S4u7L06KxT2N0t5fKdltqIQNcTS6OJlJZPK6rOhdzD+wTJe9U999p43VcYMRQZbGFtULqTMkcnwhFR6fjcrPWtbRzNj3/b89Dp6i1UIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 443adffaab4a11f0a38c85956e01ac42-20251017
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:8c300dd3-ca1a-4662-ae53-dddd42663dac,IP:0,UR
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
X-UUID: 443adffaab4a11f0a38c85956e01ac42-20251017
X-User: tanze@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1087194839; Fri, 17 Oct 2025 19:13:10 +0800
From: tanze <tanze@kylinos.cn>
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	john.g.garry@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	tanze <tanze@kylinos.cn>
Subject: [PATCH v1] bcache: Use vmalloc_array() to improve code
Date: Fri, 17 Oct 2025 19:13:06 +0800
Message-Id: <20251017111306.239064-1-tanze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
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
 drivers/md/bcache/sysfs.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..dc568e8eb6eb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1061,8 +1061,7 @@ SHOW(__bch_cache)
 		uint16_t q[31], *p, *cached;
 		ssize_t ret;
 
-		cached = p = vmalloc(array_size(sizeof(uint16_t),
-						ca->sb.nbuckets));
+		cached = p = vmalloc_array(ca->sb.nbuckets,sizeof(uint16_t));
 		if (!p)
 			return -ENOMEM;
 
-- 
2.25.1


