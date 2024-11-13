Return-Path: <linux-bcache+bounces-784-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F03929C6A6E
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 09:15:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 717C9B23A67
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2024 08:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73D118A951;
	Wed, 13 Nov 2024 08:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iLYgb1Yk"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B318A6DC;
	Wed, 13 Nov 2024 08:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731485714; cv=none; b=UyT4fOWK75tgekVCj1ITikzc8qK6Uf+69y2/ms9RB4eUcjMGsCBL5OEdbIzWdRjmAko1CUrTLigM2Xc+LPRg1uftmE+u9Rt7EhcEifso2YJzVqKwqInMmpduzxNczWZeGRFzBfHUaeLYRzoTlHyoNMK5q2HO8xX+Wf1KPrTuS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731485714; c=relaxed/simple;
	bh=SDwnK6nGB1yMC3oDR5IhcSH3O3wf3kBST4iX1Ntxm6M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dDcyNTQK4CqjRe1e6CvwoWULL63UzJmydcir/a6CAI846X/3h+rBDRVKdGtP7k5//zFwS0uGpoXw9pY96HKY+DPsXeaYdO/MDXnuvT609b25oUQEaD/B9Pq3MJyfntsZd6H0Z0+NvwNhHLs1oRhXIlDlNoQ+ECiLAQSgXMqt2Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iLYgb1Yk; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e2bdbdee559so6325639276.1;
        Wed, 13 Nov 2024 00:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731485712; x=1732090512; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0/efmsHlaxuFyXA0/RwSFAnqWnFWj7WIYJFmLgvvcjE=;
        b=iLYgb1YkgBo+FO6EdEGgrnq3roO6CTGqz7b7tVDgV5HWE/NFIqZVX+7qk2zBDeW/3j
         OGE3oAiHdv4yH4vQdN3Pb7Z7kOuk3nxcYZJRGtJtjveFMHRqSvrSfCmf30Gy5r+38+or
         mYlX8j9MLhUpZXFJAI6BCQLubKZZIAG6Ub3CWIBlqfG5ea7PaZLiynaUQogHUxSSp1Oy
         pq0VS57+MAG+LzMM+bYYOymQp0GY8VfcVKQbjXoy19H1kwhDb6hnIm8eN34+Gjk0iias
         oaZFKQMB9eeQXAgCnQ205h4FRU3igYsedBsDCVLzFzKPRt6oDF/nksg0QOXO18EC8TVT
         YuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731485712; x=1732090512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/efmsHlaxuFyXA0/RwSFAnqWnFWj7WIYJFmLgvvcjE=;
        b=cEwK8iqD9xPwqUE5G12t99VhUhmNhyfPEh5qSQkMVOjULp1VrclhugMFIpWX1QPi/u
         mtCKVM6Z7PkXlspHaAKDEKZ3y/hi9vKe8qmeSYaYJ2tP3V3fCdB5CqupYsFvBXo9tPQZ
         AsT0X3NAX/8BNeRDD/2ZrjIZPxHnXiDtEggvMtHTpmkiiNENzuniNiNvV+r5lrBrM5Yw
         I1mJUUzTklPkac6rdXq9OCqR6tXXhpYPqpU2giaFs/9twTBuSTko6h2bw7aiQYrEBAl+
         6dgaAcgl09fhuZEym4HQdB1CKg5mNVgKkQj9YexE22J9iIcXPka/8L6k69CBB0ivGtvj
         WXgw==
X-Forwarded-Encrypted: i=1; AJvYcCVtxhhOJww8KqHzeb4hDU7nY7uS0K5WYwgmq3NuZH7hkf0LIgcxqdsOuavmuBsPoM6WykFzApCA68JBfAq+@vger.kernel.org, AJvYcCWMn0wggy+uK6oGdwoL07lnh0V3toAAVb4NApAQzIJcJXMkJF3kS4mbeAQLDdGZMmaoR/200nEvYvf5v5g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaEqsrrHzpclopVE2wHs1lTlT5TE1pLLbSZZ1lH4AZD64bg+jk
	CUzH7JT9XfmS57yYohfiCiSysEAJXY5V/69hAbBiO55zQwczSLlmgds2gHtxC9pYQzq3iXQgEwb
	N0IITC4TDJTgmFO6D+G272SXNkIQd4qyieW4=
X-Google-Smtp-Source: AGHT+IEt1uQsuKPEu1ocsUc+V50IeD3LnhJBhViXitw5VvLhuqKH2KJYohjhYBXxZQA9Tff9IDSNxoeV/PtsTzzKUgM=
X-Received: by 2002:a05:6902:2a4a:b0:e30:c4b2:7c62 with SMTP id
 3f1490d57ef6-e337f8e458emr17576135276.46.1731485711659; Wed, 13 Nov 2024
 00:15:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <D57B37C5-3241-483B-83DE-483243984E60@suse.de> <CAAsfc_p0cGqB3pj_AvfDPiYNvdk6bA77AE9cgHnf-gEa2fksRw@mail.gmail.com>
In-Reply-To: <CAAsfc_p0cGqB3pj_AvfDPiYNvdk6bA77AE9cgHnf-gEa2fksRw@mail.gmail.com>
From: liequan che <liequanche@gmail.com>
Date: Wed, 13 Nov 2024 16:15:00 +0800
Message-ID: <CAAsfc_ptZCpVKeMszMqXsgKgoaJps0=mG0pSFw+xseceWQOiPw@mail.gmail.com>
Subject: Re: bcache: fix oops bug in cache_set_flush
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly:
  In addition, the following actions caused the kernel oops. After
creating the BCache device, the metadata information was not cleared.
Hot-plugged to another server, repartitioned nvme with a different
partition size to recreate the BCache device.After the partition was
executed, the kernel oops was triggered.
  After I applied the new patch, it did not trigger the kernel panic.
  For the above problems, can you give me better modification suggestions?
  Thanks!
  cheliequan

liequan che <liequanche@gmail.com> =E4=BA=8E2024=E5=B9=B411=E6=9C=8813=E6=
=97=A5=E5=91=A8=E4=B8=89 15:40=E5=86=99=E9=81=93=EF=BC=9A
>
> I tested this bug on kernel versions 5.10.0-231.0.0.133 and 5.10.0-202.0.=
0.115=E3=80=82
> You can get detailed information through the link below.
>
> https://gitee.com/openeuler/kernel/issues/IB3YQZ
> https://gitee.com/openeuler/kernel/pulls/13205
> Best Regards=EF=BC=81
> cheleiquan
>
> Coly Li <colyli@suse.de> =E4=BA=8E2024=E5=B9=B411=E6=9C=8813=E6=97=A5=E5=
=91=A8=E4=B8=89 15:04=E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Liequan,
> >
> > > 2024=E5=B9=B411=E6=9C=8813=E6=97=A5 14:25=EF=BC=8Cliequan che <liequa=
nche@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > Signed-off-by: cheliequan <cheliequan@inspur.com>
> > >
> > >   If the bcache cache disk contains damaged btree data,
> > > when the bcache cache disk partition is directly operated,
> > > the system-udevd service is triggered to call the bcache-register
> > > program to register the bcache device,resulting in kernel oops.
> > >
> >
> > What is the kernel version ?
> >
> > Interesting that why the btree node checking code during registration d=
oesn=E2=80=99t cache the meta data error.
> >
> >
> >
> > > crash> bt
> > > PID: 7773     TASK: ffff49cc44d69340  CPU: 57   COMMAND: "kworker/57:=
2"
> > > #0 [ffff800046373800] machine_kexec at ffffbe5039eb54a8
> > > #1 [ffff8000463739b0] __crash_kexec at ffffbe503a052824
> > > #2 [ffff8000463739e0] crash_kexec at ffffbe503a0529cc
> > > #3 [ffff800046373a60] die at ffffbe5039e9445c
> > > #4 [ffff800046373ac0] die_kernel_fault at ffffbe5039ec698c
> > > #5 [ffff800046373af0] __do_kernel_fault at ffffbe5039ec6a38
> > > #6 [ffff800046373b20] do_page_fault at ffffbe503ac76ba4
> > > #7 [ffff800046373b70] do_translation_fault at ffffbe503ac76ebc
> > > #8 [ffff800046373b90] do_mem_abort at ffffbe5039ec68ac
> > > #9 [ffff800046373bc0] el1_abort at ffffbe503ac669bc
> > > #10 [ffff800046373bf0] el1_sync_handler at ffffbe503ac671d4
> > > #11 [ffff800046373d30] el1_sync at ffffbe5039e82230
> > > #12 [ffff800046373d50] cache_set_flush at ffffbe50121fa4c4 [bcache]
> > > #13 [ffff800046373da0] process_one_work at ffffbe5039f5af68
> > > #14 [ffff800046373e00] worker_thread at ffffbe5039f5b3c4
> > > #15 [ffff800046373e50] kthread at ffffbe5039f634b8
> > > crash> dis cache_set_flush+0x94
> > > 0xffffbe50121fa4c8 <cache_set_flush+148>:       str     x23, [x20, #5=
12]
> > >
> > > ---
> > > drivers/md/bcache/super.c | 16 ++++++++++------
> > > 1 file changed, 10 insertions(+), 6 deletions(-)
> > > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > > index fd97730479d8..8a41dfcf9fb6 100644
> > > --- a/drivers/md/bcache/super.c
> > > +++ b/drivers/md/bcache/super.c
> > > @@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl=
)
> > >       if (!IS_ERR_OR_NULL(c->gc_thread))
> > >               kthread_stop(c->gc_thread);
> > >
> > > -       if (!IS_ERR(c->root))
> > > -               list_add(&c->root->list, &c->btree_cache);
> > > +       if (!IS_ERR_OR_NULL(c->root)) {
> > > +               if (!list_empty(&c->root->list))
> > > +                       list_add(&c->root->list, &c->btree_cache);
> > > +       }
> > >
> > >       /*
> > >        * Avoid flushing cached nodes if cache set is retiring
> > > @@ -1750,10 +1752,12 @@ static void cache_set_flush(struct closure *c=
l)
> > >        */
> > >       if (!test_bit(CACHE_SET_IO_DISABLE, &c->flags))
> > >               list_for_each_entry(b, &c->btree_cache, list) {
> > > -                       mutex_lock(&b->write_lock);
> > > -                       if (btree_node_dirty(b))
> > > -                               __bch_btree_node_write(b, NULL);
> > > -                       mutex_unlock(&b->write_lock);
> > > +                       if (!IS_ERR_OR_NULL(b)) {
> >
> > The above check is not safe.
> >
> >
> >
> > > +                               mutex_lock(&b->write_lock);
> > > +                               if (btree_node_dirty(b))
> > > +                                       __bch_btree_node_write(b, NUL=
L);
> > > +                               mutex_unlock(&b->write_lock);
> > > +                       }
> > >               }
> > >
> > >       if (ca->alloc_thread)
> > > --
> > > 2.33.0
> >
> >
> > Thanks.
> >
> > Coly Li

