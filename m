Return-Path: <linux-bcache+bounces-1276-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 891F7C9139A
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C65833AEE70
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D7C2FE071;
	Fri, 28 Nov 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPebDMuF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9992EB868
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318817; cv=none; b=cqDfRN1gUzXgrHhq5wmTE6KIOD314q/d6mXeJs/GSXmhFSwEmTF9b2aXzmZ5ToL0KGsIAZovmUVCGeDPabUgee0vbfUj2PrjqH2bo+4gA4KYc2Z9pXZ5sQDnK8mse+W5RcUrzCYj26Gkpxwg+OjQDpRIUFwPUF98MEl/jL119CI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318817; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cygI5R3EtucQyff1lC+qu35EBATopFKqFaIVGafRLx+q4Co6/h+LTVS1rNBsPdDGoql969hOxYCrcTNaz8UB2pDwCivssnAVRbJnhgeRO31e0X6xSV5NW9IlXXCnKlLtlYkQfGouBNFSYmctqwC3FIvdDaXy5tjqCzU6KaQ3yAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EPebDMuF; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bb3092e4d7so1643037b3a.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318813; x=1764923613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=EPebDMuF2YtiYM5kWUognxF1g/WoiT8JY4hRj+UZWVAgcw0ZBaHphOeRh69Nohxc8i
         TyzMJr+38d0Tl2NsNJOhzXHIkFZGFHbugNjrpwwKUwcZt/cC5mIceCQPGoJe+AOIno6O
         Zi0P0ckYCidr4AYY88DJy66bFtSFswpp4MYtYcik8TkCJ0ii1nfBS6GYTIoQ2tFugh95
         t/d73wR2vgsVU69F+rbxseA1CgyjXU8hLdFy2frc2xvhc53gQa3EIN51+SUuq4MVp4la
         lIfvjkONj3NgGeL3Y8OOOMLPCvQjce9jSxDFV9zb3Z8iBoPDqRhcCx1pf3xMxwRHxNoK
         ohLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318813; x=1764923613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=h0KtCQRKv2UNb1zNr/HG158WadE3FVJBPdxfzXNVs9kY0U8BZaQGcp22U4iBx0OOou
         wevgyqJq9K/LEZ7kStx8noH82I/QFuZXlmdlW+QNuljC9hT6X1tDU45yK6VI4lfpgsHY
         /tUpihH8dklEwt86FLumFxRHg6xjardXKcOybqK5G/hpLy4NYoCMevc2/GAntOHu2dYR
         HBGkOHpdMHABiz8d3I0aHXHyP7DPejF9dDelPfFZ95f3kCUIuIRPcpBPAAd9LxaNq4eU
         EjbfVKg66wXz9B4s2wL6VtSDgX/5N8/YkQcrpZvrNuy0Ejs0NUOjgQB5Bx5ocruY5smv
         C17w==
X-Forwarded-Encrypted: i=1; AJvYcCU19cZG+A2GsIxGzyOIbSKpMbWnUzd0j2Ji07h6uX9Zv1JdchAvzM6OTMVKOt1yKK32h2IXlcjdNXcAi0s=@vger.kernel.org
X-Gm-Message-State: AOJu0YyW3+cmpEFglhJijGCvSxJgVJIhscxn9f88VZXFIAF6BSMLYxEq
	exZEEhcWtiZ9H8oyp8qbe4bc5bLbfAffFWSMU+W+QyFzzqwcNbwllZBo
X-Gm-Gg: ASbGnct8QxUGg091exRkXKnVzVcewnyNRq51lXgKA48T4U5RBus0u0Mq4c557mVDXiq
	7ye9HYg1mc/RddbUs6HMtqPrTMTO/lDBhYNpWvF51ma0BBfR8Z7m5ECwlyjZQ2W0bJXd5FfeWcV
	Js+8hzst6No4Q7la5mLLVqxa8e5x6FWfSYdHsLR1mLwJcHhTH1lsf1PhXrL1NStlyG8aNfKGjIG
	nETRKQ3DGXgHDaB5s0hZXyGVdTLbpDFmx2KeFXt9Jkmt+5etz5EjaGHw7YlcOpUAFVfIjI+qwIu
	Ne3JusWx+ow6DvLMgZtwhlbpqz48lRjaOhGK4mzeBG8nH+5gvclzN3TjVDXlSCcEum7E/GNzZ53
	/tR1xEOEu95TFcGUYJJrFEFao6BGX3rebiS7sXAVqQNHX81Os+DKqY4ZEfW13suHJte9So/pHkr
	8yC4x56JSZh3lZ98ZrXU6Mh2XHKEMINyFRGE1V
X-Google-Smtp-Source: AGHT+IHqHdLof6s224+GbtnJAk22/n625R68t5gW5XXJrnH8NN05gDy1A3OVkHY/4+FwyWeG7e9t0g==
X-Received: by 2002:a05:7022:3886:b0:11b:9386:a3c8 with SMTP id a92af1059eb24-11c9d867ff0mr21572562c88.41.1764318813388;
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:33 -0800 (PST)
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
Subject: [PATCH v2 11/12] nvdimm: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:18 +0800
Message-Id: <20251128083219.2332407-12-zhangshida@kylinos.cn>
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
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1


