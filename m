Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B853A395831
	for <lists+linux-bcache@lfdr.de>; Mon, 31 May 2021 11:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbhEaJin (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 31 May 2021 05:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhEaJin (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 31 May 2021 05:38:43 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B167AC061574
        for <linux-bcache@vger.kernel.org>; Mon, 31 May 2021 02:37:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b11so5941732edy.4
        for <linux-bcache@vger.kernel.org>; Mon, 31 May 2021 02:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=fxGXlbNCX2sVhaalVF25+gaYVT2oNT13xFgo+6Qr1Ec=;
        b=OxxwsoQBbRPPJgGvk1Np9J4dlM8tIowzqtA0/wC/WQAEqUsS255HmDZMCt1FIEV56L
         ToML1K+QWj/wK0wAxXmTsc9XeKIj4b8Y0jJ43zQ06+2VQDVv4+PfYmiScSMCqHpqrbi7
         1atDYptI0aEQTu2WAxuRPhzkayFVdMXgBLalqXzBonbU8ClCqPORxnYImUQgL8TbhQwG
         Y/7Kmv6oB0DMNRjbJ+DmgHsZzgtwFTrydCZlVu5s0BvbOktQLsjSDS63nSsNysAI/zV9
         FvAl8VlBDE4Qt01V+WRAZ2MTadcbeXyXbqNjxyhZ+yZ6YWllT2v0kH8IjBkl7pTYHf1W
         m74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=fxGXlbNCX2sVhaalVF25+gaYVT2oNT13xFgo+6Qr1Ec=;
        b=KsOiMHoCPjxoWUvYmWpT+t1YbeX4NcvFnB2YE6OyT605aUSflC2nhdVUVQ8WXMH7bY
         6PDjd8M0K0B80pig7mwEpuP1g3OaDK7u06y5Iw9A5/wCzb/tZ/qgTa85xueStUOQzJgt
         enrs2FwLWE+sPyia06cR078FU7liolkOWmkMkYmrNkaucNLH01O2bsrMaVt6M5g4qNcG
         79si7GrtSIjnQZlpxUb1fGLf3zQhFNT8xnPxttmyfqHTSNcXdYVACokxYGJGUhFrJt2M
         IIW9B+kzjl0jrKBxxVzmhaJAHyTnhgHy98yvKJrjVrnJYSQmDGmfAUBRxpBxQnYZl1eh
         vkgg==
X-Gm-Message-State: AOAM531ItBNCuEXjkZwuPHBxLlUC4oRP/HD3I/mn/SYGx+bYm/ubxGhu
        l9QOMmGNA1BKJrg77ZDYTLzjyC/hwxYNIw==
X-Google-Smtp-Source: ABdhPJyHncXY6N+ZJMJ8sLJ7slh+wjemcl5yQSW+oFU2Gw/A270bJHFjIJ6p2MM8kYmyqHPNigcy1A==
X-Received: by 2002:a05:6402:274b:: with SMTP id z11mr6096323edd.225.1622453821974;
        Mon, 31 May 2021 02:37:01 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id u17sm3979946edx.16.2021.05.31.02.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 02:37:01 -0700 (PDT)
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Thorsten Knabe <linux@thorsten-knabe.de>,
        linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
Date:   Mon, 31 May 2021 11:37:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Same here, more details: https://bugzilla.redhat.com/show_bug.cgi?id=1965809

On 5/15/21 9:06 PM, Thorsten Knabe wrote:
> Hello.
>
> Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
> usage.
>
> Linux up to 5.11.x is not affected by this bug.
>
> Environment:
> - Debian 10 AMD 64
> - Kernel 5.12 - 5.12.4
> - Filesystem ext4
> - Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
>   (unsure if the degraded RAID-6 has an effect or not)
> - Cache device: Single SSD
>
> Kernel log:
>
> May 12 20:22:24 tek04 kernel: nr_vecs=472
> May 12 20:22:24 tek04 kernel: ------------[ cut here ]------------
> May 12 20:22:24 tek04 kernel: kernel BUG at block/bio.c:53!
> May 12 20:22:24 tek04 kernel: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> May 12 20:22:24 tek04 kernel: CPU: 1 PID: 1670 Comm: grep Tainted: G
>       I       5.12.3 #2
> May 12 20:22:24 tek04 kernel: Hardware name: To Be Filled By O.E.M. To
> Be Filled By O.E.M./X58 Deluxe, BIOS P2.20 10/30/2009
> May 12 20:22:24 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
> May 12 20:22:24 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
> e8 d4 80 fe ff
> May 12 20:22:24 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
> May 12 20:22:24 tek04 kernel: RAX: 000000000000000b RBX:
> ffffc9000274b764 RCX: 0000000000000000
> May 12 20:22:24 tek04 kernel: bch_count_backing_io_errors: 1 callbacks
> suppressed
> May 12 20:22:24 tek04 kernel: bcache: bch_count_backing_io_errors() md1:
> Read-ahead I/O failed on backing device, ignore
> May 12 20:22:24 tek04 kernel: RDX: ffff888333c5e400 RSI:
> ffff888333c57480 RDI: ffff888333c57480
> May 12 20:22:24 tek04 kernel: RBP: 0000000000000800 R08:
> 0000000000000000 R09: c0000000ffffdfff
> May 12 20:22:24 tek04 kernel: R10: ffffc9000274b580 R11:
> ffffc9000274b578 R12: ffff8881170f0118
> May 12 20:22:24 tek04 kernel: R13: ffff888109911b00 R14:
> ffff8881170f00d0 R15: 0000000000000800
> May 12 20:22:24 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
> GS:ffff888333c40000(0000) knlGS:0000000000000000
> May 12 20:22:24 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 12 20:22:24 tek04 kernel: CR2: 00005628963f4fd0 CR3:
> 000000016c43c000 CR4: 00000000000006e0
> May 12 20:22:24 tek04 kernel: Call Trace:
> May 12 20:22:24 tek04 kernel:  bvec_alloc+0x22/0x90
> May 12 20:22:24 tek04 kernel:  bio_alloc_bioset+0x176/0x230
> May 12 20:22:24 tek04 kernel:  cached_dev_cache_miss+0x1a8/0x300
> May 12 20:22:24 tek04 kernel:  cache_lookup_fn+0x110/0x2e0
> May 12 20:22:24 tek04 kernel:  ? bch_ptr_invalid+0x10/0x10
> May 12 20:22:24 tek04 kernel:  ? bch_btree_iter_next_filter+0x1af/0x2d0
> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0x69/0x160
> May 12 20:22:24 tek04 kernel:  ? __bch_bset_search+0x315/0x440
> May 12 20:22:24 tek04 kernel:  ? downgrade_write+0xb0/0xb0
> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0xcf/0x160
> May 12 20:22:24 tek04 kernel:  ? raid5_make_request+0x5c4/0xaa0
> May 12 20:22:24 tek04 kernel:  ? recalibrate_cpu_khz+0x10/0x10
> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x30/0x400
> May 12 20:22:24 tek04 kernel:  ? rwsem_wake.isra.11+0x80/0x80
> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys+0xf2/0x140
> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
> May 12 20:22:24 tek04 kernel:  cache_lookup+0xb1/0x190
> May 12 20:22:24 tek04 kernel:  cached_dev_submit_bio+0x9ab/0xc90
> May 12 20:22:24 tek04 kernel:  ? submit_bio_checks+0x197/0x4a0
> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x3b7/0x400
> May 12 20:22:24 tek04 kernel:  submit_bio_noacct+0x10e/0x4c0
> May 12 20:22:24 tek04 kernel:  submit_bio+0x2e/0x160
> May 12 20:22:24 tek04 kernel:  ? xa_load+0x66/0x70
> May 12 20:22:24 tek04 kernel:  ? bio_add_page+0x2f/0x70
> May 12 20:22:24 tek04 kernel:  ext4_mpage_readpages+0x1ae/0xa00
> May 12 20:22:24 tek04 kernel:  ? __mod_lruvec_state+0x29/0x60
> May 12 20:22:24 tek04 kernel:  read_pages+0x78/0x1d0
> May 12 20:22:24 tek04 kernel:  page_cache_ra_unbounded+0x127/0x1b0
> May 12 20:22:24 tek04 kernel:  filemap_get_pages+0x1d0/0x4a0
> May 12 20:22:24 tek04 kernel:  filemap_read+0x91/0x2d0
> May 12 20:22:24 tek04 kernel:  new_sync_read+0x103/0x180
> May 12 20:22:24 tek04 kernel:  vfs_read+0x11b/0x1b0
> May 12 20:22:24 tek04 kernel:  ksys_read+0x55/0xd0
> May 12 20:22:24 tek04 kernel:  do_syscall_64+0x33/0x80
> May 12 20:22:24 tek04 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> May 12 20:22:24 tek04 kernel: RIP: 0033:0x7f3a1cb89461
> May 12 20:22:24 tek04 kernel: Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8
> e9 03 02 00 66 0f 1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0
> 75 13 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54
> 49 89 d4 55 48
> May 12 20:22:24 tek04 kernel: RSP: 002b:00007fff4052fff8 EFLAGS:
> 00000246 ORIG_RAX: 0000000000000000
> May 12 20:22:24 tek04 kernel: RAX: ffffffffffffffda RBX:
> 0000000000018000 RCX: 00007f3a1cb89461
> May 12 20:22:24 tek04 kernel: RDX: 0000000000018000 RSI:
> 000055ff0d01a000 RDI: 0000000000000004
> May 12 20:22:24 tek04 kernel: RBP: 0000000000018000 R08:
> 0000000000000002 R09: 000055ff0d0194b0
> May 12 20:22:24 tek04 kernel: R10: 0000000000000000 R11:
> 0000000000000246 R12: 000055ff0d01a000
> May 12 20:22:24 tek04 kernel: R13: 0000000000000004 R14:
> 000055ff0d0194b0 R15: 0000000000000004
> May 12 20:22:24 tek04 kernel: Modules linked in: cmac bnep
> intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic btusb
> ledtrig_audio snd_hda_codec_hdmi btrtl kvm_intel snd_hda_intel btbcm
> snd_intel_dspcfg btintel kvm snd_hda_codec irqbypass bluetooth serio_raw
> pcspkr hfcpci snd_hda_core iTCO_wdt evdev input_leds joydev sg snd_hwdep
> intel_pmc_bxt ecdh_generic rfkill iTCO_vendor_support mISDN_core ecc
> snd_pcm snd_timer tiny_power_button snd soundcore button i7core_edac
> acpi_cpufreq wmi nft_counter nf_log_ipv6 nf_log_ipv
> May 12 20:22:24 tek04 kernel: ---[ end trace 9a03f30c7b4aa246 ]---
> May 12 20:22:25 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
> May 12 20:22:25 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
> e8 d4 80 fe ff
> May 12 20:22:25 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
> May 12 20:22:25 tek04 kernel: RAX: 000000000000000b RBX:
> ffffc9000274b764 RCX: 0000000000000000
> May 12 20:22:25 tek04 kernel: RDX: ffff888333c5e400 RSI:
> ffff888333c57480 RDI: ffff888333c57480
> May 12 20:22:25 tek04 kernel: RBP: 0000000000000800 R08:
> 0000000000000000 R09: c0000000ffffdfff
> May 12 20:22:25 tek04 kernel: R10: ffffc9000274b580 R11:
> ffffc9000274b578 R12: ffff8881170f0118
> May 12 20:22:25 tek04 kernel: R13: ffff888109911b00 R14:
> ffff8881170f00d0 R15: 0000000000000800
> May 12 20:22:25 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
> GS:ffff888333c40000(0000) knlGS:0000000000000000
> May 12 20:22:25 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033
> May 12 20:22:25 tek04 kernel: CR2: 00005628963f4fd0 CR3:
> 000000016c43c000 CR4: 00000000000006e0
>
> A printk has been added to line 52 of block/bio.c to dump the nr_vecs
> variable to the kernel log before the BUG(). Obviously nr_vecs (472
> logged) is bigger than expected by bvec_alloc/bio_alloc_bioset (max
> 256), which finally triggers the BUG().
>
> Removing the BUG() from line 52 of block/bio.c, thus basically restoring
> the Linux 5.11.x behavior of bvec_alloc/bio_alloc_bioset to just return
> NULL, when nr_vecs is too big seems to resolve the issue.
>
> Regards
> Thorsten
>

