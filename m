Return-Path: <linux-bcache+bounces-907-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53823A95A9A
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Apr 2025 03:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 204481895360
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Apr 2025 01:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDED18B47C;
	Tue, 22 Apr 2025 01:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IhjUrLf6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218DD10957
	for <linux-bcache@vger.kernel.org>; Tue, 22 Apr 2025 01:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745286289; cv=none; b=JQ00V6P4fyG2xbXVPxvi0E7q79C7nceAkoQkDsEEBHOQgxMt2WgAxOuGqvDjFQCB5/lSNApYgRQnspv5KTNVMcUK/IGZ5IgoTveWak7/P88oZ3fYP9CeMDn5HS8j6L4WCJv4r8USUmusl79+v67BQhAd9jfXbyoK3+Jmxe28/h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745286289; c=relaxed/simple;
	bh=Tt68OEL4azGC6m/6xr62maQB3WPfCC8dWgXMMvgJNrA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lix5P4DIcoWkeCFUE5sAOoSQBEfJod+c3yQSdfHe7P9qQNK39uDM5mtehTWY5ZDjaEqY5WLRzuEKhNK2/ps62xj7io9T4F8KDyxBw2HLzKhZ3nnfVpsVXbmKsu2esf/Y4dD49LNcIU+9mXsqlQL3aInyx8mj4HDPVmLYXWNEJ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IhjUrLf6; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5dbfc122b82so1590a12.0
        for <linux-bcache@vger.kernel.org>; Mon, 21 Apr 2025 18:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745286285; x=1745891085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hGipBmqjDKtDSuOjYuMgoT8+hK8013LTRO7ZW5j3pZQ=;
        b=IhjUrLf6q3NG1JH5xsv8qy6jpKm7HoxhHRzR0l1Ku6JxDE2xwwfDXQziJo3mnnvNdB
         FjMU20o2kTarJvT45fkaP5cr86sgbv/UsoW4gKEosCorMRM0wS9DVJLjlGBLYIGQbap1
         PCvqT51lySnpLP1NR0fdHnvGVctV+YmBxBqR4wcP2HQuxet3R1BICpV/2RHhcU1VykvB
         w8TA6Eg/8dcYp8qSOxUtWMDiQiRGPQkFG+W2D1Iy1EacpNjEzwotxcSdh5hXA4fNU8wp
         DLSSCWqVHv1cbI2+prM34GKyXYzvFcj9JimUilF78F3ngJ20LL3VC+DSdYK6XabSWEwR
         dVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745286285; x=1745891085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hGipBmqjDKtDSuOjYuMgoT8+hK8013LTRO7ZW5j3pZQ=;
        b=cresibdFtX96x0pdgjpl4mdLLuKb3jAKHiH3mA1NhEagZYUS2/kLIx+GoZnk2/IKOZ
         BMu3vQpQiU6dZhiRWL0TROLGrdpnVuf2ZBKVw/Ss+GdornkQGMk4MKJZPGYGDTcc9/RD
         uk6q6sE/LvpmgVYLlhk69N01IUSlqlrhFR7jiKoqVK5u4XqJ5EAFb8ZXHFALCJ7IgSYR
         w/jH2JkooP15HwGwtI8ADQ6qFhLmP10Z1tyy61wb7aVb7sfIv0pDnQN7LsDTZIvRZCBD
         VJ8jfc4HOVf7lYz0KIYQdvv+6oxVq+fP1prXXk7A+7Y+eyo1AbVo6ETJ4MHj7JzteGrV
         Ui5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbED8LPdM0g/GdeAz3zEq4zeT7aEck0x8kGKWh2cZ0kEokLbH1qNkV1h6eoc1KFpzGKS/B3mkAmT3fxfo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Codr198V/E4m5pA5bZ2NqmgsAozsSe41f/vhayDZe/nCPq1K
	isepOaWmQW1s1TAX0UtDrUVwq/k0QlyTeF2v43yJEJnu8vrA1QKSe6ZzjQCXCfO9vCEG1AGwCRj
	QMP1r4F/a3w4kQWxjSXu/hxGNz5pg7fpAgZNT4rEuQZAeZOLpH7AQp2Y=
X-Gm-Gg: ASbGncs/LaLv8CHxHQHPagtH+jiB/EFK34uiNFE4ATWLEJNsj9NCx/JJxVkj/eFzwzv
	4v11wrj62G08B3hn9J531Y/6KtbEvgekjqYfPTdqK9f8R3zF5MQzFmAbdQ8/kNWP+oqFMICttO8
	bIq4GAlU312qCWs9RC7/jJ
X-Google-Smtp-Source: AGHT+IE5oHG24BZQfKMkcoMuLXDqdCtAnInK4aCqdYYBz359QQxlTfT/Gh4G/bJvg+alHAKvXY3ocFhtOmqy5GHy6Mk=
X-Received: by 2002:aa7:c156:0:b0:5e5:ba42:80a9 with SMTP id
 4fb4d7f45d1cf-5f62899aed6mr259506a12.1.1745286285100; Mon, 21 Apr 2025
 18:44:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
In-Reply-To: <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
From: Robert Pang <robertpang@google.com>
Date: Mon, 21 Apr 2025 18:44:33 -0700
X-Gm-Features: ATxdqUHfM3SctCpzXRMgkTjCgfEAPUEtLvOhIvRcUoR-4h4f1vjbgyRCT5Icwo8
Message-ID: <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I conducted a 24-hour fio random write test on a 6TB local SSD cache using
256kb buckets and the following parameters:

ioengine=3Dlibaio
direct=3D1
bs=3D4k
size=3D12T
iodepth=3D128
readwrite=3Drandwrite
log_avg_msec=3D10

The results show some improvement in average write latency, resulting in
increased IOPS (from 11.8k to 17.1k) and throughput (from 45.9MiB/s to
66.7MiB/s). However, the maximum write latency exhibited a considerable
degradation.

Before:

latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14917: Mon Apr 21 06=
:50:45 2025
  write: IOPS=3D11.8k, BW=3D45.9MiB/s (48.1MB/s)(4035GiB/90000002msec); 0
zone resets
    slat (usec): min=3D9, max=3D4003.9k, avg=3D74.37, stdev=3D3734.09
    clat (usec): min=3D2, max=3D5319.2k, avg=3D10815.66, stdev=3D46998.95
     lat (usec): min=3D239, max=3D5319.3k, avg=3D10890.15, stdev=3D47167.41

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:38113=
8
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:383=
4
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:60668
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:825228
/sys/block/bcache0/bcache/cache/internal/bset_tree_stats:
btree nodes: 144330
written sets: 283733
unwritten sets: 144329
written key bytes: 24993783392
unwritten key bytes: 11777400
floats: 30936844345385
failed: 5776


After:

latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D15158: Mon Apr 21 17=
:22:13 2025
  write: IOPS=3D17.1k, BW=3D66.7MiB/s (69.9MB/s)(5859GiB/90000004msec); 0
zone resets
    slat (usec): min=3D7, max=3D469348k, avg=3D46.71, stdev=3D20576.47
    clat (usec): min=3D3, max=3D560660k, avg=3D7453.04, stdev=3D458965.53
     lat (usec): min=3D313, max=3D560660k, avg=3D7499.88, stdev=3D459426.83

/sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:54035=
0
/sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:323=
5
/sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:22304
/sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:719097
/sys/block/bcache0/bcache/cache/internal/bset_tree_stats:
btree nodes: 239590
written sets: 466470
unwritten sets: 239587
written key bytes: 36120573032
unwritten key bytes: 16776624
floats: 95606253613657
failed: 4522

Further investigation pointed to the 10ms sleep time being too restrictive =
for
this intensive workload. Examining tail latency percentiles outside garbage
collection revealed that a significant number of I/O requests remained in t=
he
queue for extended periods. The observed percentiles are:

Percentile Latency (ms)
P85 10
P86 11
P87 13
P88 16
P89 22
P90 36
P91 60
P92 104
P93 174
P94 231
P95 257
P96 282
P97 308
P98 337
P99 377
P100 472

This data suggests that while a 10ms sleep time might be suitable for light=
er
workloads, it becomes a bottleneck under heavier stress.

In consideration of the test results, I propose the feasibility of keeping =
the
original sleep time and min nodes per cycle, but also exposing them as
configurable attributes through sysfs so users can tune according to their
workload and latency SLO. I would appreciate your insights on this potentia=
l
enhancement.

On Mon, Apr 14, 2025 at 6:57=E2=80=AFPM Coly Li <i@coly.li> wrote:
>
> Hi Robert,
>
> Thanks for the fix up :-)
>
> > 2025=E5=B9=B44=E6=9C=8815=E6=97=A5 06:44=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > In performance benchmarks on disks with bcache using the Linux 6.6 kern=
el, we
> > observe noticeable IO latency increase during btree garbage collection.=
 The
> > increase ranges from high tens to hundreds of milliseconds, depending o=
n the
> > size of the cache device. Further investigation reveals that it is the =
same
> > issue reported in [1], where the large number of nodes processed in eac=
h
> > incremental GC cycle causes the front IO latency.
> >
> > Building upon the approach suggested in [1], this patch decomposes the
> > incremental GC process into more but smaller cycles. In contrast to [1]=
, this
> > implementation adopts a simpler strategy by setting a lower limit of 10=
 nodes
> > per cycle to reduce front IO delay and introducing a fixed 10ms sleep p=
er cycle
> > when front IO is in progress. Furthermore, when garbage collection stat=
istics
> > are available, the number of nodes processed per cycle is dynamically r=
escaled
> > based on the average GC frequency to ensure GC completes well within th=
e next
> > subsequent scheduled interval.
> >
> > Testing with a 750GB NVMe cache and 256KB bucket size using the followi=
ng fio
> > configuration demonstrates that our patch reduces front IO latency duri=
ng GC
> > without significantly increasing GC duration.
> >
> > ioengine=3Dlibaio
> > direct=3D1
> > bs=3D4k
> > size=3D900G
> > iodepth=3D10
> > readwrite=3Drandwrite
> > log_avg_msec=3D10
> >
> > Before:
> >
> > time-ms,latency-ns,,,
> >
> > 12170, 285016, 1, 0, 0
> > 12183, 296581, 1, 0, 0
> > 12207, 6542725, 1, 0, 0
> > 12242, 24483604, 1, 0, 0
> > 12250, 1895628, 1, 0, 0
> > 12260, 284854, 1, 0, 0
> > 12270, 275513, 1, 0, 0
> >
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:2=
880
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec=
:133
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:121
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3456
> >
> > After:
> >
> > 12690, 378494, 1, 0, 0
> > 12700, 413934, 1, 0, 0
> > 12710, 661217, 1, 0, 0
> > 12727, 354510, 1, 0, 0
> > 12730, 1100768, 1, 0, 0
> > 12742, 382484, 1, 0, 0
> > 12750, 532679, 1, 0, 0
> > 12760, 572758, 1, 0, 0
> > 12773, 283416, 1, 0, 0
> >
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:3=
619
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec=
:58
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:23
> > /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:3866
> >
> > [1] https://lore.kernel.org/all/20220511073903.13568-1-mingzhe.zou@easy=
stack.cn/
>
>
> I see the data, it makes sense. I=E2=80=99d like to see more testing data=
, e.g.
> 1) Larger SSD (4T or 8T)
> 2) Higher I/O pressure (randomwrite)
> 3) Much longer time with high I/O pressure (24 hours+)
>
> Then it can help me to understand the optimization better and make decisi=
on easier. Of course it will save a lot of testing time from my side.
>
> Thank you in advance.
>
> Coly Li
>

