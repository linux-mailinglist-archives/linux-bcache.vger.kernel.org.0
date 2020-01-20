Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6FF4142C1C
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Jan 2020 14:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATNcC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-bcache@lfdr.de>); Mon, 20 Jan 2020 08:32:02 -0500
Received: from mx02.bank-hlynov.ru ([65.52.69.146]:34164 "EHLO
        mx02.bank-hlynov.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgATNcC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 20 Jan 2020 08:32:02 -0500
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2020 08:32:01 EST
Received: from mx02.21bamcjcrxgudgt13xvml0pcyh.fx.internal.cloudapp.net (localhost [127.0.0.1])
        by mx02.bank-hlynov.ru (ESMTP server) with ESMTP id C323662173
        for <linux-bcache@vger.kernel.org>; Mon, 20 Jan 2020 16:22:48 +0300 (MSK)
From:   =?koi8-r?B?88/Sz8vJziDh0tTFzSDzxdLHxcXXyd4=?= 
        <a.sorokin@bank-hlynov.ru>
To:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Subject: Kernel panic after clearing stats
Thread-Topic: Kernel panic after clearing stats
Thread-Index: AQHVz5S0otwmAqUTK0O2teQ03iY29w==
Date:   Mon, 20 Jan 2020 13:22:46 +0000
Message-ID: <DA4005F3-FCC5-4D1E-9D2D-146AADA0CD3A@bank-hlynov.ru>
Accept-Language: ru-RU, en-US
Content-Language: ru-RU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Content-Type: text/plain; charset="koi8-r"
Content-ID: <23F3A0C6E5D0D441B386EEF52FD79CF0@bank-hlynov.ru>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello.
I have kernel panic after clearing stats on kernel 5.4.12.
Steps to reproduce:
1. Create new set: make-bcache -B /dev/nvme1n1 -C /dev/sda --wipe-bcache
2. Run in /sys/fs/bcache/<uuid>: echo 1 > clear_stats && cat stats_five_minute/cache_bypass_hits

[14640.589843] BUG: kernel NULL pointer dereference, address: 0000000000000000
[14640.591006] #PF: supervisor read access in kernel mode
[14640.592123] #PF: error_code(0x0000) - not-present page
[14640.593217] PGD 68498e067 P4D 68498e067 PUD 5edb19067 PMD 0
[14640.594335] Oops: 0000 [#1] SMP NOPTI
[14640.595425] CPU: 3 PID: 45788 Comm: file Kdump: loaded Not tainted 5.4.12-1.el7.x86_64 #1
[14640.596526] Hardware name: Dell Inc. PowerEdge R515/0Y9CHX, BIOS 2.4.1 05/04/2018
[14640.597636] RIP: 0010:sysfs_kf_seq_show+0xaa/0x1a0
[14640.598754] Code: 00 00 00 40 f6 c7 04 0f 85 b8 00 00 00 44 89 c9 31 c0 c1 e9 03 41 f6 c1 04 f3 48 ab 75 7d 41 f6 c1 02 75 65 41 83 e1 01 75 4e <49> 8b 04 24 48 85 c0 74 51 48 8b 0e 4c 89 c7 48 8b 71 60 e8 ee 3b
[14640.601034] RSP: 0018:ffffc9000cfe7dc8 EFLAGS: 00010246
[14640.602172] RAX: 0000000000000000 RBX: ffff8888361e4300 RCX: 0000000000000000
[14640.603318] RDX: ffff888840643000 RSI: ffff88879c76cfc0 RDI: ffff888840644000
[14640.604474] RBP: ffffc9000cfe7dd8 R08: ffff8890166e01c0 R09: 0000000000000000
[14640.605607] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000000
[14640.606724] R13: ffff88884cc72300 R14: ffff8888361e4300 R15: 0000000000000001
[14640.607849] FS:  00007fa3d82cf740(0000) GS:ffff88885fac0000(0000) knlGS:0000000000000000
[14640.608985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14640.610096] CR2: 0000000000000000 CR3: 00000005c6268000 CR4: 00000000000406e0
[14640.611213] Call Trace:
[14640.612332]  kernfs_seq_show+0x27/0x30
[14640.613434]  seq_read+0x161/0x3f0
[14640.614514]  kernfs_fop_read+0x11f/0x1b0
[14640.615591]  __vfs_read+0x1b/0x40
[14640.616668]  vfs_read+0x8e/0x140
[14640.617722]  ksys_read+0x61/0xd0
[14640.618758]  __x64_sys_read+0x1a/0x20
[14640.619774]  do_syscall_64+0x60/0x1c0
[14640.620792]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[14640.621802] RIP: 0033:0x7fa3d79997e0
[14640.622799] Code: 0b 31 c0 48 83 c4 08 e9 be fe ff ff 48 8d 3d bf 85 09 00 e8 82 65 02 00 66 90 83 3d 9d 87 2d 00 00 75 10 b8 00 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 2e c7 01 00 48 89 04 24
[14640.624861] RSP: 002b:00007fffd20b5d18 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[14640.625895] RAX: ffffffffffffffda RBX: 00007fa3d8287010 RCX: 00007fa3d79997e0
[14640.626953] RDX: 0000000000040000 RSI: 00007fa3d8287010 RDI: 0000000000000003
[14640.627989] RBP: 0000000000000003 R08: ffffffffffffffff R09: 0000000000040041
[14640.629016] R10: 00007fffd20b59a0 R11: 0000000000000246 R12: 000000000145ff20
[14640.630032] R13: 00007fffd20b7710 R14: 0000000000000000 R15: 000000000000004e
[14640.631039] Modules linked in: bcache crc64 mpt3sas raid_class scsi_transport_sas mptctl mptbase dell_rbu xt_nat veth xt_MASQUERADE nf_conntrack_netlink xt_addrtype overlay 8021q garp mrp bonding ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_nat iptable_mangle iptable_security iptable_raw nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c rfkill ip_set nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter amd64_edac_mod edac_mce_amd kvm_amd ccp kvm irqbypass dcdbas crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel sr_mod crypto_simd cryptd cdrom joydev glue_helper input_leds pcspkr sg ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter sp5100_tco k10temp i2c_piix4 fam15h_power ip_tables ext4 mbcache jbd2 uas usb_storage sd_mod ata_generic pata_acpi mgag200 drm_kms_helper syscopyarea crc32c_intel sysfillrect sysimgblt
[14640.631078]  fb_sys_fops drm_vram_helper ttm serio_raw drm i2c_algo_bit ahci pata_atiixp libahci nvme ixgbe libata mdio bnx2 megaraid_sas ptp pps_core nvme_core dca [last unloaded: bcache]
[14640.642359] CR2: 0000000000000000
