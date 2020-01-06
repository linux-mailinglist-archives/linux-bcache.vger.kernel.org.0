Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592AA131C00
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Jan 2020 00:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgAFXCJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 18:02:09 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:32991 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbgAFXCJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 18:02:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id BBB08A0694;
        Mon,  6 Jan 2020 23:02:03 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id YxkEAo9XdRrd; Mon,  6 Jan 2020 23:01:42 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 405AFA0692;
        Mon,  6 Jan 2020 23:01:37 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 405AFA0692
Date:   Mon, 6 Jan 2020 23:01:36 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
cc:     linux-bcache@vger.kernel.org
Subject: Re: Can't mount an encrypted backing device
In-Reply-To: <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
Message-ID: <alpine.LRH.2.11.2001062258320.2074@mx.ewheeler.net>
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com> <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-844282404-2074427896-1578351697=:2074"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---844282404-2074427896-1578351697=:2074
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 5 Jan 2020, Clodoaldo Neto wrote:

> I'm struggling to mount an encrypted backing device. The backing
> device is a RAID 1 array at /dev/md127 and the cache device is
> /dev/sdb1.
> 
> # lsblk
> NAME                                          MAJ:MIN RM   SIZE RO
> TYPE  MOUNTPOINT
> sda                                             8:0    0 223.6G  0 disk
> ├─sda1                                          8:1    0   700M  0 part  /boot
> ├─sda2                                          8:2    0   700M  0
> part  /boot/efi
> ├─sda3                                          8:3    0    26G  0 part
> │ └─luks-9793c78f-723c-4218-865f-83dbc4659192 253:1    0    26G  0 crypt [SWAP]
> └─sda4                                          8:4    0   162G  0 part
>   └─luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0    0   162G  0 crypt /
> sdb                                             8:16   0 111.8G  0 disk
> ├─sdb1                                          8:17   0    40G  0 part
> └─sdb2                                          8:18   0  71.8G  0 part
> sdc                                             8:32   0   1.8T  0 disk
> └─sdc1                                          8:33   0   1.8T  0 part
>   └─md127                                       9:127  0   1.8T  0 raid1
> sdd                                             8:48   0   1.8T  0 disk
> └─sdd1                                          8:49   0   1.8T  0 part
>   └─md127                                       9:127  0   1.8T  0 raid1
> sde                                             8:64   1  58.9G  0 disk
> ├─sde1                                          8:65   1    20G  0 part
> └─sde2                                          8:66   1  38.9G  0 part
> sr0                                            11:0    1  1024M  0 rom
> 
> # blkid | grep -E "md127|sdb1"
> /dev/sdb1: UUID="535bfa2d-4c6e-4c19-91b2-d292872a1877" TYPE="bcache"
> PARTLABEL="Linux filesystem"
> PARTUUID="505789f1-0523-4c62-bdb1-81bc0cc7bff1"
> /dev/md127: UUID="b17ceaac-27ec-44d8-8bbb-235cfaa0c4a4" TYPE="bcache"
> 
> It was working right when I installed Fedora 31 yesterday but then I
> resized the caching partition and I can't make it work again.
> 
> This is what I tried
> 
> # wipefs -a /dev/sdb1
> /dev/sdb1: 16 bytes were erased at offset 0x00001018 (bcache): c6 85
> 73 f6 4e 1a 45 ca 82 65 f5 7f 48 ba 6d 81
> 
> # make-bcache -C --writeback /dev/sdb1
> UUID:                   eb7d8e72-f24c-48ee-bad0-771afccca876
> Set UUID:               50e33260-4623-4374-9a61-c78b7d75280e
> version:                0
> nbuckets:               81920
> block_size:             1
> bucket_size:            1024
> nr_in_set:              1
> nr_this_dev:            0
> first_bucket:           1
> 
> # ll /sys/fs/bcache/
> total 0
> drwxr-xr-x. 7 root root    0 Jan  5 18:34 50e33260-4623-4374-9a61-c78b7d75280e
> --w-------. 1 root root 4096 Jan  5 17:39 pendings_cleanup
> --w-------. 1 root root 4096 Jan  5 18:03 register
> --w-------. 1 root root 4096 Jan  5 17:39 register_quiet
> 
> # bcache-super-show /dev/sdb1
> sb.magic                ok
> sb.first_sector         8 [match]
> sb.csum                 C4CB62916B7825CE [match]
> sb.version              3 [cache device]
> 
> dev.label               (empty)
> dev.uuid                eb7d8e72-f24c-48ee-bad0-771afccca876
> dev.sectors_per_block   1
> dev.sectors_per_bucket  1024
> dev.cache.first_sector  1024
> dev.cache.cache_sectors 83885056
> dev.cache.total_sectors 83886080
> dev.cache.ordered       yes
> dev.cache.discard       no
> dev.cache.pos           0
> dev.cache.replacement   0 [lru]
> 
> cset.uuid               50e33260-4623-4374-9a61-c78b7d75280e
> 
> # echo /dev/md127 > /sys/fs/bcache/register
> # echo 50e33260-4623-4374-9a61-c78b7d75280e > /sys/block/md127/bcache/attach
> # blkid | grep bcache0
> /dev/bcache0: UUID="7e2c0b40-8dec-4b13-8d00-b53b55160775" TYPE="crypto_LUKS"
> 
> # bcache-status
> --- bcache ---
> UUID                        50e33260-4623-4374-9a61-c78b7d75280e
> Block Size                  512 B
> Bucket Size                 512.00 KiB
> Congested?                  False
> Read Congestion             2.0ms
> Write Congestion            20.0ms
> Total Cache Size            40 GiB
> Total Cache Used            409.6 MiB   (1%)
> Total Cache Unused          40 GiB      (99%)
> Evictable Cache             40 GiB      (100%)
> Replacement Policy          [lru] fifo random
> Cache Mode                  writethrough [writeback] writearound none
> Total Hits                  9   (64%)
> Total Misses                5
> Total Bypass Hits           13  (16%)
> Total Bypass Misses         64
> Total Bypassed              308.00 KiB
> 
> # lsblk
> NAME                                          MAJ:MIN RM   SIZE RO
> TYPE  MOUNTPOINT
> sda                                             8:0    0 223.6G  0 disk
> ├─sda1                                          8:1    0   700M  0 part  /boot
> ├─sda2                                          8:2    0   700M  0
> part  /boot/efi
> ├─sda3                                          8:3    0    26G  0 part
> │ └─luks-9793c78f-723c-4218-865f-83dbc4659192 253:1    0    26G  0 crypt [SWAP]
> └─sda4                                          8:4    0   162G  0 part
>   └─luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0    0   162G  0 crypt /
> sdb                                             8:16   0 111.8G  0 disk
> ├─sdb1                                          8:17   0    40G  0 part
> │ └─bcache0                                   252:0    0   1.8T  0 disk
> └─sdb2                                          8:18   0  71.8G  0 part
> sdc                                             8:32   0   1.8T  0 disk
> └─sdc1                                          8:33   0   1.8T  0 part
>   └─md127                                       9:127  0   1.8T  0 raid1
>     └─bcache0                                 252:0    0   1.8T  0 disk
> sdd                                             8:48   0   1.8T  0 disk
> └─sdd1                                          8:49   0   1.8T  0 part
>   └─md127                                       9:127  0   1.8T  0 raid1
>     └─bcache0                                 252:0    0   1.8T  0 disk
> sde                                             8:64   1  58.9G  0 disk
> ├─sde1                                          8:65   1    20G  0 part
> └─sde2                                          8:66   1  38.9G  0 part
> sr0                                            11:0    1  1024M  0 rom
> 
> # mount /dev/bcache0 /r
> mount: /r: unknown filesystem type 'crypto_LUKS'.
> 
> # cryptsetup open /dev/bcache0 backing-device
> Enter passphrase for /dev/bcache0:
> 
> # mount /dev/mapper/backing-device /r
> mount: /r: unknown filesystem type 'bcache'.

I'm guessing that make-bcache was run upon /dev/mapper/backing-device at 
some point in time. Hopefully it wasn't clobbered.

Try 

mount -t ext2 /dev/mapper/backing-device /r
         ^^^^ or whatever your original FS really was.  

--
Eric Wheeler


> 
> What am I missing?
> 
> Regards, Clodoaldo
> 
---844282404-2074427896-1578351697=:2074--
