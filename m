Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF5130A28
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jan 2020 23:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgAEWPJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jan 2020 17:15:09 -0500
Received: from mail-qk1-f173.google.com ([209.85.222.173]:42443 "EHLO
        mail-qk1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgAEWPJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jan 2020 17:15:09 -0500
Received: by mail-qk1-f173.google.com with SMTP id z14so36741479qkg.9
        for <linux-bcache@vger.kernel.org>; Sun, 05 Jan 2020 14:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=D/zAODEWj0lDL/vUZvuQ32tbB2FeXxocoDhKyPbaHPY=;
        b=C0ee643a7iJKm7rNL5vcOzrzWPD++0lpwadgK+h8A5fNacsStVnwBrE2UByQNOwmpo
         KWQ8R+3Qo+tq8qmSLYr0kWoVx61RNP64+bAUiME8WbKwup7yw0eu0I1323olEdC0qUrD
         yEbtMQf0Sodv+xOFDB+8J92cL189P+/Nt1tz2W2CJdeVaSFIPzz659eHjIFStSqb97B7
         nH2pAJzfbBPNgGRwJRU9iE3nS4x3Ym5B5ZrV2KXXhI95YXZQp9IWuvV+mKsWkuXacE8X
         uHlNb/RB9TP3oozaZN/eDXk7BYKnZLGDW9qi025FSWiie153tRl7d1m351/QxfsEuEH2
         7MYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=D/zAODEWj0lDL/vUZvuQ32tbB2FeXxocoDhKyPbaHPY=;
        b=FQgHm5RaClOF+fw9ZoeHyMF78e+CKK+G2YdUWpqdoVtSLfRp4HD50L1+cm1YLwFCIt
         MSivYgyal9IZRqHeOxGW6BSAIcW8ICEj1S+mP5lyx4M0YZRyWnP7s1rYHhIFIxCWCf18
         I4fggJFFxuDceRmplBzxiXqojnxSmtNTp5fIy6ezXK9qbIP7iF7MirZ9QH8kDIJkNQuE
         cO/tzyYntGy2xOem3q4xTLmUgSADpSBFi2axfGmHKyJWoMR1qhD+Uwfv6Z7yM9t2DgYt
         6Oa7vG+akyLtBIT3OjJm5apWw8b6+cBKlbyGXITJou2CXnj7yUUrFQPHpwZLielheHZw
         EAWw==
X-Gm-Message-State: APjAAAXi0rHzXLNNNkZh07ydc3NcqsuwX7pgyn+a+iiRDqjnhTeY8Fup
        BVVm56uol4OE6lcFH+vkIW3B0EJjtRZ72AAStr/50Cyw
X-Google-Smtp-Source: APXvYqz3G9oDMF8ZR8trOzjO1seJexytrs1FSrxeOdLlxRBh8dRTGO2T+yZdV8GTB+KHoEfeYtNf2BRUwYaJMQ/VUe4=
X-Received: by 2002:ae9:e40d:: with SMTP id q13mr82186128qkc.2.1578262507708;
 Sun, 05 Jan 2020 14:15:07 -0800 (PST)
MIME-Version: 1.0
References: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
In-Reply-To: <CA+Z73LFJLiP7Z2_cDUsO4Om_8pdD6w1jTSGQB0jY5sL-+nw1Wg@mail.gmail.com>
Reply-To: clodoaldo.pinto.neto@gmail.com
From:   Clodoaldo Neto <clodoaldo.pinto.neto@gmail.com>
Date:   Sun, 5 Jan 2020 19:14:56 -0300
Message-ID: <CA+Z73LGvXa_V8t=KYPkrmeJ-xmEXmz1uAnaT=Yj5AReZgLeqhg@mail.gmail.com>
Subject: Can't mount an encrypted backing device
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I'm struggling to mount an encrypted backing device. The backing
device is a RAID 1 array at /dev/md127 and the cache device is
/dev/sdb1.

# lsblk
NAME                                          MAJ:MIN RM   SIZE RO
TYPE  MOUNTPOINT
sda                                             8:0    0 223.6G  0 disk
=E2=94=9C=E2=94=80sda1                                          8:1    0   =
700M  0 part  /boot
=E2=94=9C=E2=94=80sda2                                          8:2    0   =
700M  0
part  /boot/efi
=E2=94=9C=E2=94=80sda3                                          8:3    0   =
 26G  0 part
=E2=94=82 =E2=94=94=E2=94=80luks-9793c78f-723c-4218-865f-83dbc4659192 253:1=
    0    26G  0 crypt [SWAP]
=E2=94=94=E2=94=80sda4                                          8:4    0   =
162G  0 part
  =E2=94=94=E2=94=80luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0    0   =
162G  0 crypt /
sdb                                             8:16   0 111.8G  0 disk
=E2=94=9C=E2=94=80sdb1                                          8:17   0   =
 40G  0 part
=E2=94=94=E2=94=80sdb2                                          8:18   0  7=
1.8G  0 part
sdc                                             8:32   0   1.8T  0 disk
=E2=94=94=E2=94=80sdc1                                          8:33   0   =
1.8T  0 part
  =E2=94=94=E2=94=80md127                                       9:127  0   =
1.8T  0 raid1
sdd                                             8:48   0   1.8T  0 disk
=E2=94=94=E2=94=80sdd1                                          8:49   0   =
1.8T  0 part
  =E2=94=94=E2=94=80md127                                       9:127  0   =
1.8T  0 raid1
sde                                             8:64   1  58.9G  0 disk
=E2=94=9C=E2=94=80sde1                                          8:65   1   =
 20G  0 part
=E2=94=94=E2=94=80sde2                                          8:66   1  3=
8.9G  0 part
sr0                                            11:0    1  1024M  0 rom

# blkid | grep -E "md127|sdb1"
/dev/sdb1: UUID=3D"535bfa2d-4c6e-4c19-91b2-d292872a1877" TYPE=3D"bcache"
PARTLABEL=3D"Linux filesystem"
PARTUUID=3D"505789f1-0523-4c62-bdb1-81bc0cc7bff1"
/dev/md127: UUID=3D"b17ceaac-27ec-44d8-8bbb-235cfaa0c4a4" TYPE=3D"bcache"

It was working right when I installed Fedora 31 yesterday but then I
resized the caching partition and I can't make it work again.

This is what I tried

# wipefs -a /dev/sdb1
/dev/sdb1: 16 bytes were erased at offset 0x00001018 (bcache): c6 85
73 f6 4e 1a 45 ca 82 65 f5 7f 48 ba 6d 81

# make-bcache -C --writeback /dev/sdb1
UUID:                   eb7d8e72-f24c-48ee-bad0-771afccca876
Set UUID:               50e33260-4623-4374-9a61-c78b7d75280e
version:                0
nbuckets:               81920
block_size:             1
bucket_size:            1024
nr_in_set:              1
nr_this_dev:            0
first_bucket:           1

# ll /sys/fs/bcache/
total 0
drwxr-xr-x. 7 root root    0 Jan  5 18:34 50e33260-4623-4374-9a61-c78b7d752=
80e
--w-------. 1 root root 4096 Jan  5 17:39 pendings_cleanup
--w-------. 1 root root 4096 Jan  5 18:03 register
--w-------. 1 root root 4096 Jan  5 17:39 register_quiet

# bcache-super-show /dev/sdb1
sb.magic                ok
sb.first_sector         8 [match]
sb.csum                 C4CB62916B7825CE [match]
sb.version              3 [cache device]

dev.label               (empty)
dev.uuid                eb7d8e72-f24c-48ee-bad0-771afccca876
dev.sectors_per_block   1
dev.sectors_per_bucket  1024
dev.cache.first_sector  1024
dev.cache.cache_sectors 83885056
dev.cache.total_sectors 83886080
dev.cache.ordered       yes
dev.cache.discard       no
dev.cache.pos           0
dev.cache.replacement   0 [lru]

cset.uuid               50e33260-4623-4374-9a61-c78b7d75280e

# echo /dev/md127 > /sys/fs/bcache/register
# echo 50e33260-4623-4374-9a61-c78b7d75280e > /sys/block/md127/bcache/attac=
h
# blkid | grep bcache0
/dev/bcache0: UUID=3D"7e2c0b40-8dec-4b13-8d00-b53b55160775" TYPE=3D"crypto_=
LUKS"

# bcache-status
--- bcache ---
UUID                        50e33260-4623-4374-9a61-c78b7d75280e
Block Size                  512 B
Bucket Size                 512.00 KiB
Congested?                  False
Read Congestion             2.0ms
Write Congestion            20.0ms
Total Cache Size            40 GiB
Total Cache Used            409.6 MiB   (1%)
Total Cache Unused          40 GiB      (99%)
Evictable Cache             40 GiB      (100%)
Replacement Policy          [lru] fifo random
Cache Mode                  writethrough [writeback] writearound none
Total Hits                  9   (64%)
Total Misses                5
Total Bypass Hits           13  (16%)
Total Bypass Misses         64
Total Bypassed              308.00 KiB

# lsblk
NAME                                          MAJ:MIN RM   SIZE RO
TYPE  MOUNTPOINT
sda                                             8:0    0 223.6G  0 disk
=E2=94=9C=E2=94=80sda1                                          8:1    0   =
700M  0 part  /boot
=E2=94=9C=E2=94=80sda2                                          8:2    0   =
700M  0
part  /boot/efi
=E2=94=9C=E2=94=80sda3                                          8:3    0   =
 26G  0 part
=E2=94=82 =E2=94=94=E2=94=80luks-9793c78f-723c-4218-865f-83dbc4659192 253:1=
    0    26G  0 crypt [SWAP]
=E2=94=94=E2=94=80sda4                                          8:4    0   =
162G  0 part
  =E2=94=94=E2=94=80luks-569b1153-2fab-4984-b1b6-c4a02ee206ef 253:0    0   =
162G  0 crypt /
sdb                                             8:16   0 111.8G  0 disk
=E2=94=9C=E2=94=80sdb1                                          8:17   0   =
 40G  0 part
=E2=94=82 =E2=94=94=E2=94=80bcache0                                   252:0=
    0   1.8T  0 disk
=E2=94=94=E2=94=80sdb2                                          8:18   0  7=
1.8G  0 part
sdc                                             8:32   0   1.8T  0 disk
=E2=94=94=E2=94=80sdc1                                          8:33   0   =
1.8T  0 part
  =E2=94=94=E2=94=80md127                                       9:127  0   =
1.8T  0 raid1
    =E2=94=94=E2=94=80bcache0                                 252:0    0   =
1.8T  0 disk
sdd                                             8:48   0   1.8T  0 disk
=E2=94=94=E2=94=80sdd1                                          8:49   0   =
1.8T  0 part
  =E2=94=94=E2=94=80md127                                       9:127  0   =
1.8T  0 raid1
    =E2=94=94=E2=94=80bcache0                                 252:0    0   =
1.8T  0 disk
sde                                             8:64   1  58.9G  0 disk
=E2=94=9C=E2=94=80sde1                                          8:65   1   =
 20G  0 part
=E2=94=94=E2=94=80sde2                                          8:66   1  3=
8.9G  0 part
sr0                                            11:0    1  1024M  0 rom

# mount /dev/bcache0 /r
mount: /r: unknown filesystem type 'crypto_LUKS'.

# cryptsetup open /dev/bcache0 backing-device
Enter passphrase for /dev/bcache0:

# mount /dev/mapper/backing-device /r
mount: /r: unknown filesystem type 'bcache'.

What am I missing?

Regards, Clodoaldo
