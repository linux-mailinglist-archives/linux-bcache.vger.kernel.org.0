Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8148E569EF4
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Jul 2022 11:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiGGJ5M (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Jul 2022 05:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234912AbiGGJ5J (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Jul 2022 05:57:09 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBD04D4F9
        for <linux-bcache@vger.kernel.org>; Thu,  7 Jul 2022 02:57:08 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id ay10so21919348qtb.1
        for <linux-bcache@vger.kernel.org>; Thu, 07 Jul 2022 02:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devo.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r8tA9YxvTMtdgqm82y7aG+Q18pNxaaPNWOm9nx/pG48=;
        b=eIeQXNNLwBP6LC56bVDzbRFvVfMyWq2rJcTWpl+EOrhF5d+Fv4tQnB09M5tb+MqVve
         N7i6X9ahy8Tt8++U8wRbPufaboUyrv1tU8KD79Thf/gEIPjL/utwuJi6t0Wk+gYXLZ1x
         Rjxq13DCg2qRg64w2qqq/WCN3MDiAm1TbNvHynPv1T2g9hwl2dUnKAqEiSC8gyEUV60N
         1Ywn1juIbVhU9+oZc87Af7ESG5pg/1nvSe011UMwrA7OLdST2ozDxaGAVsLodPXwUneD
         3kmNvSWvvLRJdy330y3/dCqL9n7nxBPiI5EDOG78O+ud9GrYOiJGu6lwLkFuzCC5uSA+
         pgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r8tA9YxvTMtdgqm82y7aG+Q18pNxaaPNWOm9nx/pG48=;
        b=CRabtnLz8YCE6qOBCKCKpxjnMyhX1gZ8iMczWGD99gnYROcA9mDvYeHP3RXw2c0vGt
         P17Z8oVlsv5VkgH1n3qFk+RQa8Vo4BKfUE9E4baaZbOzcrjEQbjf1r7kyA74z6S0QexH
         j89r675EzRrKWR9TMvrdUOANcaztcKqNUT+NJ71f6yG7pT4pWyzpib2KHiPF4VPEDmAg
         PCFWxnfIh6bCnVgowdfqtH5Fsul4pmJef00qhKqPgH6MToI241aCp91re4uy8pN/CQPO
         2Rx3LI2pC499MrT6W6z1FZlqkr/qe6KeQBGxVVK1YUCy+kDAzOKPPGjnhzTuQBSEfK1+
         3BYA==
X-Gm-Message-State: AJIora8Ma37ckAzdb1nUW9uILQ/MBi9mmU7zXw1XHuL6ls6NBdl0Hnt6
        9ed6j4PmQAbDUumM9jL0szIFKhmdh98dBfADbI7ExV/RPVZUnQ==
X-Google-Smtp-Source: AGRyM1spVIaPVG20Zv+eOQT7g24dIIYu5ydzy5AlAvqVsbSTb7h50476G7yW5U+zcuTS6ywugm08yoeo/tFJ7KAXWW0=
X-Received: by 2002:ac8:5901:0:b0:317:c667:313b with SMTP id
 1-20020ac85901000000b00317c667313bmr35822151qty.229.1657187827474; Thu, 07
 Jul 2022 02:57:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
 <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de> <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
 <365F8F51-8D66-4DCB-BF05-50727F83B80A@suse.de> <fd11b5db-dc7d-76b3-9396-ed58833c3f6a@ewheeler.net>
In-Reply-To: <fd11b5db-dc7d-76b3-9396-ed58833c3f6a@ewheeler.net>
From:   Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
Date:   Thu, 7 Jul 2022 11:56:56 +0200
Message-ID: <CAHykVA5wk6Mw+Td4kTTPVnOy0vD=bdt6JRuwTr-FeeAZPyY+kw@mail.gmail.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Eric and Coly,
thank you very much for the interesting discussion.

Let me give you a little bit more context that maybe will help you
better understand the specific use case that this patch is trying to
tackle.
As I stated in a previous email, we're currently using ephemeral disks
as cache devices so, for us, using bcache in writeback mode is out of
discussion because it could lead us to data loss.
Moreover, I fully understand the dangerous implications of registering
a backing device without formatting it and using it in wb mode. That's
why this patch is meant to register backing devices *only* (no need to
register a cache device without formatting it) and in wt mode *only*.
I'm not saying it cannot be used to register backing devices in wb
mode, I'm just saying that it needs further and deeper analysis on the
implications.
Sorry if this context wasn't clear enough.

On Wed, Jul 6, 2022 at 12:03 AM Eric Wheeler <bcache@lists.ewheeler.net> wr=
ote:
>
> On Tue, 5 Jul 2022, Coly Li wrote:
> > > 2022=E5=B9=B47=E6=9C=885=E6=97=A5 16:48=EF=BC=8CAndrea Tomassetti <an=
drea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> > > On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
> > >>> 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea Tomassetti <=
andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
> > >>> Introducing a bcache control device (/dev/bcache_ctrl) that allows
> > >>> communicating to the driver from user space via IOCTL. The only
> > >>> IOCTL commands currently implemented, receives a struct cache_sb an=
d
> > >>> uses it to register the backing device without any need of
> > >>> formatting them.
> > >>>
> > >> Back to the patch, I don=E2=80=99t support this idea. For the proble=
m you are
> > >> solving, indeed people uses device mapper linear target for many
> > >> years, and it works perfectly without any code modification.
> > >>
> > >> That is, create a 8K image and set it as a loop device, then write a
> > >> dm table to combine it with the existing hard drive. Then you run
> > >> =E2=80=9Cbcache make -B <combined dm target>=E2=80=9D, you will get =
a bcache device
> > >> whose first 8K in the loop device and existing super block of the
> > >> hard driver located at expected offset.
> > >>
> > > We evaluated this option but we weren't satisfied by the outcomes for=
,
> > > at least, two main reasons: complexity and operational drawbacks. For
> > > the complexity side: in production we use more than 20 HD that need t=
o
> > > be cached. It means we need to create 20+ header for them, 20+ loop
> > > devices and 20+ dm linear devices. So, basically, there's a 3x factor
> > > for each HD that we want to cache. Moreover, we're currently using
> > > ephemeral disks as cache devices. In case of a machine reboot,
> > > ephemeral devices can get lost; at this point, there will be some
> > > trouble to mount the dm-linear bcache backing device because there
> > > will be no cache device.
> >
> > OK, I get your point. It might make sense for your situation, although =
I
> > know some other people use the linear dm-table to solve similar
> > situation but may be not perfect for you. This patch may work in your
> > procedure, but there are following things make me uncomfortable,
>
> Coly is right: there are some issues to address.
>
> Coly, I do not wish to contradict you, only to add that we have had times
> where this would be useful. I like the idea, particularly avoiding placin=
g
> dm-linear atop of the bdev which reduces the IO codepath.  Maybe there is
> an implementation that would fit everyone's needs.
>
> For us, such a superblock-less registration could resolve two issues:
>
> 1. Most commonly we wish to add bcache to an existing device without
>    re-formatting and without adding the dm-linear complexity.
>
That's exactly what was preventing us from using bcache in production
prior to this patch.

> 2. Relatedly, IMHO, I've never liked the default location at 8k because w=
e
>    like to align our bdev's to the RAID stride width and rarely is the
>    bdev array aligned at 8k (usually 64k or 256k for hardware RAID).  If
>    we forget to pass the --data-offset at make-bcache time then we are
>    stuck with an 8k-misalignment for the life of the device.
>
> In #2 we usually reformat the volume to avoid dm-linear complexity (and i=
n
> both cases we have wanted writeback cache support).  This process can tak=
e
> a while to `dd` =E2=80=BE30TBs of bdev on spinning disks and we have to f=
ind
> temporary disk space to move that data out and back in.
>
> > - Copying a user space memory and directly using it as a complicated in=
-kernel memory object.
>
> In the ioctl changes for bch_write_bdev_super() there does not appear to
> be a way to handle attaching caches to the running bcache.  For example:
>
> 1. Add a cacheless bcache0 volume via ioctl
> 2. Attach a writeback cache, write some data.
> 3. Unregister everything
> 4. Re-register the _dirty_ bdev from #1
>
> In this scenario bcache will start "running" immediately because it
> cannot update its cset.uuid (as reported by bcache-super-show) which I
> believe is stored in cache_sb.set_uuid.
>
> I suppose in step #2 you could update your userspace state with the
> cset.uuid so your userspace ioctl register tool would put the cset.uuid i=
n
> place, but this is fragile without good userspace integration.
>
> I could imagine something like /etc/bcachetab (like crypttab or
> mdadm.conf) that maps cset UUID's to bdev UUIDs.  Then your userspace
> ioctl tool could be included in a udev script to auto-load volumes as the=
y
> become available.
Yes, in conjunction with this patch, I developed a python udev script
that manages device registration base on a YAML configuration file. I
even patched bcache-tools to support the new IOCTL registration. You
will find a link to the Github project at the end of this message.

>
> You want to make sure that when a dirty writeback-cached bdev is
> registered that it does not activate until either:
>
>   1. The cache is attached
>   2. echo 1 > /sys/block/bcache0/bcache/running
>
> > - A new IOCTL interface added, even all rested interface are sysfs base=
d.
>
> True.  Perhaps something like this would be better, and it would avoid
> sharing a userspace page for blindly populating `struct cache_sb`, too:
>
>   echo '/dev/bdev [bdev_uuid] [/dev/cachedev|cset_uuid] [options]' > =C2=
=A5
>           /sys/fs/bcache/register_raw
>
I thought that introducing an IOCTL interface could be a stopper for
this patch, so I'm more than welcome to refactor it using sysfs
entries only. But, I will do so only if there's even the slightest
chance that this patch can be merged.
> Because of the writeback issue above, the cache and bdev either need to b=
e
> registered simultaneously or the cset uuid need to be specified.
>
> > - Do things in kernel space while there is solution in user space.
> >
> > All the above opinions are quite personal to myself, I don=E2=80=99t sa=
y you are
> > wrong or I am correct. If the patch works, that=E2=80=99s cool and you =
can use
> > it as you want, but I don=E2=80=99t support it to be in upstream.
>
> An alternate implementation might be to create a dm-bcache target.  The
> core bcache code could be left alone except a few EXPORT_SYMBOL()'s so
> dm-bcache can reach the bcache registration bits.
>
> This would:
>   * Minimally impact the bcache code base
>   * Solve the blind-populating of `struct cache_sb` issue in the same way
>     as `register_raw` could work above.
>   * Create a nicely segmented codebase (dm target) to upstream separately
>     through the DM team.
>   * Could be maintained cleanly out-of-tree because the bcache
>     registration interfaces change very infrequently.
>   * bdev resize could be done with a `dmsetup replace` but you'll need to
>     add resize support as below.
>
> > > For the operational drawbacks: from time to time, we exploit the
> > > online filesystem resize capability of XFS to increase the volume
> > > size. This would be at least tedious, if not nearly impossible, if th=
e
> > > volume is mapped inside a dm-linear.
> >
> > Currently bcache doesn=E2=80=99t support cache or backing device resize=
. I don=E2=80=99t
> > see the connection between above statement and feeding an in-memory
> > super block via IOCTL command.
>
> Resize is perhaps unrelated, so if you decide to tackle bdev or cachedev
> resize then please start a new list thread.  Briefly: supporting bdev
> resize is probably easy.  I've looked through the code a few times with
> this in mind but haven't had time.
>
> Here's the summary, not sure if there are any other
> considerations:
>
>   1. Create a sysfs file like /sys/block/bcache0/bcache/resize to trigger
>      resize on echo 1 >.
>   2. Refactor the set_capacity() bits from  bcache_device_init() into its
>      own function.
>   3. Put locks around bcache_device.full_dirty_stripes and
>      bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and zero the
>      new bytes at the end.
>
> The cachedev's don't know anything about the bdev size, so (according to
> Kent) they will "just work" by referencing new offsets that didn't exist
> before when IOs come through.  (This is basically the same as resizing th=
e
> bdev and then unregister/re-register which is how we resize bdevs now.)
>
> As for resizing a cachedev, I've not looked at all---not sure about that
> one.  We always detach, resize, make-bcache and re-attach the new cache.
> Maybe it is similarly simple, but haven't looked.
>
> > >> It is unnecessary to create a new IOCTL interface, and I feel the wa=
y
> > >> how it works is really unconvinced for potential security risk.
> > >>
> > > Which potential security risks concern you?
> > >
> >
> > Currently we don=E2=80=99t check all members of struct cache_sb_disk, w=
hat we do
> > is to simply trust bcache-tools. Create a new IOCTL interface to send a
> > user space memory into kernel space as superblock, that needs quite a
> > lot of checking code to make sure it won=E2=80=99t panic the kernel. It=
 is
> > possible, but it is not worthy to add so many code for the purpose,
> > especially adding them into upstream code.
> >
> > I am not able to provide an explicit example for security risk, just th=
e
> > new adding interface makes me not so confident.
>
> Maintaining a blind structure population from a userspace page would be
> difficult as well because even if the kernel validates _everything_ in
> cache_sb today, anyone extending `struct cache_sb` needs to remember to
> add checks for that. Failing to enforce validation inside the kernel coul=
d
> lead to kernel crashes or data corruption from userspace which is of
> course never good.
>
Can I solve this by refactoring the patch and using sysfs based
registration instead?

For anyone that is interested to try this solution, and as a
reference, I leave here below the links to my public Github
repositories:
- bcache-tools: https://github.com/andreatomassetti/bcache-tools
- bcache (standalone, patched): https://github.com/andreatomassetti/bcache

Thank you very much,
Andrea

> We always assume that, somehow, someone could leverage an insecure IOCTL
> call and crash the OS when they shouldn't be allowed to (even if they are
> not root, like from sudo).  This is a security issue from an assurance an=
d
> integrity point of view, even if there might be neither an obvious
> privelege escalation nor privacy concern.
>
> -Eric
>
>
> > Thanks.
> >
> > Coly Li
> >
> >
> >
> >
