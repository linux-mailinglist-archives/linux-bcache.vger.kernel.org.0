Return-Path: <linux-bcache+bounces-1267-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E44C912B2
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A25DE3520FD
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:33:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C9C52E9EBE;
	Fri, 28 Nov 2025 08:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kzg9a42n"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882B32E9EC1
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318770; cv=none; b=ZzQdIg0UT3xtL1Mzo2/ZlRAHI2rxS5V2Zlk5+gxn0iPmAViD8LJPZaW/+vQlQSacQZXFbrr5xNVLZvIfUH8LtS+Csgx4TiyI/XH03I4HZylSCongiBXjMOfk0o1Qz61uapiBq12o+xuvJLw1CStt4mOelhh7BznaOTbKv0/h3vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318770; c=relaxed/simple;
	bh=vDTdwwqFiUx+YnWL6sZwmz4ttt9jO7ABRme3mV3jkpo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Qk/ch2UdJ5bVRo1MSydmmC2nxf3hBwkHeio5cS2iLrWuQmf9h4HlBbp4VU87Ac3ORF3HfXpNyfcpsTLPbPto5LOVF//BzF+Bck+BpAS5jakzcjF8vYRsRGyQA6jBwCI10wyGrImypLi4roArj0cPHEWAyYHECYxJu0Iq1WSIgeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kzg9a42n; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b9387df58cso2672050b3a.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318768; x=1764923568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=Kzg9a42nKrcwuYJQY+ScZnAHIrHBJFMdQX0bDvUZSFigzvsmYxoJlJxMQzE+0EDozZ
         c5GzOKzqIpHvZWVmkyMaI/UIkTqtD+w74trvULVNNRtHYvDxzy3aOGgUm4MAWg4QsJJO
         TLf3Pg/lRzat9g/FDJqx2Ndkc4AkEhXnlOnJBv4rLYrNNn3z0Tw8gZC3x8R1sM1pAjW+
         8S29cMxQFrsZBTYkeUzoUU5aRZGaujLAkU1uoT0Ppdt/TOUDuyqO+q5fX5PBQaDfU2Tp
         vlq+R8uu4j+Aogm8F2dpG41wTSSXL6T7K0JuCRjvfZ2XhZEyIlMuzC3q6NRK02smo13l
         EcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318768; x=1764923568;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dYdGxu8+S3la90e5ilLAk2WHMl9XT2MOPAJKSPmhLP4=;
        b=Blea5niHswy4yFQNhZyv32V3L9hccw/tZKLXlKaJ20jSgbqKVgo73oHpdmpDW178x4
         VAXlM5cDZUKrX1nQEyjjg5TyLF1mgzoYJGjL4K+MQTNbW68ygKVdGmTRcNnaDu/zMY33
         mTKctQMUYzdGO6NGodWTxruZGy1nBP3t01Sjx/FgzMwG1g/Yh8+9wXCSroGIJubNPMDn
         BKst2Nk5ajZ2W4OGWdtmvMN55HVOfDZ4fG4Two2K/DSHXBmG5ewMLPBcdSVbtBxZU5KT
         lNwiAx4tCh6szmWt4GU6LoUkVncMT8fjSMIjuQCD5cKPn+ITgVq9wUJWVuxoh12J25G6
         V87A==
X-Forwarded-Encrypted: i=1; AJvYcCUT+HeXSUeGNM4n5BI6+Tj2X8VXpearI5mqJfIfTTEebei4pc/BFmgZ0Q5J6/LIIHFqqH4rJJKLl6rIc88=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5W+JZSm172Q64g4XXdJOxEJdaI0v3IN1+XXSkGLAKkCCKe0mK
	OL/HaEOqYFsUIgg/08boxoXJVsrbX3cJmbwmLPCq5K3NIbkfkoShS/Mh
X-Gm-Gg: ASbGnctBFpVbsUy+AhDSSGR2TwqFRtEdwb+tOaIjDJLtEbsO3BkvrDhIMzMSou/sxPW
	c5r+GPMpPAlprAUhp7XJ1Wxob1cpNNzJyPGBwkxX3LC7LZkoEb6Au9BRMlLEKgaLeysa1+5muoI
	PS51ND+U5J0748MobvlXJ0diM0OO0GFnoVDJgxfPwUw96PzX/6AOVkebU3lBRUMKM4O4FxI0lB8
	uDBmjN+r85UKf39t6n5iZQ6T4wXIDpnwV1ne5Q9fxGgBnohcT6wR8vO1WUwnsILSCsFab1DCwbl
	T70pWnkTe9E3sHI3NEM6xkjcSJn3AGfTouNDSQu+SM84EZrpMmbHcjqLOJKgylnKG8+Ha4lIu0I
	aO+Ttq2z/yvk7Z0k177WZgr5oR6HpGM+Xd2BTQwBR0QDEUIJJQ3zvvpQECa6uebbOV1J+IcdXvA
	Cfe8fYhETCvBP0XEid9ti/oitC7g==
X-Google-Smtp-Source: AGHT+IExXZt7YE3nF+952Md7MiVvxMbDW7G+yswwYtoDXLwvootnd7yuttY35MGv7RVbIjqP5duRMQ==
X-Received: by 2002:a05:7022:670e:b0:11b:a73b:233b with SMTP id a92af1059eb24-11cb68354b6mr8088695c88.28.1764318767897;
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:47 -0800 (PST)
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
	starzhangzsd@gmail.com,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 02/12] block: prevent race condition on bi_status in __bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:09 +0800
Message-Id: <20251128083219.2332407-3-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 55c2c1a0020..aa43435c15f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -313,9 +313,12 @@ EXPORT_SYMBOL(bio_reset);
 static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
+	blk_status_t *status = &parent->bi_status;
+	blk_status_t new_status = bio->bi_status;
+
+	if (new_status != BLK_STS_OK)
+		cmpxchg(status, BLK_STS_OK, new_status);
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1


