Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D43C37312
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jun 2019 13:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfFFLie (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jun 2019 07:38:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:40762 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726877AbfFFLie (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jun 2019 07:38:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 50FDAAF99;
        Thu,  6 Jun 2019 11:38:32 +0000 (UTC)
Subject: Re: bcache corrupted cache
To:     Massimo Burcheri <massimo.burcheri@gmx.de>,
        linux-bcache@vger.kernel.org
References: <05050ff38ce81f5aa3be938d5bff5b83bd7171e4.camel@gmx.de>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <f92ff036-5d97-0934-7c5d-0348840c67da@suse.de>
Date:   Thu, 6 Jun 2019 19:38:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <05050ff38ce81f5aa3be938d5bff5b83bd7171e4.camel@gmx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/6 5:02 下午, Massimo Burcheri wrote:
> Hello,
> 
> I got a system crash with corrupted cashing device.
> 

What is your gcc version ?


> The story: Booting after a clean halt was mounting the
> btrfs-on-luks-on-bcache as read- only. The production system was
> using a 4.19.1 kernel with bcache writeback mode, bfq scheduler.
> btrfs scrub showed un-repaired errors.
> 
> Next step was booting a live Linux OpenSuse TW live with a recent
> 5.1.5 Kernel. Registering the caching device was segfaulting and
> crashing the root shell, leaving the bcache module unusable.

This one is important, if I can have the kernel message or call trace
of this segfault it will be very helpful.

> Booting up again I registered the backing device only and made it
> online by echo 1 > running.
> 
> # btrfs check -p /dev/mapper/_dev_bcache Opening filesystem to
> check... parent transid verify failed on 67670720512 wanted 718539
> found 715246 parent transid verify failed on 67670720512 wanted
> 718539 found 715246 Ignoring transid failure Couldn't setup extent
> tree ERROR: cannot open file system
> 
> # mount /dev/mapper/_dev_bcache /mnt/btrfs-top-lvl/ mount:
> /mnt/btrfs-top-lvl: wrong fs type, bad option, bad superblock on 
> /dev/mapper/_dev_bcache, missing codepage or helper program, or
> other error.
> 
> Looks like some writeback was missing, transid gap was huge.
> 
> Reading that there have been some important patches on bcache
> released in 5.1.6 https://patchwork.kernel.org/patch/10909293/ I
> installed a very recent 5.2... kernel and booted. Now registering
> the caching device was not segfaulting anymore but freezing without
> any return.
> 
> In dmesg I found only this part [see below] which happened earlier
> than my register.
> 
> Is my bcache definitely lost?

I am not sure for the dirty data on cache, but for the backing device
you may have most of data back. Considering there is btrfs on top of
it, a fsck is required.

You may try to run the backing device wihtout attaching cache device by:
  echo 1 > /sys/block/bcache0/bcache/running




> 
> Best regards, Massimo (..considering leaving bcache as just another
> point-of-failure)
> 
> 
> [   12.390390] ------------[ cut here ]------------ [   12.390392]
> kernel BUG at drivers/md/bcache/bset.h:433! [   12.390399] invalid
> opcode: 0000 [#1] SMP PTI [   12.390402] CPU: 0 PID: 862 Comm:
> bcache-register Not tainted 5.2.0-rc3- 1.g038ee83-default #1
> openSUSE Tumbleweed (unreleased) [   12.390403] Hardware name:
> Hewlett-Packard HP EliteBook 8560w/1631, BIOS 68SVD Ver. F.03
> 07/25/2011

It is very suspicious like a corrupted btree node, but I don't have
evidence so far. I receive similar report recently but with gcc9
compiled bcache binary. Not sure whether this one is related, but for
the gcc9 compiled bcache issue, I am looking at it now.

Thanks.

Coly Li


> [   12.390413] RIP: 0010:bch_extent_sort_fixup+0x724/0x730
> [bcache] [   12.390416] Code: ff ff 4c 89 c8 e9 3e ff ff ff 49 39
> f1 0f 97 c1 e9 74 ff ff ff 49 39 f2 41 0f 97 c5 e9 12 ff ff ff 48
> 8b 04 24 e9 88 fa ff ff <0f> 0b 0f 0b 48 29 d0 e9 88 fe ff ff 66
> 66 66 66 90 41 57 41 56 41 [   12.390417] RSP:
> 0000:ffffb40c82047a38 EFLAGS: 00010282 [   12.390419] RAX:
> fffffffffffeb580 RBX: ffff8e2bea3c0020 RCX: 0000000000000000 [
> 12.390420] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
> ffffb40c82047af0 [   12.390421] RBP: ffffb40c82047a90 R08:
> 0000000005103b10 R09: ffff8e2bdca28ba0 [   12.390422] R10:
> 0000000000000001 R11: 0000000000000000 R12: 0000000005118630 [
> 12.390423] R13: 0000000005118650 R14: ffffb40c82047ae0 R15:
> ffff8e2bea3c0000 [   12.390424] FS:  00007f672f634bc0(0000)
> GS:ffff8e2beda00000(0000) knlGS:0000000000000000 [   12.390426] CS:
> 0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [   12.390427] CR2:
> 00007f3b27b89900 CR3: 000000042b9d6003 CR4: 00000000000606f0 [
> 12.390428] Call Trace: [   12.390436]  btree_mergesort+0x19b/0x5c0
> [bcache] [   12.390442]  ? bch_cache_allocator_start+0x50/0x50
> [bcache] [   12.390446]  ? __alloc_pages_nodemask+0x13c/0x2d0 [
> 12.390451]  __btree_sort+0x9e/0x1d0 [bcache] [   12.390457]
> bch_btree_node_read_done+0x2cb/0x3c0 [bcache] [   12.390462]
> bch_btree_node_read+0xdb/0x180 [bcache] [   12.390467]  ?
> bch_keybuf_init+0x60/0x60 [bcache] [   12.390472]
> bch_btree_check_recurse+0x127/0x1f0 [bcache] [   12.390477]
> bch_btree_check+0x18e/0x1b0 [bcache] [   12.390479]  ?
> wait_woken+0x70/0x70 [   12.390486]  run_cache_set+0x487/0x730
> [bcache] [   12.390492]  register_bcache+0xbfa/0xf80 [bcache] [
> 12.390495]  ? __seccomp_filter+0x7b/0x680 [   12.390497]  ?
> kernfs_fop_write+0x101/0x180 [   12.390502]  ?
> bch_cache_set_alloc+0x540/0x540 [bcache] [   12.390504]
> kernfs_fop_write+0x101/0x180 [   12.390507]  vfs_write+0xb6/0x1a0 [
> 12.390509]  ksys_write+0x4f/0xc0 [   12.390512]
> do_syscall_64+0x60/0x130 [   12.390516]
> entry_SYSCALL_64_after_hwframe+0x49/0xbe [   12.390518] RIP:
> 0033:0x7f672f724854 [   12.390520] Code: 00 f7 d8 64 89 02 48 c7 c0
> ff ff ff ff eb bb 0f 1f 80 00 00 00 00 48 8d 05 e9 49 0d 00 8b 00
> 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f
> 00 48 83 ec 28 48 89 54 24 18 48 [   12.390521] RSP:
> 002b:00007fffebc37088 EFLAGS: 00000246 ORIG_RAX: 0000000000000001 [
> 12.390523] RAX: ffffffffffffffda RBX: 000000000000000a RCX:
> 00007f672f724854 [   12.390524] RDX: 000000000000000a RSI:
> 000055bf4ea5e260 RDI: 0000000000000003 [   12.390525] RBP:
> 000055bf4ea5e260 R08: 00000000ffffffff R09: 000000000000000a [
> 12.390526] R10: 00007fffebc3958b R11: 0000000000000246 R12:
> 000000000000000a [   12.390527] R13: 00007fffebc37110 R14:
> 000000000000000a R15: 00007f672f7f47c0 [   12.390528] Modules
> linked in: intel_rapl x86_pkg_temp_thermal intel_powerclamp
> coretemp kvm_intel kvm msr irqbypass crct10dif_pclmul crc32_pclmul
> crc32c_intel mei_wdt mei_hdcp ghash_clmulni_intel iTCO_wdt 
> iTCO_vendor_support ppdev arc4 bcache crc64 iwldvm mac80211
> aesni_intel snd_hda_codec_idt aes_x86_64 crypto_simd
> snd_hda_codec_generic cryptd snd_hda_codec_hdmi ledtrig_audio
> glue_helper iwlwifi snd_hda_intel snd_hda_codec snd_hda_core
> snd_hwdep cfg80211 snd_pcm joydev hp_wmi sparse_keymap pcspkr 
> e1000e snd_timer wmi_bmof snd rfkill hp_accel(+) mei_me ptp lpc_ich
> soundcore pps_core lis3lv02d mei input_polldev parport_pc
> thermal(+) parport tpm_infineon pcc_cpufreq ac battery button uas
> usb_storage hid_generic usbhid radeon xhci_pci serio_raw xhci_hcd
> firewire_ohci i2c_algo_bit ehci_pci sdhci_pci firewire_core 
> drm_kms_helper cqhci crc_itu_t sdhci ehci_hcd syscopyarea
> sysfillrect sysimgblt fb_sys_fops usbcore ttm mmc_core drm wmi
> video sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc [
> 12.390559]  scsi_dh_alua [   12.390564] ---[ end trace
> 0613cd8ca3de039c ]--- [   12.390569] RIP:
> 0010:bch_extent_sort_fixup+0x724/0x730 [bcache]
> 
