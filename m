Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F796DC0A8
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Apr 2023 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjDIQhd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Apr 2023 12:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDIQhd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Apr 2023 12:37:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440BF3A93
        for <linux-bcache@vger.kernel.org>; Sun,  9 Apr 2023 09:37:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DEE8C21984;
        Sun,  9 Apr 2023 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681058249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPEISJrIsJG5XllSjyhBvdWqNn6ip9TaKluass5G8GA=;
        b=a0Y8BU72hY6REr/H1i2MgjY9gpZqC0csty8y04XrbQnXfiReD+iRsFyi+SPAY1sduFpQ1K
        r3cadR7NlvSzJui8UOYFVpGYRPXDuCfD2jd30EbpzDFs/LJP4mJsN1PZti9bz4TuO4CE3I
        U4lgooez0BXx4KU8yK5VjBAwpWq/lAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681058249;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPEISJrIsJG5XllSjyhBvdWqNn6ip9TaKluass5G8GA=;
        b=YhzA+fn6iAygXuiHBURzVw1MG3atYhxjg2dfzZr6AWFQ9kvbrsPn+UlPrwB2dhBLQWzJL8
        cqysPtGxU+EwfPCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E90F913461;
        Sun,  9 Apr 2023 16:37:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0gYCCMfpMmSOEgAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 09 Apr 2023 16:37:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Writeback cache all used.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <2054791833.3229438.1680723106142@mail.yahoo.com>
Date:   Mon, 10 Apr 2023 00:37:11 +0800
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
 <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
 <1121771993.1793905.1680221827127@mail.yahoo.com>
 <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
 <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
 <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
 <1783117292.2943582.1680640140702@mail.yahoo.com>
 <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
 <2054791833.3229438.1680723106142@mail.yahoo.com>
To:     Adriano Silva <adriano_da_silva@yahoo.com.br>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B44=E6=9C=886=E6=97=A5 03:31=EF=BC=8CAdriano Silva =
<adriano_da_silva@yahoo.com.br> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello Coly.
>=20
> Yes, the server is always on. I allowed it to stay on for more than 24 =
hours with zero disk I/O to the bcache device. The result is that there =
are no movements on the cache or data disks, nor on the bcache device as =
we can see:
>=20
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 =
---io/sdc----io/nvme0n1--io/bcache0 ----system----
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  =
writ|     time    =20
>   54k  154k: 301k  221k: 223k  169k|0.67  0.54 :6.99  20.5 :6.77  12.3 =
|05-04 14:45:50
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:51
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:52
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:53
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:54
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:55
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:56
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:57
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:58
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:45:59
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:00
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:01
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:02
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:03
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:04
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:05
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:06
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 14:46:07
>=20
> It can stay like that for hours without showing any, zero data flow, =
either read or write on any of the devices.
>=20
> root@pve-00-005:~# cat /sys/block/bcache0/bcache/state
> clean
> root@pve-00-005:~#
>=20
> But look how strange, in another command (priority_stats), it shows =
that there is still 1% of dirt in the cache. And 0% unused cache space. =
Even after hours of server on and completely idle:
>=20
> root@pve-00-005:~# cat =
/sys/devices/pci0000:80/0000:80:01.1/0000:82:00.0/nvme/nvme0/nvme0n1/nvme0=
n1p1/bcache/priority_stats
> Unused:         0%
> Clean:          98%
> Dirty:          1%
> Metadata:       0%
> Average:        1137
> Sectors per Q:  36245232
> Quantiles:      [12 26 42 60 80 127 164 237 322 426 552 651 765 859 =
948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2350 =
2471 2594 2764]
>=20
> Why is this happening?
>=20
>> Can you try to write 1 to cache set sysfs file=20
>> gc_after_writeback?=20
>> When it is set, a gc will be waken up automatically after=20
>> all writeback accomplished. Then most of the clean cache=20
>> might be shunk and the B+tree nodes will be deduced=20
>> quite a lot.
>=20
> Would this be the command you ask me for?
>=20
> root@pve-00-005:~# echo 1 > =
/sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb3fbbcd/internal/gc_after_writ=
eback
>=20
> If this command is correct, I already advance that it did not give the =
expected result. The Cache continues with 100% of the occupied space. =
Nothing has changed despite the cache being cleaned and having written =
the command you recommended. Let's see:
>=20
> root@pve-00-005:~# cat =
/sys/block/bcache0/bcache/cache/cache0/priority_stats
> Unused:         0%
> Clean:          98%
> Dirty:          1%
> Metadata:       0%
> Average:        1137
> Sectors per Q:  36245232
> Quantiles:      [12 26 42 60 80 127 164 237 322 426 552 651 765 859 =
948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2350 =
2471 2594 2764]
>=20
> But if there was any movement on the disks after the command, I =
couldn't detect it:
>=20
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 =
---io/sdc----io/nvme0n1--io/bcache0 ----system----
>  read  writ: read  writ: read  writ| read  writ: read  writ: read  =
writ|     time    =20
>   54k  153k: 300k  221k: 222k  169k|0.67  0.53 :6.97  20.4 :6.76  12.3 =
|05-04 15:28:57
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:28:58
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:28:59
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:29:00
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:29:01
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:29:02
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:29:03
>    0     0 :   0     0 :   0     0 |   0     0 :   0     0 :   0     0 =
|05-04 15:29:04^C
> root@pve-00-005:~#
>=20
> Why were there no changes?

Thanks for the above information. The result is unexpected from me. Let =
me check whether the B+tree nodes are not shrunk, this is something =
should be improved. And when the write erase time matters for write =
requests, normally it is the condition that heavy write loads coming. In =
such education, the LBA of the collected buckets might be allocated out =
very soon even before the SSD controller finishes internal write-erasure =
by the hint of discard/trim. Therefore issue discard/trim right before =
writing to this LBA doesn=E2=80=99t help on any write performance and =
involves in extra unnecessary workload into the SSD controller.

And for nowadays SATA/NVMe SSDs, with your workload described above, the =
write performance drawback can be almost ignored

>=20
>> Currently there is no such option for limit bcache=20
>> in-memory B+tree nodes cache occupation, but when I/O=20
>> load reduces, such memory consumption may drop very=20
>> fast by the reaper from system memory management=20
>> code. So it won=E2=80=99t be a problem. Bcache will try to use any=20
>> possible memory for B+tree nodes cache if it is=20
>> necessary, and throttle I/O performance to return these=20
>> memory back to memory management code when the=20
>> available system memory is low. By default, it should=20
>> work well and nothing should be done from user.
>=20
> I've been following the server's operation a lot and I've never seen =
less than 50 GB of free RAM memory. Let's see:=20
>=20
> root@pve-00-005:~# free               total        used        free    =
  shared  buff/cache   available
> Mem:       131980688    72670448    19088648       76780    40221592   =
 57335704
> Swap:              0           0           0
> root@pve-00-005:~#
>=20
> There is always plenty of free RAM, which makes me ask: Could there =
really be a problem related to a lack of RAM?

No, this is not because of insufficient memory. =46rom your information =
the memory is enough.

>=20
>> Bcache doesn=E2=80=99t issue trim request proactively.=20
>> [...]
>> In run time, bcache code only forward the trim request to backing =
device (not cache device).
>=20
> Wouldn't it be advantageous if bcache sent TRIM (discard) to the cache =
temporarily? I believe flash drives (SSD or NVMe) that need TRIM to =
maintain top performance are typically used as a cache for bcache. So, I =
think that if the TRIM command was used regularly by bcache, in the =
background (only for clean and free buckets), with a controlled =
frequency, or even if executed by a manually triggered by the user =
background task (always only for clean and free buckets), it could help =
to reduce the write latency of the cache. I believe it would help the =
writeback efficiency a lot. What do you think about this?

There was such attempt but indeed doesn=E2=80=99t help at all. The =
reason is, bcache can only know which bucket can be discarded when it is =
handled by garbage collection.=20


>=20
> Anyway, this issue of the free buckets not appearing is keeping me =
awake at night. Could it be a problem with my Kernel version (Linux =
5.15)?
>=20
> As I mentioned before, I saw in the bcache documentation =
(https://docs.kernel.org/admin-guide/bcache.html) a variable =
(freelist_percent) that was supposed to control a minimum rate of free =
buckets. Could it be a solution? I don't know. But in practice, I didn't =
find this variable in my system (could it be because of the OS version?)

Let me look into this=E2=80=A6

Thanks.

Coly Li=
