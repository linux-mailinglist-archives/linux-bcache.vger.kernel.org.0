Return-Path: <linux-bcache+bounces-1290-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C0CCC93A2E
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 34F3C34580C
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:01:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFDD26E161;
	Sat, 29 Nov 2025 09:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRn9SGir"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE45F274B51
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406902; cv=none; b=sQvPvIkJpvKEESBB1E8u5JqPn7znhd6lqUQv1BQjROv94kvor6K9SxlwSCTguVdzABuBsFa8j+tUFl3eZ075JQR0GVUyAX7Pm8ofKJDsWnza6D2FgHi3CMFsXGn1hos3vMCY4mhba7NAy+ksTrL7FnJEP803oTslr6HL6JwKp8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406902; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EboZp8lCOqUSw5VTqMHEO77u9lA+mIHjih6QuILcCcWvk6REbwqVGl+/F+a/ArCFOnXeRO3p/HphkXSyGNV+Z0WxNOT3VUfNGi3VoPiKGv3/nfiUXrQ1w8+fUg7LuQrEheTs+QH+dYVZ5zym0owWbAEHrnV7BIW16bZJvJ6O3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRn9SGir; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7ba55660769so2181588b3a.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406900; x=1765011700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=KRn9SGir2pBgh1mKiywJ7/hOt0zGejR1vm2MBrEsl9f98GNlgZ/GLGwsccVj/GsjQX
         WJaVuzCpvoMb/UJx1OOcLfeoU1A/jDTVXGHxrowGhucL/qEMCFP1gcKC54LawCmjQwvH
         4LehKy4Y1P+381T+jI5VC/xbtgUkSPJ8vWy2Ve0ciJcUgnMJA+TeWj72zRDM22mSCA3+
         HaVLwYO7KEArcs+UnmlxLk2MfYaOC13SfWk+mkQ4qx3hXXJpFEIUY1uGw5HMKKQv2vIJ
         hlgUAzJiWWPKKU6SZX/HM3Tc2Mts55PI6bwy4Ie6e3qKFW36wyCvXBwAwa2vzNj5MqbY
         FzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406900; x=1765011700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=RoAUTF8nJCqjvmKMwEn9jc1VXz2vG5cajsvNbCZytM6oCk1CULMkEIAzBL+I03KUqS
         UFPYeqTh1oMZIFtIPl7+YUGIqMxD3w6cycU8Y6d0V/uoJiuzGnOPRlqahYqfy6jD1mPC
         AhkLb5jODO+hr0o3qjft/aHJDs134ytSxCkRkOY3HNt5K+YQ+yxOK5NOa8TyWuhw0Abt
         BdwZfrX2xL8UGQVF82XHqPaTmjcNuPjhL3S1rFKhGQ+GMFaYMwD7owcBHgpknp5q3je8
         tq6qq60cgHkxZkxZu3VzX1uBxsRQq2UC2Cwu0JUI5EvdP3mRBOS3yrfbgRO/+ONqBbWD
         97+A==
X-Forwarded-Encrypted: i=1; AJvYcCVnL16WnWluI1vZR0Qk/JafP09zOtb2sFRis2VXkYD+XUOLfTBvK0PF5Wg0Q0dRjvr4B+bjvRWB3L1p8UM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Jq6DQkTsz9UmIbOu7d14JE96Bj9Ta7WZYjcG/SpokPGW6KUR
	96A6TFEVrGuTna+EyEA+PZZ+y/hOfFsPDet9oMiWaJIq8SMGlpli27Ha
X-Gm-Gg: ASbGnctu5mcFE+YUjrA7g19a+uXpiSsvLnUL3p47Q12Mhkm2wo/T8+TQ2Sy2oRtw5ZB
	+Y5KUiEas/yAIGbSDsA21xsS5mg/QdUfqGZfYw6CGZ4KG3RD0YpHHyWga9WBA5rVWQPX63QcbPI
	1AHV8j+1QEI49/RsUBfqG7Tsdg0dSO0qlf5Ps8IB3EeJCigbws1TGA31bDKlhznaD4+a+5gtO3V
	8toHfngLO9LzWF9Eo2zKhCQgqQD1OH01CVnpgzS4FviksfRlerD2p7JA4aSeglO7TdMXRnffvc3
	uRdp9l5uZHpr/HQxDkq1r2/Cbga0euR3dUfR2Pv3c7s/jVA+W3qnmaztIAnu04U74xTorysQiDO
	zY4QKN954rFpYsw2Vz9edY1ZSPrxA0FSV5JP4lA2ygev3hulP86Tl5t8hGipQ+y15jbjX9OkHGY
	VaozTTaKixXll2pHYwXP7b3Tn5pzxk+81b+PYZ
X-Google-Smtp-Source: AGHT+IF9fpUjxnsoJ856uo76C4AbEbv+isvtq3QMxPEeI8s0lui+ms4Diwary4B5eKv1gtl0O4hKMQ==
X-Received: by 2002:a05:7022:ec0d:b0:11b:9386:825b with SMTP id a92af1059eb24-11dc87b150cmr7316305c88.48.1764406900072;
        Sat, 29 Nov 2025 01:01:40 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:39 -0800 (PST)
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
Subject: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
Date: Sat, 29 Nov 2025 17:01:14 +0800
Message-Id: <20251129090122.2457896-2-zhangshida@kylinos.cn>
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


