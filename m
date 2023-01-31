Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F412B682A4F
	for <lists+linux-bcache@lfdr.de>; Tue, 31 Jan 2023 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjAaKUW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 Jan 2023 05:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjAaKUV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2023 05:20:21 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB4113CD
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2023 02:20:16 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-15085b8a2f7so18733900fac.2
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2023 02:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBy2jVlsmc6DmeyDpHrUWJswxX5642/ZsZASsOv+Z/A=;
        b=eVkzQ21eXIOfrl8hwH6WuPALm6Ypu38cfcOEdSzGnmjRPtVrgF3qtI9ckxyxZCfxCm
         ALbA739Tvahx+wgF9My+h5B1JE3y+sIyvvwlpRyB/+yQDFSlEFPgCgXIzrJvZgRfY1P1
         SY/9fXT9zjuXQz04f/c6oNHWZmy+ysebWpRP7T1lDsj1WswOFrnL5TbxCMrgFTZz8lJX
         ixvLYqn/Fwk0k1TW+BZ/luBub4/uV5MzHNRd+OxO3ARcZ/B1L7TCehALm+tCHQzL5YSF
         jwPS1viC2x5S7IZGFuVMIK18x4AQXPIGiqyfgF8ZGe6nEU7dubC96MJI9YYo9LOxyg6U
         8P4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBy2jVlsmc6DmeyDpHrUWJswxX5642/ZsZASsOv+Z/A=;
        b=i4LPrBc4mOpcv6MnV+INH+7suaC5RwSHfMiPvzDg8/g1vmlQCprF8fvQiwzdrpLjTe
         kr1oDK3jdxmRtEGcUBcGthJpzxPRoeoTL6CCl+cMgiFL1BM6BUn/LtMqSb60I7Ma6Rtg
         4wTm2jBnvNqJRDaX1EKwVyljVDemfyOkb0HgYkXelCRk/T+V6F748L6wGM53LZh9ERHY
         iInoYOr73cp0K1LSyBeb6AxtHNw5Ced+n6lqmbGNBThVYcwpXpJ02MN+Bw68w+Cemu/1
         CCDfSGH/ecBJAhkGhTYyufp+tV3aDsI8hTcRgYZ35eHsFCJ6JHbnrD7Km78bqsfd672W
         27HA==
X-Gm-Message-State: AO0yUKXFpM05UEHhmEMQ8ILPmCUucx8JuRNLVJvRfFHRY4EUfNvB/kfT
        nmeZM6D6G68nsi43pwoNeq9V+Z9xcX4/vUl7l/IYiA==
X-Google-Smtp-Source: AK7set+JcUtgs3fPZQ1Mk5+8ZdsUWLl2+DCZ6U1dFFA3KpXnZBuG6ggN/i7zV1MbG1AHIO5/2osHi5A1VF+YpifI8Is=
X-Received: by 2002:a05:6870:9f17:b0:163:23ed:982c with SMTP id
 xl23-20020a0568709f1700b0016323ed982cmr1567433oab.230.1675160414972; Tue, 31
 Jan 2023 02:20:14 -0800 (PST)
MIME-Version: 1.0
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com> <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de> <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
 <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de> <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
 <8992dadc-4fb-494e-cec4-baf154d529a9@ewheeler.net>
In-Reply-To: <8992dadc-4fb-494e-cec4-baf154d529a9@ewheeler.net>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Tue, 31 Jan 2023 11:20:03 +0100
Message-ID: <CAHykVA6+vFtv9DbT_vmDFvectc1WiR4iWPY12z4LFGKhb5wJ5g@mail.gmail.com>
Subject: Re: [RFC] Live resize of backing device
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Eric,
thank you for your two cents.


On Fri, Jan 27, 2023 at 11:40 PM Eric Wheeler <bcache@lists.ewheeler.net> w=
rote:
>
> On Fri, 27 Jan 2023, Andrea Tomassetti wrote:
>
> > From 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 2001
> > From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> > Date: Thu, 8 Sep 2022 09:47:55 +0200
> > Subject: [PATCH v2] bcache: Add support for live resize of backing devi=
ces
> >
> > Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com=
>
> > ---
> > Hi Coly,
> > this is the second version of the patch. As you correctly pointed out,
> > I implemented roll-back functionalities in case of error.
> > I'm testing this funcionality using QEMU/KVM vm via libvirt.
> > Here the steps:
> >   1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
> >   2. mkfs.xfs /dev/bcache0
> >   3. mount /dev/bcache0 /mnt
> >   3. dd if=3D/dev/random of=3D/mnt/random0 bs=3D1M count=3D1000
> >   4. md5sum /mnt/random0 | tee /mnt/random0.md5
> >   5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size
> > <new-size>
> >   6. xfs_growfs /dev/bcache0
> >   6. Repeat steps 3 and 4 with a different file name (e.g. random1.md5)
> >   7. umount/reboot/remount and check that the md5 hashes are correct wi=
th
> >         md5sum -c /mnt/random?.md5
> >
> >  drivers/md/bcache/super.c | 84 ++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 83 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index ba3909bb6bea..1435a3f605f8 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -2443,6 +2443,85 @@ static bool bch_is_open(dev_t dev)
> >       return bch_is_open_cache(dev) || bch_is_open_backing(dev);
> >  }
> >
> > +static bool bch_update_capacity(dev_t dev)
> > +{
> > +     const size_t max_stripes =3D min_t(size_t, INT_MAX,
> > +                                      SIZE_MAX / sizeof(atomic_t));
> > +
> > +     uint64_t n, n_old, orig_cached_sectors =3D 0;
> > +     void *tmp_realloc;
> > +
> > +     int nr_stripes_old;
> > +     bool res =3D false;
> > +
> > +     struct bcache_device *d;
> > +     struct cache_set *c, *tc;
> > +     struct cached_dev *dcp, *t, *dc =3D NULL;
> > +
> > +     uint64_t parent_nr_sectors;
> > +
> > +     list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> > +             list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
> > +                     if (dcp->bdev->bd_dev =3D=3D dev) {
> > +                             dc =3D dcp;
> > +                             goto dc_found;
> > +                     }
> > +
> > +dc_found:
> > +     if (!dc)
> > +             return false;
> > +
> > +     parent_nr_sectors =3D bdev_nr_sectors(dc->bdev) - dc->sb.data_off=
set;
> > +
> > +     if (parent_nr_sectors =3D=3D bdev_nr_sectors(dc->disk.disk->part0=
))
> > +             return false;
> > +
> > +     d =3D &dc->disk;
> > +     orig_cached_sectors =3D d->c->cached_dev_sectors;
> > +
> > +     /* Force cached device sectors re-calc */
> > +     calc_cached_dev_sectors(d->c);
> > +
> > +     /* Block writeback thread */
> > +     down_write(&dc->writeback_lock);
> > +     nr_stripes_old =3D d->nr_stripes;
> > +     n =3D DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
> > +     if (!n || n > max_stripes) {
> > +             pr_err("nr_stripes too large or invalid: %llu (start sect=
or
> > beyond end of disk?)\n",
> > +                     n);
> > +             goto restore_dev_sectors;
> > +     }
> > +     d->nr_stripes =3D n;
>
> It looks like there is some overlap between the new bch_update_capacity()
> function and the existing bcache_device_init() function:

This is something I already pointed out in the first version of my
patch, some emails ago:

  - There is some reused code between this new function and
    `bcache_device_init`. Maybe I can move `const size_t max_stripes` to
    a broader scope or make it a macro, what do you think?

>
>         https://github.com/torvalds/linux/blob/master/drivers/md/bcache/s=
uper.c#L909
>
> IMHO, it would be ideal if bch_update_capacity() could also handle the
> uninitialized state of full_dirty_stripes/stripe_sectors_dirty (and any
> related bits) at bdev registration time so bcache_device_init() can call
> bch_update_capacity().  Thus, bch_update_capacity() would replace the
> set_capacity() call in bcache_device_init().
>
Nice idea

Regards,
Andrea

> If a call to bch_update_capacity() can set the size at registration or
> resize as necessary then it would remove duplicate code and keep
> initialization in only one place.
>
> I'll defer to what Coly thinks is best, just my $0.02
>
> Cheers,
>
>
> --
> Eric Wheeler
>
>
>
> > +
> > +     n =3D d->nr_stripes * sizeof(atomic_t);
> > +     n_old =3D nr_stripes_old * sizeof(atomic_t);
> > +     tmp_realloc =3D kvrealloc(d->stripe_sectors_dirty, n_old,
> > +             n, GFP_KERNEL);
> > +     if (!tmp_realloc)
> > +             goto restore_nr_stripes;
> > +
> > +     d->stripe_sectors_dirty =3D (atomic_t *) tmp_realloc;
> > +
> > +     n =3D BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
> > +     n_old =3D BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
> > +     tmp_realloc =3D kvrealloc(d->full_dirty_stripes, n_old, n, GFP_KE=
RNEL);
> > +     if (!tmp_realloc)
> > +             goto restore_nr_stripes;
> > +
> > +     d->full_dirty_stripes =3D (unsigned long *) tmp_realloc;
> > +
> > +     if ((res =3D set_capacity_and_notify(dc->disk.disk, parent_nr_sec=
tors)))
> > +             goto unblock_and_exit;
> > +
> > +restore_nr_stripes:
> > +     d->nr_stripes =3D nr_stripes_old;
> > +restore_dev_sectors:
> > +     d->c->cached_dev_sectors =3D orig_cached_sectors;
> > +unblock_and_exit:
> > +     up_write(&dc->writeback_lock);
> > +     return res;
> > +}
> > +
> >  struct async_reg_args {
> >       struct delayed_work reg_work;
> >       char *path;
> > @@ -2569,7 +2648,10 @@ static ssize_t register_bcache(struct kobject *k=
,
> > struct kobj_attribute *attr,
> >                       mutex_lock(&bch_register_lock);
> >                       if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> >                           bch_is_open(dev))
> > -                             err =3D "device already registered";
> > +                             if (bch_update_capacity(dev))
> > +                                     err =3D "capacity changed";
> > +                             else
> > +                                     err =3D "device already registere=
d";
> >                       else
> >                               err =3D "device busy";
> >                       mutex_unlock(&bch_register_lock);
> > --
> > 2.39.0
> >
> >
> >
> > On 25/1/23 18:59, Coly Li wrote:
> > >
> > >
> > >> 2023=E5=B9=B41=E6=9C=8825=E6=97=A5 18:07=EF=BC=8CAndrea Tomassetti
> > >> <andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>
> > >> On Tue, Jan 17, 2023 at 5:18 PM Coly Li <colyli@suse.de> wrote:
> > >>>>
> > >
> > >>>>>
> > >>>>>> struct async_reg_args {
> > >>>>>>     struct delayed_work reg_work;
> > >>>>>>     char *path;
> > >>>>>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kob=
ject
> > >>>>>> *k, struct kobj_attribute *attr,
> > >>>>>>             mutex_lock(&bch_register_lock);
> > >>>>>>             if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> > >>>>>>                 bch_is_open(dev))
> > >>>>>> -                err =3D "device already registered";
> > >>>>>> +                if (bch_update_capacity(dev))
> > >>>>>> +                    err =3D "capacity changed";
> > >>>>>> +                else
> > >>>>>> +                    err =3D "device already registered";
> > >>>>>
> > >>>>>
> > >>>>> As I said, it should be a separated write-only sysfile under the =
cache
> > >>>>> device's directory.
> > >>>> Can I ask why you don't like the automatic resize way? Why should =
the
> > >>>> resize be manual?
> > >>>
> > >>> Most of system administrators don=E2=80=99t like such silently auto=
matic things.
> > >>> They want to extend the size explicitly, especially when there is o=
ther
> > >>> dependences in their configurations.
> > >>>
> > >> What I was trying to say is that, in order to resize a block device,=
 a
> > >> manual command should be executed. So, this is already a "non-silent=
"
> > >> automatic thing.
> > >> Moreover, if the block device has a FS on it, the FS needs to be
> > >> manually grown with some special utilities, e.g. xfs_growfs. So,
> > >> again, another non-silent automatic step. Don't you agree?
> > >> For example, to resize a qcow device attached to a VM I'm manually
> > >> doing a `virsh blockresize`. As soon as I issue that command, the
> > >> virtio_blk driver inside the VM detects the disk size change and cal=
ls
> > >> the `set_capacity_and_notify` function. Why then should bcache behav=
e
> > >> differently?
> > >
> > > The above VM example makes sense, I am almost convinced.
> > >
> > >>
> > >> If you're concerned that this can somehow break the
> > >> behaviour-compatibility with older versions of the driver, can we
> > >> protect this automatic discovery with an optional parameter? Will th=
is
> > >> be an option you will take into account?
> > >
> > > Then let=E2=80=99s forget the option sysfs at this moment. Once you f=
eel the patch
> > > is ready for me to testing, please notice me with detailed steps to r=
edo
> > > your testing.
> > > At that time during my testing, let=E2=80=99s discuss whether an extr=
a option is
> > > necesssary, for now just keep your idea as automatically resize the c=
ached
> > > device.
> > >
> > > Thanks for your detailed explanation.
> > >
> > > Coly Li
> > >
> >
> >
