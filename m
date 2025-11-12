Return-Path: <linux-bcache+bounces-1242-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BFBC5261F
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Nov 2025 14:08:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 41A1F4EBEAB
	for <lists+linux-bcache@lfdr.de>; Wed, 12 Nov 2025 13:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3155335081;
	Wed, 12 Nov 2025 13:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UhQ/kcOy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955B328612
	for <linux-bcache@vger.kernel.org>; Wed, 12 Nov 2025 13:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762952659; cv=none; b=tZJKessMMtKafC7ghY6ynyM/k90dnU2s2Jh1qsGs9E73juA+1hVzIXnTRFhwnVkMVnUHllMJlmnxgRNxYL0FPV5G1bWhmpT6dUllLiP1TOorZSHBeNkBTdGEdfEmVkjiGrQahuAWad4NX3Zxbc8tJiUf4xHBlxyPzE8YfUNK2oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762952659; c=relaxed/simple;
	bh=QYLYXMwpATr+2zUgtmCNYoVknYJ62/cpCdj2LA4xTMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DmcQZsQcFT4PIxo1mzLQeDQSJZe0MGPK8XGJbEf5QHSfPbQCxB+UktWF/Ru0jzFukw9OmvZJvAHtBEIuyt2TNw/2n8iKs8+BIV2abpkBLE9pTSc8/NE0C63AecFQyFSgDBn939ndkYQEN2JDvG93mh7wABWutUNqhuk0foAiOgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UhQ/kcOy; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2aa1ae006so4814285a.2
        for <linux-bcache@vger.kernel.org>; Wed, 12 Nov 2025 05:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762952656; x=1763557456; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+v0c1TnYfZJknmmDaaNsL8gKWaP3EjcNEEaSw2pEJc=;
        b=UhQ/kcOyvH6AtEfW9lhBM9Dqfs4lGj8oqAe5JCH4J/ksWECiAP+7pfCY0yM+UwQ5GR
         u91IbwiZOf5UNEgCAyr+RNy/GJv5JhXJ3+C3nizXx6lhzLQ4ppi6O7ti8VIIoVOILnDi
         +kWtcCDvaM2NJaFzv39gz6IdYS+Uvizmt9SIWEAdlCBwEfHeFWku9S9DZMtb+2f78Z8U
         LJcbsee6yqRgxD/7L1Mui86+diN3PNqXdg80lVapdkNC3JmKAlazQq+w2Bo/KewO5+42
         bsaGZUbLK+NS4/m74g4ljaqtsV/XilreeIBUV2Ipex6NPB1Lr1SBt9OKxt4TKVXw1E6i
         pzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762952656; x=1763557456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+v0c1TnYfZJknmmDaaNsL8gKWaP3EjcNEEaSw2pEJc=;
        b=UHuvqLXtZJrV1DXb86aM1PiTxeqMrssmQ9O7Q3NpvmjFSZSjVwAxNuwe037VNZpFR7
         qO45d+ekS86raiNfIvXMi+BrCVBoJle3+lWt3LyX3wqaaIZsJqcn4GrxOGIuwQTybdot
         POX+iWN9tCH7NaManTfYp/xLv7DRZlx4uvjACFLB1HCaUtd3qhk8x0IxQ9ynq6sSE292
         Qhux109Re6MDI6alheOPs8bAqmeDk5kcRqO6Res2UnRhqsXzpitTcTTHPS8wbzq2gXnd
         IGWMp20Yx3YLq2gt/iSrJ86jF8YCcmRiYgjpBh773vgLujHGB964PiInuaBUFb8uBT9P
         5WVw==
X-Forwarded-Encrypted: i=1; AJvYcCX3vTmAziVII4xyKO2olb1xdRd7X153Pn/b/TqDFIhW/Y1K7Wx6ZfK+gQx7ZgDFmeAO3GcR1SHB/Mc2fHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YywGsg6/QtWGjM7IR39nRCAar28qzrYBCY2cG45zPo+qrVTzJVM
	7+LkACYzFyLFiSqOjf/fa2kqUW423MCRUii96igJO/jhkP82A2R0iSs9DuCW7ZcrWbT2uEUOdgB
	+YiJJjk+KinYbDXw1da1tIhjQs8C+vRU=
X-Gm-Gg: ASbGncsrrRIuSk6QIuLkD7LElPtEf4DsKTbMzPJTvEdsRZLmOPm7NWrPjS0zpDYxsZd
	xDWgftH8FEJXgx5YMnt/HYTX1QaCdnPOvaQPPUMfzhBkwjn3DQh704iN5MGYfugnBh7Harpujug
	v1uunn4hnnNSmfFcuBV6A5i0FykDo3Ybfbisa2Pc06EBkEXKh+cwn3IUGWxYRMnaYJhmhhzf6eB
	DS2bnnyA/Ut78ebRnUVfaoLVLhqxwa3hvOvL42D9rNdx+I0WfBMOuHWHDZ2
X-Google-Smtp-Source: AGHT+IFUgKonRQf7BZhuJV4X0teWxeK1vGkKBkWJFx02fxymHCdBf4uLxr7iaciBl31Ta3ZKVx2cXfaPo3/dN+6C+R8=
X-Received: by 2002:ac8:5741:0:b0:4e8:a0bf:f5b5 with SMTP id
 d75a77b69052e-4eddbdd8f4amr33650611cf.73.1762952656039; Wed, 12 Nov 2025
 05:04:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_ry+u771V_dTQMiXpaz2iGbQOPmZfhwnyF56pM+FjXdsw@mail.gmail.com>
 <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem>
In-Reply-To: <4y5xucuqqqe4ppxu46nwsr6g34bu7ixc5xwwogdvkdpl3zhqi6@c6lj7rk5giem>
From: liequan che <liequanche@gmail.com>
Date: Wed, 12 Nov 2025 21:04:03 +0800
X-Gm-Features: AWmQ_bkDYreDIP2bSlZDn8H03n2kLsPL4eaS79Ti3T9H6zZ7ihTQAv77QrG_TaY
Message-ID: <CAAsfc_pa=AwaaN6Fy2jU6nPwnGET0oZgWZtSc3LtQ9_oJ6supA@mail.gmail.com>
Subject: Re: [PATCH v1 bcache] bcache: fix UAF in cached_dev_free and safely
To: Coly Li <colyli@fnnas.com>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, linux-bcache <linux-bcache@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>>Could you please point out exactly which reference is still held?
Let's analyze the call stack of the vmcore generated by kernel kdump
using the crash tool.
crash> dev -d bcache0
MAJOR GENDISK NAME REQUEST_QUEUE TOTAL ASYNC SYNC
259 ffff94f74254b800 nvme2n1 ffff94f748d60938 0 0 0
259 ffff94f741a5f800 nvme3n1 ffff94f749260000 0 0 0
259 ffff94f74746c000 nvme1n1 ffff94f746ff8938 0 0 0
8 ffff94d74196f000 sda ffff94cf45bc6568 0 0 0
8 ffff94f741ac7800 sdb ffff94cf45bc52f8 0 0 0
8 ffff94f741a1b000 sdc ffff94cf45bc5c30 0 0 0
8 ffff94f741d5b800 sdd ffff94cf45bc24e0 0 0 0
8 ffff94cf41a93000 sde ffff94cf45bc1ba8 0 0 0
8 ffff94cf41a97000 sdf ffff94cf45bc4088 0 0 0
8 ffff94cf41a93800 sdg ffff94cf4615d2f8 0 0 0
8 ffff94cf41a91000 sdh ffff94cf4615dc30 0 0 0
8 ffff94cf41a94800 sdi ffff94cf4615a4e0 0 0 0
8 ffff94cf41a96800 sdj ffff94cf46159ba8 0 0 0
8 ffff94cf41a90800 sdk ffff94cf4615e568 0 0 0
253 ffff94f7553dd800 bcache0 ffff94f51e742e18 0 0 0 259
ffff94f741d57800 nvme0n1 ffff94fc9fa5dc30 0 0 0
crash> p /x  $gendisk=3D((struct gendisk *)0xffff94f7553dd800)->private_dat=
a
$9 =3D (void *) 0xffff94f51e700010
crash> p /x  $closure=3D&((struct bcache_device *)$gendisk)->cl
$10 =3D (struct closure *) 0xffff94f51e700010
crash>p /x  $cached_set=3D&(struct cache_set *)(((struct bcache_device
*)$gendisk)->c)
$11 =3D (struct closure *) 0xffff94f51e7004b8
crash> p  $fn_name=3D((struct closure *)$closure)->fn
$12 =3D (closure_fn *) 0xffffffffc0b88440 <cached_dev_free>
crash> p $wq_name=3D((struct closure *)$closure)->wq
$13 =3D (struct workqueue_struct *) 0x14c0
crash> p /x ((struct closure *)$closure)->remaining.counter
$14 =3D  0x40000001
crash> p $dc_off=3D&((struct cached_dev *)0)->disk.cl
$15 =3D (struct closure *) 0x10
crash > p/x $cached_dev =3D (struct cached_dev *)((unsigned
long)$closure - (unsigned long)$dc_off)
$16 =3D 0xffff94f51e700000
crash> task $writeback_thread
task: invalid task, pid, or task_struct member: $writeback_thread
PID: 238405   TASK: ffff94d71fae9c00  CPU: 83   COMMAND: "kworker/83:4"
struct task_struct {
  thread_info =3D {
    flags =3D 16520,
    status =3D 0,
    cpu =3D 83,
    kabi_reserved1 =3D 0,
    kabi_reserved2 =3D 0
  },
  state =3D 0,
  stack =3D 0xffffb5f9cdd0c000,
......
crash> p  $writeback_thread
$41 =3D (struct task_struct *) 0xffff94cf4d518000
crash> kmem 0xffff94cf4d518000
CACHE             OBJSIZE  ALLOCATED     TOTAL  SLABS  SSIZE  NAME
ffff94e740006bc0     7168       1575      2904    726    32k  task_struct
  SLAB              MEMORY            NODE  TOTAL  ALLOCATED  FREE
  ffffecf502354600  ffff94cf4d518000     2      4          1     3
  FREE / [ALLOCATED]
   ffff94cf4d518000  (cpu 12 cache)
      PAGE         PHYSICAL      MAPPING       INDEX CNT FLAGS
ffffecf502354600 108d518000 ffff94e740006bc0 ffff94cf4d51b800  1
97ffffc0010200 slab,head
  the dc->writeback_thread kmem flag is  FREE / [ALLOCATED].

The outstanding reference is the struct cached_dev lifetime reference
(dc->count) held by the writeback kthread itself.

The writeback thread takes (or is created with) a ref to dc, and it
only drops it on exit via:

// writeback.c
...
if (dc->writeback_write_wq) { flush_workqueue(...); destroy_workqueue(...);=
 }
cached_dev_put(dc);                 // <-- drops the thread=E2=80=99s ref t=
o dc
wait_for_kthread_stop();

Separately, the bcache device=E2=80=99s closure (d->cl) still shows
CLOSURE_RUNNING | 1 (you saw remaining=3D0x40000001), which is the
closure=E2=80=99s *self* ref plus one extra reference that continue_at()lat=
er
drops before invokingcached_dev_free(). That closure ref is not a
leak; it=E2=80=99s the normal handoff to cached_dev_free()`.

What actually explodes is that dc->writeback_thread remains a stale
pointer after the thread has already exited and its task_struct slab
was freed. A later kthread_stop(dc->writeback_thread) tries to
get_task_struct() on a freed task, triggering:

Coly Li <colyli@fnnas.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8811=E6=97=A5=E5=
=91=A8=E4=BA=8C 21:49=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Nov 08, 2025 at 05:22:51PM +0800, liequan che wrote:
> >  We hit a use-after-free when cached_dev_free() is called while the
> > writeback workqueue/thread may still be running or holding references.
>
> Could you please point out exactly which reference is still held?
>
> > In addition, writeback_wq was flushed/destroyed in more than one place,
>
> Could you please point out all the location where writeback_wq is stopped=
?
>
> > which could lead to double flush/destroy and racy teardown=E3=80=82This=
 issue
> > exists in kernels 5.10, 6.6, etc.
>
> Yes, if you mean explain how the panic comes in code logic, it will be
> helpful for me to understand the issue.
>
> Thanks.
>
> Coly Li
>
>
> >  The error message is as follows.
>
> > [18627.310402] ------------[ cut here ]------------
> > [18627.316446] WARNING: CPU: 83 PID: 238405 at kernel/kthread.c:83
> > kthread_stop+0x12c/0x160
> > [18627.326367] Modules linked in: ceph libceph dns_resolver
> > openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> > nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> > edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> > ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> > ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> > drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> > sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> > crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> > dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> > scsi_transport_sas ccp pinctrl_amd
> > [18627.392415] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> > Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> > [18627.406601] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09=
/15/2025
> > [18627.415362] Workqueue: events cached_dev_free [bcache]
> > [18627.421985] RIP: 0010:kthread_stop+0x12c/0x160
> > [18627.427836] Code: 00 e9 0b ff ff ff 48 89 ef e8 50 69 fd ff e9 73
> > ff ff ff be 01 00 00 00 4c 89 e7 e8 2e 6a 46 00 f6 45 36 20 0f 85 16
> > ff ff ff <0f> 0b e9 0f ff ff ff be 03 00 00 00 4c 89 e7 e8 10 6a 46 00
> > e9 43
> > [18627.449681] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> > [18627.456406] RAX: 0000000000000000 RBX: ffff94f51e700010 RCX: 0000000=
000000000
> > [18627.465254] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d=
71fba0710
> > [18627.474094] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f=
9cdd0fc90
> > [18627.482942] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94c=
f4d518030
> > [18627.491792] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d=
71fbbb705
> > [18627.500643] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> > knlGS:0000000000000000
> > [18627.510564] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [18627.517861] CR2: 000055d6288098d0 CR3: 0000000594856000 CR4: 0000000=
0003506e0
> > [18627.526715] Call Trace:
> > [18627.530338]  cached_dev_free+0x30/0xd0 [bcache]
> > [18627.536283]  process_one_work+0x1b5/0x350
> > [18627.541643]  worker_thread+0x49/0x310
> > [18627.546618]  ? rescuer_thread+0x380/0x380
> > [18627.551977]  kthread+0xfe/0x140
> > [18627.556372]  ? kthread_park+0x90/0x90
> > [18627.561345]  ret_from_fork+0x22/0x30
> > [18627.566226] ---[ end trace 461f27b6101e7b4f ]---
> > [18627.572269] BUG: unable to handle page fault for address: 00007fd3f5=
b21e10
> > [18627.580823] #PF: supervisor write access in kernel mode
> > [18627.587529] #PF: error_code(0x0002) - not-present page
> > [18627.594131] PGD 6a710f067 P4D 6a710f067 PUD 0
> > [18627.599968] Oops: 0002 [#1] SMP NOPTI
> > [18627.604930] CPU: 83 PID: 238405 Comm: kworker/83:4 Kdump: loaded
> > Tainted: G        W         5.10.0-272.0.0.174.ile2312sp1.x86_64 #1
> > [18627.619101] Hardware name: Inspur CS5280H2/CS5280H2, BIOS 3.03.62 09=
/15/2025
> > [18627.627851] Workqueue: events cached_dev_free [bcache]
> > [18627.634463] RIP: 0010:kthread_stop+0x49/0x160
> > [18627.640199] Code: 45 30 85 c0 0f 84 1c 01 00 00 0f 88 e6 00 00 00
> > 83 c0 01 0f 88 dd 00 00 00 f6 45 36 20 0f 84 ea 00 00 00 48 8b 9d e8
> > 0a 00 00 <f0> 80 0b 02 48 89 ef e8 3b ff ff ff 48 89 ef e8 43 31 01 00
> > 48 8d
> > [18627.662022] RSP: 0018:ffffb5f9cdd0fe60 EFLAGS: 00010246
> > [18627.668728] RAX: 0000000000000000 RBX: 00007fd3f5b21e10 RCX: 0000000=
000000000
> > [18627.677565] RDX: ffff94d71fbb1320 RSI: ffff94d71fba0710 RDI: ffff94d=
71fba0710
> > [18627.686404] RBP: ffff94cf4d518000 R08: 0000000000000000 R09: ffffb5f=
9cdd0fc90
> > [18627.695232] R10: ffffb5f9cdd0fc88 R11: ffffffffb69e13a8 R12: ffff94c=
f4d518030
> > [18627.704070] R13: 0000000000000000 R14: ffff94d71fbbb700 R15: ffff94d=
71fbbb705
> > [18627.712910] FS:  0000000000000000(0000) GS:ffff94d71fb80000(0000)
> > knlGS:0000000000000000
> > [18627.722816] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [18627.730103] CR2: 00007fd3f5b21e10 CR3: 0000000594856000 CR4: 0000000=
0003506e0
> > [18627.738941] Call Trace:
> > [18627.742553]  cached_dev_free+0x30/0xd0 [bcache]
> > [18627.748483]  process_one_work+0x1b5/0x350
> > [18627.753824]  worker_thread+0x49/0x310
> > [18627.758785]  ? rescuer_thread+0x380/0x380
> > [18627.764134]  kthread+0xfe/0x140
> > [18627.768514]  ? kthread_park+0x90/0x90
> > [18627.773477]  ret_from_fork+0x22/0x30
> > [18627.778344] Modules linked in: ceph libceph dns_resolver
> > openvswitch nf_conncount nf_nat nf_conntrack nf_defrag_ipv6
> > nf_defrag_ipv4 libcrc32c vfat fat dm_multipath dm_mod amd64_edac_mod
> > edac_mce_amd kvm_amd kvm bcache crc64 i40iw irqbypass ses enclosure
> > ipmi_si ib_uverbs ipmi_devintf joydev rapl ipmi_msghandler pcspkr
> > ib_core sg i2c_piix4 k10temp fuse ext4 mbcache jbd2 ast
> > drm_vram_helper drm_kms_helper syscopyarea sysfillrect sysimgblt
> > sd_mod fb_sys_fops cec drm_ttm_helper ttm ahci crct10dif_pclmul igb
> > crc32_pclmul libahci nvme crc32c_intel ghash_clmulni_intel nvme_core
> > dca smartpqi i40e t10_pi drm i2c_algo_bit libata ngbe
> > scsi_transport_sas ccp pinctrl_amd
> > [18627.844370] CR2: 00007fd3f5b21e10
> > [18627.851414] kexec: Bye!
> >  The kernel error call stack is as follows:The kernel error call stack
> > is as follows.
> > crash> bt
> > PID: 238405   TASK: ffff94d71fae9c00  CPU: 83   COMMAND: "kworker/83:4"
> > #0 [ffffb5f9cdd0fca8] crash_kexec at ffffffffb4db67e9
> > #1 [ffffb5f9cdd0fcb8] oops_end at ffffffffb4c2b1c5
> > #2 [ffffb5f9cdd0fcd8] no_context at ffffffffb4c7d86c
> > #3 [ffffb5f9cdd0fd10] __bad_area_nosemaphore at ffffffffb4c7d972
> > #4 [ffffb5f9cdd0fd58] exc_page_fault at ffffffffb56f7e1c
> > #5 [ffffb5f9cdd0fdb0] asm_exc_page_fault at ffffffffb5800b4e
> >    [exception RIP: kthread_stop+73]
> >    RIP: ffffffffb4d0fee9  RSP: ffffb5f9cdd0fe60  RFLAGS: 00010246
> >    RAX: 0000000000000000  RBX: 00007fd3f5b21e10  RCX: 0000000000000000
> >    RDX: ffff94d71fbb1320  RSI: ffff94d71fba0710  RDI: ffff94d71fba0710
> >    RBP: ffff94cf4d518000   R8: 0000000000000000   R9: ffffb5f9cdd0fc90
> >    R10: ffffb5f9cdd0fc88  R11: ffffffffb69e13a8  R12: ffff94cf4d518030
> >    R13: 0000000000000000  R14: ffff94d71fbbb700  R15: ffff94d71fbbb705
> >    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> > #6 [ffffb5f9cdd0fe80] cached_dev_free at ffffffffc0b88470 [bcache]
> > #7 [ffffb5f9cdd0fe98] process_one_work at ffffffffb4d099c5
> > #8 [ffffb5f9cdd0fed8] worker_thread at ffffffffb4d09f29
> > #9 [ffffb5f9cdd0ff10] kthread at ffffffffb4d0f2be
> > #10 [ffffb5f9cdd0ff50] ret_from_fork at ffffffffb4c035b2
> > Signed-off-by: cheliequan <cheliequan@inspur.com>
> > ---
> > drivers/md/bcache/bcache.h    |  7 +++++++
> > drivers/md/bcache/super.c     | 13 +++++++++----
> > drivers/md/bcache/writeback.c |  9 ++++++---
> > 3 files changed, 22 insertions(+), 7 deletions(-)
> > diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> > index 832fb3d80eb0..5eba5c068c9c 100644
> > --- a/drivers/md/bcache/bcache.h
> > +++ b/drivers/md/bcache/bcache.h
> > @@ -963,6 +963,13 @@ static inline void wait_for_kthread_stop(void)
> >        }
> > }
> > +#define STOP_THREAD_ONCE(dc, member)                           \
> > +       do {                                                           =
\
> > +                       struct task_struct *t__ =3D xchg(&(dc)->member,=
 NULL);   \
> > +                       if (t__ && !IS_ERR(t__))                       =
        \
> > +                               kthread_stop(t__);                     =
        \
> > +       } while (0)
> > +
> > /* Forward declarations */
> > void bch_count_backing_io_errors(struct cached_dev *dc, struct bio *bio=
);
> > diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> > index 6afc718ef202..22a002cca6ab 100644
> > --- a/drivers/md/bcache/super.c
> > +++ b/drivers/md/bcache/super.c
> > @@ -1368,15 +1368,20 @@ void bch_cached_dev_release(struct kobject *kob=
j)
> > static void cached_dev_free(struct closure *cl)
> > {
> > +       struct workqueue_struct *wq =3D NULL;
> >        struct cached_dev *dc =3D container_of(cl, struct cached_dev, di=
sk.cl);
> >        if (test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags))
> >                cancel_writeback_rate_update_dwork(dc);
> > -       if (!IS_ERR_OR_NULL(dc->writeback_thread))
> > -               kthread_stop(dc->writeback_thread);
> > -       if (!IS_ERR_OR_NULL(dc->status_update_thread))
> > -               kthread_stop(dc->status_update_thread);
> > +       STOP_THREAD_ONCE(dc, writeback_thread);
> > +       STOP_THREAD_ONCE(dc, status_update_thread);
> > +
> > +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> > +       if (wq) {
> > +           flush_workqueue(wq);
> > +           destroy_workqueue(wq);
> > +       }
> >        mutex_lock(&bch_register_lock);
> > diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writebac=
k.c
> > index 854cdaa84462..3cac64b9d606 100644
> > --- a/drivers/md/bcache/writeback.c
> > +++ b/drivers/md/bcache/writeback.c
> > @@ -741,6 +741,7 @@ static int bch_writeback_thread(void *arg)
> >        struct cached_dev *dc =3D arg;
> >        struct cache_set *c =3D dc->disk.c;
> >        bool searched_full_index;
> > +       struct workqueue_struct *wq =3D NULL;
> >        bch_ratelimit_reset(&dc->writeback_rate);
> > @@ -832,10 +833,12 @@ static int bch_writeback_thread(void *arg)
> >                }
> >        }
> > -       if (dc->writeback_write_wq) {
> > -               flush_workqueue(dc->writeback_write_wq);
> > -               destroy_workqueue(dc->writeback_write_wq);
> > +       wq =3D xchg(&dc->writeback_write_wq, NULL);
> > +       if (wq) {
> > +           flush_workqueue(wq);
> > +           destroy_workqueue(wq);
> >        }
> > +
> >        cached_dev_put(dc);
> >        wait_for_kthread_stop();
> > --
> > 2.43.0

