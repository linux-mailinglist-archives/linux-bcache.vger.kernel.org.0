Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B3A457A15
	for <lists+linux-bcache@lfdr.de>; Sat, 20 Nov 2021 01:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbhKTAUL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 19 Nov 2021 19:20:11 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:53688 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234697AbhKTAUL (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 19 Nov 2021 19:20:11 -0500
X-Greylist: delayed 653 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2021 19:20:11 EST
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 1DEC68B;
        Fri, 19 Nov 2021 16:06:16 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ldZK7fhPC60H; Fri, 19 Nov 2021 16:06:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 2B32840;
        Fri, 19 Nov 2021 16:06:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 2B32840
Date:   Fri, 19 Nov 2021 16:06:10 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Kai Krakow <kai@kaishome.de>
cc:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Dumas?= <f.dumas@ellis.siteparc.fr>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
In-Reply-To: <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
Message-ID: <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com> <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de> <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-26711895-1637364118=:26882"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-26711895-1637364118=:26882
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

(Fixed mail header and resent, ignore possible duplicate message and
reply to this one instead because the From header was broken.)


Hi Coly, Kai, and Kent, I hope you are well!

On Thu, 18 Nov 2021, Kai Krakow wrote:

> Hi Coly!
> 
> Reading the commit logs, it seems to come from using a non-default
> block size, 512 in my case (although I'm pretty sure that *is* the
> default on the affected system). I've checked:
> ```
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> ```
> 
> The non-affected machines use 4k blocks (sectors per block = 8).

If it is the cache device with 4k blocks, then this could be a known issue 
(perhaps) not directly related to the 5.15 release. We've hit a before:
  https://www.spinics.net/lists/linux-bcache/msg05983.html

and I just talked to Frédéric Dumas this week who hit it too (cc'ed).  
His solution was to use manufacturer disk tools to change the cachedev's 
logical block size from 4k to 512-bytes and reformat (see below).

We've not seen issues with the backing device using 4k blocks, but bcache 
doesn't always seem to make 4k-aligned IOs to the cachedev.  It would be 
nice to find a long-term fix; more and more SSDs support 4k blocks, which 
is a nice x86 page-alignment and may provide for less CPU overhead.

I think this was the last message on the subject from Kent and Coly:

	> On 2018/5/9 3:59 PM, Kent Overstreet wrote:
	> > Have you checked extent merging?
	> 
	> Hi Kent,
	> 
	> Not yet. Let me look into it.
	> 
	> Thanks for the hint.
	> 
	> Coly Li


Here is a snip of my offline conversation with Frédéric:

11/17/2021 04:03 (America/Los_Angeles) - Frédéric Dumas wrote: 
> > > (3) When I declare the newly created /dev/bcache0 device to LVM, it works but with errors:
> > >
> > > # pvcreate /dev/bcache0
> > >  Error reading device /dev/bcache0 at 7965015146496 length 4.
> > >  bcache_invalidate: block (0, 0) still held
> > >  bcache_abort: block (0, 0) still held
> > >  Error reading device /dev/bcache0 at 7965015248896 length 4.
> > >  Error reading device /dev/bcache0 at 7965015259648 length 24.
> > >  Error reading device /dev/bcache0 at 7965015260160 length 512.
> > >  scan_dev_close /dev/bcache0 no DEV_IN_BCACHE set
> > >  scan_dev_close /dev/bcache0 already closed
> > >  Error reading device /dev/bcache0 at 7965015146496 length 4.
> > >  bcache_invalidate: block (0, 0) still held
> > >  bcache_abort: block (0, 0) still held
> > >  Error reading device /dev/bcache0 at 7965015248896 length 4.
> > >  Error reading device /dev/bcache0 at 7965015259648 length 24.
> > >  Error reading device /dev/bcache0 at 7965015260160 length 512.
> > >  Physical volume "/dev/bcache0" successfully created.
> > >
> > > # vgcreate vms /dev/bcache0
> > >  Error reading device /dev/bcache0 at 7965015146496 length 4.
> > >  bcache_invalidate: block (3, 0) still held
> > >  bcache_abort: block (3, 0) still held
> > >  Error reading device /dev/bcache0 at 7965015248896 length 4.
> > >  Error reading device /dev/bcache0 at 7965015259648 length 24.
> > >  Error reading device /dev/bcache0 at 7965015260160 length 512.
> > >  Error reading device /dev/bcache0 at 7965015146496 length 4.
> > >  bcache_invalidate: block (0, 0) still held
> > >  bcache_abort: block (0, 0) still held
> > >  Error reading device /dev/bcache0 at 7965015248896 length 4.
> > >  Error reading device /dev/bcache0 at 7965015259648 length 24.
> > >  Error reading device /dev/bcache0 at 7965015260160 length 512.
> > >  Volume group "vms" successfully created
> > >
> > > The logs do not give any more clues:
> > >
> > > # journalctl | grep -i bcache
> > > Nov 14 13:00:13 softq-pve-710 kernel: bcache: run_cache_set() invalidating existing data
> > > Nov 14 13:00:13 softq-pve-710 kernel: bcache: register_cache() registered cache device md0
> > > Nov 14 13:00:13 softq-pve-710 kernel: bcache: register_bdev() registered backing device sda4
> > > Nov 14 13:00:13 softq-pve-710 kernel: bcache: bch_cached_dev_attach() Caching sda4 as bcache0 on set a8f159d2-06e6-461f-b66b-22419d2829c0
> > > Nov 14 14:35:49 softq-pve-710 lvm[307524]:   pvscan[307524] PV /dev/bcache0 online, VG vms is complete.
> > >
> > > This error seems to have no effect on the operation of LVM. Do you 
> > > know what is causing it, and whether or not I can overlook it?
> > 

> Le 17 nov. 2021 à 22:12, Eric Wheeler <ewheeler@linuxglobal.com> a écrit 
> 
> > I am guessing you have a cache device with 4K sectors and that bcache 
> > is trying to index it on 512 byte boundaries. This is the bug I was 
> > talking about above. You can tell because 
> > 7965015260160/4096=1944583803.75. Note the fractional division from 
> > the last sector listed in your logs just above . If this is easily 
> > reproducible, then please open an issue on the mailing list so that 
> > Coly, the maintainer, can work on a fix.
>

11/19/2021 01:00 (America/Los_Angeles) - Frédéric Dumas wrote:  
> As you anticipated, reformatting the two P3700s with 512 byte sectors 
> instead of 4KB made any error message from bcache disappear.
>  
> # intelmas start -intelssd 0 -nvmeformat LBAFormat=0
> # intelmas start -intelssd 1 -nvmeformat LBAFormat=0
>  
> Then,
>  
> # vgcreate vms /dev/bcache0
>  
> no more errors:
>  
> # vgcreate vms /dev/bcache0
>   Physical volume "/dev/bcache0" successfully created.
>   Volume group "vms" successfully created
> # lvcreate -n store -l 100%VG vms
>   Logical volume "datastore" created.


--
Eric Wheeler



> 
> Can this value be changed "on the fly"? I think I remember that the
> bdev super block must match the cdev super block - although that
> doesn't make that much sense to me.
> 
> By "on the fly" I mean: Re-create the cdev super block, then just
> attach the bdev - in this case, the sectors per block should not
> matter because this is a brand new cdev with no existing cache data.
> But I think it will refuse attaching the devices because of
> non-matching block size (at least this was the case in the past). I
> don't see a point in having a block size in both super blocks at all
> if the only block size that matters lives in the cdev superblock.
> 
> Thanks
> Kai
> 
> Am Di., 16. Nov. 2021 um 12:02 Uhr schrieb Coly Li <colyli@suse.de>:
> >
> > On 11/16/21 6:10 PM, Kai Krakow wrote:
> > > Hello Coly!
> > >
> > > I think I can consistently reproduce a failure mode of bcache when
> > > going from 5.10 LTS to 5.15.2 - on one single system (my other systems
> > > do just fine).
> > >
> > > In 5.10, bcache is stable, no problems at all. After booting to
> > > 5.15.2, btrfs would complain about broken btree generation numbers,
> > > then freeze completely. Going back to 5.10, bcache complains about
> > > being broken and cannot start the cache set.
> > >
> > > I was able to reproduce the following behavior after the problem
> > > struck me twice in a row:
> > >
> > > 1. Boot into SysRescueCD
> > > 2. modprobe bcache
> > > 3. Manually detach the btrfs disks from bcache, set cache mode to
> > > none, force running
> > > 4. Reboot into 5.15.2 (now works)
> > > 5. See this error in dmesg:
> > >
> > > [   27.334306] bcache: bch_cache_set_error() error on
> > > 04af889c-4ccb-401b-b525-fb9613a81b69: empty set at bucket 1213, block
> > > 1, 0 keys, disabling caching
> > > [   27.334453] bcache: cache_set_free() Cache set
> > > 04af889c-4ccb-401b-b525-fb9613a81b69 unregistered
> > > [   27.334510] bcache: register_cache() error sda3: failed to run cache set
> > > [   27.334512] bcache: register_bcache() error : failed to register device
> > >
> > > 6. wipefs the failed bcache cache
> > > 7. bcache make -C -w 512 /dev/sda3 -l bcache-cdev0 --force
> > > 8. re-attach the btrfs disks in writearound mode
> > > 9. btrfs immediately fails, freezing the system (with transactions IDs way off)
> > > 10. reboot loops to 5, unable to mount
> > > 11. escape the situation by starting at 1, and not make a new bcache
> > >
> > > Is this a known error? Why does it only hit this machine?
> > >
> > > SSD Model: Samsung SSD 850 EVO 250GB
> >
> > This is already known, there are 3 locations to fix,
> >
> > 1, Revert commit 2fd3e5efe791946be0957c8e1eed9560b541fe46
> > 2, Revert commit  f8b679a070c536600c64a78c83b96aa617f8fa71
> > 3, Do the following change in drivers/md/bcache.c,
> > @@ -885,9 +885,9 @@ static void bcache_device_free(struct bcache_device *d)
> >
> >                 bcache_device_detach(d);
> >
> >         if (disk) {
> > -               blk_cleanup_disk(disk);
> >                 ida_simple_remove(&bcache_device_idx,
> >                                   first_minor_to_idx(disk->first_minor));
> > +               blk_cleanup_disk(disk);
> >         }
> >
> > The fix 1) and 3) are on the way to stable kernel IMHO, and fix 2) is 
> > only my workaround and I don't see upstream fix yet.
> >
> > Just FYI.
> >
> > Coly Li
> >
> 
--8323328-26711895-1637364118=:26882--
