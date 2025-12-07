Return-Path: <linux-bcache+bounces-1345-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB8ACAB430
	for <lists+linux-bcache@lfdr.de>; Sun, 07 Dec 2025 13:22:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3229630074A3
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Dec 2025 12:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28872EB5A1;
	Sun,  7 Dec 2025 12:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T20n3oaE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1B32609EE
	for <linux-bcache@vger.kernel.org>; Sun,  7 Dec 2025 12:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765110122; cv=none; b=hpn5tpov+kM1YcTE2HuZONG7p/DBMfcIQNXfqHW2Q8rXRE+YOinUlZZk9dCSnks/KX7pIrqYH8nF0FTkMwrtV+6LjdTz5X4DqQEf1ullh14ZyklNAfO0/g/SkpgGlD8zG2U5wxrMSlhPdiz1eHIliesN1SVVESvRDPzvkoAPIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765110122; c=relaxed/simple;
	bh=w8eGtVtlolLagnlYNt5x+XC8+sk1v+JVwx6mfbCwbOg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SfHnwDS7aX0qafSrVv99MkDFfYP5qrlWhE+7GOzhKv9MkSm440HnoaMOB+lblpSzsVESqc3ilNtr8ZhYszsLYd1adFJPPevldg4DXnzIEpsmRTbPc18poCPcKRdeWBes5iCrUXjYbW458YudQMuW+ju9bd5vlZsNkBOPNv0whPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T20n3oaE; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2953ad5517dso34515655ad.0
        for <linux-bcache@vger.kernel.org>; Sun, 07 Dec 2025 04:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765110119; x=1765714919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=izKeaJNjYDUXJJUmuNDk2T6fLdmn69WrrecR/pMCWDY=;
        b=T20n3oaEQwzxXBknNtxQZvm1mNJm9vaJHB77antzABXhJJ0YhkOAOG7P429Hy9vUR5
         ZLlqlOXFSRZBQkKYoryHdt8D2vbaNapTHpD/zD9zR8Ff8pPf7lE4iUCcJmRAS9lkLVoY
         wpCRjAfHXwdf7r5Aq/JkAlmxKb7xQIpdjyFWPZGQOBVI3MapzGQEwUBlgDSYTeWpb6t9
         mL9JRfPMJbb9hh+i6FUA0Yj5Nv8oifhSxrYba3UW6xJRp1PCG6Uz/Gor70C2IqyKuC9C
         jUFiu7DaS2cylWolqkliroma1pEQ6g8Elv0SFLxqShmDDu0lcRv03eMxm12fQqpO0eU+
         DchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765110119; x=1765714919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=izKeaJNjYDUXJJUmuNDk2T6fLdmn69WrrecR/pMCWDY=;
        b=UCjgfHSO3rjMy0PNcHiaYaKJPdHAX6NzA/zKLT7OnB0F/ae2wyR02/64P+onQG1ZmW
         +FbqVZp3vPxNsvjd0+wuhDITpMiElzma5aJjQe4aEtgNMieXm/3UUKNQ+gt1UH3sk7CW
         T92yIOg/+ePgKvVwRGObV9mzncR9sulyAKTnRPM0zUlYtNectFrXktmuVssRO2yIM6Ks
         GYKo06UMBeCnHGFy4tTwYvAE2HFsGpqHNBH6qiDf07oz0ytpLj04vws0+q6GB3qcvDif
         2/4SanQQTyrbYHRXirwUdSdDjszMDJWmudNF40R4g5uFwa7ref5k9PdWWdUtFW3lYSSH
         xUTA==
X-Forwarded-Encrypted: i=1; AJvYcCUUAjny1dpAEhnO7Jd4fn5uF7LGR1j7XOtgGsvcUGHKzSAsxckBoLhEU1/GU+MZYIrL/0+6VNCbe3B9Pms=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp7BE7tip3aJGKEUDppgWOpJ0s4gTlSYJ75RuEcLl4Ymdqyc58
	B9/1HKbGpszp5xHXLC//9UuvzCNSSClqCdg4Kem0dLrPAvcKT7souFad
X-Gm-Gg: ASbGncuQYraZOk1VdtOQ8tOVnCWnEGOQDyJ23ra34UOYI7o61sxkKN64mryzz3/yhXd
	PgwqydYQudNM/Iv2SmsJp8kvH8cdG8oMoceUFHoi/NJ3nCcF8rd1jrdEcnj5s4t2tY4gbrbGtjk
	t0XRnHJ+1hyA6aHImB3nBDQC+hHfTeeHAwsIJ3DAYmH9tIEDK0P1yPhEUxZLiqUwqDnRAqwpcup
	GPGs7voaL9cEFeQ48X/yepElHKyX88YYhwC38NRQ6qGjesCiReww52CXbRqw4zBNg80hxqyeKY+
	Fx0Epj5LR1zvESixc/onoZxzY5ID0rsdf+TGXVIquhNrOhb0KoSw7CmVsgORa0tU8Pd+YaX/WwK
	BLPKusffXUZbYF+ZFEQCSgBztZsvg9XrR9WI3hnCqK3U2MDt095sY+3u0lljmXwpTRQ4oBMXmjQ
	A+8/HJMsK8osKubrxTkY65mLr6Gg==
X-Google-Smtp-Source: AGHT+IECvKJIBxL4NZCJGy3oY+S1k6hGdcU74QcxSoe7E6jhp3VaKBVwnJ2amzDXJrC/dyJKXDSsxg==
X-Received: by 2002:a05:7022:f89:b0:119:e55a:9c04 with SMTP id a92af1059eb24-11e032ac37dmr3497724c88.32.1765110119410;
        Sun, 07 Dec 2025 04:21:59 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm38598822c88.5.2025.12.07.04.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Dec 2025 04:21:59 -0800 (PST)
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
Subject: [PATCH v6 3/3] block: prevent race condition on bi_status in __bio_chain_endio
Date: Sun,  7 Dec 2025 20:21:26 +0800
Message-Id: <20251207122126.3518192-4-zhangshida@kylinos.cn>
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
index d236ca35271..8b4b6b4e210 100644
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


