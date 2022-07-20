Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2557B788
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Jul 2022 15:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiGTNb1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Jul 2022 09:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGTNb0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Jul 2022 09:31:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD32722E
        for <linux-bcache@vger.kernel.org>; Wed, 20 Jul 2022 06:31:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D454520B43;
        Wed, 20 Jul 2022 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658323882; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLTvwCJQtU8LGTVkwUYDCW1n3xbry/8SXXWOgnXoPXM=;
        b=aCmy8PdKATu65XEzAeHAE6FndvoQynOvZhabthaJhfY2Zr2gDRgRVZPSMQ9qSKmiVH1UsK
        5sQ3ROBlqQsDAtans5R8n9H9tzBeDeNm33RkrAT5JH7S9lpnbu2knrrrRaRpk1gZGUW/YS
        pkK/DABSNqSZI5gSuqFwV+KiwbcmEkU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658323882;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oLTvwCJQtU8LGTVkwUYDCW1n3xbry/8SXXWOgnXoPXM=;
        b=qSxhJKmPPFE6rehZkZDjVzwOPjVzeAkgR9//ejfe6KgLqi0O2LbWfswjDSNVPeUat6igwL
        FF8kdFyLb+GejDDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 310EC13AA1;
        Wed, 20 Jul 2022 13:31:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6b39NqgD2GLJAwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 20 Jul 2022 13:31:20 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA6NnAtL-OghpAqchbo1K7n8xnHYjRC5c1834-tpHH=rPQ@mail.gmail.com>
Date:   Wed, 20 Jul 2022 21:31:17 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D6039F11-06A8-4EB4-8793-78B0FCB1EFC2@suse.de>
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com>
 <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de>
 <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com>
 <365F8F51-8D66-4DCB-BF05-50727F83B80A@suse.de>
 <fd11b5db-dc7d-76b3-9396-ed58833c3f6a@ewheeler.net>
 <CAHykVA5wk6Mw+Td4kTTPVnOy0vD=bdt6JRuwTr-FeeAZPyY+kw@mail.gmail.com>
 <207619af-bdd1-a457-1169-f014816dfa1@ewheeler.net>
 <CAHykVA6NnAtL-OghpAqchbo1K7n8xnHYjRC5c1834-tpHH=rPQ@mail.gmail.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8820=E6=97=A5 16:06=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Jul 12, 2022 at 10:29 PM Eric Wheeler =
<bcache@lists.ewheeler.net> wrote:
>>=20
>> On Thu, 7 Jul 2022, Andrea Tomassetti wrote:
>>> On Wed, Jul 6, 2022 at 12:03 AM Eric Wheeler =
<bcache@lists.ewheeler.net> wrote:
>>>> On Tue, 5 Jul 2022, Coly Li wrote:
>>>>>> 2022=E5=B9=B47=E6=9C=885=E6=97=A5 16:48=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>> On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
>>>>>>>> 2022=E5=B9=B47=E6=9C=884=E6=97=A5 23:13=EF=BC=8CAndrea =
Tomassetti <andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>>>>>>> Introducing a bcache control device (/dev/bcache_ctrl) that =
allows
>>>>>>>> communicating to the driver from user space via IOCTL. The only
>>>>>>>> IOCTL commands currently implemented, receives a struct =
cache_sb and
>>>>>>>> uses it to register the backing device without any need of
>>>>>>>> formatting them.
>>>>>>>>=20
>>>>>>> Back to the patch, I don=E2=80=99t support this idea. For the =
problem you are
>>>>>>> solving, indeed people uses device mapper linear target for many
>>>>>>> years, and it works perfectly without any code modification.
>>>>>>>=20
>>>>>>> That is, create a 8K image and set it as a loop device, then =
write a
>>>>>>> dm table to combine it with the existing hard drive. Then you =
run
>>>>>>> =E2=80=9Cbcache make -B <combined dm target>=E2=80=9D, you will =
get a bcache device
>>>>>>> whose first 8K in the loop device and existing super block of =
the
>>>>>>> hard driver located at expected offset.
>>>>>>>=20
>>>>>> We evaluated this option but we weren't satisfied by the outcomes =
for,
>>>>>> at least, two main reasons: complexity and operational drawbacks. =
For
>>>>>> the complexity side: in production we use more than 20 HD that =
need to
>>>>>> be cached. It means we need to create 20+ header for them, 20+ =
loop
>>>>>> devices and 20+ dm linear devices. So, basically, there's a 3x =
factor
>>>>>> for each HD that we want to cache. Moreover, we're currently =
using
>>>>>> ephemeral disks as cache devices. In case of a machine reboot,
>>>>>> ephemeral devices can get lost; at this point, there will be some
>>>>>> trouble to mount the dm-linear bcache backing device because =
there
>>>>>> will be no cache device.
>>>>>=20
>>>>> OK, I get your point. It might make sense for your situation, =
although I
>>>>> know some other people use the linear dm-table to solve similar
>>>>> situation but may be not perfect for you. This patch may work in =
your
>>>>> procedure, but there are following things make me uncomfortable,
>>>>=20
>>>> Coly is right: there are some issues to address.
>>>>=20
>>>> Coly, I do not wish to contradict you, only to add that we have had =
times
>>>> where this would be useful. I like the idea, particularly avoiding =
placing
>>>> dm-linear atop of the bdev which reduces the IO codepath. Maybe =
there is
>>>> an implementation that would fit everyone's needs.
>>>>=20
>>>> For us, such a superblock-less registration could resolve two =
issues:
>>>>=20
>>>> 1. Most commonly we wish to add bcache to an existing device =
without
>>>> re-formatting and without adding the dm-linear complexity.
>>>=20
>>> That's exactly what was preventing us from using bcache in =
production
>>> prior to this patch.
>>=20
>> Ok, but we always use writeback...and others may wish to, too. I =
think
>> any patch that introduces a feature needs to support existing =
features
>> without introducing limitations on the behavior.
>>=20
> Totally agree. My only point was that I extensively tested this patch
> with wt mode. It works in wb mode as well, for sure because the
> backing device's header is almost never used. The only issue I can
> foresee in wb mode is in case of a machine reboot: the backing device
> will lose the virtual header and, at boot time, another one will be
> generated. It will get attached again to its cache device with a new
> UID and I'm not sure if this will imply the loss of the data that was
> not previously written to it, but was only present on the cache
> device. But I think that losing data it's a well-known risk of wb
> mode.

NO, losing dirty data on cache device is unacceptable. If the previous =
attached cache device is not ready, the backing device will be suspended =
and its bcache device won=E2=80=99t show up in /dev/.


>=20
>>>> 2. Relatedly, IMHO, I've never liked the default location at 8k =
because we
>>>> like to align our bdev's to the RAID stride width and rarely is the
>>>> bdev array aligned at 8k (usually 64k or 256k for hardware RAID). =
If
>>>> we forget to pass the --data-offset at make-bcache time then we are
>>>> stuck with an 8k-misalignment for the life of the device.
>>>>=20
>>>> In #2 we usually reformat the volume to avoid dm-linear complexity =
(and in
>>>> both cases we have wanted writeback cache support). This process =
can take
>>>> a while to `dd` =E2=80=BE30TBs of bdev on spinning disks and we =
have to find
>>>> temporary disk space to move that data out and back in.
>>>>=20
>>>>> - Copying a user space memory and directly using it as a =
complicated in-kernel memory object.
>>>>=20
>>>> In the ioctl changes for bch_write_bdev_super() there does not =
appear to
>>>> be a way to handle attaching caches to the running bcache. For =
example:
>>>>=20
>>>> 1. Add a cacheless bcache0 volume via ioctl
>>>> 2. Attach a writeback cache, write some data.
>>>> 3. Unregister everything
>>>> 4. Re-register the _dirty_ bdev from #1
>>>>=20
>>>> In this scenario bcache will start "running" immediately because it
>>>> cannot update its cset.uuid (as reported by bcache-super-show) =
which I
>>>> believe is stored in cache_sb.set_uuid.
>>>>=20
>>>> I suppose in step #2 you could update your userspace state with the
>>>> cset.uuid so your userspace ioctl register tool would put the =
cset.uuid in
>>>> place, but this is fragile without good userspace integration.
>>>>=20
>>>> I could imagine something like /etc/bcachetab (like crypttab or
>>>> mdadm.conf) that maps cset UUID's to bdev UUIDs. Then your =
userspace
>>>> ioctl tool could be included in a udev script to auto-load volumes =
as they
>>>> become available.
>>> Yes, in conjunction with this patch, I developed a python udev =
script
>>> that manages device registration base on a YAML configuration file. =
I
>>> even patched bcache-tools to support the new IOCTL registration. You
>>> will find a link to the Github project at the end of this message.
>>=20
>> Fewer dependencies are better: There are still python2 vs python3
>> conflicts out there---and loading python and its dependencies into an
>> initrd/initramfs for early bcache loading could be very messy, =
indeed!
>>=20
>> You've already put some work into make-bcache so creating a =
bcache_udev
>> function and a bcache-udev.c file (like make-bcache.c) is probably =
easy
>> enough. IMHO, a single-line grepable format (instead of YAML) could =
be
>> used to minimize dependencies so that it is clean in an initramfs in =
the
>> same way that mdadm.conf and crypttab already do. You could then =
parse it
>> with C or bash pretty easily...
>>=20
> I will be really glad to rework the patch if we can agree on some
> modifications that will make it suitable to be merged upstream.


I don=E2=80=99t support the idea to copy a block of memory from user =
space to kernel space and reference it as a super block, neither IOCTL =
nor sysfs interface.
It is very easy to generate a corrupted super block memory and send it =
into kernel space and panic the whole system, I will not take this =
potential risk.

>=20
>>>> You want to make sure that when a dirty writeback-cached bdev is
>>>> registered that it does not activate until either:
>>>>=20
>>>> 1. The cache is attached
>>>> 2. echo 1 > /sys/block/bcache0/bcache/running
>>>>=20
>>>>> - A new IOCTL interface added, even all rested interface are sysfs =
based.
>>>>=20
>>>> True. Perhaps something like this would be better, and it would =
avoid
>>>> sharing a userspace page for blindly populating `struct cache_sb`, =
too:
>>>>=20
>>>> echo '/dev/bdev [bdev_uuid] [/dev/cachedev|cset_uuid] [options]' > =
=C2=A5
>>>> /sys/fs/bcache/register_raw
>>>=20
>>> I thought that introducing an IOCTL interface could be a stopper for
>>> this patch, so I'm more than welcome to refactor it using sysfs
>>> entries only. But, I will do so only if there's even the slightest
>>> chance that this patch can be merged.
>>=20
>> I'm for the patch with sysfs, but I'm not the decision maker either.
>>=20
>=20
> As Eric already asked,
>> Coly: what would your requirements be to accept this upstream?
>>>>>=20

You may use it as you want, but I won=E2=80=99t accept it into upstream =
via my path.

Coly Li


