Return-Path: <linux-bcache+bounces-1355-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC30BCEBD61
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Dec 2025 12:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6ECDF3017868
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Dec 2025 11:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 037E6313263;
	Wed, 31 Dec 2025 11:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KviW8yi2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95829233D9C
	for <linux-bcache@vger.kernel.org>; Wed, 31 Dec 2025 11:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767178965; cv=none; b=uATL6CXU8ps9vCfnc4Q7IlQVt6VQc8+uwRmmTEkHjO7aYgYS/Njzw79xd4ctK1CvLVsIVbTFO0la0Q6DbIRz4PxwJXcjgGUoJ7xx0HxOeJ8+/v+IQ++dqtWO9FUF+/CHVddkR3jZGz7ckGJ62l/Yzh5X+s3gAbGOhAy1+kZ0Vxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767178965; c=relaxed/simple;
	bh=ysk6+ongJvPRbbG1uVFJI/jmcbLFa8c5xooKxTHpfdk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IzBWWply5wE8G4eX62Mn9Gpv01lkjzq1O1nF7jMFc55VH0xQlLqOmQ/SAhy4JdPx5qZ/lJWuhlQtgxYZEzu5aUaey7n/x91MnF+3GerAUKvBQXN4nZV1ONEXPwGGZebj1qSYQbwTShjBNAL6fUxVHfutDZf9hZqOqtuxz0QzKhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KviW8yi2; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b7eff205947so1529822566b.1
        for <linux-bcache@vger.kernel.org>; Wed, 31 Dec 2025 03:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767178962; x=1767783762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gmouQycwaR0nvn7xB77nXirTToGOjbdvAlTqh8MU83w=;
        b=KviW8yi2cPYOsbsklVfeNFnjl8p6b8Q6dXG4B9RWuVzhPoRvdUAmVWlMd/HaG8Eu1c
         K4l7CaN3nwHP5GyyZdAacomD74AKE6CQa3gw/+L0KBLVou5zCJKYYEQT4sWqjn+S7NZ3
         LDtKfFuP7WheoZvWpkRGpc62cYqSPno/+X9pNAXUSLSiSMCj0pyWvdsCcwKf2YDTa6Dt
         I4+jQfd4jlPfyG0Vrq0JdxzuoH4w0DIwV6GKly49oh6QG1v9BD9MoIELOannlEnZQv2Y
         zDUq2B7uInhsvvD32RxAIJoq7aXYPKMV1nF/UaChrBsvVy02wrACfrkdnfre/GSAf15M
         o86Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767178962; x=1767783762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gmouQycwaR0nvn7xB77nXirTToGOjbdvAlTqh8MU83w=;
        b=rlR+eOsnAT9CVZMoZKU3SnBe15YKC3b3BsIUpkPD51Qu8zACSOoCHUQIF58RjzuJTE
         IVHO6LnyAlFBPaZv1oqIZqT5gxV9kJZAVzruwevLIJFY4NGpGJIyHL1jZl0ef8Xl4giH
         99n7Z476UatUmF3jEpSHWkv4aL1OUjIaCI35cuV0P5rYCB8MR8PPBFeKUYC/7kro2z0q
         mO7Mbo6BzusWr2GtIFUxS3YPqco3OCrLGuxS06/Eg9sMePMop4vD7Ko7hiJE+bebdimk
         0OPmW5hHU1Jn3Z+ylp0HQ26Oq/S6pzX1cANgFf2VJdDJBLl9kugOLQn1+WZjvdJdW1rI
         Fn7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW3YN/phcfAi9NdoOeW6bzdOhAZCnKWOj6mg6unlAO2u7XmER5gml3mRqpE7UzNo9jBnnzYE69KdaCivX0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzefymPJzXBCeVYiKov/0PeBLpJx/XKv3NvsU0MCrZlN68SGPra
	oVjCEoktsDlNGRhbcyfTBpUQAL58t7oufUng5bMEjvLuLumw12XlsPRkHFN7h+GeeS8Y5DiUihS
	8ZmHJbd2jD9ciU8a64aIxAvXg5486T3s=
X-Gm-Gg: AY/fxX6SnlTskF5cw4LiUCROhVUfI1RDCFp7x9F5e+9YJtcAOKFk0wxzLEFC2+U3wQ+
	+sr9fjb1CsGtenAploTJNX7HxCRVFgwdmsFrgMZRTqyupA92e6eGHQqPgzdWyvURYkPhXd1jDsY
	Yj5QhpAJ4uMSfAhJ0+GX9SzqfATvJ51AQcNJXMZG4h7kSBOqv675Vt9NMqDi4z35ycgcTHTkobl
	7VkVbB+cwhNfvB04yq+uMJLOuTQtMAkAFKVPbJNaEbUq+0o0ygHU54q0uCSenO2wJjbK58QXlDn
	MRGguuw=
X-Google-Smtp-Source: AGHT+IGe+0TL9C+tqUCYB9pXQ9XZafBP8OHAPofJsNuA7ghUqdCNx7GljW25i2BmQrdTLhyk/9a7ULFvMKJJJLfWsTI=
X-Received: by 2002:a17:907:7e86:b0:b76:8074:344b with SMTP id
 a640c23a62f3a-b8036ebdd9emr3538764566b.8.1767178961614; Wed, 31 Dec 2025
 03:02:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251230113357.1299759-1-wale.zhang.ftd@gmail.com> <aVPDeUkQ1f_PqEDs@studio.local>
In-Reply-To: <aVPDeUkQ1f_PqEDs@studio.local>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Wed, 31 Dec 2025 19:02:30 +0800
X-Gm-Features: AQt7F2pSrSQx0j_fjVFIZ2fIexUlkIDQGN8M4GceYlHDgB88hsTLUNVEtSpTsh4
Message-ID: <CAHrEdeuuj_WQQ00i344TqgwoxLJJv--3sCEx5rFrseXtLjog4w@mail.gmail.com>
Subject: Re: [RFC PATCH] bcache: make bcache_is_reboot atomic.
To: Coly Li <colyli@fnnas.com>
Cc: kent.overstreet@linux.dev, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 30, 2025 at 8:22=E2=80=AFPM Coly Li <colyli@fnnas.com> wrote:
>
> On Tue, Dec 30, 2025 at 07:33:57PM +0800, Wale Zhang wrote:
> > bcache: make bcache_is_reboot atomic.
> >
> > The smp_mb is mainly used to ensure the dependency relationship between
> > variables, but there is only one variable bcache_is_reboot. Therefore,
> > using smp_mb is not very appropriate.
> >
> > When bcache_reboot and register_bcache occur concurrently, register_bca=
che
> > cannot immediately detect that bcache_is_reboot has been set to true.
> >
> >     cpu0                            cpu1
> > bcache_reboot
> >   bcache_is_reboot =3D true;
> >   smp_mb();                      register_bcache
> >                                    smp_mb();
> >                                    if (bcache_is_reboot)
> >                                    // bcache_is_reboot may still be fal=
se.
> >
>
> From the above comments, I don't see what problem this patch tries to sol=
ve.
> And read or write bcache_is_reboot is atomic indeed, I don't see the diff=
erence
> this patch makes.

Hello Coly,

I'm puzzled by the use of smp_mb in this bcache_is_reboot scenario.

I know that smp_mb is typically used for the scenarios where data
dependency is involved, such as
---------------------------------
 CPU0          CPU1
  x=3D1              y=3D1
smp_mb      smb_mb
 load y          load x
---------------------------------
If CPU1 observe x=3D=3D1, then CPU0 must also observe y=3D=3D1.

Thank you for clearing up my puzzlement.

Thanks
Wale

> Thanks.
>
> Coly Li
>
> > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > ---
> >  drivers/md/bcache/super.c | 19 ++++++-------------
> >  drivers/md/bcache/sysfs.c | 14 +++++++-------
> >  2 files changed, 13 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index c17d4517af22..0b2098aa7234 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -41,7 +41,7 @@ static const char invalid_uuid[] =3D {
> >
> >  static struct kobject *bcache_kobj;
> >  struct mutex bch_register_lock;
> > -bool bcache_is_reboot;
> > +atomic_t bcache_is_reboot =3D ATOMIC_INIT(0);
> >  LIST_HEAD(bch_cache_sets);
> >  static LIST_HEAD(uncached_devices);
> >
> > @@ -2561,10 +2561,8 @@ static ssize_t register_bcache(struct kobject *k=
, struct kobj_attribute *attr,
> >       if (!try_module_get(THIS_MODULE))
> >               goto out;
> >
> > -     /* For latest state of bcache_is_reboot */
> > -     smp_mb();
> >       err =3D "bcache is in reboot";
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               goto out_module_put;
> >
> >       ret =3D -ENOMEM;
> > @@ -2735,7 +2733,7 @@ static ssize_t bch_pending_bdevs_cleanup(struct k=
object *k,
> >
> >  static int bcache_reboot(struct notifier_block *n, unsigned long code,=
 void *x)
> >  {
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return NOTIFY_DONE;
> >
> >       if (code =3D=3D SYS_DOWN ||
> > @@ -2750,16 +2748,11 @@ static int bcache_reboot(struct notifier_block =
*n, unsigned long code, void *x)
> >
> >               mutex_lock(&bch_register_lock);
> >
> > -             if (bcache_is_reboot)
> > +             if (atomic_read(&bcache_is_reboot))
> >                       goto out;
> >
> >               /* New registration is rejected since now */
> > -             bcache_is_reboot =3D true;
> > -             /*
> > -              * Make registering caller (if there is) on other CPU
> > -              * core know bcache_is_reboot set to true earlier
> > -              */
> > -             smp_mb();
> > +             atomic_set(&bcache_is_reboot, 1);
> >
> >               if (list_empty(&bch_cache_sets) &&
> >                   list_empty(&uncached_devices))
> > @@ -2935,7 +2928,7 @@ static int __init bcache_init(void)
> >
> >       bch_debug_init();
> >
> > -     bcache_is_reboot =3D false;
> > +     atomic_set(&bcache_is_reboot, 0);
> >
> >       return 0;
> >  err:
> > diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> > index 72f38e5b6f5c..5384653c5bbb 100644
> > --- a/drivers/md/bcache/sysfs.c
> > +++ b/drivers/md/bcache/sysfs.c
> > @@ -17,7 +17,7 @@
> >  #include <linux/sort.h>
> >  #include <linux/sched/clock.h>
> >
> > -extern bool bcache_is_reboot;
> > +extern atomic_t bcache_is_reboot;
> >
> >  /* Default is 0 ("writethrough") */
> >  static const char * const bch_cache_modes[] =3D {
> > @@ -296,7 +296,7 @@ STORE(__cached_dev)
> >       struct kobj_uevent_env *env;
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >  #define d_strtoul(var)               sysfs_strtoul(var, dc->var)
> > @@ -459,7 +459,7 @@ STORE(bch_cached_dev)
> >                                            disk.kobj);
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >       mutex_lock(&bch_register_lock);
> > @@ -571,7 +571,7 @@ STORE(__bch_flash_dev)
> >       struct uuid_entry *u =3D &d->c->uuids[d->id];
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >       sysfs_strtoul(data_csum,        d->data_csum);
> > @@ -814,7 +814,7 @@ STORE(__bch_cache_set)
> >       ssize_t v;
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >       if (attr =3D=3D &sysfs_unregister)
> > @@ -941,7 +941,7 @@ STORE(bch_cache_set_internal)
> >       struct cache_set *c =3D container_of(kobj, struct cache_set, inte=
rnal);
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >       return bch_cache_set_store(&c->kobj, attr, buf, size);
> > @@ -1137,7 +1137,7 @@ STORE(__bch_cache)
> >       ssize_t v;
> >
> >       /* no user space access if system is rebooting */
> > -     if (bcache_is_reboot)
> > +     if (atomic_read(&bcache_is_reboot))
> >               return -EBUSY;
> >
> >       if (attr =3D=3D &sysfs_cache_replacement_policy) {
> > --
> > 2.43.0

