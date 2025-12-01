Return-Path: <linux-bcache+bounces-1308-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0996C961AF
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 09:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53C643A1B3D
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 08:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B2A2C0291;
	Mon,  1 Dec 2025 08:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i60lXE1M"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310F5222560
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 08:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764577595; cv=none; b=IEH7SinRKixQF46JDy8221zgfkIkr+p8veJhTpp7Su79orFEz7Y/gT0PuSPhnqbOIYTZg8FERTLTlCXseD8ZmzTT+oNapn8dKe6eTpDRt5xScNS0HIVHqCx/mjjH6TWBstZ/MnI0SNJLbpqB2M66S5nZ+JbvKlgokK0762aAo9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764577595; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uK1/qUhr3F0tEmoQCGLjtvM5DMVqiTHpwY9pdpmFvpEYRGvNb+VjeQqb+i8K/0BpfGIqCAyuGYX1JNsYOcXCuEWANjOz8CN+8R47MImVMmD7cL9WiW99CzGYcoup1Ccnpm3iTGzwd/odFgpPgwK2o35ZhqxW9P7iuaHFGScIPDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i60lXE1M; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7ade456b6abso3013937b3a.3
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 00:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764577592; x=1765182392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=i60lXE1MwLwGO6xE6dzfpLQE2v+JD9qlDWdu8pXy9Uc0HzY99VB8rx0MTJI1ik5Vns
         tLapob8JLb8RdSBx5ZGyHPL8Y8JKBScEmbBlvou3tFuCr4T/EmsEAtcgEDEv3zG0JsGY
         YTSlv/KvXYsc89wGGr9MKmq2K60v/7AYkn6wTN34Y6qfQX4SeDu6gjD9SpIeFs7/BQPu
         C8AckKd548CKyDFUv8hQySk1jTCNMo+ERDVt3U9yJRR4+KYoO3YHnQSSRJ8L1nbEaWCu
         Bwq5YMSTBkGfSd1KiLn9YirDYpP3P48+Bo+tXzUO4sMGC9ubk2+JNokKdRz1dIvj8Xey
         FyFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764577592; x=1765182392;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=pj3vTQCQsvreiHDZ27cnAIeElg4bkBCydR8vsXzCqI0HcBz7LwucSDiEpCYExfXFCp
         imyeR1brN+Y6cmEbUZ/Cz2WWTbl27j8SFPVVrNL2Yez49ov4e8MF/REO0geRd1NcgBeY
         Oi8oKZEhhdKfbJo2bvh9hXNIkRDgCHVLdB3s6Zeig0T+NNnAVbKP0z07wVFjzKiYJfrl
         9vxygQ6Ho+525v8Ea5gipPpIT8zzywX+SPf6I8GLDim9R6bChFhNxBYAICwu+Ftac03C
         /qN/z836RmaKv6V2wCClYlA/6vMHAbw6KqLvELMssQ0Kjyecv7uquTmvfUGYggjQkPsf
         Ckcw==
X-Gm-Message-State: AOJu0YzQZhgv0T3P2Nz3yOIbOuq3p+UK2/cXFD+N+RAJdLZIKOL+sTKa
	NwljUKTH+8i0ZCRDyZ+AWygwXMXC4TJvDCS1OQd/QHAiDcvIWyKeQxZ+wzimyQ==
X-Gm-Gg: ASbGnctkOe1wf9b/EPW/LIPk/6gHo3l2RRxQIMSxxZGMf/CW50jMaNWcVrSM6/RF+Nt
	rRCMBQBnEtVa6Ovc26205XOgX7qOsbScQjOv0UTueAaYWxJj49JIFOFtWr1+Ddz/yaO4++Lx293
	fNtyn8FHLeeyuDz79wwReA0nK3q7uBAm/K6tlyw1hVolrEdQgCBhHSSzmDTloRRkp5yMfk7KsGA
	MAOwN8iFTBEsDLAzdeHk0pXtrVnhXFnPA5skkW65XmjM7GMcdR9am5UG4DT4+FZkLY7LvWzAeB8
	HO+qJ+0+XZ5TiM7VG7POfWdvtrNJ0ndjc6UGl78koF52VJz1lB/tNQzm7ZLSfc5tU2vHiNjViMm
	20icPO5C7qTQXSugCBN7VdriyScPj1ukplO77bohpD0rxULhs9UmfoVKIfNdLoXB01V5QP5rdj9
	+xauwCjKlrrKCHsRKxbTrCUKb5NA==
X-Google-Smtp-Source: AGHT+IHkB6F1n1pCPSMHu7lL5tTRqaUJZpvVYbCWc1Ln0mtXxaCu767RCeSksPf/MtCaFLSiooG/jw==
X-Received: by 2002:a05:7022:6b9a:b0:119:e56b:91f4 with SMTP id a92af1059eb24-11c9d870550mr20266043c88.37.1764577592272;
        Mon, 01 Dec 2025 00:26:32 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaee660asm64015545c88.3.2025.12.01.00.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 00:26:31 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: colyli@fnnas.com
Cc: linux-bcache@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] bcache: fix improper use of bi_end_io
Date: Mon,  1 Dec 2025 16:26:11 +0800
Message-Id: <20251201082611.2703889-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Don't call bio->bi_end_io() directly. Use the bio_endio() helper
function instead, which handles completion more safely and uniformly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde..82fdea7dea7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		detached_dev_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.34.1


