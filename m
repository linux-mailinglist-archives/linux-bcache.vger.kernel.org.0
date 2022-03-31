Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3B34EE333
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Mar 2022 23:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbiCaVUC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 31 Mar 2022 17:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiCaVUB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 31 Mar 2022 17:20:01 -0400
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ADC23587B
        for <linux-bcache@vger.kernel.org>; Thu, 31 Mar 2022 14:18:11 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20220331211806euoutp022aadaa62758a4e897882cd11c129da2f~hk9Yhw-rf3022830228euoutp02a
        for <linux-bcache@vger.kernel.org>; Thu, 31 Mar 2022 21:18:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220331211806euoutp022aadaa62758a4e897882cd11c129da2f~hk9Yhw-rf3022830228euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648761486;
        bh=DM0rhvB2GhxeOPQPo/EjMS38q+Iw5NVWfPDrrASpcb4=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=ja/zMyMDE2hI5nWK1cSG+xVwKDnHdB3TJJsbdYWzaeuSimQ3m9JkMJrhhXkbmjFkz
         e2f0Sj3aKvgroxwesW/XSvOFwyXkOAq15i5RcLlHfNSmVWPBiN0QVU0vJC2kkc8Ck/
         rErf/8S9OuUhBowX3M73oJFu2oPgR/2m7MXkX2ic=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220331211805eucas1p2a8a5006c03c42a203bd56896dafbf5b4~hk9Xbop573192531925eucas1p2Z;
        Thu, 31 Mar 2022 21:18:05 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id ED.B2.09887.D8A16426; Thu, 31
        Mar 2022 22:18:05 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42~hk9WlERhz0832008320eucas1p2F;
        Thu, 31 Mar 2022 21:18:04 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220331211804eusmtrp20190ecaa189b027a004cf7cf2b9bcc1b~hk9WkFQiu0959209592eusmtrp2E;
        Thu, 31 Mar 2022 21:18:04 +0000 (GMT)
X-AuditID: cbfec7f4-471ff7000000269f-d8-62461a8d2ebf
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7F.43.09404.C8A16426; Thu, 31
        Mar 2022 22:18:04 +0100 (BST)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220331211803eusmtip1a9ccf738d9b7d324aba71fa048d24a9b~hk9VwfLgt1478114781eusmtip1M;
        Thu, 31 Mar 2022 21:18:03 +0000 (GMT)
Message-ID: <6696cc6a-3e3f-035e-5b8c-05ea361383f3@samsung.com>
Date:   Thu, 31 Mar 2022 23:18:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
        Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 4/5] block: turn bio_kmalloc into a simple kmalloc
 wrapper
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
From:   Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20220308061551.737853-5-hch@lst.de>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDKsWRmVeSWpSXmKPExsWy7djP87q9Um5JBg838VmsvtvPZjG98Ty7
        xd53s1ktLvxoZLJYufook8Wfh4YWx7ZdY7LYe0vb4tLjFewWl3fNYbNon7+L0WL58X9MFkd7
        NrNZtG38ymhxfPlfNovWpW+ZHAQ8Lp8t9di0qpPNY/fNBjaPj09vsXi833eVzWPK1+fMHuu3
        XGXx2Hy62mPC5o2sHp83yQVwRXHZpKTmZJalFunbJXBlbJ49m7WgRadi6/J57A2Me1W6GDk5
        JARMJJ7M3MEKYgsJrGCU2PvcuIuRC8j+wigx7/MeRgjnM6PE15P/WGE6Dt/6wwaRWM4o8X3P
        ShYI5yOjRHfDIaAMBwevgJ3E5WteIA0sAqoSbbO/MYPYvAKCEidnPmEBsUUFkiRWb18NVi4s
        ECAxb7cVSJhZQFzi1pP5TCC2iICDxOwNS8F2MQucZ5bY/OUOI0iCTcBQouttFxuIzQlk93y4
        wQbRLC/RvHU2M0iDhMBuTom5R98wQ1ztIvF+51yoD4QlXh3fwg5hy0j83wmyjQPIzpf4O8MY
        Ilwhce31GqhWa4k7536B3cksoCmxfpc+RNhR4mnjVjaITj6JG28FIS7gk5i0bTozRJhXoqNN
        CKJaTWLW8XVwOw9euMQ8gVFpFlKYzELy/Cwkv8xC2LuAkWUVo3hqaXFuemqxUV5quV5xYm5x
        aV66XnJ+7iZGYAI8/e/4lx2My1991DvEyMTBeIhRgoNZSYT3aqxrkhBvSmJlVWpRfnxRaU5q
        8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZJg5OqQam9Iw27xM7eus6sqM4NSetOn73XsrL
        jPMnXyb/25a38anntEliL28rGemdCC07nuipf7QuN+/oBW22L9+eTZZfcG5mTrnk7Q72WnO+
        mUKFm+PTBCeFT1KTf74wL9moLzp9cSzn5QoLltvLP6hfttnq/alz0tZvTAoy9ZPEpy04fOpk
        nV6O3SPPe4zXdky93GDzZnbIs5xFN047H+XrnbBIzE1S8kzJqtMfzni+qbK6XSi5eqbWyQTj
        X5IrpHYqXOdjNPokXrY1jeH5h2L74oNOWo5uyneOG6952ts6M80pIFdtZVvN7x+v/7ELZyqV
        KvM9u8k44+XZYvU98ydVXdjHf/SzgKKv8LkIZck1n6WLlViKMxINtZiLihMBeBXxdu8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t/xu7o9Um5JBic+C1usvtvPZjG98Ty7
        xd53s1ktLvxoZLJYufook8Wfh4YWx7ZdY7LYe0vb4tLjFewWl3fNYbNon7+L0WL58X9MFkd7
        NrNZtG38ymhxfPlfNovWpW+ZHAQ8Lp8t9di0qpPNY/fNBjaPj09vsXi833eVzWPK1+fMHuu3
        XGXx2Hy62mPC5o2sHp83yQVwRenZFOWXlqQqZOQXl9gqRRtaGOkZWlroGZlY6hkam8daGZkq
        6dvZpKTmZJalFunbJehlbJ49m7WgRadi6/J57A2Me1W6GDk5JARMJA7f+sPWxcjFISSwlFHi
        5IedbBAJGYmT0xpYIWxhiT/XusDiQgLvGSUO3HLqYuTg4BWwk7h8zQskzCKgKtE2+xsziM0r
        IChxcuYTFhBbVCBJ4lJXOyOILSzgJ3Hh4gawMcwC4hK3nsxnArFFBBwkZm9YCnYDs8BFZon3
        h6czQuwKl7h3pQlsKJuAoUTXW4gbOIHsng83oAaZSXRt7WKEsOUlmrfOZp7AKDQLyR2zkOyb
        haRlFpKWBYwsqxhFUkuLc9Nzi430ihNzi0vz0vWS83M3MQLjftuxn1t2MK589VHvECMTB+Mh
        RgkOZiUR3quxrklCvCmJlVWpRfnxRaU5qcWHGE2BgTGRWUo0OR+YePJK4g3NDEwNTcwsDUwt
        zYyVxHk9CzoShQTSE0tSs1NTC1KLYPqYODilGpg04u5N1BdXFt3TNvtertcEwbUOK+pNbVMC
        0yqWC3NGHL6966WrV+5xzZjP55NOVL94uu/z3qqNTW36Ho7qbw15BLI+aAUd5d3MF6U0Jf10
        dOnCFx/XGnBld5xX57Dpa63Zmtxh4OjAVvLtxdmZt/ZJehVfOiZ2ZQ7P46oNwQ+iCzrclMvC
        tjdpTfrh6Thd9dS9BLs3GnxTF1T2fF0UaXMlrGqJq8ipS8/teWdEFh/v1fX21Mq7lqgipa35
        hVHyjf7D9SEfjtWubUxJrXohsy5CaavqvuOZ8qa/lzRf//jxlfZMhm23nU/5as3c5NO+t3AV
        87slnskMM2TlfvcdFQn2LnwWfz8/OJbrntDORCWW4oxEQy3mouJEAFsaRTyEAwAA
X-CMS-MailID: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42
References: <20220308061551.737853-1-hch@lst.de>
        <20220308061551.737853-5-hch@lst.de>
        <CGME20220331211804eucas1p28da21f2dfd57aa490abffb8f87417f42@eucas1p2.samsung.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Christoph,

On 08.03.2022 07:15, Christoph Hellwig wrote:
> Remove the magic autofree semantics and require the callers to explicitly
> call bio_init to initialize the bio.
>
> This allows bio_free to catch accidental bio_put calls on bio_init()ed
> bios as well.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This patch, which landed in today's next-20220331 as commit 57c47b42f454 
("block: turn bio_kmalloc into a simple kmalloc wrapper"), breaks badly 
all my test systems, which use squashfs initrd:

RAMDISK: squashfs filesystem found at block 0
RAMDISK: Loading 2489KiB [1 disk] into ram disk... done.
using deprecated initrd support, will be removed in 2021.
------------[ cut here ]------------
WARNING: CPU: 4 PID: 1 at block/bio.c:229 bio_free+0x6c/0x70
Modules linked in:
CPU: 4 PID: 1 Comm: swapper/0 Not tainted 5.17.0-next-20220331 #4767
Hardware name: Samsung Exynos (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x58/0x70
  dump_stack_lvl from __warn+0xc8/0x218
  __warn from warn_slowpath_fmt+0x5c/0xb4
  warn_slowpath_fmt from bio_free+0x6c/0x70
  bio_free from squashfs_read_data+0x118/0x748
  squashfs_read_data from squashfs_read_table+0xdc/0x144
  squashfs_read_table from squashfs_fill_super+0x100/0x9ec
  squashfs_fill_super from get_tree_bdev+0x154/0x248
  get_tree_bdev from vfs_get_tree+0x24/0xe4
  vfs_get_tree from path_mount+0x3d0/0xb14
  path_mount from init_mount+0x54/0x80
  init_mount from do_mount_root+0x78/0x104
  do_mount_root from mount_block_root+0xf0/0x1fc
  mount_block_root from initrd_load+0xec/0x294
  initrd_load from prepare_namespace+0xdc/0x18c
  prepare_namespace from kernel_init+0x18/0x12c
  kernel_init from ret_from_fork+0x14/0x2c
Exception stack(0xf0835fb0 to 0xf0835ff8)
...
irq event stamp: 398271
hardirqs last  enabled at (398279): [<c019c984>] __up_console_sem+0x50/0x60
hardirqs last disabled at (398338): [<c019c970>] __up_console_sem+0x3c/0x60
softirqs last  enabled at (398352): [<c0101680>] __do_softirq+0x348/0x610
softirqs last disabled at (398347): [<c012f048>] __irq_exit_rcu+0x144/0x1ec
---[ end trace 0000000000000000 ]---
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000004
[00000004] *pgd=00000000
Internal error: Oops: 5 [#1] PREEMPT SMP ARM
Modules linked in:
CPU: 4 PID: 1 Comm: swapper/0 Tainted: G        W 5.17.0-next-20220331 #4767
Hardware name: Samsung Exynos (Flattened Device Tree)
PC is at bio_free+0x24/0x70
LR is at bio_free+0x24/0x70
pc : [<c0502d28>]    lr : [<c0502d28>]    psr: 80000113
sp : f0835cf0  ip : 00000000  fp : c28cae80
r10: ef0a95c0  r9 : c2805cc0  r8 : 00000060
r7 : 00000060  r6 : 00000060  r5 : 00000000  r4 : c2804a80
r3 : c2804ac8  r2 : 00000001  r1 : c2804ac8  r0 : 00000074
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
Control: 10c5387d  Table: 4000406a  DAC: 00000051
Register r0 information: non-paged memory
Register r1 information: slab kmalloc-128 start c2804a80 pointer offset 
72 size 128
Register r2 information: non-paged memory
Register r3 information: slab kmalloc-128 start c2804a80 pointer offset 
72 size 128
Register r4 information: slab kmalloc-128 start c2804a80 pointer offset 
0 size 128
Register r5 information: NULL pointer
Register r6 information: non-paged memory
Register r7 information: non-paged memory
Register r8 information: non-paged memory
Register r9 information: slab kmalloc-192 start c2805cc0 pointer offset 
0 size 192
Register r10 information: non-slab/vmalloc memory
Register r11 information: slab kmalloc-64 start c28cae80 pointer offset 
0 size 64
Register r12 information: NULL pointer
Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
Stack: (0xf0835cf0 to 0xf0836000)
...
  bio_free from squashfs_read_data+0x118/0x748
  squashfs_read_data from squashfs_read_table+0xdc/0x144
  squashfs_read_table from squashfs_fill_super+0x100/0x9ec
  squashfs_fill_super from get_tree_bdev+0x154/0x248
  get_tree_bdev from vfs_get_tree+0x24/0xe4
  vfs_get_tree from path_mount+0x3d0/0xb14
  path_mount from init_mount+0x54/0x80
  init_mount from do_mount_root+0x78/0x104
  do_mount_root from mount_block_root+0xf0/0x1fc
  mount_block_root from initrd_load+0xec/0x294
  initrd_load from prepare_namespace+0xdc/0x18c
  prepare_namespace from kernel_init+0x18/0x12c
  kernel_init from ret_from_fork+0x14/0x2c
Exception stack(0xf0835fb0 to 0xf0835ff8)
...
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Reverting it on top of linux next-20220331 (together with commit 
1292fb59f283 ("pktcdvd: stop using bio_reset")) fixes (or hides?) the issue.

> ---
>   block/bio.c                        | 47 ++++++++++++------------------
>   block/blk-crypto-fallback.c        | 14 +++++----
>   block/blk-map.c                    | 42 ++++++++++++++++----------
>   drivers/block/pktcdvd.c            | 25 ++++++++--------
>   drivers/md/bcache/debug.c          | 10 ++++---
>   drivers/md/dm-bufio.c              |  9 +++---
>   drivers/md/raid1.c                 | 12 +++++---
>   drivers/md/raid10.c                | 21 ++++++++-----
>   drivers/target/target_core_pscsi.c | 10 +++----
>   fs/squashfs/block.c                |  9 +++---
>   include/linux/bio.h                |  2 +-
>   11 files changed, 108 insertions(+), 93 deletions(-)

 > [...]

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

