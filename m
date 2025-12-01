Return-Path: <linux-bcache+bounces-1310-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA60C96504
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:05:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E00D434219B
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9682F1FD7;
	Mon,  1 Dec 2025 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtBy0pek"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC3214A64
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579898; cv=none; b=nXfbsqE1DG1SRgqxbSc6B6BDrEH9uXt6jmgfT7xD3oFUR6V+evttyFu0UGPX7SBsSi7Mv3n5MlWughW9GgvoHH87lY7xPCCfpPDHu60I9JZaqmuU0S8oj7v5gU5ksc2sAYBnOMZEQoOUaqkimUX+bzmi6s/oOKYIbMnClZZ5kyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579898; c=relaxed/simple;
	bh=wWI0hn55fvTvrLDkP5A9I3pEc/gcCNnN7tnCnxLnN0w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GFWMMxgyvtqBC7oTg3myiD07OvJ/WI8sLj62OA8wb4oXSu8CIhPYkOfrBe2bcY2NTM3Y8kmBhF9Rcow1ef31eXP7wF5IeAYoKvuk1qDLWkBm+Fuou4MlQh6orhf3YNtkyAXWSymRspvlYC1KKjlVPfotWWUcFe3kcMqv1IqNFIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZtBy0pek; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bc8198fbaf8so3475683a12.1
        for <linux-bcache@vger.kernel.org>; Mon, 01 Dec 2025 01:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764579896; x=1765184696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kfhO4t45NNnLyH8RgYmrHOJVhdz/vqMYLwrTLqjFvMk=;
        b=ZtBy0pekBD/gUg8jySnBVBNbx69k6M2G26ckUriUnPI7WozVcodiDpH/u8mTtfxOLD
         cUbX0TSpX5ySIc1//GgFIY9PDN8WAnGYakxTFh2t/tbX/VESJhOOBVQz4hznfmjn4BzP
         813bAOyweS7A89C8e2u7EMbbIZLfil+U06/231ktfMTXvDqXndhgKCOF8LIN1v/OebMJ
         Ffgz1/79HHW0wSFROdOEZEWBuF40/Yn8BDKEyQHgZf/MJ0zD5OyjsdZhwg3lNW8MieIZ
         3wMGIsYi9jXwcsx2DJ33gCQQJdOWB0gtS0hP0QCpsw7wJg7l9QijzTdc2FwUmHpyVG6c
         YnPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764579896; x=1765184696;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kfhO4t45NNnLyH8RgYmrHOJVhdz/vqMYLwrTLqjFvMk=;
        b=Z25bxaVuyjxQS8tUSuFti2VUnzV11Hwuahj8k/L88fVyb3fYGfVu80IJF9XtyBQrDT
         AmxDm3BniPUA2QD5WwIaSsED3z2lxFmNq+CeB6Dk40D5S3ViOaQTIB5XS8KkA7qObgBV
         GZF4DPl7TWYqdKMvxlSYxa5KdhtdWFlNKSTtSvsiegwd/uwi52Ov4DnJPNtMLX9bEZD4
         hk6IXVVK48UEKgW8Z5eD5qZkynbXYF0JcL/mvTiqHVAxPNijsf4ceu0ERuClMEs4pGk2
         gXeoe7IwnAfstkaX/I9VV2tki9wNPZ+UqMaRa1Pmk+ySVtd84YeU9cI/paOiM4lOAMwr
         by1g==
X-Forwarded-Encrypted: i=1; AJvYcCVoxIQPBNHv44wE/4gqOkuSrPmjbsyriJBVrOMG25whjLWSwhhEunap/dJoUdGKXVezVYPhMTpSfjJyvHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOXwvnT4Sm8G1fG+NrLQ9Dpbby0M2PWBpdLHUNscp0nVLlyD85
	CvZsf7nOcpd6pH9oy/U9tsavEoBTZGNI4eobJj6FhrDjUyA8/VDm6/IK
X-Gm-Gg: ASbGnctbqpS7w3Oc/kLcvQs5db4ec62veCfKYpsYPly9hW7Qq3ZxAyxqa1I+oWBrnWq
	iSJR9RTDPk7mvmBs9JLWSGGG8BtM5DLTQfLilxUpbOiwkkzdDDNKY6J2J4PyOHeQq9O8Jh/Mm7O
	oQ4wc+7cbw8PbBBanMHrGtu5HMhkc2ajQgHWlxfKH6UlBAZTfoJO8d3tFdQWEuLIwp+90BFDyJ7
	K8MRx432ijKnXLWcukWKz62vr38bz8JPmVwzlMmuN7XoSGtPjmoVqehUIKq4AGSxdfCV509ifqy
	xJwBgLaNheu9xcg11myt+NdNPwY3S+t/c/g7nmULZN2Om/EGkTjYuuA6nu1Pu5zlwWSOoZYomO6
	ZtDfx1VkrMNXgb8PgIS1F/px5oI3/wuOXfQGS9raUux0FFcdMNWUKE+C3kxjm6yPngWVsyRgj+Q
	MgDCxk2IzEZ4tDWi2bb96UPg2ExQ==
X-Google-Smtp-Source: AGHT+IEacD7nIRpWHZXiz4TsORsmjqaoL0X94j8cSIbshETof7GukRtdYu3CFoH/ye5Jv7+JumoDAQ==
X-Received: by 2002:a05:7022:2393:b0:119:e569:fbb4 with SMTP id a92af1059eb24-11c9d864e98mr25000325c88.35.1764579896080;
        Mon, 01 Dec 2025 01:04:56 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm54908307c88.0.2025.12.01.01.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:04:55 -0800 (PST)
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
Subject: [PATCH v4 0/3] Fix bio chain related issues
Date: Mon,  1 Dec 2025 17:04:39 +0800
Message-Id: <20251201090442.2707362-1-zhangshida@kylinos.cn>
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

Note: Patch 2 must depends on changes introduced in patch 1. Therefore,
patch 1 is still included in this series even though Coly suggested
sending it directly to the bcache mailing list:
https://lore.kernel.org/all/20251201082611.2703889-1-zhangshida@kylinos.cn/

v4:
- Removed unnecessary cleanups from the series.

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


