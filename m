Return-Path: <linux-bcache+bounces-1313-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D24A7C9651F
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 49D4D34444C
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2602FFDDE;
	Mon,  1 Dec 2025 09:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OpcWBsdP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC412FF675
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579910; cv=none; b=kbU0Atq0A0HQVPy+diI5OsC7F7aGzM0GaNtDT5UbDAGEc/qlQAbeCfhBQTrvE90lVQL6+l7/+d/vmUSffYBH0f4NKblINhbf22LzKAM8se9cz3qLm4JJ7kkQ9EoPOHhOD0DG5Q1LX/3OAcoH/EjAKFVriEpYsyWyWJ35b+doCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579910; c=relaxed/simple;
	bh=aYxMtN+DE9oP1VlQcVa69Tb9BdLadbrZwyizizgybXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Dq6sz+HWdtuO3TeZvx2IDjUIwjcPf/MrTSzFOVIRgmYL4C5u0O1S/sgbInb/YLRQJGIQDd4BbsIcq7vxw1TEx8n6I3zwSX/u5I5VvMhaaZNwpwyaJtejpqbcKrSkRIyASUIlJI35Yu0Ud5GkKeHoWtLXm+dKh1ti4+iw0MKUXnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OpcWBsdP; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bc274b8ab7dso2911723a12.3
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 01:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579908; x=1765184708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyEEQJEWsLRxIUx0Z9OWCeFI3uMaF2jR+E58v4Ivl7s=;
        b=OpcWBsdPV1blfQTxLrrgkv7mt972nHHZPujPQeiAmtBgaDD9lSffyrUFaL7H00erFY
         w6b8OEIFvGc5QeDB1cqZOxYQ0mEIl5W3OH4/kGrW+P/8WlPqCR2N2zLYVZnYp2rUPxo5
         MbjaeieBdZzU3XQwOrtVQPunCD05y2jtFmVfQs9uru8kQQOpbP/xGJxLzRfDwBtV09TR
         fNt2zis8X7m5gqhODtdMm/Nk14kS6T/6t9jyWN7xg82dDql3k2Bj1CA4rfbq7SbXiKIL
         z/Z+AOSxx/SwbMtyJxx71gN5J5QnDMNr1fCabzBLsygp0waTCGyU28764Oc2uyLNhwzR
         teRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579908; x=1765184708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kyEEQJEWsLRxIUx0Z9OWCeFI3uMaF2jR+E58v4Ivl7s=;
        b=xN83tO0lUKQT+wV1zpIz+RMTKJ523mo8tGJ8QYMULLlTKQ1pp1OIxXcWh0R+f7C8f/
         N4cB4uAE7DCZFLtAaxMbhMsM1NL+Vu2PNGvpASMS9Lf+beaEfRoLymj/waXODfdNBnSg
         Pwl+xRVkRaXkPYhcQ+FpsVWq47B3/4KJ9rlEsjA+iIoK/BBwmEswe2d+B4zJrq8eBCyw
         I2r/UjiclAnOxj+GC/QU+uQd1Gt6C2nFSh8xQ6MIRqwJZ90vTxOvLq28Hg315t9+6kZ2
         oe33aOQEMioNlqUHQgJG7b1FBjX2t2KzpXp2vcQ/tteAdawroNK2UTHYpEM+Y1jVMWG3
         9lJA==
X-Forwarded-Encrypted: i=1; AJvYcCWgqpyb4T/MyQz5O7scypXc7ZruSU9AM7e2pGzE4266Kpcg6+Q+NGzZ5mfpjQeBaTV7Wd5XYh3YECKOC/Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt9BE8YtyZcjHJFUb5EcYtzNCe4OhHdoU5wTV3Ee8wXiIxxcse
	SFTzNNTB608wQqcNVZfBZ0uJm1NFr5Md/SdG+rYdfyvqCcGnlZOEv1iD
X-Gm-Gg: ASbGncsmM9jWXOdIJgkT8SMnVDvQb4GRiR/yK02dQrnIPwxBsXjYoItw9qIiq/xuoQC
	keTTdxaxg9qCsLfTWcIjD1+4D9Af+TWjerhnAKJvSTJsT4B3rohx//tMXaCQITdSnPCMySrbJFA
	EDTVFET1P8Jya6UxItB2w9xf0xWubZD4ih/Mi8y86W1A1Rvh8UDExOFBBLNjIm4pUYc4hILK+M6
	NstgYOa+Lw3jaO8VW94VW5mdgNFleoL6TjUeIpk0BbMD0zRdu458R7r7/w6mKA53RgDSKLE307S
	HudlKZctGdB+EKfvoCAp/g4F72siGRKQzffS5UXfNSC+hNTV9OF2HkK89jpdfS1/6RiQtyuY0yb
	tNWpBI5RZLc5BEAB8TU4I1rwcKhXfVVe0yMaFCMEO2MI3dkd8+/c0AU4qoUUYhITOMC3JBn4O1X
	NV4bYNPeJ8QcMAUD1zcMib2ZaAbQ==
X-Google-Smtp-Source: AGHT+IERKCYKXvZ6dTL/bPTF2aHnk3Job6CGRSNu/ZdXHTkTIUuDU/0EXZprXpLJTdUnmnyIDS++sg==
X-Received: by 2002:a05:7300:dc0d:b0:2a7:3eee:df10 with SMTP id 5a478bee46e88-2a73eef4cc5mr23118540eec.27.1764579907713;
        Mon, 01 Dec 2025 01:05:07 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm54908307c88.0.2025.12.01.01.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:05:07 -0800 (PST)
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
Subject: [PATCH v4 3/3] block: prevent race condition on bi_status in __bio_chain_endio
Date: Mon,  1 Dec 2025 17:04:42 +0800
Message-Id: <20251201090442.2707362-4-zhangshida@kylinos.cn>
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

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1b5e4577f4c..097c1cd2054 100644
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


