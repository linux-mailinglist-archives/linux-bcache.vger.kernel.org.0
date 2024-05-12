Return-Path: <linux-bcache+bounces-434-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 107EA8C3523
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2024 07:43:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 851E11F2139B
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2024 05:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 635AFCA40;
	Sun, 12 May 2024 05:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hKSIYz+l"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95355C13D
	for <linux-bcache@vger.kernel.org>; Sun, 12 May 2024 05:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715492603; cv=none; b=eweOhriVbruynRrwL4fPmywYR3j0vfoeWLuSo+5nOAEd9pBKp20aSYqKwMWpFX4gbGhxVRVXYAsTbSTCOB/4a4QrsZdqFQV37b37jwZEaneFnDcJsdvDA9HUbZ1tHf8Ik6PQyC/ozPMuM/ZsSYpPOS3tjyKiQjDUTedKM8GOrdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715492603; c=relaxed/simple;
	bh=VkFOzTbDdWHy17K2/xBr4HZAwm4320NegfXNwP7nr/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDy8che1pVwkS/XTE/BTPS/IkpIrDAGJ3RAKUG1oIi5KbhmBPNj5p8Xf3LUwMBvQP3UqhFqvmu5lGWg36SJh/0bJYSQEOCftYde0y+YjRy6/ygncKRxIyjFxIA5xDjsUdU0GU7UmBRLlnG7ZTcxTw5T7/sTVdx9UdNcVsKY7ZWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hKSIYz+l; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41ff3a5af40so34875e9.1
        for <linux-bcache@vger.kernel.org>; Sat, 11 May 2024 22:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715492600; x=1716097400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mi6OWa2mDCWBq1apdqVQ4e62XyCLGXys8pzdO7gmZmg=;
        b=hKSIYz+l93Bx1J1uDWzsUpwYbBgZHHSAKyju1xyi6sFZWm2P9ljvR3gLL8EX8lhlW4
         nDghJqkjf4WvcZKJO0uakL70CVNf2G2GGt9v9fircCev5JSSkOyWV9M5AE5CZNwNMjU2
         uIHFn2+Zu6mTScNbqF2gFxKVlAEUIziwwgyvcBfc2l1meIQ1M0gm3k9F8xZArM6/CU4m
         qvefxM9NqOAQNdGpZtXlnYtI1OYWLxAgNALWY7m2DLQTVfQvF3NciCf+Qt1zG/F6ZCgB
         1XiWuyaushSWU97S4ylwBbZDvVwILTVgMo31Vh0shrebD3iFKH6I5RGPliD1K9AFj2L0
         dkBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715492600; x=1716097400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mi6OWa2mDCWBq1apdqVQ4e62XyCLGXys8pzdO7gmZmg=;
        b=S+bZUI6aNmhx9hMyRkDaWLU3Opwc3/Zl3J4gduZwARJtN3Az8kznwjlXhziwgN9h6N
         vXQw+87mIRoBdfOhDMUbebQOdqkHE4w348AstjkoR5wmMO/UL/F70aI7sjiRVd3+w78J
         HKcynahpiz7RjfOZJUuUdfC7mqh1UM1p29hmMyoZnSWEMBe+lW24kdasrxLTe4nr4vRo
         SED8FEqqT78F/2H8H4FrNP4wH746fVYtmq43cklqe96KfIhqzI7SbpY4SAvWYI0o5hMU
         ZOFAug/Ka9hZCW4Q18G909FECsaKPZYdpHaSNXMdQRXxbHsIV5xyTEKIijGzKeNFqFi7
         7Q9g==
X-Forwarded-Encrypted: i=1; AJvYcCWhm8MzoV2bvk3qMP+EiWBFoe41tBRIUeZ9nO/NWlpHq3BF3+0X7lW/ezJ1/FkJawDOn8o+ZCbR6j6ig93J4U4k+gUnuPcbS/wQvl2x
X-Gm-Message-State: AOJu0YxAgs1oEr249RgEY6vlNGuoxv/l3MOuacRgzWZCHAWO2WMVCf8r
	GPbdd9jQ9cDNyNRmhQ/O2m59Jqmo4ysGehuZE3q2WHVhtWQVB5W5to3CBuYg3ghI0uewVnRxvs5
	h8tnfh8w6uB3vgQCYnvl6+uHQEqKYdXifPxM4
X-Google-Smtp-Source: AGHT+IEPewLE+ZOznMzZFzNdwSgQdB4YPDDVWXug5Y+aEMpWetuYrX5haCruqrGYoXmrXeUpou6Qb0ekK+39ND0fIQo=
X-Received: by 2002:a05:600c:a4a:b0:41c:a1b:2476 with SMTP id
 5b1f17b1804b1-4200ee3824fmr1960585e9.6.1715492599476; Sat, 11 May 2024
 22:43:19 -0700 (PDT)
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
In-Reply-To: <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
From: Robert Pang <robertpang@google.com>
Date: Sat, 11 May 2024 22:43:07 -0700
Message-ID: <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Coly Li <colyli@suse.de>, mingzhe.zou@easystack.cn, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

I see that Mingzhe has submitted the rebased patch [1]. Do you have a
chance to reproduce the stall and test the patch? Are we on track to
submit this patch upstream in the coming 6.10 merge window? Do you
need any help or more info?

Thanks
Robert


[1] https://lore.kernel.org/linux-bcache/1596418224.689.1715223543586.JavaM=
ail.hmail@wm-bj-12-entmail-virt53.gy.ntes/T/#u


On Tue, May 7, 2024 at 7:34=E2=80=AFPM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> =E5=9C=A8 2024/5/4 =E6=98=9F=E6=9C=9F=E5=85=AD =E4=B8=8A=E5=8D=88 11:08, =
Coly Li =E5=86=99=E9=81=93:
> >
> >
> >> 2024=E5=B9=B45=E6=9C=884=E6=97=A5 10:04=EF=BC=8CRobert Pang <robertpan=
g@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> Hi Coly,
> >>
> >>> Can I know In which kernel version did you test the patch?
> >>
> >> I tested in both Linux kernels 5.10 and 6.1.
> >>
> >>> I didn=E2=80=99t observe obvious performance advantage of this patch.
> >>
> >> This patch doesn't improve bcache performance. Instead, it eliminates =
the IO stall in bcache that happens due to bch_allocator_thread() getting b=
locked and waiting on GC to finish when GC happens.
> >>
> >> /*
> >> * We've run out of free buckets, we need to find some buckets
> >> * we can invalidate. First, invalidate them in memory and add
> >> * them to the free_inc list:
> >> */
> >> retry_invalidate:
> >> allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
> >>         !ca->invalidate_needs_gc);
> >> invalidate_buckets(ca);
> >>
> >>  From what you showed, it looks like your rebase is good. As you alrea=
dy noticed, the original patch was based on 4.x kernel so the bucket traver=
sal in btree.c needs to be adapted for 5.x and 6.x kernels. I attached the =
patch rebased to 6.9 HEAD for your reference.
> >>
> >> But to observe the IO stall before the patch, please test with a read-=
write workload so GC will happen periodically enough (read-only or read-mos=
tly workload doesn't show the problem). For me, I used the "fio" utility to=
 generate a random read-write workload as follows.
> >>
> >> # Pre-generate a 900GB test file
> >> $ truncate -s 900G test
> >>
> >> # Run random read-write workload for 1 hour
> >> $ fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dlib=
aio --name=3Dlatency_test --filename=3Dtest --bs=3D8k --iodepth=3D1 --size=
=3D900G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=
=3Dlat --log_avg_msec=3D1000 --log_max_value=3D1
> >>
> >> We include the flags "--write_lat_log=3Dlat --log_avg_msec=3D1000 --lo=
g_max_value=3D1" so fio will dump the second-by-second max latency into a l=
og file at the end of test so we can when stall happens and for how long:
> >>
> >
> > Copied. Thanks for the information. Let me try the above command lines =
on my local machine with longer time.
> >
> >
> >
> >> E.g.
> >>
> >> $ more lat_lat.1.log
> >> (format: <time-ms>,<max-latency-ns>,,,)
> >> ...
> >> 777000, 5155548, 0, 0, 0
> >> 778000, 105551, 1, 0, 0
> >> 802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO possible
> >> 802615, 82134, 1, 0, 0
> >> 804000, 9944554, 0, 0, 0
> >> 805000, 7424638, 1, 0, 0
> >>
> >> I used a 375 GB local SSD (cache device) and a 1 TB network-attached s=
torage (backing device). In the 1-hr run, GC starts happening about 10 minu=
tes into the run and then happens at ~ 5 minute intervals. The stall durati=
on ranges from a few seconds at the beginning to close to 40 seconds toward=
s the end. Only about 1/2 to 2/3 of the cache is used by the end.
> >>
> >> Note that this patch doesn't shorten the GC either. Instead, it just a=
voids GC from blocking the allocator thread by first sweeping the buckets a=
nd marking reclaimable ones quickly at the beginning of GC so the allocator=
 can proceed while GC continues its actual job.
> >>
> >> We are eagerly looking forward to this patch to be merged in this comi=
ng merge window that is expected to open in a week to two.
> >
> > In order to avoid the no-space deadlock, normally there are around 10% =
space will not be allocated out. I need to look more close onto this patch.
> >
> >
> > Dongsheng Yang,
> >
> > Could you please post a new version based on current mainline kernel co=
de ?
>
> Hi Coly,
>         Mingzhe will send a new version based on mainline.
>
> Thanx
> >
> > Thanks.
> >
> > Coly Li
> >
> >
> >

