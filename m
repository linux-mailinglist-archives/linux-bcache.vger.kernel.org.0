Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AFC79099E
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Sep 2023 22:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbjIBUzN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Sep 2023 16:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbjIBUzN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Sep 2023 16:55:13 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E65B4
        for <linux-bcache@vger.kernel.org>; Sat,  2 Sep 2023 13:55:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-52bcd4db4e6so226630a12.0
        for <linux-bcache@vger.kernel.org>; Sat, 02 Sep 2023 13:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693688107; x=1694292907; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M5nWi6ztt364z3YdJ4qkVFRBFgHTzx1/xfw37PpC64U=;
        b=etRmdxOGdZcRzXAsM+jRZkz2nU3hgupvqHfDWqnXNCOADF80gwBcWwtxWrnPJyRhMC
         5UMcrruB3GIKc4bEqmAGnmefGbw4LTMwIH3QkvSKppX2HJiK1KS7vQFAUuDPrusmP1Aq
         pPo+bNua8gu1iUZV8fRWKcHu/bzMXcT1p0JRigXURCEy7iyqpcYvBkv8DSoy86eAy8VW
         wJ5tasXhpM68PI1B20rSUg/3InabBp19N3ufsmNJ4ai4l0MsB0XhjGQDhERRofxOmX5W
         ahFBidwVJ3/XHzCBSso38I3DTq/S4CPsc2Lw/NTqDbQBSluvg37QdqizIvk6ThGxEpIP
         8FLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693688107; x=1694292907;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M5nWi6ztt364z3YdJ4qkVFRBFgHTzx1/xfw37PpC64U=;
        b=eTkpfSQhHULtBiDXhGmf+noBMm/gFS+p/vQEoiiEmJJkQ4gUfgmBKsTZ39RjWxdbUz
         rrkIxo7bnpkXmkw/7xMTlXUvDxYSbOmuI21Ki/N7TGWrxwkiLFfHlsDjI9qcDDFPipL1
         1YenRJws5kULE/v4JbhA1Dh7NujAqBcrkNw9cAsVzas43oLTFHKpPAtjurYNxvTSHme4
         riG5JBa2EmIujT88auxpUbgnpivpTMK+V8BJL6jlR8fSgaXmYNGgXy1jW7GoezNvhSND
         7VFGMMPcsQf0uMqTVhGzcnOOlrULeIzVsc4C2Sp/sa6/3yabPzZRSWcRzAAt7axInmx3
         6brw==
X-Gm-Message-State: AOJu0Yzgjir8EmCQ7vaq5m5xx7/36lV+TnH6/j482toDWyPY7wIssISi
        uB1Pv1ZphT0uRoJi3JsKCxjvpKxzOy0ztl7+fdr7Mb4r5aQ=
X-Google-Smtp-Source: AGHT+IEbC5yufzpM6VFRRLKmNSz/uLpCkkXIJpjBSrHHo/4j7xzlycRUwrgtuOpWt5wqdag0kt2NIPqubdZHtKjfD+Y=
X-Received: by 2002:aa7:d5c9:0:b0:523:4acb:7f41 with SMTP id
 d9-20020aa7d5c9000000b005234acb7f41mr4495985eds.14.1693688106755; Sat, 02 Sep
 2023 13:55:06 -0700 (PDT)
MIME-Version: 1.0
From:   Pitxyoki <pitxyoki@gmail.com>
Date:   Sat, 2 Sep 2023 21:54:55 +0100
Message-ID: <CANNm6ZxemivAjgzXNzRg7unJddsEsFbVBmc0z=d-KMixtoEx6A@mail.gmail.com>
Subject: Unbootable system (already manually recovered): "corrupted btree at
 bucket ..., block ..., ... keys, disabling caching"
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

I just recovered from a pretty uncomfortable problem with Bcache.
Having read this in
https://www.kernel.org/doc/html/v5.7/admin-guide/bcache.html, I'm
reporting what happened:

=C2=ABC. Corrupt bcache crashes the kernel at device registration time:
This should never happen. If it does happen, then you have found a
bug! Please report it to the bcache development list:
linux-bcache@vger.kernel.org
Be sure to provide as much information that you can including kernel
dmesg output if available so that we may assist.=C2=BB


So, sit back and read on for an (not so?) interesting tale:

I have a somewhat complex setup, with 2 HDDs and 2 NVMe drives
providing caching.
This is all mounted over an md device and the root filesystem is
installed on top of this.
This setup has been working for me with no issues for about 3 years.

Current versions:
$ uname -a
Linux C-5 6.1.0-10-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.38-1
(2023-07-14) x86_64 GNU/Linux
$ apt policy bcache-tools
bcache-tools:
  Installed: 1.0.8-4

In the end I paste the output of lsblk and bcache-super-show for the
relevant drives (with a working system).

--------------------
I usually set my computer to hibernate so I don't lose the context of
what I was doing before. This time something went very wrong.
I set it to hibernate on August 30th at night, at around 22:30.
When I came back on August 31st, the image was frozen, with the clock
still showing August 30th 22:30. The mouse and keyboard were
unresponsive.

I forced it to shut down by pressing the power button.

When booting up again, it went through GRUB and displayed this (this
was deterministic, the values of the reported buckets changed on
different attempts):

[    0.975019] bcache: bch_cache_set_error() error on
6de5186a-bc7c-46b8-a97d-d308d49db7d8: corrupted btree at bucket
818470, block 267, 324 keys, disabling caching
[    0.975075] bcache: bch_cache_set_error() error on
6de5186a-bc7c-46b8-a97d-d308d49db7d8: io error reading bucket 777551,
disabling caching
[    3.327527] bcache: bch_cache_set_error() error on
6de5186a-bc7c-46b8-a97d-d308d49db7d8: corrupted btree at bucket
818470, block 267, 324 keys, disabling caching
/scripts/local-block/mdadm: 58: /scripts/local-block/mdadm: rm: not found
Gave-up waiting for root file system device. Common problems:
 - Boot args (cat /proc/cmdline)
   - Check rootdelay=3D (did the system wait long enough?)
  - Missing modules (cat /proc/modules; ls /dev)
ALERT! UUID=3D5864ba4a-3991-4e19-9d17-e9ecd56e88c6 does not exist.
Dropping to a shell!
(initramfs)

(I copied this over by hand, there may be typos)


Looking around the /sys/block/ filesystem in the initramfs shell at
least showed that the backing and cache devices were there, so I
trusted that I could recover from this.

First I reminded myself about the Bcache concepts, reading from here:
* https://wiki.ubuntu.com/ServerTeam/Bcache
* https://wiki.archlinux.org/title/Bcache

Then, I used the following pages as guides for the commands to issue:
* https://www.kernel.org/doc/html/v5.7/admin-guide/bcache.html
* https://unix.stackexchange.com/questions/560469/missing-bcache0-backing-d=
evice


This is what I ended up doing (from what I remember):
1. Removed one of the HDDs and one of the NVMes, so that I could have
at least two attempts at recovering this.
2. Booting into GRUB displayed the same problem.
3. I switched the HDD+NVMe, to make sure the problem was stable across
both combinations of drives. It was.

My strategy was then to remove the cache device and see if it was
possible to boot with only the backing device:
4. I booted from a Debian 11 live USB image. This showed both md
devices with just one backing device each, as expected.
5. From there, I removed the cache device from the Bcache setup:
    a. debian:~# echo none > /sys/block/md125/bcache/cache_mode
    b. debian:~# echo 1 > /sys/block/md125/bcache/detach
    c. debian:~# wipefs -a /dev/md127
       wipefs: error: /dev/md127: probing initialization failed:
Device or resource busy

       I also noticed that the /dev/bcache0 device was not present.
This was very similar to the report in
https://unix.stackexchange.com/questions/560469/missing-bcache0-backing-dev=
ice
       As such, I combined the commands in the answer to that with
those suggested, sections E/F in
https://www.kernel.org/doc/html/v5.7/admin-guide/bcache.html#howto-cookbook=
:
    a. debian:~# echo 1 > /sys/block/md125/bcache/stop
    b. debian:~# echo 1 > /sys/block/md125/bcache/detach
    c. debian:~# wipefs -a /dev/md127
       /dev/md127: 16 bytes were erased at offset 0x00001018 (bcache):
c6 85 73 f6 4e 1a 45 ca 82 65 f5 7f 48 ba 6d 81
    d. debian:~# echo /dev/md125 > /sys/fs/bcache/register
    e. debian:~# echo 1 > /sys/block/md125/bcache/running

6. (I'm not 100% sure if the sequence for the commands above was
exactly this. I am also not sure if I attached some device at the end
of the sequence, probably not)
7. debian:~# fsck.ext4 -cv  /dev/bcache0
   a. No errors were found. Pouff!
8. Rebooted into GRUB.
9. GRUB kicked me again into the initramfs shell, but now it was not
preceded by any bcache-related error lines.
   From that shell, I verified that the cache device was not
associated, and that the backing device was not "running".
   I then issued:
   # echo 1 > /sys/block/md125/bcache/running
   # exit

   ...and the system booted.

10. Now in my normal system, I recreated the cache device over
/dev/md127 and reattached it.
    I rebuilt the MD devices and the system has been stable.

I cannot find any errors in /var/log/syslog or journalctl from the
time I asked the computer to hibernate, on the 30th. It only has log
lines for normal operation until about 1 hour before:

Aug 30 21:20:20 C-5 systemd[1]: Finished apt-listbugs.service - Hourly
check for daily apt-listbugs preferences cleanup.
Aug 30 21:30:01 C-5 CRON[3356104]: pam_unix(cron:session): session
opened for user root(uid=3D0) by (uid=3D0)
Aug 30 21:30:01 C-5 CRON[3356105]: (root) CMD ([ -x
/etc/init.d/anacron ] && if [ ! -d /run/systemd/system ]; then
/usr/sbin/invoke-rc.d anacron start >/dev/null; fi)
Aug 30 21:30:01 C-5 CRON[3356104]: pam_unix(cron:session): session
closed for user root
Aug 30 21:34:30 C-5 systemd[1]: Started anacron.service - Run anacron jobs.
Aug 30 21:34:30 C-5 anacron[3368976]: Anacron 2.3 started on 2023-08-30
Aug 30 21:34:30 C-5 anacron[3368976]: Normal exit (0 jobs run)
Aug 30 21:34:30 C-5 systemd[1]: anacron.service: Deactivated successfully.
-- Boot d809418631c142099bfc35cedd66bd5e --
Sep 02 09:50:43 C-5 systemd-journald[720]: Journal started


I suspected of a faulty drive(s), but:
   * S.M.A.R.T. data shows nothing special for any of the NVMe or HDD drive=
s.
   * `nvme self-test-log` for both nvme drives shows all test results as 0x=
f.
   * `nvme error-log` for both nvme drives shows all commands as successful=
.
   * `smartctl -a` for the HDDs shows no errors either.


In the end, this was a pretty frightening event that I hope doesn't
occur again any time soon.
Unfortunately, I don't know how/if I can further debug the cause to
prevent it from happening again.
If you can contribute to discover what may have caused this, or if
more information about this would be useful to you, feel free to ask.


Best regards,
Lu=C3=ADs Picciochi Oliveira


--------------------
Appendix:
Details of the bcache setup (after recovery - it should be the same as befo=
re):


$ lsblk  -oNAME,SIZE,TYPE,MOUNTPOINTS,LABEL,FSTYPE /dev/sda3 /dev/sdb3
/dev/nvme0n1 /dev/nvme1n1
NAME            SIZE TYPE  MOUNTPOINTS LABEL        FSTYPE
sda3            7.2T part              debian:data  linux_raid_member
=E2=94=94=E2=94=80md125         7.2T raid1                          bcache
  =E2=94=94=E2=94=80bcache0     7.2T disk  /           Linux-RAID   ext4
sdb3            7.2T part              debian:data  linux_raid_member
=E2=94=94=E2=94=80md125         7.2T raid1                          bcache
  =E2=94=94=E2=94=80bcache0     7.2T disk  /           Linux-RAID   ext4
nvme1n1       931.5G disk
=E2=94=94=E2=94=80nvme1n1p1   931.5G part              debian:cache linux_r=
aid_member
  =E2=94=94=E2=94=80md127     931.4G raid1                          bcache
=E2=94=94=E2=94=80bcache0   7.2T disk  /           Linux-RAID   ext4
nvme0n1       931.5G disk
=E2=94=94=E2=94=80nvme0n1p1   931.5G part              debian:cache linux_r=
aid_member
  =E2=94=94=E2=94=80md127     931.4G raid1                          bcache
=E2=94=94=E2=94=80bcache0   7.2T disk  /           Linux-RAID   ext4



# bcache-super-show /dev/md125
sb.magic ok
sb.first_sector 8 [match]
sb.csum CABB3EA4D8F30521 [match]
sb.version 1 [backing device]

dev.label (empty)
dev.uuid 364dd782-b1a9-4617-84f2-52be3346c006
dev.sectors_per_block 1
dev.sectors_per_bucket 1024
dev.data.first_sector 16
dev.data.cache_mode 1 [writeback]
dev.data.cache_state 2 [dirty]

cset.uuid 67fe244b-0243-4a16-8421-81f1c4a9bf6e

# bcache-super-show /dev/md127
sb.magic ok
sb.first_sector 8 [match]
sb.csum 1FC6C801046C29DF [match]
sb.version 3 [cache device]

dev.label (empty)
dev.uuid a23a4295-ec44-48a9-bcd8-b5a62efcb4a5
dev.sectors_per_block 1
dev.sectors_per_bucket 1024
dev.cache.first_sector 1024
dev.cache.cache_sectors 1953257472
dev.cache.total_sectors 1953258496
dev.cache.ordered yes
dev.cache.discard no
dev.cache.pos 0
dev.cache.replacement 0 [lru]

cset.uuid 67fe244b-0243-4a16-8421-81f1c4a9bf6e
