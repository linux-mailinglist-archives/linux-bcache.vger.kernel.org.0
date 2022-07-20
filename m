Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4757957B854
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Jul 2022 16:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiGTOXy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Jul 2022 10:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGTOXy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Jul 2022 10:23:54 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C082718
        for <linux-bcache@vger.kernel.org>; Wed, 20 Jul 2022 07:23:52 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id bz13so7050525qtb.7
        for <linux-bcache@vger.kernel.org>; Wed, 20 Jul 2022 07:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o17HT0bG+77LtT5lcCCQCMpp0py0kCoy6j5rv47AOTc=;
        b=UjY+OKW3uSjatSiojxpcHmysQ7PIfg1LEuGVTuhbbR7omG5djvgFXcNd/vzPfr3vWZ
         CCbW9t7PXp3KZBXl4jJeKYglwkl/2g/kOfiTjjj5RQsNBLoYdabkL0fmACWzhzh2Pfjr
         wF3J40GQxYcq1H/X1LjAinn3AiEUjh8JM5dIR8DmETVWVkjyag/o+ynIs9Fj4lo4Djyy
         0j6FDPuf1rVVC4E+HSHd9a5YwnTq1dsHHdmcl7P++ZF7x80L7twP58RzVyNnW34c7E0e
         APQKd9N38WtnV44NW1eOFOgb/VwNbcPmKrq4ZsV9Pyb48E147GuuwnHe1y0cB7Eqkmrx
         BzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o17HT0bG+77LtT5lcCCQCMpp0py0kCoy6j5rv47AOTc=;
        b=lqXGyxO+iJIVAZuaYwf3q2xnpO9jOgrnZDgiOCuaYbwkxVl8cIeQPpf8ToIkyp71D0
         mgKvedl9iLdIa3nkzCS4XCrF7VZ3+0Qabr2e8JvVPR3YMQhx1m151lMxIRMoml2c46o/
         0ptZWzLGgCTWYiedVY+bzsEY2bcttNdaaSBXZJsO14WuSQzX6McBeVVbHEj1YwxR31Zw
         +frGR+ioaOObKfNMMeZk+zS1PeNe6/aWznZudXqKGJ71II99J2+OclCp4VrP/1SpjPK6
         65te+nbRCfuWZ5e6ntJW0rehTpF/hFvNRNcOWoVdre70zJXyU8SPPOT4T7chZ3H5tpA+
         n/dQ==
X-Gm-Message-State: AJIora/7/+gOnzDygK7VkPkoI276K/1m9+hqSCDFTdXqNTxQslxZxCdT
        OW0hjZguy4uA0I2ZMxV4rhkTe7e6utFgKXUSoHNC/Q==
X-Google-Smtp-Source: AGRyM1sN/Up8XfSCvDw2RMjjPIs693afAYRUxltMOHDqZWbcCOU9MQi2ypwxxpiY+TEu+b4KhLImoXAPlUyLk1Ctfds=
X-Received: by 2002:ac8:5c4d:0:b0:31e:f794:1b18 with SMTP id
 j13-20020ac85c4d000000b0031ef7941b18mr8661346qtj.282.1658327031274; Wed, 20
 Jul 2022 07:23:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
 <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de> <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
 <365F8F51-8D66-4DCB-BF05-50727F83B80A@suse.de> <fd11b5db-dc7d-76b3-9396-ed58833c3f6a@ewheeler.net>
 <CAHykVA5wk6Mw+Td4kTTPVnOy0vD=bdt6JRuwTr-FeeAZPyY+kw@mail.gmail.com>
 <207619af-bdd1-a457-1169-f014816dfa1@ewheeler.net> <CAHykVA6NnAtL-OghpAqchbo1K7n8xnHYjRC5c1834-tpHH=rPQ@mail.gmail.com>
 <D6039F11-06A8-4EB4-8793-78B0FCB1EFC2@suse.de>
In-Reply-To: <D6039F11-06A8-4EB4-8793-78B0FCB1EFC2@suse.de>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Wed, 20 Jul 2022 16:23:40 +0200
Message-ID: <CAHykVA54mCRim2UBAM7t_e-X3yOdifggyPLHBLMcTYoetJp-zw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
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

On Wed, Jul 20, 2022 at 3:31 PM Coly Li <colyli@suse.de> wrote:
>
>
>
> > 2022=E5=B9=B47=E6=9C=8820=E6=97=A5 16:06=EF=BC=8CAndrea Tomassetti <and=
rea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Tue, Jul 12, 2022 at 10:29 PM Eric Wheeler <bcache@lists.ewheeler.ne=
t> wrote:
> >>
> >> On Thu, 7 Jul 2022, Andrea Tomassetti wrote:
> >>> On Wed, Jul 6, 2022 at 12:03 AM Eric Wheeler <bcache@lists.ewheeler.n=
et> wrote:
> >>>> On Tue, 5 Jul 2022, Coly Li wrote:
> >>>>>> 2022=E5=B9=B47=E6=9C=885=E6=97=A5 16:48=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>> On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
> >>>>>>>> 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea Tomassett=
i <andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>>>>>>> Introducing a bcache control device (/dev/bcache_ctrl) that allo=
ws
> >>>>>>>> communicating to the driver from user space via IOCTL. The only
> >>>>>>>> IOCTL commands currently implemented, receives a struct cache_sb=
 and
> >>>>>>>> uses it to register the backing device without any need of
> >>>>>>>> formatting them.
> >>>>>>>>
> >>>>>>> Back to the patch, I don=E2=80=99t support this idea. For the pro=
blem you are
> >>>>>>> solving, indeed people uses device mapper linear target for many
> >>>>>>> years, and it works perfectly without any code modification.
> >>>>>>>
> >>>>>>> That is, create a 8K image and set it as a loop device, then writ=
e a
> >>>>>>> dm table to combine it with the existing hard drive. Then you run
> >>>>>>> =E2=80=9Cbcache make -B <combined dm target>=E2=80=9D, you will g=
et a bcache device
> >>>>>>> whose first 8K in the loop device and existing super block of the
> >>>>>>> hard driver located at expected offset.
> >>>>>>>
> >>>>>> We evaluated this option but we weren't satisfied by the outcomes =
for,
> >>>>>> at least, two main reasons: complexity and operational drawbacks. =
For
> >>>>>> the complexity side: in production we use more than 20 HD that nee=
d to
> >>>>>> be cached. It means we need to create 20+ header for them, 20+ loo=
p
> >>>>>> devices and 20+ dm linear devices. So, basically, there's a 3x fac=
tor
> >>>>>> for each HD that we want to cache. Moreover, we're currently using
> >>>>>> ephemeral disks as cache devices. In case of a machine reboot,
> >>>>>> ephemeral devices can get lost; at this point, there will be some
> >>>>>> trouble to mount the dm-linear bcache backing device because there
> >>>>>> will be no cache device.
> >>>>>
> >>>>> OK, I get your point. It might make sense for your situation, altho=
ugh I
> >>>>> know some other people use the linear dm-table to solve similar
> >>>>> situation but may be not perfect for you. This patch may work in yo=
ur
> >>>>> procedure, but there are following things make me uncomfortable,
> >>>>
> >>>> Coly is right: there are some issues to address.
> >>>>
> >>>> Coly, I do not wish to contradict you, only to add that we have had =
times
> >>>> where this would be useful. I like the idea, particularly avoiding p=
lacing
> >>>> dm-linear atop of the bdev which reduces the IO codepath. Maybe ther=
e is
> >>>> an implementation that would fit everyone's needs.
> >>>>
> >>>> For us, such a superblock-less registration could resolve two issues=
:
> >>>>
> >>>> 1. Most commonly we wish to add bcache to an existing device without
> >>>> re-formatting and without adding the dm-linear complexity.
> >>>
> >>> That's exactly what was preventing us from using bcache in production
> >>> prior to this patch.
> >>
> >> Ok, but we always use writeback...and others may wish to, too. I think
> >> any patch that introduces a feature needs to support existing features
> >> without introducing limitations on the behavior.
> >>
> > Totally agree. My only point was that I extensively tested this patch
> > with wt mode. It works in wb mode as well, for sure because the
> > backing device's header is almost never used. The only issue I can
> > foresee in wb mode is in case of a machine reboot: the backing device
> > will lose the virtual header and, at boot time, another one will be
> > generated. It will get attached again to its cache device with a new
> > UID and I'm not sure if this will imply the loss of the data that was
> > not previously written to it, but was only present on the cache
> > device. But I think that losing data it's a well-known risk of wb
> > mode.
>
> NO, losing dirty data on cache device is unacceptable. If the previous at=
tached cache device is not ready, the backing device will be suspended and =
its bcache device won=E2=80=99t show up in /dev/.
>
>
> >
> >>>> 2. Relatedly, IMHO, I've never liked the default location at 8k beca=
use we
> >>>> like to align our bdev's to the RAID stride width and rarely is the
> >>>> bdev array aligned at 8k (usually 64k or 256k for hardware RAID). If
> >>>> we forget to pass the --data-offset at make-bcache time then we are
> >>>> stuck with an 8k-misalignment for the life of the device.
> >>>>
> >>>> In #2 we usually reformat the volume to avoid dm-linear complexity (=
and in
> >>>> both cases we have wanted writeback cache support). This process can=
 take
> >>>> a while to `dd` =E2=80=BE30TBs of bdev on spinning disks and we have=
 to find
> >>>> temporary disk space to move that data out and back in.
> >>>>
> >>>>> - Copying a user space memory and directly using it as a complicate=
d in-kernel memory object.
> >>>>
> >>>> In the ioctl changes for bch_write_bdev_super() there does not appea=
r to
> >>>> be a way to handle attaching caches to the running bcache. For examp=
le:
> >>>>
> >>>> 1. Add a cacheless bcache0 volume via ioctl
> >>>> 2. Attach a writeback cache, write some data.
> >>>> 3. Unregister everything
> >>>> 4. Re-register the _dirty_ bdev from #1
> >>>>
> >>>> In this scenario bcache will start "running" immediately because it
> >>>> cannot update its cset.uuid (as reported by bcache-super-show) which=
 I
> >>>> believe is stored in cache_sb.set_uuid.
> >>>>
> >>>> I suppose in step #2 you could update your userspace state with the
> >>>> cset.uuid so your userspace ioctl register tool would put the cset.u=
uid in
> >>>> place, but this is fragile without good userspace integration.
> >>>>
> >>>> I could imagine something like /etc/bcachetab (like crypttab or
> >>>> mdadm.conf) that maps cset UUID's to bdev UUIDs. Then your userspace
> >>>> ioctl tool could be included in a udev script to auto-load volumes a=
s they
> >>>> become available.
> >>> Yes, in conjunction with this patch, I developed a python udev script
> >>> that manages device registration base on a YAML configuration file. I
> >>> even patched bcache-tools to support the new IOCTL registration. You
> >>> will find a link to the Github project at the end of this message.
> >>
> >> Fewer dependencies are better: There are still python2 vs python3
> >> conflicts out there---and loading python and its dependencies into an
> >> initrd/initramfs for early bcache loading could be very messy, indeed!
> >>
> >> You've already put some work into make-bcache so creating a bcache_ude=
v
> >> function and a bcache-udev.c file (like make-bcache.c) is probably eas=
y
> >> enough. IMHO, a single-line grepable format (instead of YAML) could be
> >> used to minimize dependencies so that it is clean in an initramfs in t=
he
> >> same way that mdadm.conf and crypttab already do. You could then parse=
 it
> >> with C or bash pretty easily...
> >>
> > I will be really glad to rework the patch if we can agree on some
> > modifications that will make it suitable to be merged upstream.
>
Hi Coly,
thank you very much for your time.

>
> I don=E2=80=99t support the idea to copy a block of memory from user spac=
e to kernel space and reference it as a super block, neither IOCTL nor sysf=
s interface.
> It is very easy to generate a corrupted super block memory and send it in=
to kernel space and panic the whole system, I will not take this potential =
risk.
>
I think I'm missing something here because I cannot see the difference
between passing the structure through the sysfs interface or reading
it from the header of the block device. In both cases the source of
such structure will be the same: the user via the make-bcache command.
My understanding of the part involved is:
    udev_rule -> bcache-register.c -> sysfs/register ->
bcache_module/register_bcache -> read_super
So, in read_super the bcache module will read what the userspace
utility make-bcache wrote as a super block. Correct?
If I'm correct, a big if, I cannot see why it should be "easier" to
generate a corrupted super block with this patch. Can you please
elaborate on this?

Thank you in advance,
Andrea

> >
> >>>> You want to make sure that when a dirty writeback-cached bdev is
> >>>> registered that it does not activate until either:
> >>>>
> >>>> 1. The cache is attached
> >>>> 2. echo 1 > /sys/block/bcache0/bcache/running
> >>>>
> >>>>> - A new IOCTL interface added, even all rested interface are sysfs =
based.
> >>>>
> >>>> True. Perhaps something like this would be better, and it would avoi=
d
> >>>> sharing a userspace page for blindly populating `struct cache_sb`, t=
oo:
> >>>>
> >>>> echo '/dev/bdev [bdev_uuid] [/dev/cachedev|cset_uuid] [options]' > =
=C2=A5
> >>>> /sys/fs/bcache/register_raw
> >>>
> >>> I thought that introducing an IOCTL interface could be a stopper for
> >>> this patch, so I'm more than welcome to refactor it using sysfs
> >>> entries only. But, I will do so only if there's even the slightest
> >>> chance that this patch can be merged.
> >>
> >> I'm for the patch with sysfs, but I'm not the decision maker either.
> >>
> >
> > As Eric already asked,
> >> Coly: what would your requirements be to accept this upstream?
> >>>>>
>
> You may use it as you want, but I won=E2=80=99t accept it into upstream v=
ia my path.
>
> Coly Li
>
>
