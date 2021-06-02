Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7B7398583
	for <lists+linux-bcache@lfdr.de>; Wed,  2 Jun 2021 11:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbhFBJr2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Jun 2021 05:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhFBJr0 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Jun 2021 05:47:26 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95526C061574
        for <linux-bcache@vger.kernel.org>; Wed,  2 Jun 2021 02:45:43 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id c10so2857300eja.11
        for <linux-bcache@vger.kernel.org>; Wed, 02 Jun 2021 02:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Q1s1oM8+GaWzX0loTd9mGwyV8+bYfahIjRVZtwRPpBE=;
        b=FB0uA6DPacWFyEr9+5Vb+5YhM3rrI/IwdcaxLVl15MnzA/LDfXhr7yWrjR+ij60QoC
         1lznDPvjMU6QDwch5M80RECODVgKkCY6UkQddRklhhqH1Y7Oan3mp32Uf0tf8gK8fIjc
         F/aNeNAhy56NUkkuS5gyWSuMIADQz0L39155Ddw5JLO49yk79JFwKBVArfHi06Hv7BxS
         sP8RIIIdpyud6DGwmUkbwNOEPD/ihddgqpHiaZjfx4AbzHZN+qrj4B77oz13clee8cKA
         OWUqbje/eaH+SlhczTiMthY86aqjT0B1+1OR01Lx6hGpqtNtTOeV+wme9XdU1HamTozJ
         jw/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Q1s1oM8+GaWzX0loTd9mGwyV8+bYfahIjRVZtwRPpBE=;
        b=FwO++ChFxITry0ApdW3W0ZpQdAb2GopK+QK65/uE9koQmqb8zH26v/zeJpJiD3Tkwg
         CrF3zCjYS7RQE4IiQ8G+EuVsoMfONYxzvZeXzuANVUu3nL17U8/+wPv/woaSbgCr47Fb
         Hl729aut+h/PJ1p9gEh1LXoaFsZgER2iIC+BXFXgYBJV84sdab33iKVyv4kYE5dL12d8
         MHqFZ1kgWUdFDsDLwcM2xULqP0Or/kWEWUIN+B+em065SJCgFJhfO6FbAWkdEDxRnTU9
         1rLYnZy1jXtKmWhCoyLy8//uFLVA3xowhms5I61E8Lqz6AY5HYchZYupSHYRYu0tdwq2
         oS2A==
X-Gm-Message-State: AOAM533LJZ/++CniRqHKVH80ZSZmnrD4zle8svwA+rq0/+4NvaXxqS6M
        uImqOv78WUOm5hAn7fXUwwVfLUhO+QI6Mg==
X-Google-Smtp-Source: ABdhPJwveMws9LeS8imxa6oOzeo384cLO1e1IbYkGpVn06sLmPTysAF/cx6r5Q2yRM4vzm1Flfmypw==
X-Received: by 2002:a17:906:268c:: with SMTP id t12mr32824368ejc.441.1622627141776;
        Wed, 02 Jun 2021 02:45:41 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id f21sm988391edr.45.2021.06.02.02.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 02:45:41 -0700 (PDT)
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Thorsten Knabe <linux@thorsten-knabe.de>, Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
Date:   Wed, 2 Jun 2021 11:45:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coli,

Things are stable so far, looks really promising:

bash-5.0$ cat /proc/version
Linux version 5.12.8-200.rf.fc33.x86_64
(mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
(Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
23:10:39 CEST 2021
bash-5.0$ uptime
 11:42:05 up 12:01,  1 user,  load average: 0.84, 2.43, 3.20
bash-5.0$

I left the system running during the night, and have been using it
actively for 3 hours now.

I'll keep you posted if anything changes, but this is a major step
forward for sure (before your patches the system would freeze in minutes
after booting).

Rolf

On 6/2/21 10:33 AM, Thorsten Knabe wrote:
> Hello Coly.
>
> On 6/1/21 5:34 PM, Coly Li wrote:
>> On 5/31/21 5:37 PM, Rolf Fokkens wrote:
>>> Same here, more details: https://bugzilla.redhat.com/show_bug.cgi?id=1965809
>> Could you please try these attached patches ? I'd like to have more
>> confirmation before submitting to Jens.
> Running 5.12.8 + your v5 patches for a few hours now on that degraded
> RAID-6 system without any issues. If anything changes, I'll let you know.
>
> Thorsten
>> Thanks.
>>
>> Coly Li
>>
>>
>>
>>> On 5/15/21 9:06 PM, Thorsten Knabe wrote:
>>>> Hello.
>>>>
>>>> Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
>>>> usage.
>>>>
>>>> Linux up to 5.11.x is not affected by this bug.
>>>>
>>>> Environment:
>>>> - Debian 10 AMD 64
>>>> - Kernel 5.12 - 5.12.4
>>>> - Filesystem ext4
>>>> - Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
>>>>   (unsure if the degraded RAID-6 has an effect or not)
>>>> - Cache device: Single SSD
>>>>
>>>> Kernel log:
>>>>
>>>> May 12 20:22:24 tek04 kernel: nr_vecs=472
>>>> May 12 20:22:24 tek04 kernel: ------------[ cut here ]------------
>>>> May 12 20:22:24 tek04 kernel: kernel BUG at block/bio.c:53!
>>>> May 12 20:22:24 tek04 kernel: invalid opcode: 0000 [#1] PREEMPT SMP PTI
>>>> May 12 20:22:24 tek04 kernel: CPU: 1 PID: 1670 Comm: grep Tainted: G
>>>>       I       5.12.3 #2
>>>> May 12 20:22:24 tek04 kernel: Hardware name: To Be Filled By O.E.M. To
>>>> Be Filled By O.E.M./X58 Deluxe, BIOS P2.20 10/30/2009
>>>> May 12 20:22:24 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
>>>> May 12 20:22:24 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
>>>> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
>>>> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
>>>> e8 d4 80 fe ff
>>>> May 12 20:22:24 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
>>>> May 12 20:22:24 tek04 kernel: RAX: 000000000000000b RBX:
>>>> ffffc9000274b764 RCX: 0000000000000000
>>>> May 12 20:22:24 tek04 kernel: bch_count_backing_io_errors: 1 callbacks
>>>> suppressed
>>>> May 12 20:22:24 tek04 kernel: bcache: bch_count_backing_io_errors() md1:
>>>> Read-ahead I/O failed on backing device, ignore
>>>> May 12 20:22:24 tek04 kernel: RDX: ffff888333c5e400 RSI:
>>>> ffff888333c57480 RDI: ffff888333c57480
>>>> May 12 20:22:24 tek04 kernel: RBP: 0000000000000800 R08:
>>>> 0000000000000000 R09: c0000000ffffdfff
>>>> May 12 20:22:24 tek04 kernel: R10: ffffc9000274b580 R11:
>>>> ffffc9000274b578 R12: ffff8881170f0118
>>>> May 12 20:22:24 tek04 kernel: R13: ffff888109911b00 R14:
>>>> ffff8881170f00d0 R15: 0000000000000800
>>>> May 12 20:22:24 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
>>>> GS:ffff888333c40000(0000) knlGS:0000000000000000
>>>> May 12 20:22:24 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>> 0000000080050033
>>>> May 12 20:22:24 tek04 kernel: CR2: 00005628963f4fd0 CR3:
>>>> 000000016c43c000 CR4: 00000000000006e0
>>>> May 12 20:22:24 tek04 kernel: Call Trace:
>>>> May 12 20:22:24 tek04 kernel:  bvec_alloc+0x22/0x90
>>>> May 12 20:22:24 tek04 kernel:  bio_alloc_bioset+0x176/0x230
>>>> May 12 20:22:24 tek04 kernel:  cached_dev_cache_miss+0x1a8/0x300
>>>> May 12 20:22:24 tek04 kernel:  cache_lookup_fn+0x110/0x2e0
>>>> May 12 20:22:24 tek04 kernel:  ? bch_ptr_invalid+0x10/0x10
>>>> May 12 20:22:24 tek04 kernel:  ? bch_btree_iter_next_filter+0x1af/0x2d0
>>>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>>>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0x69/0x160
>>>> May 12 20:22:24 tek04 kernel:  ? __bch_bset_search+0x315/0x440
>>>> May 12 20:22:24 tek04 kernel:  ? downgrade_write+0xb0/0xb0
>>>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>>>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0xcf/0x160
>>>> May 12 20:22:24 tek04 kernel:  ? raid5_make_request+0x5c4/0xaa0
>>>> May 12 20:22:24 tek04 kernel:  ? recalibrate_cpu_khz+0x10/0x10
>>>> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x30/0x400
>>>> May 12 20:22:24 tek04 kernel:  ? rwsem_wake.isra.11+0x80/0x80
>>>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys+0xf2/0x140
>>>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>>>> May 12 20:22:24 tek04 kernel:  cache_lookup+0xb1/0x190
>>>> May 12 20:22:24 tek04 kernel:  cached_dev_submit_bio+0x9ab/0xc90
>>>> May 12 20:22:24 tek04 kernel:  ? submit_bio_checks+0x197/0x4a0
>>>> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x3b7/0x400
>>>> May 12 20:22:24 tek04 kernel:  submit_bio_noacct+0x10e/0x4c0
>>>> May 12 20:22:24 tek04 kernel:  submit_bio+0x2e/0x160
>>>> May 12 20:22:24 tek04 kernel:  ? xa_load+0x66/0x70
>>>> May 12 20:22:24 tek04 kernel:  ? bio_add_page+0x2f/0x70
>>>> May 12 20:22:24 tek04 kernel:  ext4_mpage_readpages+0x1ae/0xa00
>>>> May 12 20:22:24 tek04 kernel:  ? __mod_lruvec_state+0x29/0x60
>>>> May 12 20:22:24 tek04 kernel:  read_pages+0x78/0x1d0
>>>> May 12 20:22:24 tek04 kernel:  page_cache_ra_unbounded+0x127/0x1b0
>>>> May 12 20:22:24 tek04 kernel:  filemap_get_pages+0x1d0/0x4a0
>>>> May 12 20:22:24 tek04 kernel:  filemap_read+0x91/0x2d0
>>>> May 12 20:22:24 tek04 kernel:  new_sync_read+0x103/0x180
>>>> May 12 20:22:24 tek04 kernel:  vfs_read+0x11b/0x1b0
>>>> May 12 20:22:24 tek04 kernel:  ksys_read+0x55/0xd0
>>>> May 12 20:22:24 tek04 kernel:  do_syscall_64+0x33/0x80
>>>> May 12 20:22:24 tek04 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>> May 12 20:22:24 tek04 kernel: RIP: 0033:0x7f3a1cb89461
>>>> May 12 20:22:24 tek04 kernel: Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8
>>>> e9 03 02 00 66 0f 1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0
>>>> 75 13 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54
>>>> 49 89 d4 55 48
>>>> May 12 20:22:24 tek04 kernel: RSP: 002b:00007fff4052fff8 EFLAGS:
>>>> 00000246 ORIG_RAX: 0000000000000000
>>>> May 12 20:22:24 tek04 kernel: RAX: ffffffffffffffda RBX:
>>>> 0000000000018000 RCX: 00007f3a1cb89461
>>>> May 12 20:22:24 tek04 kernel: RDX: 0000000000018000 RSI:
>>>> 000055ff0d01a000 RDI: 0000000000000004
>>>> May 12 20:22:24 tek04 kernel: RBP: 0000000000018000 R08:
>>>> 0000000000000002 R09: 000055ff0d0194b0
>>>> May 12 20:22:24 tek04 kernel: R10: 0000000000000000 R11:
>>>> 0000000000000246 R12: 000055ff0d01a000
>>>> May 12 20:22:24 tek04 kernel: R13: 0000000000000004 R14:
>>>> 000055ff0d0194b0 R15: 0000000000000004
>>>> May 12 20:22:24 tek04 kernel: Modules linked in: cmac bnep
>>>> intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic btusb
>>>> ledtrig_audio snd_hda_codec_hdmi btrtl kvm_intel snd_hda_intel btbcm
>>>> snd_intel_dspcfg btintel kvm snd_hda_codec irqbypass bluetooth serio_raw
>>>> pcspkr hfcpci snd_hda_core iTCO_wdt evdev input_leds joydev sg snd_hwdep
>>>> intel_pmc_bxt ecdh_generic rfkill iTCO_vendor_support mISDN_core ecc
>>>> snd_pcm snd_timer tiny_power_button snd soundcore button i7core_edac
>>>> acpi_cpufreq wmi nft_counter nf_log_ipv6 nf_log_ipv
>>>> May 12 20:22:24 tek04 kernel: ---[ end trace 9a03f30c7b4aa246 ]---
>>>> May 12 20:22:25 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
>>>> May 12 20:22:25 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
>>>> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
>>>> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
>>>> e8 d4 80 fe ff
>>>> May 12 20:22:25 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
>>>> May 12 20:22:25 tek04 kernel: RAX: 000000000000000b RBX:
>>>> ffffc9000274b764 RCX: 0000000000000000
>>>> May 12 20:22:25 tek04 kernel: RDX: ffff888333c5e400 RSI:
>>>> ffff888333c57480 RDI: ffff888333c57480
>>>> May 12 20:22:25 tek04 kernel: RBP: 0000000000000800 R08:
>>>> 0000000000000000 R09: c0000000ffffdfff
>>>> May 12 20:22:25 tek04 kernel: R10: ffffc9000274b580 R11:
>>>> ffffc9000274b578 R12: ffff8881170f0118
>>>> May 12 20:22:25 tek04 kernel: R13: ffff888109911b00 R14:
>>>> ffff8881170f00d0 R15: 0000000000000800
>>>> May 12 20:22:25 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
>>>> GS:ffff888333c40000(0000) knlGS:0000000000000000
>>>> May 12 20:22:25 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>>>> 0000000080050033
>>>> May 12 20:22:25 tek04 kernel: CR2: 00005628963f4fd0 CR3:
>>>> 000000016c43c000 CR4: 00000000000006e0
>>>>
>>>> A printk has been added to line 52 of block/bio.c to dump the nr_vecs
>>>> variable to the kernel log before the BUG(). Obviously nr_vecs (472
>>>> logged) is bigger than expected by bvec_alloc/bio_alloc_bioset (max
>>>> 256), which finally triggers the BUG().
>>>>
>>>> Removing the BUG() from line 52 of block/bio.c, thus basically restoring
>>>> the Linux 5.11.x behavior of bvec_alloc/bio_alloc_bioset to just return
>>>> NULL, when nr_vecs is too big seems to resolve the issue.
>>>>
>>>> Regards
>>>> Thorsten
>>>>
>

