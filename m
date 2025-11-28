Return-Path: <linux-bcache+bounces-1277-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D5471C9138B
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:37:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B55E3353C06
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABDCF2FFDE0;
	Fri, 28 Nov 2025 08:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTjE6bRE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701EF2E7F1D
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318823; cv=none; b=UqLfokGfSiC+3KEnn3sQY0xid2xZtJnL4/d3yoNvmgNTHHu+cy3rLfVqRfM3riKXUeAf2tvHkllVZhDui3QJ4GzL0IsT0ujpZd+Pgct/1PDikKDhnegxq17kDCwcAjRpqZ4PUc/CMdZootZt8RQjRQwnYn/SFo1NSNhA6N8URL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318823; c=relaxed/simple;
	bh=HTuaf3JKiz2KHLk/jbQPL7NkOb05byK6j+tq4J3zrGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qFflAwhAaRI7kh5DRGHpoxLVEnO+Yfpi4Ajs6JLE/o5eTnzYYx9ytbj/EEgbzGboFn1+hzwBZfqFDtBsSklIcORzDdiRJe540p3B8sbwdzGq8zlxD6nfvPq+06ddSD2ScByJKgGTd47jyuGk8693y5ou1+rDoKbRL8ykOiinUtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iTjE6bRE; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bc09b3d3afeso942622a12.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318818; x=1764923618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=iTjE6bREmVJASqSDl8EFaPBpPk/0T4H/LQbXF3pe7HyptW+mMYa99/LJ8ElLXOMM3F
         Sd1Bb+StN9LTrgQtOJzA6Z8y5oi6xmzg45HAPvfnFx+7OKFhMyj44RqbRm9UkKJoweJy
         bsF1I7MI7UIuCSy11JPccmNBjPR82TIbC3pVXwWKyyzcaAMz9jRUxwSAU9z/POeNlFWI
         EMtBGBCOQdRelgl/DqzIfbJRW4w0G8qWR76cpDznOwZD2usTxkCnrWWfCkyCLcI3LbJb
         jI0DV8r8w2K4Q06tnvQKwq4aJEa4N6MXeLCER59iAVqSwHrVlaUpfJsJSLc2Ihsc9loy
         ramQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318818; x=1764923618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=OkxW2kbKXa1vFDWFWzJ6FHHL1tuJhJMlyBN1N/RWuV+3PjtAC+F0o3ZQ3D2ZfKs4Tn
         XpQ9iwoIFEbAhfpgQAtSMuUQfJe4Y9pPbJXPirnRTIHFGH5XwBgWStAv0ALQFHhzPStd
         /HU4przX569Civ33maeuKTfD3ZxkKFPcQ5smMErWKM3irkRbzZ7ZUzLZ241pt/pVZ7gh
         Yux5TWw1M/Ae4dv5jhY7swyxYNg65Mhm1sUdQ2bTkOFmWtsnsjzM7jEV5d/ZPipnmLyw
         W4A9cvnpk19QKJ5B/mvsRtbou/c6K08UMOHVyzSBefrpndar/VrlWy1qcp7ANOS1Pj8W
         dKgA==
X-Forwarded-Encrypted: i=1; AJvYcCVPu6Xlrr1WVcaBTGeesDYxRB6XOlCQpJeVpBr0vhr+CJnQFf1v6GCVQRjaF7AAtwssxK8/z9AOsMqO+kA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+ocOjEdoIUAQknWYndrpp1sCnK51rlhNDds6+wZ+4XUul+W6x
	CQ+6zo1VxAzgfl2yk6w0eBG8KQ4f8FCNTDV3UdxvU/xGuoOBzs6ty32c
X-Gm-Gg: ASbGncvwUka20WMqb26vyEJ4VbfxyEsRMaPK9CxJhNJR+UwMK8mMRk4UFJENUscvVjQ
	qorBHCytpTbaZkm+rSN7DooZ2bAxGEw6a9+YusAyvngMLjn72iYvwi588bp2K/yO/CZuCsDS3my
	gF9heI4YvPxzuLf5PGKZhBc+9lo4UMYxAj8wIeRTO4ZhpvNxuka0g9n86ZETtrPxTQ+Xi6CGLQe
	Q7KhZq+aUdWycUQ9d85afTLq39B6PC7XYinPVJkySKzudUp4snozcsZTeRmK+6UlxPkQLS0JEL0
	37Oc0EhfM5wNGNq2Wi+Z9uciEayXgqZefw6K+vqLOfGmuKLJ3OJqmol7y4nBKtXCZfPMnDSdMtU
	97Qx9hXXq/kNHrrp9J8N8fQIROK+Kq6skrz7L5dtW9ihxksuFNtv1lwQKuxEYLHejjuzYP2SDU0
	j4rMZWx7/9+BtOxOE8y2+0Z4f98Q==
X-Google-Smtp-Source: AGHT+IEiYKFOm1UmbHzu9Io+L0ipF/pftCo6ih2XEqCkxPLrZNrFMt6HrxgMvpe9BJ/P01XRe5CPUg==
X-Received: by 2002:a05:7301:162a:b0:2a4:3593:ddd7 with SMTP id 5a478bee46e88-2a71953bfaamr12018765eec.4.1764318818087;
        Fri, 28 Nov 2025 00:33:38 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:37 -0800 (PST)
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
Subject: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
Date: Fri, 28 Nov 2025 16:32:19 +0800
Message-Id: <20251128083219.2332407-13-zhangshida@kylinos.cn>
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

Replace repetitive bio chaining patterns with bio_chain_and_submit.
Note that while the parameter order (prev vs new) differs from the
original code, the chaining order does not affect bio chain
functionality.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvme/target/io-cmd-bdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca60..4af45659bd2 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 					opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = sector;
 
-			bio_chain(bio, prev);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 
 		sector += sg->length >> 9;
-- 
2.34.1


