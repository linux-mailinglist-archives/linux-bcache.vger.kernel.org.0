Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74732B2279
	for <lists+linux-bcache@lfdr.de>; Fri, 13 Nov 2020 18:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgKMRbh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Fri, 13 Nov 2020 12:31:37 -0500
Received: from vostok.pvgoran.name ([71.19.149.48]:48591 "EHLO
        vostok.pvgoran.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgKMRbg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 13 Nov 2020 12:31:36 -0500
Received: from [10.0.10.127] (l37-193-246-51.novotelecom.ru [::ffff:37.193.246.51])
  (AUTH: CRAM-MD5 main-collector@pvgoran.name, )
  by vostok.pvgoran.name with ESMTPSA
  id 0000000000085FD6.000000005FAEC2F7.000039D2; Fri, 13 Nov 2020 17:31:35 +0000
Date:   Sat, 14 Nov 2020 00:31:33 +0700
From:   Pavel Goran <via-bcache@pvgoran.name>
X-Mailer: The Bat! (v3.85.03) Professional
Reply-To: Pavel Goran <via-bcache@pvgoran.name>
X-Priority: 3 (Normal)
Message-ID: <1132527885.20201114003133@pvgoran.name>
To:     Jean-Denis Girard <jd.girard@sysnux.pf>
CC:     linux-bcache@vger.kernel.org
Subject: Re[2]: bcache error -> btrfs unmountable
In-Reply-To: <romdor$11i3$1@ciao.gmane.io>
References: <rokg8t$u8n$1@ciao.gmane.io> <1854634128.20201113145913@pvgoran.name> <romag0$2ci$1@ciao.gmane.io> <1726375278.20201113231911@pvgoran.name> <romdor$11i3$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Jean-Denis,

Friday, November 13, 2020, 11:54:50 PM, you wrote:

> Le 13/11/2020 a 06:19, Pavel Goran a ecrit :
>> First, you may want to check if there is any dirty data in the cache, by
>> executing:
>> cat /sys/block/bcache0/bcache/state
>> cat /sys/block/bcache1/bcache/state
>> 
>> If these return "clean", then you should be good to detach the cache.

> I get "no cache", not sure why:
> [jdg@tiare ~]$ cat /sys/block/bcache{0,1}/bcache/state
> no cache
> no cache

This means that bcache already detached the faulty cache device. The data
that was cached but not written to the backing devices is now lost. (I don't
expect it to be recoverable, but don't take my word for it.) The logs from
your initial message say that the cache was dirty, so there *was* some
non-written data in the cache.

You can now try to check the BTRFS devices, preferably in read-only mode.
(It's important in case you would try to recoved the lost cached data.)
Since you mentioned you had a backup, probably there isn't much sense in
trying to recover the data, so you could just try to mount the BTRFS
filesystem instead. Maybe compare the filesystem contents with what was
restored from the backup, if you are curious (and if the filesystem can be
mounted). Maybe do btrfs scrub, too.

> Here are the kernel logs concerning bcache:
> [jdg@tiare ~]$ dmesg | grep bcache
> [    9.217610] bcache: bch_journal_replay() journal replay done, 0 keys 
> in 1 entries, seq 254637130
> [    9.219671] bcache: register_cache() registered cache device nvme0n1p4
> [    9.223512] bcache: register_bdev() registered backing device sdc
> [    9.226015] bcache: register_bdev() registered backing device sdb
> [    9.312796] BTRFS: device fsid c5b8386b-b81d-4473-9340-7b8a74fc3a3c 
> devid 2 transid 29647859 /dev/bcache1 scanned by systemd-udevd (314)
> [    9.314219] BTRFS: device fsid c5b8386b-b81d-4473-9340-7b8a74fc3a3c 
> devid 1 transid 29647859 /dev/bcache0 scanned by systemd-udevd (290)

> That was after rebooting, and no trying to mount the broken Btrfs RAID1.

> So, should I detach the cache?


> Thanks for your assistance Pavel,
> Best regards,



Pavel Goran
  

