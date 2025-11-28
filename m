Return-Path: <linux-bcache+bounces-1265-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8E2C9128C
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 36832350998
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:32:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F4B2E7BDA;
	Fri, 28 Nov 2025 08:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbSTKMTh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2862E6CA0
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318760; cv=none; b=YS7dUCGsfRTQj7Mev4gG7eQGyMEdu/S0wY6oy/IimWS3BGkK3En8cWrPe42/PGbldvFfzUawsgbgm7pHhNoSkE3yoFE+28Vbo3NfTNxyZcUUawkqsxyVl7L4DB85SWzZe06SKVi97Euht/tBXnc+gnrOs0KOh0sQnfeG8tmhduA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318760; c=relaxed/simple;
	bh=nXmk28ARgCcn+VciidQA11ELnwMOW79oTG8rwah+rkY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NtFjSKBH3Hh7n5D25VT5sJxm/fmN8BNHRgFl9xRR0JdXJtFG76hztCLS7QnlRPrn6as4VBV9rmFNMoZGHtvx8u2kJByU74T7NujciZ/ReYZIIWj/aHe8FZJc1mb7scBvVype3qHF7NawBEYVNaNJZUyoxU4PFUvkxtROir5mkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbSTKMTh; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1303254b3a.3
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318758; x=1764923558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=WbSTKMThxlm/4xPvDvVSdATelz6yqeTOs+IvgJZWQDyb709cyNDzAvJaCuE/WHUfr8
         f1EXuQjx9KklKfe6IGC9GxwbPNiUhFRhtPViJU5n1/wswvK2qvWEKT15ugysJsOxNyOV
         0uqD9V9m04Yc9KgtA+FDS8Mvu/cCw1m4aFP6z6xpnXqkwCvAyLykLEave5F5K6paV0r5
         RH2U9jLSGQzsV3JqjgNJOo8b3jqGoP/3QTiNs6/CVY5odXzqsztNSE+auBZPLLZQWGtm
         b3SYZJ7/TkhkqFqTAMHpaoTfjrZBGaxDBSXuJVI40X+Q/WhUsDScuEMwNUyzoUgxeTWP
         AhLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318758; x=1764923558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NqrU9sAvwHlZJQNnImTr6s/wIfO8kcl//WUqMA/q7Cw=;
        b=t7wQ1VVUpeWJS6jxyQlU6UGCGKVGTSDF0Rk9sOzLTF3enhz1MQXtiwdM+x6lLpBEc+
         WafT/5jlVeG9nYgu1LDC1BDg9YJ29seoJKPfWjOSQS6AMPRKl1RO6SHc09twTqntL1JR
         Pc07Hm2IQSjfQk5VTQbIGmXkHzO3/g5QYA6MxJag8HW2S6Ga12z9qw33/xMYWHWVoCUn
         BPzLcdo1m/z+sI1+kNbHBZfUlBI5fX/MuBOS2RgPEn90BITwPBi8WYZniGE3wjoTvImp
         6gd9W7bey2O0YztX91C9hlM1JyvVj7NJhsJoXm3DoV8ik6hmlX4x6avQzdjBySS+leRn
         GOYg==
X-Forwarded-Encrypted: i=1; AJvYcCX2Lsxn85IrYo/HHjUvKhlRdYp4UmRVEYUVoGvAbJb1T5hRwb1GgeCCs8aVnFbWxxWyai3fyqqhM5Mpp4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOj05jcfbKbuxDSDRiTX3Z3hlpp1wFNtqOQhQ3umz38zG1ZQOZ
	R6JFRaqRtWNcxP8oIFkphOyf0FimVdAw1UiIp3eH57Fu0FXFQwcBNH3a
X-Gm-Gg: ASbGncvUjlW61w8VnaW6v2C63KEXbIoBMFatXIwqQFo0gsKD0nSjkI8d3GAkvkvMGsD
	bKasqBX4RwFL16PjAMBtO+uTdy+tWlY2PwQRRLk9zKpDA2lpcrXGmavR3c+J1NLLJ9Q7XDqcEKY
	eLIETxSt+bf1vZ9jyQ3OZ+6r4ukPjsUOhjaD7+ZWXlUWlmiaHvlkqy1h9QHvDbbTGTztD/SccHR
	mpHpsKj45iciPDTVfdpuaQkSbjZncwjPr435YBymaYjxlJ0CKT0FwU0usvOl2jvggFcwrgqFlfy
	+ROGyxpqPdsnp2KETrY10XvnYEuD2dvlIXQtlzzp+e2dvFZs+7oqPK6N2D7X8/fa803TF+X0JWm
	8L6GOHdt6g5M1/H1dCMQqlKSuwM9DzoUe4ZQ5C+xL11NP1sg5aZA3DaxNQ0YQ8KHW11qg60o5xv
	delyV+XlzgcTb8edCeTbRKYkLpvg==
X-Google-Smtp-Source: AGHT+IHdakmTE4ccsFNQ1yLU+VXJurH34ar1nC0le8zm5bpThSihG4vDxPqEawqzf6sYQkBphfQIBA==
X-Received: by 2002:a05:7022:ebc2:b0:11a:e610:ee32 with SMTP id a92af1059eb24-11c9d85f282mr16086363c88.25.1764318757636;
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:37 -0800 (PST)
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
Subject: [PATCH v2 00/12] Fix bio chain related issues
Date: Fri, 28 Nov 2025 16:32:07 +0800
Message-Id: <20251128083219.2332407-1-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Hi all,

While investigating another problem [mentioned in v1], we identified
some buggy code in the bio chain handling logic. This series addresses
those issues and performs related code cleanup.

Patches 1-4 fix incorrect usage of bio_chain_endio().
Patches 5-12 clean up repetitive code patterns in bio chain handling.

v2:
- Added fix for bcache.
- Added BUG_ON() in bio_chain_endio().
- Enhanced commit messages for each patch

v1:
https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.cn/


Shida Zhang (12):
  block: fix incorrect logic in bio_chain_endio
  block: prevent race condition on bi_status in __bio_chain_endio
  md: bcache: fix improper use of bi_end_io
  block: prohibit calls to bio_chain_endio
  block: export bio_chain_and_submit
  gfs2: Replace the repetitive bio chaining code patterns
  xfs: Replace the repetitive bio chaining code patterns
  block: Replace the repetitive bio chaining code patterns
  fs/ntfs3: Replace the repetitive bio chaining code patterns
  zram: Replace the repetitive bio chaining code patterns
  nvdimm: Replace the repetitive bio chaining code patterns
  nvmet: use bio_chain_and_submit to simplify bio chaining

 block/bio.c                       | 15 ++++++++++++---
 drivers/block/zram/zram_drv.c     |  3 +--
 drivers/md/bcache/request.c       |  6 +++---
 drivers/nvdimm/nd_virtio.c        |  3 +--
 drivers/nvme/target/io-cmd-bdev.c |  3 +--
 fs/gfs2/lops.c                    |  3 +--
 fs/ntfs3/fsntfs.c                 | 12 ++----------
 fs/squashfs/block.c               |  3 +--
 fs/xfs/xfs_bio_io.c               |  3 +--
 fs/xfs/xfs_buf.c                  |  3 +--
 fs/xfs/xfs_log.c                  |  3 +--
 11 files changed, 25 insertions(+), 32 deletions(-)

-- 
2.34.1


