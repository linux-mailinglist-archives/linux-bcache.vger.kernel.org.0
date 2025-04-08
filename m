Return-Path: <linux-bcache+bounces-852-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D085A7F33A
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 05:34:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E36F1897BC4
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 03:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327AB221723;
	Tue,  8 Apr 2025 03:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6o9b+Qy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2682AEE3;
	Tue,  8 Apr 2025 03:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744083239; cv=none; b=CxApWxyQ1MtU5gkkEE/gTBj76FiuaNhlc5/kHwus6i4CsuBo7KgB/gHk1daAjhFn0novIXmV/NlU05fV61lxB0y/rIzWJgyY2MFR7jJwdOGgTPC++ONGVHnRSoqxjS714zeyfM2q49V4FDHhu6e5EMY4p31w3M6sOtnwQSLT1AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744083239; c=relaxed/simple;
	bh=BIWsEMn2fRKec8Ap3iHaJPpW9wj7oHxaUW/9vNAjTbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tGXa4ALSeBWpI6APTZhrTZc2AaXyYS3IO85LMLN6oyIF2mYNY6Pug/zbtFj9Z7WOJY3TogRyT8aB00U2X6jHtNzYyc0tfKUaO+SSHf8uOsTLGi2c1kfu8gVXFGBMVUJu1VHo49iKSNiKkbW5a+sRN51uds4TsIqHd2TnQC3q1XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6o9b+Qy; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7c7913bab2cso116638685a.0;
        Mon, 07 Apr 2025 20:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744083236; x=1744688036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=udL5m0T4dkNFRE3vfDH2Xja10VJVdeF3f1lm63u5woM=;
        b=L6o9b+QyyV4FA/4CzyPOKYF3pMu5Ffwrshy/Qyr3M0ImEUqzXQQ3tquUSgcWgX1zaI
         M2Iu+nLbPZJ0Lmm16mMSBGJTarPgAelkWu6ToJBHtFVKvSHYLyrSDuHw+rUOQOYZwoXk
         FFgy2CNeFyosaMuBJ7etH+RfobayLZmp+fgpsA61Dr8MElVhwzu6p2xR+EN7HE0Fv1v+
         W8felJT1+A/NL1Kqd8F2GBbdfyewtStV2//UiwIjxafCIsuGv+s4S3dvd8i4Q/G7DMwz
         cYm3FOwCzcZ3lfmLZ143uC62jVDGoJfDsVzcDioztkbIOtU3XQPRvRUntqdZZQP0GPHB
         7fSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744083236; x=1744688036;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=udL5m0T4dkNFRE3vfDH2Xja10VJVdeF3f1lm63u5woM=;
        b=jHh3cS5oX5NFNg1Iwo/6JEjCNAFBx9BDM8WCgfuaV3whVIqe2wvpWKiv0mpLwtJcHS
         2n7OXS3IAihwbuRIeUmQxDH+2n3atkTVp+2CTbl+NoSyV3N2iDZrjgKmNKKwuSsDgdCt
         wzzbmTtDk5Hw/LvB99g1vgeuU7YaE9u+5s4lxa5NHgIHosmRnymuwaJViqZ2rPuj8ReH
         fkhNcltSbKDuAEfi+IVOTboL50xCQjEDtRym/HtXGWobJmFQd+hyOOR9Be6NFDKgW3SN
         EqbpNdixddVxD/OtWxblHPdxvwsEy3MA7KVqN5CSy5w9Iw7YKpXxWD9w0Sa53FlBmLix
         NeXA==
X-Forwarded-Encrypted: i=1; AJvYcCVRyG44OuqLoZJjGfhK2YDZB13KMKEL2471o98TxIYyoWOh9w3JY5q8tkmbVYL5BJjEAOzSXDdce4LIYhA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Lb0+h/ofJHnYH++SLoRyQLPQjMNltx7yUY7USze/ZbXn5I68
	C3FzfzK/b8ufdVY58Ug+Vj7+eQkS05b7BDGVxTj7VrBfw+NsJRqb8XN/nKItbY8=
X-Gm-Gg: ASbGncu8k7Dqt9xF0Mv8nTk7/aYEWjQp8QHSJTvuPTSqEeFjaUo/jKkuYyGLOaRrfbP
	P8fN3SgJy/vHBGN1czYN8hOF22xtKXs2heE88rJWekdhDXdhzH5I9n9kqElsR2Bxnq/pjcYjwjT
	NMg77WsuxnKzOT7udYxH4J0FhhQ55e2mTa9KMZWQF760ysn1pUs4enhXwqorEW5BMbG+cBU4HzD
	EJbStR1s3TdwUnE3Ui5JA3V8OJF4yU5Ctb0QIaFbNOQ+xdNV5vPptq2WHvQ4C2Cz5O9fCfRG8n2
	IO2+MRmIHh3om0zYLuwys0sS2ZHW3v1zBhb2MdVQGcgZ5ZnBw8Jg8UA5IoEhdiR5YLIUMA==
X-Google-Smtp-Source: AGHT+IFbSNCZz6PDdSSJYNZI+3L9Qa0eWY+HBYRvkaZkya89BklnMzisBU8bwvxrFsSIGC4xpS3rYw==
X-Received: by 2002:a05:620a:4252:b0:7c5:49c9:e4ae with SMTP id af79cd13be357-7c774d6543emr1863453985a.32.1744083236402;
        Mon, 07 Apr 2025 20:33:56 -0700 (PDT)
Received: from theriatric.mshome.net ([73.123.232.110])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c76ea82d48sm692759585a.101.2025.04.07.20.33.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 20:33:56 -0700 (PDT)
From: Gabriel Shahrouzi <gshahrouzi@gmail.com>
To: Coly Li <colyli@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	kernelmentees@lists.linuxfoundation.org,
	gshahrouzi@gmail.com
Subject: [PATCH 0/2] bcache: Fix symbol visibility and type assignment
Date: Mon,  7 Apr 2025 23:33:20 -0400
Message-ID: <20250408033322.401680-1-gshahrouzi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 ensures bcache_is_reboot is properly declared along with the
other forward declarations.

Patch 2 removes incorrect cpu_to_leXX conversions for assignments.

Gabriel Shahrouzi (2):
  bcache: Fix undeclared symbol warning for bcache_is_reboot
  bcache: Fix warnings for incorrect type in assignments

 drivers/md/bcache/bcache.h |  1 +
 drivers/md/bcache/super.c  | 12 ++++++------
 drivers/md/bcache/sysfs.c  |  2 --
 3 files changed, 7 insertions(+), 8 deletions(-)

-- 
2.43.0


