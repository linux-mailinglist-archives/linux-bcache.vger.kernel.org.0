Return-Path: <linux-bcache+bounces-1370-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 41003D22EB8
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 08:48:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B6CE330151AD
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 07:48:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E37D32BF4B;
	Thu, 15 Jan 2026 07:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hBB5Vr/f"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3983B32AAC0
	for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 07:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768463321; cv=none; b=Rd7Hhk9ew4z3n4y/x3TorFlyvMDDV5ZEK+lwmfYJwckjH96SOK5ny5rqMTGczGiRvTNsj/Qg1Gq7EwGdu6JrBQSchTO/oqkzP5tTz2Q2Et5mN/ruC1lx66VfsHU88WpLONd7O3clgwPjDlzjZPDaIEndRbdVDIYp3lqIi8zyxtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768463321; c=relaxed/simple;
	bh=0X42B03mCPCGzfI39C6/GCr6/8Z/3IApETRaB01pd9I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F7tYgUqHzTcq0BEFtrE1+EHGP3vRMDwnxIfexuWv1lrmU4SHL1Rvx/8mIkd35kiwEEZCnHzef4DUIJt0yJiqSmLx8hlyXdFl7NgiPOGwS/SeTiyT6d7PIalOeuOOFTUg122BWMxq3PxMkuG1rifPPbBrP9rp5/0IG7UjoT59Xjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hBB5Vr/f; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2ae255ac8bdso1241525eec.0
        for <linux-bcache@vger.kernel.org>; Wed, 14 Jan 2026 23:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768463319; x=1769068119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2TIYSBe8c2j7UeU4NjfNEF82mHDuPlUbUKvJDYdP08Q=;
        b=hBB5Vr/fGTU7pOPEILRKkS6qHpfowU3m8RLB1h4/SOoOl2EKaVdmJRjudqx21ihqYH
         bWys9ahKtEHhYtI0AZlzQoAApBIpG4XEsqPkP4c86k3rwDhgto+BI8DB8G3DryxcQHY1
         nLD8ZSDCfbqD1pq2HydM2ajDG/TPCSpCnb3569gZI6VmVqusXtjdx+VT9Clp9Pa4lKgf
         AY9tnoF+b4l6VoKT3DmHYzhV9ILNwIWDzWCFQRm5BL2oZifUK39uSNC0f8GKEKlK6tgv
         HsKQnP5w1B6KvgLxvRKpicVZsWqH2d2xpqrtsfZzoQBBuEmzw76wHZpngj9JJbqsfNN9
         H5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768463319; x=1769068119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2TIYSBe8c2j7UeU4NjfNEF82mHDuPlUbUKvJDYdP08Q=;
        b=f1iPbismT7ULph7d0hoN19x/nCX9DCsjivRpO1iXigTiGj71gzRcqbiaIrBvDFKRPh
         YDZ+uvFKElCBswR3vmhrL+7RF8V9ukSrOauoXE/XaFgbXIArEcH1xGzfv8+6McwfzZ9e
         2lxgSBX+hBgfIPhDKy2Pkj+cbdF8leVjee9eh+satGa4CqaEqXWY/4r3SARDGdUyolVw
         vvzgQP1LiSJe9YdpTo9AP4DHQNefkSrsf9qOmhnABkja06De+SqhZjNtdUq1fxl0AJ6o
         sigoVCHGqDibWv0GpjPUqXfe7ZSRcg/pOC29rocZuZCqgVMoTsUEx/zBUVN956FUpHai
         7cvA==
X-Gm-Message-State: AOJu0Yxncu+HQW0YbquvRBxRwyls9Yj6uauomqmh1dkHAD36GyHAXRap
	QIFfVLD+WkMWRm6nBwaIoOKWu78vfWTS/HGUrVJ8yZLyvxaiEt86+uf9XHVl0eCO
X-Gm-Gg: AY/fxX4FwF83kX99GvkTepnbtNb2Pfz83n0QgmMzF1JDM5VTKYAqEDMxy3tb6aknwCO
	ITdqiDGpm7y6d85arEaLUJ5Oz4NnZ9ZnaMsrJQEvc1YPiQFjgjpYFwxuTdfyHynYOpNmQJa5qu5
	I+Jp/lLOCwnxhTPZPwlny0OZoUujTUo+KZzmGaIj63JhDyODSOcwQ6ag1sUXBH0Z+PQtHeo4+ld
	jZAo8Tr6XAOzjTpvMhtzYNzfkwGqmxxEUKrABalK15J8tfNU+XA+Y/JPV2t/30htFTcF58rL99O
	WP40MfwU5P20v7gf1KYGKItghAkBpEG7mdPtQ7qMux0HAvFccngaw86JVAMRX19wJU72fnjuHFf
	mSrWCFFTZUVSgXe5/37g/+EgRm+qVtSh+zkG4i/oCtY0zblWbHlfCIllCXLghH2SrMbN9Sng5nL
	ofWfbS4VS9IbSrqMb63imNYvrgnA==
X-Received: by 2002:a05:693c:3104:b0:2ae:5b88:3499 with SMTP id 5a478bee46e88-2b48f6d41b6mr7379124eec.37.1768463319082;
        Wed, 14 Jan 2026 23:48:39 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b4549fc8e9sm5619748eec.28.2026.01.14.23.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 23:48:38 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: colyli@fnnas.com,
	kent.overstreet@linux.dev,
	axboe@kernel.dk,
	sashal@kernel.org
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH] bcache: fix double bio_endio completion in detached_dev_end_io
Date: Thu, 15 Jan 2026 15:48:11 +0800
Message-Id: <20260115074811.230807-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Commit 53280e398471 ("bcache: fix improper use of bi_end_io") attempted
to fix up bio completions by replacing manual bi_end_io calls with
bio_endio(). However, it introduced a double-completion bug in the
detached_dev path.

In a normal completion path, the call stack is:
   blk_update_request
     bio_endio(bio)
       bio->bi_end_io(bio) -> detached_dev_end_io
         bio_endio(bio)    <- BUG: second call

To fix this, detached_dev_end_io() must manually call the next completion
handler in the chain.

However, in detached_dev_do_request(), if a discard is unsupported, the
bio is rejected before being submitted to the lower level. In this case,
we can use the standard bio_endio().

   detached_dev_do_request
     bio_endio(bio)        <- Correct: starts completion for
				unsubmitted bio

Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 82fdea7dea7..ec712b5879f 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,14 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio_endio(bio);
+	/*
+	 * This is an exception where bio_endio() cannot be used.
+	 * We are already called from within a bio_endio() stack;
+	 * calling it again here would result in a double-completion
+	 * (decrementing bi_remaining twice). We must call the
+	 * original completion routine directly.
+	 */
+	bio->bi_end_io(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1136,7 +1143,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		detached_dev_end_io(bio);
+		bio_endio(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.34.1


