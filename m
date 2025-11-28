Return-Path: <linux-bcache+bounces-1268-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 98587C912E3
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A78F2348598
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27D102EF665;
	Fri, 28 Nov 2025 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3h5NxD2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E12EDD6C
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318776; cv=none; b=Il60vWQjM2+a1B3oU+yMXfW2St8Lb5tMK+R3p7DQDuzzGMZ53UHZfF7hsmAK4dSgjp7L3HPd2TLUvzNVrwKDYh1XjFE4eC0xttFdYDtiIm5HgLAXI8QJAzHsE23TRFD/8oEpJODTuPSJPOkgZxDVIalUSebwpGrUxOau8OTeUFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318776; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hdblm6XZNwx1+fXXiRVWeDXbtfWNjrSNWb5HckTM6edy60RaBHBGw54zuunZMfa338pXNihYzCn6aJqf881cbrnnDFAfuLOGHMM3iNh9df5giZd0tHlZsuuVn/ZM71Qpl9U7AZgV7pGx1RBEl2+OeKd/UF19PeU9yD7JBCmQdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3h5NxD2; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b80fed1505so1933830b3a.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318773; x=1764923573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=e3h5NxD2+pjCU+SL4YYCXLOBvl2ZfbIVgZx0v94A5jYGGMy2YxzoJ2BvRB7sgYqCdG
         apEykxsswt4QE1e00J7/lg5wXxqaMckUKsKxLIzybNLFlVgVWGDFACNNWv+GOn8a1L8o
         lTIX9cnHDuZU6moNC2Mdj4bmo8eT8y5ikd79d5IfF03notzdK4Ug8TgTE9SeYdrqnMy0
         TXU4PRVHxeX8OJWhf8QHfhfDRnfR8kIZ/9I9MnoVuoSK8rYuvGayN8OcY+3lOOJXkS0b
         6sed7j4zSDFJ81iwNkdCcFDzQzIkXpi+lm/oZPlfQXMghV5QtreY6YfBaYgs0Qr3VYRG
         gaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318773; x=1764923573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=mfMHMQeXlJHvFZhX7pHcGdjO19cJK9RrDSZScl7pFEcGUbzDIr8Hk9Epo826OsVSzo
         mOpRgt4fgzJehMeEqLUfmP+XXLePg0X8pD/PoX1V1HXWgcA6PNy0E47s8bcvc/BrZDis
         u8tLe/mXrOkhwjV6b+k9CRIxffyAROPmRdZnAYgFyHq4HZrTnP52hXkAKhJWBXGlW1bN
         yVF1belmxbAwAKJceb+lwpmK6B9LvFnTqtR/ukBD0kxpn/froC7QIzOb+G18IDgG3TB5
         nstoc8EYW47bNGa5nO9d33dGqxuKBNsJn6NUFAlsh+8JXwVX6/a7G7svCnxKXfJIf5ZG
         tPkg==
X-Forwarded-Encrypted: i=1; AJvYcCXePRrIiZhTeZS2iamTQmEl6l+HL6zchyLjAL1Mh+4Zd8ZZi1CcJZGegkYRcLxTYnP7Ui4SSfKZ7wMGD7c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3+RWaTgzObp//7ERag6cl1MvvW2twpjY7L/5cVUOIhZoirElv
	im6q5C4XHH0mE99P9a6UCXfK0GbAa+yLbj0Ps1g2gW1qXuln7tXYklwk
X-Gm-Gg: ASbGncvOIrztum4IZfhqhxW+b2RXIRfrCf1aCLvOEwxUYIdClAH/hSybaJV0L95HEOP
	raZu/p092fDpuwooDUS9SJF1QRNTsPciooCZxRq4CtAXU/Cwu0XJk5eInUQQNADeX/htGgnRrpQ
	P6pPnhcz25XgPvjQMjMCcPhpPh5PTJF4LbvFugsr7ULXl5hdSQi1aKqiSeadqv+fiIwrakAyjzm
	vbrm32ZMxEkHhW0rwRpxqG6a704mE7gEDBQXBj89vk2y8yHr7n4N41o+UjnYm7mzw1CaK2dmtGQ
	aeklWfTk9NiMQkVsxplDfFJrkjQK1Uh+bo7H6U0/fxNIabwNUKIiSuSzfrZSCZJUCpcUYnwH8SQ
	AmKtk+Wuv+fV5m1jPmbnCzHfbLzMhY+/6xYm4sIIo/a3mM5oZbF5Y2TvTBzgLQ/0eUkzRCHDlJP
	xl3bywQltzRJKFst8XU4K82WiKMQ==
X-Google-Smtp-Source: AGHT+IExpRIXm/rx9JSaduyyoo433z0edlCZgYRCixn+2l+uiE9AooEQRv+QW8QlPPxN5lYcC0yJLw==
X-Received: by 2002:a05:7022:2390:b0:11b:2de8:6271 with SMTP id a92af1059eb24-11c9d8635bcmr22508225c88.39.1764318773026;
        Fri, 28 Nov 2025 00:32:53 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:52 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 03/12] md: bcache: fix improper use of bi_end_io
Date: Fri, 28 Nov 2025 16:32:10 +0800
Message-Id: <20251128083219.2332407-4-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
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


