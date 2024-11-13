Return-Path: <linux-bcache+bounces-783-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E179C6A16
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 08:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624FF285165
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 07:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0BD187342;
	Wed, 13 Nov 2024 07:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N30UZLjR"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231C917D341;
	Wed, 13 Nov 2024 07:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731483647; cv=none; b=R6wNPWHmiaIVoUkbFkagnVbiLDg2IVn8BgZUTTorieAkqHaPFupkBXTqN0qfYmDuqZMf//9cZQa7ofU4ZRbg++F5+hSHD6FG0w7/6v2qirgmZ33gDXkF7pSGhyJtbmff/R00b/FJKvV5TtSZSMk+S4ZVJH7OMUUBrv8fCo8orqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731483647; c=relaxed/simple;
	bh=sloWZVQZcLvh6SYZA2x5rWsAk7RnMx9aaLXTsBzje2Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMl7Zb2BjHIi4wIY7QEb7opFbye1syzZbnAi9+BbDjZgki4wnEWvsPKLXeLx/NC3ZBXPPFsSp3+74I6z+erdc8/NxtMqHb9HsjpzxntWlyFKo3/H2BE1CBk8WuSQ2LY086vEd8YEGKJVWJXYln/QlFwADqgNYb6k3S3PVqDVauw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N30UZLjR; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-84fc818f518so2332205241.2;
        Tue, 12 Nov 2024 23:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731483644; x=1732088444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kN22Cxd+47IPGGWtgeX+L6opnh7GzlQQ1eFRQjrtgcQ=;
        b=N30UZLjR0V+xvOCf2T/4WlTE09DCDDssQ5Tho9xWD0K3yuOsln7ns/y/B4ujIjs7Fn
         h5trc+dyeGkks5u0eQmF0Xsx4E1XYuQnxsw04bj27goRoBg74MYGgDFOGLK8GG6at3YK
         lyMk2QLSJLsLtdU4WroZm9zZtV4VpJBzpW0Njs2uxr/38j/VlXQurYvHsB8sV3MWAoE/
         qZFGxx0UG/6BZxSZ6pW3VzyHugcQNSOg1JCGuMbjcDTPVDjVWu3gcAWr1TI7p8Sr9jXD
         X+PQWpGXGZ+5w7+h9zWxcknU6S7uKjtl5N+vvjYHmpL7q2mmB2htc2T4gIvw6B82xH6x
         DrTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731483644; x=1732088444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kN22Cxd+47IPGGWtgeX+L6opnh7GzlQQ1eFRQjrtgcQ=;
        b=gP5GElWtQsi5ooeVNFP1aVPah5otGdgLLPv7Le8g18TGOkxvhmzicslZ6UHuFdT10r
         6Y55ShmGvP1zJ6KBWQiut2WgZUnoXSNgU8XYF2bd4Fea5B+u/tnL/Rkg9y4rXaWz9fcW
         wmmOFcV0XtvHvFsdeIc+PsCJU8r3Pn6MfWX3Jl9GBb5Y3i+OtDJh+ohn4+UlcuqjRF0u
         3Bl7r8Vo54SI62WLYtU5aYDG+3b7b6tlhb1Sb/shNOBuA6UbXn73hGpB+OuPnSBUrk5R
         ypMziojOBlbrLJXWq1JSe0tqmQvlRZAV2Ze8BrofTB3Rfux4ptxfgz4Nwf2wFfDUXWWY
         pwUA==
X-Forwarded-Encrypted: i=1; AJvYcCU0whOKfp621wH13zcR248333gf8GAaZ9EECUiadhjUqwqYjJvcAWok6IlvMX6wBa90IYRuAAdF4Mr6U+w=@vger.kernel.org, AJvYcCWmbWuNUMjpO2pVhtKbNT+HaO3XinanwaSzudA8hYz3cp8gMNUFl4H92dzcBFean9ZLZe8wnZnOhJelyzT7@vger.kernel.org
X-Gm-Message-State: AOJu0YyGN/DecZ8YlPFa6Scp5YMgLojWBiZ4xAsY3Gs+F7RuA7w8xawS
	Jvk8wXuAWzIWRnjhjxD9/aOeXgpXHQ4zD3E+cQ+zGGyhS5ANf8uckH49m90eY+zYlEMY6hlma5/
	AUzIS3fpf26ZnzENZo9mWW9RPVz4=
X-Google-Smtp-Source: AGHT+IExoZtJQjCj2NeywbUcLmZp08ES9XxvzG38iio/g8DGPmLfSN08tbzs5iIpvs1ilQEKdR0OpHxuoKawOd3fM40=
X-Received: by 2002:a05:6102:3a13:b0:4a7:4900:4b5a with SMTP id
 ada2fe7eead31-4aae138a2camr18154152137.9.1731483643858; Tue, 12 Nov 2024
 23:40:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <D57B37C5-3241-483B-83DE-483243984E60@suse.de>
In-Reply-To: <D57B37C5-3241-483B-83DE-483243984E60@suse.de>
From: liequan che <liequanche@gmail.com>
Date: Wed, 13 Nov 2024 15:40:33 +0800
Message-ID: <CAAsfc_p0cGqB3pj_AvfDPiYNvdk6bA77AE9cgHnf-gEa2fksRw@mail.gmail.com>
Subject: Re: bcache: fix oops bug in cache_set_flush
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this bug on kernel versions 5.10.0-231.0.0.133 and 5.10.0-202.0.0.=
115=E3=80=82
You can get detailed information through the link below.

https://gitee.com/openeuler/kernel/issues/IB3YQZ
https://gitee.com/openeuler/kernel/pulls/13205
Best Regards=EF=BC=81
cheleiquan

Coly Li <colyli@suse.de> =E4=BA=8E2024=E5=B9=B411=E6=9C=8813=E6=97=A5=E5=91=
=A8=E4=B8=89 15:04=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Liequan,
>
> > 2024=E5=B9=B411=E6=9C=8813=E6=97=A5 14:25=EF=BC=8Cliequan che <liequanc=
he@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Signed-off-by: cheliequan <cheliequan@inspur.com>
> >
> >   If the bcache cache disk contains damaged btree data,
> > when the bcache cache disk partition is directly operated,
> > the system-udevd service is triggered to call the bcache-register
> > program to register the bcache device,resulting in kernel oops.
> >
>
> What is the kernel version ?
>
> Interesting that why the btree node checking code during registration doe=
sn=E2=80=99t cache the meta data error.
>
>
>
> > crash> bt
> > PID: 7773     TASK: ffff49cc44d69340  CPU: 57   COMMAND: "kworker/57:2"
> > #0 [ffff800046373800] machine_kexec at ffffbe5039eb54a8
> > #1 [ffff8000463739b0] __crash_kexec at ffffbe503a052824
> > #2 [ffff8000463739e0] crash_kexec at ffffbe503a0529cc
> > #3 [ffff800046373a60] die at ffffbe5039e9445c
> > #4 [ffff800046373ac0] die_kernel_fault at ffffbe5039ec698c
> > #5 [ffff800046373af0] __do_kernel_fault at ffffbe5039ec6a38
> > #6 [ffff800046373b20] do_page_fault at ffffbe503ac76ba4
> > #7 [ffff800046373b70] do_translation_fault at ffffbe503ac76ebc
> > #8 [ffff800046373b90] do_mem_abort at ffffbe5039ec68ac
> > #9 [ffff800046373bc0] el1_abort at ffffbe503ac669bc
> > #10 [ffff800046373bf0] el1_sync_handler at ffffbe503ac671d4
> > #11 [ffff800046373d30] el1_sync at ffffbe5039e82230
> > #12 [ffff800046373d50] cache_set_flush at ffffbe50121fa4c4 [bcache]
> > #13 [ffff800046373da0] process_one_work at ffffbe5039f5af68
> > #14 [ffff800046373e00] worker_thread at ffffbe5039f5b3c4
> > #15 [ffff800046373e50] kthread at ffffbe5039f634b8
> > crash> dis cache_set_flush+0x94
> > 0xffffbe50121fa4c8 <cache_set_flush+148>:       str     x23, [x20, #512=
]
> >
> > ---
> > drivers/md/bcache/super.c | 16 ++++++++++------
> > 1 file changed, 10 insertions(+), 6 deletions(-)
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index fd97730479d8..8a41dfcf9fb6 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl)
> >       if (!IS_ERR_OR_NULL(c->gc_thread))
> >               kthread_stop(c->gc_thread);
> >
> > -       if (!IS_ERR(c->root))
> > -               list_add(&c->root->list, &c->btree_cache);
> > +       if (!IS_ERR_OR_NULL(c->root)) {
> > +               if (!list_empty(&c->root->list))
> > +                       list_add(&c->root->list, &c->btree_cache);
> > +       }
> >
> >       /*
> >        * Avoid flushing cached nodes if cache set is retiring
> > @@ -1750,10 +1752,12 @@ static void cache_set_flush(struct closure *cl)
> >        */
> >       if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags))
> >               list_for_each_entry(b, &c->btree_cache, list) {
> > -                       mutex_lock(&b->write_lock);
> > -                       if (btree_node_dirty(b))
> > -                               __bch_btree_node_write(b, NULL);
> > -                       mutex_unlock(&b->write_lock);
> > +                       if (!IS_ERR_OR_NULL(b)) {
>
> The above check is not safe.
>
>
>
> > +                               mutex_lock(&b->write_lock);
> > +                               if (btree_node_dirty(b))
> > +                                       __bch_btree_node_write(b, NULL)=
;
> > +                               mutex_unlock(&b->write_lock);
> > +                       }
> >               }
> >
> >       if (ca->alloc_thread)
> > --
> > 2.33.0
>
>
> Thanks.
>
> Coly Li

