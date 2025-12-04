Return-Path: <linux-bcache+bounces-1328-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DA10FCA232D
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 03:49:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FF6430378BD
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 02:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430B42FD662;
	Thu,  4 Dec 2025 02:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XnTVzxer"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25AE2FB0A3
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 02:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764816504; cv=none; b=lNeJ99DTnIrLF9ukvA9Pw/vr2zQSr9r4x8fYYb/Y1jYtIgs/I+XkiqUs4MN0RiO5sfvhJZVVTNOS/3SqxlkVC3TLsXz6D/VMwcXoiWFNAJA1gkQQLbRUqcz0KK+A7gJeBPH0BtqqczBbiIa3E5uDqHRaqc27Z1IIrZLigRWVigs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764816504; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UKQYnhzUD/KuwFTTGzVa4OzNw9B6wTyIhWaGWNm7KBjZyUkPedqBufo0EC27XcBSWBMhSBG5PxPdBNk1J7KeW11DyNm9fk+zYs5ThWT0dhtpkbppx6iLBja/nGqq9tHcjtaB6HPDnyM/0G21tog/0AoM11Nan9JcuOpyjtvODs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XnTVzxer; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so426991b3a.0
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2025 18:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764816498; x=1765421298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=XnTVzxergD/1zjfx76F9BSZzo9o/r0VE4vDIgGpatGyKsylXlNTt8/JfEdgckLk/yr
         hkAFbZxasrhonowS2EDvdXciSVHsxS1pEeEoP8/jsN6c7EPCX8LgKfwHQRs00HoSy2lW
         l12VjGbzqTnuNwEfsX86Syi2dqwsBOwXG2OkPQ2C7m0Ym3ecytJMD5lRVQzeeZM6WiDF
         YZ3I4Jkqy2+DnLqyB2X1lej4eHSaRDqc1WxWgmdHns7VwFDY5nktnDDFdGLEaN3S2uln
         pQUl2mHUkCIasI1iUL6cJgi0HACsN38Yqbt/y36jBJ8IlOtC91rjigv9uWygK4qKoKyr
         nj9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764816498; x=1765421298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=WST8symrC1Yqw9lHg0s9elvfDl4QWcRlNewQtFxEHyk/XShRiaEBXY6OfeYI+PiKjf
         Ea/N5ENKnes1rA9hdev3a/JFkSY0wq19I18IjSY5lJ8mAcbzdUfM7PDvH4kflO5uyXKw
         hc7ndSQtI7IjAhwTaLoBc6p6NF2HgV2fUs2U2rj8w2sc6/mUteJ9HJ2GfOLaAesxlzX9
         WzYwWJxIZV5i1FUutNhPU3y2Dq35UDQikKuHDeURjGwhUn8j4RiFppJePaLUKr7/OCiI
         tloH9J10zt99BiJpzksaEFZNJqmZxkeAC072AB88NY69D5QIrSc+oyr03WU2lpus0U0d
         iaBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWd7f4JId9CcLde+N6F7PK5DsjmuBTGh9a2mYNYqQrBien66vEY0VbKz0yFXkM+CoW6RqoFIsLLk8iOz0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvGrUvqsY584U4h8FjHVbmw4Acxsy7TIjCXuoI3PFAy346FFJQ
	ZDXE8b9VAK+3EPW/xG8te8v+H6YDt64ebIAs1rdMsMsP4GrIE5U4jbCA
X-Gm-Gg: ASbGnctvfWhNOrTad+W/UfkbqAP03waDi3Z735SJgNxoSqlc6XFoNHIrIdF1jSpHSgF
	CTlAMJZ1aub8YzsofsRNWQfFM12E0eoZlHOID7dPGj+fb4qavpODrdAuPWRG9M3GPVQR8JQbvm1
	xfIHsF2Tf/YZEKIn1VmijXUnDZfH0EAkyDMBYVWcMbkRFYNBWByfhpbeyUEihkCwqq23E5AGtG9
	Jh83dFu+bCj/pi6XLBbJoezTHcZOag/2NUje28k+Q9CGKCIrf53TCQlWa9jixz4eOHwg5O+AFRW
	/vDHbsLV0TEiOou2QWNcMCYPVGFBiHEmm2g+I65IlT02Wu+JeQFz+keaFYagTokvSkv5VvMj1iH
	tdSWeLOK6A5vDQ+D27OzTHqMl4hd6c0C5+nWwlFcKs9pq735Fmdc1Txs+pAXc1/WEoZR5udxnii
	vXN9IT7VJ9ZSSDvrO+/ka13QODfQ==
X-Google-Smtp-Source: AGHT+IEThN9cBQeL3cXuDOIc1+uCaHf9ep2wDNPFjuh/TeOr5B3FR/bA1QanG4XfS+l/fJbBKZDCrQ==
X-Received: by 2002:a05:7022:4595:b0:11d:f441:6c9b with SMTP id a92af1059eb24-11df4417192mr2091918c88.22.1764816497778;
        Wed, 03 Dec 2025 18:48:17 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm1838847c88.5.2025.12.03.18.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 18:48:17 -0800 (PST)
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
Subject: [PATCH v5 1/3] bcache: fix improper use of bi_end_io
Date: Thu,  4 Dec 2025 10:47:46 +0800
Message-Id: <20251204024748.3052502-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251204024748.3052502-1-zhangshida@kylinos.cn>
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
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


