Return-Path: <linux-bcache+bounces-362-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A1078907F0
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Mar 2024 19:05:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 992941C2C793
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Mar 2024 18:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BA7E131BD9;
	Thu, 28 Mar 2024 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FNu1RPhD"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7697F12F391
	for <linux-bcache@vger.kernel.org>; Thu, 28 Mar 2024 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711649135; cv=none; b=YGJdy1mqxmia9PkC3iUoKPcoH8kOSzAsl4sD+1+MvMlrrT9Gnjn9LlZ+k3PyNIyj7lYVOvpBgVP7fRUjHBiTOLAMGotlFcQukol4EXd2ccI1F/JwWyRPmnzfZhrfxXVlxCFHyEjkn3rsNXPDxy9Fr11ZmfbJkOJSbMx+aYwyIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711649135; c=relaxed/simple;
	bh=WfQQJHo5CWxX5z0MYaFkCZdpVziHIGJbz+YA2rAc7cw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D2ZcOCGjDPqI3tWr2Lf24oKHMVgWlPho6ucT45AlVMs10ZxAUiQyAQYw0Bm6p7eDhtj0Q0d+yaSJjOy05Ge3Ox+kuyXQOdZ4PpDirhkCKzguCj6f5tXrytIELeqb2+JpXLGRENvg0Rj68kO/34oJpK9XYsD9ZbE7sqARzfqNEUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FNu1RPhD; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4148c09ec6bso10325e9.1
        for <linux-bcache@vger.kernel.org>; Thu, 28 Mar 2024 11:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711649132; x=1712253932; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV+AWUum/505WLj/CNKA7S2NGOYrb2TGiX/4vGImYAY=;
        b=FNu1RPhDc8Kub7lEZPM+OGGweaqhhTLGU6/HQ2V9GyL3BbsxFm6Mbs4Ol+HPIrno9W
         tUU0olDcE0bVVS+9Y5fzGjVJ4Pgo+l1bUbUFd2PMg1Er5QfsHcXPCkJpQARxgo/u3B49
         ZAIGP2h/t6KhV1YAUz7AuYOWE8KQzC/1lsFHw8LfGssoiApVp+9QWMZIRdJHsMVwOcFh
         OuuhBVeMbjHT0Afr39FLhVH5NeDxPS6/YTPwJUsrU7u700o9Gye14rJRlzHIinEVOmGQ
         kNTjNEyKNwfCb9m6sY54C3uLrg5hg2PXlxRBKNgOeGIRC6L0f2DJIRGIb48TNuhOUIV6
         b/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711649132; x=1712253932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AV+AWUum/505WLj/CNKA7S2NGOYrb2TGiX/4vGImYAY=;
        b=ofeE41SLPkeDZ5dyvyRKA8bvVyEfU7REKF5z4SXQQneodoKQeWo5iui8O+TSPg2+Sd
         L8zo2TUHpKw+utDxZFtOol38WbqF6u6HHknIEB0VTGTeltKQBnNBeQuesfjYRksClcWf
         wMrIRJnA5iy8cYXaPhNdsYBbBdnA0I4Q8BPL6OwQi4DRifDRqka9tU1cokT6GihyA6HR
         IzrcevIPq+F5RD9tEydMosHJvRehgLApYxJVxkYN6pyvUW0B7RkcLfdaQQs7T7gtdycO
         XlG2cT8VISobDPcOkKHon0l1Gryqv1my2J3ghHIQERTtnDBvugRvMTETHtabsxRuWL5O
         RxOw==
X-Forwarded-Encrypted: i=1; AJvYcCUKzuYJLsIiWuJ3Ex0h4XkIjmHNomEC0BA53+s6X/diQ5q+f9F6GeO5NV75OR8PWTR5UGY5AztGh3vEvK0ZDxbcIcRNEJ+Wd0jt5ZFr
X-Gm-Message-State: AOJu0YxuClCY+h3Uk+Cd5d71cbIWeCh8Oi3lMju2TnuGiGkrASNpk1xA
	1u5t2/Mwc32XmEnaXsPjAIHfjRA8bEMCF96sYeqNyXKg+o8Wxb1qdGQurDVnbQiRr6qx+SRMWLX
	vjaYptyO3hnZ2i/2tkLoSSXzRawV0iXi9ZbxZg+KSRmHJcuZqGQ==
X-Google-Smtp-Source: AGHT+IEApXblFu5kZuMmagbANoutduU9ZIGMYZmOzrrOSH8xNBSsnfWtzXZ77C7/eO3f0wlbArviha/I5+ny+oEEC5k=
X-Received: by 2002:a05:600c:4ab0:b0:414:908c:460d with SMTP id
 b48-20020a05600c4ab000b00414908c460dmr5618wmp.7.1711649131461; Thu, 28 Mar
 2024 11:05:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de> <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
In-Reply-To: <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Thu, 28 Mar 2024 11:05:17 -0700
Message-ID: <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi bcache developers

Greetings. Any update on this patch? How are things going with the
testing and submission upstream?

Thanks
Robert


On Sun, Mar 17, 2024 at 11:16=E2=80=AFPM Robert Pang <robertpang@google.com=
> wrote:
>
> Hi Coly
>
> Thank you for confirming. It looks like the 6.9 merge window just
> opened last week so we hope it can catch it. Please update in this
> thread when it gets submitted.
>
> https://lore.kernel.org/lkml/CAHk-=3Dwiehc0DfPtL6fC2=3DbFuyzkTnuiuYSQrr6J=
TQxQao6pq1Q@mail.gmail.com/T/
>
> BTW, speaking of testing, mind if you point us to the bcache test
> suite? We would like to have a look and maybe give it a try also.
>
> Thanks
> Robert
>
> On Sun, Mar 17, 2024 at 7:00=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
> >
> >
> >
> > > 2024=E5=B9=B43=E6=9C=8817=E6=97=A5 13:41=EF=BC=8CRobert Pang <robertp=
ang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Hi Coly
> > >
> >
> > Hi Robert,
> >
> > > Thank you for looking into this issue.
> > >
> > > We tested this patch in 5 machines with local SSD size ranging from
> > > 375 GB to 9 TB, and ran tests for 10 to 12 hours each. We observed no
> > > stall nor other issues. Performance was comparable before and after
> > > the patch. Hope this info will be helpful.
> >
> > Thanks for the information.
> >
> > Also I was told this patch has been deployed and shipped for 1+ year in=
 easystack products, works well.
> >
> > The above information makes me feel confident for this patch. I will su=
bmit it in next merge window if some ultra testing loop passes.
> >
> > Coly Li
> >
> >
> > >
> > >
> > > On Fri, Mar 15, 2024 at 7:49=E2=80=AFPM Coly Li <colyli@suse.de> wrot=
e:
> > >>
> > >> Hi Robert,
> > >>
> > >> Thanks for your email.
> > >>
> > >>> 2024=E5=B9=B43=E6=9C=8816=E6=97=A5 06:45=EF=BC=8CRobert Pang <rober=
tpang@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>>
> > >>> Hi all
> > >>>
> > >>> We found this patch via google.
> > >>>
> > >>> We have a setup that uses bcache to cache a network attached storag=
e in a local SSD drive. Under heavy traffic, IO on the cached device stalls=
 every hour or so for tens of seconds. When we track the latency with "fio"=
 utility continuously, we can see the max IO latency shoots up when stall h=
appens,
> > >>>
> > >>> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri M=
ar 15 21:14:18 2024
> > >>> read: IOPS=3D62.3k, BW=3D486MiB/s (510MB/s)(11.4GiB/24000msec)
> > >>>   slat (nsec): min=3D1377, max=3D98964, avg=3D4567.31, stdev=3D1330=
.69
> > >>>   clat (nsec): min=3D367, max=3D43682, avg=3D429.77, stdev=3D234.70
> > >>>    lat (nsec): min=3D1866, max=3D105301, avg=3D5068.60, stdev=3D138=
3.14
> > >>>   clat percentiles (nsec):
> > >>>    |  1.00th=3D[  386],  5.00th=3D[  406], 10.00th=3D[  406], 20.00=
th=3D[  410],
> > >>>    | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  414], 60.00=
th=3D[  418],
> > >>>    | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00=
th=3D[  462],
> > >>>    | 99.00th=3D[  652], 99.50th=3D[  708], 99.90th=3D[ 3088], 99.95=
th=3D[ 5600],
> > >>>    | 99.99th=3D[11328]
> > >>>  bw (  KiB/s): min=3D318192, max=3D627591, per=3D99.97%, avg=3D4979=
39.04, stdev=3D81923.63, samples=3D47
> > >>>  iops        : min=3D39774, max=3D78448, avg=3D62242.15, stdev=3D10=
240.39, samples=3D47
> > >>> ...
> > >>>
> > >>> <IO stall>
> > >>>
> > >>> latency_test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D50416: Fri M=
ar 15 21:21:23 2024
> > >>> read: IOPS=3D26.0k, BW=3D203MiB/s (213MB/s)(89.1GiB/448867msec)
> > >>>   slat (nsec): min=3D958, max=3D40745M, avg=3D15596.66, stdev=3D136=
50543.09
> > >>>   clat (nsec): min=3D364, max=3D104599, avg=3D435.81, stdev=3D302.8=
1
> > >>>    lat (nsec): min=3D1416, max=3D40745M, avg=3D16104.06, stdev=3D13=
650546.77
> > >>>   clat percentiles (nsec):
> > >>>    |  1.00th=3D[  378],  5.00th=3D[  390], 10.00th=3D[  406], 20.00=
th=3D[  410],
> > >>>    | 30.00th=3D[  414], 40.00th=3D[  414], 50.00th=3D[  418], 60.00=
th=3D[  418],
> > >>>    | 70.00th=3D[  418], 80.00th=3D[  422], 90.00th=3D[  426], 95.00=
th=3D[  494],
> > >>>    | 99.00th=3D[  772], 99.50th=3D[  916], 99.90th=3D[ 3856], 99.95=
th=3D[ 5920],
> > >>>    | 99.99th=3D[10816]
> > >>>  bw (  KiB/s): min=3D    1, max=3D627591, per=3D100.00%, avg=3D2443=
93.77, stdev=3D103534.74, samples=3D765
> > >>>  iops        : min=3D    0, max=3D78448, avg=3D30549.06, stdev=3D12=
941.82, samples=3D765
> > >>>
> > >>> When we track per-second max latency in fio, we see something like =
this:
> > >>>
> > >>> <time-ms>,<max-latency-ns>,,,
> > >>> ...
> > >>> 777000, 5155548, 0, 0, 0
> > >>> 778000, 105551, 1, 0, 0
> > >>> 802615, 24276019570, 0, 0, 0
> > >>> 802615, 82134, 1, 0, 0
> > >>> 804000, 9944554, 0, 0, 0
> > >>> 805000, 7424638, 1, 0, 0
> > >>>
> > >>> fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dli=
baio --name=3Dlatency_test --filename=3Dfio --bs=3D8k --iodepth=3D1 --size=
=3D900G  --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=
=3Dlat --log_avg_msec=3D1000 --log_max_value=3D1
> > >>>
> > >>> We saw a smiliar issue reported in https://www.spinics.net/lists/li=
nux-bcache/msg09578.html, which suggests an issue in garbage collection. Wh=
en we trigger GC manually via "echo 1 > /sys/fs/bcache/a356bdb0-...-64f7943=
87488/internal/trigger_gc", the stall is always reproduced. That thread poi=
nts to this patch (https://www.spinics.net/lists/linux-bcache/msg08870.html=
) that we tested and the stall no longer happens.
> > >>>
> > >>> AFAIK, this patch marks buckets reclaimable at the beginning of GC =
to unblock the allocator so it does not need to wait for GC to finish. This=
 periodic stall is a serious issue. Can the community look at this issue an=
d this patch if possible?
> > >>>
> > >>
> > >> Could you please share more performance information of this patch? A=
nd how many nodes/how long time does the test cover so far?
> > >>
> > >> Last time I test the patch, it looked fine. But I was not confident =
how large scale and how long time this patch was tested. If you may provide=
 more testing information, it will be helpful.
> > >>
> > >>
> > >> Coly Li
> > >
> >

