Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02A688D27
	for <lists+linux-bcache@lfdr.de>; Fri,  3 Feb 2023 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBCClr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 21:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBCClq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 21:41:46 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072F56EAF7
        for <linux-bcache@vger.kernel.org>; Thu,  2 Feb 2023 18:41:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 914F633797;
        Fri,  3 Feb 2023 02:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675392102; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxd0jf8g5GbIBP307uPVq8pnFAgDiON57FEgfngvP/w=;
        b=j5LbUR61XxF8jIu50j0mp4w5b69GF7a8Ub5wIEhYXLcSsYI+FeUL8TW6dvbwROXuHGg/z+
        jnfska2RqmVODdZwHUTY0ty59GVjwSQ5vW4WQ8u65VK5INY6CTTgSMtojjh0vlOjIXTzuR
        GCoXpWuyqrYlBQnDrqPvmLZcFayUtUI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675392102;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gxd0jf8g5GbIBP307uPVq8pnFAgDiON57FEgfngvP/w=;
        b=uD6b5uTFDA3V4W2ooE5z16rlbHVUNDlh+nstUTLgeZy9NLaG2yt1nH7WvOPRq1NSedOcho
        nJoYBV90f19yCWDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 81FD81346D;
        Fri,  3 Feb 2023 02:41:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id o/5fFGV03GNUfAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 03 Feb 2023 02:41:41 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [RFC] Live resize of backing device
From:   Coly Li <colyli@suse.de>
In-Reply-To: <3b52d311-9ab5-5fcc-3bb3-cc844caa2eb@ewheeler.net>
Date:   Fri, 3 Feb 2023 10:41:28 +0800
Cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <C491B45E-B608-4590-BB8A-D24957D4D983@suse.de>
References: <CAHykVA5sgGooeRjM1EepCCpZqkvtQJ_=cY8hmjqe0oQ3FLDFnQ@mail.gmail.com>
 <9474c19e-56f0-cb4d-68c-405c55aef281@ewheeler.net>
 <CAHykVA4zGN=WA4A3njQ3VdX4age2-AXq3EcW1qRTFbf=o1=yDw@mail.gmail.com>
 <4ddb082f-cefc-644e-2ccf-56d41207ecd3@devo.com>
 <107e8ceb-748e-b296-ae60-c2155d68352d@suse.de>
 <CAHykVA4WfYysOcKnQETkUyUjx_tFypFCWYG1RidRMVNqObGmRg@mail.gmail.com>
 <B7718488-B00D-4F72-86CA-0FF335AD633F@suse.de>
 <CAHykVA7_e1r9x2PfiDe8czH2WRaWtNxTJWcNmdyxJTSVGCxDHA@mail.gmail.com>
 <755CAB25-BC58-4100-A524-6F922E1C13DC@suse.de>
 <50e64fcd-3bd8-4175-c96e-5fa2ffe051d4@devo.com>
 <E0614C66-E18B-44F7-9E96-369BC9BD44B2@suse.de>
 <3b52d311-9ab5-5fcc-3bb3-cc844caa2eb@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B42=E6=9C=883=E6=97=A5 04:48=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, 3 Feb 2023, Coly Li wrote:
>>> 2023=E5=B9=B41=E6=9C=8827=E6=97=A5 20:44=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>>> =46rom 83f490ec8e81c840bdaf69e66021d661751975f2 Mon Sep 17 00:00:00 =
2001
>>> From: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
>>> Date: Thu, 8 Sep 2022 09:47:55 +0200
>>> Subject: [PATCH v2] bcache: Add support for live resize of backing =
devices
>>>=20
>>> Signed-off-by: Andrea Tomassetti =
<andrea.tomassetti-opensource@devo.com>
>>> ---
>>> Hi Coly,
>>> this is the second version of the patch. As you correctly pointed =
out,
>>> I implemented roll-back functionalities in case of error.
>>> I'm testing this funcionality using QEMU/KVM vm via libvirt.
>>> Here the steps:
>>> 1. make-bcache --writeback -B /dev/vdb -C /dev/vdc
>>> 2. mkfs.xfs /dev/bcache0
>>> 3. mount /dev/bcache0 /mnt
>>> 3. dd if=3D/dev/random of=3D/mnt/random0 bs=3D1M count=3D1000
>>> 4. md5sum /mnt/random0 | tee /mnt/random0.md5
>>> 5. [HOST] virsh blockresize <vm-name> --path <disk-path> --size =
<new-size>
>>> 6. xfs_growfs /dev/bcache0
>>> 6. Repeat steps 3 and 4 with a different file name (e.g. =
random1.md5)
>>> 7. umount/reboot/remount and check that the md5 hashes are correct =
with
>>>       md5sum -c /mnt/random?.md5
>>=20
>> [snipped]
>>=20
>> Hi Andrea,
>>=20
>> For the above step 5, could you provide a specific command line for =
me to reproduce?
>>=20
>> I tried to resize the disk by virsh from 400G to 800G, the disk =
resize=20
>> doesn=E2=80=99t happen online, I have to stop and restart the virtual =
machine=20
>> and see the resized disk.
>=20
> Coly,=20
>=20
> The `virsh blockresize` command only informs the vm that the size has=20=

> changed. You will need to resize the disk itself using `lvresize` or=20=

> whatever your VM's backing device is. If you're backing device for the=20=

> virtual machine is a file, then you could use `truncate -s <size>=20
> /file/path` before issuing `virsh blockresize`.
>=20
> Another possibility: are you using virtio-blk as shown in his example, =
or=20
> a different virtual driver like virtio-scsi?
>=20

Yes, it was virtio-scsi drive.


> If the VM doesn't detect it you might need to do this if its a=20
> virtio-scsi disk on the inside:
>=20
> for i in /sys/class/scsi_host/*/scan; do echo - - - > $i; done
>=20
> If you're using virtio-blk (vda) then it should be immediate.  I don't=20=

> think IDE will work at all, and not sure about nvme.

Sure, now I switch to virtio-blk drive and I can see the backing device =
size extends immediately after blockresize command in virsh.

Thanks.

Coly Li

