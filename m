Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD7381AC2
	for <lists+linux-bcache@lfdr.de>; Sat, 15 May 2021 21:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhEOTYa (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 15 May 2021 15:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEOTY3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 15 May 2021 15:24:29 -0400
X-Greylist: delayed 1017 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 15 May 2021 12:23:15 PDT
Received: from mail.thorsten-knabe.de (mail.thorsten-knabe.de [IPv6:2a01:170:101e::d43c:8be2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E73C061573
        for <linux-bcache@vger.kernel.org>; Sat, 15 May 2021 12:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:To:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vW/RcWJmY76BE49OBoxY2NG+uqS+Xjg2Ua3q28+r+RE=; b=ouLTuP7EeWz0FfFEFbGMZuj+td
        eOXf6ER7lZ0f56Z5g/Wj0i5B67FNI5t8xeqqjlflz5hI/66+wkpwlso6xEEah7TVgqDex7iK0r3v0
        yCWS6i4IjmnjtpJWwXSXRirBZL1Ks30hq4Kcy/4FtDhiXGh0odWnu6QkdyPggKHzEZleNbVLbFr9t
        OUsSCL3AJ5PYtt14k1fl3MZoV7Hj95mbccr02PCzQMtkI0DE7YSHewu1UhaRKkiuoBEF7l5X5vNFP
        7s4ZGMBFst/uZf0sNZr0cG95ImxNR+5LZKRqs+KsgZznGlhE8002GASEA5/KieluCWu9maYQvqc8w
        sEC34yNA==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1lhzbz-0006OX-UV
        for linux-bcache@vger.kernel.org; Sat, 15 May 2021 21:06:10 +0200
From:   Thorsten Knabe <linux@thorsten-knabe.de>
To:     linux-bcache@vger.kernel.org
Subject: PROBLEM: bcache related kernel BUG() since Linux 5.12
Message-ID: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
Date:   Sat, 15 May 2021 21:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Report: Content analysis details:   (-1.1 points, 5.0 required)
  pts rule name              description
 ---- ---------------------- --------------------------------------------------
  0.8 DKIM_ADSP_ALL          No valid author signature, domain signs all mail
 -1.9 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello.

Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
usage.

Linux up to 5.11.x is not affected by this bug.

Environment:
- Debian 10 AMD 64
- Kernel 5.12 - 5.12.4
- Filesystem ext4
- Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
  (unsure if the degraded RAID-6 has an effect or not)
- Cache device: Single SSD

Kernel log:

May 12 20:22:24 tek04 kernel: nr_vecs=472
May 12 20:22:24 tek04 kernel: ------------[ cut here ]------------
May 12 20:22:24 tek04 kernel: kernel BUG at block/bio.c:53!
May 12 20:22:24 tek04 kernel: invalid opcode: 0000 [#1] PREEMPT SMP PTI
May 12 20:22:24 tek04 kernel: CPU: 1 PID: 1670 Comm: grep Tainted: G
      I       5.12.3 #2
May 12 20:22:24 tek04 kernel: Hardware name: To Be Filled By O.E.M. To
Be Filled By O.E.M./X58 Deluxe, BIOS P2.20 10/30/2009
May 12 20:22:24 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
May 12 20:22:24 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
e8 d4 80 fe ff
May 12 20:22:24 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
May 12 20:22:24 tek04 kernel: RAX: 000000000000000b RBX:
ffffc9000274b764 RCX: 0000000000000000
May 12 20:22:24 tek04 kernel: bch_count_backing_io_errors: 1 callbacks
suppressed
May 12 20:22:24 tek04 kernel: bcache: bch_count_backing_io_errors() md1:
Read-ahead I/O failed on backing device, ignore
May 12 20:22:24 tek04 kernel: RDX: ffff888333c5e400 RSI:
ffff888333c57480 RDI: ffff888333c57480
May 12 20:22:24 tek04 kernel: RBP: 0000000000000800 R08:
0000000000000000 R09: c0000000ffffdfff
May 12 20:22:24 tek04 kernel: R10: ffffc9000274b580 R11:
ffffc9000274b578 R12: ffff8881170f0118
May 12 20:22:24 tek04 kernel: R13: ffff888109911b00 R14:
ffff8881170f00d0 R15: 0000000000000800
May 12 20:22:24 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
GS:ffff888333c40000(0000) knlGS:0000000000000000
May 12 20:22:24 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
May 12 20:22:24 tek04 kernel: CR2: 00005628963f4fd0 CR3:
000000016c43c000 CR4: 00000000000006e0
May 12 20:22:24 tek04 kernel: Call Trace:
May 12 20:22:24 tek04 kernel:  bvec_alloc+0x22/0x90
May 12 20:22:24 tek04 kernel:  bio_alloc_bioset+0x176/0x230
May 12 20:22:24 tek04 kernel:  cached_dev_cache_miss+0x1a8/0x300
May 12 20:22:24 tek04 kernel:  cache_lookup_fn+0x110/0x2e0
May 12 20:22:24 tek04 kernel:  ? bch_ptr_invalid+0x10/0x10
May 12 20:22:24 tek04 kernel:  ? bch_btree_iter_next_filter+0x1af/0x2d0
May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0x69/0x160
May 12 20:22:24 tek04 kernel:  ? __bch_bset_search+0x315/0x440
May 12 20:22:24 tek04 kernel:  ? downgrade_write+0xb0/0xb0
May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0xcf/0x160
May 12 20:22:24 tek04 kernel:  ? raid5_make_request+0x5c4/0xaa0
May 12 20:22:24 tek04 kernel:  ? recalibrate_cpu_khz+0x10/0x10
May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x30/0x400
May 12 20:22:24 tek04 kernel:  ? rwsem_wake.isra.11+0x80/0x80
May 12 20:22:24 tek04 kernel:  bch_btree_map_keys+0xf2/0x140
May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
May 12 20:22:24 tek04 kernel:  cache_lookup+0xb1/0x190
May 12 20:22:24 tek04 kernel:  cached_dev_submit_bio+0x9ab/0xc90
May 12 20:22:24 tek04 kernel:  ? submit_bio_checks+0x197/0x4a0
May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x3b7/0x400
May 12 20:22:24 tek04 kernel:  submit_bio_noacct+0x10e/0x4c0
May 12 20:22:24 tek04 kernel:  submit_bio+0x2e/0x160
May 12 20:22:24 tek04 kernel:  ? xa_load+0x66/0x70
May 12 20:22:24 tek04 kernel:  ? bio_add_page+0x2f/0x70
May 12 20:22:24 tek04 kernel:  ext4_mpage_readpages+0x1ae/0xa00
May 12 20:22:24 tek04 kernel:  ? __mod_lruvec_state+0x29/0x60
May 12 20:22:24 tek04 kernel:  read_pages+0x78/0x1d0
May 12 20:22:24 tek04 kernel:  page_cache_ra_unbounded+0x127/0x1b0
May 12 20:22:24 tek04 kernel:  filemap_get_pages+0x1d0/0x4a0
May 12 20:22:24 tek04 kernel:  filemap_read+0x91/0x2d0
May 12 20:22:24 tek04 kernel:  new_sync_read+0x103/0x180
May 12 20:22:24 tek04 kernel:  vfs_read+0x11b/0x1b0
May 12 20:22:24 tek04 kernel:  ksys_read+0x55/0xd0
May 12 20:22:24 tek04 kernel:  do_syscall_64+0x33/0x80
May 12 20:22:24 tek04 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
May 12 20:22:24 tek04 kernel: RIP: 0033:0x7f3a1cb89461
May 12 20:22:24 tek04 kernel: Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8
e9 03 02 00 66 0f 1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0
75 13 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54
49 89 d4 55 48
May 12 20:22:24 tek04 kernel: RSP: 002b:00007fff4052fff8 EFLAGS:
00000246 ORIG_RAX: 0000000000000000
May 12 20:22:24 tek04 kernel: RAX: ffffffffffffffda RBX:
0000000000018000 RCX: 00007f3a1cb89461
May 12 20:22:24 tek04 kernel: RDX: 0000000000018000 RSI:
000055ff0d01a000 RDI: 0000000000000004
May 12 20:22:24 tek04 kernel: RBP: 0000000000018000 R08:
0000000000000002 R09: 000055ff0d0194b0
May 12 20:22:24 tek04 kernel: R10: 0000000000000000 R11:
0000000000000246 R12: 000055ff0d01a000
May 12 20:22:24 tek04 kernel: R13: 0000000000000004 R14:
000055ff0d0194b0 R15: 0000000000000004
May 12 20:22:24 tek04 kernel: Modules linked in: cmac bnep
intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic btusb
ledtrig_audio snd_hda_codec_hdmi btrtl kvm_intel snd_hda_intel btbcm
snd_intel_dspcfg btintel kvm snd_hda_codec irqbypass bluetooth serio_raw
pcspkr hfcpci snd_hda_core iTCO_wdt evdev input_leds joydev sg snd_hwdep
intel_pmc_bxt ecdh_generic rfkill iTCO_vendor_support mISDN_core ecc
snd_pcm snd_timer tiny_power_button snd soundcore button i7core_edac
acpi_cpufreq wmi nft_counter nf_log_ipv6 nf_log_ipv
May 12 20:22:24 tek04 kernel: ---[ end trace 9a03f30c7b4aa246 ]---
May 12 20:22:25 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
May 12 20:22:25 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
e8 d4 80 fe ff
May 12 20:22:25 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
May 12 20:22:25 tek04 kernel: RAX: 000000000000000b RBX:
ffffc9000274b764 RCX: 0000000000000000
May 12 20:22:25 tek04 kernel: RDX: ffff888333c5e400 RSI:
ffff888333c57480 RDI: ffff888333c57480
May 12 20:22:25 tek04 kernel: RBP: 0000000000000800 R08:
0000000000000000 R09: c0000000ffffdfff
May 12 20:22:25 tek04 kernel: R10: ffffc9000274b580 R11:
ffffc9000274b578 R12: ffff8881170f0118
May 12 20:22:25 tek04 kernel: R13: ffff888109911b00 R14:
ffff8881170f00d0 R15: 0000000000000800
May 12 20:22:25 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
GS:ffff888333c40000(0000) knlGS:0000000000000000
May 12 20:22:25 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
May 12 20:22:25 tek04 kernel: CR2: 00005628963f4fd0 CR3:
000000016c43c000 CR4: 00000000000006e0

A printk has been added to line 52 of block/bio.c to dump the nr_vecs
variable to the kernel log before the BUG(). Obviously nr_vecs (472
logged) is bigger than expected by bvec_alloc/bio_alloc_bioset (max
256), which finally triggers the BUG().

Removing the BUG() from line 52 of block/bio.c, thus basically restoring
the Linux 5.11.x behavior of bvec_alloc/bio_alloc_bioset to just return
NULL, when nr_vecs is too big seems to resolve the issue.

Regards
Thorsten

-- 
___
 |        | /                 E-Mail: linux@thorsten-knabe.de
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de
