Return-Path: <linux-bcache+bounces-1230-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C99EBFF4CA
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 08:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2CD184EB1DC
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Oct 2025 06:06:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8817226059D;
	Thu, 23 Oct 2025 06:06:46 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C386202F70;
	Thu, 23 Oct 2025 06:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761199606; cv=none; b=tEhXrV/D7kRoHrM5yYGnmDQgIExxpeI+jmVnXf4zGN3EBSNzMPEDQ4lT+LfLGFr0UQ59CIrD/AHyNpdHSrbwx5MOSs30rTxP0Si+sLcHaWqzt63sYKAT8buqdMIVpsKT39QiqAH5GM7EJsXvLCG1G+OYYTU/z4q7FZM2Jlvk7L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761199606; c=relaxed/simple;
	bh=wMNnumjJicJoqPgWdyK+l69PZ/emwc33VKxymz4a84o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MBBzTsLHAbDlK+AIeQU+nf+ONkFfPWesVAi1v1E3UpcIa1xkO7HepWVr00Qy8nEPoJaVyl0zUtbepl7s17RywX3a/nUSY9Dt3LCmfIZ6kBCaP7gc6HLIFJ5cWIcbeSZ26GELO1D15rB8ktFuAXfvPece7i5Xxki7Cjhq0xLth/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6d79cc1aafd611f0a38c85956e01ac42-20251023
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:85431971-929a-4a07-a3bb-486db7b8152b,IP:0,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:25
X-CID-META: VersionHash:a9d874c,CLOUDID:00b3c77b57be2ea93448732c615ce6bf,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850,TC:nil,Content:0|50,EDM:5,IP:nil
	,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6d79cc1aafd611f0a38c85956e01ac42-20251023
X-User: tanze@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <tanze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2056816658; Thu, 23 Oct 2025 14:06:34 +0800
From: tanze <tanze@kylinos.cn>
To: colyli@fnnas.com,
	john.g.garry@oracle.com,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tanze <tanze@kylinos.cn>
Subject: [PATCH v3] bcache: Use vmalloc_array() to improve code
Date: Thu, 23 Oct 2025 14:06:29 +0800
Message-Id: <20251023060629.801792-1-tanze@kylinos.cn>
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

Thank you for your prompt reply. 
I have resubmitted the v3 version of the patch, 
with revisions made as per your requirements.

Best regards,
Ze Tan
---
Changes in v3:
- The empty line has been deleted.
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


