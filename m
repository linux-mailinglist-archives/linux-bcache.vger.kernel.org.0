Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3486567DCAD
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Jan 2023 04:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjA0DaR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 Jan 2023 22:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjA0DaQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 Jan 2023 22:30:16 -0500
X-Greylist: delayed 1201 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 26 Jan 2023 19:30:15 PST
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382B03B65C;
        Thu, 26 Jan 2023 19:30:15 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 4964984;
        Thu, 26 Jan 2023 18:54:03 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id kuwCjWUZ_17q; Thu, 26 Jan 2023 18:53:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id EFFEC49;
        Thu, 26 Jan 2023 18:53:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net EFFEC49
Date:   Thu, 26 Jan 2023 18:53:41 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
cc:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [RFC] Live resize of bcache backing device
In-Reply-To: <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
Message-ID: <9e68cc3-b13f-68e0-61c-59d5d044064@ewheeler.net>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com> <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net> <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com> <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de> <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com> <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de> <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1208808310-1674787980=:32313"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1208808310-1674787980=:32313
Content-Type: text/plain; CHARSET=ISO-2022-JP

On Wed, 25 Jan 2023, Andrea Tomassetti wrote:
> On Tue, Jan 17, 2023 at 5:18 PM Coly Li <colyli@suse.de> wrote:
> > > 2023年1月12日 00:01，Andrea Tomassetti <andrea.tomassetti-opensource@devo.com> 写道：
> > > On Fri, Dec 30, 2022 at 11:41 AM Coly Li <colyli@suse.de> wrote:
> > >> On 9/8/22 4:32 PM, Andrea Tomassetti wrote:
> > >>> From 59787372cf21af0b79e895578ae05b6586dfeb09 Mon Sep 17 00:00:00 2001
> > >>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> > >>> Date: Thu, 8 Sep 2022 09:47:55 +0200
> > >>> Subject: [PATCH] bcache: Add support for live resize of backing devices
> > >>>
> > >>> Here is the first version of the patch. There are some points I noted
> > >>> down
> > >>> that I would like to discuss with you:
> > >>> - I found it pretty convenient to hook the call of the new added
> > >>> function
> > >>>   inside the `register_bcache`. In fact, every time (at least from my
> > >>>   understandings) a disk changes size, it will trigger a new probe and,
> > >>>   thus, `register_bcache` will be triggered. The only inconvenient
> > >>>   is that, in case of success, the function will output
> > >>
> > >> The resize should be triggered manually, and not to do it automatically.
> > >>
> > >> You may create a sysfs file under the cached device's directory, name it
> > >> as "extend_size" or something else you think better.

This is the way it works for other blockdevs:

	echo 1 > /sys/class/block/sdX/device/rescan

... but of course bcache doesn't have a "device" folder.  Maybe a sysfs 
flag named "rescan" or "resize" would be appropriate:

	echo 1 > /sys/block/bcache0/bcache/resize

> > >> Then the sysadmin may extend the cached device size explicitly on a
> > >> predictable time.
> > >>>
> > >>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > >>> index ba3909bb6bea..9a77caf2a18f 100644
> > >>> --- a/drivers/md/bcache/super.c
> > >>> +++ b/drivers/md/bcache/super.c
> > >>> @@ -2443,6 +2443,76 @@ static bool bch_is_open(dev_t dev)
> > >>>     return bch_is_open_cache(dev) || bch_is_open_backing(dev);
> > >>> }
> > >>>
> > >>> +static bool bch_update_capacity(dev_t dev)
> > >>> +{
> > >>> +    const size_t max_stripes = min_t(size_t, INT_MAX,
> > >>> +                     SIZE_MAX / sizeof(atomic_t));
> > >>> +
> > >>> +    uint64_t n, n_old;
> > >>> +    int nr_stripes_old;
> > >>> +    bool res = false;
> > >>> +
> > >>> +    struct bcache_device *d;
> > >>> +    struct cache_set *c, *tc;
> > >>> +    struct cached_dev *dcp, *t, *dc = NULL;
> > >>> +
> > >>> +    uint64_t parent_nr_sectors;
> > >>> +
> > >>> +    list_for_each_entry_safe(c, tc, &bch_cache_sets, list)
> > >>> +        list_for_each_entry_safe(dcp, t, &c->cached_devs, list)
> > >>> +            if (dcp->bdev->bd_dev == dev) {
> > >>> +                dc = dcp;
> > >>> +                goto dc_found;
> > >>> +            }
> > >>> +
> > >>> +dc_found:
> > >>> +    if (!dc)
> > >>> +        return false;
> > >>> +
> > >>> +    parent_nr_sectors = bdev_nr_sectors(dc->bdev) - dc->sb.data_offset;
> > >>> +
> > >>> +    if (parent_nr_sectors == bdev_nr_sectors(dc->disk.disk->part0))
> > >>> +        return false;
> > >>> +
> > >>
> > >> The above code only handles whole disk using as cached device. If a
> > >> partition of a hard drive is used as cache device, and there are other
> > >> data after this partition, such condition should be handled as well. So
> > >> far I am fine to only extend size when using the whole hard drive as
> > >> cached device, but more code is necessary to check and only permits
> > >> size-extend for such condition.

Is it even possible to hot-resize a partition that is in use?  I usually 
get an error if a filesystem from sdb is mounted (or, presumably, if a 
partition is in use as a backing device by bcache):

	# blockdev --rereadpt /dev/sdb
	blockdev: ioctl error on BLKRRPART: Device or resource busy

(I've always wanted a feature in Linux's partition code to support
hot-grow for non-overlapping partition changes that keep the original
starting sector, like when you grow the last partition, but I
digress...)

> > > I don't understand if there's a misalignment here so let me be more
> > > clear: this patch is intended to support the live resize of *backing
> > > devices*, is this what you mean with "cached device"?
> >
> > Yes, backing device is cached device.
> >
> >
> > > When I was working on the patch I didn't consider the possibility of
> > > live resizing the cache devices, but it should be trivial.
> > > So, as far as I understand, a partition cannot be used as a backing
> > > device, correct? The whole disk should be used as a backing device,
> > > that's why I'm checking and that's why this check should be correct.
> > > Am I wrong?
> >
> > Yes a partition can be used as a backing (cached) device. That is to 
> > say, if a file system is format on top of the cached device, this file 
> > system cannot be directly accessed via the partition. It has to be 
> > accessed via the bcache device e.g. /dev/bcache0.

> > >> As I said, it should be a separated write-only sysfile under the cache
> > >> device's directory.
>
> > > Can I ask why you don't like the automatic resize way? Why should the
> > > resize be manual?
> >
> > Most of system administrators don’t like such silently automatic 
> > things. They want to extend the size explicitly, especially when there 
> > is other dependences in their configurations.

+1, I'm one of those administrators...

> What I was trying to say is that, in order to resize a block device, a
> manual command should be executed. So, this is already a "non-silent"
> automatic thing.

In some cases the "manual command" to which you refer may take weeks:

Lets say you have a big hardware RAID5 and add a disk.  After the resize 
completes the RAID controller reports a new disk size to the OS:

	kernel: sd 2:0:0:1: [sdb] 503296888 512-byte logical blocks: (257 GB/239 GiB)
	kernel: sdb: detected capacity change from 150317101056 to 257688006656

Are you suggesting that if `sdb` is the backing device to `bcache0` that 
`bcache0` should be resized immediately when `sdb` detects a capacity 
change?

I would recommend against it:  while I can't control when the RAID
reconstruction finishes (since it takes 2 weeks for us to grow our
arrays), I would like to control when `bcache0` grows in case there is a
bug that triggers an IO hang (or worse).  At least then we can grow
`bcache0` in a maintenance window in case there is a "surprise".

IMHO, this should be controlable by the admin and should be a _manual_ 
procedure (ie, echo 1 > resize)

> Moreover, if the block device has a FS on it, the FS needs to be
> manually grown with some special utilities, e.g. xfs_growfs.

I've never seen a block dev resize call userspace commands from the kernel 
(like xfs_growfs or resize2fs).  Does that exist?  Again, to avoid
surprises, IMHO this should be a udev thing if someone wants it.

> So, again, another non-silent automatic step. Don't you agree? For 
> example, to resize a qcow device attached to a VM I'm manually doing a 
> `virsh blockresize`. As soon as I issue that command, the virtio_blk 
> driver inside the VM detects the disk size change and calls the 
> `set_capacity_and_notify` function.

Yes, that is expected and desired:

> Why then should bcache behave differently?

Because a VM presents itself as hardware.  When you `virsh blockresize` 
from _outside_ of the VM, then the result is effectively the same as a 
RAID reconstruction completing and notifying the OS as in my example 
above.

However, bcache _should_ call `set_capacity_and_notify` when
  echo 1 > /sys/fs/bcache0/bcache/resize
happens, but I'm not convinced that it is a good idea to auto-resize 
`bcache0` when the backing device `sdb` grows.

> If you're concerned that this can somehow break the 
> behaviour-compatibility with older versions of the driver, can we 
> protect this automatic discovery with an optional parameter? Will this 
> be an option you will take into account?

I like the idea of supporting it as a feature for those who might want it, 
but please default it off for the sanity of admins who like more control.  

Maybe /sys/fs/bcache0/bcache/resize can be tri-state sysfs attribute:

	echo 0 > /sys/fs/bcache0/bcache/resize # default
	echo 1 > /sys/fs/bcache0/bcache/resize # one-shot, resets to 0
	echo 2 > /sys/fs/bcache0/bcache/resize # auto-resize on bdev change

-Eric

> 
> Thank you very much,
> Andrea
> >
> > > Someone needs to trigger the block device resize, so shouldn't that be enough?
> >
> > Yes, an explicit write operation on a sysfs file to trigger the resize. Then we can permit people to do the size extend explicit and avoid to change current behavior.
> >
> > Thanks.
> >
> > Coly Li
> >
> > >
> > > Andrea
> > >>
> > >>
> > >>> else
> > >>>                 err = "device busy";
> > >>>             mutex_unlock(&bch_register_lock);
> > >>> --
> > >>> 2.37.3
> > >>>
> > >>
> >
> 
--8323328-1208808310-1674787980=:32313--
