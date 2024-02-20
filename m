Return-Path: <linux-bcache+bounces-280-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B71DC85BD0F
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Feb 2024 14:22:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 265021F227D6
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Feb 2024 13:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 025F06A329;
	Tue, 20 Feb 2024 13:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IOil34ly"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2ADE6A038
	for <linux-bcache@vger.kernel.org>; Tue, 20 Feb 2024 13:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435324; cv=none; b=Hgya/8cU17qpqZS/4ENOujrVfPJhAlnjJe0ml2CL5KUbBsTAQ69Smq25mR4NyZa7d0f05lC0XEy+h4FDkw/2Xsov6ezg/1pwWFwhFAzeJG2K/2dmJzPtHONpIbj8zDxoYDBIBkZkilPKpEVRhSpiz89AV52ABIl1JkOxBeuVn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435324; c=relaxed/simple;
	bh=3q84UebxO+IhnMV8qY+OCVsLMfCwqQIckMDPCnOjIso=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hoP3ChLgdqxCpTaPxA4n7Xx4eiKqS4mAwr6hCyDdcP5kQAuQJt5jFcj9i4Ur5wD79mciQ617GoOGVb7055jWrNZ4vi1++vk0S5Mj9fLBQot6f78qVswGuDT1uwGTpdInd5Ni6G4iTUsCBH2Azi64/gAG7MN0+UBPb7Iy13MLOUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IOil34ly; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1db8f32cae5so7457205ad.1
        for <linux-bcache@vger.kernel.org>; Tue, 20 Feb 2024 05:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708435321; x=1709040121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HEAQQIO5cXmeHaxWtI/kIw0AxsNxruezROUdauKPKd8=;
        b=IOil34lyMm0y3l5Ymx6h57i6MAEgWrDlWIh4Aap2R4/s5TUCR7WtL1u0sE7g43esRR
         uJG7aTC2wFa1cStK2uUPibUS6PAUC8sXTXFVaXQSrNMsNLw5ym1y0acgrgNCD6ECjYz5
         9F6OMnQD8HJwGOW2J8hbhvEtP0lxb9Zl9aEWGZ1rv0bXSYCYOyPK1Kj2TqgOHtiX7/ER
         OsmmU5rCpG3EvdquqfbkzJZu5dL5r/IP2nt/EQqXKRk+b7fjAZvBwZ97TsXsD9HDC5SW
         teb0Dq8RtY1yS0xhepPbVp8xlsDfYJehM7AsbUABdAfsy3KiPWx8u98Pci2ozJSbxQJd
         dMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708435321; x=1709040121;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HEAQQIO5cXmeHaxWtI/kIw0AxsNxruezROUdauKPKd8=;
        b=BaO6flHZQ03EBRx2d4E2FusMTgZfuE3g9fGdE38RW51gEvw8vCsqIdaOmhEYvd3bSY
         TO48aXwDurvoVVoLu7DoMh1qj+LT8VIxH5sdHu+gLC2xLPvRiLt44CN8Ofj68WiEyzbC
         qKa8+/nMtWusl4pz43sHrOaSelMvQRFX4w90ygEOstyY2fThrPt7Qq3nk5/Rf6x0rb52
         dbwU+cyPjuBJAf8vQtTjP1UeTVg39ge+68gQNVkcudkVzUXVWHLTfvSYIUR4+OxeS3ST
         Puv4fwppE8hoDJ9xzr5OTVYoIhx6gSrQRvUiJW0kMzNjkA1L5y6GoK+AEwZLlNBdqv4y
         K7sQ==
X-Forwarded-Encrypted: i=1; AJvYcCVuOjK3434tabkgoYKIpyJ/3s7coyxK43+sNCNW/n182pNs1bDfD9rYDtRi69QTqj6n5tbAY1PyVuGOLDPKvk46iVRSsXcp61gNf29W
X-Gm-Message-State: AOJu0YxI3cO9+TSrUnqtm3DuJ2+WZ0mCdhv+ydX4BkOURYM2AOh2T41v
	to130UMPR7jUAaFxTNi8uZrw0ju+QQPFmLHAlRq6Pr7o043X5ecAAFrCCvuYtuyt1aO/2fm6SS8
	/
X-Google-Smtp-Source: AGHT+IEMwWNUM0V6Qdc3mCEsLOi+xgsjqIc+o1/9KK8l9wrn0nGXqQ1ot4iyhmAMYT1vnSnW2SKzWg==
X-Received: by 2002:a17:902:8681:b0:1db:55c2:4a3a with SMTP id g1-20020a170902868100b001db55c24a3amr13335822plo.6.1708435321497;
        Tue, 20 Feb 2024 05:22:01 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id iw11-20020a170903044b00b001db5e807cd2sm6188911plb.82.2024.02.20.05.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Feb 2024 05:22:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Coly Li <colyli@suse.de>, 
 Vishal Verma <vishal.l.verma@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, linux-m68k@lists.linux-m68k.org, 
 linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-block@vger.kernel.org
In-Reply-To: <20240215071055.2201424-1-hch@lst.de>
References: <20240215071055.2201424-1-hch@lst.de>
Subject: Re: pass queue_limits to blk_alloc_disk for simple drivers
Message-Id: <170843532016.4095460.3703902225081924718.b4-ty@kernel.dk>
Date: Tue, 20 Feb 2024 06:22:00 -0700
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Thu, 15 Feb 2024 08:10:46 +0100, Christoph Hellwig wrote:
> this series converts all "simple" bio based drivers that don't have
> complex internal layering or other oddities to pass the queue_limits to
> blk_mq_alloc_disk.  None of these drivers updates the limits at runtime.
> 
> Diffstat:
>  arch/m68k/emu/nfblock.c             |   10 ++++---
>  arch/xtensa/platforms/iss/simdisk.c |    8 +++--
>  block/genhd.c                       |   11 ++++---
>  drivers/block/brd.c                 |   26 +++++++++---------
>  drivers/block/drbd/drbd_main.c      |    6 ++--
>  drivers/block/n64cart.c             |   12 +++++---
>  drivers/block/null_blk/main.c       |    7 ++--
>  drivers/block/pktcdvd.c             |    7 ++--
>  drivers/block/ps3vram.c             |    6 ++--
>  drivers/block/zram/zram_drv.c       |   51 +++++++++++++++++-------------------
>  drivers/md/bcache/super.c           |   48 +++++++++++++++++----------------
>  drivers/md/dm.c                     |    4 +-
>  drivers/md/md.c                     |    7 ++--
>  drivers/nvdimm/btt.c                |   14 +++++----
>  drivers/nvdimm/pmem.c               |   14 +++++----
>  drivers/nvme/host/multipath.c       |    6 ++--
>  drivers/s390/block/dcssblk.c        |   10 ++++---
>  include/linux/blkdev.h              |   10 ++++---
>  18 files changed, 143 insertions(+), 114 deletions(-)
> 
> [...]

Applied, thanks!

[1/9] block: pass a queue_limits argument to blk_alloc_disk
      commit: 74fa8f9c553f7b5ccab7d103acae63cc2e080465
[2/9] nfblock: pass queue_limits to blk_mq_alloc_disk
      commit: 2cfe0104bc1b4a94f81e386f5ff11041f39c1882
[3/9] brd: pass queue_limits to blk_mq_alloc_disk
      commit: b5baaba4ce5c8a0e36b5232b16c0731e3eb0d939
[4/9] n64cart: pass queue_limits to blk_mq_alloc_disk
      commit: cc7f05c7ec0b26e1eda8ec7a99452032d08d305e
[5/9] zram: pass queue_limits to blk_mq_alloc_disk
      commit: 4190b3f291d9563a438bf32424a3f049442fc3a5
[6/9] bcache: pass queue_limits to blk_mq_alloc_disk
      commit: b3f0846e720ee59291e3c5235f8a46e70dbc652c
[7/9] btt: pass queue_limits to blk_mq_alloc_disk
      commit: 77c059222c31b0480c61964f361b28a4ce111e52
[8/9] pmem: pass queue_limits to blk_mq_alloc_disk
      commit: c3d9c3031e18f145d8a12026d4d704125fe901ac
[9/9] dcssblk: pass queue_limits to blk_mq_alloc_disk
      commit: af190c53c995bf7c742c3387f6537534f8b92322

Best regards,
-- 
Jens Axboe




