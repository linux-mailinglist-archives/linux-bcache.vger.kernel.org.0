Return-Path: <linux-bcache+bounces-1275-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C0CEC91391
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:37:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A18B33ADF8E
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA232FF150;
	Fri, 28 Nov 2025 08:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjmpIAyJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193FC2FE563
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318812; cv=none; b=DTcQ9Lm1qsNBm1IghYAeYsVcdVRkssyFu6Kb7cn37QeC8Cn176lcGtu4VhpNiflVVGOu61mkfG5NOl0KTmB4DkcJ6zJl7Bfa2/QYxvy11P8o95ViEa4y8ELQjA3+sI/FrhW5qhXs5ACD1LiFzCv4BRV4tNfkZJ3Mv8QAz8Gboew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318812; c=relaxed/simple;
	bh=TbxNohFMmSKnHTWH+mnyMfPFRdWdcWW/LS3/VsufZdc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N/YEf7GkGfrwDMgxq4YaL0Mp6fhqfMtP5V7MpTyEyTYTOb7bFbGe9DJYPKbTdj6j0zA8T/WSnCI9l84mi/Xx5WuiL4OyenKoG7SikrWQLal4tcoJFN6wwlpXMsgTP1w8DZmEPNtLeUwh4zy5tYxlw3Zu7Xob7O7U3TPC2H9uU7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AjmpIAyJ; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bdde8f1814fso1401251a12.2
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318808; x=1764923608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=AjmpIAyJf6JuyIrhAGiNid6XUAa4g4RrZwnHclHp/pVWuzH1VLVvZppOCoNcecZmRJ
         TsroiT53VAQOILzAKA/KT9wWusG74M9XHGbLDWt9nWP5Ig7woXGHCDNlIisELR81PsjM
         Gj1gSPdcetRXXQOL5NzyCj2+NiUSYFYbhosk8SNnwkX1mSVNFWcpBxxhZDts2K+D6eiy
         qBcXBeSo4t2Bb2D74uAI9RGN+1hwtAaIr89QCc9QNUnf5EF1ZsEJCCrBHz98uJ9cM/qA
         YaESTKuRxQR7U4wZ/SDPPSNnnICcG0SsaBX0ZTDgsGddCJFYqBHmxOsLbs3KuYOtZYGx
         rQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318808; x=1764923608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jJti1W24hnwF4OFg7cS4jWnw0eZv9xglyyGrmFluATQ=;
        b=qWKK3Ex+hosWpkY3Czz/we2snVVGzsOS3QNZrfD2j5g6NyG0gkT/tjXoFkwSWVMsHM
         5nLEI7RiSvFEW32PtvZey3Nl8dC8lgWu1W2QyPxPPh4leWfi7ZM2JT59mEGLAZZxS1Tv
         /0tV30MjM30yfQYwZQlRMU1Kb/+N0sj3eCjlGDMiLGvsitF0aLOIDF8vYjRDDzylcwd8
         OjgY6c6lqn45Zecq9UA4YJUTCzVfqqsxGZqZAetoYpcpfzzBaH75gDqWsVYBLF1kzS5a
         nX23xta6TJ5RgDlWTt76d5J4KmHO+rm9b+KxOIt0nJc9AnKF5tqXqADyGToRyXzY//RM
         utpw==
X-Forwarded-Encrypted: i=1; AJvYcCX8ZQt6FFxltEfJVfx8lFG97Z1tG716y6yjGhU8ZOAMtgKytErGhvwmU+C9gQx8TXirIsC7eSvWiLtKejk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxipsjsu1vKGYtrataEaTI9VqNNDnWeBVxIAhe27baaR5uzFVrV
	RiAtZXtvpxg2OvLQMiA7P2HXsqHAez4j0cC+98yT7pXku5m1YK/Tihm+
X-Gm-Gg: ASbGncvIR5qb+XymEk3+nenPhHJCtp1R16SKBx+n/VkkqNLLgj4hrGwzE8i9H/iLXQG
	/hOJStfNt0Zwnja/7szKdr14UudlxSmSNJ9Yegvd/aH6eEGcM/cGWIUxQzj2OaL84gKtlncuAvx
	+8Rn0w+1XrIrtS+P8o5PqAkBSSmjKdb8px5MsPiVMjaOyumT24mTCS3koD2z8qwu3R4pfvaW0nF
	8MBdZ1d2iirTpwNKdXEcZ/nZ9nam7pYsJSlwYau1Bi0u/ZkN7ridcUFBUTDzSlUB4irmauwBbTM
	lU//OWcOlexkpHBMBcWaA/T7NAUxyBBTPVhSy4Y2xt3pDgmlR3UCdNQ5b2fSQGoI1Uc4shZyt/A
	9WeWyCVpVf+Lkgt/0N35GSxbWDrhsbo6LMygOu1r1PRYLNpyQy1HdwM8TAh6cZLNVoNrvcXPWnk
	MrBRVyy/DzYD5Q9P1pPPYvv8XY0L0fxuFBiJh2
X-Google-Smtp-Source: AGHT+IHDsMToqUoj0PcNSA32TYDuHE8zhBuDir1BrYt+w5Y/wAZYCWlUzMNg1Dgih3T9wVkLcbd8Tg==
X-Received: by 2002:a05:693c:2488:b0:2a4:3593:6464 with SMTP id 5a478bee46e88-2a71929687fmr16240699eec.20.1764318807899;
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:27 -0800 (PST)
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
Subject: [PATCH v2 10/12] zram: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:17 +0800
Message-Id: <20251128083219.2332407-11-zhangshida@kylinos.cn>
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


