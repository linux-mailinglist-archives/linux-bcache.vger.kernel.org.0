Return-Path: <linux-bcache+bounces-843-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C89C3A3202E
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 08:43:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24C8C7A4AAF
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Feb 2025 07:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 602E7204C34;
	Wed, 12 Feb 2025 07:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QtIWU0j6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA72046B3
	for <linux-bcache@vger.kernel.org>; Wed, 12 Feb 2025 07:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739346130; cv=none; b=FZKDzuNq4YTc5bhPUk4g7GhthDihy0Tq48vGNETUNx+QyaMyQc2qOSuNvIFWheKpbcZBzno4bxoWm/5n+Lc6SPAC+G78UhrFHMK3R8P40aKaynKnZKGxb+IDZfQl4YgmcGgZ+nB99JE+jh4ytu+x7P74eLTdx1Xu7XQ7uQG52d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739346130; c=relaxed/simple;
	bh=nmgGjp6Hsua2qC7uevGCNhuckiJgC7Xrz1BZeCpMOVw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u+FcSRtn8PMxTPt1JVuaG9vjLlkdo7DFGm9n7CQhKF4IcOMJ+r1zjxk/850eGoKWwhVxMtR5XpNFpY0xHOcqZCBXX+JNRu2xdvndnXdT+VD4sULl5n7wSHXdegPftDhULeHbMBEYTrPysOAgiheK4ZmsFuj7Jb8B2YicQROfmyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QtIWU0j6; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5450cf0cb07so2490423e87.0
        for <linux-bcache@vger.kernel.org>; Tue, 11 Feb 2025 23:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739346126; x=1739950926; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l4Lz6wMDUQ8OPcJDsT1Zmh9Nq0pDVI/Rc8vIMBXZZG4=;
        b=QtIWU0j6k233d393FSXf7mlRPXVDJ1pjs844B18q1kXyKYRaxEPulF6fUJQ/ei2zJ4
         pgXv4YUHjY3mRuWIe6zu/JGPHgmvLw5kXWWkOJWTH6aC/MoYudQvrGkcQbecyc+fTHA0
         0ldUcQfG5j941T4MrXvbpu+Y1yEyyXVY+HDRD5/w8ZkHLdXlocW3c4bMQ1hRChVbXTmB
         gotQQgUxw8tZ+zRP7lQveOJAv/g66uowmWB/9ZBWSPQ4OTwwBeuQaD3fQ6k9yXhhO8v7
         TcfTFNrzGCNl1WJfISptMm0r/dghXLxAvM09yvIAoxLHgPRGt/Jyaf7O4tyoZp57OGa7
         h7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739346126; x=1739950926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l4Lz6wMDUQ8OPcJDsT1Zmh9Nq0pDVI/Rc8vIMBXZZG4=;
        b=A2x1RSnc7yNriwrTvQKH8dMRgJ5XkOMHnQLLbOwXxL5s6FuWBjo30gfuUJOIWNdeRw
         o1pIO4X5Ze+XgA5LBmofp2d1/a/GorsQltwKc3u8Le1q0wa6q1NQrkU2BwRjPI/W7AHi
         jv5n56LS6qHH5lmYbiL+/l2AMsQRsMO0rstFls3axzmTraY9uOb2oCVlf2xWoKh8rr73
         Y9CQz8fjp0rtPaA91vH3Odph4lQF/fA/GsIWngggOs56k87msQfDs/CGqwbthfluFEdE
         aH692SrQOKrHNoRCjJGQAfqF0+8EmQr8kSw2bFhu5Wp3v9Cp/TnUPKCrF6Qv9Mr+eLCy
         dXyw==
X-Gm-Message-State: AOJu0Yz726GKtCL18JP0fzZybA5YfXzVVvjB1+jK07oRW10XjMWY3p/z
	XADTUxxkY5bhOWiqTfc8fcRIxM+ejGJPZnaQZhMULOQXiombjTYeGTw0Pjf53ZWAM59/4iavT8a
	nCF2CxTsWX/Z7/wALhaeXLtlfJ2E=
X-Gm-Gg: ASbGncu+2bMDQMDIu3YSw9cDMJ/nLompd353L3iCGy0fmeiwAt/DmnlPyjyDMJhUwW4
	Sg0bjAPRE5rFK+9W9eBjNqt1Xl7aaX3AnlUdQhk8uEUfU3/0CcsHa65JBrXCJkafsG754vyGgyg
	==
X-Google-Smtp-Source: AGHT+IEKR1TrhUDybIPWS/zHA9/q7RwCX+IAjDf9sV8dI/WiO5wHCdpFwDpWRy/Cb46JYH1dlsxvejxWtt/NU0WBb+s=
X-Received: by 2002:a05:6512:3056:b0:545:9ce:7606 with SMTP id
 2adb3069b0e04-54518178d07mr653941e87.34.1739346126019; Tue, 11 Feb 2025
 23:42:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212055126.117092-1-sunjunchao2870@gmail.com> <ALsAXgAaLhNhHzKQW2msV4pl.3.1739343977966.Hmail.mingzhe.zou@easystack.cn>
In-Reply-To: <ALsAXgAaLhNhHzKQW2msV4pl.3.1739343977966.Hmail.mingzhe.zou@easystack.cn>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Wed, 12 Feb 2025 15:41:54 +0800
X-Gm-Features: AWEUYZlHzIO5GtRBUYSQVvNKrcTiWDBMv1gqftCwbXHWd0eoB03cUkziX2f5NRQ
Message-ID: <CAHB1Najgakh_J94FZBW1HnYRSTeGbo8TehE3jQ5LKn8D6J8DKw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Use the lastest writeback_delay value when
 writeback thread is woken up
To: =?UTF-8?B?6YK55piO5ZOy?= <mingzhe.zou@easystack.cn>
Cc: linux-bcache <linux-bcache@vger.kernel.org>, colyli <colyli@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, mingzhe

Thanks for your review and comments.

On Wed, Feb 12, 2025 at 3:06=E2=80=AFPM =E9=82=B9=E6=98=8E=E5=93=B2 <mingzh=
e.zou@easystack.cn> wrote:
>
> Original:
> From=EF=BC=9AJulian Sun <sunjunchao2870@gmail.com>
> Date=EF=BC=9A2025-02-12 13:51:26(=E4=B8=AD=E5=9B=BD (GMT+08:00))
> To=EF=BC=9Alinux-bcache<linux-bcache@vger.kernel.org>
> Cc=EF=BC=9Acolyli<colyli@kernel.org> , kent.overstreet<kent.overstreet@li=
nux.dev> , Julian Sun <sunjunchao2870@gmail.com>
> Subject=EF=BC=9A[PATCH] bcache: Use the lastest writeback_delay value whe=
n writeback thread is woken up
> When users reset writeback_delay value and woke up writeback
> thread via sysfs interface, expect the writeback thread
> to do actual writeback work, but in reality, the writeback
> thread probably continue to sleep.
>
> For example the following script set writeback_delay to 0 and
> wake up writeback thread, but writeback thread just continue to
> sleep:
> echo 0 &gt; /sys/block/bcache0/bcache/writeback_delay
> echo 1 &gt; /sys/block/bcache0/bcache/writeback_running
>
> Using the lastest value when writeback thread is woken up can
> urge it to do actual writeback work.
>
> Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
> ---
>  drivers/md/bcache/writeback.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.=
c
> index c1d28e365910..0d2d06aaacfe 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -825,8 +825,10 @@ static int bch_writeback_thread(void *arg)
>
> Hi, Julian Sun:
>
> We should first understand the role of writable_delay.
>
> The writeback thread only sleep when searched_full_index is True,
> which means that there are very few dirty keys at this time, all
> dirty keys are refilled at once.
>
>                         while (delay &amp;&amp;
>                                !kthread_should_stop() &amp;&amp;
>                                !test_bit(CACHE_SET_IO_DISABLE, &amp;c-&gt=
;flags) &amp;&amp;
> -                              !test_bit(BCACHE_DEV_DETACHING, &amp;dc-&g=
t;disk.flags))
> +                              !test_bit(BCACHE_DEV_DETACHING, &amp;dc-&g=
t;disk.flags)) {
>                                 delay =3D schedule_timeout_interruptible(=
delay);
> +                               delay =3D min(delay, dc-&gt;writeback_del=
ay * HZ);
> +                       }
>
>
> > So, I don't think it is necessary to immediately adjust the sleep time
> > unless the writeback_delay is set very large. We need to set a reasonab=
le
> > value for writable_delay at startup, rather than adjusting it at runtim=
e.
> >

I understand your point, but I still believe this is important.
IMO, since /sys/block/bcacheX/bcache/writeback_delay allows adjusting
the writeback_delay value at runtime,  bcache should ideally support
this functionality. Otherwise, the current behavior may be confusing
for users: "I've adjusted it, but why does it seem ineffective?" :)

> mingzhe
>
>                         bch_ratelimit_reset(&amp;dc-&gt;writeback_rate);
>                 }
> --
> 2.39.5
>
>
>
> </sunjunchao2870@gmail.com></sunjunchao2870@gmail.com></kent.overstreet@l=
inux.dev></colyli@kernel.org></linux-bcache@vger.kernel.org></sunjunchao287=
0@gmail.com>
>

Thanks,
--=20
Julian Sun <sunjunchao2870@gmail.com>

