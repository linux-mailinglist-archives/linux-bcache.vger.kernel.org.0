Return-Path: <linux-bcache+bounces-1295-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BA81FC93A76
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:03:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3D44A34832D
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED39326F443;
	Sat, 29 Nov 2025 09:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dd1ocxGz"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE642848A4
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406925; cv=none; b=QID/B0FJ94mbuQBl1AEELp3ARONchToezV6MTFBtsQPhYOQvlw48uD2Ee28iKpibYoOG3BwiTKH8ON0N4p3wE8dONGfL9bm5MRZ+mKqPyYJ1MOxS+GVP8XuFL8yz/2TFSyfW7XY27/l+SPpImWIExTY/ZaxkIzJDRzt6VdpcYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406925; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rntlOcI1lV0aJxx3bq8WThUQRJJB+RPyAaC6Sqto+YTxcAVur1MIpkZnAVVZpKhPG3KSARLk8L61h4KCX3nlBsJCdyebDl2WBMiycJExGRwt0EM2dnm73E1qfYdp/YGcz+lx9XdQ0w84uN8y6RCD8+C2/IFGVmrJc+44I1uvVQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dd1ocxGz; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-343684a06b2so2477247a91.1
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:02:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406923; x=1765011723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=dd1ocxGzdhjSsgteQ1J8SNLo8OkTdBZAanb6vnoi7oFFq5bU9MJlGPjhuAytnKRXwd
         7foxMQOWM9CeGrUlD1kcXTTvusKIKkyx13/f7/rFKW6layhbqq8l8U5wGBJ8Kgig59eJ
         p99Qc4DmI+mPpo5U5ok8IbPT0fhgeP3x9lRrqtvDlQhJ9QmDIDHVLCauvhgyhhmGfMG8
         FFkIU8Zl1AFofkQhVPM6eE64bjWyk+7YTN9jf6MxPy15TjQlLCGmg68P2pBHzIP6EL4W
         RAQIEa5ud3nDqEtRoDP2v/ieowml3UaYUT+nzfVlXXDAK0DLgRBhxecyQrP3aL2K90zH
         QmNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406923; x=1765011723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=kqh+jjvsZadjD/coebquY576XKODV0rhV/fp4nUVXrKtFVzKK4VDuRovy34ja1NTc2
         /gG48p17GSGH7fP0lRGKDQngRRRuHnztvCPLc4bbVZHliCjS5+eVJUdlLqg70CAJPB/1
         0jTgvrSN4Gjl9+ej3igwcxi/nMz3jIofREtywXRZTknlLomcwd9B0CJFwK4m5TPqQODp
         7Keibci9kBY07t7kxGJOnRYCCmCLD3j21wTkDHfuSZc5q7Hdcwj6DL83ugR6ymnMviiw
         thze4v0yIbzeZh1ANL8XrsL2LjqxeCULwYc3u5OIDWG4HuiqALa/asTQo2eZ78BwRZjH
         jPOw==
X-Forwarded-Encrypted: i=1; AJvYcCW96SN5rp+79Y9ZUP4hnUqmYU19b4G2VDsx0DDcmeeTcf2pA2IapEbQ7WXm90OdIxFKwZJyn5vLN6CM+rE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6pyhGESmYJlKzm0UVFEEnEbE4FUDhtl9whiSdyBa7YYFIbhkS
	n4ZSq1L+ISRBMctwoVGrAmU5CL7igxJDSFof+SRLiJeq2MeamiSt+nqe
X-Gm-Gg: ASbGncvmGLTAP7kmvjufTGDD5N39dXNgD6jL2IWfodK+BeALysu3PS/oOdWzbdwy/7W
	16n1SwKVuC/zJLIT6wJT+pTMwzxwqCgWklj73oQl6n6HPG8vmFHhDXSbmAZCF0ubdOvGef8q5U6
	jnIYeS9MFHv9Q1BBT3DgLIaanHdpKjuo76FzJZl9S+JrWr1SWtFZ14H+pt/isOafnOs1o1IuZtU
	dtdpaljegfChq/PCnYSu5hQhlk+lIUjP4VawG6NmroNTwIPY+qd8zDwpiyiCLwLa8uG8EV6ezev
	jXYtOTi4IsrISJd104voKoD+xMptumUGE6CG5++oClcOJsVuMgdMpn6Radu7O1brtyLyHIBlP+Z
	FJwRUv8I9BxfJrkqcPUetxGyCTgI3w3CkJQTcZTUTcUZhZUXnOpgQOgeATxsWTeCXVq+ky/JRg9
	YNoGZZ3YgxlZrDwypDR8O35spkJhsIMliaYEMy
X-Google-Smtp-Source: AGHT+IH/QH6JeY8zEnnFSEp2edvSj4WvW2OiftF5ahPSC2LjhfBX3UeSnFliqzhG5QTteUkJDEx/bA==
X-Received: by 2002:a05:7022:ebc2:b0:119:e56b:957d with SMTP id a92af1059eb24-11c9d6127f9mr19966464c88.2.1764406923339;
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:03 -0800 (PST)
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
Subject: [PATCH v3 6/9] block: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:19 +0800
Message-Id: <20251129090122.2457896-7-zhangshida@kylinos.cn>
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

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1


