Return-Path: <linux-bcache+bounces-1343-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 01483CAB42D
	for <lists+linux-bcache@lfdr.de>; Sun, 07 Dec 2025 13:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6379E3007686
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Dec 2025 12:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FDB2E92A2;
	Sun,  7 Dec 2025 12:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lIps9MXg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38952EBDFB
	for <linux-bcache@vger.kernel.org>; Sun,  7 Dec 2025 12:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765110114; cv=none; b=DKTvQFV+QjSh11j9X3FK1nkeCOIEY/Mg2KZ9uEe6sPaSqxcMBKtsCQ4Z0DY8LrkNfxEsKrF3v7SFlrYGczZkrHCWiIAdR4h9N+isf8OorxPqrWA8UlBfZsMu/W1mP1VXcH5qSkTIG4dDbMTk2CqnrzmAZSVwl4tcfPdbPhq1SrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765110114; c=relaxed/simple;
	bh=54Xh/j2WhG2Ei4a1qEnIpkmDGonn8ZggrBoCMAcXO3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bQktSDH8G25FcelRs3zGtEqbUjYYaea/qP9q8Nks2DKZKetd0TCkfR+UhuEOV8TxH/CZvp/Q1UGGni7Y0SxuXGvuIF17Sa8cIECXXRez30uHFJP0IzKU+gyTVOogyhfIef5nQfPPc9EFecOmCzYFji2uJ1R+imlqlKLpgiMJrQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lIps9MXg; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29568d93e87so33314755ad.2
        for <linux-bcache@vger.kernel.org>; Sun, 07 Dec 2025 04:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765110112; x=1765714912; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/7vzy1FUoDsUfjpWUzueUpIzsuHBaOImPA4L+Mj+ZI=;
        b=lIps9MXgArmN91wavXUc49twuZy+fZdUvCItADOejMyZFcw7TxXGTVflAC0WSqz8yK
         K46EEucCKjjKQgXMDkX8wFF63Flc3R3ycovlyUIe22SSr6NrkjwFEV0JgMxzZ3umKlwp
         eyHn59khjfHUiY3+axufKMjbF0wl4fG/ZCsO0HW9THHMEYUJNEgiPJ8cTgiYglnQ+Xnw
         XREz95pgqYBZ5TSeQddJOvdqfpvKMRjN5sK8exIz0P3RBG60iI+K9Q4TREmlU+imLGQU
         +4OwGhDRhAPQ6uPKdCXeDM47Gmp8cius5zfZdEdGUNYhGikxV08seuV5GRvssIDLS3dX
         V4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765110112; x=1765714912;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i/7vzy1FUoDsUfjpWUzueUpIzsuHBaOImPA4L+Mj+ZI=;
        b=Y6UDl4yxVDjP9eAURKMh0CVkJRmFBspm5MjqZYtnLKNTCmV09elaJGsgLwcJk712ck
         D/Zc/+g0jFrLtLgjc9O4dlX8duLYl7TcUR0uoQagjE7OvS4k62xIxKOQyAwD4r0zJ+yk
         bwJ45LWwx8Fb8RqeLgMfq05N8Wx/xMrbCp+N/ZtUhGH6OH9EwRumMRNH/Utgm2qTTYX+
         dWSvfvH7PG04kIKtYnHvmV+wh3xi7Vm8ifrp+9LYwjKOulI18dbbNXzwxchTC++8amGg
         I7KGfLaa4BBpkg7N889KCiFEp8ecNUyGA32EBlw9Qi98US8c4kZqyhsoE/cIwGTVr/za
         Oq8w==
X-Forwarded-Encrypted: i=1; AJvYcCVTCYC8hrF7uO2WW1W9fQRnFu/2QrL2lEQ6CogS0mS8Tn3TI7D+vj2fRIAy/oOG6hcvf2G5iXkF9bycLVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKHWkA7F9ZTPpqY0XY2o00/z8jzzYbmDlziImV//cotkq6irEv
	KJ/+yDlWa0cLRu3S8LyVS9JgM1BGU8HlF49cfXxXyikjOnWRULlRAfan
X-Gm-Gg: ASbGncvUZf8vgp8O6qKcIfA+7dCyrv+7m9w6Y8szdOTIogBCUNsHfUmBCOEvdMItoHH
	wo0gbgqILolCbM0I6S5IKh9XicfLz8P4LgOW3oDmMB8eJYf5t8oa1DOjvuXh4vVyUp3JKeJgRM8
	JDFPA3cKB16iAK+oQu8aNF5SI8bzDET/v7if/FnXzMwBxzVbcr9FgJnV6GoP/APDDRM2dX/Nugy
	78/dicgIXe682uGyQaQq0ICvpOVS0bCElG8UwI7lzzSBy+Kkx43vlAsA3wql7J2cCda3En8so+U
	L7dz31mI18Rt4IUvrxcGeoF8zUq+shYfPYwOIEiHFhVtPhY7KN2m1Sb2h5IlRqE2twrbrHsHi08
	3QnPLqfm4xFnm6gf1C4TVdTKPyI+3yR98FW+kSlCktnTnrOL0N7S3gj/R1PZfuKmGBB9/n3tzL5
	dODh5eYLoXtp+0voJP7uQgmQYpfQ==
X-Google-Smtp-Source: AGHT+IFnUgbCbzWKaHX3DgU1C71Wvw3pYFn2ma/gYdiJLLhx9hJu0uDqdIfBQDxlroW91cHZjfSAcw==
X-Received: by 2002:a05:7022:21d:b0:11b:9d52:9102 with SMTP id a92af1059eb24-11e0315b334mr3249541c88.6.1765110111933;
        Sun, 07 Dec 2025 04:21:51 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm38598822c88.5.2025.12.07.04.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 04:21:51 -0800 (PST)
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
Subject: [PATCH v6 1/3] bcache: fix improper use of bi_end_io
Date: Sun,  7 Dec 2025 20:21:24 +0800
Message-Id: <20251207122126.3518192-2-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251207122126.3518192-1-zhangshida@kylinos.cn>
References: <20251207122126.3518192-1-zhangshida@kylinos.cn>
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


