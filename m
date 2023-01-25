Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC6367AF4A
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Jan 2023 11:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbjAYKHW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 Jan 2023 05:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjAYKHV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Jan 2023 05:07:21 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6452A168
        for <linux-bcache@vger.kernel.org>; Wed, 25 Jan 2023 02:07:19 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-15bb8ec196aso20826588fac.3
        for <linux-bcache@vger.kernel.org>; Wed, 25 Jan 2023 02:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHpnmt8O8xXodUPpfgNiGxZfKbIyLH2J24N8J32FMbc=;
        b=TaQmMmaiORRUTuOLnP2m/q8mS8anKYDYZGrc/v8liL9sfjCKEnCLncCbEWfDDcGF6Y
         YZ3YhoJWLc9O4n59+V7fqjuzK1ntNDsyc2dG0LHvIS+yuuX60MLSxLD5hl6M5rr49IAJ
         7dDPrBIpwPkjSHGhkV+zIokt9LAsI6YR3T22M0c3a4AByH9LjiELmxSHX+GDmhHcBJLN
         TGhO+FTIMbo9rU3Lf3RoULKBsYNHulQDGBaC5pgdzBm2mST9FEpLdesU5YUuCc1k/7j4
         KnPrRwe1fU+b+jI888ZbIUO/HJx0wcNW0jzrNsclKSEIb2uvQ09DuUbCLZ+PvfsMP+wi
         15UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHpnmt8O8xXodUPpfgNiGxZfKbIyLH2J24N8J32FMbc=;
        b=uBpVHpstiSOInOICxaIM9cbkhTBekEwC+gHtdU8/5PI33QWmcOSyjUMFJV7gGXTWFL
         OWb4jea8IZe/s33xnldwiU32Pwpmj/d+8jiDDz240zgVzkTA0Ch/EjH7UhxxUvKBO8uY
         VKvfoEoKlkqkQfi8ud9goixvWQ+Ee7JmleuCO3XdvuNN/gYkGrDVNjhhPP9LMZpcTzmM
         U10I7KlFEwIdErwqN+kKOs8Vfxom9Xm4g2I3Y/thdWX3eLk78nUR+s+QlmBAC/fNAgel
         ldWSmHnincGnQGulzmdX1L0oFo8uK/h2s1+/JBWGNht1K+JN2sxoqIYP64MtAq/IC6hG
         MC1A==
X-Gm-Message-State: AO0yUKWKdaRvxhL2RAYZO9ilj3goiTcG1Oj8G0HJw52I2hfeDe5mznaM
        J8frFAYD3BmmdAGdtEefrf0vt7dM/tWUCIMGBA+ylsct0LLcv7Jz/0c=
X-Google-Smtp-Source: AK7set8aRpLjhXl7OTZjufI/ypsQoc8c56/iLu/F6TYn1B1/cow3p057oujF8pzPonNwSI2fsWC2iwG2okjNhUoCWPc=
X-Received: by 2002:a05:6870:8311:b0:163:2f0c:3ce7 with SMTP id
 p17-20020a056870831100b001632f0c3ce7mr130639oae.6.1674641238976; Wed, 25 Jan
 2023 02:07:18 -0800 (PST)
MIME-Version: 1.0
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com> <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com> <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
In-Reply-To: <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 25 Jan 2023 11:07:07 +0100
Message-ID: <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
Subject: Re: [RFC] Live resize of backing device
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
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

On Tue, Jan 17, 2023 at 5:18 PM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2023=E5=B9=B41=E6=9C=8812=E6=97=A5 00:01=EF=BC=8CAndrea Tomassetti <and=
rea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> > thank you for taking the time to reply, I really hope you are feeling
> > better now.
>
> Thanks. But the recovery is really slow, and my response cannot be in tim=
e. I was told it might be better after 1 month, hope it is true.
>
> >
> > On Fri, Dec 30, 2022 at 11:41 AM Coly Li <colyli@suse.de> wrote:
> >>
> >> On 9/8/22 4:32 PM, Andrea Tomassetti wrote:
> >>> From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 200=
1
> >>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> >>> Date: Thu, 8 Sep 2022 09:47:55 +0200
> >>> Subject: [PATCH] bcache: Add support for live resize of backing devic=
es
> >>>
> >>> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.c=
om>
> >>
> >> Hi Andrea,
> >>
> >> I am just recovered from Omicron, and able to reply email. Let me plac=
e
> >> my comments inline.
> >>
> >>
> >>> ---
> >>> Hi Coly,
> >>> Here is the first version of the patch. There are some points I noted
> >>> down
> >>> that I would like to discuss with you:
> >>> - I found it pretty convenient to hook the call of the new added
> >>> function
> >>>   inside the `register_bcache`. In fact, every time (at least from my
> >>>   understandings) a disk changes size, it will trigger a new probe an=
d,
> >>>   thus, `register_bcache` will be triggered. The only inconvenient
> >>>   is that, in case of success, the function will output
> >>
> >> The resize should be triggered manually, and not to do it automaticall=
y.
> >>
> >> You may create a sysfs file under the cached device's directory, name =
it
> >> as "extend_size" or something else you think better.
> >>
> >> Then the sysadmin may extend the cached device size explicitly on a
> >> predictable time.
> >>
> >>> `error: capacity changed` even if it's not really an error.
> >>> - I'm using `kvrealloc`, introduced in kernel version 5.15, to resize
> >>>   `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
> >>>   problem, right?
> >>> - There is some reused code between this new function and
> >>>   `bcache_device_init`. Maybe I can move `const size_t max_stripes` t=
o
> >>>   a broader scope or make it a macro, what do you think?
> >>>
> >>> Thank you very much,
> >>> Andrea
> >>>
> >>> drivers/md/bcache/super.c | 75 ++++++++++++++++++++++++++++++++++++++=
-
> >>> 1 file changed, 74 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >>> index ba3909bb6bea..9a77caf2a18f 100644
> >>> --- a/drivers/md/bcache/super.c
> >>> +++ b/drivers/md/bcache/super.c
> >>> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
> >>>     return bch_is_open_cache(dev) || bch_is_open_backing(dev);
> >>> }
> >>>
> >>> +static bool bch_update_capacity(dev_t dev)
> >>> +{
> >>> +    const size_t max_stripes =3D min_t(size_t, INT_MAX,
> >>> +                     SIZE_MAX / sizeof(atomic_t));
> >>> +
> >>> +    uint64_t n, n_old;
> >>> +    int nr_stripes_old;
> >>> +    bool res =3D false;
> >>> +
> >>> +    struct bcache_device *d;
> >>> +    struct cache_set *c, *tc;
> >>> +    struct cached_dev *dcp, *t, *dc =3D NULL;
> >>> +
> >>> +    uint64_t parent_nr_sectors;
> >>> +
> >>> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> >>> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
> >>> +            if (dcp->bdev->bd_dev =3D=3D dev) {
> >>> +                dc =3D dcp;
> >>> +                goto dc_found;
> >>> +            }
> >>> +
> >>> +dc_found:
> >>> +    if (!dc)
> >>> +        return false;
> >>> +
> >>> +    parent_nr_sectors =3D bdev_nr_sectors(dc->bdev) - dc->sb.data_of=
fset;
> >>> +
> >>> +    if (parent_nr_sectors =3D=3D bdev_nr_sectors(dc->disk.disk->part=
0))
> >>> +        return false;
> >>> +
> >>
> >> The above code only handles whole disk using as cached device. If a
> >> partition of a hard drive is used as cache device, and there are other
> >> data after this partition, such condition should be handled as well. S=
o
> >> far I am fine to only extend size when using the whole hard drive as
> >> cached device, but more code is necessary to check and only permits
> >> size-extend for such condition.
> > I don't understand if there's a misalignment here so let me be more
> > clear: this patch is intended to support the live resize of *backing
> > devices*, is this what you mean with "cached device"?
>
> Yes, backing device is cached device.
>
>
> > When I was working on the patch I didn't consider the possibility of
> > live resizing the cache devices, but it should be trivial.
> > So, as far as I understand, a partition cannot be used as a backing
> > device, correct? The whole disk should be used as a backing device,
> > that's why I'm checking and that's why this check should be correct.
> > Am I wrong?
>
> Yes a partition can be used as a backing (cached) device.
> That is to say, if a file system is format on top of the cached device, t=
his file system cannot be directly accessed via the partition. It has to be=
 accessed via the bcache device e.g. /dev/bcache0.
>
>
> >
> >>
> >>> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
> >>> +        return false;
> >>
> >> The above code should be done when all rested are set.
> >>
> >>
> >>> +
> >>> +    d =3D &dc->disk;
> >>> +
> >>> +    /* Force cached device sectors re-calc */
> >>> +    calc_cached_dev_sectors(d->c);
> >>
> >> Here c->cached_dev_sectors might be changed, if any of the following
> >> steps fails, it should be restored to previous value.
> >>
> >>
> >>> +
> >>> +    /* Block writeback thread */
> >>> +    down_write(&dc->writeback_lock);
> >>> +    nr_stripes_old =3D d->nr_stripes;
> >>> +    n =3D DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
> >>> +    if (!n || n > max_stripes) {
> >>> +        pr_err("nr_stripes too large or invalid: %llu (start sector
> >>> beyond end of disk?)\n",
> >>> +            n);
> >>> +        goto unblock_and_exit;
> >>> +    }
> >>> +    d->nr_stripes =3D n;
> >>> +
> >>> +    n =3D d->nr_stripes * sizeof(atomic_t);
> >>> +    n_old =3D nr_stripes_old * sizeof(atomic_t);
> >>> +    d->stripe_sectors_dirty =3D kvrealloc(d->stripe_sectors_dirty, n=
_old,
> >>> +        n, GFP_KERNEL);
> >>> +    if (!d->stripe_sectors_dirty)
> >>> +        goto unblock_and_exit;
> >>> +
> >>> +    n =3D BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
> >>> +    n_old =3D BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
> >>> +    d->full_dirty_stripes =3D kvrealloc(d->full_dirty_stripes, n_old=
,
> >>> n, GFP_KERNEL);
> >>> +    if (!d->full_dirty_stripes)
> >>> +        goto unblock_and_exit;
> >>
> >> If kvrealloc() fails and NULL set to d->full_dirty_sripes, the previou=
s
> >> array should be restored.
> >>
> >>> +
> >>> +    res =3D true;
> >>> +
> >>> +unblock_and_exit:
> >>> +    up_write(&dc->writeback_lock);
> >>> +    return res;
> >>> +}
> >>> +
> >>
> >> I didn't test the patch, from the first glance, I feel the failure
> >> handling should restore all previous values, otherwise the cache devic=
e
> >> may be in a non-consistent state when extend size fails.
> >>
> > Completely agree with you on this point. I changed it locally and, as
> > soon as we agree on the other points I'll send a newer version of the
> > patch.
> >>
> >>> struct async_reg_args {
> >>>     struct delayed_work reg_work;
> >>>     char *path;
> >>> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject
> >>> *k, struct kobj_attribute *attr,
> >>>             mutex_lock(&bch_register_lock);
> >>>             if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> >>>                 bch_is_open(dev))
> >>> -                err =3D "device already registered";
> >>> +                if (bch_update_capacity(dev))
> >>> +                    err =3D "capacity changed";
> >>> +                else
> >>> +                    err =3D "device already registered";
> >>
> >>
> >> As I said, it should be a separated write-only sysfile under the cache
> >> device's directory.
> > Can I ask why you don't like the automatic resize way? Why should the
> > resize be manual?
>
> Most of system administrators don=E2=80=99t like such silently automatic =
things. They want to extend the size explicitly, especially when there is o=
ther dependences in their configurations.
>
What I was trying to say is that, in order to resize a block device, a
manual command should be executed. So, this is already a "non-silent"
automatic thing.
Moreover, if the block device has a FS on it, the FS needs to be
manually grown with some special utilities, e.g. xfs_growfs. So,
again, another non-silent automatic step. Don't you agree?
For example, to resize a qcow device attached to a VM I'm manually
doing a `virsh blockresize`. As soon as I issue that command, the
virtio_blk driver inside the VM detects the disk size change and calls
the `set_capacity_and_notify` function. Why then should bcache behave
differently?

If you're concerned that this can somehow break the
behaviour-compatibility with older versions of the driver, can we
protect this automatic discovery with an optional parameter? Will this
be an option you will take into account?

Thank you very much,
Andrea
>
> > Someone needs to trigger the block device resize, so shouldn't that be =
enough?
>
> Yes, an explicit write operation on a sysfs file to trigger the resize. T=
hen we can permit people to do the size extend explicit and avoid to change=
 current behavior.
>
> Thanks.
>
> Coly Li
>
> >
> > Andrea
> >>
> >>
> >>> else
> >>>                 err =3D "device busy";
> >>>             mutex_unlock(&bch_register_lock);
> >>> --
> >>> 2.37.3
> >>>
> >>
>
