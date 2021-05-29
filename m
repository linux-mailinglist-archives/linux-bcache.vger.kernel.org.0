Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754D0394D45
	for <lists+linux-bcache@lfdr.de>; Sat, 29 May 2021 18:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhE2QzX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 29 May 2021 12:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhE2QzW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 29 May 2021 12:55:22 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3723C061574
        for <linux-bcache@vger.kernel.org>; Sat, 29 May 2021 09:53:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b11so1613125edy.4
        for <linux-bcache@vger.kernel.org>; Sat, 29 May 2021 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x77fvIu+8ecO4dER2Jg2KEk9AQM9DChEkIPgKIcCOkg=;
        b=JgE4VNKDYANWUflKel/hzdp9fsgBZrWc2tYjz7jidB9oDAW9fbeITYqramO5+iA/7E
         5XTr8hruJy9fsz9gCkelOUx16RgpnKcq2Jjfaw53BISvk1RHc7cJIywY1nm87hFI6zoP
         G8+Np5fzCIoqsmgYVcoRRxxPaDvovv1O5MpfTJ1GeUTCfOp8YKtrUZLh9Xm7HQrnTQRD
         T80UPNm/NQ0r7Y3pKiQ1QzZ+75Je+etImWbzhj2FPeUYdceCFvktSxG7zVioDSupzZcD
         etFq1Gy8Ou0/V+cwszlCwbZ79fcz3LW6xzPQTCFZD5bYa4/8sT+mLyHwuORNhx5G9BLw
         8CxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x77fvIu+8ecO4dER2Jg2KEk9AQM9DChEkIPgKIcCOkg=;
        b=VHLHgJTN/n6N6Kt84r4uP0JUKElowd+wwRvGHxqV9n6LjcDHdSUL/qVoF60BylK2XE
         dRFnX4xg6kwT6B2A6Mz5HmYTGn53TFLWdT/bGa3p70Ihj9z5Tl6i+yEA8LTWq5pd1sts
         4hRnRxsWKbve8OCJ4phePqvvGXyCyH71sPdEnUwJEp/53Pf5YZUm617hHV+4TxWKOQ8L
         rA5SxGNKXD7fP8+62xZy0RZlLOMnth1NVsC3J32hlAMtZkkNiCYSiU4Abn2EEXeSduQk
         ui3oeq0QQNA/dlhEcZAXH6GBbq0hK+65axqo/Di0JDnJJGZw/747aVVUDpqdEGCPFg55
         LuyA==
X-Gm-Message-State: AOAM532ocAI+1OKamwkW3u36qv7aJPPfuYCNKqUTYbb0bVUkBpJpTIHp
        0b5oVDbmd4U93w4jcb/NpyYHNKadzIxOveYQ
X-Google-Smtp-Source: ABdhPJxS+CFt69FPbaziwt5MoqRgC0MtI+XN3u9oGVMunRFp3tnQ6h/W6sAjzkZylNuw+Wtsh4RBfw==
X-Received: by 2002:a50:fb17:: with SMTP id d23mr16261817edq.338.1622307223353;
        Sat, 29 May 2021 09:53:43 -0700 (PDT)
Received: from kevinix.localnet (ip-88-152-156-99.hsi03.unitymediagroup.de. [88.152.156.99])
        by smtp.gmail.com with ESMTPSA id i5sm4370190edt.11.2021.05.29.09.53.42
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 09:53:42 -0700 (PDT)
From:   Alexander Ullrich <ealex1979@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: Arch Linux 5.10.39-1-lts bcache bug
Date:   Sat, 29 May 2021 18:53:41 +0200
Message-ID: <6038577.Dgk0sJP1XM@kevinix>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

Im experiencing a kernel bug with bcache on the Arch linux LTS kernel 
(5.10.39-1-lts) that might relate to the one you try to solve in "[PATCH v4] 
bcache: avoid oversized read request in cache missing code path". The previous 
version of the LTS kernel, 5.10.38-1-lts, seems to be stable and unaffected.

The perceived behaviour is, as far as I can tell, identical to what happens 
when the mentioned bug happens on a 5.12 kernel, but it happens way later. 
While the 5.12 kernels bug out early on one of the systemd units, I was using 
my system normally for several hours using the LTS kernel, with quite high 
load (for a desktop) on IO with games, virtual machines and emulators, trying 
to start the Epic Games Launcher /w wine triggers the bug even accross 
reboots.

I will copy the relevant section of the kernel log after this mail. Please 
request any information I failed to provide that would be needed to figure this 
one out, this is my first contact with any linux ML and I do not feel to be 
exactly, or anyhow, competent on the matter or on behaviour and form here.

Thank you very much,

Alexander Ullrich

---
Mai 27 18:49:53 kevinix systemd[931]: Started Lutris.
Mai 27 18:50:15 kevinix kernel: ------------[ cut here ]------------
Mai 27 18:50:15 kevinix kernel: kernel BUG at drivers/md/bcache/bset.c:884!
Mai 27 18:50:15 kevinix kernel: invalid opcode: 0000 [#1] SMP NOPTI
Mai 27 18:50:15 kevinix kernel: CPU: 2 PID: 4018 Comm: EpicGamesLaunch 
Tainted: P           OE     5.10.39-1-lts #1
Mai 27 18:50:15 kevinix kernel: Hardware name: System manufacturer System 
Product Name/M5A78L-M LX3, BIOS 1101    01/17/2013
Mai 27 18:50:15 kevinix kernel: RIP: 0010:bch_btree_insert_key+0x298/0x2a0 
[bcache]
Mai 27 18:50:15 kevinix kernel: Code: 8b 55 08 48 29 fa 25 ff ff 0f 00 0f 85 f9 
fd ff ff 45 31 c0 48 85 d2 0f 84 08 fe ff ff e9 f7 fd ff ff 48 89 c3 e9 2d ff ff ff 
<0f> 0b e8 71 83 e7 dc 90 0f 1f 44 00 00 48 8d 4f 18 e9 92 fc ff ff
Mai 27 18:50:15 kevinix kernel: RSP: 0018:ffffba4ec216b568 EFLAGS: 00010246
Mai 27 18:50:15 kevinix kernel: RAX: 9000001000000000 RBX: 0000000000000000 
RCX: ffff965e901bf0d8
Mai 27 18:50:15 kevinix kernel: RDX: ffffffffc01c27c0 RSI: 8000000000000000 RDI: 
0000000000000000
Mai 27 18:50:15 kevinix kernel: RBP: ffffba4ec216b768 R08: ffff965e8ca60000 R09: 
000007ffffffffff
Mai 27 18:50:15 kevinix kernel: R10: 000000000000000f R11: 0000000006018141 
R12: ffff965e8ac77000
Mai 27 18:50:15 kevinix kernel: R13: ffff965e901bf0c0 R14: ffff965e901bf0d8 R15: 
0000000000000000
Mai 27 18:50:15 kevinix kernel: FS:  00007f3da397f080(0000) 
GS:ffff96618ec80000(0000) knlGS:000000013ffe0000
Mai 27 18:50:15 kevinix kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Mai 27 18:50:15 kevinix kernel: CR2: 00000000074c0000 CR3: 0000000317650000 
CR4: 00000000000406e0
Mai 27 18:50:15 kevinix kernel: Call Trace:
Mai 27 18:50:15 kevinix kernel:  ? btree_insert_key+0x51/0xc0 [bcache]
Mai 27 18:50:15 kevinix kernel:  btree_insert_key+0x51/0xc0 [bcache]
Mai 27 18:50:15 kevinix kernel:  bch_btree_insert_keys+0xb0/0x2b0 [bcache]
Mai 27 18:50:15 kevinix kernel:  bch_btree_insert_node+0x176/0x420 [bcache]
Mai 27 18:50:15 kevinix kernel:  bch_btree_insert_check_key+0xf4/0x1b0 
[bcache]
Mai 27 18:50:15 kevinix kernel:  ? __bch_extent_invalid+0x96/0xb0 [bcache]
Mai 27 18:50:15 kevinix kernel:  ? submit_bio_noacct+0x32/0x4f0
Mai 27 18:50:15 kevinix kernel:  ? bio_associate_blkg_from_css+0x1d1/0x300
Mai 27 18:50:15 kevinix kernel:  cached_dev_cache_miss+0xb3/0x2d0 [bcache]
Mai 27 18:50:15 kevinix kernel:  cache_lookup_fn+0x112/0x2e0 [bcache]
Mai 27 18:50:15 kevinix kernel:  ? bch_btree_iter_next_filter+0x1ad/0x2c0 
[bcache]
Mai 27 18:50:15 kevinix kernel:  ? bch_data_invalidate+0x180/0x180 [bcache]
Mai 27 18:50:15 kevinix kernel:  bch_btree_map_keys_recurse+0x80/0x180 
[bcache]
Mai 27 18:50:15 kevinix kernel:  ? bch_data_invalidate+0x180/0x180 [bcache]
Mai 27 18:50:15 kevinix kernel:  bch_btree_map_keys_recurse+0xfb/0x180 
[bcache]
Mai 27 18:50:15 kevinix kernel:  ? mempool_alloc+0x60/0x160
Mai 27 18:50:15 kevinix kernel:  bch_btree_map_keys+0x163/0x1b0 [bcache]
Mai 27 18:50:15 kevinix kernel:  ? bch_data_invalidate+0x180/0x180 [bcache]
Mai 27 18:50:15 kevinix kernel:  cache_lookup+0xa1/0x160 [bcache]
Mai 27 18:50:15 kevinix kernel:  cached_dev_submit_bio+0x936/0xd10 [bcache]
Mai 27 18:50:15 kevinix kernel:  ? submit_bio_checks+0x1bb/0x5b0
Mai 27 18:50:15 kevinix kernel:  ? mempool_alloc+0x60/0x160
Mai 27 18:50:15 kevinix kernel:  submit_bio_noacct+0x11b/0x4f0
Mai 27 18:50:15 kevinix kernel:  ext4_mpage_readpages+0x62d/0x9e0 [ext4]
Mai 27 18:50:15 kevinix kernel:  ? __mod_memcg_lruvec_state+0x21/0xe0
Mai 27 18:50:15 kevinix kernel:  ? __add_to_page_cache_locked+0x19c/0x430
Mai 27 18:50:15 kevinix kernel:  read_pages+0x8c/0x280
Mai 27 18:50:15 kevinix kernel:  page_cache_ra_unbounded+0x13f/0x200
Mai 27 18:50:15 kevinix kernel:  generic_file_buffered_read+0x14d/0xa60
Mai 27 18:50:15 kevinix kernel:  new_sync_read+0x115/0x1a0
Mai 27 18:50:15 kevinix kernel:  vfs_read+0x147/0x1a0
Mai 27 18:50:15 kevinix kernel:  __x64_sys_pread64+0x8c/0xc0
Mai 27 18:50:15 kevinix kernel:  do_syscall_64+0x33/0x40
Mai 27 18:50:15 kevinix kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Mai 27 18:50:15 kevinix kernel: RIP: 0033:0x7f3da396b03f
Mai 27 18:50:15 kevinix kernel: Code: 08 89 3c 24 48 89 4c 24 18 e8 2d f4 ff ff 
4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 7d f4 ff ff 48 8b
Mai 27 18:50:15 kevinix kernel: RSP: 002b:00000000005ecd30 EFLAGS: 00000293 
ORIG_RAX: 0000000000000011
Mai 27 18:50:15 kevinix kernel: RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007f3da396b03f
Mai 27 18:50:15 kevinix kernel: RDX: 0000000006292a00 RSI: 00000000071c1000 
RDI: 000000000000009d
Mai 27 18:50:15 kevinix kernel: RBP: 0000000006292a00 R08: 0000000000000000 
R09: 0000000000000000
Mai 27 18:50:15 kevinix kernel: R10: 0000000000000400 R11: 0000000000000293 
R12: 00007fffffbb43f0
Mai 27 18:50:15 kevinix kernel: R13: 0000000000000003 R14: 0000000000000012 
R15: 0000000000000400
Mai 27 18:50:15 kevinix kernel: Modules linked in: rfkill vmnet(OE) 
nls_iso8859_1 vfat fat zfs(POE) kvm_amd ccp rng_core zunicode(POE) zzstd(OE) 
kvm wmi_bmof snd_hda_codec_realtek snd_hda_codec_generic irqbypass zlua(OE) 
ledtrig_audio snd_hda_codec_hdmi crct10dif_pclmul zavl(POE) icp(POE) 
snd_hda_intel crc32_pclmul snd_intel_dspcfg soundwire_intel 
ghash_clmulni_intel soundwire_generic_allocation soundwire_cadence 
zcommon(POE) znvpair(POE) aesni_intel snd_hda_codec crypto_simd cryptd spl(OE) 
snd_usb_audio glue_helper snd_hda_core snd_usbmidi_lib soundwire_bus snd_hwdep 
snd_rawmidi snd_soc_core pcspkr snd_seq_device fam15h_power k10temp 
snd_compress mc ac97_bus snd_pcm_dmaengine sp5100_tco i2c_piix4 snd_pcm 
snd_timer mousedev snd alx soundcore mdio asus_atk0110 wmi mac_hid bridge 
acpi_cpufreq stp llc vmmon(OE) vmw_vmci vboxnetflt(OE) vboxnetadp(OE) nfsd 
auth_rpcgss vboxdrv(OE) nfs_acl lockd grace usbip_host usbip_core sunrpc sg 
crypto_user fuse nfs_ssc ip_tables x_tables ext4 crc32c_generic crc16 mbcache 
jbd2
Mai 27 18:50:15 kevinix kernel:  ata_generic pata_acpi nvidia_uvm(POE) 
nvidia_drm(POE) nvidia_modeset(POE) usbhid crc32c_intel drm_kms_helper 
syscopyarea sysfillrect sysimgblt fb_sys_fops cec pata_atiixp drm agpgart 
nvidia(POE) bcache crc64
Mai 27 18:50:15 kevinix kernel: ---[ end trace 7c38f1244f3084e2 ]---
Mai 27 18:50:15 kevinix kernel: RIP: 0010:bch_btree_insert_key+0x298/0x2a0 
[bcache]
Mai 27 18:50:15 kevinix kernel: Code: 8b 55 08 48 29 fa 25 ff ff 0f 00 0f 85 f9 
fd ff ff 45 31 c0 48 85 d2 0f 84 08 fe ff ff e9 f7 fd ff ff 48 89 c3 e9 2d ff ff ff 
<0f> 0b e8 71 83 e7 dc 90 0f 1f 44 00 00 48 8d 4f 18 e9 92 fc ff ff
Mai 27 18:50:15 kevinix kernel: RSP: 0018:ffffba4ec216b568 EFLAGS: 00010246
Mai 27 18:50:15 kevinix kernel: RAX: 9000001000000000 RBX: 0000000000000000 
RCX: ffff965e901bf0d8
Mai 27 18:50:15 kevinix kernel: RDX: ffffffffc01c27c0 RSI: 8000000000000000 RDI: 
0000000000000000
Mai 27 18:50:15 kevinix kernel: RBP: ffffba4ec216b768 R08: ffff965e8ca60000 R09: 
000007ffffffffff
Mai 27 18:50:15 kevinix kernel: R10: 000000000000000f R11: 0000000006018141 
R12: ffff965e8ac77000
Mai 27 18:50:15 kevinix kernel: R13: ffff965e901bf0c0 R14: ffff965e901bf0d8 R15: 
0000000000000000
Mai 27 18:50:15 kevinix kernel: FS:  00007f3da397f080(0000) 
GS:ffff96618ec80000(0000) knlGS:000000013ffe0000
Mai 27 18:50:15 kevinix kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Mai 27 18:50:15 kevinix kernel: CR2: 00000000074c0000 CR3: 0000000317650000 
CR4: 00000000000406e0
Mai 27 18:50:15 kevinix kernel: ------------[ cut here ]------------
Mai 27 18:50:15 kevinix kernel: WARNING: CPU: 2 PID: 4018 at kernel/exit.c:725 
do_exit+0x47/0xa20
Mai 27 18:50:15 kevinix kernel: Modules linked in: rfkill vmnet(OE) 
nls_iso8859_1 vfat fat zfs(POE) kvm_amd ccp rng_core zunicode(POE) zzstd(OE) 
kvm wmi_bmof snd_hda_codec_realtek snd_hda_codec_generic irqbypass zlua(OE) 
ledtrig_audio snd_hda_codec_hdmi crct10dif_pclmul zavl(POE) icp(POE) 
snd_hda_intel crc32_pclmul snd_intel_dspcfg soundwire_intel 
ghash_clmulni_intel soundwire_generic_allocation soundwire_cadence 
zcommon(POE) znvpair(POE) aesni_intel snd_hda_codec crypto_simd cryptd spl(OE) 
snd_usb_audio glue_helper snd_hda_core snd_usbmidi_lib soundwire_bus snd_hwdep 
snd_rawmidi snd_soc_core pcspkr snd_seq_device fam15h_power k10temp 
snd_compress mc ac97_bus snd_pcm_dmaengine sp5100_tco i2c_piix4 snd_pcm 
snd_timer mousedev snd alx soundcore mdio asus_atk0110 wmi mac_hid bridge 
acpi_cpufreq stp llc vmmon(OE) vmw_vmci vboxnetflt(OE) vboxnetadp(OE) nfsd 
auth_rpcgss vboxdrv(OE) nfs_acl lockd grace usbip_host usbip_core sunrpc sg 
crypto_user fuse nfs_ssc ip_tables x_tables ext4 crc32c_generic crc16 mbcache 
jbd2
Mai 27 18:50:15 kevinix kernel:  ata_generic pata_acpi nvidia_uvm(POE) 
nvidia_drm(POE) nvidia_modeset(POE) usbhid crc32c_intel drm_kms_helper 
syscopyarea sysfillrect sysimgblt fb_sys_fops cec pata_atiixp drm agpgart 
nvidia(POE) bcache crc64
Mai 27 18:50:15 kevinix kernel: CPU: 2 PID: 4018 Comm: EpicGamesLaunch 
Tainted: P      D    OE     5.10.39-1-lts #1
Mai 27 18:50:15 kevinix kernel: Hardware name: System manufacturer System 
Product Name/M5A78L-M LX3, BIOS 1101    01/17/2013
Mai 27 18:50:15 kevinix kernel: RIP: 0010:do_exit+0x47/0xa20
Mai 27 18:50:15 kevinix kernel: Code: ec 38 65 48 8b 04 25 28 00 00 00 48 89 
44 24 30 31 c0 48 8b 83 f0 07 00 00 48 85 c0 74 0e 48 8b 10 48 39 d0 0f 84 61 
04 00 00 <0f> 0b 65 8b 0d 90 a4 98 63 89 c8 25 00 ff ff 00 89 44 24 0c 0f 85
Mai 27 18:50:15 kevinix kernel: RSP: 0018:ffffba4ec216bee8 EFLAGS: 00010216
Mai 27 18:50:15 kevinix kernel: RAX: ffffba4ec216bcc0 RBX: ffff9660842cbd00 RCX: 
0000000000000027
Mai 27 18:50:15 kevinix kernel: RDX: ffff965e88f52d48 RSI: 0000000000000001 RDI: 
000000000000000b
Mai 27 18:50:15 kevinix kernel: RBP: 000000000000000b R08: 0000000000000000 
R09: ffffba4ec216b198
Mai 27 18:50:15 kevinix kernel: R10: ffffba4ec216b190 R11: ffffffff9e0cb228 R12: 
000000000000000b
Mai 27 18:50:15 kevinix kernel: R13: 0000000000000000 R14: ffff9660842cbd00 R15: 
0000000000000006
Mai 27 18:50:15 kevinix kernel: FS:  00007f3da397f080(0000) 
GS:ffff96618ec80000(0000) knlGS:000000013ffe0000
Mai 27 18:50:15 kevinix kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
Mai 27 18:50:15 kevinix kernel: CR2: 00000000074c0000 CR3: 0000000317650000 
CR4: 00000000000406e0
Mai 27 18:50:15 kevinix kernel: Call Trace:
Mai 27 18:50:15 kevinix kernel:  ? __x64_sys_pread64+0x8c/0xc0
Mai 27 18:50:15 kevinix kernel:  rewind_stack_do_exit+0x17/0x20
Mai 27 18:50:15 kevinix kernel: RIP: 0033:0x7f3da396b03f
Mai 27 18:50:15 kevinix kernel: Code: 08 89 3c 24 48 89 4c 24 18 e8 2d f4 ff ff 
4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 
0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 7d f4 ff ff 48 8b
Mai 27 18:50:15 kevinix kernel: RSP: 002b:00000000005ecd30 EFLAGS: 00000293 
ORIG_RAX: 0000000000000011
Mai 27 18:50:15 kevinix kernel: RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 
00007f3da396b03f
Mai 27 18:50:15 kevinix kernel: RDX: 0000000006292a00 RSI: 00000000071c1000 
RDI: 000000000000009d
Mai 27 18:50:15 kevinix kernel: RBP: 0000000006292a00 R08: 0000000000000000 
R09: 0000000000000000
Mai 27 18:50:15 kevinix kernel: R10: 0000000000000400 R11: 0000000000000293 
R12: 00007fffffbb43f0
Mai 27 18:50:15 kevinix kernel: R13: 0000000000000003 R14: 0000000000000012 
R15: 0000000000000400
Mai 27 18:50:15 kevinix kernel: ---[ end trace 7c38f1244f3084e3 ]---
Mai 27 18:52:06 kevinix PackageKit[1156]: daemon quit
Mai 27 18:52:06 kevinix systemd[1]: packagekit.service: Deactivated 
successfully.


