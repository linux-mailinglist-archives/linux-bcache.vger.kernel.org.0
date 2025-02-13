Return-Path: <linux-bcache+bounces-846-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A49BA3386F
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Feb 2025 08:01:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAA8A188C4A9
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Feb 2025 07:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48597205ACF;
	Thu, 13 Feb 2025 07:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dc5nKN2W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA314A0B5
	for <linux-bcache@vger.kernel.org>; Thu, 13 Feb 2025 07:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739430081; cv=none; b=YiwDfJuh8EwEqAeQR8KQletY9sBNdcrlmx6I25vv4MtUFVc2CKC7ZJ8haXjOoEalxCd2z3LrCE3SAAXTKlbMhQZkXjQ5wx0/pVDyt2aCHL4/j1C8nIE+MMgvfLAI/GjJXerPXpxDBzISujHPsZyixE9D1+cs3Zb3m3sOOqcO8Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739430081; c=relaxed/simple;
	bh=UHy677gn9a9U1z8LT70SMbMD+wf7jYhUxRFH6MOF+88=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jyvzxlIGQqMvZ1YW2eq7nWraC6WKHkrKxdaMoVAq/Zvj+AWydo8ZnCNZGc5Jbh4/1Br89kDuc0jlHuBr2atFjYnDhKNWbA2ORPa+ip+AhlND17iM+gEfDIkxqK2yg3Lr70T5OxqF7subGeMrOuAERU0MOr4P1PJPJYcAxUx30mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dc5nKN2W; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-54504bf07cdso490877e87.2
        for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2025 23:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739430076; x=1740034876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGtPn3nfsPml+6VuTtM5rbdqpKLcwCtbfYca9M6VM/s=;
        b=Dc5nKN2WiYZoJ2TtJ62cBYFQ8CgJemGfJpgnuSTejSU3t/MN5H4QDU5Lf/5Zj/8nZm
         79ezLdwzA613tp3BEy4HLMDogEH3/lbm6AZLkRtKROfZhGU8jy821HLb3wH2exj78SDZ
         lAQoiWXGDCvU+7RlggO76QYCWOWRTI5gy9JVG6PjUkidzBnHsCvqahLEejl2o3+CVIBR
         NlP/C3sV0nHhvD8sIvjjiSmZ+g+wqrwmTDW0GHXgfHfG0yQM9aZcmMLy8DXdUxMeHlQ6
         CthoDfpla3/5qvphqU0NB08xIwfac2GNS4+wcI3crKl62hrOf6vgkWEvXY2No1JQ3Pfa
         UFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739430076; x=1740034876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGtPn3nfsPml+6VuTtM5rbdqpKLcwCtbfYca9M6VM/s=;
        b=JeeSHnowQ0/ltebEDLRNvPEz3vCv2Xa598VTe0asfRg/QTEGkC9doF932gong12nx0
         +RebSdicrWnTaSFn3dKPV4CHPodu/PKIej0ujlncDd5RoT+uOI4u3ClLZnHS+2QRvQa6
         gcnqMn5YxGYe0ouZpySeYBvNheGvAkVokls4LAOrHQJDHGqN7nOn3Kbcz7rwHkxDN6gX
         cic22M4CwmM86ru8oLQEl3SYSjgKwttLOAYUHmE0tS4FVr3QFMcyeihm7mFKwMvCGvFw
         FTf7H6L6z14NzRivwxVu+wYRcBYNm5tihmDhR/jwXhtEpEr/kO+o7bUVAwptuyWNRpU7
         i0tg==
X-Forwarded-Encrypted: i=1; AJvYcCWiC6cTk0sxQZ+cVrxtAyDh+0kD+CKx4vhxYPfCYkAAuYNZ77UhooA3fitpHhs1eYybj3kQtdSkpqLcfjw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMoelFeOvtNOQ6EyD6WzxNvrij9xvmM/W9FmsIkk6noG4LcFxE
	4/yDoCOsWa99soUBj3aBIenxeqMwXsK7W8WPX3JkXB7OGrwTEImCNe+EyPEzt+jgai6E0WeZLGj
	JiKdjmayCzI/BQ9jHQEjAoMJRyHIia1+0
X-Gm-Gg: ASbGncvzCqRw/q1X3uPBJlcxLlvw863VH1cpMcXvtY6/0lBspjWzXcd8Gc8rw1jE48R
	u7pR+vk/3FzzIHJvFvetafUWlm616+IVCB/RL1MKC5anbDQ+QpcVpD/GK9gCPdDGf59Vz8bOmMQ
	==
X-Google-Smtp-Source: AGHT+IFrAvtpPpE7L7pWEdvX3SiJ3eosnafkRo2XspFGrhunOpApowhw1Jjp8T+zMClCMFsQ8tspb+kZkPiqopBWcwA=
X-Received: by 2002:a05:6512:3b20:b0:545:10bc:20ca with SMTP id
 2adb3069b0e04-5451811d362mr2151297e87.24.1739430076014; Wed, 12 Feb 2025
 23:01:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212055126.117092-1-sunjunchao2870@gmail.com>
 <ALsAXgAaLhNhHzKQW2msV4pl.3.1739343977966.Hmail.mingzhe.zou@easystack.cn>
 <CAHB1Najgakh_J94FZBW1HnYRSTeGbo8TehE3jQ5LKn8D6J8DKw@mail.gmail.com> <mtmlo6kdq52z47fz336anzolmfctrqtzrffqjikqd5ee7jgp5q@pcissxq7yx7h>
In-Reply-To: <mtmlo6kdq52z47fz336anzolmfctrqtzrffqjikqd5ee7jgp5q@pcissxq7yx7h>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Thu, 13 Feb 2025 15:01:04 +0800
X-Gm-Features: AWEUYZkK541pTwQbpCD24r4xAZad3SndLT9VQXoq9lgn6BrC4oDIlWTEXs_wovA
Message-ID: <CAHB1Nai_2TESJ+c44szcKfTi0PPEdu6k=siDNCPQ_eFBro_ByQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: Use the lastest writeback_delay value when
 writeback thread is woken up
To: Coly Li <i@coly.li>
Cc: =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>, 
	linux-bcache <linux-bcache@vger.kernel.org>, colyli <colyli@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,
Thanks for your review and comments.

On Thu, Feb 13, 2025 at 1:06=E2=80=AFAM Coly Li <i@coly.li> wrote:
>
> On Wed, Feb 12, 2025 at 03:41:54PM +0800, Julian Sun wrote:
> > Hi, mingzhe
> >
> > Thanks for your review and comments.
> >
> > On Wed, Feb 12, 2025 at 3:06=E2=80=AFPM =E9=82=B9=E6=98=8E=E5=93=B2 <mi=
ngzhe.zou@easystack.cn> wrote:
> > >
> > > Original:
> > > From=EF=BC=9AJulian Sun <sunjunchao2870@gmail.com>
> > > Date=EF=BC=9A2025-02-12 13:51:26(=E4=B8=AD=E5=9B=BD (GMT+08:00))
> > > To=EF=BC=9Alinux-bcache<linux-bcache@vger.kernel.org>
> > > Cc=EF=BC=9Acolyli<colyli@kernel.org> , kent.overstreet<kent.overstree=
t@linux.dev> , Julian Sun <sunjunchao2870@gmail.com>
> > > Subject=EF=BC=9A[PATCH] bcache: Use the lastest writeback_delay value=
 when writeback thread is woken up
> > > When users reset writeback_delay value and woke up writeback
> > > thread via sysfs interface, expect the writeback thread
> > > to do actual writeback work, but in reality, the writeback
> > > thread probably continue to sleep.
> > >
> > > For example the following script set writeback_delay to 0 and
> > > wake up writeback thread, but writeback thread just continue to
> > > sleep:
> > > echo 0 &gt; /sys/block/bcache0/bcache/writeback_delay
> > > echo 1 &gt; /sys/block/bcache0/bcache/writeback_running
> > >
> > > Using the lastest value when writeback thread is woken up can
> > > urge it to do actual writeback work.
> > >
> > > Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> > > ---
> > >  drivers/md/bcache/writeback.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeb=
ack.c
> > > index c1d28e365910..0d2d06aaacfe 100644
> > > --- a/drivers/md/bcache/writeback.c
> > > +++ b/drivers/md/bcache/writeback.c
> > > @@ -825,8 +825,10 @@ static int bch_writeback_thread(void *arg)
> > >
> > > Hi, Julian Sun:
> > >
> > > We should first understand the role of writable_delay.
> > >
> > > The writeback thread only sleep when searched_full_index is True,
> > > which means that there are very few dirty keys at this time, all
> > > dirty keys are refilled at once.
> > >
> > >                         while (delay &amp;&amp;
> > >                                !kthread_should_stop() &amp;&amp;
> > >                                !test_bit(CACHE_SET_IO_DISABLE, &amp;c=
-&gt;flags) &amp;&amp;
> > > -                              !test_bit(BCACHE_DEV_DETACHING, &amp;d=
c-&gt;disk.flags))
> > > +                              !test_bit(BCACHE_DEV_DETACHING, &amp;d=
c-&gt;disk.flags)) {
> > >                                 delay =3D schedule_timeout_interrupti=
ble(delay);
> > > +                               delay =3D min(delay, dc-&gt;writeback=
_delay * HZ);
> > > +                       }
> > >
> > >
> > > > So, I don't think it is necessary to immediately adjust the sleep t=
ime
> > > > unless the writeback_delay is set very large. We need to set a reas=
onable
> > > > value for writable_delay at startup, rather than adjusting it at ru=
ntime.
> > > >
> >
> > I understand your point, but I still believe this is important.
> > IMO, since /sys/block/bcacheX/bcache/writeback_delay allows adjusting
> > the writeback_delay value at runtime,  bcache should ideally support
> > this functionality. Otherwise, the current behavior may be confusing
> > for users: "I've adjusted it, but why does it seem ineffective?" :)
> >
>
>
> > Hi Julian,
> >
> > Correct me if I am wrong. I feel maybe that you misunderstodd the
> > functionality of sysfs parameter writeback_delay. It is NOT used to
> > control the writeback rate.
> > You may want to check Documentation/admin-guide/bcache.rst at,
> >
> > 468 writeback_delay
> > 469   When dirty data is written to the cache and it previously did not=
 contain
> > 470   any, waits some number of seconds before initiating writeback. De=
faults to
> > 471   30.

Yeah, this is exactly what I want to say and I have no tendency to
change its functionality.
The writeback thread will wait for a specified number of
seconds(default 30) before performing the next actual writeback work.
Users are allowed to reset this value, for example to 0, which means
the thread will not wait any seconds and will proceed with the
writeback immediately.
Currently, the writeback thread behaves in such a way that it
continues to wait for the original remaining seconds even after being
woken up and a new writeback_delay value was set, which might not be
the intended behavior.

If there is any misunderstanding, please let me kown.
>
> Thanks.
>
> --
> Coly Li


Thanks,
--
Julian Sun <sunjunchao2870@gmail.com>

