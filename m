Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7703857273D
	for <lists+linux-bcache@lfdr.de>; Tue, 12 Jul 2022 22:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiGLU3I (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 12 Jul 2022 16:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiGLU3I (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 12 Jul 2022 16:29:08 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BECBFAE3
        for <linux-bcache@vger.kernel.org>; Tue, 12 Jul 2022 13:29:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id D9B7548;
        Tue, 12 Jul 2022 13:29:05 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id V5MUb3hwJ_96; Tue, 12 Jul 2022 13:29:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 57DC439;
        Tue, 12 Jul 2022 13:29:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 57DC439
Date:   Tue, 12 Jul 2022 13:29:01 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Zhang Zhen <zhangzhen.email@gmail.com>
Subject: Re: [PATCH] bcache: Use bcache without formatting existing device
In-Reply-To: <CAHykVA5wk6Mw+Td4kTTPVnOy0vD=bdt6JRuwTr-FeeAZPyY+kw@mail.gmail.com>
Message-ID: <207619af-bdd1-a457-1169-f014816dfa1@ewheeler.net>
References: <20220704151320.78094-1-andrea.tomassetti-opensource@devo.com> <B18A4668-47F5-4219-8336-EDB00D0292C2@suse.de> <CAHykVA48C-8JBsyZG8_iGzBJ9rjDMrW7O0mk9L4PDpRAP0yUXQ@mail.gmail.com> <365F8F51-8D66-4DCB-BF05-50727F83B80A@suse.de>
 <fd11b5db-dc7d-76b3-9396-ed58833c3f6a@ewheeler.net> <CAHykVA5wk6Mw+Td4kTTPVnOy0vD=bdt6JRuwTr-FeeAZPyY+kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323328-1530191041-1657657741=:20520"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1530191041-1657657741=:20520
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 7 Jul 2022, Andrea Tomassetti wrote:
> On Wed, Jul 6, 2022 at 12:03 AM Eric Wheeler <bcache@lists.ewheeler.net> wrote:
> > On Tue, 5 Jul 2022, Coly Li wrote:
> > > > 2022年7月5日 16:48，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > > > On Mon, Jul 4, 2022 at 5:29 PM Coly Li <colyli@suse.de> wrote:
> > > >>> 2022年7月4日 23:13，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > > >>> Introducing a bcache control device (/dev/bcache_ctrl) that allows
> > > >>> communicating to the driver from user space via IOCTL. The only
> > > >>> IOCTL commands currently implemented, receives a struct cache_sb and
> > > >>> uses it to register the backing device without any need of
> > > >>> formatting them.
> > > >>>
> > > >> Back to the patch, I don’t support this idea. For the problem you are
> > > >> solving, indeed people uses device mapper linear target for many
> > > >> years, and it works perfectly without any code modification.
> > > >>
> > > >> That is, create a 8K image and set it as a loop device, then write a
> > > >> dm table to combine it with the existing hard drive. Then you run
> > > >> “bcache make -B <combined dm target>”, you will get a bcache device
> > > >> whose first 8K in the loop device and existing super block of the
> > > >> hard driver located at expected offset.
> > > >>
> > > > We evaluated this option but we weren't satisfied by the outcomes for,
> > > > at least, two main reasons: complexity and operational drawbacks. For
> > > > the complexity side: in production we use more than 20 HD that need to
> > > > be cached. It means we need to create 20+ header for them, 20+ loop
> > > > devices and 20+ dm linear devices. So, basically, there's a 3x factor
> > > > for each HD that we want to cache. Moreover, we're currently using
> > > > ephemeral disks as cache devices. In case of a machine reboot,
> > > > ephemeral devices can get lost; at this point, there will be some
> > > > trouble to mount the dm-linear bcache backing device because there
> > > > will be no cache device.
> > >
> > > OK, I get your point. It might make sense for your situation, although I
> > > know some other people use the linear dm-table to solve similar
> > > situation but may be not perfect for you. This patch may work in your
> > > procedure, but there are following things make me uncomfortable,
> >
> > Coly is right: there are some issues to address.
> >
> > Coly, I do not wish to contradict you, only to add that we have had times
> > where this would be useful. I like the idea, particularly avoiding placing
> > dm-linear atop of the bdev which reduces the IO codepath.  Maybe there is
> > an implementation that would fit everyone's needs.
> >
> > For us, such a superblock-less registration could resolve two issues:
> >
> > 1. Most commonly we wish to add bcache to an existing device without
> >    re-formatting and without adding the dm-linear complexity.
>
> That's exactly what was preventing us from using bcache in production
> prior to this patch.

Ok, but we always use writeback...and others may wish to, too.  I think 
any patch that introduces a feature needs to support existing features 
without introducing limitations on the behavior.
 
> > 2. Relatedly, IMHO, I've never liked the default location at 8k because we
> >    like to align our bdev's to the RAID stride width and rarely is the
> >    bdev array aligned at 8k (usually 64k or 256k for hardware RAID).  If
> >    we forget to pass the --data-offset at make-bcache time then we are
> >    stuck with an 8k-misalignment for the life of the device.
> >
> > In #2 we usually reformat the volume to avoid dm-linear complexity (and in
> > both cases we have wanted writeback cache support).  This process can take
> > a while to `dd` ‾30TBs of bdev on spinning disks and we have to find
> > temporary disk space to move that data out and back in.
> >
> > > - Copying a user space memory and directly using it as a complicated in-kernel memory object.
> >
> > In the ioctl changes for bch_write_bdev_super() there does not appear to
> > be a way to handle attaching caches to the running bcache.  For example:
> >
> > 1. Add a cacheless bcache0 volume via ioctl
> > 2. Attach a writeback cache, write some data.
> > 3. Unregister everything
> > 4. Re-register the _dirty_ bdev from #1
> >
> > In this scenario bcache will start "running" immediately because it
> > cannot update its cset.uuid (as reported by bcache-super-show) which I
> > believe is stored in cache_sb.set_uuid.
> >
> > I suppose in step #2 you could update your userspace state with the
> > cset.uuid so your userspace ioctl register tool would put the cset.uuid in
> > place, but this is fragile without good userspace integration.
> >
> > I could imagine something like /etc/bcachetab (like crypttab or
> > mdadm.conf) that maps cset UUID's to bdev UUIDs.  Then your userspace
> > ioctl tool could be included in a udev script to auto-load volumes as they
> > become available.
> Yes, in conjunction with this patch, I developed a python udev script
> that manages device registration base on a YAML configuration file. I
> even patched bcache-tools to support the new IOCTL registration. You
> will find a link to the Github project at the end of this message.

Fewer dependencies are better: There are still python2 vs python3 
conflicts out there---and loading python and its dependencies into an 
initrd/initramfs for early bcache loading could be very messy, indeed!

You've already put some work into make-bcache so creating a bcache_udev 
function and a bcache-udev.c file (like make-bcache.c) is probably easy 
enough.  IMHO, a single-line grepable format (instead of YAML) could be 
used to minimize dependencies so that it is clean in an initramfs in the 
same way that mdadm.conf and crypttab already do.  You could then parse it 
with C or bash pretty easily...

> > You want to make sure that when a dirty writeback-cached bdev is
> > registered that it does not activate until either:
> >
> >   1. The cache is attached
> >   2. echo 1 > /sys/block/bcache0/bcache/running
> >
> > > - A new IOCTL interface added, even all rested interface are sysfs based.
> >
> > True.  Perhaps something like this would be better, and it would avoid
> > sharing a userspace page for blindly populating `struct cache_sb`, too:
> >
> >   echo '/dev/bdev [bdev_uuid] [/dev/cachedev|cset_uuid] [options]' > ¥
> >           /sys/fs/bcache/register_raw
>
> I thought that introducing an IOCTL interface could be a stopper for
> this patch, so I'm more than welcome to refactor it using sysfs
> entries only. But, I will do so only if there's even the slightest
> chance that this patch can be merged.

I'm for the patch with sysfs, but I'm not the decision maker either.

Coly: what would your requirements be to accept this upstream?

> > Because of the writeback issue above, the cache and bdev either need to be
> > registered simultaneously or the cset uuid need to be specified.
> >
> > > - Do things in kernel space while there is solution in user space.
> > >
> > > All the above opinions are quite personal to myself, I don’t say you are
> > > wrong or I am correct. If the patch works, that’s cool and you can use
> > > it as you want, but I don’t support it to be in upstream.
> >
> > An alternate implementation might be to create a dm-bcache target.  The
> > core bcache code could be left alone except a few EXPORT_SYMBOL()'s so
> > dm-bcache can reach the bcache registration bits.
> >
> > This would:
> >   * Minimally impact the bcache code base
> >   * Solve the blind-populating of `struct cache_sb` issue in the same way
> >     as `register_raw` could work above.
> >   * Create a nicely segmented codebase (dm target) to upstream separately
> >     through the DM team.
> >   * Could be maintained cleanly out-of-tree because the bcache
> >     registration interfaces change very infrequently.
> >   * bdev resize could be done with a `dmsetup replace` but you'll need to
> >     add resize support as below.
> >
> > > > For the operational drawbacks: from time to time, we exploit the
> > > > online filesystem resize capability of XFS to increase the volume
> > > > size. This would be at least tedious, if not nearly impossible, if the
> > > > volume is mapped inside a dm-linear.
> > >
> > > Currently bcache doesn’t support cache or backing device resize. I don’t
> > > see the connection between above statement and feeding an in-memory
> > > super block via IOCTL command.
> >
> > Resize is perhaps unrelated, so if you decide to tackle bdev or cachedev
> > resize then please start a new list thread.  Briefly: supporting bdev
> > resize is probably easy.  I've looked through the code a few times with
> > this in mind but haven't had time.
> >
> > Here's the summary, not sure if there are any other
> > considerations:
> >
> >   1. Create a sysfs file like /sys/block/bcache0/bcache/resize to trigger
> >      resize on echo 1 >.
> >   2. Refactor the set_capacity() bits from  bcache_device_init() into its
> >      own function.
> >   3. Put locks around bcache_device.full_dirty_stripes and
> >      bcache_device.stripe_sectors_dirty.  Re-alloc+copy+free and zero the
> >      new bytes at the end.
> >
> > The cachedev's don't know anything about the bdev size, so (according to
> > Kent) they will "just work" by referencing new offsets that didn't exist
> > before when IOs come through.  (This is basically the same as resizing the
> > bdev and then unregister/re-register which is how we resize bdevs now.)
> >
> > As for resizing a cachedev, I've not looked at all---not sure about that
> > one.  We always detach, resize, make-bcache and re-attach the new cache.
> > Maybe it is similarly simple, but haven't looked.
> >
> > > >> It is unnecessary to create a new IOCTL interface, and I feel the way
> > > >> how it works is really unconvinced for potential security risk.
> > > >>
> > > > Which potential security risks concern you?
> > > >
> > >
> > > Currently we don’t check all members of struct cache_sb_disk, what we do
> > > is to simply trust bcache-tools. Create a new IOCTL interface to send a
> > > user space memory into kernel space as superblock, that needs quite a
> > > lot of checking code to make sure it won’t panic the kernel. It is
> > > possible, but it is not worthy to add so many code for the purpose,
> > > especially adding them into upstream code.
> > >
> > > I am not able to provide an explicit example for security risk, just the
> > > new adding interface makes me not so confident.
> >
> > Maintaining a blind structure population from a userspace page would be
> > difficult as well because even if the kernel validates _everything_ in
> > cache_sb today, anyone extending `struct cache_sb` needs to remember to
> > add checks for that. Failing to enforce validation inside the kernel could
> > lead to kernel crashes or data corruption from userspace which is of
> > course never good.
> >
>
> Can I solve this by refactoring the patch and using sysfs based
> registration instead?

Sure, just make the sysfs interface configurable enough that:
  - all configuration is text (not binary)
  - bcache.txt documentation is updated

-Eric

> For anyone that is interested to try this solution, and as a
> reference, I leave here below the links to my public Github
> repositories:
> - bcache-tools: https://github.com/andreatomassetti/bcache-tools
> - bcache (standalone, patched): https://github.com/andreatomassetti/bcache
> 
> Thank you very much,
> Andrea
> 
> > We always assume that, somehow, someone could leverage an insecure IOCTL
> > call and crash the OS when they shouldn't be allowed to (even if they are
> > not root, like from sudo).  This is a security issue from an assurance and
> > integrity point of view, even if there might be neither an obvious
> > privelege escalation nor privacy concern.
> >
> > -Eric
> >
> >
> > > Thanks.
> > >
> > > Coly Li
> > >
> > >
> > >
> > >
> 
--8323328-1530191041-1657657741=:20520--
