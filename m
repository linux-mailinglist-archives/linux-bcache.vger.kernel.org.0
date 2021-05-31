Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B2E39580A
	for <lists+linux-bcache@lfdr.de>; Mon, 31 May 2021 11:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhEaJZF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 May 2021 05:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhEaJZF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 May 2021 05:25:05 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAA1C061574
        for <linux-bcache@vger.kernel.org>; Mon, 31 May 2021 02:23:24 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id dj8so449494edb.6
        for <linux-bcache@vger.kernel.org>; Mon, 31 May 2021 02:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=pTxGEsubUZCwHh4Sz8clWfweJaz0THwbpR07rhWBZPI=;
        b=cF5EYSTOfSAFUeC1BeP06Twbpw6peArTyW1ayoxaq0rzNU4cswh7iOCvUcg3si6djk
         wdiu1ctf3bxMedmkFJSF+pdzGIDHxFj5RuWuYoGaZTTKBM9sWUIgBupd2V8p8H0MIJJM
         qIgqfjaY5RezQokHbYWgWoYzq0pd5pMj6d0ijsluK6/wSENARFNc3cR7nTibwdNSkg2m
         IGgFFxD8h6YkWCk4fQoN0uOYtgYUj7kQ09Stk5yDN68nwE9dHrSuDXPQ5flPtQmQLNGT
         VCDaSMiWgqJjLCjAJhaFGM0R5OYHpYobWpbjYMKyAiDznaGuV6GMCiH98Nj2/OO2frmh
         +EeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=pTxGEsubUZCwHh4Sz8clWfweJaz0THwbpR07rhWBZPI=;
        b=n/6X/f848AJaMZkK+Cgx68ElYtUXgXv/SEQwR5zVNW9+i9MTZHoP7MLCioVn2YPFSP
         fR9Nv5SwhvM9+xbvnl12IfvOrmxNYiT+64sDAXT3A12qf3OYg7o5bow4FKxd2a5jzd0Y
         9rYHbxfBdPSfv2c3XMw8pvJgF4RdxuPYeLUF6BQIdkaNw61CrBeGXdDBIduv1DNJFiOi
         ZCmN/nkfFM9PU/6WRgADMAQf/Txnq5DZqHrgRgwTOH1jiVUvgyStU1HCZY0eOcFXF9qy
         UvKT9m0MeGbL7BNm2XDp2D7r4B/oWkqcmCv+2y+CwK4Pf4dTusEt2YVz+gx01/F+CdEX
         U4eA==
X-Gm-Message-State: AOAM532QXi40rU58/+/B8i0GYaxOQUpJNJIxRpbi2ozSyDIZU1SRL0vr
        r6W85yq7D3s4cB/HYPQfpbOr8qXbZ5ZPPQ==
X-Google-Smtp-Source: ABdhPJzrjvFzZaV0/KPBSbzyRvok3Y9RfVoDa2rGsToOICJVWNUYhWBpLo3c4MR6xRAH36AScBe9FA==
X-Received: by 2002:a05:6402:1153:: with SMTP id g19mr24193427edw.179.1622453003100;
        Mon, 31 May 2021 02:23:23 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id p5sm5658123ejm.115.2021.05.31.02.23.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 02:23:22 -0700 (PDT)
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Subject: Re: [BCACHE KERNEL OOPS AND PANIC] System not boot on fedora 34 with
 5.12.5-6 kernel versions
To:     Giuseppe Della Bianca <giusdbg@gmail.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
References: <2214829.ElGaqSPkdT@exnet.gdb.it>
Message-ID: <00ff0a20-a620-d2d4-926e-e672d8b3d61e@rolffokkens.nl>
Date:   Mon, 31 May 2021 11:23:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <2214829.ElGaqSPkdT@exnet.gdb.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Ran into the same thing probably. More info here:
https://bugzilla.redhat.com/show_bug.cgi?id=1965809

The oops:

May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085344] kernel BUG at
block/bio.c:52!
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085352] invalid
opcode: 0000 [#1] SMP PTI
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085355] CPU: 3 PID:
2829 Comm: Xorg Tainted: P           OE     5.12.7-200.fc33.x86_64 #1
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085358] Hardware
name: System manufacturer System Product Name/PRIME B250M-A, BIOS 0614
04/18/2017
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085360] RIP:
0010:biovec_slab.part.0+0x5/0x10
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085364] Code: b1 3a
04 00 48 83 3b 00 74 08 48 89 df e8 f3 fe ff ff 48 c7 03 00 00 00 00 5b
c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <0f> 0b 66 0f 1f 84 00
00 00 00 00 0f 1f 44 00 00 48 83 7f 40 00 75
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085366] RSP:
0000:ffffc0cc82a33780 EFLAGS: 00010212
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085369] RAX:
0000000000000081 RBX: ffffc0cc82a337b4 RCX: 00000000000000e8
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085370] RDX:
0000000000000800 RSI: ffffc0cc82a337b4 RDI: ffff9e060c300118
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085372] RBP:
0000000000000800 R08: ffff9e060c300118 R09: ffff9e060e5334d8
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085373] R10:
ffff9e060e228570 R11: 0000000000000001 R12: ffff9e060c300118
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085375] R13:
0000000000000800 R14: 0000000000000800 R15: ffff9e060c3000d0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085376] FS: 
00007f7d034eaa80(0000) GS:ffff9e0926d80000(0000) knlGS:0000000000000000
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085378] CS:  0010 DS:
0000 ES: 0000 CR0: 0000000080050033
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085380] CR2:
00007f7d0170ea4c CR3: 0000000118d5a006 CR4: 00000000003706e0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085382] Call Trace:
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085384] 
bvec_alloc+0x90/0xc0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085388] 
bio_alloc_bioset+0x1b3/0x260
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085391] 
cached_dev_cache_miss+0xf6/0x2f0 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085409] 
cache_lookup_fn+0xf2/0x2e0 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085419]  ?
bch_btree_iter_next_filter+0x1ad/0x2e0 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085427]  ?
bch_ptr_invalid+0x10/0x10 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085435]  ?
bch_data_invalidate+0x160/0x160 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085443] 
bch_btree_map_keys_recurse+0x70/0x170 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085452]  ?
bch_btree_node_get.part.0+0x190/0x2c0 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085460]  ?
rwsem_mark_wake+0x2a0/0x2a0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085462]  ?
bch_data_invalidate+0x160/0x160 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085471] 
bch_btree_map_keys_recurse+0xd7/0x170 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085479]  ?
mempool_alloc+0x5b/0x150
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085540] 
bch_btree_map_keys+0x163/0x1b0 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085548]  ?
bch_data_invalidate+0x160/0x160 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085557] 
cache_lookup+0x93/0x140 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085565] 
cached_dev_submit_bio+0x9f3/0xd60 [bcache]
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085574]  ?
dm_submit_bio+0x187/0x3d0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085577]  ?
blk_queue_enter+0x181/0x230
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085580] 
submit_bio_noacct+0x112/0x4d0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085584] 
ext4_mpage_readpages+0x33f/0xb00
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085588]  ?
__mod_memcg_lruvec_state+0x22/0xe0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085591]  ?
__add_to_page_cache_locked+0x1da/0x430
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085594] 
read_pages+0x5d/0x2c0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085596] 
page_cache_ra_unbounded+0x1ab/0x230
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085599] 
filemap_fault+0x694/0xa60
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085602]  ?
__alloc_pages_nodemask+0x16c/0x340
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085606] 
ext4_filemap_fault+0x2d/0x40
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085608] 
__do_fault+0x36/0x100
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085611] 
__handle_mm_fault+0x6ca/0x15d0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085614] 
handle_mm_fault+0xd5/0x2b0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085616] 
do_user_addr_fault+0x1ba/0x690
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085619]  ?
ksys_mmap_pgoff+0x102/0x220
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085622] 
exc_page_fault+0x67/0x150
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085625]  ?
asm_exc_page_fault+0x8/0x30
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085642] 
asm_exc_page_fault+0x1e/0x30
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085644] RIP:
0033:0x7f7d04306ea3
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085646] Code: 0f 7f
44 17 f0 f3 0f 7f 07 c3 48 83 fa 40 77 16 f3 0f 7f 07 f3 0f 7f 47 10 f3
0f 7f 44 17 f0 f3 0f 7f 44 17 e0 c3 48 8d 4f 40 <f3> 0f 7f 07 48 83 e1
c0 f3 0f 7f 44 17 f0 f3 0f 7f 47 10 f3 0f 7f
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085648] RSP:
002b:00007ffd525db8a8 EFLAGS: 00010206
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085650] RAX:
00007f7d0170ea4c RBX: 0000000000000002 RCX: 00007f7d0170ea8c
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085652] RDX:
00000000000005b4 RSI: 0000000000000000 RDI: 00007f7d0170ea4c
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085667] RBP:
00007ffd525dbb60 R08: 00007f7d0170ea4c R09: 00000000016f9000
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085669] R10:
0000000000000003 R11: 0000000000000206 R12: 0000559d50818840
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085670] R13:
00007ffd525db8e0 R14: 00007f7d0170f000 R15: 0000000000000000
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085673] Modules
linked in: xt_CHECKSUM xt_MASQUERADE nf_nat_tftp nf_conntrack_tftp xt_CT
tun bridge stp llc netconsole cfg80211 ip6t_REJECT nf_reject_ipv6
ip6t_rpfilter ipt_REJECT nf_reject_ipv4 xt_conntrack ebtable_nat
ebtable_broute ip6table_nat ip6table_mangle ip6table_raw
ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 iptable_mangle iptable_raw iptable_security ip_set
nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables
iptable_filter nct6775 hwmon_vid lm92 sunrpc nvidia_drm(POE)
nvidia_modeset(POE) intel_rapl_msr intel_rapl_common raid1 uvcvideo
x86_pkg_temp_thermal intel_powerclamp coretemp videobuf2_vmalloc ee1004
ppdev videobuf2_memops mei_hdcp videobuf2_v4l2 iTCO_wdt intel_pmc_bxt
iTCO_vendor_support kvm_intel snd_usb_audio videobuf2_common kvm
videodev snd_usbmidi_lib snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_codec_hdmi ledtrig_audio snd_rawmidi snd_hda_intel nvidia(POE)
snd_intel_dspcfg snd_intel_sdw_acpi joydev mc
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085710]  irqbypass
snd_hda_codec snd_hda_core rapl snd_hwdep intel_cstate snd_seq
intel_uncore snd_seq_device eeepc_wmi asus_wmi snd_pcm sparse_keymap
rfkill pcspkr wmi_bmof snd_timer i2c_i801 i2c_smbus drm_kms_helper snd
cec soundcore parport_pc parport mei_me mei acpi_pad essiv authenc drm
binfmt_misc ip_tables dm_crypt trusted raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx bcache crc64 mxm_wmi
crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw
nvme r8169 nvme_core wmi video fuse ecryptfs
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085747] ---[ end
trace 06c92d68c51b74c5 ]---
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085749] RIP:
0010:biovec_slab.part.0+0x5/0x10
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085752] Code: b1 3a
04 00 48 83 3b 00 74 08 48 89 df e8 f3 fe ff ff 48 c7 03 00 00 00 00 5b
c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <0f> 0b 66 0f 1f 84 00
00 00 00 00 0f 1f 44 00 00 48 83 7f 40 00 75
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085755] RSP:
0000:ffffc0cc82a33780 EFLAGS: 00010212
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085756] RAX:
0000000000000081 RBX: ffffc0cc82a337b4 RCX: 00000000000000e8
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085758] RDX:
0000000000000800 RSI: ffffc0cc82a337b4 RDI: ffff9e060c300118
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085759] RBP:
0000000000000800 R08: ffff9e060c300118 R09: ffff9e060e5334d8
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085761] R10:
ffff9e060e228570 R11: 0000000000000001 R12: ffff9e060c300118
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085762] R13:
0000000000000800 R14: 0000000000000800 R15: ffff9e060c3000d0
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085764] FS: 
00007f7d034eaa80(0000) GS:ffff9e0926d80000(0000) knlGS:0000000000000000
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085788] CS:  0010 DS:
0000 ES: 0000 CR0: 0000000080050033
May 31 10:57:20 home07.rolf-en-monique.lan  [   40.085846] CR2:
00007f7d0170ea4c CR3: 0000000118d5a006 CR4: 00000000003706e0


On 5/25/21 11:04 PM, Giuseppe Della Bianca wrote:
> Hi.
>
> On fedora 34 with 5.12.5-6 kernel version, kernel oops and panic on
> booting when accessing the nvme cache device (I don't know a way to
> report the many kernel messages, the system won't boot).
>
> Detaching the cache device from the bcache device, the system boot.
>
> gdb
>
>


