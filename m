Return-Path: <linux-bcache+bounces-229-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE785835659
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:37:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7349DB2171B
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 15:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53D9374E9;
	Sun, 21 Jan 2024 15:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M2CPQM6v"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99651273FB;
	Sun, 21 Jan 2024 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705851417; cv=none; b=fOD/cLLhhb5YOE2cmmUdtFSWK/Di8EnplZmOfvvZRFn0ZxeBdJWIytaXs5RASpc7XSWz1Cot9P0o6f5LoN2+GcnxDoHn0LgUpKxbELnMzxnufANjpxxWJeXXWdpbs6O/xj/mkRIJpKLgIgZdAczCIem5j/9xCW/XDK2LsTXhuAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705851417; c=relaxed/simple;
	bh=OToNoS2KhWjwJ7oKMtu9Y/Gf1v1EhBU5bWep/eGedAE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=O5AiaUGW+PyMZazfHlXGexJbVf4UOafTY0osIUJA4HEL5dricNXODtoob9sS05BzxBeFo9bxqDZiUAYuhMihRwepfSHOFca4jzgc617Fb4tp3PV8yxWJPBZ4ejPwBswIiMRyPksl/hB+b2IYn6J/V/1j5klo+rCx5K56/5nZkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M2CPQM6v; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-28bbe484bc0so602697a91.1;
        Sun, 21 Jan 2024 07:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705851416; x=1706456216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vVHG+8xKK4bDOVD38QzrtIW6oL2Yuwi1GWqKNOlEnpA=;
        b=M2CPQM6v6CQ0bwgEa/ozeNsohQNaKJnweQkK9zE5tGglkbC4ZAD27D0NO7DkSqtU/u
         OHpDVNuZBNqODO+U98cvwzaH45QnVkH7hbBJknShy50vPwLsCWMD2DGQZ828MHzlk7Hl
         NamIk4nuebIGL90ihSBcuEAdSq24AaSGvmlb4Omzu3GKnYOOZJM4W3ObobtWYl3WP6WH
         L791DoA8aAcxp8R6fM6qHatnCDM6nYK3hPOVKFT2P0SNmN35fRgLJujTfjF4AFa7qNEM
         Z3mkee5sQSf4S14SIRoqrvfiDDa/rxwz8b2FGK51zu1/Rky/mVw+IU+l3dgnVCNSTRsN
         MQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705851416; x=1706456216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vVHG+8xKK4bDOVD38QzrtIW6oL2Yuwi1GWqKNOlEnpA=;
        b=FtsXIuSGZgUVwE1v//gmmuhwvoZiBPw6dVyEew7wnWY8s+kNLLzITiaYek93RwfCL2
         2YLgAOhSmUpyfQ01xLzqc9ADTyAbwyfNtgV95EhNQ4OWmfWwPeQ7WlZeTUD0ecc6ofko
         1fvAgeerqZaJYtz9x95QsUF9Ta+9LK0DaEFdpckXLJAToVcpuCAuO4xszJKsvmPaOdpC
         NJuEK372JzcnvERIFpysRwl57V0xUkh88dEQDAyc4gwAu4I+6u1hcb4k/31DO7yW0LHy
         CkWDAnEcIzDZ3Z/xczdOwZyS/QY6cz5/yTeSn9jq9srHEw6grnnYEBPjdpIBS1J+uNat
         gn/A==
X-Gm-Message-State: AOJu0YzUvrIXqlI3b+2h5aTRN6AhfqzzqNXqSJUPLyMRZ8YAS4DMjeyN
	sAe/DsoBgNwj2v3jqRw1BNjNU8XuW6qMS3CoTagfT+98bXpPZgto
X-Google-Smtp-Source: AGHT+IGeE84l68Vra6WCZ39i7YzXJKVHPaFYFqpkJTmi29/+geppKxidhdiRykQrAd7m8N/mN4/V3A==
X-Received: by 2002:a17:90a:46c7:b0:28e:3989:c49f with SMTP id x7-20020a17090a46c700b0028e3989c49fmr3694917pjg.1.1705851415960;
        Sun, 21 Jan 2024 07:36:55 -0800 (PST)
Received: from localhost.localdomain ([140.116.154.65])
        by smtp.gmail.com with ESMTPSA id sv13-20020a17090b538d00b0028d8fa0171asm7744347pjb.35.2024.01.21.07.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:36:55 -0800 (PST)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: colyli@suse.de,
	kent.overstreet@linux.dev
Cc: bfoster@redhat.com,
	jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 0/5] Optimize number of comparisons for heap/heapsort implementaion
Date: Sun, 21 Jan 2024 23:36:44 +0800
Message-Id: <20240121153649.2733274-1-visitorckw@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

The existing implementations of heap/heapsort follow the conventional
textbook approach, where each heapify operation requires approximately
2*log2(n) comparisons. In this series, I introduce a bottom-up variant
that reduces the number of comparisons during heapify operations to
approximately log2(n), while maintaining the same number of swap
operations.

Thanks,
Kuan-Wei

Kuan-Wei Chiu (5):
  bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
  bcachefs: Introduce parent function for sort_cmp_size()
  bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
  bcachefs: Optimize number of comparisons in heap_sift_down
  bcache: Optimize number of comparisons in heap_sift

 drivers/md/bcache/util.h |  23 +++++----
 fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
 fs/bcachefs/util.h       |  23 +++++----
 3 files changed, 98 insertions(+), 57 deletions(-)

-- 
2.25.1


