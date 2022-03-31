Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0D84EDEE5
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Mar 2022 18:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbiCaQgw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 31 Mar 2022 12:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240022AbiCaQgv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 31 Mar 2022 12:36:51 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850411BBF62;
        Thu, 31 Mar 2022 09:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648744503; x=1680280503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vcu31rMS0yn2EqzHi27wb6PxKwLH34tTd/+ys8ECp/A=;
  b=ADDuc88FzNWZGKBrIk06zzzX+k6YSxqk27uWQNihSUCGuZ1GtMpxcMlV
   xTEWa75dpfcsFQw+mC064HKR7W4MWXLYRVTC8926TBwzR2AQWBCbndTjo
   VEkv7SFykl4Py4aMRGoIAena380+aMTSMqaNCRjn7CsXqgUcJlMFOvVOW
   g=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 31 Mar 2022 09:35:03 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 09:35:02 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 31 Mar 2022 09:35:02 -0700
Received: from qian (10.80.80.8) by nalasex01a.na.qualcomm.com (10.47.209.196)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 31 Mar
 2022 09:34:58 -0700
Date:   Thu, 31 Mar 2022 12:34:56 -0400
From:   Qian Cai <quic_qiancai@quicinc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "David Sterba" <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        <linux-block@vger.kernel.org>, <dm-devel@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-bcache@vger.kernel.org>,
        <linux-raid@vger.kernel.org>, <target-devel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: cleanup bio_kmalloc v2
Message-ID: <YkXYMGGbk/ZTbGaA@qian>
References: <20220308061551.737853-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220308061551.737853-1-hch@lst.de>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Mar 08, 2022 at 07:15:46AM +0100, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series finishes off the bio allocation interface cleanups by dealing
> with the weirdest member of the famility.  bio_kmalloc combines a kmalloc
> for the bio and bio_vecs with a hidden bio_init call and magic cleanup
> semantics.
> 
> This series moves a few callers away from bio_kmalloc and then turns
> bio_kmalloc into a simple wrapper for a slab allocation of a bio and the
> inline biovecs.  The callers need to manually call bio_init instead with
> all that entails and the magic that turns bio_put into a kfree goes away
> as well, allowing for a proper debug check in bio_put that catches
> accidental use on a bio_init()ed bio.

Reverting this series fixed boot crashes.

 WARNING: CPU: 1 PID: 2622 at block/bio.c:229 bio_free
 Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce drm_ttm_helper mlx5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas xhci_pci nvme_core raid_class drm xhci_pci_renesas
 CPU: 1 PID: 2622 Comm: mount Not tainted 5.17.0-next-20220331 #50
 pstate: 10400009 (nzcV daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : bio_free
 lr : bio_put
 sp : ffff8000371b7760
 x29: ffff8000371b7760 x28: 0000000000000000 x27: dfff800000000000
 x26: ffff08028f93a600 x25: 0000000000000000 x24: ffff08028f92f600
 x23: 1ffff00006e36f10 x22: ffff08028fa18510 x21: 1fffe10051f430a2
 x20: 0000000000000000 x19: ffff08028fa18500 x18: ffffde03db3e7d2c
 x17: ffffde03d55f8bc4 x16: 1fffe10051e75129 x15: 1fffe106cfcfbb46
 x14: 1fffe10051e7511c x13: 0000000000000004 x12: ffff700006e36eab
 x11: 1ffff00006e36eaa x10: ffff700006e36eaa x9 : ffffde03d5cb9fec
 x8 : ffff8000371b7557 x7 : 0000000000000001 x6 : ffff700006e36eaa
 x5 : 1ffff00006e36ea9 x4 : 1ffff00006e36ebe x3 : 1fffe10051f430a2
 x2 : 1fffe10051f430ae x1 : 0000000000000000 x0 : ffff08028fa18570
 Call trace:
  bio_free
  bio_put
  squashfs_read_data
  squashfs_read_table
  squashfs_fill_super
  get_tree_bdev
  squashfs_get_tree
  vfs_get_tree
  do_new_mount
  path_mount
  __arm64_sys_mount
  invoke_syscall
  el0_svc_common.constprop.0
  do_el0_svc
  el0_svc
  el0t_64_sync_handler
  el0t_64_sync
 irq event stamp: 33146
 hardirqs last  enabled at (33145):  free_unref_page
 hardirqs last disabled at (33146):  el1_dbg
 softirqs last  enabled at (33122):  __do_softirq
 softirqs last disabled at (33111):  __irq_exit_rcu
 ---[ end trace 0000000000000000 ]---
 Unable to handle kernel paging request at virtual address dfff800000000001
 KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
 Mem abort info:
   ESR = 0x96000004
   EC = 0x25: DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
   FSC = 0x04: level 0 translation fault
 Data abort info:
   ISV = 0, ISS = 0x00000004
   CM = 0, WnR = 0
 [dfff800000000001] address between user and kernel address ranges
 Internal error: Oops: 96000004 [#1] PREEMPT SMP
 Modules linked in: cdc_ether usbnet ipmi_devintf ipmi_msghandler cppc_cpufreq fuse ip_tables x_tables ipv6 btrfs blake2b_generic libcrc32c xor xor_neon raid6_pq zstd_compress dm_mod nouveau crct10dif_ce
drm_ttm_helper mlx5_core ttm drm_dp_helper drm_kms_helper nvme mpt3sas xhci_pci nvme_core raid_class drm xhci_pci_renesas
 CPU: 1 PID: 2622 Comm: mount Tainted: G        W         5.17.0-next-20220331 #50
 pc : bio_free
 lr : bio_free
 sp : ffff8000371b7760
 x29: ffff8000371b7760 x28: 0000000000000000 x27: dfff800000000000
 x26: ffff08028f93a600 x25: 0000000000000000 x24: ffff08028f92f600
 x23: 1ffff00006e36f10 x22: ffff08028fa18548 x21: 00000000000000d0
 x20: 0000000000000000 x19: ffff08028fa18500 x18: ffffde03db3e7d2c
 x17: ffffde03d55f8bc4 x16: 1fffe10051e75129 x15: 1fffe106cfcfbb46
 x14: 1fffe10051e7511c x13: 0000000000000004 x12: ffff700006e36eab
 x11: 1ffff00006e36eaa x10: ffff700006e36eaa x9 : ffffde03d5cb9c78
 x8 : ffff8000371b7557 x7 : 0000000000000001 x6 : ffff700006e36eaa
 x5 : 1ffff00006e36ea9 x4 : 1fffe10051f430ac x3 : 0000000000000001
 x2 : 0000000000000003 x1 : dfff800000000000 x0 : 0000000000000008
 Call trace:
  bio_free
  bio_put
  squashfs_read_data
  squashfs_read_table
  squashfs_fill_super
  get_tree_bdev
  squashfs_get_tree
  vfs_get_tree
  do_new_mount
  path_mount
  __arm64_sys_mount
  invoke_syscall
  el0_svc_common.constprop.0
  do_el0_svc
  el0_svc
  el0t_64_sync_handler
  el0t_64_sync
 Code: d2d00001 f2fbffe1 52800062 d343fc03 (38e16861)
 ---[ end trace 0000000000000000 ]---
 SMP: stopping secondary CPUs
 Kernel Offset: 0x5e03ccd70000 from 0xffff800008000000
 PHYS_OFFSET: 0x80000000
 CPU features: 0x000,00085c0d,19801c82
 Memory Limit: none
 ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---
> 
> Changes since v1:
>  - update a pre-existing comment per maintainer suggestion
> 
> Diffstat:
>  block/bio.c                        |   47 ++++++++++++++-----------------------
>  block/blk-crypto-fallback.c        |   14 ++++++-----
>  block/blk-map.c                    |   42 +++++++++++++++++++++------------
>  drivers/block/pktcdvd.c            |   34 +++++++++++---------------
>  drivers/md/bcache/debug.c          |   10 ++++---
>  drivers/md/dm-bufio.c              |    9 +++----
>  drivers/md/raid1.c                 |   12 ++++++---
>  drivers/md/raid10.c                |   21 +++++++++++-----
>  drivers/target/target_core_pscsi.c |   36 ++++------------------------
>  fs/btrfs/disk-io.c                 |    8 +++---
>  fs/btrfs/volumes.c                 |   11 --------
>  fs/btrfs/volumes.h                 |    2 -
>  fs/squashfs/block.c                |   14 +++--------
>  include/linux/bio.h                |    2 -
>  14 files changed, 116 insertions(+), 146 deletions(-)
