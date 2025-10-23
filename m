Return-Path: <linux-bcache+bounces-1228-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 798DBBFEEF5
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 04:27:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 25BC4353C75
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 02:27:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB0FA202960;
	Thu, 23 Oct 2025 02:27:00 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1192AEF5;
	Thu, 23 Oct 2025 02:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761186420; cv=none; b=Jab84LAwxq2WjTJpFqX4ZdOtjE921LbXP3taF4UH8oc9tNEMzad+EO6DuuW4bim7eLl4tSmHBcI9c+4vHrF+mb1jg0WX/j/Y3CVaAvTv0DTfVJwkmq8bd6VQvDFx3RsnJgRn7cm/2WOPej3PPGMThAn8oLiIt5rpOwyOX1fcWno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761186420; c=relaxed/simple;
	bh=H95TV8i8Oc3tyQFVTlMu6xvcwsAnij8qsi0WyF/DqWw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NUOUBo5eB8YBddkaXFb5KVFth8NdFyZgt1d3K9OxisLfXz2NojLjC5D07wsQ1zPNmZSGy82YEHzLCMxTzFUnoJB6foMS8mwrqxwU7xGN2AjC6iVT7ZeFGI7Ov3r9tjZZe0d2PENLtFEreELNF7v06gVxZH+T9fjDQ29kjwNP+KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b975b3c8afb711f0a38c85956e01ac42-20251023
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:da30c6f2-080e-417c-9d97-3d4366ac6db0,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:893b816a7c0c9430c7a542dcf0fc2066,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850,TC:nil,Content:0|50,EDM:5,IP:nil
	,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b975b3c8afb711f0a38c85956e01ac42-20251023
X-User: tanze@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 200291275; Thu, 23 Oct 2025 10:26:47 +0800
From: tanze <tanze@kylinos.cn>
To: colyli@fnnas.com,
	john.g.garry@oracle.com,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tanze <tanze@kylinos.cn>
Subject: [PATCH v2] bcache: Use vmalloc_array() to improve code
Date: Thu, 23 Oct 2025 10:26:42 +0800
Message-Id: <20251023022642.742834-1-tanze@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove array_size() calls and replace vmalloc(),
due to vmalloc_array() being optimized better,
using fewer instructions, and handling overflow more concisely.

Signed-off-by: tanze <tanze@kylinos.cn>
---
Hi, Coly Li.

Thank you for your suggestions. 
I have made revisions according to your requirements. 
Do you have any further suggestions?

---
Changes in v2:
- Fix coding style and formatting issues.
---
 drivers/md/bcache/sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 826b14cae4e5..1ecd2cb3d302 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -1061,8 +1061,8 @@ SHOW(__bch_cache)
 		uint16_t q[31], *p, *cached;
 		ssize_t ret;
 
-		cached = p = vmalloc(array_size(sizeof(uint16_t),
-						ca->sb.nbuckets));
+		cached = p = vmalloc_array(ca->sb.nbuckets, sizeof(uint16_t));
+
 		if (!p)
 			return -ENOMEM;
 
-- 
2.25.1


