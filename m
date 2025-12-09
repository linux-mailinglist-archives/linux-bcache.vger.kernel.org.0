Return-Path: <linux-bcache+bounces-1348-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A03ACAF603
	for <lists+linux-bcache@lfdr.de>; Tue, 09 Dec 2025 10:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A73E230141DD
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Dec 2025 09:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D06EF225791;
	Tue,  9 Dec 2025 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tn8i8SSh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749627145F
	for <linux-bcache@vger.kernel.org>; Tue,  9 Dec 2025 09:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765270930; cv=none; b=dxSaVqhyQGW7CeEuL4FtD9zoMNWZgp5UKsu5A62DaE6NkPoAXKqiQR8SiLiar7Q8eXaOWaNK60MOoh/RIU05WzO/KGqNW7hLlv7XCQzOtyPnQwrlJwDv33FV1LxkDFf1avW2hg3Vg7VCcipSrnKMiO/3XCeB2wCH+r0WzjOKeK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765270930; c=relaxed/simple;
	bh=o3zn5/dTCHFgsoiRIpo9rvtFdKHBOryMehXGhpxlCQE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HXCEBSVWz5p+jRQ+OCgArNqn30gp8A4Aozxzwad0Mj5RYNd75000EFOEc5g++XMHD+ysXeViVSqxpztdCl59DX6dMuI5MZBIG5ajymHf3zH1QdTr59QVdsCDCfuyF6F2rxBqBxMGq22hoNnI6Vmmi7Y6ijigSw+WDsQ2kj6pKqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tn8i8SSh; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso6181945b3a.2
        for <linux-bcache@vger.kernel.org>; Tue, 09 Dec 2025 01:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765270928; x=1765875728; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C/Nb2Is6M0GneIbgo+NcCsJBTIf8Ny5rTNinjOiO5UI=;
        b=Tn8i8SShf2cDweK1Qz7VDX7Wcyrxq5+kmHv/txeugk45z1tGOxU2JQ/c2wNCQzM3ew
         rTfR/tWL2+LA+vZqpmFr6C+gDcVT98p61HyY4gNLmCcGtymbEK6/aIksBG4lOrmilV1Y
         oJXgQHlFS8ssZlfmrHG4DRjc1dwVxPKmfCXN+CZ/8xiwaAfvlo/9+AtsLd+2xnqW3xYt
         FV5stuxVfBbjlJ5JMvC+EyR8kJWPbaI/0HwJTFZOgBiU3r5tD4BkNbe+XAxyZ4wUeGy4
         FBOTa8f/S2wznyM4uJswVdQKqv324J7Ud/ke0lj0w6vwnaqdZ8mdWjP4cDkTCuxrLk4M
         XvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765270928; x=1765875728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C/Nb2Is6M0GneIbgo+NcCsJBTIf8Ny5rTNinjOiO5UI=;
        b=j+fzk08WhEIABX1qHDFijW7lWJKm/tTkeulcL1LL6bF9E5G4fD+FBWynPRoG1uHcj2
         yu/sL8PyxCSXdhbgTCghUw1rQvdAKoaghkqoah1LjoSLIox1zsXTg/jMzZ10qoCREF/d
         Hlkw6rZS4kdKSkCwT/KGlYG7urV6vScwB4Y8uQEWV843oJidfcOMLk3T228Mn5QkrDAC
         o0H5ZytAKhC54Nj7djmdBhNWppCa5uYtB7hIQqAxGFmx0CGSRE4DsCCHnE9XJ5/IVkyz
         r5WsGMvlTBbQR8EfvH5g1Mvmxto3j57cTfxtmI52nXJjQ5rqS0a0bQMsTb/NCrJyJhig
         hKDg==
X-Forwarded-Encrypted: i=1; AJvYcCU7IW+jwCKVikBToAgVNNFOdPIHof7aQ1kFoNNR1SRThTpZXOJRWiqzT0fUesgzNKOPqSUpPJz2OELjk6I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl/Ok7mi/X3CQLLG4v6tZhQjT3N+TtjpcE6tIXwBbQlYGjSYDp
	lN2fSqZMSkgk8wqTwfw4z64lm4/7BUwpp/5rLPdb/Iy7H+r0vyCiJlDJ
X-Gm-Gg: ASbGncuAR2dgGhbpTRMsMh4wmxCa3DChoUNGhQXytQ//KFmLiH0xvUp12IHoqkQnzhw
	xjERbichHs+3ztCPl9pJSeA5V3l1BwFHkqYXKSgVbS+F+Rb11Tj/FpWMwNc5qHls3Cj7JN7gQ95
	0B6nWVqh8s1AwA1I/8Ha8F2n5XKMPnGzSpzcQhHNEM+HNv0/09u24aBrWIXQ6MWu8J+w0H1B2xD
	kXMTh2xp/ZLRtBhy5n3r9UKeYHKwt8bDHCMWvePtPvdor2VEXBUJPjGJi0FxiDrOdmivfhqNL6w
	NNFx1G35TBAIlHPw9fUebfFvOek1MQDaBeempBzZGNEF1iLCcy7nZCuUo23G4ZmkCS4P+CdL4qP
	ObjE2Bmw8nNWEMKcaSo3KybM4+GDfMym3Blv/4ucmG/HfMo2PGGb8LoRwOuiIWZOHVR8DDUiKV2
	PP0K2PB4T4dJEkbzgRJWru9mU2lA==
X-Google-Smtp-Source: AGHT+IFZzmQ2/bsti0gPk8sjEbYdV2dJ1Lrc5Vp6Jzw3MTDPpZwdTrGSJRee6+JBOyYP3s8Bi1pzlA==
X-Received: by 2002:a05:7022:62a5:b0:11b:9b9f:426b with SMTP id a92af1059eb24-11e0326073cmr6796299c88.20.1765270928187;
        Tue, 09 Dec 2025 01:02:08 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7576932sm69700982c88.4.2025.12.09.01.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 01:02:07 -0800 (PST)
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
	starzhangzsd@gmail.com
Subject: [PATCH v7 0/2] Fix bio chain related issues
Date: Tue,  9 Dec 2025 17:01:55 +0800
Message-Id: <20251209090157.3755068-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

This series addresses incorrect usage of bio_chain_endio().

Note: Patch 2 depends on changes introduced in patch 1. Therefore, patch
1 is still included in this series even though Coly suggested sending it
directly to the bcache mailing list:
https://lore.kernel.org/all/20251201082611.2703889-1-zhangshida@kylinos.cn/

v7:
- Dropped the patch 3 in v6.

v6:
- Patch 2: Fix the comment format.
https://lore.kernel.org/all/20251207122126.3518192-1-zhangshida@kylinos.cn/

v5:
- Patch 2: Replaced BUG_ON(1) with BUG().
- Patch 3: Rephrased the commit message.
https://lore.kernel.org/all/20251204024748.3052502-1-zhangshida@kylinos.cn/

v4:
- Removed unnecessary cleanups from the series.
https://lore.kernel.org/all/20251201090442.2707362-1-zhangshida@kylinos.cn/

v3:
- Remove the dead code in bio_chain_endio and drop patch 1 in v2 
- Refined the __bio_chain_endio changes with minor modifications (was
  patch 02 in v2).
- Dropped cleanup patches 06 and 12 from v2 due to an incorrect 'prev'
  and 'new' order.
https://lore.kernel.org/all/20251129090122.2457896-1-zhangshida@kylinos.cn/

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch
https://lore.kernel.org/all/20251128083219.2332407-1-zhangshida@kylinos.cn/

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/

Shida Zhang (2):
  bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio

 block/bio.c                 | 6 +++++-
 drivers/md/bcache/request.c | 6 +++---
 2 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.34.1


