Return-Path: <linux-bcache+bounces-1327-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B31DFCA232F
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 03:49:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 125433036593
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 02:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493BF2FBE09;
	Thu,  4 Dec 2025 02:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDBaazNW"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA3A2FD682
	for <linux-bcache@vger.kernel.org>; Thu,  4 Dec 2025 02:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764816500; cv=none; b=ROpvQOKWc9OY8bwOdgqz3mKlWSgucMIKm/Uwh5gZHWZR4u49BU3Ry92EIouKwkHRD/0c2gTUZskxeYSXvY4b1L22UMWc6EZyh6xzHFoe6GIxxufbVwctfbRavfvQdBKsvjgBzxv+b7IuJlUAk/c5zUCJQRlg8NCbeH5sFkhSgCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764816500; c=relaxed/simple;
	bh=X+yZ/K1ZTsaoVE0DJ49j3nn1ER6Lnivz4II/94xrrZ0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=eFT8z3ej5SbVSn/BzFj5jtBtLrBYPq3AWoZPmCT/C55H1d9oLBfaQp0+01pw8fa2MqBNfSFC31qJ4+sJkCt0fmMyWN2gB+0mFlEfaMSWL1f1wPGWzGPStPa8PrIWh3E4tEihM0YcQFWp8f+Ida5a1JjOCpVj7YD9975+ojfhgnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nDBaazNW; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bb2447d11ceso257858a12.0
        for <linux-bcache@vger.kernel.org>; Wed, 03 Dec 2025 18:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764816494; x=1765421294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=k7UnwontmyLPrQKRk7Kie3LanJLCzBGPcKe/gr+3MdM=;
        b=nDBaazNWiZOU1HPZ8pFLoHwD0HmeGoP9iqZ5tWirFav0/oGio4gtM2FJ3uP+nledvv
         0Q0BMEJ0Q8NyLJw/CduVHi/u+ch03MFkBQnc8vwRA8NNBdmEnB9jqS4VdwXQTFYg9vXO
         oeRBVmvsV4RFVMbvfzf+RcLPjwN9tMzRqXuq/5xIbdA01AF+I6u2xq2JMHjwCzvE3xqX
         XiGiaV/n7jEPgVrVTBgQhKT5MSEgqmZgNEu+Z2HB3Vo8VfQWMIH80ArCGOAkX+0fyb5q
         THr0pym2eg8NhmkoFSURd830JL93hyPqk3peNAYtAOGgL3g0SzRYJ3nHzqMSatSAq25m
         tKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764816494; x=1765421294;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k7UnwontmyLPrQKRk7Kie3LanJLCzBGPcKe/gr+3MdM=;
        b=KPYZB8Yi+xwAGGszgdh049DW/KdbbBXAxRKNfi3CXxDyhZGncR0afzDVXbCUqP1Ubx
         ZFrUSGgNZg5zLwnwH5oh3cQm9qhdnhACadMfbV7FWXTmT6oZT7Yj1t5POuYMABsaVhpE
         7tbftSd7eK70RBskK/8FWH9cq8MYFFawaXyxSwDSPQxFRl9jiHQdZZenLjkP5snS3yrI
         lQvtxjFAxX/+BTXBzfev2is19acR7/HhxssSDI2vrBAcVw3SCY0KYChDfWNekGcAGO56
         Wa3nqQAqv3SClLmerQMyVJLDd5eGeaiXhdraQH62x7KJew2hgBU8sfih7N3MikqjBhHI
         r9PA==
X-Forwarded-Encrypted: i=1; AJvYcCXmlhb1aAjrtSINBVFVcE1flf20KAmLJy8ZSduzvLO42A+6g/N7zIUNCvDglNy+yWbdnBDlFT+t0KTJ5uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzx1OW8PTefAtdHZMbm02tn2rVQ5GfMvtkBG+PjG85fPVFr36iA
	3W6tCsaXizttKZqbBuMNn8FmIekALcNIFLKkwzVjx6ILQEsf4ncEOuKW
X-Gm-Gg: ASbGncuCliv4nTaoE7EPUl9yoHVhtSr7wfj7YDInTEEqBH1m8UZrfO1QAh89s5dNzt5
	4bn3G/XQM32VXNabiUjfmpaHwLGbLv8Mkth7H6UZntKRfRuUrhWgzmYSRFwQedNBz2jzgsT9MgN
	qD353M/A8YFIp4xxOCbpqajo+RSHX7U/TRsEOMeB9hJ14nD+d7zH9HNcFC5Cr80x36Du5s+4+2P
	Ecy18g5a9yfhPtOexc9EnknDe/2C5Cji3OyJYpUN0iqoXIUqK+ytEBm1qIjFYSmDQPrSDGfSV7Q
	Uhr1ulzDPtmxJtQ8GJ2CyLk5RF/snCwZlwA4MGYbohup+CTFjx+vboy2Cip9Gkmmh2GT689SClb
	SfjM9YMKj2DDDkWe0q5TZ+zc2/wA2SxIlrtxS1HfNJ5nNJZ+b7MRpe37TJZnt6GgljZrBxUxeSJ
	nw0i+kEpfnpD1g+bTtwcg0JqqMuA==
X-Google-Smtp-Source: AGHT+IFOKtCW31i4FdwWaXVGRlDrC9YoWC6jwT8zUUWeS8OToViJXaHXySQmsIjV9v+TS3YVMPQbKg==
X-Received: by 2002:a05:7022:ea4a:b0:119:e56b:98a7 with SMTP id a92af1059eb24-11df6463f28mr613468c88.14.1764816493587;
        Wed, 03 Dec 2025 18:48:13 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.41])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2f3csm1838847c88.5.2025.12.03.18.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 18:48:13 -0800 (PST)
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
Subject: [PATCH v5 0/3] Fix bio chain related issues
Date: Thu,  4 Dec 2025 10:47:45 +0800
Message-Id: <20251204024748.3052502-1-zhangshida@kylinos.cn>
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

V5:
- Patch 2: Replaced BUG_ON(1) with BUG().
- Patch 3: Rephrased the commit message.

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

Shida Zhang (3):
  bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio

 block/bio.c                 | 11 ++++++++---
 drivers/md/bcache/request.c |  6 +++---
 2 files changed, 11 insertions(+), 6 deletions(-)

-- 
2.34.1


