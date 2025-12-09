Return-Path: <linux-bcache+bounces-1349-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9743ACAF615
	for <lists+linux-bcache@lfdr.de>; Tue, 09 Dec 2025 10:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79336306A05A
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Dec 2025 09:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4123E26E715;
	Tue,  9 Dec 2025 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EpJxwryK"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF427145F
	for <linux-bcache@vger.kernel.org>; Tue,  9 Dec 2025 09:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765270935; cv=none; b=ANj5cdGsAruQy09FXEwtqEJtgubZQkB6RhMc5gyW4VpikKGVYFnppb42ZIgPQkf1hfkeiYaOfEmbqbZqbynaCbA7cjsqLjvdQMbzgPPGSQ2v56HwCtsPgyhZIRJlHFDkoSq5VRpkiGBIkB+nlOVd5TFz4nvUiKtBGXZFmgJkEXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765270935; c=relaxed/simple;
	bh=54Xh/j2WhG2Ei4a1qEnIpkmDGonn8ZggrBoCMAcXO3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DZMFaEOEKk0yXE1iWuxZr1j8lsBLl+bgEcaZZ8Io7EtzdCojuT5fQmByFTSrg+eOf9+9McLdgDkKbH+lxcxZC7cAnOmuZVgKXeOYCwENtW3FEhSlrK0QCPgkRjg6OdGvahT2YRiQqu6HZfnfVtH3lUv79FKmHZTQP02kwz2cWAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EpJxwryK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29806bd47b5so32097495ad.3
        for <linux-bcache@vger.kernel.org>; Tue, 09 Dec 2025 01:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765270932; x=1765875732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/7vzy1FUoDsUfjpWUzueUpIzsuHBaOImPA4L+Mj+ZI=;
        b=EpJxwryK9g1Feixo5HHg0A7IWUjHhSJZm9ujaEBQ9sWhRetOzFD3gsyryoOuyYVUBJ
         19Rx37MWHMc/F+ASQSz0osshuiVFw8yVyYJRhaNqSTphkLEfR0DmMrC0q6ACdLYGpRHP
         k0yKYhmmAoAgYzAmVppILLEScbdCuZZyhUYeRQiEpb5KVxVYpi0H9xXddfTGa6sfcSST
         FdWWUcc6l0AwwalAkqJ/DCpJvEDPQ0SEw9BYRn4EJKnThghmHaotEaw3MdTvV7mhx7vY
         8Gxvz0EE08zYWCKUQFmw07iIiPoJNq+Ozq+4xhqxM43CfFRz62SwrzFM6U6hv9a3lOjn
         QdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765270932; x=1765875732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i/7vzy1FUoDsUfjpWUzueUpIzsuHBaOImPA4L+Mj+ZI=;
        b=L4Du6bbtjjxgP8nrx0mTAnbkFgmaLYKHxBeLZKM2DdAd90IsNXBWbQJ7tsXGCCO0tt
         qOGQegtUgMa1WBI/HfqEUeLJmKhoOeDuQLtT7vqFLtU40xzzGu9/WFzyuU0ELGb9nEGO
         DhxSeC8tGEnFfVyIWyueYikFBLuGvm2Pm57HbTGFA9cFplAmlCtaz12n51rwWUHpm8eB
         j+y10H0hayCEtPf6TuxxBpmiYddZjxyzvFsT8kQOhYYduPDs+u/ZpBE1X0myqgjYNPP2
         JF8QE+lR06kY+6aoZtR1hrm/s8zNw37NffUyfxv7Uti6kwQ9QTfLF19qaSQulQEFPXOw
         Oajg==
X-Forwarded-Encrypted: i=1; AJvYcCU41w9xLB9o1fXtvB/4X7wNH2B89rb2vfOWa1F8bdYRv6ZkfomMANfrHH+sX10MjWMimGdkVpPSDJhdEu8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk7Ar18dtFXnd3OPex5wN1b/h3Ov5irQHSW7vjHaz55gPGdcLP
	VQPM6oYcVv0iIBLjsw/K5ufWy5aQELxKZZ/gnh/KXI6lveXj9RL7x0NF
X-Gm-Gg: ASbGnctFyFuOeLGYVVlsid0+YizBRp2WXUD0tLrzDW2wJGxrBPEPGzqv5sw3i++Wp0l
	3Im0XGAzSGVnjXaWhw6bj5KVnEG37rNkr7FtLaG6KEz9UYu+rV5Yd9ztq8Dv//RYMgDgW4JB5cA
	melcAIUVdPNpU+3dZoMoDYkWGOc12qikFltIKXw34jKZ24/f5/nnfCD3rbZNUM8i2a8cGvuJPWM
	sxifNv22ZM3wZ9dv7k68XdvhQvYCHMcR+DUmHNtMyLFfV0xRTbmEMHRpMzDCJaG8+4A8h7rfnRz
	seN+q1If9/423kNLTwg0zPCITqja3pQsOZEsBoPo/tn4pJIhCYLtoRuWMK1D4LLUZZUrhPOqxcC
	uPXdNPh/4l5UUu63Bbxzll23eQS01B2RFZC+Me0nPAumrBUeOlua5sP9aaFhq1mUQoL1/mQM3T6
	6eYanJBhz5WXOBnE502d0CydyV2GBXL+yTV5p9
X-Google-Smtp-Source: AGHT+IEWOR2FgI2CN9m4o4aayuOxDe2oGxmpJeGBPF7NkEyhYo7Qnk9E6QoJf+0EWwAzSeLh/XP9Fw==
X-Received: by 2002:a05:7022:170d:b0:11b:9386:8258 with SMTP id a92af1059eb24-11e032d86demr4398847c88.45.1765270932150;
        Tue, 09 Dec 2025 01:02:12 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7576932sm69700982c88.4.2025.12.09.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 01:02:11 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 1/2] bcache: fix improper use of bi_end_io
Date: Tue,  9 Dec 2025 17:01:56 +0800
Message-Id: <20251209090157.3755068-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251209090157.3755068-1-zhangshida@kylinos.cn>
References: <20251209090157.3755068-1-zhangshida@kylinos.cn>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


