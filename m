Return-Path: <linux-bcache+bounces-1270-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6BCC91331
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 75C2E3ADEB4
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C893C2F690C;
	Fri, 28 Nov 2025 08:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhCDL1Ws"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2372F531A
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318785; cv=none; b=hkEbpSNeBKbIGYeAKZIwTmbW+NVwSbCnaLYjGYoHGjOSlLEkYd5IihEZsLPjaf7Xg/3nWgZqr/1cx3w1w8xni0DouzQgwbk77f9UgiZw2aDUOBIEWRIpO4aKTO5vvfPnCjXTuMnchYwRdHoEr5q0Bi8SIQfGKNSVpp7JjG41W2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318785; c=relaxed/simple;
	bh=+kdxszjTpaHcpdO+OsTg3+9Bb8a87RQlO+SGH8oGptU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r0/nWypD9PwrMbQFqfcE5QGZ5+EHQzc9khlczyxGQpdjRXZmURjzQnM0z24+e/TdoGK82BvF6S8JLc9EEP5hD7mbIFfYRQEtAfeZoW+Jz7SAdtOuBY6/Z/k2qOFIUE4REpudtrwLFQxqKizvNc2nY2h3Tl6K0X1ImvZZus6ys0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BhCDL1Ws; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7ba55660769so1359619b3a.1
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318783; x=1764923583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOTI9zrIzg7zm0suBs1FvPesu0SkZxT8M/7CVofybKk=;
        b=BhCDL1Wsgz2qKihch1wO4CLq72D8pMTuQKp7V3DyN38kesed6BOxzCgXNGMbwkE5fx
         aYxqxqmf7GGfGIDefKebcCUlo5c1TKq3JapQr6aLALpmpHtkxdsMkxrRerFmjjJt6Hid
         EB5IBxJ/uWXG3ataKDrGiAbmmtEbOw2Bp18k5STbhdzeCc0bjSGGyQb4Ss9AS6CRlofN
         6aHQLCbkg+YcFz/eOBdmk7eTmQ142LJrcBFPGIUzM77IipIigdR5sFpqPxHFv15kbyLS
         eYOxNGdub2N0DxI/+veH1eJhqjH7eq6kjqqT+Zx44xBisBVFERmoiIarMGe38OCHPZjQ
         Tb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318783; x=1764923583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WOTI9zrIzg7zm0suBs1FvPesu0SkZxT8M/7CVofybKk=;
        b=MvVKNjgcM63Fazb63SP3twm72/SEgPa7aoC5t7derW2YFtOPOw3cmHqw8WH3DwZS6e
         3Xy+AGenWbzM3YjjSyzsa8RdQbYBGEbGoAmhElt+RSqe5/xu+PXYLoZ+AFnh7f4ni2pM
         yF1tD6M0gzMm69ioIJXfhSYJxlKljoU7+dyuF/vg1q8cFyYsuH3uwhp6E0CyCBeWSS7k
         2Mr3OXPvEkVhIv7Vk3PT3/XWVucfMSriTpWURj5IFh/dPeCESg5az0EDC6k5fR6zYIhp
         bdI6nZbaF6rm1UHRX1ZuIrEXeslBtj2B5GVS8PZpH1WgelcPYgeL6o/Pzg+QK9d7nc3V
         TTew==
X-Forwarded-Encrypted: i=1; AJvYcCUfgQLqdj3UJ+yioJFWhrYGHEAIo0yca+3QCcO8eIbvl2K5OCPFSViqb/enD+Oob8xe4pzB9tuTYciYOvo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQxLRSK2dgaHG5jf99LzUsmwoSzIsDhD6JYYo/DVrx4zp6phlj
	38HaB/+Fw6jvdYyudpBsFfoIiCrf9aCPzptapwz7wn/KLrwYjv0kpYgu
X-Gm-Gg: ASbGncubZ++M0HRfyPY8EacqfbDXK+21dLTyqZ7fI/oguaPVvaCYNynYVf++IOGK8NW
	UDFuQRMNVfOAfsr/qw8UPe5XbNZQdVKbu4/VmBhrBYvTCXykYC/Bxpp9KeM5HLAXcWKEtKa+qOA
	wm0q5vBgnR+lPgEddN0ZE5vAm90iuA5wAn5BBFAjaswAp9lTa/3S7070zvewSeNNFgJ207opMZl
	iff+a+8GzL7selYtZAZ143PFABa/sZwcJf1V9sPuWqqYbMdcMF6qduzkk2VBY2UgCXd1I0Zn2UB
	SnPtaQNJq2jm+43boI40X9VT230FoybiKD3vEyqGYYOgpPFzxuN1/agyAdIUH7NbviCfIT/Uoho
	UMQZtZfL1yi1lUvvhKcfImYdcld0TWiRAl4ORzYh7kMLnl2IQksTtijZ4u1liKKqdJClkQAaLd6
	/ubA0fB4NWSdsNipbpF9YrgDo/XA==
X-Google-Smtp-Source: AGHT+IG9KZ7rWCO0ABhUceCtzlD+O/EyLZjlRlvHPaAHNjz6G3IYpmLI91Aw7ItyMwREv8ZXa06T1A==
X-Received: by 2002:a05:7022:671f:b0:119:e56b:91f2 with SMTP id a92af1059eb24-11c9d870411mr17435747c88.35.1764318783005;
        Fri, 28 Nov 2025 00:33:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:02 -0800 (PST)
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
Subject: [PATCH v2 05/12] block: export bio_chain_and_submit
Date: Fri, 28 Nov 2025 16:32:12 +0800
Message-Id: <20251128083219.2332407-6-zhangshida@kylinos.cn>
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

Export the bio_chain_and_submit function to make it available as a
common utility. This will allow replacing repetitive bio chaining
patterns found in multiple locations throughout the codebase.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 2473a2c0d2f..6102e2577cb 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -371,6 +371,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1


