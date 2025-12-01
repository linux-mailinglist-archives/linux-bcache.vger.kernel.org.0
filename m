Return-Path: <linux-bcache+bounces-1311-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D4501C9650D
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:05:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2828F3A2A70
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:05:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C2C72FF150;
	Mon,  1 Dec 2025 09:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nbieNTfq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B312FBE01
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579902; cv=none; b=WHIotfII0kCs8sgKW3PWv9q6VRKSQeVTl9OF/6bqKkfwRUMRH1xiB8PAaawHngZFI3yxSFDW4jZ6cdDkxFuPwhsTAMS3dDN3/WFUEhbz41+yk1juTBl4A5yEKlSlveRCuMpr/2e3t6z4SPISGFvEAn7iEsD3O6po/9IcEap8WEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579902; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Nrapz+CX/+8LMvoC7VdQDlMS1Ze4L9IGv7B+a3RXGzsXrrJm/N5iw8rrjcBhrzuuIfWGkqthqAz72+2xEYqTCkctyT0bjYBvGOE4lKaFJioI/hWrlJGHomy6vW1hXrZDfjAoy18XW1M6d5fMVG2ES+swzyGDRi7r2U3LbXmWtS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nbieNTfq; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-298456bb53aso51531485ad.0
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 01:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579900; x=1765184700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=nbieNTfqgJGTlh/GgrhZAIZaBLoZjTBD6ft2QW7Rgu7WMrpzdkJ5NdroTW8N4xGBjg
         HFw+YJzO7Qw0/Tj4c7AQVPrtPflzgGweYjFVtri7hzymjCSmpw+wvUAv6Jt+lCmCaLad
         uMEsGfgGnuwvyvt6GWD7MwF4SDOI+CP24OLoVGrYQPRzyk+bO6ZbMnAceFKP1ip7ibP9
         0d1vgMJsFcVXJuBLzkOvTQr2fbw6dOW4WcKClu9QV9h5X6uYvs103wmCyEP5J9wRSY7d
         9CnHwGQECUKQQs+ATXtFoWZA2sJ7Lytmem/TdoRksgpsHcZZ8blVBQbZUOBJp2IwvYg7
         1haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579900; x=1765184700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=U4MnqBDDbIWATZ+xUJf8HAzoQYaVxuF7a5ga1mMwb1U+pRu+DD7Du7Pm7d5QXOfhNz
         qdp8LiOleLGLSHnoadNAhuVVcRNrN0Dv+sTfZWy9Ij2b0YE9t5DHwne3CHyeXfOiPARM
         hOp6iH1MfaAvx8CuekDoMbRvhvoI6pkD5l2BfzFcS+a2D+PibQ2oY7k91dFwQKKB30qT
         wtmFiEtk5Ul2BWMN53hlv4/fEed2NiMJRJF3jRCs3DfpEc9U+dFh845YbTYiDbJDJN8n
         l88yrw8fMn3qmXK3Zw446FHLmpqmNXgwf33FVefPeLyxD7yHmMTF3Y3ZhjpgBD/3GU38
         fygg==
X-Forwarded-Encrypted: i=1; AJvYcCXB+tL5YHObg/T8DK2Hf8CvlxbZ8rUf+YfQFgRdNUF+55KNHEfESDMSMfdp38Wh5Pf6aKGpnCBfdi2NCQA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5vgIq3tIYwKj5Slv8jhZ4JzjyI+eO29ghWpdM4f/+SgDKVW00
	2qHV0ND4eiRdkLPkr+g4ieGI/CfZZy4c2AKpdlUbpU++Zd5pszsXG0U9
X-Gm-Gg: ASbGnct3uRWDiF0d8aX5J0jQbus2jOZOpl8hOCo+1eXECkVxZtq9XFIqVOiso7eOrsb
	pdyAXzAkwsVFuJWShve5OdwEruzUYabTVlTwCIoQxW4jkYhhLGpw+adrjE+z5ZCRHgfHEbLDYXb
	CeVbyQ+n5/L/bpqIPucG4WSZ8wxR/Z3SHpXgrqng1mAK7/Z3kZ4+1dzGTnydeKXGQO1NoHeDZTZ
	B4Vy4AqdEew9j2Z9GtodY7Ny/05seEFa1mEjd9Ydve6WkruU/wLZZSGsM2WiCJC7uY4+n7duDnF
	RDl2DsUpA1E3DgMk1l78sCkK9fTbjRMrJjR77qNOWRNXf5gO8gtMaNfzxBP62nOzIZ02G8/8ehc
	gXMNIP2quxQEnGSKjHj5iIsECiqWBxQgZ+zHoS3BofSLm+Q79qaXNhJ0C9wdQxYZvA+B6kJ8RiJ
	3tjuH7aPvNh0o/qs7Wvc5W7rscKw==
X-Google-Smtp-Source: AGHT+IH19AutgiB4q5n1yDQ8ciHD5SRBcvRXU/5QyAJ1UaeK08hADApRcLuj+Gt1810PslIB22fggg==
X-Received: by 2002:a05:7022:6885:b0:119:e569:f61e with SMTP id a92af1059eb24-11c9d84bc2amr26089780c88.23.1764579899796;
        Mon, 01 Dec 2025 01:04:59 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm54908307c88.0.2025.12.01.01.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:04:59 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com,
	colyli@fnnas.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v4 1/3] bcache: fix improper use of bi_end_io
Date: Mon,  1 Dec 2025 17:04:40 +0800
Message-Id: <20251201090442.2707362-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251201090442.2707362-1-zhangshida@kylinos.cn>
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
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


