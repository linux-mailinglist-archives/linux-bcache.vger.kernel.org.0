Return-Path: <linux-bcache+bounces-438-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03C0F8C4BEA
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 07:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62A041F22708
	for <lists+linux-bcache@lfdr.de>; Tue, 14 May 2024 05:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5370AB645;
	Tue, 14 May 2024 05:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U7gzmtY0"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972F14A96
	for <linux-bcache@vger.kernel.org>; Tue, 14 May 2024 05:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715663717; cv=none; b=QCAA3Kjpj3+iIFf3eTOb8Zrwb1vUAU31a6EVxjrTFaZG89LVsrTxSJErgcWP2gn1FygUs3P363wZyNUJl5lYaq7VYu7wrTZPGIuuUUiDAyy1KvzT9hBFSo7kJJRq7b2edpcIoiP6gMqu9g3IxO6CDuRHdfCJSjf5tCd4uV4ukmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715663717; c=relaxed/simple;
	bh=Lxcyt21y6fczFaaVQB9gnc2tw8TLsy7VkXfDDJkccXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u4NVr0T0eUY4+19dvyhn/E/FGCMasRSA/8y+c+I1kvlcQiEz3+7KMu1xz9b6R3tsf08v1Q01cgq6FyHiTb86zsa+xS01iQ6kyY0B4A1NoFUZ/6wfh/oF50QCA9ZdQ9gIeDLh9b8igAJ6cDtDkztaZxwoCEn6KOkszxGB8hgWfmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U7gzmtY0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-42012c85e61so122895e9.0
        for <linux-bcache@vger.kernel.org>; Mon, 13 May 2024 22:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715663714; x=1716268514; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bujwNGqFd+VCJ5oFYLZjIM2StSlbXM+L+O5WrqrG1PU=;
        b=U7gzmtY0PBkYmd+kff1mRtClHM4a1R6tI8SasLYo+TEDGy9bGERwkinJ/5sPXWdnKX
         P4vkuRRadyhdGz3pxJAUaOl1h7eLe0ODeU7aC2pmhxQqh1x4AcLAo+FS5+iQQcr/suyO
         Ymd/46A1IXnlvXtUjCrR8z08RDpkGphOZFkO+dJExSF5mffe9+ou+Z5gAiiuDquaKcN0
         QFf5dUcadow31ICNZgEdoSxBz8ryMEq9eruYrlLGzrv1oj+ZzpiIMlZchiuPeialUwx0
         DuTLxIOggc8ZMs5wTTKrfdwL18nNKvMuIR4U8bfQy68rpvkscpjMYxAD7+SAzlLI378l
         LdvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715663714; x=1716268514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bujwNGqFd+VCJ5oFYLZjIM2StSlbXM+L+O5WrqrG1PU=;
        b=UM/VmXr0Jlbp6xsgbRe6iktbq6FF/f+jEreQFGW7eh/IlUO4b9YC4cVGLYUTHEoaRZ
         4K9etjEsGFDdE891fR21m7vUhCDtBCYzboCxFAMjZHql0fU8BktbiHB1uDYkGPANwqlg
         sQyznjH7yRkdVY3lRCO6CxbeFaW4PquNsEgNw1ky35n6iaetuCm8GcIYG7v+R3nyjXk5
         0g2HcrfEcxzG3nUH6JUWEIwbaa+c/KdqAJQaggu9V1Oa3h4yr4s3/YyuX8j5zFz8cLT1
         fSIP/j0+dUqixUW0km4xEwfK++bal7voDDCqljFAyi+sFYxMW21oOcxu/tDjBV15bE2N
         W8ew==
X-Forwarded-Encrypted: i=1; AJvYcCUWmL4d7qpvldTREJHNgd+oVh+3XegO6DptBOPOAUSxwT0GyxEEE6CXVLQKefvvTm+3gsk75D1hKVbXWpiZq60xWlN5CFtAVDBzl3HV
X-Gm-Message-State: AOJu0YzXgUblrXES8/u485iWA3Nd6Crxp3I5m3rcpLbXpDAdToaMSshq
	7gmvIsicsAjCLVqjqju/WkJnYHIdcoGtSyVpQaei7zZAIBhXi+Og588Rf22jJBh27WSp798ZVzP
	abb76aJ0H19TJR1nD2GHntBjB9ATntCRh3fyVEdYziZz9jReIyROC
X-Google-Smtp-Source: AGHT+IFK4ugnATu+E8ebsElPQbVicI158srPc6sk9tftlhPRMVglBszKDms0+Ukr/R7MHJH9k7zn5uy6dhWDW1fwAi8=
X-Received: by 2002:a05:600c:3d9a:b0:41f:a15d:2228 with SMTP id
 5b1f17b1804b1-4200ebea389mr5350525e9.0.1715663713462; Mon, 13 May 2024
 22:15:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de> <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de> <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com> <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
In-Reply-To: <1B20E890-F136-496B-AF1F-C09DB0B45BE8@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Mon, 13 May 2024 22:15:00 -0700
Message-ID: <CAJhEC06FQPw3p7PHJpjN13CVjibbBVv-ZhwBb_6ducJP+XJ3gg@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Coly,

Thank you for your dedication in reviewing this patch. I understand my
previous message may have come across as urgent, but I want to
emphasize the significance of this bcache operational issue as it has
been reported by multiple users.

We understand the importance of thoroughness, To that end, we have
conducted extensive, repeated testing on this patch across a range of
cache sizes (375G/750G/1.5T/3T/6T/9TB) and CPU cores
(2/4/8/16/32/48/64/80/96/128) for an hour-long run. We tested various
workloads (read-only, read-write, and write-only) with 8kB I/O size.
In addition, we did a series of 16-hour runs with 750GB cache and 16
CPU cores. Our tests, primarily in writethrough mode, haven't revealed
any issues or deadlocks.

We hope this additional testing data proves helpful. Please let us
know if there are any other specific tests or configurations you would
like us to consider.

Thank you,
Robert


On Mon, May 13, 2024 at 12:43=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2024=E5=B9=B45=E6=9C=8812=E6=97=A5 13:43=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly
> >
> > I see that Mingzhe has submitted the rebased patch [1]. Do you have a
> > chance to reproduce the stall and test the patch? Are we on track to
> > submit this patch upstream in the coming 6.10 merge window? Do you
> > need any help or more info?
> >
>
> Hi Robert,
>
> Please don=E2=80=99t push me. The first wave of bcache-6.10 is in linux-n=
ext now. For this patch, I need to do more pressure testing, to make me com=
fortable that no-space deadlock won=E2=80=99t be triggered.
>
> The testing is simple, using small I/O size (512Bytes to 4KB) to do rando=
m write on writeback mode cache for long time (24-48 hours), see whether th=
ere is any warning or deadlock happens.
>
> For me, my tests covers cache size from 256G/512G/1T/4T cache size with 2=
0-24 CPU cores. If you may help to test on more machine and configuration, =
that will be helpful.
>
> I trust you and Zheming for the allocation latency measurement, now I nee=
d to confirm that offering allocation more priority than GC won=E2=80=99t t=
rigger potential no-space deadlock in practice.
>
> Thanks.
>
> Coly Li
>
>
> >
> >
> > [1] https://lore.kernel.org/linux-bcache/1596418224.689.1715223543586.J=
avaMail.hmail@wm-bj-12-entmail-virt53.gy.ntes/T/#u
> >
> >
> > On Tue, May 7, 2024 at 7:34=E2=80=AFPM Dongsheng Yang
> > <dongsheng.yang@easystack.cn> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2024/5/4 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 11:0=
8, Coly Li =E5=86=99=E9=81=93:
> >>>
> >>>
> >>>> 2024=E5=B9=B45=E6=9C=884=E6=97=A5 10:04=EF=BC=8CRobert Pang <robertp=
ang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>
> >>>> Hi Coly,
> >>>>
> >>>>> Can I know In which kernel version did you test the patch?
> >>>>
> >>>> I tested in both Linux kernels 5.10 and 6.1.
> >>>>
> >>>>> I didn=E2=80=99t observe obvious performance advantage of this patc=
h.
> >>>>
> >>>> This patch doesn't improve bcache performance. Instead, it eliminate=
s the IO stall in bcache that happens due to bch_allocator_thread() getting=
 blocked and waiting on GC to finish when GC happens.
> >>>>
> >>>> /*
> >>>> * We've run out of free buckets, we need to find some buckets
> >>>> * we can invalidate. First, invalidate them in memory and add
> >>>> * them to the free_inc list:
> >>>> */
> >>>> retry_invalidate:
> >>>> allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
> >>>>        !ca->invalidate_needs_gc);
> >>>> invalidate_buckets(ca);
> >>>>
> >>>> From what you showed, it looks like your rebase is good. As you alre=
ady noticed, the original patch was based on 4.x kernel so the bucket trave=
rsal in btree.c needs to be adapted for 5.x and 6.x kernels. I attached the=
 patch rebased to 6.9 HEAD for your reference.
> >>>>
> >>>> But to observe the IO stall before the patch, please test with a rea=
d-write workload so GC will happen periodically enough (read-only or read-m=
ostly workload doesn't show the problem). For me, I used the "fio" utility =
to generate a random read-write workload as follows.
> >>>>
> >>>> # Pre-generate a 900GB test file
> >>>> $ truncate -s 900G test
> >>>>
> >>>> # Run random read-write workload for 1 hour
> >>>> $ fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dl=
ibaio --name=3Dlatency_test --filename=3Dtest --bs=3D8k --iodepth=3D1 --siz=
e=3D900G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_lo=
g=3Dlat --log_avg_msec=3D1000 --log_max_value=3D1
> >>>>
> >>>> We include the flags "--write_lat_log=3Dlat --log_avg_msec=3D1000 --=
log_max_value=3D1" so fio will dump the second-by-second max latency into a=
 log file at the end of test so we can when stall happens and for how long:
> >>>>
> >>>
> >>> Copied. Thanks for the information. Let me try the above command line=
s on my local machine with longer time.
> >>>
> >>>
> >>>
> >>>> E.g.
> >>>>
> >>>> $ more lat_lat.1.log
> >>>> (format: <time-ms>,<max-latency-ns>,,,)
> >>>> ...
> >>>> 777000, 5155548, 0, 0, 0
> >>>> 778000, 105551, 1, 0, 0
> >>>> 802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO possibl=
e
> >>>> 802615, 82134, 1, 0, 0
> >>>> 804000, 9944554, 0, 0, 0
> >>>> 805000, 7424638, 1, 0, 0
> >>>>
> >>>> I used a 375 GB local SSD (cache device) and a 1 TB network-attached=
 storage (backing device). In the 1-hr run, GC starts happening about 10 mi=
nutes into the run and then happens at ~ 5 minute intervals. The stall dura=
tion ranges from a few seconds at the beginning to close to 40 seconds towa=
rds the end. Only about 1/2 to 2/3 of the cache is used by the end.
> >>>>
> >>>> Note that this patch doesn't shorten the GC either. Instead, it just=
 avoids GC from blocking the allocator thread by first sweeping the buckets=
 and marking reclaimable ones quickly at the beginning of GC so the allocat=
or can proceed while GC continues its actual job.
> >>>>
> >>>> We are eagerly looking forward to this patch to be merged in this co=
ming merge window that is expected to open in a week to two.
> >>>
> >>> In order to avoid the no-space deadlock, normally there are around 10=
% space will not be allocated out. I need to look more close onto this patc=
h.
> >>>
> >>>
> >>> Dongsheng Yang,
> >>>
> >>> Could you please post a new version based on current mainline kernel =
code ?
> >>
> >> Hi Coly,
> >>        Mingzhe will send a new version based on mainline.
> >>
> >> Thanx
> >>>
> >>> Thanks.
> >>>
> >>> Coly Li
> >>>
> >>>
> >>>
>

