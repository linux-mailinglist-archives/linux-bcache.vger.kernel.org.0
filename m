Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01E84599A0
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfF1MAU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:00:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:54106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfF1MAU (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:00:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B63ECB631;
        Fri, 28 Jun 2019 12:00:18 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 02/37] bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()
Date:   Fri, 28 Jun 2019 19:59:25 +0800
Message-Id: <20190628120000.40753-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When system memory is in heavy pressure, bch_gc_thread_start() from
run_cache_set() may fail due to out of memory. In such condition,
c->gc_thread is assigned to -ENOMEM, not NULL pointer. Then in following
failure code path bch_cache_set_error(), when cache_set_flush() gets
called, the code piece to stop c->gc_thread is broken,
         if (!IS_ERR_OR_NULL(c->gc_thread))
                 kthread_stop(c->gc_thread);

And KASAN catches such NULL pointer deference problem, with the warning
information:

[  561.207881] ==================================================================
[  561.207900] BUG: KASAN: null-ptr-deref in kthread_stop+0x3b/0x440
[  561.207904] Write of size 4 at addr 000000000000001c by task kworker/15:1/313

[  561.207913] CPU: 15 PID: 313 Comm: kworker/15:1 Tainted: G        W         5.0.0-vanilla+ #3
[  561.207916] Hardware name: Lenovo ThinkSystem SR650 -[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE136T-2.10]- 03/22/2019
[  561.207935] Workqueue: events cache_set_flush [bcache]
[  561.207940] Call Trace:
[  561.207948]  dump_stack+0x9a/0xeb
[  561.207955]  ? kthread_stop+0x3b/0x440
[  561.207960]  ? kthread_stop+0x3b/0x440
[  561.207965]  kasan_report+0x176/0x192
[  561.207973]  ? kthread_stop+0x3b/0x440
[  561.207981]  kthread_stop+0x3b/0x440
[  561.207995]  cache_set_flush+0xd4/0x6d0 [bcache]
[  561.208008]  process_one_work+0x856/0x1620
[  561.208015]  ? find_held_lock+0x39/0x1d0
[  561.208028]  ? drain_workqueue+0x380/0x380
[  561.208048]  worker_thread+0x87/0xb80
[  561.208058]  ? __kthread_parkme+0xb6/0x180
[  561.208067]  ? process_one_work+0x1620/0x1620
[  561.208072]  kthread+0x326/0x3e0
[  561.208079]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  561.208090]  ret_from_fork+0x3a/0x50
[  561.208110] ==================================================================
[  561.208113] Disabling lock debugging due to kernel taint
[  561.208115] irq event stamp: 11800231
[  561.208126] hardirqs last  enabled at (11800231): [<ffffffff83008538>] do_syscall_64+0x18/0x410
[  561.208127] BUG: unable to handle kernel NULL pointer dereference at 000000000000001c
[  561.208129] #PF error: [WRITE]
[  561.312253] hardirqs last disabled at (11800230): [<ffffffff830052ff>] trace_hardirqs_off_thunk+0x1a/0x1c
[  561.312259] softirqs last  enabled at (11799832): [<ffffffff850005c7>] __do_softirq+0x5c7/0x8c3
[  561.405975] PGD 0 P4D 0
[  561.442494] softirqs last disabled at (11799821): [<ffffffff831add2c>] irq_exit+0x1ac/0x1e0
[  561.791359] Oops: 0002 [#1] SMP KASAN NOPTI
[  561.791362] CPU: 15 PID: 313 Comm: kworker/15:1 Tainted: G    B   W         5.0.0-vanilla+ #3
[  561.791363] Hardware name: Lenovo ThinkSystem SR650 -[7X05CTO1WW]-/-[7X05CTO1WW]-, BIOS -[IVE136T-2.10]- 03/22/2019
[  561.791371] Workqueue: events cache_set_flush [bcache]
[  561.791374] RIP: 0010:kthread_stop+0x3b/0x440
[  561.791376] Code: 00 00 65 8b 05 26 d5 e0 7c 89 c0 48 0f a3 05 ec aa df 02 0f 82 dc 02 00 00 4c 8d 63 20 be 04 00 00 00 4c 89 e7 e8 65 c5 53 00 <f0> ff 43 20 48 8d 7b 24 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48
[  561.791377] RSP: 0018:ffff88872fc8fd10 EFLAGS: 00010286
[  561.838895] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838916] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838934] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838948] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838966] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838979] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  561.838996] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  563.067028] RAX: 0000000000000000 RBX: fffffffffffffffc RCX: ffffffff832dd314
[  563.067030] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000297
[  563.067032] RBP: ffff88872fc8fe88 R08: fffffbfff0b8213d R09: fffffbfff0b8213d
[  563.067034] R10: 0000000000000001 R11: fffffbfff0b8213c R12: 000000000000001c
[  563.408618] R13: ffff88dc61cc0f68 R14: ffff888102b94900 R15: ffff88dc61cc0f68
[  563.408620] FS:  0000000000000000(0000) GS:ffff888f7dc00000(0000) knlGS:0000000000000000
[  563.408622] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  563.408623] CR2: 000000000000001c CR3: 0000000f48a1a004 CR4: 00000000007606e0
[  563.408625] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  563.408627] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  563.904795] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  563.915796] PKRU: 55555554
[  563.915797] Call Trace:
[  563.915807]  cache_set_flush+0xd4/0x6d0 [bcache]
[  563.915812]  process_one_work+0x856/0x1620
[  564.001226] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  564.033563]  ? find_held_lock+0x39/0x1d0
[  564.033567]  ? drain_workqueue+0x380/0x380
[  564.033574]  worker_thread+0x87/0xb80
[  564.062823] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  564.118042]  ? __kthread_parkme+0xb6/0x180
[  564.118046]  ? process_one_work+0x1620/0x1620
[  564.118048]  kthread+0x326/0x3e0
[  564.118050]  ? kthread_create_worker_on_cpu+0xc0/0xc0
[  564.167066] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  564.252441]  ret_from_fork+0x3a/0x50
[  564.252447] Modules linked in: msr rpcrdma sunrpc rdma_ucm ib_iser ib_umad rdma_cm ib_ipoib i40iw configfs iw_cm ib_cm libiscsi scsi_transport_iscsi mlx4_ib ib_uverbs mlx4_en ib_core nls_iso8859_1 nls_cp437 vfat fat intel_rapl skx_edac x86_pkg_temp_thermal coretemp iTCO_wdt iTCO_vendor_support crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ses raid0 aesni_intel cdc_ether enclosure usbnet ipmi_ssif joydev aes_x86_64 i40e scsi_transport_sas mii bcache md_mod crypto_simd mei_me ioatdma crc64 ptp cryptd pcspkr i2c_i801 mlx4_core glue_helper pps_core mei lpc_ich dca wmi ipmi_si ipmi_devintf nd_pmem dax_pmem nd_btt ipmi_msghandler device_dax pcc_cpufreq button hid_generic usbhid mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect xhci_pci sysimgblt fb_sys_fops xhci_hcd ttm megaraid_sas drm usbcore nfit libnvdimm sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua efivarfs
[  564.299390] bcache: bch_count_io_errors() nvme0n1: IO error on writing btree.
[  564.348360] CR2: 000000000000001c
[  564.348362] ---[ end trace b7f0e5cc7b2103b0 ]---

Therefore, it is not enough to only check whether c->gc_thread is NULL,
we should use IS_ERR_OR_NULL() to check both NULL pointer and error
value.

This patch changes the above buggy code piece in this way,
         if (!IS_ERR_OR_NULL(c->gc_thread))
                 kthread_stop(c->gc_thread);

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 1b63ac876169..64d9de89a63f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1564,7 +1564,7 @@ static void cache_set_flush(struct closure *cl)
 	kobject_put(&c->internal);
 	kobject_del(&c->kobj);
 
-	if (c->gc_thread)
+	if (!IS_ERR_OR_NULL(c->gc_thread))
 		kthread_stop(c->gc_thread);
 
 	if (!IS_ERR_OR_NULL(c->root))
-- 
2.16.4

