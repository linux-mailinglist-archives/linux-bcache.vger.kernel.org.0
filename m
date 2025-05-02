Return-Path: <linux-bcache+bounces-1018-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EA7AA6817
	for <lists+linux-bcache@lfdr.de>; Fri,  2 May 2025 03:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A30713B162B
	for <lists+linux-bcache@lfdr.de>; Fri,  2 May 2025 01:01:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFCD1EA90;
	Fri,  2 May 2025 01:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wKHqro6W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550978467
	for <linux-bcache@vger.kernel.org>; Fri,  2 May 2025 01:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746147684; cv=none; b=Tln+zGwwMoox7zIlRNzskDrm9BW3f1cZM+/NU+f99ROr+ekCAAA2IoqfkkUNmo8Br03KhY9OkHuCkmJRA/RkXG6Sqk3QbtEofftGbXuTv/9EAPnmBtQGu2QY/AKrEokn+WjCyrMApikPrAPFoY/BGC3N3KFyqMVcgKEtJM9LRTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746147684; c=relaxed/simple;
	bh=gvd2GD2xXrKNhMzzQeruUKC1LlGK97sJ0dgNzSL0w84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pCReHXj9raZHH4CswN/6bsK7LzjTXg2pPAT3M6wBgJSv8Jk1Udkrap4dIF/pKs/oQcG0pNYMrvo7AgiQBefaHgQeGes4EWQ3dDMwduFJ5T4qwav0yNRKRSmlccOKjXpEEt96DnnumkLKn8fLdZ5NVAVjOs7cUNGDZe7T9PqQM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wKHqro6W; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5dbfc122b82so4945a12.0
        for <linux-bcache@vger.kernel.org>; Thu, 01 May 2025 18:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746147680; x=1746752480; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HD+PTGZkA9iLfm6oTv9038Oe42d2T75V0CgA/Q0XRaY=;
        b=wKHqro6W/uvCH4frCk/B4SpebAfRN2p8OhXmjUXnH61efNpiLzedveIV4h3quqtSlm
         SaSrS9iVSw2rZkd7eWukIbD4OP4uX+wlHmLcqYIZM9D1h+1XPDg1/eQN/hAJzE5kU7y1
         D8Htvt1Dz3RDks8PrPad86aTZ6ILRYLDDez6B8G13fadhbnCcwV2MlFAyAX+6npY4int
         9WsTb3X+DcxUTzDGHccfkuBpLaVaV5sUWMsWxhv5opAGrZn+AbxbIUT9CabFq8InEZFL
         6797bQlOTfyhJK9DItsyoEmjtg2ZgVrDvk82vX6lWun4+3JLq6Vc7MdJy3PMVftLGYlg
         HTVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746147680; x=1746752480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HD+PTGZkA9iLfm6oTv9038Oe42d2T75V0CgA/Q0XRaY=;
        b=OQaRcX7vpwVT9tZyHUYt3ZXD+ugRPAgzkGyxdQnfkAGnHY1LbCdlt5wPtf750QqbqL
         i7alx4kMJ7yeW2c/XTYBsxr0p+ggIk1Yf5t3wQ0ayRP3BMtBRhSf7GdfreSjBw/VlIFF
         uB1WYcH8rGtjxQbIPGevf47PziFrzX+9vLirhT3IGdWNToy/IfnZSnwEPW0GaeKpKU6l
         7P50NnkGvGsRMq+BRX5vjE/W6KFqbkpyZH1TphxdbWpJA/wby0IDM6TfSDgm4YOcVOS1
         5cMrYt1DHbLo4Bh4I1o3fwz345Hxl2iSiCQKMnnKX0RRL6OJOis2ob8sjnVrCQJqrPMc
         uNpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQIKRudxyp0Mtxia+Fag22ao+yWZpZ1chpPgoFAntj5X4yCBL35CoXBwplFkyyAidGC6FTcJ3GhK3UjYk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt3qM1wQ9tA3NFre6uyTgqHJ6JUFR9Jctqqof/SCHYatWqVMiB
	u+DTf7PtOsK0DwaX9X4YQrkTcDOg3u0iN7r5lpBCToCM/yKVocBuUOBzD6uWLqw/37cgn3UWzpF
	K5GY7F47/zE7yT/s6lzykH8kdi3V9QFzRAgra
X-Gm-Gg: ASbGncttzluzwzz13PiCFWKGOzkGk4JFXk0pM2wIYSQHk4hhKjjP/1mFJzAZomHbb1A
	4QEgKOkJPN7Z7Q8TDI2kS4IDn3aHKvf7yxusaQJPnCzbbuwiyDROxeQ94CdR+0jpocNXqDkhIoB
	mMS7Y5x9gdTdRCogcp3VdH0PODzf2HLh8Sjuq4wF6FsqMo58oJqulo
X-Google-Smtp-Source: AGHT+IGirdnMeXlHgTNgIj1bBHORgGg2+pBzj40rrhOlDU4URaoSJ7fmgoY6wWeno4VkrgcHyPY4dWLQhQwDGhQW5Wk=
X-Received: by 2002:a50:c018:0:b0:5f7:f888:4cb5 with SMTP id
 4fb4d7f45d1cf-5f918c08662mr126067a12.1.1746147680261; Thu, 01 May 2025
 18:01:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
In-Reply-To: <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Thu, 1 May 2025 18:01:09 -0700
X-Gm-Features: ATxdqUHwaIpwIsV1E2I-r5mXH4BECy6UyfKf5GmrsNs4J8Qr-KQ1zOt1WNuhbeE
Message-ID: <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <i@coly.li>
Cc: Coly Li <colyli@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,

Please disregard the test results I shared over a week ago. After digging
deeper into the recent latency spikes with various workloads and by
instrumenting the garbage collector, I realized that the earlier GC latency
patch, "bcache: allow allocator to invalidate bucket in gc" [1], wasn't
backported to the Linux 6.6 branch I tested my patch against. This omission
explains the much higher latency observed during the extended test because =
the
allocator was blocked for the entire GC. My sincere apologies for the
inconsistent results and any confusion this has caused.

With patch [1] back-patched and after a 24-hour re-test, the fio results cl=
early
demonstrate that this patch effectively reduces front IO latency during GC =
due
to the smaller incremental GC cycles, while the GC duration increase is sti=
ll
well within bounds.

Here's a summary of the improved latency:

Before:

Median latency (P50): 210 ms
Max latency (P100): 3.5 sec

btree_gc_average_duration_ms:381138
btree_gc_average_frequency_sec:3834
btree_gc_last_sec:60668
btree_gc_max_duration_ms:825228
bset_tree_stats:
btree nodes: 144330
written sets: 283733
unwritten sets: 144329
written key bytes: 24993783392
unwritten key bytes: 11777400
floats: 30936844345385
failed: 5776

After:

Median latency (P50): 25 ms
Max latency (P100): 0.8 sec

btree_gc_average_duration_ms:622274
btree_gc_average_frequency_sec:3518
btree_gc_last_sec:8931
btree_gc_max_duration_ms:953146
bset_tree_stats:
btree nodes: 175491
written sets: 339078
unwritten sets: 175488
written key bytes: 29821314856
unwritten key bytes: 14076504
floats: 90520963280544
failed: 6462

The complete latency data is available at [2].

I will be glad to run further tests to solidify these findings for the incl=
usion
of this patch in the coming merge window. Let me know if you'd like me to
conduct any specific tests.

Best regards
Robert Pang

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Da14a68b76954e73031ca6399abace17dcb77c17a
[2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f9180f

On Mon, Apr 21, 2025 at 6:44=E2=80=AFPM Robert Pang <robertpang@google.com>=
 wrote:
>
> I conducted a 24-hour fio random write test on a 6TB local SSD cache usin=
g
> 256kb buckets and the following parameters:
>
> ioengine=3Dlibaio
> direct=3D1
> bs=3D4k
> size=3D12T
> iodepth=3D128
> readwrite=3Drandwrite
> log_avg_msec=3D10
>
> The results show some improvement in average write latency, resulting in
> increased IOPS (from 11.8k to 17.1k) and throughput (from 45.9MiB/s to
> 66.7MiB/s). However, the maximum write latency exhibited a considerable
> degradation.
>
> Before:
>
> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D14917: Mon Apr 21 =
06:50:45 2025
>   write: IOPS=3D11.8k, BW=3D45.9MiB/s (48.1MB/s)(4035GiB/90000002msec); 0
> zone resets
>     slat (usec): min=3D9, max=3D4003.9k, avg=3D74.37, stdev=3D3734.09
>     clat (usec): min=3D2, max=3D5319.2k, avg=3D10815.66, stdev=3D46998.95
>      lat (usec): min=3D239, max=3D5319.3k, avg=3D10890.15, stdev=3D47167.=
41
>
> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:381=
138
> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:3=
834
> /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:60668
> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:825228
> /sys/block/bcache0/bcache/cache/internal/bset_tree_stats:
> btree nodes: 144330
> written sets: 283733
> unwritten sets: 144329
> written key bytes: 24993783392
> unwritten key bytes: 11777400
> floats: 30936844345385
> failed: 5776
>
>
> After:
>
> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D15158: Mon Apr 21 =
17:22:13 2025
>   write: IOPS=3D17.1k, BW=3D66.7MiB/s (69.9MB/s)(5859GiB/90000004msec); 0
> zone resets
>     slat (usec): min=3D7, max=3D469348k, avg=3D46.71, stdev=3D20576.47
>     clat (usec): min=3D3, max=3D560660k, avg=3D7453.04, stdev=3D458965.53
>      lat (usec): min=3D313, max=3D560660k, avg=3D7499.88, stdev=3D459426.=
83
>
> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms:540=
350
> /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_sec:3=
235
> /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:22304
> /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:719097
> /sys/block/bcache0/bcache/cache/internal/bset_tree_stats:
> btree nodes: 239590
> written sets: 466470
> unwritten sets: 239587
> written key bytes: 36120573032
> unwritten key bytes: 16776624
> floats: 95606253613657
> failed: 4522
>
> Further investigation pointed to the 10ms sleep time being too restrictiv=
e for
> this intensive workload. Examining tail latency percentiles outside garba=
ge
> collection revealed that a significant number of I/O requests remained in=
 the
> queue for extended periods. The observed percentiles are:
>
> Percentile Latency (ms)
> P85 10
> P86 11
> P87 13
> P88 16
> P89 22
> P90 36
> P91 60
> P92 104
> P93 174
> P94 231
> P95 257
> P96 282
> P97 308
> P98 337
> P99 377
> P100 472
>
> This data suggests that while a 10ms sleep time might be suitable for lig=
hter
> workloads, it becomes a bottleneck under heavier stress.
>
> In consideration of the test results, I propose the feasibility of keepin=
g the
> original sleep time and min nodes per cycle, but also exposing them as
> configurable attributes through sysfs so users can tune according to thei=
r
> workload and latency SLO. I would appreciate your insights on this potent=
ial
> enhancement.
>
> On Mon, Apr 14, 2025 at 6:57=E2=80=AFPM Coly Li <i@coly.li> wrote:
> >
> > Hi Robert,
> >
> > Thanks for the fix up :-)
> >
> > > 2025=E5=B9=B44=E6=9C=8815=E6=97=A5 06:44=EF=BC=8CRobert Pang <robertp=
ang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > In performance benchmarks on disks with bcache using the Linux 6.6 ke=
rnel, we
> > > observe noticeable IO latency increase during btree garbage collectio=
n. The
> > > increase ranges from high tens to hundreds of milliseconds, depending=
 on the
> > > size of the cache device. Further investigation reveals that it is th=
e same
> > > issue reported in [1], where the large number of nodes processed in e=
ach
> > > incremental GC cycle causes the front IO latency.
> > >
> > > Building upon the approach suggested in [1], this patch decomposes th=
e
> > > incremental GC process into more but smaller cycles. In contrast to [=
1], this
> > > implementation adopts a simpler strategy by setting a lower limit of =
10 nodes
> > > per cycle to reduce front IO delay and introducing a fixed 10ms sleep=
 per cycle
> > > when front IO is in progress. Furthermore, when garbage collection st=
atistics
> > > are available, the number of nodes processed per cycle is dynamically=
 rescaled
> > > based on the average GC frequency to ensure GC completes well within =
the next
> > > subsequent scheduled interval.
> > >
> > > Testing with a 750GB NVMe cache and 256KB bucket size using the follo=
wing fio
> > > configuration demonstrates that our patch reduces front IO latency du=
ring GC
> > > without significantly increasing GC duration.
> > >
> > > ioengine=3Dlibaio
> > > direct=3D1
> > > bs=3D4k
> > > size=3D900G
> > > iodepth=3D10
> > > readwrite=3Drandwrite
> > > log_avg_msec=3D10
> > >
> > > Before:
> > >
> > > time-ms,latency-ns,,,
> > >
> > > 12170, 285016, 1, 0, 0
> > > 12183, 296581, 1, 0, 0
> > > 12207, 6542725, 1, 0, 0
> > > 12242, 24483604, 1, 0, 0
> > > 12250, 1895628, 1, 0, 0
> > > 12260, 284854, 1, 0, 0
> > > 12270, 275513, 1, 0, 0
> > >
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms=
:2880
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_s=
ec:133
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:121
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:345=
6
> > >
> > > After:
> > >
> > > 12690, 378494, 1, 0, 0
> > > 12700, 413934, 1, 0, 0
> > > 12710, 661217, 1, 0, 0
> > > 12727, 354510, 1, 0, 0
> > > 12730, 1100768, 1, 0, 0
> > > 12742, 382484, 1, 0, 0
> > > 12750, 532679, 1, 0, 0
> > > 12760, 572758, 1, 0, 0
> > > 12773, 283416, 1, 0, 0
> > >
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_duration_ms=
:3619
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_average_frequency_s=
ec:58
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_last_sec:23
> > > /sys/block/bcache0/bcache/cache/internal/btree_gc_max_duration_ms:386=
6
> > >
> > > [1] https://lore.kernel.org/all/20220511073903.13568-1-mingzhe.zou@ea=
systack.cn/
> >
> >
> > I see the data, it makes sense. I=E2=80=99d like to see more testing da=
ta, e.g.
> > 1) Larger SSD (4T or 8T)
> > 2) Higher I/O pressure (randomwrite)
> > 3) Much longer time with high I/O pressure (24 hours+)
> >
> > Then it can help me to understand the optimization better and make deci=
sion easier. Of course it will save a lot of testing time from my side.
> >
> > Thank you in advance.
> >
> > Coly Li
> >

