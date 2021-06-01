Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D403976C9
	for <lists+linux-bcache@lfdr.de>; Tue,  1 Jun 2021 17:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhFAPgq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 1 Jun 2021 11:36:46 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60222 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhFAPgp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 1 Jun 2021 11:36:45 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7E4132194A;
        Tue,  1 Jun 2021 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622561703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3+xxoUWRmVhfm3r2Asao3rj7Jc1IUbsH2zgezNGpjg=;
        b=Pfj6w4vFLBO5UX11zlPX3twVGrD7Fsusu3GXEMPrvDGLRgmEHMBaBRgn6CMJf7OZw7+RQU
        56oUDfk9zrKJrWqQnXBWF13p1043H73kuH8rWR/xlVqxgiWtTm0dfAsbH5/4UyPqGnr8Vb
        6ctpcqR+OuQtxt6Oyw+Sd9emEndUwrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622561703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3+xxoUWRmVhfm3r2Asao3rj7Jc1IUbsH2zgezNGpjg=;
        b=dxuMabDTAU5Yra2QbYzPwexG1YT59zkj2uBWx88YtVNBHaqzAwbDoCa/ljk9EOqYkwe6+e
        kQLgNNFVcrjUoEBA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B7085118DD;
        Tue,  1 Jun 2021 15:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622561703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3+xxoUWRmVhfm3r2Asao3rj7Jc1IUbsH2zgezNGpjg=;
        b=Pfj6w4vFLBO5UX11zlPX3twVGrD7Fsusu3GXEMPrvDGLRgmEHMBaBRgn6CMJf7OZw7+RQU
        56oUDfk9zrKJrWqQnXBWF13p1043H73kuH8rWR/xlVqxgiWtTm0dfAsbH5/4UyPqGnr8Vb
        6ctpcqR+OuQtxt6Oyw+Sd9emEndUwrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622561703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3+xxoUWRmVhfm3r2Asao3rj7Jc1IUbsH2zgezNGpjg=;
        b=dxuMabDTAU5Yra2QbYzPwexG1YT59zkj2uBWx88YtVNBHaqzAwbDoCa/ljk9EOqYkwe6+e
        kQLgNNFVcrjUoEBA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id RtUoIKVTtmB1VAAALh3uQQ
        (envelope-from <colyli@suse.de>); Tue, 01 Jun 2021 15:35:01 +0000
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Rolf Fokkens <rolf@rolffokkens.nl>
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
Cc:     Thorsten Knabe <linux@thorsten-knabe.de>,
        linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Message-ID: <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
Date:   Tue, 1 Jun 2021 23:34:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
Content-Type: multipart/mixed;
 boundary="------------CFC77A06027D258EBB0FF1E3"
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is a multi-part message in MIME format.
--------------CFC77A06027D258EBB0FF1E3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 5/31/21 5:37 PM, Rolf Fokkens wrote:
> Same here, more details: https://bugzilla.redhat.com/show_bug.cgi?id=1965809

Could you please try these attached patches ? I'd like to have more
confirmation before submitting to Jens.

Thanks.

Coly Li



>
> On 5/15/21 9:06 PM, Thorsten Knabe wrote:
>> Hello.
>>
>> Starting with Linux 5.12 bcache triggers a BUG() after a few minutes of
>> usage.
>>
>> Linux up to 5.11.x is not affected by this bug.
>>
>> Environment:
>> - Debian 10 AMD 64
>> - Kernel 5.12 - 5.12.4
>> - Filesystem ext4
>> - Backing device: degraded software RAID-6 (MD) with 3 of 4 disks active
>>   (unsure if the degraded RAID-6 has an effect or not)
>> - Cache device: Single SSD
>>
>> Kernel log:
>>
>> May 12 20:22:24 tek04 kernel: nr_vecs=472
>> May 12 20:22:24 tek04 kernel: ------------[ cut here ]------------
>> May 12 20:22:24 tek04 kernel: kernel BUG at block/bio.c:53!
>> May 12 20:22:24 tek04 kernel: invalid opcode: 0000 [#1] PREEMPT SMP PTI
>> May 12 20:22:24 tek04 kernel: CPU: 1 PID: 1670 Comm: grep Tainted: G
>>       I       5.12.3 #2
>> May 12 20:22:24 tek04 kernel: Hardware name: To Be Filled By O.E.M. To
>> Be Filled By O.E.M./X58 Deluxe, BIOS P2.20 10/30/2009
>> May 12 20:22:24 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
>> May 12 20:22:24 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
>> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
>> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
>> e8 d4 80 fe ff
>> May 12 20:22:24 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
>> May 12 20:22:24 tek04 kernel: RAX: 000000000000000b RBX:
>> ffffc9000274b764 RCX: 0000000000000000
>> May 12 20:22:24 tek04 kernel: bch_count_backing_io_errors: 1 callbacks
>> suppressed
>> May 12 20:22:24 tek04 kernel: bcache: bch_count_backing_io_errors() md1:
>> Read-ahead I/O failed on backing device, ignore
>> May 12 20:22:24 tek04 kernel: RDX: ffff888333c5e400 RSI:
>> ffff888333c57480 RDI: ffff888333c57480
>> May 12 20:22:24 tek04 kernel: RBP: 0000000000000800 R08:
>> 0000000000000000 R09: c0000000ffffdfff
>> May 12 20:22:24 tek04 kernel: R10: ffffc9000274b580 R11:
>> ffffc9000274b578 R12: ffff8881170f0118
>> May 12 20:22:24 tek04 kernel: R13: ffff888109911b00 R14:
>> ffff8881170f00d0 R15: 0000000000000800
>> May 12 20:22:24 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
>> GS:ffff888333c40000(0000) knlGS:0000000000000000
>> May 12 20:22:24 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 12 20:22:24 tek04 kernel: CR2: 00005628963f4fd0 CR3:
>> 000000016c43c000 CR4: 00000000000006e0
>> May 12 20:22:24 tek04 kernel: Call Trace:
>> May 12 20:22:24 tek04 kernel:  bvec_alloc+0x22/0x90
>> May 12 20:22:24 tek04 kernel:  bio_alloc_bioset+0x176/0x230
>> May 12 20:22:24 tek04 kernel:  cached_dev_cache_miss+0x1a8/0x300
>> May 12 20:22:24 tek04 kernel:  cache_lookup_fn+0x110/0x2e0
>> May 12 20:22:24 tek04 kernel:  ? bch_ptr_invalid+0x10/0x10
>> May 12 20:22:24 tek04 kernel:  ? bch_btree_iter_next_filter+0x1af/0x2d0
>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0x69/0x160
>> May 12 20:22:24 tek04 kernel:  ? __bch_bset_search+0x315/0x440
>> May 12 20:22:24 tek04 kernel:  ? downgrade_write+0xb0/0xb0
>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys_recurse+0xcf/0x160
>> May 12 20:22:24 tek04 kernel:  ? raid5_make_request+0x5c4/0xaa0
>> May 12 20:22:24 tek04 kernel:  ? recalibrate_cpu_khz+0x10/0x10
>> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x30/0x400
>> May 12 20:22:24 tek04 kernel:  ? rwsem_wake.isra.11+0x80/0x80
>> May 12 20:22:24 tek04 kernel:  bch_btree_map_keys+0xf2/0x140
>> May 12 20:22:24 tek04 kernel:  ? cache_lookup+0x190/0x190
>> May 12 20:22:24 tek04 kernel:  cache_lookup+0xb1/0x190
>> May 12 20:22:24 tek04 kernel:  cached_dev_submit_bio+0x9ab/0xc90
>> May 12 20:22:24 tek04 kernel:  ? submit_bio_checks+0x197/0x4a0
>> May 12 20:22:24 tek04 kernel:  ? kmem_cache_alloc+0x3b7/0x400
>> May 12 20:22:24 tek04 kernel:  submit_bio_noacct+0x10e/0x4c0
>> May 12 20:22:24 tek04 kernel:  submit_bio+0x2e/0x160
>> May 12 20:22:24 tek04 kernel:  ? xa_load+0x66/0x70
>> May 12 20:22:24 tek04 kernel:  ? bio_add_page+0x2f/0x70
>> May 12 20:22:24 tek04 kernel:  ext4_mpage_readpages+0x1ae/0xa00
>> May 12 20:22:24 tek04 kernel:  ? __mod_lruvec_state+0x29/0x60
>> May 12 20:22:24 tek04 kernel:  read_pages+0x78/0x1d0
>> May 12 20:22:24 tek04 kernel:  page_cache_ra_unbounded+0x127/0x1b0
>> May 12 20:22:24 tek04 kernel:  filemap_get_pages+0x1d0/0x4a0
>> May 12 20:22:24 tek04 kernel:  filemap_read+0x91/0x2d0
>> May 12 20:22:24 tek04 kernel:  new_sync_read+0x103/0x180
>> May 12 20:22:24 tek04 kernel:  vfs_read+0x11b/0x1b0
>> May 12 20:22:24 tek04 kernel:  ksys_read+0x55/0xd0
>> May 12 20:22:24 tek04 kernel:  do_syscall_64+0x33/0x80
>> May 12 20:22:24 tek04 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> May 12 20:22:24 tek04 kernel: RIP: 0033:0x7f3a1cb89461
>> May 12 20:22:24 tek04 kernel: Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8
>> e9 03 02 00 66 0f 1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0
>> 75 13 31 c0 0f 05 <48> 3d 00 f0 ff ff 77 57 c3 66 0f 1f 44 00 00 41 54
>> 49 89 d4 55 48
>> May 12 20:22:24 tek04 kernel: RSP: 002b:00007fff4052fff8 EFLAGS:
>> 00000246 ORIG_RAX: 0000000000000000
>> May 12 20:22:24 tek04 kernel: RAX: ffffffffffffffda RBX:
>> 0000000000018000 RCX: 00007f3a1cb89461
>> May 12 20:22:24 tek04 kernel: RDX: 0000000000018000 RSI:
>> 000055ff0d01a000 RDI: 0000000000000004
>> May 12 20:22:24 tek04 kernel: RBP: 0000000000018000 R08:
>> 0000000000000002 R09: 000055ff0d0194b0
>> May 12 20:22:24 tek04 kernel: R10: 0000000000000000 R11:
>> 0000000000000246 R12: 000055ff0d01a000
>> May 12 20:22:24 tek04 kernel: R13: 0000000000000004 R14:
>> 000055ff0d0194b0 R15: 0000000000000004
>> May 12 20:22:24 tek04 kernel: Modules linked in: cmac bnep
>> intel_powerclamp snd_hda_codec_realtek snd_hda_codec_generic btusb
>> ledtrig_audio snd_hda_codec_hdmi btrtl kvm_intel snd_hda_intel btbcm
>> snd_intel_dspcfg btintel kvm snd_hda_codec irqbypass bluetooth serio_raw
>> pcspkr hfcpci snd_hda_core iTCO_wdt evdev input_leds joydev sg snd_hwdep
>> intel_pmc_bxt ecdh_generic rfkill iTCO_vendor_support mISDN_core ecc
>> snd_pcm snd_timer tiny_power_button snd soundcore button i7core_edac
>> acpi_cpufreq wmi nft_counter nf_log_ipv6 nf_log_ipv
>> May 12 20:22:24 tek04 kernel: ---[ end trace 9a03f30c7b4aa246 ]---
>> May 12 20:22:25 tek04 kernel: RIP: 0010:biovec_slab.cold.45+0xf/0x11
>> May 12 20:22:25 tek04 kernel: Code: b3 ae ff 89 c6 48 c7 c7 30 82 21 82
>> e8 03 81 fe ff b8 b6 ff ff ff e9 3d bc ae ff 0f b7 f7 48 c7 c7 c4 82 21
>> 82 e8 ea 80 fe ff <0f> 0b 49 8b b4 24 d0 00 00 00 48 c7 c7 40 84 21 82
>> e8 d4 80 fe ff
>> May 12 20:22:25 tek04 kernel: RSP: 0018:ffffc9000274b730 EFLAGS: 00010292
>> May 12 20:22:25 tek04 kernel: RAX: 000000000000000b RBX:
>> ffffc9000274b764 RCX: 0000000000000000
>> May 12 20:22:25 tek04 kernel: RDX: ffff888333c5e400 RSI:
>> ffff888333c57480 RDI: ffff888333c57480
>> May 12 20:22:25 tek04 kernel: RBP: 0000000000000800 R08:
>> 0000000000000000 R09: c0000000ffffdfff
>> May 12 20:22:25 tek04 kernel: R10: ffffc9000274b580 R11:
>> ffffc9000274b578 R12: ffff8881170f0118
>> May 12 20:22:25 tek04 kernel: R13: ffff888109911b00 R14:
>> ffff8881170f00d0 R15: 0000000000000800
>> May 12 20:22:25 tek04 kernel: FS:  00007f3a1ca7cb80(0000)
>> GS:ffff888333c40000(0000) knlGS:0000000000000000
>> May 12 20:22:25 tek04 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
>> 0000000080050033
>> May 12 20:22:25 tek04 kernel: CR2: 00005628963f4fd0 CR3:
>> 000000016c43c000 CR4: 00000000000006e0
>>
>> A printk has been added to line 52 of block/bio.c to dump the nr_vecs
>> variable to the kernel log before the BUG(). Obviously nr_vecs (472
>> logged) is bigger than expected by bvec_alloc/bio_alloc_bioset (max
>> 256), which finally triggers the BUG().
>>
>> Removing the BUG() from line 52 of block/bio.c, thus basically restoring
>> the Linux 5.11.x behavior of bvec_alloc/bio_alloc_bioset to just return
>> NULL, when nr_vecs is too big seems to resolve the issue.
>>
>> Regards
>> Thorsten
>>


--------------CFC77A06027D258EBB0FF1E3
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="v5-0001-bcache-remove-bcache-device-self-defined-readahea.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="v5-0001-bcache-remove-bcache-device-self-defined-readahea.pa";
 filename*1="tch"

RnJvbSA3OWM4YjZmZTZiMWFlOTVlNmE3NWU0OWFhOTA3YjgwZjRjZjFmODEzIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
TW9uLCAzMSBNYXkgMjAyMSAyMjozMDozNyArMDgwMApTdWJqZWN0OiBbUEFUQ0ggdjUgMS8y
XSBiY2FjaGU6IHJlbW92ZSBiY2FjaGUgZGV2aWNlIHNlbGYtZGVmaW5lZCByZWFkYWhlYWQK
CkZvciByZWFkIGNhY2hlIG1pc3NpbmcsIGJjYWNoZSBkZWZpbmVzIGEgcmVhZGFoZWFkIHNp
emUgZm9yIHRoZSByZWFkIEkvTwpyZXF1ZXN0IHRvIHRoZSBiYWNraW5nIGRldmljZSBmb3Ig
dGhlIG1pc3NpbmcgZGF0YS4gVGhpcyByZWFkYWhlYWQgc2l6ZQppcyBpbml0aWFsaXplZCB0
byAwLCBhbmQgYWxtb3N0IG5vIG9uZSB1c2VzIGl0IHRvIGF2b2lkIHVubmVjZXNzYXJ5IHJl
YWQKYW1wbGlmeWluZyBvbnRvIGJhY2tpbmcgZGV2aWNlIGFuZCB3cml0ZSBhbXBsaWZ5aW5n
IG9udG8gY2FjaGUgZGV2aWNlLgpDb25zaWRlcmluZyB1cHBlciBsYXllciBmaWxlIHN5c3Rl
bSBjb2RlIGhhcyByZWFkYWhlYWQgbG9naWMgYWxscmVhZHkKYW5kIHdvcmtzIGZpbmUgd2l0
aCByZWFkYWhlYWRfY2FjaGVfcG9saWN5IHN5c2ZpbGUgaW50ZXJmYWNlLCB3ZSBkb24ndApo
YXZlIHRvIGtlZXAgYmNhY2hlIHNlbGYtZGVmaW5lZCByZWFkYWhlYWQgYW55bW9yZS4KClRo
aXMgcGF0Y2ggcmVtb3ZlcyB0aGUgYmNhY2hlIHNlbGYtZGVmaW5lZCByZWFkYWhlYWQgZm9y
IGNhY2hlIG1pc3NpbmcKcmVxdWVzdCBmb3IgYmFja2luZyBkZXZpY2UsIGFuZCB0aGUgcmVh
ZGFoZWFkIHN5c2ZzIGZpbGUgaW50ZXJmYWNlcyBhcmUKcmVtb3ZlZCBhcyB3ZWxsLgoKVGhp
cyBpcyB0aGUgcHJlcGFyYXRpb24gZm9yIG5leHQgcGF0Y2ggdG8gZml4IHBvdGVudGlhbCBr
ZXJuZWwgcGFuaWMgZHVlCnRvIG92ZXJzaXplZCByZXF1ZXN0IGluIGEgc2ltcGxlciBtZXRo
b2QuCgpSZXBvcnRlZC1ieTogQWxleGFuZGVyIFVsbHJpY2ggPGVhbGV4MTk3OUBnbWFpbC5j
b20+ClJlcG9ydGVkLWJ5OiBEaWVnbyBFcmNvbGFuaSA8ZGllZ28uZXJjb2xhbmlAZ21haWwu
Y29tPgpSZXBvcnRlZC1ieTogSmFuIFN6dWJpYWsgPGphbi5zenViaWFrQGxpbnV4cG9sc2th
LnBsPgpSZXBvcnRlZC1ieTogTWFyY28gUmViaGFuIDxtZUBkYmxzYWlrby5uZXQ+ClJlcG9y
dGVkLWJ5OiBNYXR0aGlhcyBGZXJkaW5hbmQgPGJjYWNoZUBtZmVkdi5uZXQ+ClJlcG9ydGVk
LWJ5OiBUaG9yc3RlbiBLbmFiZSA8bGludXhAdGhvcnN0ZW4ta25hYmUuZGU+ClJlcG9ydGVk
LWJ5OiBWaWN0b3IgV2VzdGVyaHVpcyA8dmljdG9yQHdlc3Rlcmh1LmlzPgpSZXBvcnRlZC1i
eTogVm9qdGVjaCBQYXZsaWsgPHZvanRlY2hAc3VzZS5jej4KU2lnbmVkLW9mZi1ieTogQ29s
eSBMaSA8Y29seWxpQHN1c2UuZGU+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCkNjOiBD
aHJpc3RvcGggSGVsbHdpZyA8aGNoQGxzdC5kZT4KQ2M6IEtlbnQgT3ZlcnN0cmVldCA8a2Vu
dC5vdmVyc3RyZWV0QGdtYWlsLmNvbT4KQ2M6IE5peCA8bml4QGVzcGVyaS5vcmcudWs+CkNj
OiBUYWthc2hpIEl3YWkgPHRpd2FpQHN1c2UuY29tPgotLS0KQ2hhbmdsb2csCnYxLCB0aGUg
aW5pdGlhbCB2ZXJzaW9uIGJ5IGhpbnQgZnJvbSAgQ2hyaXN0b3BoIEhlbGx3aWcuCgogZHJp
dmVycy9tZC9iY2FjaGUvYmNhY2hlLmggIHwgIDEgLQogZHJpdmVycy9tZC9iY2FjaGUvcmVx
dWVzdC5jIHwgMTMgKy0tLS0tLS0tLS0tLQogZHJpdmVycy9tZC9iY2FjaGUvc3RhdHMuYyAg
IHwgMTQgLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvbWQvYmNhY2hlL3N0YXRzLmggICB8ICAx
IC0KIGRyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMgICB8ICA0IC0tLS0KIDUgZmlsZXMgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDMyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oIGIvZHJpdmVycy9tZC9iY2FjaGUvYmNhY2hlLmgK
aW5kZXggMGE0NTUxZTE2NWFiLi41ZmM5ODlhNmQ0NTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bWQvYmNhY2hlL2JjYWNoZS5oCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oCkBA
IC0zNjQsNyArMzY0LDYgQEAgc3RydWN0IGNhY2hlZF9kZXYgewogCiAJLyogVGhlIHJlc3Qg
b2YgdGhpcyBhbGwgc2hvd3MgdXAgaW4gc3lzZnMgKi8KIAl1bnNpZ25lZCBpbnQJCXNlcXVl
bnRpYWxfY3V0b2ZmOwotCXVuc2lnbmVkIGludAkJcmVhZGFoZWFkOwogCiAJdW5zaWduZWQg
aW50CQlpb19kaXNhYmxlOjE7CiAJdW5zaWduZWQgaW50CQl2ZXJpZnk6MTsKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3Jl
cXVlc3QuYwppbmRleCAyOWMyMzE3NTgyOTMuLmFiOGZmMThkZjMyYSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9tZC9iY2FjaGUvcmVxdWVzdC5jCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3Jl
cXVlc3QuYwpAQCAtODgwLDcgKzg4MCw2IEBAIHN0YXRpYyBpbnQgY2FjaGVkX2Rldl9jYWNo
ZV9taXNzKHN0cnVjdCBidHJlZSAqYiwgc3RydWN0IHNlYXJjaCAqcywKIAkJCQkgc3RydWN0
IGJpbyAqYmlvLCB1bnNpZ25lZCBpbnQgc2VjdG9ycykKIHsKIAlpbnQgcmV0ID0gTUFQX0NP
TlRJTlVFOwotCXVuc2lnbmVkIGludCByZWFkYSA9IDA7CiAJc3RydWN0IGNhY2hlZF9kZXYg
KmRjID0gY29udGFpbmVyX29mKHMtPmQsIHN0cnVjdCBjYWNoZWRfZGV2LCBkaXNrKTsKIAlz
dHJ1Y3QgYmlvICptaXNzLCAqY2FjaGVfYmlvOwogCkBAIC04OTIsMTQgKzg5MSw3IEBAIHN0
YXRpYyBpbnQgY2FjaGVkX2Rldl9jYWNoZV9taXNzKHN0cnVjdCBidHJlZSAqYiwgc3RydWN0
IHNlYXJjaCAqcywKIAkJZ290byBvdXRfc3VibWl0OwogCX0KIAotCWlmICghKGJpby0+Ymlf
b3BmICYgUkVRX1JBSEVBRCkgJiYKLQkgICAgIShiaW8tPmJpX29wZiAmIChSRVFfTUVUQXxS
RVFfUFJJTykpICYmCi0JICAgIHMtPmlvcC5jLT5nY19zdGF0cy5pbl91c2UgPCBDVVRPRkZf
Q0FDSEVfUkVBREEpCi0JCXJlYWRhID0gbWluX3Qoc2VjdG9yX3QsIGRjLT5yZWFkYWhlYWQg
Pj4gOSwKLQkJCSAgICAgIGdldF9jYXBhY2l0eShiaW8tPmJpX2JkZXYtPmJkX2Rpc2spIC0K
LQkJCSAgICAgIGJpb19lbmRfc2VjdG9yKGJpbykpOwotCi0Jcy0+aW5zZXJ0X2Jpb19zZWN0
b3JzID0gbWluKHNlY3RvcnMsIGJpb19zZWN0b3JzKGJpbykgKyByZWFkYSk7CisJcy0+aW5z
ZXJ0X2Jpb19zZWN0b3JzID0gbWluKHNlY3RvcnMsIGJpb19zZWN0b3JzKGJpbykpOwogCiAJ
cy0+aW9wLnJlcGxhY2Vfa2V5ID0gS0VZKHMtPmlvcC5pbm9kZSwKIAkJCQkgYmlvLT5iaV9p
dGVyLmJpX3NlY3RvciArIHMtPmluc2VydF9iaW9fc2VjdG9ycywKQEAgLTkzMyw5ICs5MjUs
NiBAQCBzdGF0aWMgaW50IGNhY2hlZF9kZXZfY2FjaGVfbWlzcyhzdHJ1Y3QgYnRyZWUgKmIs
IHN0cnVjdCBzZWFyY2ggKnMsCiAJaWYgKGJjaF9iaW9fYWxsb2NfcGFnZXMoY2FjaGVfYmlv
LCBfX0dGUF9OT1dBUk58R0ZQX05PSU8pKQogCQlnb3RvIG91dF9wdXQ7CiAKLQlpZiAocmVh
ZGEpCi0JCWJjaF9tYXJrX2NhY2hlX3JlYWRhaGVhZChzLT5pb3AuYywgcy0+ZCk7Ci0KIAlz
LT5jYWNoZV9taXNzCT0gbWlzczsKIAlzLT5pb3AuYmlvCT0gY2FjaGVfYmlvOwogCWJpb19n
ZXQoY2FjaGVfYmlvKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL3N0YXRzLmMg
Yi9kcml2ZXJzL21kL2JjYWNoZS9zdGF0cy5jCmluZGV4IDUwM2FhZmUxODhkYy4uNGM3ZWU1
ZmVkYjlkIDEwMDY0NAotLS0gYS9kcml2ZXJzL21kL2JjYWNoZS9zdGF0cy5jCisrKyBiL2Ry
aXZlcnMvbWQvYmNhY2hlL3N0YXRzLmMKQEAgLTQ2LDcgKzQ2LDYgQEAgcmVhZF9hdHRyaWJ1
dGUoY2FjaGVfbWlzc2VzKTsKIHJlYWRfYXR0cmlidXRlKGNhY2hlX2J5cGFzc19oaXRzKTsK
IHJlYWRfYXR0cmlidXRlKGNhY2hlX2J5cGFzc19taXNzZXMpOwogcmVhZF9hdHRyaWJ1dGUo
Y2FjaGVfaGl0X3JhdGlvKTsKLXJlYWRfYXR0cmlidXRlKGNhY2hlX3JlYWRhaGVhZHMpOwog
cmVhZF9hdHRyaWJ1dGUoY2FjaGVfbWlzc19jb2xsaXNpb25zKTsKIHJlYWRfYXR0cmlidXRl
KGJ5cGFzc2VkKTsKIApAQCAtNjQsNyArNjMsNiBAQCBTSE9XKGJjaF9zdGF0cykKIAkJICAg
IERJVl9TQUZFKHZhcihjYWNoZV9oaXRzKSAqIDEwMCwKIAkJCSAgICAgdmFyKGNhY2hlX2hp
dHMpICsgdmFyKGNhY2hlX21pc3NlcykpKTsKIAotCXZhcl9wcmludChjYWNoZV9yZWFkYWhl
YWRzKTsKIAl2YXJfcHJpbnQoY2FjaGVfbWlzc19jb2xsaXNpb25zKTsKIAlzeXNmc19ocHJp
bnQoYnlwYXNzZWQsCXZhcihzZWN0b3JzX2J5cGFzc2VkKSA8PCA5KTsKICN1bmRlZiB2YXIK
QEAgLTg2LDcgKzg0LDYgQEAgc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGUgKmJjaF9zdGF0c19m
aWxlc1tdID0gewogCSZzeXNmc19jYWNoZV9ieXBhc3NfaGl0cywKIAkmc3lzZnNfY2FjaGVf
YnlwYXNzX21pc3NlcywKIAkmc3lzZnNfY2FjaGVfaGl0X3JhdGlvLAotCSZzeXNmc19jYWNo
ZV9yZWFkYWhlYWRzLAogCSZzeXNmc19jYWNoZV9taXNzX2NvbGxpc2lvbnMsCiAJJnN5c2Zz
X2J5cGFzc2VkLAogCU5VTEwKQEAgLTExMyw3ICsxMTAsNiBAQCB2b2lkIGJjaF9jYWNoZV9h
Y2NvdW50aW5nX2NsZWFyKHN0cnVjdCBjYWNoZV9hY2NvdW50aW5nICphY2MpCiAJYWNjLT50
b3RhbC5jYWNoZV9taXNzZXMgPSAwOwogCWFjYy0+dG90YWwuY2FjaGVfYnlwYXNzX2hpdHMg
PSAwOwogCWFjYy0+dG90YWwuY2FjaGVfYnlwYXNzX21pc3NlcyA9IDA7Ci0JYWNjLT50b3Rh
bC5jYWNoZV9yZWFkYWhlYWRzID0gMDsKIAlhY2MtPnRvdGFsLmNhY2hlX21pc3NfY29sbGlz
aW9ucyA9IDA7CiAJYWNjLT50b3RhbC5zZWN0b3JzX2J5cGFzc2VkID0gMDsKIH0KQEAgLTE0
NSw3ICsxNDEsNiBAQCBzdGF0aWMgdm9pZCBzY2FsZV9zdGF0cyhzdHJ1Y3QgY2FjaGVfc3Rh
dHMgKnN0YXRzLCB1bnNpZ25lZCBsb25nIHJlc2NhbGVfYXQpCiAJCXNjYWxlX3N0YXQoJnN0
YXRzLT5jYWNoZV9taXNzZXMpOwogCQlzY2FsZV9zdGF0KCZzdGF0cy0+Y2FjaGVfYnlwYXNz
X2hpdHMpOwogCQlzY2FsZV9zdGF0KCZzdGF0cy0+Y2FjaGVfYnlwYXNzX21pc3Nlcyk7Ci0J
CXNjYWxlX3N0YXQoJnN0YXRzLT5jYWNoZV9yZWFkYWhlYWRzKTsKIAkJc2NhbGVfc3RhdCgm
c3RhdHMtPmNhY2hlX21pc3NfY29sbGlzaW9ucyk7CiAJCXNjYWxlX3N0YXQoJnN0YXRzLT5z
ZWN0b3JzX2J5cGFzc2VkKTsKIAl9CkBAIC0xNjgsNyArMTYzLDYgQEAgc3RhdGljIHZvaWQg
c2NhbGVfYWNjb3VudGluZyhzdHJ1Y3QgdGltZXJfbGlzdCAqdCkKIAltb3ZlX3N0YXQoY2Fj
aGVfbWlzc2VzKTsKIAltb3ZlX3N0YXQoY2FjaGVfYnlwYXNzX2hpdHMpOwogCW1vdmVfc3Rh
dChjYWNoZV9ieXBhc3NfbWlzc2VzKTsKLQltb3ZlX3N0YXQoY2FjaGVfcmVhZGFoZWFkcyk7
CiAJbW92ZV9zdGF0KGNhY2hlX21pc3NfY29sbGlzaW9ucyk7CiAJbW92ZV9zdGF0KHNlY3Rv
cnNfYnlwYXNzZWQpOwogCkBAIC0yMDksMTQgKzIwMyw2IEBAIHZvaWQgYmNoX21hcmtfY2Fj
aGVfYWNjb3VudGluZyhzdHJ1Y3QgY2FjaGVfc2V0ICpjLCBzdHJ1Y3QgYmNhY2hlX2Rldmlj
ZSAqZCwKIAltYXJrX2NhY2hlX3N0YXRzKCZjLT5hY2NvdW50aW5nLmNvbGxlY3RvciwgaGl0
LCBieXBhc3MpOwogfQogCi12b2lkIGJjaF9tYXJrX2NhY2hlX3JlYWRhaGVhZChzdHJ1Y3Qg
Y2FjaGVfc2V0ICpjLCBzdHJ1Y3QgYmNhY2hlX2RldmljZSAqZCkKLXsKLQlzdHJ1Y3QgY2Fj
aGVkX2RldiAqZGMgPSBjb250YWluZXJfb2YoZCwgc3RydWN0IGNhY2hlZF9kZXYsIGRpc2sp
OwotCi0JYXRvbWljX2luYygmZGMtPmFjY291bnRpbmcuY29sbGVjdG9yLmNhY2hlX3JlYWRh
aGVhZHMpOwotCWF0b21pY19pbmMoJmMtPmFjY291bnRpbmcuY29sbGVjdG9yLmNhY2hlX3Jl
YWRhaGVhZHMpOwotfQotCiB2b2lkIGJjaF9tYXJrX2NhY2hlX21pc3NfY29sbGlzaW9uKHN0
cnVjdCBjYWNoZV9zZXQgKmMsIHN0cnVjdCBiY2FjaGVfZGV2aWNlICpkKQogewogCXN0cnVj
dCBjYWNoZWRfZGV2ICpkYyA9IGNvbnRhaW5lcl9vZihkLCBzdHJ1Y3QgY2FjaGVkX2Rldiwg
ZGlzayk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9zdGF0cy5oIGIvZHJpdmVy
cy9tZC9iY2FjaGUvc3RhdHMuaAppbmRleCBhYmZhYWJmN2U3ZmMuLmNhNGY0MzVmNzIxNiAx
MDA2NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvc3RhdHMuaAorKysgYi9kcml2ZXJzL21k
L2JjYWNoZS9zdGF0cy5oCkBAIC03LDcgKzcsNiBAQCBzdHJ1Y3QgY2FjaGVfc3RhdF9jb2xs
ZWN0b3IgewogCWF0b21pY190IGNhY2hlX21pc3NlczsKIAlhdG9taWNfdCBjYWNoZV9ieXBh
c3NfaGl0czsKIAlhdG9taWNfdCBjYWNoZV9ieXBhc3NfbWlzc2VzOwotCWF0b21pY190IGNh
Y2hlX3JlYWRhaGVhZHM7CiAJYXRvbWljX3QgY2FjaGVfbWlzc19jb2xsaXNpb25zOwogCWF0
b21pY190IHNlY3RvcnNfYnlwYXNzZWQ7CiB9OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tZC9i
Y2FjaGUvc3lzZnMuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3N5c2ZzLmMKaW5kZXggY2M4OWYz
MTU2ZDFhLi4wNWFjMWQ2ZmJiZjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL3N5
c2ZzLmMKKysrIGIvZHJpdmVycy9tZC9iY2FjaGUvc3lzZnMuYwpAQCAtMTM3LDcgKzEzNyw2
IEBAIHJ3X2F0dHJpYnV0ZShpb19kaXNhYmxlKTsKIHJ3X2F0dHJpYnV0ZShkaXNjYXJkKTsK
IHJ3X2F0dHJpYnV0ZShydW5uaW5nKTsKIHJ3X2F0dHJpYnV0ZShsYWJlbCk7Ci1yd19hdHRy
aWJ1dGUocmVhZGFoZWFkKTsKIHJ3X2F0dHJpYnV0ZShlcnJvcnMpOwogcndfYXR0cmlidXRl
KGlvX2Vycm9yX2xpbWl0KTsKIHJ3X2F0dHJpYnV0ZShpb19lcnJvcl9oYWxmbGlmZSk7CkBA
IC0yNjAsNyArMjU5LDYgQEAgU0hPVyhfX2JjaF9jYWNoZWRfZGV2KQogCXZhcl9wcmludGYo
cGFydGlhbF9zdHJpcGVzX2V4cGVuc2l2ZSwJIiV1Iik7CiAKIAl2YXJfaHByaW50KHNlcXVl
bnRpYWxfY3V0b2ZmKTsKLQl2YXJfaHByaW50KHJlYWRhaGVhZCk7CiAKIAlzeXNmc19wcmlu
dChydW5uaW5nLAkJYXRvbWljX3JlYWQoJmRjLT5ydW5uaW5nKSk7CiAJc3lzZnNfcHJpbnQo
c3RhdGUsCQlzdGF0ZXNbQkRFVl9TVEFURSgmZGMtPnNiKV0pOwpAQCAtMzY1LDcgKzM2Myw2
IEBAIFNUT1JFKF9fY2FjaGVkX2RldikKIAlzeXNmc19zdHJ0b3VsX2NsYW1wKHNlcXVlbnRp
YWxfY3V0b2ZmLAogCQkJICAgIGRjLT5zZXF1ZW50aWFsX2N1dG9mZiwKIAkJCSAgICAwLCBV
SU5UX01BWCk7Ci0JZF9zdHJ0b2lfaChyZWFkYWhlYWQpOwogCiAJaWYgKGF0dHIgPT0gJnN5
c2ZzX2NsZWFyX3N0YXRzKQogCQliY2hfY2FjaGVfYWNjb3VudGluZ19jbGVhcigmZGMtPmFj
Y291bnRpbmcpOwpAQCAtNTM4LDcgKzUzNSw2IEBAIHN0YXRpYyBzdHJ1Y3QgYXR0cmlidXRl
ICpiY2hfY2FjaGVkX2Rldl9maWxlc1tdID0gewogCSZzeXNmc19ydW5uaW5nLAogCSZzeXNm
c19zdGF0ZSwKIAkmc3lzZnNfbGFiZWwsCi0JJnN5c2ZzX3JlYWRhaGVhZCwKICNpZmRlZiBD
T05GSUdfQkNBQ0hFX0RFQlVHCiAJJnN5c2ZzX3ZlcmlmeSwKIAkmc3lzZnNfYnlwYXNzX3Rv
cnR1cmVfdGVzdCwKLS0gCjIuMjYuMgoK
--------------CFC77A06027D258EBB0FF1E3
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="v5-0002-bcache-avoid-oversized-read-request-in-cache-miss.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0="v5-0002-bcache-avoid-oversized-read-request-in-cache-miss.pa";
 filename*1="tch"

RnJvbSBhZDllZDgyNTI5OTkzMDI5OGMyZTEyNjk5ZDg1NWUwYjg5YzI5NTNhIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KRGF0ZTog
TW9uLCAzMSBNYXkgMjAyMSAyMjo0NzoxMiArMDgwMApTdWJqZWN0OiBbUEFUQ0ggdjUgMi8y
XSBiY2FjaGU6IGF2b2lkIG92ZXJzaXplZCByZWFkIHJlcXVlc3QgaW4gY2FjaGUgbWlzc2lu
ZwogY29kZSBwYXRoCgpJbiB0aGUgY2FjaGUgbWlzc2luZyBjb2RlIHBhdGggb2YgY2FjaGVk
IGRldmljZSwgaWYgYSBwcm9wZXIgbG9jYXRpb24KZnJvbSB0aGUgaW50ZXJuYWwgQisgdHJl
ZSBpcyBtYXRjaGVkIGZvciBhIGNhY2hlIG1pc3MgcmFuZ2UsIGZ1bmN0aW9uCmNhY2hlZF9k
ZXZfY2FjaGVfbWlzcygpIHdpbGwgYmUgY2FsbGVkIGluIGNhY2hlX2xvb2t1cF9mbigpIGlu
IHRoZQpmb2xsb3dpbmcgY29kZSBibG9jaywKW2NvZGUgYmxvY2sgMV0KICA1MjYgICAgICAg
ICB1bnNpZ25lZCBpbnQgc2VjdG9ycyA9IEtFWV9JTk9ERShrKSA9PSBzLT5pb3AuaW5vZGUK
ICA1MjcgICAgICAgICAgICAgICAgID8gbWluX3QodWludDY0X3QsIElOVF9NQVgsCiAgNTI4
ICAgICAgICAgICAgICAgICAgICAgICAgIEtFWV9TVEFSVChrKSAtIGJpby0+YmlfaXRlci5i
aV9zZWN0b3IpCiAgNTI5ICAgICAgICAgICAgICAgICA6IElOVF9NQVg7CiAgNTMwICAgICAg
ICAgaW50IHJldCA9IHMtPmQtPmNhY2hlX21pc3MoYiwgcywgYmlvLCBzZWN0b3JzKTsKCkhl
cmUgcy0+ZC0+Y2FjaGVfbWlzcygpIGlzIHRoZSBjYWxsIGJhY2tmdW5jdGlvbiBwb2ludGVy
IGluaXRpYWxpemVkIGFzCmNhY2hlZF9kZXZfY2FjaGVfbWlzcygpLCB0aGUgbGFzdCBwYXJh
bWV0ZXIgJ3NlY3RvcnMnIGlzIGFuIGltcG9ydGFudApoaW50IHRvIGNhbGN1bGF0ZSB0aGUg
c2l6ZSBvZiByZWFkIHJlcXVlc3QgdG8gYmFja2luZyBkZXZpY2Ugb2YgdGhlCm1pc3Npbmcg
Y2FjaGUgZGF0YS4KCkN1cnJlbnQgY2FsY3VsYXRpb24gaW4gYWJvdmUgY29kZSBibG9jayBt
YXkgZ2VuZXJhdGUgb3ZlcnNpemVkIHZhbHVlIG9mCidzZWN0b3JzJywgd2hpY2ggY29uc2Vx
dWVudGx5IG1heSB0cmlnZ2VyIDIgZGlmZmVyZW50IHBvdGVudGlhbCBrZXJuZWwKcGFuaWNz
IGJ5IEJVRygpIG9yIEJVR19PTigpIGFzIGxpc3RlZCBiZWxvdywKCjEpIEJVR19PTigpIGlu
c2lkZSBiY2hfYnRyZWVfaW5zZXJ0X2tleSgpLApbY29kZSBibG9jayAyXQogICA4ODYgICAg
ICAgICBCVUdfT04oYi0+b3BzLT5pc19leHRlbnRzICYmICFLRVlfU0laRShrKSk7CjIpIEJV
RygpIGluc2lkZSBiaW92ZWNfc2xhYigpLApbY29kZSBibG9jayAzXQogICA1MSAgICAgICAg
IGRlZmF1bHQ6CiAgIDUyICAgICAgICAgICAgICAgICBCVUcoKTsKICAgNTMgICAgICAgICAg
ICAgICAgIHJldHVybiBOVUxMOwoKQWxsIHRoZSBhYm92ZSBwYW5pY3MgYXJlIG9yaWdpbmFs
IGZyb20gY2FjaGVkX2Rldl9jYWNoZV9taXNzKCkgYnkgdGhlCm92ZXJzaXplZCBwYXJhbWV0
ZXIgJ3NlY3RvcnMnLgoKSW5zaWRlIGNhY2hlZF9kZXZfY2FjaGVfbWlzcygpLCBwYXJhbWV0
ZXIgJ3NlY3RvcnMnIGlzIHVzZWQgdG8gY2FsY3VsYXRlCnRoZSBzaXplIG9mIGRhdGEgcmVh
ZCBmcm9tIGJhY2tpbmcgZGV2aWNlIGZvciB0aGUgY2FjaGUgbWlzc2luZy4gVGhpcwpzaXpl
IGlzIHN0b3JlZCBpbiBzLT5pbnNlcnRfYmlvX3NlY3RvcnMgYnkgdGhlIGZvbGxvd2luZyBs
aW5lcyBvZiBjb2RlLApbY29kZSBibG9jayA0XQogIDkwOSAgICBzLT5pbnNlcnRfYmlvX3Nl
Y3RvcnMgPSBtaW4oc2VjdG9ycywgYmlvX3NlY3RvcnMoYmlvKSArIHJlYWRhKTsKClRoZW4g
dGhlIGFjdHVhbCBrZXkgaW5zZXJ0aW5nIHRvIHRoZSBpbnRlcm5hbCBCKyB0cmVlIGlzIGdl
bmVyYXRlZCBhbmQKc3RvcmVkIGluIHMtPmlvcC5yZXBsYWNlX2tleSBieSB0aGUgZm9sbG93
aW5nIGxpbmVzIG9mIGNvZGUsCltjb2RlIGJsb2NrIDVdCiAgOTExICAgcy0+aW9wLnJlcGxh
Y2Vfa2V5ID0gS0VZKHMtPmlvcC5pbm9kZSwKICA5MTIgICAgICAgICAgICAgICAgICAgIGJp
by0+YmlfaXRlci5iaV9zZWN0b3IgKyBzLT5pbnNlcnRfYmlvX3NlY3RvcnMsCiAgOTEzICAg
ICAgICAgICAgICAgICAgICBzLT5pbnNlcnRfYmlvX3NlY3RvcnMpOwpUaGUgb3ZlcnNpemVk
IHBhcmFtZXRlciAnc2VjdG9ycycgbWF5IHRyaWdnZXIgcGFuaWMgMSkgYnkgQlVHX09OKCkg
ZnJvbQp0aGUgYWJvdmUgY29kZSBibG9jay4KCkFuZCB0aGUgYmlvIHNlbmRpbmcgdG8gYmFj
a2luZyBkZXZpY2UgZm9yIHRoZSBtaXNzaW5nIGRhdGEgaXMgYWxsb2NhdGVkCndpdGggaGlu
dCBmcm9tIHMtPmluc2VydF9iaW9fc2VjdG9ycyBieSB0aGUgZm9sbG93aW5nIGxpbmVzIG9m
IGNvZGUsCltjb2RlIGJsb2NrIDZdCiAgOTI2ICAgIGNhY2hlX2JpbyA9IGJpb19hbGxvY19i
aW9zZXQoR0ZQX05PV0FJVCwKICA5MjcgICAgICAgICAgICAgICAgIERJVl9ST1VORF9VUChz
LT5pbnNlcnRfYmlvX3NlY3RvcnMsIFBBR0VfU0VDVE9SUyksCiAgOTI4ICAgICAgICAgICAg
ICAgICAmZGMtPmRpc2suYmlvX3NwbGl0KTsKVGhlIG92ZXJzaXplZCBwYXJhbWV0ZXIgJ3Nl
Y3RvcnMnIG1heSB0cmlnZ2VyIHBhbmljIDIpIGJ5IEJVRygpIGZyb20gdGhlCmFnb3ZlIGNv
ZGUgYmxvY2suCgpOb3cgbGV0IG1lIGV4cGxhaW4gaG93IHRoZSBwYW5pY3MgaGFwcGVuIHdp
dGggdGhlIG92ZXJzaXplZCAnc2VjdG9ycycuCkluIGNvZGUgYmxvY2sgNSwgcmVwbGFjZV9r
ZXkgaXMgZ2VuZXJhdGVkIGJ5IG1hY3JvIEtFWSgpLiBGcm9tIHRoZQpkZWZpbml0aW9uIG9m
IG1hY3JvIEtFWSgpLApbY29kZSBibG9jayA3XQogIDcxICNkZWZpbmUgS0VZKGlub2RlLCBv
ZmZzZXQsIHNpemUpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKICA3MiAo
KHN0cnVjdCBia2V5KSB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcCiAgNzMgICAgICAuaGlnaCA9ICgxVUxMIDw8IDYzKSB8ICgoX191NjQp
IChzaXplKSA8PCAyMCkgfCAoaW5vZGUpLCAgICAgXAogIDc0ICAgICAgLmxvdyA9IChvZmZz
ZXQpICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKICA3
NSB9KQoKSGVyZSAnc2l6ZScgaXMgMTZiaXRzIHdpZHRoIGVtYmVkZGVkIGluIDY0Yml0cyBt
ZW1iZXIgJ2hpZ2gnIG9mIHN0cnVjdApia2V5LiBCdXQgaW4gY29kZSBibG9jayAxLCBpZiAi
S0VZX1NUQVJUKGspIC0gYmlvLT5iaV9pdGVyLmJpX3NlY3RvciIgaXMKdmVyeSBwcm9iYWJs
eSB0byBiZSBsYXJnZXIgdGhhbiAoMTw8MTYpIC0gMSwgd2hpY2ggbWFrZXMgdGhlIGJrZXkg
c2l6ZQpjYWxjdWxhdGlvbiBpbiBjb2RlIGJsb2NrIDUgaXMgb3ZlcmZsb3dlZC4gSW4gb25l
IGJ1ZyByZXBvcnQgdGhlIHZhbHVlCm9mIHBhcmFtZXRlciAnc2VjdG9ycycgaXMgMTMxMDcy
ICg9IDEgPDwgMTcpLCB0aGUgb3ZlcmZsb3dlZCAnc2VjdG9ycycKcmVzdWx0cyB0aGUgb3Zl
cmZsb3dlZCBzLT5pbnNlcnRfYmlvX3NlY3RvcnMgaW4gY29kZSBibG9jayA0LCB0aGVuIG1h
a2VzCnNpemUgZmllbGQgb2Ygcy0+aW9wLnJlcGxhY2Vfa2V5IHRvIGJlIDAgaW4gY29kZSBi
bG9jayA1LiBUaGVuIHRoZSAwLQpzaXplZCBzLT5pb3AucmVwbGFjZV9rZXkgaXMgaW5zZXJ0
ZWQgaW50byB0aGUgaW50ZXJuYWwgQisgdHJlZSBhcyBjYWNoZQptaXNzaW5nIGNoZWNrIGtl
eSAoYSBzcGVjaWFsIGtleSB0byBkZXRlY3QgYW5kIGF2b2lkIGEgcmFjaW5nIGJldHdlZW4K
bm9ybWFsIHdyaXRlIHJlcXVlc3QgYW5kIGNhY2hlIG1pc3NpbmcgcmVhZCByZXF1ZXN0KSBh
cywKW2NvZGUgYmxvY2sgOF0KICA5MTUgICByZXQgPSBiY2hfYnRyZWVfaW5zZXJ0X2NoZWNr
X2tleShiLCAmcy0+b3AsICZzLT5pb3AucmVwbGFjZV9rZXkpOwoKVGhlbiB0aGUgMC1zaXpl
ZCBzLT5pb3AucmVwbGFjZV9rZXkgYXMgM3JkIHBhcmFtZXRlciB0cmlnZ2VycyB0aGUgYmtl
eQpzaXplIGNoZWNrIEJVR19PTigpIGluIGNvZGUgYmxvY2sgMiwgYW5kIGNhdXNlcyB0aGUg
a2VybmVsIHBhbmljIDEpLgoKQW5vdGhlciBrZXJuZWwgcGFuaWMgaXMgZnJvbSBjb2RlIGJs
b2NrIDYsIGlzIGJ5IHRoZSBidmVjcyBudW1iZXIKb3ZlcnNpemVkIHZhbHVlIHMtPmluc2Vy
dF9iaW9fc2VjdG9ycyBmcm9tIGNvZGUgYmxvY2sgNCwKICAgICAgICBtaW4oc2VjdG9ycywg
YmlvX3NlY3RvcnMoYmlvKSArIHJlYWRhKQpUaGVyZSBhcmUgdHdvIHBvc3NpYmlsaXR5IGZv
ciBvdmVyc2l6ZWQgcmVyZXN1bHQsCi0gYmlvX3NlY3RvcnMoYmlvKSBpcyB2YWxpZCwgYnV0
IGJpb19zZWN0b3JzKGJpbykgKyByZWFkYSBpcyBvdmVyc2l6ZWQuCi0gc2VjdG9ycyA8IGJp
b19zZWN0b3JzKGJpbykgKyByZWFkYSwgYnV0IHNlY3RvcnMgaXMgb3ZlcnNpemVkLgoKRnJv
bSBhIGJ1ZyByZXBvcnQgdGhlIHJlc3VsdCBvZiAiRElWX1JPVU5EX1VQKHMtPmluc2VydF9i
aW9fc2VjdG9ycywKUEFHRV9TRUNUT1JTKSIgZnJvbSBjb2RlIGJsb2NrIDYgY2FuIGJlIDM0
NCwgMjgyLCA5NDYsIDM0MiBhbmQgbWFueQpvdGhlciB2YWx1ZXMgd2hpY2ggbGFydGhlciB0
aGFuIEJJT19NQVhfVkVDUyAoYS5rLmEgMjU2KS4gV2hlbiBjYWxsaW5nCmJpb19hbGxvY19i
aW9zZXQoKSB3aXRoIHN1Y2ggbGFyZ2VyLXRoYW4tMjU2IHZhbHVlIGFzIHRoZSAybmQgcGFy
YW1ldGVyLAp0aGlzIHZhbHVlIHdpbGwgZXZlbnR1YWxseSBiZSBzZW50IHRvIGJpb3ZlY19z
bGFiKCkgYXMgcGFyYW1ldGVyCiducl92ZWNzJyBpbiBmb2xsb3dpbmcgY29kZSBwYXRoLAog
ICBiaW9fYWxsb2NfYmlvc2V0KCkgPT0+IGJ2ZWNfYWxsb2MoKSA9PT4gYmlvdmVjX3NsYWIo
KQpCZWNhdXNlIHBhcmFtZXRlciAnbnJfdmVjcycgaXMgbGFyZ2VyLXRoYW4tMjU2IHZhbHVl
LCB0aGUgcGFuaWMgYnkgQlVHKCkKaW4gY29kZSBibG9jayAzIGlzIHRyaWdnZXJlZCBpbnNp
ZGUgYmlvdmVjX3NsYWIoKS4KCkZyb20gdGhlIGFib3ZlIGFuYWx5c2lzLCB3ZSBrbm93IHRo
YXQgdGhlIDR0aCBwYXJhbWV0ZXIgJ3NlY3Rvcicgc2VudAppbnRvIGNhY2hlZF9kZXZfY2Fj
aGVfbWlzcygpIG1heSBjYXVzZSBvdmVyZmxvdyBpbiBjb2RlIGJsb2NrIDUgYW5kIDYsCmFu
ZCBmaW5hbGx5IGNhdXNlIGtlcm5lbCBwYW5pYyBpbiBjb2RlIGJsb2NrIDIgYW5kIDMuIEFu
ZCBpZiByZXN1bHQgb2YKYmlvX3NlY3RvcnMoYmlvKSArIHJlYWRhIGV4Y2VlZHMgdmFsaWQg
YnZlY3MgbnVtYmVyLCBpdCBtYXkgYWxzbyB0cmlnZ2VyCmtlcm5lbCBwYW5pYyBpbiBjb2Rl
IGJsb2NrIDMgZnJvbSBjb2RlIGJsb2NrIDYuCgpOb3cgdGhlIGFsbW9zdC11c2VsZXNzIHJl
YWRhaGVhZCBzaXplIGZvciBjYWNoZSBtaXNzaW5nIHJlcXVlc3QgYmFjayB0bwpiYWNraW5n
IGRldmljZSBpcyByZW1vdmVkLCB0aGlzIHBhdGNoIGNhbiBmaXggdGhlIG92ZXJzaXplZCBp
c3N1ZSB3aXRoCm1vcmUgc2ltcGxlciBtZXRob2QuCi0gYWRkIGEgbG9jYWwgdmFyaWFibGUg
c2l6ZV9saW1pdCwgIHNldCBpdCBieSB0aGUgbWluaW11bSB2YWx1ZSBmcm9tCiAgdGhlIG1h
eCBia2V5IHNpemUgYW5kIG1heCBiaW8gYnZlY3MgbnVtYmVyLgotIHNldCBzLT5pbnNlcnRf
YmlvX3NlY3RvcnMgYnkgdGhlIG1pbmltdW0gdmFsdWUgZnJvbSBzaXplX2xpbWl0LAogIHNl
Y3RvcnMsIGFuZCB0aGUgc2VjdG9ycyBzaXplIG9mIGJpby4KLSByZXBsYWNlIHNlY3RvcnMg
Ynkgcy0+aW5zZXJ0X2Jpb19zZWN0b3JzIHRvIGRvIGJpb19uZXh0X3NwbGl0LgoKQnkgdGhl
IGFib3ZlIG1ldGhvZCB3aXRoIHNpemVfbGltaXQsIHMtPmluc2VydF9iaW9fc2VjdG9ycyB3
aWxsIG5ldmVyCnJlc3VsdCBvdmVyc2l6ZWQgcmVwbGFjZV9rZXkgc2l6ZSBvciBiaW8gYnZl
Y3MgbnVtYmVyLiBBbmQgc3BsaXQgYmlvCidtaXNzJyBmcm9tIGJpb19uZXh0X3NwbGl0KCkg
d2lsbCBhbHdheXMgbWF0Y2ggdGhlIHNpemUgb2YgJ2NhY2hlX2JpbycsCnRoYXQgaXMgdGhl
IGN1cnJlbnQgbWF4aW11bSBiaW8gc2l6ZSB3ZSBjYW4gc2VudCB0byBiYWNraW5nIGRldmlj
ZSBmb3IKZmV0Y2hpbmcgdGhlIGNhY2hlIG1pc3NpbmcgZGF0YS4KCkN1cnJlbnQgcHJvYmxt
YXRpYyBjb2RlIGNhbiBiZSBwYXJ0aWFsbHkgZm91bmQgc2luY2UgTGludXggdjMuMTMtcmMx
LAp0aGVyZWZvcmUgYWxsIG1haW50YWluZWQgc3RhYmxlIGtlcm5lbHMgc2hvdWxkIHRyeSB0
byBhcHBseSB0aGlzIGZpeC4KClJlcG9ydGVkLWJ5OiBBbGV4YW5kZXIgVWxscmljaCA8ZWFs
ZXgxOTc5QGdtYWlsLmNvbT4KUmVwb3J0ZWQtYnk6IERpZWdvIEVyY29sYW5pIDxkaWVnby5l
cmNvbGFuaUBnbWFpbC5jb20+ClJlcG9ydGVkLWJ5OiBKYW4gU3p1YmlhayA8amFuLnN6dWJp
YWtAbGludXhwb2xza2EucGw+ClJlcG9ydGVkLWJ5OiBNYXJjbyBSZWJoYW4gPG1lQGRibHNh
aWtvLm5ldD4KUmVwb3J0ZWQtYnk6IE1hdHRoaWFzIEZlcmRpbmFuZCA8YmNhY2hlQG1mZWR2
Lm5ldD4KUmVwb3J0ZWQtYnk6IFRob3JzdGVuIEtuYWJlIDxsaW51eEB0aG9yc3Rlbi1rbmFi
ZS5kZT4KUmVwb3J0ZWQtYnk6IFZpY3RvciBXZXN0ZXJodWlzIDx2aWN0b3JAd2VzdGVyaHUu
aXM+ClJlcG9ydGVkLWJ5OiBWb2p0ZWNoIFBhdmxpayA8dm9qdGVjaEBzdXNlLmN6PgpTaWdu
ZWQtb2ZmLWJ5OiBDb2x5IExpIDxjb2x5bGlAc3VzZS5kZT4KQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcKQ2M6IENocmlzdG9waCBIZWxsd2lnIDxoY2hAbHN0LmRlPgpDYzogS2VudCBP
dmVyc3RyZWV0IDxrZW50Lm92ZXJzdHJlZXRAZ21haWwuY29tPgpDYzogTml4IDxuaXhAZXNw
ZXJpLm9yZy51az4KQ2M6IFRha2FzaGkgSXdhaSA8dGl3YWlAc3VzZS5jb20+Ci0tLQpDaGFu
Z2Vsb2csCnY1LCBpbXByb3ZlbWVudCBhbmQgZml4IGJhc2VkIG9uIHY0IGNvbW1lbnRzIGZy
b20gQ2hyaXN0b3BoIEhlbGx3aWcKICAgIGFuZCBOaXguCnY0LCBub3QgZGlyZWN0bHkgYWNj
ZXNzIEJJT19NQVhfVkVDUyBhbmQgcmVkdWNlIHJlYWRhIHZhbHVlIHRvIGF2b2lkCiAgICBv
dmVyc2l6ZWQgYnZlY3MgbnVtYmVyLCBieSBoaW50IGZyb20gQ2hyaXN0b3BoIEhlbGx3aWcu
CnYzLCBmaXggdHlwbyBpbiB2Mi4KdjIsIGZpeCB0aGUgYnlwYXNzIGJpbyBzaXplIGNhbGN1
bGF0aW9uIGluIHYxLgp2MSwgdGhlIGluaXRpYWwgdmVyc2lvbi4KCiBkcml2ZXJzL21kL2Jj
YWNoZS9yZXF1ZXN0LmMgfCA4ICsrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hl
L3JlcXVlc3QuYyBiL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYwppbmRleCBhYjhmZjE4
ZGYzMmEuLmQ4NTVhODg4MmNiYyAxMDA2NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvcmVx
dWVzdC5jCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL3JlcXVlc3QuYwpAQCAtODgyLDYgKzg4
Miw3IEBAIHN0YXRpYyBpbnQgY2FjaGVkX2Rldl9jYWNoZV9taXNzKHN0cnVjdCBidHJlZSAq
Yiwgc3RydWN0IHNlYXJjaCAqcywKIAlpbnQgcmV0ID0gTUFQX0NPTlRJTlVFOwogCXN0cnVj
dCBjYWNoZWRfZGV2ICpkYyA9IGNvbnRhaW5lcl9vZihzLT5kLCBzdHJ1Y3QgY2FjaGVkX2Rl
diwgZGlzayk7CiAJc3RydWN0IGJpbyAqbWlzcywgKmNhY2hlX2JpbzsKKwl1bnNpZ25lZCBp
bnQgc2l6ZV9saW1pdDsKIAogCXMtPmNhY2hlX21pc3NlZCA9IDE7CiAKQEAgLTg5MSw3ICs4
OTIsMTAgQEAgc3RhdGljIGludCBjYWNoZWRfZGV2X2NhY2hlX21pc3Moc3RydWN0IGJ0cmVl
ICpiLCBzdHJ1Y3Qgc2VhcmNoICpzLAogCQlnb3RvIG91dF9zdWJtaXQ7CiAJfQogCi0Jcy0+
aW5zZXJ0X2Jpb19zZWN0b3JzID0gbWluKHNlY3RvcnMsIGJpb19zZWN0b3JzKGJpbykpOwor
CS8qIExpbWl0YXRpb24gZm9yIHZhbGlkIHJlcGxhY2Uga2V5IHNpemUgYW5kIGNhY2hlX2Jp
byBidmVjcyBudW1iZXIgKi8KKwlzaXplX2xpbWl0ID0gbWluX3QodW5zaWduZWQgaW50LCBi
aW9fbWF4X3NlZ3MoVUlOVF9NQVgpICogUEFHRV9TRUNUT1JTLAorCQkJICAgKDEgPDwgS0VZ
X1NJWkVfQklUUykgLSAxKTsKKwlzLT5pbnNlcnRfYmlvX3NlY3RvcnMgPSBtaW4zKHNpemVf
bGltaXQsIHNlY3RvcnMsIGJpb19zZWN0b3JzKGJpbykpOwogCiAJcy0+aW9wLnJlcGxhY2Vf
a2V5ID0gS0VZKHMtPmlvcC5pbm9kZSwKIAkJCQkgYmlvLT5iaV9pdGVyLmJpX3NlY3RvciAr
IHMtPmluc2VydF9iaW9fc2VjdG9ycywKQEAgLTkwMyw3ICs5MDcsNyBAQCBzdGF0aWMgaW50
IGNhY2hlZF9kZXZfY2FjaGVfbWlzcyhzdHJ1Y3QgYnRyZWUgKmIsIHN0cnVjdCBzZWFyY2gg
KnMsCiAKIAlzLT5pb3AucmVwbGFjZSA9IHRydWU7CiAKLQltaXNzID0gYmlvX25leHRfc3Bs
aXQoYmlvLCBzZWN0b3JzLCBHRlBfTk9JTywgJnMtPmQtPmJpb19zcGxpdCk7CisJbWlzcyA9
IGJpb19uZXh0X3NwbGl0KGJpbywgcy0+aW5zZXJ0X2Jpb19zZWN0b3JzLCBHRlBfTk9JTywg
JnMtPmQtPmJpb19zcGxpdCk7CiAKIAkvKiBidHJlZV9zZWFyY2hfcmVjdXJzZSgpJ3MgYnRy
ZWUgaXRlcmF0b3IgaXMgbm8gZ29vZCBhbnltb3JlICovCiAJcmV0ID0gbWlzcyA9PSBiaW8g
PyBNQVBfRE9ORSA6IC1FSU5UUjsKLS0gCjIuMjYuMgoK
--------------CFC77A06027D258EBB0FF1E3--
