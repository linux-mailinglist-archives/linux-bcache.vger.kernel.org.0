Return-Path: <linux-bcache+bounces-854-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E18E9A7F340
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 05:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A254A3B6DB0
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 03:34:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011AC25F98F;
	Tue,  8 Apr 2025 03:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H69c+cSw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4484125F981;
	Tue,  8 Apr 2025 03:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744083243; cv=none; b=RuFO3tLFFXmiAOti2BwKHI8h5ZSwR4FM1r4nFAnts7qtDRgaAs0dxMCTwubeoyK0eztpQaBW+6DL+zDXR0IytH4jdLP0beQgViewb+n2pmbwOS0gbr8wcSww6gG/cl4TNh0LX65YITqezh7VATayQJKwaqdk4JOnjpJDwDV3WCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744083243; c=relaxed/simple;
	bh=imYro8UTdpYAOtprQsP7qTkt/JH320aZZld/QkLjJCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnDqefDAORKbG76FUgEiMTUSeuSsV29X6RIn7uX6SPNu41nSmlYvuE2L7P8EZVxwp++X2MoMF0gKB9RTSOYq4HFC1ZOW8BGWmBEU5vJ4GXUgpWM/N8hGiTN0rELla6bXxQOMAcOd0JwJQe2247/2EP8qwyCLEGpDK6W+tTIq39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H69c+cSw; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7c5f720c717so633563185a.0;
        Mon, 07 Apr 2025 20:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744083241; x=1744688041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7jb0oaxWwuHrFion4GHXoqaHsrx3lftzE+OrY+WHKs=;
        b=H69c+cSwvinFJaW9v2qYR2fDgReaYRzbgWetJsaAYDvH9Kx1TFyH3RAsa3vyUGx67p
         xUAc7SPsYuJBheHB/gPHtfsuL3i1xGUrasHH9c/vTWx8qMCq1d168j+EA6M1e6jftjnd
         9VTYNaxsqGHL1Uf41A6q2UL50yBIUqcx5zlBJIFuBOr7lQNCq3v1RsBCYOTNU5a3uS1n
         Gy9ZerwlJli3YJGvXGNibGOzA9mg2D/ZuSZeRqxCXfYmDxCIV+9dcdcuQL7MJ4xpTUeU
         mN+8VsZTjiW26q6/EiVgSJqxgFdKYbjX0KeyNjG6ALjdjiRY4vLio+9+YTXGeugMJjsC
         gDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744083241; x=1744688041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7jb0oaxWwuHrFion4GHXoqaHsrx3lftzE+OrY+WHKs=;
        b=coSqZX3fJfVgP8UgAe+Sx1zwS3EpmWShzvq+c16SoXs37vIGnbzdSzpIK2b9ZApI5I
         XTIz0GKTnbZZa/EIEPeV+9ImMHXNx6kStOCIJMg4HhB9riPySDIagcsmy65k6uCb2ygz
         YsjjPlSEcIvyg0+xwhN2v6Z7UaLkIh5KKLkbkdxUU7TGAiCS6Rd7t7UUomEVUFA8sVgc
         gptLemfIxngYAplE4JqK8Ix6tBeVPeqgCbHSrSKx7NwreNL6zD25EB+LMhsa1e6i1VX3
         7cR+YaWb5IGJCOJY2NUPVT01zOxZJkA192ArJF7nbNlLZN3fsxltzwGV1elrLBkvrxrI
         iHrA==
X-Forwarded-Encrypted: i=1; AJvYcCUt9eDZs6BhwI22/70eCXvk8yQTtnDVi42/RSe2elGsrw3GYpOCEJF+hefxN86exWEyxdwnwr6k0BbyXCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh7cVE22PH0lAE3zgBRDrrVhKTcoG4o/lWewnY+EN61rtX1OTa
	4U3mIXW+0dlQmFs/hjL05PRCPH/tWamggWXQq3s5Qj0kyYsDDII6
X-Gm-Gg: ASbGncsyYFK+JKsEPCtaAi3mqDa94nqBBycShTQBDLcbSOXCpPpiyJMzuUYqL1avRLf
	HkKym3g/hWAb52pi7ZxbghjzhlNBIPPxIZVTrdNiV5pU03GXxP9Ni9mBthlTfoO4JsYeZrq+JPk
	ln2IfHqUmW26ubWQNu25nEsaVB9AbulNa0+RC/kO66QGQXKtX7TX3mwu/KZPu63uTzHqllbRfhP
	ZjCBb9IIYoQ5ADXwvq1GomRYkMLrT/iaaLm79eGCsIgnJQ7CLHtRQrKDU+GPj+24sLKlXSE6fR6
	eJwsvBTw9zWj+TtRi0xl5MRCjGsmHe53MDFPomv3NCuxS+gSNBKF7T2ezrI=
X-Google-Smtp-Source: AGHT+IHmwcGuxP7t1DnvwSICv3jBk4SiEIhe8/2ozWDOEBtbHw+zVeYb1Ehvr8edr5eMVImfJY0MgQ==
X-Received: by 2002:a05:620a:3189:b0:7bc:de68:e932 with SMTP id af79cd13be357-7c7940d7cadmr305690985a.23.1744083241068;
        Mon, 07 Apr 2025 20:34:01 -0700 (PDT)
Received: from theriatric.mshome.net ([73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea82d48sm692759585a.101.2025.04.07.20.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 20:34:00 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	kernelmentees@lists.linuxfoundation.org,
	gshahrouzi@gmail.com
Subject: [PATCH 2/2] bcache: Fix warnings for incorrect type in assignments
Date: Mon,  7 Apr 2025 23:33:22 -0400
Message-ID: <20250408033322.401680-3-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250408033322.401680-1-gshahrouzi@gmail.com>
References: <20250408033322.401680-1-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove unnecessary cpu_to_le16() and cpu_to_le32() conversions when
assigning values (priorities, timestamps) to native integer type
members. Prevent incorrect byte ordering for big-endian systems.

Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
---
 drivers/md/bcache/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e42f1400cea9d..c4c5ca17fb600 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -648,7 +648,7 @@ int bch_prio_write(struct cache *ca, bool wait)
 		for (b = ca->buckets + i * prios_per_bucket(ca);
 		     b < ca->buckets + ca->sb.nbuckets && d < end;
 		     b++, d++) {
-			d->prio = cpu_to_le16(b->prio);
+			d->prio = b->prio;
 			d->gen = b->gen;
 		}
 
@@ -721,7 +721,7 @@ static int prio_read(struct cache *ca, uint64_t bucket)
 			d = p->data;
 		}
 
-		b->prio = le16_to_cpu(d->prio);
+		b->prio = d->prio;
 		b->gen = b->last_gc = d->gen;
 	}
 
@@ -832,7 +832,7 @@ static void bcache_device_detach(struct bcache_device *d)
 
 		SET_UUID_FLASH_ONLY(u, 0);
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
+		u->invalidated = (u32)ktime_get_real_seconds();
 		bch_uuid_write(d->c);
 	}
 
@@ -1188,7 +1188,7 @@ void bch_cached_dev_detach(struct cached_dev *dc)
 int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 			  uint8_t *set_uuid)
 {
-	uint32_t rtime = cpu_to_le32((u32)ktime_get_real_seconds());
+	uint32_t rtime = (u32)ktime_get_real_seconds();
 	struct uuid_entry *u;
 	struct cached_dev *exist_dc, *t;
 	int ret = 0;
@@ -1230,7 +1230,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
 	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
 		memcpy(u->uuid, invalid_uuid, 16);
-		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
+		u->invalidated = (u32)ktime_get_real_seconds();
 		u = NULL;
 	}
 
@@ -1591,7 +1591,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 
 	get_random_bytes(u->uuid, 16);
 	memset(u->label, 0, 32);
-	u->first_reg = u->last_reg = cpu_to_le32((u32)ktime_get_real_seconds());
+	u->first_reg = u->last_reg = (u32)ktime_get_real_seconds();
 
 	SET_UUID_FLASH_ONLY(u, 1);
 	u->sectors = size >> 9;
-- 
2.43.0


