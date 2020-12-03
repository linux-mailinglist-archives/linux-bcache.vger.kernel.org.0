Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984D32CCF15
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 07:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgLCG0C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 3 Dec 2020 01:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgLCG0C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 3 Dec 2020 01:26:02 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091EAC061A4D;
        Wed,  2 Dec 2020 22:25:22 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id m5so536574pjv.5;
        Wed, 02 Dec 2020 22:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dF+9WErUEsZZf/F9EgKmI/B4LPzytnYTXLPFiKajYvw=;
        b=h01NwowopEJlKhteUvBFtAUACt44qR7FliwX0FDAHDGYbG4Q8IiHILTJkJPNG2Z4Bq
         /0wMlDtoa2yKmm2m3dtCA2WwNeBIrZ/k52xau1umdztFWKMggDVvvFdHAGY0NwYTNB/z
         nsyChZruVY71wCzkBrL6DBWH5K2q2BjbStwNWYEFZHVqVzGUUo1XFGXcsJmMuoAnln9C
         uSivj8lTQ+l7WbU7w4XCeQqnayRwnV7Q4fXq/KzxW+izN1q+DbMDl/MqWBwRPQeXdj38
         B24yuu+XqkLiOmALYokaslKZtfKtTq7rNEnGtMSTIcaSSPhEpijl9nISzrlvzR3SdGrC
         yKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dF+9WErUEsZZf/F9EgKmI/B4LPzytnYTXLPFiKajYvw=;
        b=pN67/TI1gg1Q0rclWU7ZZwd6Mcybl33H1rrD0bmD6c5Qym+OPG+GbewmaVT+7NqETH
         hZ1iZvX1GjcCqAgT5xP4RRADNFGXAkRlCgzQ1ePdAqopbiJOto4apahU3+ePdbAp7xrB
         h10Y2kAzSWmV3tZkWtTSll4FvJZ4gBbRVUneT9yCq/UCyPWj0mn3IDH/+FQ4b3ZaTODK
         xYwVn1zXNqA/Lsjoi54KPFvj2vlmCU7u5ZuoLGotA13zOGfIAXM3kDavLCYai8hWYChM
         nBiLJKPoQSrVUJDUhkF05mSmmoP1+UPoeH64YkOJg7+N56a2Q9sludd60l5Vme9lY8Rc
         7nUw==
X-Gm-Message-State: AOAM532WPFh3QKNkUCdLEJwznEv6o1DGeQyMpmjKgxXhO8FeZF3oNss/
        yCEoA99kcDZalCbT6SRzrvBLpbUM2oL5qUZ19lPyn0+q6dw=
X-Google-Smtp-Source: ABdhPJy+jLplZiBL8Rd8+bH246vqSSvHA/6eKKgPMc2nh2bxtxHFP9nZfiKkr31SaMKpdynfjcjIbjYMbpCaHsuC2uk=
X-Received: by 2002:a17:902:bd98:b029:d9:7b0:e1e5 with SMTP id
 q24-20020a170902bd98b02900d907b0e1e5mr1652045pls.77.1606976721366; Wed, 02
 Dec 2020 22:25:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90a:7886:0:0:0:0 with HTTP; Wed, 2 Dec 2020 22:25:20
 -0800 (PST)
In-Reply-To: <b838b790-e1e3-d644-2b1c-5de02a10669f@suse.de>
References: <20201130112137.587437-1-yili@winhong.com> <CAJfdMYDnDJXFVfEECtQ9-E4F9kfsF035PH+x3kaVn6PPSYCydA@mail.gmail.com>
 <b838b790-e1e3-d644-2b1c-5de02a10669f@suse.de>
From:   Yi Li <yilikernel@gmail.com>
Date:   Thu, 3 Dec 2020 14:25:20 +0800
Message-ID: <CAJfdMYCbkAZtWpJ6sgsrRnV4i+5sRahaq-ktMjqcG1JXoazmGQ@mail.gmail.com>
Subject: Re: [PATCH] bcache: fix panic due to cache_set is null
To:     Coly Li <colyli@suse.de>
Cc:     Yi Li <yili@winhong.com>, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guo Chao <guochao@winhong.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

> On 12/1/20 12:35 PM, Yi Li wrote:
>> sorry, This patch will cause deadlock, i will check and redo it.
>
> Can you try latest upstream kernel firstly ? Before spending more time
> on the fix.
>

This issue just happened three times =EF=BC=88xenserver7.5 dom0 kernel=EF=
=BC=89 on the
same machine and cannot reproduce it now. and have not reproduce it
using the lastest uptream kernel.

> If I remember correctly, when cancel_writeback_rate_update_dwork() is
> not timed out, the cache set memory won't be freed before the
> writeback_rate_update worker terminates. It is possible that I miss
> something in the code, but I suggest to test with a kernel after v5.3,
> and better a v5.8+ kernel.
>
> Coly Li
>
Thanks.

it is  confused that why writeback_rate_update worker run  again after
cancel_delayed_work_sync( kernel log telled).

Maybe i should dig more.

Attach some debug info as below.

Nov 30 18:00:44 host-126 kernel: [ 1697.906137] bcache:
update_writeback_rate() dc =3D ffff880818580000
Nov 30 18:00:44 host-126 kernel: [ 1697.906145] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:44 host-126 kernel: [ 1697.906148] bcache:
update_writeback_rate() dc->disk.flags =3D ffff8808185800a0
Nov 30 18:00:44 host-126 kernel: [ 1697.906150] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:45 host-126 kernel: [ 1698.578104] bcache:
update_writeback_rate() dc =3D ffff880839bd0000
Nov 30 18:00:45 host-126 kernel: [ 1698.578108] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:45 host-126 kernel: [ 1698.578109] bcache:
update_writeback_rate() dc->disk.flags =3D ffff880839bd00a0
Nov 30 18:00:45 host-126 kernel: [ 1698.578111] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:49 host-126 kernel: [ 1702.914126] bcache:
update_writeback_rate() dc =3D ffff880818580000
Nov 30 18:00:49 host-126 kernel: [ 1702.914130] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:49 host-126 kernel: [ 1702.914132] bcache:
update_writeback_rate() dc->disk.flags =3D ffff8808185800a0
Nov 30 18:00:49 host-126 kernel: [ 1702.914133] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:50 host-126 kernel: [ 1703.586182] bcache:
update_writeback_rate() dc =3D ffff880839bd0000
Nov 30 18:00:50 host-126 kernel: [ 1703.586188] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:50 host-126 kernel: [ 1703.586191] bcache:
update_writeback_rate() dc->disk.flags =3D ffff880839bd00a0
Nov 30 18:00:50 host-126 kernel: [ 1703.586193] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:54 host-126 kernel: [ 1707.922215] bcache:
update_writeback_rate() dc =3D ffff880818580000
Nov 30 18:00:54 host-126 kernel: [ 1707.922222] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:54 host-126 kernel: [ 1707.922225] bcache:
update_writeback_rate() dc->disk.flags =3D ffff8808185800a0
Nov 30 18:00:54 host-126 kernel: [ 1707.922227] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:55 host-126 kernel: [ 1708.594202] bcache:
update_writeback_rate() dc =3D ffff880839bd0000
Nov 30 18:00:55 host-126 kernel: [ 1708.594206] bcache:
update_writeback_rate() c =3D ffff8808182c0000
Nov 30 18:00:55 host-126 kernel: [ 1708.594208] bcache:
update_writeback_rate() dc->disk.flags =3D ffff880839bd00a0
Nov 30 18:00:55 host-126 kernel: [ 1708.594210] bcache:
update_writeback_rate() c->flags =3D ffff8808182c0368
Nov 30 18:00:55 host-126 kernel: [ 1709.118221] sd 0:0:1:0:
device_block, handle(0x0009)
Nov 30 18:00:58 host-126 kernel: [ 1711.368197] sd 0:0:1:0:
device_unblock and setting to running, handle(0x0009)
Nov 30 18:00:58 host-126 kernel: [ 1711.368263] sd 0:0:1:0: [sdb]
tag#0 FAILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Nov 30 18:00:58 host-126 kernel: [ 1711.368277] sd 0:0:1:0: [sdb]
tag#0 CDB: Synchronize Cache(10) 35 00 00 00 00 00 00 00 00 00
Nov 30 18:00:58 host-126 kernel: [ 1711.368289] blk_update_request:
I/O error, dev sdb, sector 36160
Nov 30 18:00:58 host-126 kernel: [ 1711.368326] bcache: error on
96083de4-6b3e-4ede-81d1-44edc1a93729: journal io error, disabling
caching
Nov 30 18:00:58 host-126 kernel: [ 1711.368372] sd 0:0:1:0: [sdb]
tag#1 FAILED Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
Nov 30 18:00:58 host-126 kernel: [ 1711.368387] sd 0:0:1:0: [sdb]
tag#1 CDB: Write(10) 2a 00 00 81 b0 40 00 00 08 00
Nov 30 18:00:58 host-126 kernel: [ 1711.368392] blk_update_request:
I/O error, dev sdb, sector 8499264
Nov 30 18:00:58 host-126 kernel: [ 1711.368407] bcache:
bch_count_io_errors() sdb2: IO error on writing data to cache.
Nov 30 18:00:58 host-126 kernel: [ 1711.368447] bcache:
bch_cached_dev_detach() bch_cached_dev_detach start
Nov 30 18:00:58 host-126 kernel: [ 1711.368458] bcache:
bch_cached_dev_detach() bch_cached_dev_detach end
Nov 30 18:00:58 host-126 kernel: [ 1711.368463] bcache:
conditional_stop_bcache_device() stop_when_cache_set_failed of bcache1
is "auto" and cache is dirty, stop it to avoid potential data
corruption.
Nov 30 18:00:58 host-126 kernel: [ 1711.368466] bcache:
bch_cached_dev_detach() bch_cached_dev_detach start
Nov 30 18:00:58 host-126 kernel: [ 1711.368474] bcache:
bch_cached_dev_detach() bch_cached_dev_detach end
Nov 30 18:00:58 host-126 kernel: [ 1711.368479] bcache:
conditional_stop_bcache_device() stop_when_cache_set_failed of bcache0
is "auto" and cache is clean, keep it alive.
Nov 30 18:00:58 host-126 kernel: [ 1711.368494] Buffer I/O error on
dev bcache1, logical block 210979209, lost async page write
Nov 30 18:00:58 host-126 kernel: [ 1711.368585] bcache:
cached_dev_detach_finish() cached_dev_detach_finish start
Nov 30 18:00:58 host-126 kernel: [ 1711.368589] bcache:
cached_dev_detach_finish() dc->disk.flags =3D f
Nov 30 18:00:58 host-126 kernel: [ 1711.368591] bcache:
cancel_writeback_rate_update_dwork()
cancel_writeback_rate_update_dwork start
Nov 30 18:00:58 host-126 kernel: [ 1711.368594] bcache:
cancel_writeback_rate_update_dwork()
cancel_writeback_rate_update_dwork end
Nov 30 18:00:58 host-126 kernel: [ 1711.368617] bcache:
cached_dev_detach_finish() cached_dev_detach_finish start
Nov 30 18:00:58 host-126 kernel: [ 1711.369022] bcache:
cached_dev_detach_finish() Caching disabled for sda2
Nov 30 18:00:58 host-126 kernel: [ 1711.369025] bcache:
cached_dev_detach_finish() cached_dev_detach_finish end
Nov 30 18:00:58 host-126 kernel: [ 1711.369035] bcache:
cached_dev_detach_finish() dc->disk.flags =3D a
Nov 30 18:00:58 host-126 kernel: [ 1711.369039] bcache:
cancel_writeback_rate_update_dwork()
cancel_writeback_rate_update_dwork start
Nov 30 18:00:58 host-126 kernel: [ 1711.369042] bcache:
cancel_writeback_rate_update_dwork()
cancel_writeback_rate_update_dwork end
Nov 30 18:00:58 host-126 kernel: [ 1711.369460] bcache:
cached_dev_detach_finish() Caching disabled for sdf2
Nov 30 18:00:58 host-126 kernel: [ 1711.369464] bcache:
cached_dev_detach_finish() cached_dev_detach_finish end
Nov 30 18:00:58 host-126 kernel: [ 1711.374327] sd 0:0:1:0: [sdb]
Synchronizing SCSI cache
Nov 30 18:00:58 host-126 kernel: [ 1711.374516] sd 0:0:1:0: [sdb]
Synchronize Cache(10) failed: Result: hostbyte=3DDID_NO_CONNECT
driverbyte=3DDRIVER_OK
Nov 30 18:00:58 host-126 kernel: [ 1711.376907] bcache:
cache_set_free() Cache set 96083de4-6b3e-4ede-81d1-44edc1a93729
unregistered
Nov 30 18:00:58 host-126 kernel: [ 1711.418979] mpt3sas_cm0: removing
handle(0x0009), sas_addr(0x4433221102000000)
Nov 30 18:00:58 host-126 kernel: [ 1711.418984] mpt3sas_cm0: removing
:enclosure logical id(0x5a4bf013514f4000), slot(4)
Nov 30 18:00:58 host-126 kernel: [ 1711.418988] mpt3sas_cm0: removing
:enclosure level(0x0000), connector name(     )
Nov 30 18:01:05 host-126 kernel: [ 1718.873725] bcache:
cached_dev_free() cached_dev_free start
Nov 30 18:01:05 host-126 kernel: [ 1718.873776] bcache:
bcache_device_free() bcache1 stopped
Nov 30 18:01:05 host-126 kernel: [ 1718.926598] bcache:
cached_dev_free() cached_dev_free end
Nov 30 18:01:06 host-126 kernel: [ 1719.668540]  sda: sda1 sda2
Nov 30 18:01:11 host-126 kernel: [ 1725.010305] bcache:
update_writeback_rate() dc =3D ffff880818580000
Nov 30 18:01:11 host-126 kernel: [ 1725.010309] bcache:
update_writeback_rate() c =3D           (null)
------------the kernel log show that cache_set is null.
Nov 30 18:01:11 host-126 kernel: [ 1725.010311] bcache:
update_writeback_rate() dc->disk.flags =3D ffff8808185800a0
Nov 30 18:01:12 host-126 kernel: [ 1725.369791] mpt3sas_cm0:
detecting: handle(0x0009), sas_address(0x4433221102000000), phy(2)
Nov 30 18:01:12 host-126 kernel: [ 1725.369802] mpt3sas_cm0:
REPORT_LUNS: handle(0x0009), retries(0)
Nov 30 18:01:12 host-126 kernel: [ 1725.618138] mpt3sas_cm0:
TEST_UNIT_READY: handle(0x0009), lun(0)
Nov 30 18:01:13 host-126 kernel: [ 1726.619148] mpt3sas_cm0:
detecting: handle(0x0009), sas_address(0x4433221102000000), phy(2)
Nov 30 18:01:13 host-126 kernel: [ 1726.619156] mpt3sas_cm0:
REPORT_LUNS: handle(0x0009), retries(0)
Nov 30 18:01:13 host-126 kernel: [ 1726.619300] mpt3sas_cm0:
TEST_UNIT_READY: handle(0x0009), lun(0)
Nov 30 18:01:13 host-126 kernel: [ 1726.622323] scsi 0:0:6:0:
Direct-Access     ATA      INTEL SSDSC2BB48 0112 PQ: 0 ANSI: 6
Nov 30 18:01:13 host-126 kernel: [ 1726.622839] scsi 0:0:6:0: SATA:
handle(0x0009), sas_addr(0x4433221102000000), phy(2),
device_name(0x55cd2e414d6dcd4b)
Nov 30 18:01:13 host-126 kernel: [ 1726.622845] scsi 0:0:6:0: SATA:
enclosure logical id(0x5a4bf013514f4000), slot(4)
Nov 30 18:01:13 host-126 kernel: [ 1726.622847] scsi 0:0:6:0: SATA:
enclosure level(0x0000), connector name(     )
Nov 30 18:01:13 host-126 kernel: [ 1726.622990] scsi 0:0:6:0:
atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Nov 30 18:01:13 host-126 kernel: [ 1726.623642] scsi 0:0:6:0:
serial_number(PHDV7102003Q480BGN  )
Nov 30 18:01:13 host-126 kernel: [ 1726.626116] sd 0:0:6:0: Attached
scsi generic sg1 type 0
Nov 30 18:01:13 host-126 kernel: [ 1726.626784] sd 0:0:6:0: [sdb]
937703088 512-byte logical blocks: (480 GB/447 GiB)
Nov 30 18:01:13 host-126 kernel: [ 1726.626789] sd 0:0:6:0: [sdb]
4096-byte physical blocks
Nov 30 18:01:13 host-126 kernel: [ 1726.631161] sd 0:0:6:0: [sdb]
Write Protect is off
Nov 30 18:01:13 host-126 kernel: [ 1726.631165] sd 0:0:6:0: [sdb] Mode
Sense: 9b 00 10 08
Nov 30 18:01:13 host-126 kernel: [ 1726.632513] sd 0:0:6:0: [sdb]
Write cache: enabled, read cache: enabled, supports DPO and FUA
Nov 30 18:01:13 host-126 kernel: [ 1726.648068]  sdb: sdb1 sdb2
Nov 30 18:01:13 host-126 kernel: [ 1726.656841] sd 0:0:6:0: [sdb]
Attached SCSI disk

>>
>> On 11/30/20, Yi Li <yili@winhong.com> wrote:
>>> bcache_device_detach will release the cache_set after hotunplug cache
>>> disk. update_writeback_rate should check validate of cache_set.
>>>
>>>   IP: [<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0 [bcache]
>>>   PGD 879620067 PUD 8755d3067 PMD 0
>>>   Oops: 0000 [#1] SMP
>>>   CPU: 8 PID: 1005702 Comm: kworker/8:0 Tainted: G 4.4.0+10 #1
>>>   Hardware name: Intel BIOS SE5C610.86B.01.01.0021.032120170601
>>> 03/21/2017
>>>   Workqueue: events update_writeback_rate [bcache]
>>>   task: ffff8808786f3800 ti: ffff88077082c000 task.ti: ffff88077082c000
>>>   RIP: e030:[<ffffffffa03730c9>] update_writeback_rate+0x59/0x3a0
>>> [bcache]
>>>   RSP: e02b:ffff88077082fde0  EFLAGS: 00010202
>>>   RAX: 0000000000000018 RBX: ffff8808047f0b08 RCX: 0000000000000000
>>>   RDX: 0000000000000001 RSI: ffff88088170dab8 RDI: ffff88088170dab8
>>>   RBP: ffff88077082fe18 R08: 000000000000000a R09: 0000000000000000
>>>   R10: 0000000000000000 R11: 0000000000017bc8 R12: 0000000000000000
>>>   R13: ffff8808047f0000 R14: 0000000000000200 R15: ffff8808047f0b08
>>>   FS:  00007f157b6d6700(0000) GS:ffff880881700000(0000)
>>> knlGS:0000000000000000
>>>   CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>   CR2: 0000000000000368 CR3: 0000000875c05000 CR4: 0000000000040660
>>>   Stack:
>>>    0000000000000001 0000000000007ff0 ffff88085ff600c0 ffff880881714e80
>>>    ffff880881719500 0000000000000200 ffff8808047f0b08 ffff88077082fe60
>>>    ffffffff81088c0c 0000000081714e80 0000000000000000 ffff880881714e80
>>>   Call Trace:
>>>    [<ffffffff81088c0c>] process_one_work+0x1fc/0x3b0
>>>    [<ffffffff81089575>] worker_thread+0x2a5/0x470
>>>    [<ffffffff815a2f58>] ? __schedule+0x648/0x870
>>>    [<ffffffff810892d0>] ? rescuer_thread+0x300/0x300
>>>    [<ffffffff8108e3d5>] kthread+0xd5/0xe0
>>>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>>>    [<ffffffff815a704f>] ret_from_fork+0x3f/0x70
>>>    [<ffffffff8108e300>] ? kthread_stop+0x110/0x110
>>>
>>> Reported-by: Guo Chao <guochao@winhong.com>
>>> Signed-off-by: Guo Chao <guochao@winhong.com>
>>> Signed-off-by: Yi Li <yili@winhong.com>
>>> ---
>>>  drivers/md/bcache/writeback.c | 12 +++++++++++-
>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/bcache/writeback.c
>>> b/drivers/md/bcache/writeback.c
>>> index 3c74996978da..186c4c6e1607 100644
>>> --- a/drivers/md/bcache/writeback.c
>>> +++ b/drivers/md/bcache/writeback.c
>>> @@ -175,7 +175,15 @@ static void update_writeback_rate(struct
>>> work_struct
>>> *work)
>>>  	struct cached_dev *dc =3D container_of(to_delayed_work(work),
>>>  					     struct cached_dev,
>>>  					     writeback_rate_update);
>>> -	struct cache_set *c =3D dc->disk.c;
>>> +	struct cache_set *c =3D NULL;
>>> +
>>> +	mutex_lock(&bch_register_lock);
>>> +	c =3D dc->disk.c;
>>> +
>>> +	if (c =3D=3D NULL) {
>>> +		mutex_unlock(&bch_register_lock);
>>> +		return;
>>> +	}
>>>
>>>  	/*
>>>  	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
>>> @@ -194,6 +202,7 @@ static void update_writeback_rate(struct work_struc=
t
>>> *work)
>>>  		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>>  		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>>>  		smp_mb__after_atomic();
>>> +		mutex_unlock(&bch_register_lock);
>>>  		return;
>>>  	}
>>>
>>> @@ -230,6 +239,7 @@ static void update_writeback_rate(struct work_struc=
t
>>> *work)
>>>  	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>>>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
>>>  	smp_mb__after_atomic();
>>> +	mutex_unlock(&bch_register_lock);
>>>  }
>>>
>>>  static unsigned int writeback_delay(struct cached_dev *dc,
>>> --
>>> 2.25.3
>>>
>>>
>>>
>>>
>
>
