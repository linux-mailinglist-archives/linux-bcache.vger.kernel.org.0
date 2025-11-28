Return-Path: <linux-bcache+bounces-1278-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F61C913CA
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 09:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7AD1B343FAC
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Nov 2025 08:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 625FF2E7F25;
	Fri, 28 Nov 2025 08:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dC2IxDOR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012B2E718B
	for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 08:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764319113; cv=none; b=iFjXHyHwqsBapfh5y0SJBiZVFDjwi1URlkb2nP6w3QD9HZ5MjooBLbTZB1xl+a2xao6e8ZPashcYpFUnDnGqmBIkC8PqncTUB3bhTsqCpW1ehPLzLOL7H3ZFJclzT/EVc47gIqwcAc921XBs6xcF9hlFLTCagCpXPJyYxswzd2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764319113; c=relaxed/simple;
	bh=mG04EOy5shg0G6MHF6boM7DuHGiLByU6HW/XuA5FyN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jLR+qxRQ0ksNth/Vr4vbLJRGTiDhTdIrgp27RqyKXn+xHWEeFep5YyPt+JkcafwLZOB5eQdKE9mwim0yEnMHNz/suU0uFsA+mdvE6zGMZzsAW+qLkZ+59twcRIAeljQ+T5LtFWYLo8qJ45XyumsIDF9F3ndgywVPJB1Ef4612FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dC2IxDOR; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee158187aaso17505131cf.0
        for <linux-bcache@vger.kernel.org>; Fri, 28 Nov 2025 00:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764319110; x=1764923910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=++QMIe2Gzi7z7FeXSAmSiuqg8P1uQ1lVTlMI6i3m06g=;
        b=dC2IxDOR0WeEmPZSlsUxwDLBGMsc+fIeXUYA+M+8wTeUPkh4BpLsVKWiIWaKfxtLNj
         s30DMr23fbEbBnmdth3SK0f8HTjXmqF+jpfglihhy6alcBMQrRfCQwWecd47M5pFVdI/
         UaNo6JCtvgYcDq7wVEFMYbujCkDcBTDPlacvfh1hsifnN4b8UIzOuIgib4dpdhUTJJbG
         2+WU1qaSortVni3Vwgk8eNvqX3pBqtlrAno69ovaRZ5lCGSvCGW7IcUP7pQpFuOWuyB3
         rVhw+SFUFjSr/dXCy/9Eo2Wo7ImEm0q7EpnxaFhaTiOJ4U6PHqK+EswOoX5dW4cRWPYp
         bnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764319110; x=1764923910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=++QMIe2Gzi7z7FeXSAmSiuqg8P1uQ1lVTlMI6i3m06g=;
        b=AbYxZfWJCf/o48bIcfxh1j+3gxA8iZ1EXiMOvf/ZjV/OQaLG/MuD6mhyW8+wyWI5Rl
         mcdjCF2FmRE7iR0TUFcS0cg34NNVo4oaPDMYam9mUsZwT203b5B0dpi39M9J70ymMQBm
         77wYw6NTb3B27++5umak9cFGewr+xM9Uz+6YF//6paV9QsFOYW9WsBF8jCuTIflpTesI
         6cpm5BKhUVc4+zaE8apsQEIOZLevG5WzQj+XzGvZLumnrKgoyC4kEeDvdVM8e2bKpadR
         +0RUdKCdsrEPyNrzypYGM4KwM0ALYARl5emFM3qAxwboYGYfBzxfVmv+AhPmGo3xEIzM
         X3pw==
X-Forwarded-Encrypted: i=1; AJvYcCWoUXPHf8KhKy1vXXONgWr5pMJ6va22M2ohpiXL7dqpEIGvZlfsQR0o9n+k2r02Byf3sSu8ijCJ1svlU/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3O0kzejJ0lzURtCJYhyPknWVa1sUfflz+vvlmKWrb8BBAh9KW
	omdBc6fdMZMkd2BHZkmndGwq89lwrArN6yWbah1541D/1/mMBIbxgV5MF+gccxF38yefNY4XA4L
	Je32Mv1ecwDcMaj87URBl7nUeQxD8Bdk=
X-Gm-Gg: ASbGncvjxg2y/iOs2txhlXEn+vCzytv9uJeQCX/b4v5IDoLRGjmQ+rUf/j1uk1T5PKW
	hoFFcylmSlezlz2JQQfyex9cKTH71Eau9xgb0XzQLDCXEqAes1ePZCkfMBwJVF7XIrBJZX4StDf
	PAp1Q7qYyEcjZ5xLAh2tcUUu1AFfVh9YQSTEGks0f5a1+xxCJ+y7sfrPtUYeV+/39rJ+wxWfQwG
	tTFhGIwbFIzFoXVeErM1az3JzrtiBNIUcvkp6axIZOQbnNuhWiWK3SY+ygmlWo5SsUc4LU=
X-Google-Smtp-Source: AGHT+IEfh/pR5dVEp+MyGlS6Z0E5USpuJd+WqXIzQcqzstZI05ioUW/B3ey2i9/MpvyCwVsDk2BTTIWfhdBYNOpApmc=
X-Received: by 2002:ac8:5a4d:0:b0:4e7:1eb9:605d with SMTP id
 d75a77b69052e-4ee5883f99cmr321417371cf.11.1764319110284; Fri, 28 Nov 2025
 00:38:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Fri, 28 Nov 2025 16:37:54 +0800
X-Gm-Features: AWmQ_bkmQmYK3DJQjInSuzOGjciJ8sGZNWSCY3EbybUAu4bZJ47LIxlxmcK_q9w
Message-ID: <CANubcdUgYpxBqPrsOnFpGJK8S9DM46DT6hriu4kDckPMVzc-Fw@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Fix bio chain related issues
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:32=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Hi all,
>
> While investigating another problem [mentioned in v1], we identified
> some buggy code in the bio chain handling logic. This series addresses
> those issues and performs related code cleanup.
>
> Patches 1-4 fix incorrect usage of bio_chain_endio().
> Patches 5-12 clean up repetitive code patterns in bio chain handling.
>
> v2:
> - Added fix for bcache.
> - Added BUG_ON() in bio_chain_endio().
> - Enhanced commit messages for each patch
>
> v1:
> https://lore.kernel.org/all/20251121081748.1443507-1-zhangshida@kylinos.c=
n/
>
>
> Shida Zhang (12):
>   block: fix incorrect logic in bio_chain_endio
>   block: prevent race condition on bi_status in __bio_chain_endio
>   md: bcache: fix improper use of bi_end_io
>   block: prohibit calls to bio_chain_endio
>   block: export bio_chain_and_submit
>   gfs2: Replace the repetitive bio chaining code patterns
>   xfs: Replace the repetitive bio chaining code patterns
>   block: Replace the repetitive bio chaining code patterns
>   fs/ntfs3: Replace the repetitive bio chaining code patterns
>   zram: Replace the repetitive bio chaining code patterns
>   nvdimm: Replace the repetitive bio chaining code patterns
>   nvmet: use bio_chain_and_submit to simplify bio chaining
>
>  block/bio.c                       | 15 ++++++++++++---
>  drivers/block/zram/zram_drv.c     |  3 +--
>  drivers/md/bcache/request.c       |  6 +++---
>  drivers/nvdimm/nd_virtio.c        |  3 +--
>  drivers/nvme/target/io-cmd-bdev.c |  3 +--
>  fs/gfs2/lops.c                    |  3 +--
>  fs/ntfs3/fsntfs.c                 | 12 ++----------
>  fs/squashfs/block.c               |  3 +--
>  fs/xfs/xfs_bio_io.c               |  3 +--
>  fs/xfs/xfs_buf.c                  |  3 +--
>  fs/xfs/xfs_log.c                  |  3 +--
>  11 files changed, 25 insertions(+), 32 deletions(-)
>
> --
> 2.34.1
>

Apologies, I missed the 'h' in the email address when CC'ing
hsiangkao@linux.alibaba.com.

Thanks,
Shida

