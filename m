Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB1141701
	for <lists+linux-bcache@lfdr.de>; Sat, 18 Jan 2020 11:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgARKo5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 18 Jan 2020 05:44:57 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:41996 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgARKo5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 18 Jan 2020 05:44:57 -0500
Received: by mail-qt1-f172.google.com with SMTP id j5so23851905qtq.9
        for <linux-bcache@vger.kernel.org>; Sat, 18 Jan 2020 02:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=bzhwXYoAM2h/zyu6g79meaaxt6PMyiQPkmaxImwbZyU=;
        b=fL/DBDyYbYLCIRR6OmHOwkyRLT+QCPV26bhrCfcTNXYNOU8y5X/0pS6c8DK1trUIjQ
         99+utxR3gOPycCYoQpvOyPs7wvDaOIC/TnuDVlbgTgs8GS/aheL1mzA/CGDvNDfohsMh
         EB03m8fedvGzUevLFeXKVMgekqf4+Joq3ISSewlYn4kvHJ78IOltzKrfbSyOIa3jAz34
         YQHyHovU3lsj6X7qU+2CPB7qvDfObGGNw6pz0QZ3/erg6foHrBvaZgeavMzxeDvCqyBO
         R72orRtVgsOMwQcPZSxGyPSIfey2dgiu5mLQIZgNULswoa0dHTlvXvYktLJghd33ANJ8
         t+Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=bzhwXYoAM2h/zyu6g79meaaxt6PMyiQPkmaxImwbZyU=;
        b=HdzCCWZcs81srD1y1dbzd1ybi2msegRTv6oKhhXdnwOfFiDM26ufcYw6lZXm6DcvBG
         fe6xB0l2TIB3oVXjhobQFbTYMv6dPsIc+g5CjsLnsd0HgOfzy0X450w3abxGC9Wqm3SU
         DwRX/tOL9H7BlLUN/POc8v5/2QOrWDrZcf+6dCFBVlAMFdy5r/fsSIIFZrhiKS9H9N90
         MR25VOTkHWZLTtUurcKnmco/LbCMSx4BdN7eHjD16Uyodj2eWdZRR/YmaB5Wa2MClpjQ
         b4TnNVzHSNivDvhY7n9bZ8bP2uXtmzHr7aben+qC4W7mhcT5tkqOLa4ujTNuh9EtnHss
         MuxA==
X-Gm-Message-State: APjAAAUgryQR/Nok7/C4/63k8JPCmSa9FXFnfjzrxqxpf0wWY+T5Kkby
        1Y8EEeU2HH1HjJLCLL+nRX5YiXAMuTNOUqOHCiBqYa7vv/0=
X-Google-Smtp-Source: APXvYqwQc+Y11CsedR1ATU11IK4TIWp3bWitwDc5t1vdlR5ba48NYFaVqVKVOTSswYlV6ZD+5kYiCXzN9JsvxO9SwcU=
X-Received: by 2002:aed:2725:: with SMTP id n34mr11093331qtd.333.1579344295572;
 Sat, 18 Jan 2020 02:44:55 -0800 (PST)
MIME-Version: 1.0
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
 <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
 <alpine.LRH.2.11.2001062258320.2074@mx.ewheeler.net> <CA+Z73LFDs0zGk+24r7XG=oXDZU=wV34GpvAODY96BFXZxrbdhw@mail.gmail.com>
 <alpine.LRH.2.11.2001162250480.23088@mx.ewheeler.net>
In-Reply-To: <alpine.LRH.2.11.2001162250480.23088@mx.ewheeler.net>
Reply-To: clodoaldo.pinto.neto@gmail.com
From:   Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Date:   Sat, 18 Jan 2020 07:44:44 -0300
Message-ID: <CA+Z73LFxEsB-3SqVouDHjb2JwQH+mnqwsBHk7LF0+vKq6cTb=Q@mail.gmail.com>
Subject: Re: Can't mount an encrypted backing device
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jan 16, 2020 at 7:55 PM Eric Wheeler <bcache@lists.ewheeler.net> wr=
ote:
>
> On Sat, 11 Jan 2020, Clodoaldo Neto wrote:
>
> > On Mon, Jan 6, 2020 at 8:02 PM Eric Wheeler <bcache@lists.ewheeler.net>=
 wrote:
> > >
> > > On Sun, 5 Jan 2020, Clodoaldo Neto wrote:
> > >
> > > > I'm struggling to mount an encrypted backing device. The backing
> > > > device is a RAID 1 array at /dev/md127 and the cache device is
> > > > /dev/sdb1.
> > > >
> > > > # lsblk
> > > > NAME                                          MAJ:MIN RM   SIZE RO
> > > > TYPE  MOUNTPOINT
> > > > sda                                             8:0    0 223.6G  0 =
disk
> > > > =E2=94=9C=E2=94=80sda1                                          8:1=
    0   700M  0 part  /boot
> > > > =E2=94=9C=E2=94=80sda2                                          8:2=
    0   700M  0
> > > > part  /boot/efi
> > > > =E2=94=9C=E2=94=80sda3                                          8:3=
    0    26G  0 part
> > > > =E2=94=82 =E2=94=94=E2=94=80luks-9793c78f-723c-4218-865f-83dbc46591=
92 253:1    0    26G  0 crypt [SWAP]
> > > > =E2=94=94=E2=94=80sda4                                          8:4=
    0   162G  0 part
> > > >   =E2=94=94=E2=94=80luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0=
    0   162G  0 crypt /
> > > > sdb                                             8:16   0 111.8G  0 =
disk
> > > > =E2=94=9C=E2=94=80sdb1                                          8:1=
7   0    40G  0 part
> > > > =E2=94=94=E2=94=80sdb2                                          8:1=
8   0  71.8G  0 part
> > > > sdc                                             8:32   0   1.8T  0 =
disk
> > > > =E2=94=94=E2=94=80sdc1                                          8:3=
3   0   1.8T  0 part
> > > >   =E2=94=94=E2=94=80md127                                       9:1=
27  0   1.8T  0 raid1
> > > > sdd                                             8:48   0   1.8T  0 =
disk
> > > > =E2=94=94=E2=94=80sdd1                                          8:4=
9   0   1.8T  0 part
> > > >   =E2=94=94=E2=94=80md127                                       9:1=
27  0   1.8T  0 raid1
> > > > sde                                             8:64   1  58.9G  0 =
disk
> > > > =E2=94=9C=E2=94=80sde1                                          8:6=
5   1    20G  0 part
> > > > =E2=94=94=E2=94=80sde2                                          8:6=
6   1  38.9G  0 part
> > > > sr0                                            11:0    1  1024M  0 =
rom
> > > >
> > > > # blkid | grep -E "md127|sdb1"
> > > > /dev/sdb1: UUID=3D"535bfa2d-4c6e-4c19-91b2-d292872a1877" TYPE=3D"bc=
ache"
> > > > PARTLABEL=3D"Linux filesystem"
> > > > PARTUUID=3D"505789f1-0523-4c62-bdb1-81bc0cc7bff1"
> > > > /dev/md127: UUID=3D"b17ceaac-27ec-44d8-8bbb-235cfaa0c4a4" TYPE=3D"b=
cache"
> > > >
> > > > It was working right when I installed Fedora 31 yesterday but then =
I
> > > > resized the caching partition and I can't make it work again.
> > > >
> > > > This is what I tried
> > > >
> > > > # wipefs -a /dev/sdb1
> > > > /dev/sdb1: 16 bytes were erased at offset 0x00001018 (bcache): c6 8=
5
> > > > 73 f6 4e 1a 45 ca 82 65 f5 7f 48 ba 6d 81
> > > >
> > > > # make-bcache -C --writeback /dev/sdb1
> > > > UUID:                   eb7d8e72-f24c-48ee-bad0-771afccca876
> > > > Set UUID:               50e33260-4623-4374-9a61-c78b7d75280e
> > > > version:                0
> > > > nbuckets:               81920
> > > > block_size:             1
> > > > bucket_size:            1024
> > > > nr_in_set:              1
> > > > nr_this_dev:            0
> > > > first_bucket:           1
> > > >
> > > > # ll /sys/fs/bcache/
> > > > total 0
> > > > drwxr-xr-x. 7 root root    0 Jan  5 18:34 50e33260-4623-4374-9a61-c=
78b7d75280e
> > > > --w-------. 1 root root 4096 Jan  5 17:39 pendings_cleanup
> > > > --w-------. 1 root root 4096 Jan  5 18:03 register
> > > > --w-------. 1 root root 4096 Jan  5 17:39 register_quiet
> > > >
> > > > # bcache-super-show /dev/sdb1
> > > > sb.magic                ok
> > > > sb.first_sector         8 [match]
> > > > sb.csum                 C4CB62916B7825CE [match]
> > > > sb.version              3 [cache device]
> > > >
> > > > dev.label               (empty)
> > > > dev.uuid                eb7d8e72-f24c-48ee-bad0-771afccca876
> > > > dev.sectors_per_block   1
> > > > dev.sectors_per_bucket  1024
> > > > dev.cache.first_sector  1024
> > > > dev.cache.cache_sectors 83885056
> > > > dev.cache.total_sectors 83886080
> > > > dev.cache.ordered       yes
> > > > dev.cache.discard       no
> > > > dev.cache.pos           0
> > > > dev.cache.replacement   0 [lru]
> > > >
> > > > cset.uuid               50e33260-4623-4374-9a61-c78b7d75280e
> > > >
> > > > # echo /dev/md127 > /sys/fs/bcache/register
> > > > # echo 50e33260-4623-4374-9a61-c78b7d75280e > /sys/block/md127/bcac=
he/attach
> > > > # blkid | grep bcache0
> > > > /dev/bcache0: UUID=3D"7e2c0b40-8dec-4b13-8d00-b53b55160775" TYPE=3D=
"crypto_LUKS"
> > > >
> > > > # bcache-status
> > > > --- bcache ---
> > > > UUID                        50e33260-4623-4374-9a61-c78b7d75280e
> > > > Block Size                  512 B
> > > > Bucket Size                 512.00 KiB
> > > > Congested?                  False
> > > > Read Congestion             2.0ms
> > > > Write Congestion            20.0ms
> > > > Total Cache Size            40 GiB
> > > > Total Cache Used            409.6 MiB   (1%)
> > > > Total Cache Unused          40 GiB      (99%)
> > > > Evictable Cache             40 GiB      (100%)
> > > > Replacement Policy          [lru] fifo random
> > > > Cache Mode                  writethrough [writeback] writearound no=
ne
> > > > Total Hits                  9   (64%)
> > > > Total Misses                5
> > > > Total Bypass Hits           13  (16%)
> > > > Total Bypass Misses         64
> > > > Total Bypassed              308.00 KiB
> > > >
> > > > # lsblk
> > > > NAME                                          MAJ:MIN RM   SIZE RO
> > > > TYPE  MOUNTPOINT
> > > > sda                                             8:0    0 223.6G  0 =
disk
> > > > =E2=94=9C=E2=94=80sda1                                          8:1=
    0   700M  0 part  /boot
> > > > =E2=94=9C=E2=94=80sda2                                          8:2=
    0   700M  0
> > > > part  /boot/efi
> > > > =E2=94=9C=E2=94=80sda3                                          8:3=
    0    26G  0 part
> > > > =E2=94=82 =E2=94=94=E2=94=80luks-9793c78f-723c-4218-865f-83dbc46591=
92 253:1    0    26G  0 crypt [SWAP]
> > > > =E2=94=94=E2=94=80sda4                                          8:4=
    0   162G  0 part
> > > >   =E2=94=94=E2=94=80luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0=
    0   162G  0 crypt /
> > > > sdb                                             8:16   0 111.8G  0 =
disk
> > > > =E2=94=9C=E2=94=80sdb1                                          8:1=
7   0    40G  0 part
> > > > =E2=94=82 =E2=94=94=E2=94=80bcache0                                =
   252:0    0   1.8T  0 disk
> > > > =E2=94=94=E2=94=80sdb2                                          8:1=
8   0  71.8G  0 part
> > > > sdc                                             8:32   0   1.8T  0 =
disk
> > > > =E2=94=94=E2=94=80sdc1                                          8:3=
3   0   1.8T  0 part
> > > >   =E2=94=94=E2=94=80md127                                       9:1=
27  0   1.8T  0 raid1
> > > >     =E2=94=94=E2=94=80bcache0                                 252:0=
    0   1.8T  0 disk
> > > > sdd                                             8:48   0   1.8T  0 =
disk
> > > > =E2=94=94=E2=94=80sdd1                                          8:4=
9   0   1.8T  0 part
> > > >   =E2=94=94=E2=94=80md127                                       9:1=
27  0   1.8T  0 raid1
> > > >     =E2=94=94=E2=94=80bcache0                                 252:0=
    0   1.8T  0 disk
> > > > sde                                             8:64   1  58.9G  0 =
disk
> > > > =E2=94=9C=E2=94=80sde1                                          8:6=
5   1    20G  0 part
> > > > =E2=94=94=E2=94=80sde2                                          8:6=
6   1  38.9G  0 part
> > > > sr0                                            11:0    1  1024M  0 =
rom
> > > >
> > > > # mount /dev/bcache0 /r
> > > > mount: /r: unknown filesystem type 'crypto_LUKS'.
> > > >
> > > > # cryptsetup open /dev/bcache0 backing-device
> > > > Enter passphrase for /dev/bcache0:
> > > >
> > > > # mount /dev/mapper/backing-device /r
> > > > mount: /r: unknown filesystem type 'bcache'.
> > >
> > > I'm guessing that make-bcache was run upon /dev/mapper/backing-device=
 at
> > > some point in time. Hopefully it wasn't clobbered.
> > >
> > I guess you are right because /dev/mapper/backing-device is seen as a
> > cache device:
> >
> > # bcache-super-show /dev/mapper/backing-device
> > sb.magic                ok
> > sb.first_sector         8 [match]
> > sb.csum                 D9C2336DD00A6E69 [match]
> > sb.version              3 [cache device]
> >
> > dev.label               (empty)
> > dev.uuid                8022eea3-fcf0-40b8-850a-31e5f841d0bd
> > dev.sectors_per_block   1
> > dev.sectors_per_bucket  1024
> > dev.cache.first_sector  1024
> > dev.cache.cache_sectors 3774576640
> > dev.cache.total_sectors 3774577664
> > dev.cache.ordered       yes
> > dev.cache.discard       no
> > dev.cache.pos           0
> > dev.cache.replacement   0 [lru]
> >
> > cset.uuid               4a63d2b5-1568-473d-925d-53306af2ba7c
> >
> > Is there a path to revert it? Like just formatting it to ext4?
> >
> > > Try
> > >
> > > mount -t ext2 /dev/mapper/backing-device /r
> > >          ^^^^ or whatever your original FS really was.
> > >
> > # mount /dev/mapper/backing-device /r
> > mount: /r: unknown filesystem type 'bcache'.
>
> I don't see a -t option to mount.  Does it work with -t ?

# mount -t ext4 /dev/mapper/backing-device /r
mount: /r: wrong fs type, bad option, bad superblock on
/dev/mapper/backing-device, missing codepage or helper program, or
other error.

>
> If not, and if the cache device is gone forever, you could try this to
> force the device online:
>
> echo 1 > /sys/block/bcache0/bcache/run
>

I will reserve it for later

> > > --
> > > Eric Wheeler
> > >
> > >
> > > >
> > > > What am I missing?
> > > >
> > > > Regards, Clodoaldo
> > > >
> >
