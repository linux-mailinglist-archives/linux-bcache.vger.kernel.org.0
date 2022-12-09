Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBC1647FA8
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Dec 2022 09:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLII6E (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Dec 2022 03:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiLII6B (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Dec 2022 03:58:01 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D8126AB8
        for <linux-bcache@vger.kernel.org>; Fri,  9 Dec 2022 00:57:56 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id cn2-20020a056830658200b0066c74617e3dso2422825otb.2
        for <linux-bcache@vger.kernel.org>; Fri, 09 Dec 2022 00:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ixDe/jUtXQQRaAXkanYLFduCSS8x+IDVDdTs28wLwE8=;
        b=TSCWMRf8j+jXM9OVGKv4PPccG3B1L75ENPrzPKxk8w3zKIslqDl9k7rO6XqyFLDwvx
         qwACWTqHsqAWs0bxtGrK/uKCOB2PFXMEHyDYk94okOS6IrwyKxAW0/GE1NzY6/BmGmGE
         O9rQUI4vuBo6CVyDck+yfCq4A5v3+q7ndOlsa1DTRUWBZoToMpTR+IulZA9z2Pz+ZWX5
         WqGyjm7UC9D0p+JSB9v/E2zNhcdFoQ74kP9VXZhnQRueJqxGqL3JUBG19hYe1XEi184Y
         1R6XBHSjXWFVAR5dEBjI5V0REgf6inGggYI26hoY0EKuA8VcWJ/AShWuvEPkfV7DUNv+
         fxAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ixDe/jUtXQQRaAXkanYLFduCSS8x+IDVDdTs28wLwE8=;
        b=8CJYuS2CVr3Fm7CKgYQTwk9FdOvPpA6SEmo5VwQdq716UcKf5mWZngKHCfwtUi5Db+
         QVKUcFX+idIhUtPAsDu2uldL6uiX8T6A012ujRUbl3afW1JJiRsGmfkB5MbP3rcgmfpy
         gpTAuHPXvASPmdMOhnHpZI2yrByjtlq+bulZ+6mC76zACCrA3s6rryTlBdVratE0yLYb
         rw4PMggiE0TS0+Y46lJMHi30+Dars11mQZDEk0/XpNt9shwfDlsAQXSev7Yso/F2OgX2
         C/cCmtZszdCD61Tqkm31to1vCBQ0/mX8m0OUsynBWEj+whn7snUSzNu0hlDU7y+X5UF+
         UlpA==
X-Gm-Message-State: ANoB5pnNjoG21JXdWLI8cY9vX9mFU4mW97lwxN7T8q9JFeEBV0T9Mbl9
        hFI5A/H9J0OD/dY4vMX/lPDRFXAIYJCFI6vxGbJz8w==
X-Google-Smtp-Source: AA0mqf6c0vUOjkfchAg8IShoixW39VRICRkWeIaHY6XuLOJ/vVuIA4Alnbv65P7mUecNxXT4q0Pcm4H9hsR1msTUhDY=
X-Received: by 2002:a05:6830:91f:b0:66e:824b:e48d with SMTP id
 v31-20020a056830091f00b0066e824be48dmr12645858ott.212.1670576276261; Fri, 09
 Dec 2022 00:57:56 -0800 (PST)
MIME-Version: 1.0
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com> <14c2bdbd-e4ae-a5d1-3947-6ea6dc29f0bc@devo.com>
 <E8AC75B3-1BAD-4AD8-AD77-ADE8A2E9E8C6@suse.de>
In-Reply-To: <E8AC75B3-1BAD-4AD8-AD77-ADE8A2E9E8C6@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Fri, 9 Dec 2022 09:57:45 +0100
Message-ID: <CAHykVA4tz_WxmYae9i+TUPLmEsUpJ0rxMV_cs=4st0voM=Oo9w@mail.gmail.com>
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

Hi Coly,
just a kind reminder for this patch.

Thank you very much,
Andrea

On Mon, Sep 19, 2022 at 2:17 PM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B49=E6=9C=8819=E6=97=A5 19:42=EF=BC=8CAndrea Tomassetti <and=
rea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi Coly,
> > have you had any time to take a look at this? Do you prefer if I send t=
he patch as a separate thread?
> >
> > Thank you very much,
> > Andrea
>
>
> Yes, it is on my queue, just after I finish my tasks on hand, I will take=
 a look on it.
>
> Thanks.
>
> Coly Li
>
>
> >
> > On 8/9/22 10:32, Andrea Tomassetti wrote:
> >> From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 2001
> >> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> >> Date: Thu, 8 Sep 2022 09:47:55 +0200
> >> Subject: [PATCH] bcache: Add support for live resize of backing device=
s
> >> Signed-off-by: Andrea Tomassetti <andrea.tomassetti-opensource@devo.co=
m>
> >> ---
> >> Hi Coly,
> >> Here is the first version of the patch. There are some points I noted =
down
> >> that I would like to discuss with you:
> >>  - I found it pretty convenient to hook the call of the new added func=
tion
> >>    inside the `register_bcache`. In fact, every time (at least from my
> >>    understandings) a disk changes size, it will trigger a new probe an=
d,
> >>    thus, `register_bcache` will be triggered. The only inconvenient
> >>    is that, in case of success, the function will output
> >>    `error: capacity changed` even if it's not really an error.
> >>  - I'm using `kvrealloc`, introduced in kernel version 5.15, to resize
> >>    `stripe_sectors_dirty` and `full_dirty_stripes`. It shouldn't be a
> >>    problem, right?
> >>  - There is some reused code between this new function and
> >>    `bcache_device_init`. Maybe I can move `const size_t max_stripes` t=
o
> >>    a broader scope or make it a macro, what do you think?
> >> Thank you very much,
> >> Andrea
> >>  drivers/md/bcache/super.c | 75 ++++++++++++++++++++++++++++++++++++++=
-
> >>  1 file changed, 74 insertions(+), 1 deletion(-)
> >> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> >> index ba3909bb6bea..9a77caf2a18f 100644
> >> --- a/drivers/md/bcache/super.c
> >> +++ b/drivers/md/bcache/super.c
> >> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
> >>      return bch_is_open_cache(dev) || bch_is_open_backing(dev);
> >>  }
> >> +static bool bch_update_capacity(dev_t dev)
> >> +{
> >> +    const size_t max_stripes =3D min_t(size_t, INT_MAX,
> >> +                     SIZE_MAX / sizeof(atomic_t));
> >> +
> >> +    uint64_t n, n_old;
> >> +    int nr_stripes_old;
> >> +    bool res =3D false;
> >> +
> >> +    struct bcache_device *d;
> >> +    struct cache_set *c, *tc;
> >> +    struct cached_dev *dcp, *t, *dc =3D NULL;
> >> +
> >> +    uint64_t parent_nr_sectors;
> >> +
> >> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> >> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
> >> +            if (dcp->bdev->bd_dev =3D=3D dev) {
> >> +                dc =3D dcp;
> >> +                goto dc_found;
> >> +            }
> >> +
> >> +dc_found:
> >> +    if (!dc)
> >> +        return false;
> >> +
> >> +    parent_nr_sectors =3D bdev_nr_sectors(dc->bdev) - dc->sb.data_off=
set;
> >> +
> >> +    if (parent_nr_sectors =3D=3D bdev_nr_sectors(dc->disk.disk->part0=
))
> >> +        return false;
> >> +
> >> +    if (!set_capacity_and_notify(dc->disk.disk, parent_nr_sectors))
> >> +        return false;
> >> +
> >> +    d =3D &dc->disk;
> >> +
> >> +    /* Force cached device sectors re-calc */
> >> +    calc_cached_dev_sectors(d->c);
> >> +
> >> +    /* Block writeback thread */
> >> +    down_write(&dc->writeback_lock);
> >> +    nr_stripes_old =3D d->nr_stripes;
> >> +    n =3D DIV_ROUND_UP_ULL(parent_nr_sectors, d->stripe_size);
> >> +    if (!n || n > max_stripes) {
> >> +        pr_err("nr_stripes too large or invalid: %llu (start sector b=
eyond end of disk?)\n",
> >> +            n);
> >> +        goto unblock_and_exit;
> >> +    }
> >> +    d->nr_stripes =3D n;
> >> +
> >> +    n =3D d->nr_stripes * sizeof(atomic_t);
> >> +    n_old =3D nr_stripes_old * sizeof(atomic_t);
> >> +    d->stripe_sectors_dirty =3D kvrealloc(d->stripe_sectors_dirty, n_=
old,
> >> +        n, GFP_KERNEL);
> >> +    if (!d->stripe_sectors_dirty)
> >> +        goto unblock_and_exit;
> >> +
> >> +    n =3D BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
> >> +    n_old =3D BITS_TO_LONGS(nr_stripes_old) * sizeof(unsigned long);
> >> +    d->full_dirty_stripes =3D kvrealloc(d->full_dirty_stripes, n_old,=
 n, GFP_KERNEL);
> >> +    if (!d->full_dirty_stripes)
> >> +        goto unblock_and_exit;
> >> +
> >> +    res =3D true;
> >> +
> >> +unblock_and_exit:
> >> +    up_write(&dc->writeback_lock);
> >> +    return res;
> >> +}
> >> +
> >>  struct async_reg_args {
> >>      struct delayed_work reg_work;
> >>      char *path;
> >> @@ -2569,7 +2639,10 @@ static ssize_t register_bcache(struct kobject *=
k, struct kobj_attribute *attr,
> >>              mutex_lock(&bch_register_lock);
> >>              if (lookup_bdev(strim(path), &dev) =3D=3D 0 &&
> >>                  bch_is_open(dev))
> >> -                err =3D "device already registered";
> >> +                if (bch_update_capacity(dev))
> >> +                    err =3D "capacity changed";
> >> +                else
> >> +                    err =3D "device already registered";
> >>              else
> >>                  err =3D "device busy";
> >>              mutex_unlock(&bch_register_lock);
> >> --
> >> 2.37.3
> >> On 6/9/22 15:22, Andrea Tomassetti wrote:
> >>> Hi Coly,
> >>> I have finally some time to work on the patch. I already have a first
> >>> prototype that seems to work but, before sending it, I would like to
> >>> ask you two questions:
> >>>    1. Inspecting the code, I found that the only lock mechanism is th=
e
> >>> writeback_lock semaphore. Am I correct?
> >>>    2. How can I effectively test my patch? So far I'm doing something=
 like this:
> >>>       a. make-bcache --writeback -B /dev/vdb -C /dev/vdc
> >>>       b. mkfs.xfs /dev/bcache0
> >>>       c. dd if=3D/dev/random of=3D/mnt/random bs=3D1M count=3D1000
> >>>       d. md5sum /mnt/random | tee /mnt/random.md5
> >>>       e. live resize the disk and repeat c. and d.
> >>>       f. umount/reboot/remount and check that the md5 hashes are corr=
ect
> >>>
> >>> Any suggestions?
> >>>
> >>> Thank you very much,
> >>> Andrea
> >>>
> >>> On Fri, Aug 5, 2022 at 9:38 PM Eric Wheeler <bcache@lists.ewheeler.ne=
t> wrote:
> >>>>
> >>>> On Wed, 3 Aug 2022, Andrea Tomassetti wrote:
> >>>>> Hi Coly,
> >>>>> In one of our previous emails you said that
> >>>>>> Currently bcache doesn=E2=80=99t support cache or backing device r=
esize
> >>>>>
> >>>>> I was investigating this point and I actually found a solution. I
> >>>>> briefly tested it and it seems to work fine.
> >>>>> Basically what I'm doing is:
> >>>>>    1. Check if there's any discrepancy between the nr of sectors
> >>>>> reported by the bcache backing device (holder) and the nr of sector=
s
> >>>>> reported by its parent (slave).
> >>>>>    2. If the number of sectors of the two devices are not the same,
> >>>>> then call set_capacity_and_notify on the bcache device.
> >>>>>    3. From user space, depending on the fs used, grow the fs with s=
ome
> >>>>> utility (e.g. xfs_growfs)
> >>>>>
> >>>>> This works without any need of unmounting the mounted fs nor stoppi=
ng
> >>>>> the bcache backing device.
> >>>>
> >>>> Well done! +1, would love to see a patch for this!
> >>>>
> >>>>
> >>>>> So my question is: am I missing something? Can this live resize cau=
se
> >>>>> some problems (e.g. data loss)? Would it be useful if I send a patc=
h on
> >>>>> this?
> >>>>
> >>>> A while a go we looked into doing this.  Here is the summary of our
> >>>> findings, not sure if there are any other considerations:
> >>>>
> >>>>    1. Create a sysfs file like /sys/block/bcache0/bcache/resize to t=
rigger
> >>>>       resize on echo 1 >.
> >>>>    2. Refactor the set_capacity() bits from  bcache_device_init() in=
to its
> >>>>       own function.
> >>>>    3. Put locks around bcache_device.full_dirty_stripes and
> >>>>       bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and ze=
ro the
> >>>>       new bytes at the end.  Grep where bcache_device.full_dirty_str=
ipes is
> >>>>       used and make sure it is locked appropriately, probably in the
> >>>>       writeback thread, maybe other places too.
> >>>>
> >>>> The cachedev's don't know anything about the bdev size, so (accordin=
g to
> >>>> Kent) they will "just work" by referencing new offsets that were
> >>>> previously beyond the disk. (This is basically the same as resizing =
the
> >>>> bdev and then unregister/re-register which is how we resize bdevs no=
w.)
> >>>>
> >>>> As for resizing a cachedev, I've not looked at all---not sure about =
that
> >>>> one.  We always detach, resize, make-bcache and re-attach the new ca=
che.
> >>>> Maybe it is similarly simple, but haven't looked.
> >>>>
> >>>>
> >>>> --
> >>>> Eric Wheeler
> >>>>
> >>>>
> >>>>
> >>>>>
> >>>>> Kind regards,
> >>>>> Andrea
> >>>>>
>
