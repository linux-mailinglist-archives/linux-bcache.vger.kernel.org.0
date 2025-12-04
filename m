Return-Path: <linux-bcache+bounces-1330-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1B30CA2363
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 03:53:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2A4B73021C49
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 02:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808593074BA;
	Thu,  4 Dec 2025 02:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1B06UWI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E902F9D85
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 02:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764816514; cv=none; b=bLe8wfRXBqtf9U8ZbAmaUmsMuThYKX0110v3YxAIjiaQxHZUhvvcVXBR6im06+8BbdNVXmJS2/FUGUgkUGuO5PZU7/8kdElQICqIzYNAsphnBGtbNajSW3ZEmD3KcJRfYeAqAxCjnc8LD6SBCYHIN/1g9K+e+qRdEohj8qn9FDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764816514; c=relaxed/simple;
	bh=GWGqYe6NZTrI9deOI6ejOoQBWm5NR0OgoP9ZCzjXKGw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kCjtS2MqcvyF1pSGPSQHSSpelZDQGZyQTjwsNxPV17+1TD2wDMkDWs8Nyhyy9S1ZM+lRTiSOcmd2HvNvNSxXAEI0qYYo/69McWfuVfHujW/HojzMt7Q4OT8ktVPXeqLJlYQaTHD+NGk0B1bfXiwJQENNbie/2lF2LDFgzK9kpsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1B06UWI; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29d7b019e0eso5538625ad.2
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2025 18:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764816507; x=1765421307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODLAjaeZWmKKDwhHXqzdB6DoouDdnHDHsOcQ2a6RqDY=;
        b=m1B06UWIUHYuAmSdR3uhDTaDpbqxedM8WF6af2dRS9/R62CHeg01oFYuFoxvDgsuq7
         voBeipjgYzcV40KTCF2Qh7Syy29iTSkZHzs1SdGFmGMsusQ/IFqOXEoWLcPrgUWm4T9i
         A+92ZsFyniEPHedFbSJAR7OpqocbbqByi77fO1hVH9ey5zhVNLd+e9olloTkCkl8gb+9
         BmBSlKtjmCQCXJQn3Xw5lBFcFdi9jNzJWJH3N3WnHgjoDI4KBfmXfcaN1nxVMvESiRr0
         oGh6xuVih+AXtKIJIf47k4v7UHJqksZT33MwYKA6V2bcRRxdJ9L2Rhxd8yb8p7+IVVfx
         Kd+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764816507; x=1765421307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ODLAjaeZWmKKDwhHXqzdB6DoouDdnHDHsOcQ2a6RqDY=;
        b=mzQ59Fc1sMGOkKSLG7HVjKy5bK4Td+Q7y4XP9sRoYoOGb4JZck7Uf1hN+1cn0VDPC6
         +utpvmFkDHQw1DWEwkeQb176O5lu3Aeyomk3jnDrXoJNyjLkqdJETJQPuaPZSZskp3TP
         +4hv4iZfqynvZ2ZMdIYO+Vc7ND0eNPQbrRRm27U+N8bQdzUZERVdWaUWlNAkJ5GtkXmg
         6BSF4bYkrWp3XFCUkmYLIJec3FBoD7rZ8v/XFeBE8scRLfosizJfcQNCLBz3g6crcsMd
         K9pq9DxRxKpZsdo3rPbGXBZgSK8+im0+mj26f2/V/dMYRc/rFJbGjluPTPO61epQeSMu
         XNhA==
X-Forwarded-Encrypted: i=1; AJvYcCUnhqpASY3j4UjJDznwCQyn+KXmRsHWn3lSLiXRuhHNZZJEjBMTQxI8RkK9x+HcEyZeOiQaMz2PWdotiU4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb7xP4HsEafXGqOjQH6KR9gk/JyA6nVwhSUe/dCGgPugXcHqBj
	/J3psaaqQ3xOOp90GxOkuu4Ac+qPs/9zD47xCCn7d2MKX0/V2kwqxkta
X-Gm-Gg: ASbGncvhVnbe+dzbz8Ev1v6AvM/SAXS1ByUa/0Yl3Wv74583LQWIlZ2NIMt8XSvDH7h
	lbQrFYuwNIS6NEDD9ZNJ2On+pUVJc8x+02RV8tlgv+nS1rBJMlXuEkiPaeZ1TpjjjK+qm8Cs4em
	2LEZielT5Mv0CPY5t3dI0eTW+kPtcD4lxctI97oOy6K+LyqiixjgenzWPBVnvMo7vawdfGeZvu1
	cH35gtkGhj2CHB32y6RlYerYV+B+o51uejjn+XdqKENbdnC9UDn0xdWcWWLy6ZRAOj1MpdYzzmC
	ARzBZ/+USRWLGpVjv/9wR2CiCpL7zEfndgdHdBuZzOBKwGyO2TQyGAUmq5w3UiP6TsdqbXzkiWg
	gTGgF8UBnqycoEJId5fp02HlRnygb9U5OdmsEYZjZJrY0UQuZiuLAESex9p3Boqf/OlbT1iOOo7
	90o/NCauSZ4UmdJhHS2fcdAPnwCQ==
X-Google-Smtp-Source: AGHT+IGM6SlIysHbulWdQG8xyoxU4IAcs1YhWt2VJRjAfRnb3Xvrgep+D+UgkBMDQdlNnkJeXkWtsQ==
X-Received: by 2002:a05:7022:63aa:b0:11d:f464:38b3 with SMTP id a92af1059eb24-11df4643926mr2045006c88.2.1764816506518;
        Wed, 03 Dec 2025 18:48:26 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm1838847c88.5.2025.12.03.18.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 18:48:26 -0800 (PST)
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
Subject: [PATCH v5 3/3] block: prevent race condition on bi_status in __bio_chain_endio
Date: Thu,  4 Dec 2025 10:47:48 +0800
Message-Id: <20251204024748.3052502-4-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

If __bio_chain_endio() is called concurrently from multiple threads
accessing the same parent bio, it should use WRITE_ONCE()/READ_ONCE()
to access parent->bi_status and avoid data races.

On x86 and ARM, these macros compile to the same instruction as a
normal write, but they may be required on other architectures to
prevent tearing, and to ensure the compiler does not add or remove
memory accesses under the assumption that the values are not accessed
concurrently.

Adopting a cmpxchg approach, as used in other code paths, resolves all
these issues, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index cfb751dfcf5..51b57f9d8bd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
+	if (bio->bi_status)
+		cmpxchg(&parent->bi_status, 0, bio->bi_status);
+
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1


