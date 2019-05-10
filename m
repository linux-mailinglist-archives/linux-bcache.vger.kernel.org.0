Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7CB11A0F9
	for <lists+linux-bcache@lfdr.de>; Fri, 10 May 2019 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfEJQIX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 10 May 2019 12:08:23 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44983 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbfEJQIX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 10 May 2019 12:08:23 -0400
Received: by mail-ot1-f68.google.com with SMTP id g18so5813548otj.11
        for <linux-bcache@vger.kernel.org>; Fri, 10 May 2019 09:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25IWrtoBN+KZVs2p6HVwdjmf+IVjoI2FQfN6+SvV8Qw=;
        b=Qt+HiZFdGl9nO9kHlFZCupEWma+3kJdSbK9EOtNOanVYFL2mqHDUcywc6iHaO+5H+6
         CHaGh86v7KQJUdlaJfxz1ANObPhaV9HXRA9FZz58H833zuTA6iB0zD816ldjKZsTNTtw
         Cz0nGPnQK86lk3TygTE1WX2CUJah1cOXFE+1ZqXmkFazPRioevVsz/+a54zfMhkdUiND
         0EvuO42M5BgFgxljEwA97IzHcIWtAD3on8yv0FmEVwN9/bqG27kuSCH7bSHuVKp5sFdo
         oT+vFfv/jpWrXh3UImaNRA31bw2HIkL2N6j2Zp7Zp4llZpHChKiO108p++V6d1OLVwTP
         6okA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25IWrtoBN+KZVs2p6HVwdjmf+IVjoI2FQfN6+SvV8Qw=;
        b=R4LwsBEO3+oJVwsKxdInPi+pCI92FsirCs/xbQmZqF6Wofy0R5y2jQYSB6VETxH6Pg
         IpjEarnojatyz8Yed7uof1QmJZmodPEdtCS3upYVV27HK3TLGn6LcvNHSyPjDvt6N7mk
         Sy0/xN11ugbzvrL1PG0eJhUFsdDkG2VOoaJqxO2+7tflN9P3D57J9IEGPjAc5AA0nqFL
         dcuD/c/J9CMIR588071degDjfbn8ek7Q26vsLPyb96+KqTTUwaUl57WtEIY3HqhC1/OH
         4DYlXaHKmQckieTwMIL++blqRlsaZc0RHcmoka3xOYaCP5y73N+3ZvDnawVYipe7imKm
         Y5fA==
X-Gm-Message-State: APjAAAWLVwG7vhVQ/rrW5vss5gHUAtXE9GI48LmwRu6B1BYHKX/dNGrN
        kL6X7nFAJOQxFfr60FqqSm9sez7rSsAe7PL372uSW/ZJ
X-Google-Smtp-Source: APXvYqwB8LrrzZQVUqpXatfYXaMAHyUiu2nOI70upKSFhekjGvXu/pmtlHYYu31sV50DWZ6+dFFghOJRXQham09qo9c=
X-Received: by 2002:a9d:6409:: with SMTP id h9mr454311otl.68.1557504502317;
 Fri, 10 May 2019 09:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAHDOzW4gegWc8sM-gS9Ddnsbm1dhMUuHcwjuWP10fdxXwQ1OkA@mail.gmail.com>
In-Reply-To: <CAHDOzW4gegWc8sM-gS9Ddnsbm1dhMUuHcwjuWP10fdxXwQ1OkA@mail.gmail.com>
From:   Jordan Patterson <jordanp@gmail.com>
Date:   Fri, 10 May 2019 10:08:11 -0600
Message-ID: <CAHDOzW5vujObYKLi=cBUPSOGg=zFTzjKq_HTEhAJB6nsBnqJSQ@mail.gmail.com>
Subject: Re: Kernel bug message when registering cache devices
To:     linux-bcache@vger.kernel.org
Cc:     rolf@rolffokkens.nl
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi:

I noticed Rolf's post about corruption after upgrading to Fedora 30,
and that Fedora 30 now defaults to GCC 9 for building the kernel.  I
also recently updated GCC to 9.1 on my system (Gentoo), and this was
the first kernel that I built with it.

Jordan


On Tue, May 7, 2019 at 10:08 AM Jordan Patterson <jordanp@gmail.com> wrote:
>
> Hi:
>
> I upgraded my kernel to 5.1 yesterday and after about an hour, I got
> some messages about timeouts on bcache_writeback.  After rebooting, I
> get a kernel bug message when the init tries to register my cache
> devices.  My setup consists of 4 bcache devices, each with a 6TB hard
> drive for the backing device and 800GB ssd for the cache device.
>
> The timeout messages:
>
> [ 3072.115581] INFO: task bcache_writebac:781 blocked for more than 122 seconds.
> [ 3072.115584]       Tainted: P           OE     5.1.0 #1
> [ 3072.115584] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3072.115586] bcache_writebac D    0   781      2 0x80000000
> [ 3072.115588] Call Trace:
> [ 3072.115599]  ? __schedule+0x26c/0x8c0
> [ 3072.115614]  ? blk_queue_exit+0x3e/0x60
> [ 3072.115616]  schedule+0x3c/0x80
> [ 3072.115618]  rwsem_down_write_failed+0x16e/0x250
> [ 3072.115622]  call_rwsem_down_write_failed+0x13/0x20
> [ 3072.115624]  down_write+0x20/0x30
> [ 3072.115634]  bch_writeback_thread+0x8f/0x5b0 [bcache]
> [ 3072.115639]  ? __wake_up_common+0x7a/0x140
> [ 3072.115641]  kthread+0xfb/0x130
> [ 3072.115647]  ? read_dirty+0x540/0x540 [bcache]
> [ 3072.115648]  ? kthread_park+0x90/0x90
> [ 3072.115650]  ret_from_fork+0x35/0x40
> [ 3072.115653] INFO: task bcache_writebac:785 blocked for more than 122 seconds.
> [ 3072.115653]       Tainted: P           OE     5.1.0 #1
> [ 3072.115654] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3072.115654] bcache_writebac D    0   785      2 0x80000000
> [ 3072.115655] Call Trace:
> [ 3072.115657]  ? __schedule+0x26c/0x8c0
> [ 3072.115659]  ? blk_queue_exit+0x2c/0x60
> [ 3072.115660]  schedule+0x3c/0x80
> [ 3072.115665]  __closure_sync+0x5a/0x4f0 [bcache]
> [ 3072.115670]  read_dirty+0x4ee/0x540 [bcache]
> [ 3072.115676]  ? __closure_wake_up+0x40/0x40 [bcache]
> [ 3072.115681]  bch_writeback_thread+0x4f1/0x5b0 [bcache]
> [ 3072.115683]  ? __wake_up_common+0x7a/0x140
> [ 3072.115685]  kthread+0xfb/0x130
> [ 3072.115689]  ? read_dirty+0x540/0x540 [bcache]
> [ 3072.115690]  ? kthread_park+0x90/0x90
> [ 3072.115692]  ret_from_fork+0x35/0x40
> [ 3072.115694] INFO: task bcache_writebac:789 blocked for more than 122 seconds.
> [ 3072.115694]       Tainted: P           OE     5.1.0 #1
> [ 3072.115695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3072.115695] bcache_writebac D    0   789      2 0x80000000
> [ 3072.115696] Call Trace:
> [ 3072.115698]  ? __schedule+0x26c/0x8c0
> [ 3072.115699]  ? blk_queue_exit+0x3e/0x60
> [ 3072.115700]  schedule+0x3c/0x80
> [ 3072.115702]  rwsem_down_write_failed+0x16e/0x250
> [ 3072.115704]  call_rwsem_down_write_failed+0x13/0x20
> [ 3072.115706]  down_write+0x20/0x30
> [ 3072.115710]  bch_writeback_thread+0x8f/0x5b0 [bcache]
> [ 3072.115712]  ? __wake_up_common+0x7a/0x140
> [ 3072.115714]  kthread+0xfb/0x130
> [ 3072.115718]  ? read_dirty+0x540/0x540 [bcache]
> [ 3072.115719]  ? kthread_park+0x90/0x90
> [ 3072.115720]  ret_from_fork+0x35/0x40
> [ 3072.115723] INFO: task bcache_writebac:796 blocked for more than 122 seconds.
> [ 3072.115724]       Tainted: P           OE     5.1.0 #1
> [ 3072.115724] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3072.115725] bcache_writebac D    0   796      2 0x80000000
> [ 3072.115726] Call Trace:
> [ 3072.115727]  ? __schedule+0x26c/0x8c0
> [ 3072.115729]  ? schedule_timeout+0x1d4/0x490
> [ 3072.115730]  schedule+0x3c/0x80
> [ 3072.115731]  rwsem_down_write_failed+0x16e/0x250
> [ 3072.115733]  call_rwsem_down_write_failed+0x13/0x20
> [ 3072.115735]  down_write+0x20/0x30
> [ 3072.115739]  bch_writeback_thread+0x8f/0x5b0 [bcache]
> [ 3072.115741]  ? __wake_up_common+0x7a/0x140
> [ 3072.115743]  kthread+0xfb/0x130
> [ 3072.115747]  ? read_dirty+0x540/0x540 [bcache]
> [ 3072.115748]  ? kthread_park+0x90/0x90
> [ 3072.115749]  ret_from_fork+0x35/0x40
> [ 3072.115752] INFO: task kworker/13:2:888 blocked for more than 122 seconds.
> [ 3072.115752]       Tainted: P           OE     5.1.0 #1
> [ 3072.115752] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 3072.115753] kworker/13:2    D    0   888      2 0x80000000
> [ 3072.115759] Workqueue: events update_writeback_rate [bcache]
> [ 3072.115760] Call Trace:
> [ 3072.115761]  ? __schedule+0x26c/0x8c0
> [ 3072.115763]  ? __switch_to_asm+0x40/0x70
> [ 3072.115764]  schedule+0x3c/0x80
> [ 3072.115765]  rwsem_down_read_failed+0xed/0x170
> [ 3072.115767]  ? __switch_to_asm+0x40/0x70
> [ 3072.115769]  ? __switch_to_asm+0x40/0x70
> [ 3072.115770]  ? __switch_to_asm+0x40/0x70
> [ 3072.115771]  call_rwsem_down_read_failed+0x14/0x30
> [ 3072.115773]  down_read+0x13/0x30
> [ 3072.115777]  update_writeback_rate+0x127/0x2f0 [bcache]
> [ 3072.115780]  process_one_work+0x1d1/0x3e0
> [ 3072.115781]  worker_thread+0x4a/0x3d0
> [ 3072.115783]  kthread+0xfb/0x130
> [ 3072.115784]  ? process_one_work+0x3e0/0x3e0
> [ 3072.115785]  ? kthread_park+0x90/0x90
> [ 3072.115786]  ret_from_fork+0x35/0x40
>
>
> The kernel bug message when trying to reload after reboot (booting
> from a USB key so I could get the log to a file):
>
> [  241.374514] kernel BUG at drivers/md/bcache/extents.c:294!
> [  241.374520] invalid opcode: 0000 [#1] SMP PTI
> [  241.374523] CPU: 1 PID: 12951 Comm: bash Tainted: P           O
>  4.19.27-gentoo-r1 #1
> [  241.374523] Hardware name: Supermicro X9DAi/X9DAi, BIOS 3.3 07/12/2018
> [  241.374529] RIP: 0010:bch_extent_sort_fixup+0x293/0x49d [bcache]
> [  241.374531] Code: 4c 8b 48 08 4d 89 d0 49 c1 e8 14 45 0f b7 c0 4d
> 89 ce 4d 29 c6 48 39 d1 74 0b 49 89 ce 49 29 d6 4c 89 f2 eb 0d 4d 39
> f3 75 02 <0f> 0b 48 89 fa 4c 29 ca 48 85 d2 0f 89 6e 01 00 00 4c 89 d2
> 48 89
> [  241.374532] RSP: 0018:ffffc900098b39a8 EFLAGS: 00010246
> [  241.374533] RAX: ffff88882bba75a8 RBX: ffff88885c633000 RCX: 0000000000000000
> [  241.374534] RDX: 0000000000000000 RSI: ffff88882bba8200 RDI: 0000000048044e58
> [  241.374535] RBP: ffffc900098b3a08 R08: 0000000000000040 R09: 0000000048044e88
> [  241.374536] R10: 9000001004000000 R11: 0000000048044e48 R12: ffffc900098b3a48
> [  241.374536] R13: ffff88885c633020 R14: 0000000048044e48 R15: 0000000000000004
> [  241.374538] FS:  00007fe781406740(0000) GS:ffff88887fc40000(0000)
> knlGS:0000000000000000
> [  241.374538] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  241.374539] CR2: 00005590ae11fe08 CR3: 000000085e206002 CR4: 00000000000606e0
> [  241.374540] Call Trace:
> [  241.374546]  ? bch_ptr_status+0x127/0x127 [bcache]
> [  241.374548]  btree_mergesort+0x161/0x46b [bcache]
> [  241.374551]  ? bch_cache_allocator_start+0x3d/0x3d [bcache]
> [  241.374554]  __btree_sort+0xaf/0x19c [bcache]
> [  241.374557]  bch_btree_node_read_done+0x20f/0x363 [bcache]
> [  241.374560]  bch_btree_node_read+0x14e/0x184 [bcache]
> [  241.374563]  ? __closure_wake_up+0x31/0x31 [bcache]
> [  241.374566]  bch_btree_check_recurse+0x116/0x1e0 [bcache]
> [  241.374569]  ? bch_extent_to_text+0xec/0x14c [bcache]
> [  241.374572]  bch_btree_check+0xd3/0x14e [bcache]
> [  241.374575]  ? wait_woken+0x68/0x68
> [  241.374578]  run_cache_set+0x328/0x730 [bcache]
> [  241.374582]  register_bcache+0x1290/0x1438 [bcache]
> [  241.374586]  kernfs_fop_write+0xf4/0x136
> [  241.374590]  __vfs_write+0x2e/0x13c
> [  241.374592]  ? __alloc_fd+0x91/0x147
> [  241.374594]  ? set_close_on_exec+0x25/0x50
> [  241.374595]  vfs_write+0xc3/0x166
> [  241.374596]  ksys_write+0x58/0xa6
> [  241.374599]  do_syscall_64+0x57/0xe6
> [  241.374603]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  241.374605] RIP: 0033:0x7fe78155cbf8
> [  241.374606] Code: 00 90 48 83 ec 38 64 48 8b 04 25 28 00 00 00 48
> 89 44 24 28 31 c0 48 8d 05 e5 7a 0d 00 8b 00 85 c0 75 27 b8 01 00 00
> 00 0f 05 <48> 3d 00 f0 ff ff 77 60 48 8b 4c 24 28 64 48 33 0c 25 28 00
> 00 00
> [  241.374607] RSP: 002b:00007ffcdca34870 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000001
> [  241.374608] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007fe78155cbf8
> [  241.374609] RDX: 0000000000000009 RSI: 00005590ae915940 RDI: 0000000000000001
> [  241.374609] RBP: 00005590ae915940 R08: 00005590ae943550 R09: 000000000000000a
> [  241.374610] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fe781630760
> [  241.374611] R13: 0000000000000009 R14: 00007fe78162b760 R15: 0000000000000009
> [  241.374612] Modules linked in: bcache crc64 ipv6 cfg80211 rfkill
> 8021q video backlight ac battery fan thermal snd_hda_codec_realtek
> snd_hda_codec_generic snd_hda_codec_hdmi mxm_wmi x86_pkg_temp_thermal
> crc32c_intel snd_hda_intel efivars snd_hda_codec snd_hda_core snd_pcm
> isci snd_timer hid_logitech_hidpp snd soundcore wmi button xts
> aes_x86_64 crc32_generic sha256_generic ixgb ixgbe samsung_sxgbe tulip
> cxgb3 cxgb mdio cxgb4 vxge bonding vxlan ip6_udp_tunnel udp_tunnel
> macvlan vmxnet3 tg3 sky2 r8169 libphy pcnet32 igb i2c_algo_bit hwmon
> i2c_core e1000 bnx2 atl1c msdos efivarfs configfs fuse f2fs zfs(PO)
> zunicode(PO) zlua(PO) zcommon(PO) znvpair(PO) zavl(PO) icp(PO) spl(O)
> jfs btrfs zstd_decompress zstd_compress xxhash lzo_compress
> zlib_deflate multipath linear raid10 raid1 raid0 dm_zero dm_snapshot
> [  241.374656]  dm_raid raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq dm_mirror dm_region_hash
> dm_log dm_crypt dm_bufio dm_mod dax hid_sunplus hid_sony hid_samsung
> hid_pl hid_petalynx hid_logitech_dj hid_gyration sl811_hcd xhci_pci
> xhci_hcd ohci_hcd uhci_hcd usb_storage ehci_pci ehci_hcd mpt3sas
> raid_class aic94xx libsas qla2xxx megaraid_sas megaraid_mbox
> megaraid_mm megaraid aacraid sx8 DAC960 hpsa 3w_9xxx 3w_xxxx 3w_sas
> mptsas scsi_transport_sas mptfc scsi_transport_fc mptspi mptscsih
> mptbase atp870u dc395x qla1280 dmx3191d sym53c8xx gdth initio BusLogic
> arcmsr aic7xxx aic79xx scsi_transport_spi sg pdc_adma sata_inic162x
> sata_mv ata_piix ahci libahci sata_qstor sata_vsc sata_uli sata_sis
> sata_sx4 sata_nv sata_via sata_svw sata_sil24 sata_sil sata_promise
> pata_sl82c105
> [  241.374695]  pata_via pata_jmicron pata_marvell pata_sis
> pata_netcell pata_pdc202xx_old pata_triflex pata_atiixp pata_opti
> pata_amd pata_ali pata_it8213 pata_pcmcia pcmcia pcmcia_core
> pata_ns87415 pata_ns87410 pata_serverworks pata_artop pata_it821x
> pata_optidma pata_hpt3x2n pata_hpt3x3 pata_hpt37x pata_hpt366
> pata_cmd64x pata_efar pata_rz1000 pata_sil680 pata_radisys
> pata_pdc2027x pata_mpiix libata nvme nvme_core virtio_net net_failover
> failover virtio_crypto crypto_engine virtio_mmio virtio_pci
> virtio_balloon virtio_rng virtio_console virtio_blk virtio_scsi
> virtio_ring virtio
> [  241.374718] ---[ end trace 00ee587553d956cb ]---
> [  241.374721] RIP: 0010:bch_extent_sort_fixup+0x293/0x49d [bcache]
> [  241.374722] Code: 4c 8b 48 08 4d 89 d0 49 c1 e8 14 45 0f b7 c0 4d
> 89 ce 4d 29 c6 48 39 d1 74 0b 49 89 ce 49 29 d6 4c 89 f2 eb 0d 4d 39
> f3 75 02 <0f> 0b 48 89 fa 4c 29 ca 48 85 d2 0f 89 6e 01 00 00 4c 89 d2
> 48 89
> [  241.374723] RSP: 0018:ffffc900098b39a8 EFLAGS: 00010246
> [  241.374724] RAX: ffff88882bba75a8 RBX: ffff88885c633000 RCX: 0000000000000000
> [  241.374724] RDX: 0000000000000000 RSI: ffff88882bba8200 RDI: 0000000048044e58
> [  241.374725] RBP: ffffc900098b3a08 R08: 0000000000000040 R09: 0000000048044e88
> [  241.374726] R10: 9000001004000000 R11: 0000000048044e48 R12: ffffc900098b3a48
> [  241.374727] R13: ffff88885c633020 R14: 0000000048044e48 R15: 0000000000000004
> [  241.374728] FS:  00007fe781406740(0000) GS:ffff88887fc40000(0000)
> knlGS:0000000000000000
> [  241.374728] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  241.374729] CR2: 00005590ae11fe08 CR3: 000000085e206002 CR4: 00000000000606e0
>
> Thanks.
>
> Jordan
