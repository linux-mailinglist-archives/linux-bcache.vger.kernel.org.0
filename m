Return-Path: <linux-bcache+bounces-1297-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 85599C93A94
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 68D5534914E
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436A3279DB7;
	Sat, 29 Nov 2025 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abasbWaq"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF93E2882B7
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406935; cv=none; b=ArQ8TjHaE+CxE9l+/xx6pWSFUKIYqo3StH/DZL7Y5bUIgu5zyEPCHB1fGHMJK4viy3w4kZCpwgakzF7vm5G0DKR0GW6WIh4h845K5vPmmmiyjEbotBj/TqfzmkYE11H4uoh2p4xlgu1nXCs2HsuQzyJNivb6lj/xFRIK4UwolWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406935; c=relaxed/simple;
	bh=TbxNohFMmSKnHTWH+mnyMfPFRdWdcWW/LS3/VsufZdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ER1tGsVbbMoSxa/nzLxdPQBW5rzdbVsH2knnpmURwjbfPuoXSR1flbQxDBW/3yl86mW9ApXg4rxvK3Mrfca9kDCRiCERBcAYgR4MgMA58Js9ul+7MVzXZ8VxDP07SmJLRTPcE6mcK2BUKT7xR6ruXnYaAjmEPdN9CKikS3+J2Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=abasbWaq; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bd1b0e2c1eeso2035435a12.0
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406933; x=1765011733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=abasbWaqd2EQERmVlO4+ix+ajwq4zsnMGSqN0AiBTP/gJ07Tfm06jAFcO97v9VmLvq
         2zub/alv8m+QU99JxygnzsSvlBqLcnvPzmaEEVtofoaQFB3jwxu6Ll3W2IXlWVopXnQc
         Pn3EV3vbwgxxtRqMiQpaDA3dR6TwFtmjPdyui0q2WWwkiLg6cP3j6K7nlQzGzgaejRoI
         aNvzNqaO3kk3ZUIOnUE0htZAq3vokOzxgl6U7LuI9oSKoXvAC78ng7k6uIANfEekogbq
         W4DIW8SXZWtA6HvnzHQiJS7GejvH99MZ9VGNpqiKqAadXcnQN6NXFuhC3Tgz0BKKCS9b
         2x0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406933; x=1765011733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=BbL4EUUM0nmvVBvtGy5xm80f9y+YQOKboDM1wzCadC1XdNSbY5QPISfdl+KvEMHasQ
         wNII7TUlfii0GoNR6w4cxPbixcIxm3DBE3HFQBa+YX+f5VEzW6l+uhZyKmhoFWozeXTT
         /OvQzhY4raa4nesNHFIzKzgUG3hfzKn90UQbntzoMh3BFAEPR6s5Pz1qC4n5QH/aKV/t
         XukZ9qkcO+odNdp79cPsBmSQYsdDcY7+g55ReIj69UNCnzBFmzwlAed6GvH/iWqHHUZq
         0q5ModuQFdQsZGJpFPLyuwV/rw4zjDVJDrlKrovTEioIIjQBltzFvC6ArGsby+5JviM1
         FOTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKkO/sVpHjvZGaguYMmyICXzT6GuejvW0ZdewlLxtXTjk0eZzArx4gYBEuIIVUY3iqlWy5HZEglIN4Rdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL/844El7NIF7u3d/6TJY/tV9GtGORG6OO3WiPwH0dnOGPGk6T
	wP3KEsS/ioB/yQHIKNX13iTwZo81VYMt8c6wBL2NOS0CkTIPWsFQ2Jio
X-Gm-Gg: ASbGncu05nSOqk1gn+E2nYTXqjETJQMXg6SlarRCxn0pvAS4eDY9T+YsAuNcBhBdYP1
	QrvntLg53HgeI926AuzEfnmoqx/MYcCkSWrJRWkbEHfEyunYhCJ8UDZIscR51jlWLfiqObvjAoC
	964gGlyaU/FfP4ae9W69CkXvsPchMr4dKFH/m6vO9Q9DvCk2Fu8kxtLm7iEp7hCzGRT+D4BQXfu
	NflLH843ib+7/l5lkwMNT0XGB9DJLztQ+QVmWpsu/qHKB8jys5D0Y7k9SkDKAtTi+qHMhmZfPwS
	5aeWJYd9rU98shXw5pobzTZ2otD60ZTWNW8Njg/x/ZchnZP0dt4NCnYBedj0B1W6LE4mkOmNCPU
	tTVlvdQ86h7WXudK4W0xQMTIKYnjstiP/D5Ec8JtdOag3lBT1u60WMoqoI7bKfezq/QKQxX+Ywq
	r47g+AIVc71oNxSoI8vAlD5+69+w==
X-Google-Smtp-Source: AGHT+IFlPlVYDb7yoZVR+mp1/g2QkqJgugDSidMl3HlYfTA53/2piBoQC1SYt0i5BZxdW5Dqskhrig==
X-Received: by 2002:a05:7022:3c84:b0:11b:9bbe:2aac with SMTP id a92af1059eb24-11c9d863a7dmr14635218c88.40.1764406932641;
        Sat, 29 Nov 2025 01:02:12 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:12 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 8/9] zram: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:21 +0800
Message-Id: <20251129090122.2457896-9-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a4307465753..084de60ebaf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -730,8 +730,7 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
+	bio_chain_and_submit(bio, parent);
 }
 
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-- 
2.34.1


