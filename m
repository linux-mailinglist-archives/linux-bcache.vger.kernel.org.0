Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A731BE4E8
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Sep 2019 20:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfIYSpe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 25 Sep 2019 14:45:34 -0400
Received: from mx.ewheeler.net ([66.155.3.69]:52678 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfIYSpe (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 25 Sep 2019 14:45:34 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 14:45:33 EDT
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 27920A0692;
        Wed, 25 Sep 2019 18:40:30 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id U_MdrTF4XxmN; Wed, 25 Sep 2019 18:40:28 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [66.155.3.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9A821A067D;
        Wed, 25 Sep 2019 18:40:28 +0000 (UTC)
Date:   Wed, 25 Sep 2019 18:40:26 +0000 (UTC)
From:   Eric Wheeler <dm-devel@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org, lvm-devel@redhat.com
Subject: kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178
 with scsi_mod.use_blk_mq=y
Message-ID: <alpine.LRH.2.11.1909251814220.15810@mx.ewheeler.net>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

We are using the 4.19.75 stable tree with dm-thin and multi-queue scsi.  
We have been using the 4.19 branch for months without issue; we just 
switched to MQ and we seem to have hit this BUG_ON.  Whether or not MQ is 
related to the issue, I don't know, maybe coincidence:

	static int sm_disk_new_block(struct dm_space_map *sm, dm_block_t *b)
	{
	    int r;
	    enum allocation_event ev;
	    struct sm_disk *smd = container_of(sm, struct sm_disk, sm);

	    /* FIXME: we should loop round a couple of times */
	    r = sm_ll_find_free_block(&smd->old_ll, smd->begin, smd->old_ll.nr_blocks, b);
	    if (r)
		return r;

	    smd->begin = *b + 1;
	    r = sm_ll_inc(&smd->ll, *b, &ev);
	    if (!r) {
		BUG_ON(ev != SM_ALLOC); <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		smd->nr_allocated_this_transaction++;
	    }

	    return r;
	}

This is a brand-new thin pool created about 12 hours ago:

  lvcreate -c 64k -L 12t --type thin-pool --thinpool data-pool --poolmetadatasize 16G data /dev/bcache0

We are using bcache, but I don't see any bcache code in the backtraces.  
The metadata is also on the bcache volume.

We were transferring data to the new thin volumes and it ran for about 12 
hours and then gave the trace below.  So far it has only happened once 
and I don't have a way to reproduce it.

Any idea what this BUG_ON would indicate and how we might contrive a fix?

-Eric



[199391.677689] ------------[ cut here ]------------
[199391.678437] kernel BUG at drivers/md/persistent-data/dm-space-map-disk.c:178!
[199391.679183] invalid opcode: 0000 [#1] SMP NOPTI
[199391.679941] CPU: 4 PID: 31359 Comm: kworker/u16:4 Not tainted 4.19.75 #1
[199391.680683] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.2 02/20/2015
[199391.681446] Workqueue: dm-thin do_worker [dm_thin_pool]
[199391.682187] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199391.682929] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[199391.684432] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
[199391.685186] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
[199391.685936] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
[199391.686659] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
[199391.687379] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
[199391.688120] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
[199391.688843] FS:  0000000000000000(0000) GS:ffff88880fb00000(0000) knlGS:0000000000000000
[199391.689571] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[199391.690253] CR2: 00007f5ae49a1000 CR3: 000000000200a003 CR4: 00000000001626e0
[199391.690984] Call Trace:
[199391.691714]  dm_pool_alloc_data_block+0x3f/0x60 [dm_thin_pool]
[199391.692411]  alloc_data_block.isra.52+0x6d/0x1e0 [dm_thin_pool]
[199391.693142]  process_cell+0x2a3/0x550 [dm_thin_pool]
[199391.693852]  ? sort+0x17b/0x270
[199391.694527]  ? u32_swap+0x10/0x10
[199391.695192]  do_worker+0x268/0x9a0 [dm_thin_pool]
[199391.695890]  process_one_work+0x171/0x370
[199391.696640]  worker_thread+0x49/0x3f0
[199391.697332]  kthread+0xf8/0x130
[199391.697988]  ? max_active_store+0x80/0x80
[199391.698659]  ? kthread_bind+0x10/0x10
[199391.699281]  ret_from_fork+0x1f/0x40
[199391.699930] Modules linked in: dm_snapshot btrfs xor zstd_decompress zstd_compress xxhash raid6_pq xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio drbd lru_cache xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables binfmt_misc ip6table_filter ip6_tables bcache xt_comment crc64 iptable_filter netconsole bridge 8021q garp stp mrp llc lz4 lz4_compress zram sunrpc x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul pcc_cpufreq ghash_clmulni_intel pcspkr sg ipmi_si ipmi_devintf lpc_ich ipmi_msghandler video i2c_i801 mfd_core ip_tables ext4 mbcache jbd2 mgag200 i2c_algo_bit drm_kms_helper
[199391.705631]  syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel i2c_core ahci libahci ixgbe libata e1000e arcmsr mdio dca dm_mirror dm_region_hash dm_log dm_mod
[199391.708083] ---[ end trace c31536d98046e8ec ]---
[199391.866776] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199391.867960] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[199391.870379] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
[199391.871524] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
[199391.872364] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
[199391.873173] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
[199391.873871] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
[199391.874550] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
[199391.875231] FS:  0000000000000000(0000) GS:ffff88880fb00000(0000) knlGS:0000000000000000
[199391.875941] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[199391.876633] CR2: 00007f5ae49a1000 CR3: 000000000200a003 CR4: 00000000001626e0
[199391.877317] Kernel panic - not syncing: Fatal exception
[199391.878006] Kernel Offset: disabled
[199392.032304] ---[ end Kernel panic - not syncing: Fatal exception ]---
[199392.032962] unchecked MSR access error: WRMSR to 0x83f (tried to write 0x00000000000000f6) at rIP: 0xffffffff81067af4 (native_write_msr+0x4/0x20)
[199392.034277] Call Trace:
[199392.034929]  <IRQ>
[199392.035576]  native_apic_msr_write+0x2e/0x40
[199392.036228]  arch_irq_work_raise+0x28/0x40
[199392.036877]  irq_work_queue_on+0x83/0xa0
[199392.037518]  irq_work_run_list+0x4c/0x70
[199392.038149]  irq_work_run+0x14/0x40
[199392.038771]  smp_call_function_single_interrupt+0x3a/0xd0
[199392.039393]  call_function_single_interrupt+0xf/0x20
[199392.040011]  </IRQ>
[199392.040624] RIP: 0010:panic+0x209/0x25c
[199392.041234] Code: 83 3d 86 de 75 01 00 74 05 e8 ff 5d 02 00 48 c7 c6 e0 bc 80 82 48 c7 c7 10 cd e5 81 31 c0 e8 fe 2b 06 00 fb 66 0f 1f 44 00 00 <45> 31 e4 e8 eb 2e 0d 00 4d 39 ec 7c 1e 41 83 f6 01 48 8b 05 2b de
[199392.042518] RSP: 0018:ffffc9000a147a30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff04
[199392.043174] RAX: 0000000000000039 RBX: 0000000000000200 RCX: 0000000000000006
[199392.043833] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff88880fb168b0
[199392.044493] RBP: ffffc9000a147aa0 R08: 0000000000000001 R09: 00000000000174b5
[199392.045155] R10: ffff8883d9753f00 R11: 0000000000000001 R12: ffffffff81e4a15c
[199392.045820] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81e49951
[199392.046486]  oops_end+0xc1/0xd0
[199392.047149]  do_trap+0x13d/0x150
[199392.047795]  do_error_trap+0xd5/0x130
[199392.048427]  ? sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.049048]  invalid_op+0x14/0x20
[199392.049650] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.050245] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[199392.051434] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
[199392.052010] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
[199392.052580] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
[199392.053150] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
[199392.053715] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
[199392.054266] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
[199392.054807]  ? __wake_up_common_lock+0x87/0xc0
[199392.055342]  ? sm_disk_new_block+0x82/0xb0 [dm_persistent_data]
[199392.055877]  dm_pool_alloc_data_block+0x3f/0x60 [dm_thin_pool]
[199392.056410]  alloc_data_block.isra.52+0x6d/0x1e0 [dm_thin_pool]
[199392.056947]  process_cell+0x2a3/0x550 [dm_thin_pool]
[199392.057484]  ? sort+0x17b/0x270
[199392.058016]  ? u32_swap+0x10/0x10
[199392.058538]  do_worker+0x268/0x9a0 [dm_thin_pool]
[199392.059060]  process_one_work+0x171/0x370
[199392.059576]  worker_thread+0x49/0x3f0
[199392.060083]  kthread+0xf8/0x130
[199392.060587]  ? max_active_store+0x80/0x80
[199392.061086]  ? kthread_bind+0x10/0x10
[199392.061569]  ret_from_fork+0x1f/0x40
[199392.062038] ------------[ cut here ]------------
[199392.062508] sched: Unexpected reschedule of offline CPU#1!
[199392.062989] WARNING: CPU: 4 PID: 31359 at arch/x86/kernel/smp.c:128 native_smp_send_reschedule+0x39/0x40
[199392.063485] Modules linked in: dm_snapshot btrfs xor zstd_decompress zstd_compress xxhash raid6_pq xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio drbd lru_cache xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables binfmt_misc ip6table_filter ip6_tables bcache xt_comment crc64 iptable_filter netconsole bridge 8021q garp stp mrp llc lz4 lz4_compress zram sunrpc x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul pcc_cpufreq ghash_clmulni_intel pcspkr sg ipmi_si ipmi_devintf lpc_ich ipmi_msghandler video i2c_i801 mfd_core ip_tables ext4 mbcache jbd2 mgag200 i2c_algo_bit drm_kms_helper
[199392.067463]  syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel i2c_core ahci libahci ixgbe libata e1000e arcmsr mdio dca dm_mirror dm_region_hash dm_log dm_mod
[199392.068729] CPU: 4 PID: 31359 Comm: kworker/u16:4 Tainted: G      D           4.19.75 #1
[199392.069356] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.2 02/20/2015
[199392.069982] Workqueue: dm-thin do_worker [dm_thin_pool]
[199392.070604] RIP: 0010:native_smp_send_reschedule+0x39/0x40
[199392.071229] Code: 0f 92 c0 84 c0 74 15 48 8b 05 93 f1 eb 00 be fd 00 00 00 48 8b 40 30 e9 85 f4 9a 00 89 fe 48 c7 c7 08 23 e5 81 e8 c7 9a 05 00 <0f> 0b c3 0f 1f 40 00 0f 1f 44 00 00 53 be 20 00 48 00 48 89 fb 48
[199392.072528] RSP: 0018:ffff88880fb03dc0 EFLAGS: 00010082
[199392.073186] RAX: 0000000000000000 RBX: ffff88880fa625c0 RCX: 0000000000000006
[199392.073847] RDX: 0000000000000000 RSI: 0000000000000096 RDI: ffff88880fb168b0
[199392.074512] RBP: ffff88880fa625c0 R08: 0000000000000001 R09: 00000000000174e5
[199392.075182] R10: ffff8881f2512300 R11: 0000000000000000 R12: ffff888804541640
[199392.075849] R13: ffff88880fb03e08 R14: 0000000000000000 R15: 0000000000000001
[199392.076512] FS:  0000000000000000(0000) GS:ffff88880fb00000(0000) knlGS:0000000000000000
[199392.077179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[199392.077833] CR2: 00007f5ae49a1000 CR3: 000000000200a003 CR4: 00000000001626e0
[199392.078481] Call Trace:
[199392.079117]  <IRQ>
[199392.079745]  check_preempt_curr+0x6b/0x90
[199392.080373]  ttwu_do_wakeup+0x19/0x130
[199392.080999]  try_to_wake_up+0x1e2/0x460
[199392.081623]  __wake_up_common+0x8f/0x160
[199392.082246]  ep_poll_callback+0x1af/0x300
[199392.082860]  __wake_up_common+0x8f/0x160
[199392.083470]  __wake_up_common_lock+0x7a/0xc0
[199392.084074]  irq_work_run_list+0x4c/0x70
[199392.084675]  smp_call_function_single_interrupt+0x3a/0xd0
[199392.085277]  call_function_single_interrupt+0xf/0x20
[199392.085879]  </IRQ>
[199392.086477] RIP: 0010:panic+0x209/0x25c
[199392.087079] Code: 83 3d 86 de 75 01 00 74 05 e8 ff 5d 02 00 48 c7 c6 e0 bc 80 82 48 c7 c7 10 cd e5 81 31 c0 e8 fe 2b 06 00 fb 66 0f 1f 44 00 00 <45> 31 e4 e8 eb 2e 0d 00 4d 39 ec 7c 1e 41 83 f6 01 48 8b 05 2b de
[199392.088341] RSP: 0018:ffffc9000a147a30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff04
[199392.088988] RAX: 0000000000000039 RBX: 0000000000000200 RCX: 0000000000000006
[199392.089639] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff88880fb168b0
[199392.090291] RBP: ffffc9000a147aa0 R08: 0000000000000001 R09: 00000000000174b5
[199392.090947] R10: ffff8883d9753f00 R11: 0000000000000001 R12: ffffffff81e4a15c
[199392.091601] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81e49951
[199392.092255]  oops_end+0xc1/0xd0
[199392.092894]  do_trap+0x13d/0x150
[199392.093516]  do_error_trap+0xd5/0x130
[199392.094122]  ? sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.094718]  invalid_op+0x14/0x20
[199392.095296] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.095866] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[199392.097006] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
[199392.097558] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
[199392.098103] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
[199392.098644] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
[199392.099176] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
[199392.099703] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
[199392.100229]  ? __wake_up_common_lock+0x87/0xc0
[199392.100744]  ? sm_disk_new_block+0x82/0xb0 [dm_persistent_data]
[199392.101251]  dm_pool_alloc_data_block+0x3f/0x60 [dm_thin_pool]
[199392.101752]  alloc_data_block.isra.52+0x6d/0x1e0 [dm_thin_pool]
[199392.102252]  process_cell+0x2a3/0x550 [dm_thin_pool]
[199392.102750]  ? sort+0x17b/0x270
[199392.103242]  ? u32_swap+0x10/0x10
[199392.103733]  do_worker+0x268/0x9a0 [dm_thin_pool]
[199392.104228]  process_one_work+0x171/0x370
[199392.104714]  worker_thread+0x49/0x3f0
[199392.105193]  kthread+0xf8/0x130
[199392.105665]  ? max_active_store+0x80/0x80
[199392.106132]  ? kthread_bind+0x10/0x10
[199392.106601]  ret_from_fork+0x1f/0x40
[199392.107069] ---[ end trace c31536d98046e8ed ]---
[199392.107544] ------------[ cut here ]------------
[199392.108017] sched: Unexpected reschedule of offline CPU#7!
[199392.108497] WARNING: CPU: 4 PID: 31359 at arch/x86/kernel/smp.c:128 native_smp_send_reschedule+0x39/0x40
[199392.108996] Modules linked in: dm_snapshot btrfs xor zstd_decompress zstd_compress xxhash raid6_pq xfs dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio drbd lru_cache xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_conntrack nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ipt_REJECT nf_reject_ipv4 ebtable_filter ebtables binfmt_misc ip6table_filter ip6_tables bcache xt_comment crc64 iptable_filter netconsole bridge 8021q garp stp mrp llc lz4 lz4_compress zram sunrpc x86_pkg_temp_thermal intel_powerclamp coretemp iTCO_wdt iTCO_vendor_support kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul pcc_cpufreq ghash_clmulni_intel pcspkr sg ipmi_si ipmi_devintf lpc_ich ipmi_msghandler video i2c_i801 mfd_core ip_tables ext4 mbcache jbd2 mgag200 i2c_algo_bit drm_kms_helper
[199392.112967]  syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel i2c_core ahci libahci ixgbe libata e1000e arcmsr mdio dca dm_mirror dm_region_hash dm_log dm_mod
[199392.114203] CPU: 4 PID: 31359 Comm: kworker/u16:4 Tainted: G      D W         4.19.75 #1
[199392.114819] Hardware name: Supermicro X9SCL/X9SCM/X9SCL/X9SCM, BIOS 2.2 02/20/2015
[199392.115439] Workqueue: dm-thin do_worker [dm_thin_pool]
[199392.116061] RIP: 0010:native_smp_send_reschedule+0x39/0x40
[199392.116683] Code: 0f 92 c0 84 c0 74 15 48 8b 05 93 f1 eb 00 be fd 00 00 00 48 8b 40 30 e9 85 f4 9a 00 89 fe 48 c7 c7 08 23 e5 81 e8 c7 9a 05 00 <0f> 0b c3 0f 1f 40 00 0f 1f 44 00 00 53 be 20 00 48 00 48 89 fb 48
[199392.117982] RSP: 0018:ffff88880fb03ee0 EFLAGS: 00010082
[199392.118632] RAX: 0000000000000000 RBX: ffff8887d093ac80 RCX: 0000000000000006
[199392.119295] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff88880fb168b0
[199392.119961] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000017529
[199392.120623] R10: ffff8881438ba800 R11: 0000000000000000 R12: ffffc9000a147988
[199392.121283] R13: ffffffff8113f9a0 R14: 0000000000000002 R15: ffff88880fb1cff8
[199392.121938] FS:  0000000000000000(0000) GS:ffff88880fb00000(0000) knlGS:0000000000000000
[199392.122589] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[199392.123229] CR2: 00007f5ae49a1000 CR3: 000000000200a003 CR4: 00000000001626e0
[199392.123867] Call Trace:
[199392.124495]  <IRQ>
[199392.125116]  update_process_times+0x40/0x50
[199392.125742]  tick_sched_handle+0x25/0x60
[199392.126367]  tick_sched_timer+0x37/0x70
[199392.126987]  __hrtimer_run_queues+0xfb/0x270
[199392.127601]  hrtimer_interrupt+0x122/0x270
[199392.128211]  smp_apic_timer_interrupt+0x6a/0x140
[199392.128819]  apic_timer_interrupt+0xf/0x20
[199392.129423]  </IRQ>
[199392.130020] RIP: 0010:panic+0x209/0x25c
[199392.130619] Code: 83 3d 86 de 75 01 00 74 05 e8 ff 5d 02 00 48 c7 c6 e0 bc 80 82 48 c7 c7 10 cd e5 81 31 c0 e8 fe 2b 06 00 fb 66 0f 1f 44 00 00 <45> 31 e4 e8 eb 2e 0d 00 4d 39 ec 7c 1e 41 83 f6 01 48 8b 05 2b de
[199392.131883] RSP: 0018:ffffc9000a147a30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[199392.132530] RAX: 0000000000000039 RBX: 0000000000000200 RCX: 0000000000000006
[199392.133180] RDX: 0000000000000000 RSI: 0000000000000086 RDI: ffff88880fb168b0
[199392.133830] RBP: ffffc9000a147aa0 R08: 0000000000000001 R09: 00000000000174b5
[199392.134482] R10: ffff8883d9753f00 R11: 0000000000000001 R12: ffffffff81e4a15c
[199392.135136] R13: 0000000000000000 R14: 0000000000000000 R15: ffffffff81e49951
[199392.135792]  oops_end+0xc1/0xd0
[199392.136444]  do_trap+0x13d/0x150
[199392.137094]  do_error_trap+0xd5/0x130
[199392.137740]  ? sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.138383]  invalid_op+0x14/0x20
[199392.139010] RIP: 0010:sm_disk_new_block+0xa0/0xb0 [dm_persistent_data]
[199392.139630] Code: 22 00 00 49 8b 34 24 e8 4e f9 ff ff 85 c0 75 11 83 7c 24 04 01 75 13 48 83 83 28 22 00 00 01 eb af 89 c5 eb ab e8 e0 95 9b e0 <0f> 0b 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55
[199392.140870] RSP: 0018:ffffc9000a147c88 EFLAGS: 00010297
[199392.141472] RAX: 0000000000000000 RBX: ffff8887ceed8000 RCX: 0000000000000000
[199392.142066] RDX: ffff8887d093ac80 RSI: 0000000000000246 RDI: ffff8887faab0a00
[199392.142647] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8887faab0a98
[199392.143211] R10: ffffffff810f8077 R11: 0000000000000000 R12: ffffc9000a147d58
[199392.143759] R13: ffffc9000a147d58 R14: 00000000ffffffc3 R15: 000000000014bbc0
[199392.144301]  ? __wake_up_common_lock+0x87/0xc0
[199392.144838]  ? sm_disk_new_block+0x82/0xb0 [dm_persistent_data]
[199392.145374]  dm_pool_alloc_data_block+0x3f/0x60 [dm_thin_pool]
[199392.145909]  alloc_data_block.isra.52+0x6d/0x1e0 [dm_thin_pool]
[199392.146435]  process_cell+0x2a3/0x550 [dm_thin_pool]
[199392.146949]  ? sort+0x17b/0x270
[199392.147450]  ? u32_swap+0x10/0x10
[199392.147944]  do_worker+0x268/0x9a0 [dm_thin_pool]
[199392.148441]  process_one_work+0x171/0x370
[199392.148937]  worker_thread+0x49/0x3f0
[199392.149430]  kthread+0xf8/0x130
[199392.149922]  ? max_active_store+0x80/0x80
[199392.150406]  ? kthread_bind+0x10/0x10
[199392.150883]  ret_from_fork+0x1f/0x40
[199392.151353] ---[ end trace c31536d98046e8ee ]---


--
Eric Wheeler
