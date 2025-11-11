Return-Path: <linux-bcache+bounces-1241-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA9F9C4E3E5
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 14:51:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34DB6189880B
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 13:49:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB45D32824A;
	Tue, 11 Nov 2025 13:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="oF0nKDKN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-14.ptr.blmpb.com (sg-1-14.ptr.blmpb.com [118.26.132.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFAA17B50A
	for <linux-bcache@vger.kernel.org>; Tue, 11 Nov 2025 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762868948; cv=none; b=bX1IUUj/FxY8yVFlxpHEoyI9n018/qUwSAe0ciT5VVqmt+Mi9niyu558strMv7+EVKQ/Qofsvq3AzBgMVDoLp1HNitjkdygZF18hPVwU8VytXGX/CnZXDNBmv6sO1j4VUsBGnzz33jDIMbJQkhLMyliCMEpTEGow3hOnIUFtnOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762868948; c=relaxed/simple;
	bh=GTZ845BDJzFILrNgoVqXSNgKYtU0vrBWnYPLjL/kGsU=;
	h=To:Cc:Message-Id:Content-Disposition:Subject:Content-Type:
	 References:Date:From:Mime-Version:In-Reply-To; b=Lcro+yDs3TS0xQOcv26tYtx5gDDfJt65KNzE0lQwF8ExQhmB+mv5sAZuhC5/XVeDNQTAvow+9I1uUlMb20HHn20F0w40y9ljAkwHCu58gvEaV58UeZMF5YhoofGiMUzZTXAd5wDgSyuxABtby/+WHvmSFsWAKBOkZaMRgJXWMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=oF0nKDKN; arc=none smtp.client-ip=118.26.132.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762868939;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CCDxGbhhW/RGYf36zB7bjoSJcysDLeg2T4UB47+M/XQ=;
 b=oF0nKDKNaNcBhcxTtQOon31SO8gzULtvzxKDKiburKRq3guNyoHqcrfNFTKAsihFHWcyL6
 Xy+MYJj1TiEw0m8FOh7zOZBWr8Ph9IgN7sszeCRgFv1RgRJm1lNhWLa9hGxsKtYXdwnc0A
 4EtXYfTnFzqBEv0FvAz/VzB8ye6fHxpOAW/8e6hKWoLI9zf7TashxsQDKyFvo4iB2eqJIP
 FB7uVXb0Sg3Fza/JLsesKBzTbkVcJ8wMYFocdtRRjREYu/+ue5F05sTZE2kKewDv78NF5L
 STDjo3UJZ8l8ClzopT2avd0q+htNxwXOrsZU9yL5eZJ1KbaA1crFRps2rznfNg==
To: "liequan che" <liequanche@gmail.com>
Cc: "Kent Overstreet" <kent.overstreet@gmail.com>, 
	"linux-bcache" <linux-bcache@vger.kernel.org>, 
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-Id: <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem>
Content-Disposition: inline
Subject: Re: [PATCH v1 bcache] bcache: fix UAF in cached_dev_free and safely
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Received: from studio.coly ([120.245.64.178]) by smtp.feishu.cn with ESMTPS; Tue, 11 Nov 2025 21:48:56 +0800
References: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>
Date: Tue, 11 Nov 2025 21:48:55 +0800
X-Original-From: Coly Li <colyli@fnnas.com>
X-Lms-Return-Path: <lba+269133ec9+2b1923+vger.kernel.org+colyli@fnnas.com>
From: "Coly Li" <colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>

On Sat, Nov 08, 2025 at 05:22:51PM +0800, liequan che wrote:
>  We hit a use-after-free when cached_dev_free() is called while the
> writeback workqueue/thread may still be running or holding references.

Could you please point out exactly which reference is still held?

> In addition, writeback_wq was flushed/destroyed in more than one place,

Could you please point out all the location where writeback_wq is stopped?

> which could lead to double flush/destroy and racy teardown=E3=80=82This i=
ssue
> exists in kernels 5.10, 6.6, etc.

Yes, if you mean explain how the panic comes in code logic, it will be
helpful for me to understand the issue.

Thanks.

Coly Li


>  The error message is as follows.

> [18627.310402] ------------[ cut here ]------------
> [18627.316446] WARNING: CPU: 83 PID: 238405 at kernel/kthread.c:83
> kthread_stop+0x12c/0x160
> [18627.326367] Modules linked in: ceph libceph dns_resolver
> openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> scsi_transport_sas ccp pinctrl_amd
> [18627.392415] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> [18627.406601] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09/1=
5/2025
> [18627.415362] Workqueue: events cached_dev_free [bcache]
> [18627.421985] RIP: 0010:kthread_stop+0x12c/0x160
> [18627.427836] Code: 00 e9 0b ff ff ff 48 89 ef e8 50 69 fd ff e9 73
> ff ff ff be 01 00 00 00 4c 89 e7 e8 2e 6a 46 00 f6 45 36 20 0f 85 16
> ff ff ff <0f> 0b e9 0f ff ff ff be 03 00 00 00 4c 89 e7 e8 10 6a 46 00
> e9 43
> [18627.449681] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> [18627.456406] RAX: 0000000000000000 RBX: ffff94f51e700010 RCX: 000000000=
0000000
> [18627.465254] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d71=
fba0710
> [18627.474094] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f9c=
dd0fc90
> [18627.482942] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94cf4=
d518030
> [18627.491792] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d71=
fbbb705
> [18627.500643] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> knlGS:0000000000000000
> [18627.510564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [18627.517861] CR2: 000055d6288098d0 CR3: 0000000594856000 CR4: 000000000=
03506e0
> [18627.526715] Call Trace:
> [18627.530338]  cached_dev_free+0x30/0xd0 [bcache]
> [18627.536283]  process_one_work+0x1b5/0x350
> [18627.541643]  worker_thread+0x49/0x310
> [18627.546618]  ? rescuer_thread+0x380/0x380
> [18627.551977]  kthread+0xfe/0x140
> [18627.556372]  ? kthread_park+0x90/0x90
> [18627.561345]  ret_from_fork+0x22/0x30
> [18627.566226] ---[ end trace 461f27b6101e7b4f ]---
> [18627.572269] BUG: unable to handle page fault for address: 00007fd3f5b2=
1e10
> [18627.580823] #PF: supervisor write access in kernel mode
> [18627.587529] #PF: error_code(0x0002) - not-present page
> [18627.594131] PGD 6a710f067 P4D 6a710f067 PUD 0
> [18627.599968] Oops: 0002 [#1] SMP NOPTI
> [18627.604930] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> [18627.619101] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09/1=
5/2025
> [18627.627851] Workqueue: events cached_dev_free [bcache]
> [18627.634463] RIP: 0010:kthread_stop+0x49/0x160
> [18627.640199] Code: 45 30 85 c0 0f 84 1c 01 00 00 0f 88 e6 00 00 00
> 83 c0 01 0f 88 dd 00 00 00 f6 45 36 20 0f 84 ea 00 00 00 48 8b 9d e8
> 0a 00 00 <f0> 80 0b 02 48 89 ef e8 3b ff ff ff 48 89 ef e8 43 31 01 00
> 48 8d
> [18627.662022] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> [18627.668728] RAX: 0000000000000000 RBX: 00007fd3f5b21e10 RCX: 000000000=
0000000
> [18627.677565] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d71=
fba0710
> [18627.686404] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f9c=
dd0fc90
> [18627.695232] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94cf4=
d518030
> [18627.704070] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d71=
fbbb705
> [18627.712910] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> knlGS:0000000000000000
> [18627.722816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [18627.730103] CR2: 00007fd3f5b21e10 CR3: 0000000594856000 CR4: 000000000=
03506e0
> [18627.738941] Call Trace:
> [18627.742553]  cached_dev_free+0x30/0xd0 [bcache]
> [18627.748483]  process_one_work+0x1b5/0x350
> [18627.753824]  worker_thread+0x49/0x310
> [18627.758785]  ? rescuer_thread+0x380/0x380
> [18627.764134]  kthread+0xfe/0x140
> [18627.768514]  ? kthread_park+0x90/0x90
> [18627.773477]  ret_from_fork+0x22/0x30
> [18627.778344] Modules linked in: ceph libceph dns_resolver
> openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> scsi_transport_sas ccp pinctrl_amd
> [18627.844370] CR2: 00007fd3f5b21e10
> [18627.851414] kexec: Bye!
>  The kernel error call stack is as follows:The kernel error call stack
> is as follows.
> crash> bt
> PID: 238405   TASK: ffff94d71fae9c00  CPU: 83   COMMAND: "kworker/83:4"
> #0 [ffffb5f9cdd0fca8] crash_kexec at ffffffffb4db67e9
> #1 [ffffb5f9cdd0fcb8] oops_end at ffffffffb4c2b1c5
> #2 [ffffb5f9cdd0fcd8] no_context at ffffffffb4c7d86c
> #3 [ffffb5f9cdd0fd10] __bad_area_nosemaphore at ffffffffb4c7d972
> #4 [ffffb5f9cdd0fd58] exc_page_fault at ffffffffb56f7e1c
> #5 [ffffb5f9cdd0fdb0] asm_exc_page_fault at ffffffffb5800b4e
>    [exception RIP: kthread_stop+73]
>    RIP: ffffffffb4d0fee9  RSP: ffffb5f9cdd0fe60  RFLAGS: 00010246
>    RAX: 0000000000000000  RBX: 00007fd3f5b21e10  RCX: 0000000000000000
>    RDX: ffff94d71fbb1320  RSI: ffff94d71fba0710  RDI: ffff94d71fba0710
>    RBP: ffff94cf4d518000   R8: 0000000000000000   R9: ffffb5f9cdd0fc90
>    R10: ffffb5f9cdd0fc88  R11: ffffffffb69e13a8  R12: ffff94cf4d518030
>    R13: 0000000000000000  R14: ffff94d71fbbb700  R15: ffff94d71fbbb705
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> #6 [ffffb5f9cdd0fe80] cached_dev_free at ffffffffc0b88470 [bcache]
> #7 [ffffb5f9cdd0fe98] process_one_work at ffffffffb4d099c5
> #8 [ffffb5f9cdd0fed8] worker_thread at ffffffffb4d09f29
> #9 [ffffb5f9cdd0ff10] kthread at ffffffffb4d0f2be
> #10 [ffffb5f9cdd0ff50] ret_from_fork at ffffffffb4c035b2
> Signed-off-by: cheliequan <cheliequan@inspur.com>
> ---
> drivers/md/bcache/bcache.h    |  7 +++++++
> drivers/md/bcache/super.c     | 13 +++++++++----
> drivers/md/bcache/writeback.c |  9 ++++++---
> 3 files changed, 22 insertions(+), 7 deletions(-)
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 832fb3d80eb0..5eba5c068c9c 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -963,6 +963,13 @@ static inline void wait_for_kthread_stop(void)
>        }
> }
> +#define STOP_THREAD_ONCE(dc, member)                           \
> +       do {                                                           \
> +                       struct task_struct *t__ =3D xchg(&(dc)->member, N=
ULL);   \
> +                       if (t__ && !IS_ERR(t__))                         =
      \
> +                               kthread_stop(t__);                       =
      \
> +       } while (0)
> +
> /* Forward declarations */
> void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 6afc718ef202..22a002cca6ab 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1368,15 +1368,20 @@ void bch_cached_dev_release(struct kobject *kobj)
> static void cached_dev_free(struct closure *cl)
> {
> +       struct workqueue_struct *wq =3D NULL;
>        struct cached_dev *dc =3D container_of(cl, struct cached_dev, disk=
.cl);
>        if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
>                cancel_writeback_rate_update_dwork(dc);
> -       if (!IS_ERR_OR_NULL(dc->writeback_thread))
> -               kthread_stop(dc->writeback_thread);
> -       if (!IS_ERR_OR_NULL(dc->status_update_thread))
> -               kthread_stop(dc->status_update_thread);
> +       STOP_THREAD_ONCE(dc, writeback_thread);
> +       STOP_THREAD_ONCE(dc, status_update_thread);
> +
> +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> +       if (wq) {
> +           flush_workqueue(wq);
> +           destroy_workqueue(wq);
> +       }
>        mutex_lock(&bch_register_lock);
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.=
c
> index 854cdaa84462..3cac64b9d606 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -741,6 +741,7 @@ static int bch_writeback_thread(void *arg)
>        struct cached_dev *dc =3D arg;
>        struct cache_set *c =3D dc->disk.c;
>        bool searched_full_index;
> +       struct workqueue_struct *wq =3D NULL;
>        bch_ratelimit_reset(&dc->writeback_rate);
> @@ -832,10 +833,12 @@ static int bch_writeback_thread(void *arg)
>                }
>        }
> -       if (dc->writeback_write_wq) {
> -               flush_workqueue(dc->writeback_write_wq);
> -               destroy_workqueue(dc->writeback_write_wq);
> +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> +       if (wq) {
> +           flush_workqueue(wq);
> +           destroy_workqueue(wq);
>        }
> +
>        cached_dev_put(dc);
>        wait_for_kthread_stop();
> --
> 2.43.0

