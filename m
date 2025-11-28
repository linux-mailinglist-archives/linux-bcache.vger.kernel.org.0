Return-Path: <linux-bcache+bounces-1266-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CF7C912AC
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20A0B3AD6C5
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:33:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59EA2E9721;
	Fri, 28 Nov 2025 08:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0pYmYtI"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AA42E8B9B
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318766; cv=none; b=Ert3fz0nOOT8JU4fixBNF93nYnJqk01DqIlWTt0U/ziLoSMX3K/HZd6En+zNojWgv/yURNI1rPXtS+TgTOiYbKGiuWRtKc/529ZVqhMsK6emo2v4XLCIo9JF5MGQ7YC7ahfT1jeBpAUSyr3Ek5LfqQRFGFEwGeyn6HPH+Q9ZEsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318766; c=relaxed/simple;
	bh=nbYby2EM9de8liKCH6EPXwLAr+CXSG8jGQgCdHY1huE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fiSsEMizUNwO/szNSIvE6/9KQIulTxvPbjXwgohHtiX+YVKrUy6QxcGKPNAVQRra7UUN91FPuuj7Gqz4m+j556EEF3Qvh4knGJ8jd3zIz1vcOenFsR9Fp5QbUBxtEtl5Tg0zzxBoPuJ/jbZGAd60OcQukwt5fCLs6ISCp376Mok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0pYmYtI; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so1825600b3a.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318763; x=1764923563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=g0pYmYtIS/P7dMpQ1erDvN2bSLVnJDU7lfPJm1A2SlMQjNBQa0vNrfvHR4fXZBhpk5
         UHRMokyQSBTl0qaE3JcHHjjzO+j3PO6PZZw68b0dN4GXFSq6V9WKk82w6wWAT9R7RgJx
         Wh6GPPHmo2ZwNIyqiALQCK1pVIyYtvwQYG0de7CQmuQue6EWrwpTb1wqyydFo4rXcxLq
         Pr+zD9mGo2fPUSWhfV6YRfBEl2sspB1q7r70DKpOYneMHO9D1RsfGG9+nwBfqvatPs3q
         zb60/K0hz8NR7KTGUotMJkf8DtF0VssVC3nk19wz4i81NPAA1iiacVVw9QpzvP+yDqmA
         Dkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318763; x=1764923563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wEXNzDk3PZG7Vl6bACrm82r4Ym6fDNxq87feOMpROvE=;
        b=st3dICt/nJrzujxhvvym8WU75fhSQh/KoIVBzQcENIT9rUCSDR2y/5sVWic8r7vfMz
         X+H8/XPZz8FXS4BWgbvrPRa40uLOpqQ0N+pRt9Hl2BA/q2E3ahXCxKzOlEZYUqvlQp7l
         MWmyZAkeE+Xe6+J/E1ru+IbxGLXcjnAt2Aytk8J8srrHY9pVsl60zwJ+WrVAVJIF6EV3
         PNscQCAqxPZCXOdBXgTdMey9TY0IulXouETf4+rtekQudkhEvUZDxJwHnpSJURJN1ujL
         /a+6euaV1MGvD+lQ3cafWvwMG3ho5WNlF7bHpBEJz023VV1K9tCIFIkPLg2Nsfe7RBU4
         wBJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVxhOK+Evcb4M3aEq8GEsa5K4sPUGant0JVjmTlkJUVfyrbDfVQ92uTLqdevBRL5c9BbbMgOja8hjxCBc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxftg6FD5OtksELtnk5Hqt5N3siOummh2q4S8+xZzXcdGGgXg2B
	iToQoeG3O4o30LB7tV7Env/3GD4Q5IjZOA89UxzUrhsK5c8KRw0BKDjT
X-Gm-Gg: ASbGnctUcLk+uhnqsX+zOYfbIjbwQAGKywsxgvyC/9IN+fa8eG2MLxuhUoHQIagOWCx
	FySg9m8HkxAbFOECDBNPbugkP4w3oPchlfC1JlUe33Q7pFZrbegwaDqAN8Or7uq9rzA4vThxIOl
	LIC8gPg153C9zYgozJbSayJ2K6eCR/5ZwmJs3Q/+heR3I56Jp4pm3JJjSR5Lm9+UbZJ6GVUYnVo
	tdMS0rKg6uxol3IGLLaaOrQCCT3AFcd+t44z39wjhEpBhOzOkPJRVL9/yF/FlZZQYeZ/RBP7hYq
	bksPvc4lR8l+7ieC1WHoic/2JD73YcutH6DMhbsMM8p7PunjKaYZAKhws3W4PxCpE5ALUfho7lS
	F3lkDaUSaFFbYYc/saDO7qMG2UV5yfxxPZxcDZUuxD0h/SJctZs46yLkSNj+XQdWSlynvPVT6Zx
	ze/SjazzZTkRvQSlzTn6K/XBJHjQ==
X-Google-Smtp-Source: AGHT+IF16ld9QNCqaVETJUBsXYjs2kY4Pw4mcEH3R6jDofKcar8TG/UX/uqF2Rs9fZ+s8kH1ElEzpw==
X-Received: by 2002:a05:7022:7f1c:b0:119:e569:f615 with SMTP id a92af1059eb24-11c9d712704mr11436137c88.14.1764318762983;
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:42 -0800 (PST)
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
Subject: [PATCH v2 01/12] block: fix incorrect logic in bio_chain_endio
Date: Fri, 28 Nov 2025 16:32:08 +0800
Message-Id: <20251128083219.2332407-2-zhangshida@kylinos.cn>
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

The `__bio_chain_endio` function, which was intended to serve only as a
flag, contains faulty completion logic. When called, it decrements the
`bi_remaining` count on the *next* bio in the chain without checking its
own.

Consider a bio chain where `bi_remaining` is decremented as each bio in
the chain completes.
For example, if a chain consists of three bios (bio1 -> bio2 -> bio3)
with bi_remaining count:
1->2->2
if the bio completes in the reverse order, there will be a problem.
if bio 3 completes first, it will become:
1->2->1
then bio 2 completes:
1->1->0

Because `bi_remaining` has reached zero, the final `end_io` callback for
the entire chain is triggered, even though not all bios in the chain have
actually finished processing.

As a quick fix, removing `__bio_chain_endio` and allowing the standard
`bio_endio` to handle the completion logic should resolve this issue,
as `bio_endio` correctly manages the `bi_remaining` counter.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index b3a79285c27..55c2c1a0020 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -322,7 +322,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 
 static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(__bio_chain_endio(bio));
+	bio_endio(bio);
 }
 
 /**
-- 
2.34.1


