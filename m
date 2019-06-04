Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29A734B50
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfFDO7m (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 10:59:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:34996 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727911AbfFDO7k (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 10:59:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A90A5AE79;
        Tue,  4 Jun 2019 14:59:38 +0000 (UTC)
Subject: Re: bcache: oops when writing to writeback_percent without a cache
 device
To:     =?UTF-8?Q?Bj=c3=b8rn_Forsman?= <bjorn.forsman@gmail.com>
References: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <6823d3ab-5f93-da74-0dbc-19bdb7be6907@suse.de>
Date:   Tue, 4 Jun 2019 22:59:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/4 7:00 下午, Bjørn Forsman wrote:
> Hi all,
> 
> I get a kernel oops from bcache when writing to
> /sys/block/bcache0/bcache/writeback_percent and there is no attached
> cache device. See the oops itself below my signature.
> 
> This is on Linux 4.19.46. I looked in git and see many commits to
> bcache lately, but none seem to address this particular issue.
> 
> Background: I'm writing to .../writeback_percent with
> systemd-tmpfiles. I'd rather not replace it with a script that figures
> out whether or not the kernel will oops if writing to the sysfs file
> -- the kernel should not oops in the first place.

Hi Bjorn,

Thank you for the reporting. I believe this is a case we missed in
testings. When a bcache device is not attached, it does not make sense
to update the writeback rate in period by the changing of writeback_percent.

I will post a patch for your testing soon.

Coly Li


> 
> Jun 04 12:35:42 kernel: BUG: unable to handle kernel NULL pointer
> dereference at 0000000000000340
> Jun 04 12:35:42 kernel: PGD 0 P4D 0
> Jun 04 12:35:42 kernel: Oops: 0000 [#1] SMP PTI
> Jun 04 12:35:42 kernel: CPU: 6 PID: 20266 Comm: kworker/6:220 Not
> tainted 4.19.46 #1-NixOS
> Jun 04 12:35:42 kernel: Hardware name: To Be Filled By O.E.M. To Be
> Filled By O.E.M./X99 Extreme4/3.1, BIOS P3.60 04/06/2018
> Jun 04 12:35:42 kernel: Workqueue: events update_writeback_rate [bcache]
> Jun 04 12:35:42 kernel: RIP: 0010:update_writeback_rate+0x2f/0x2e0 [bcache]
> Jun 04 12:35:42 kernel: Code: 41 57 41 56 41 55 41 54 55 53 48 8b af
> 00 f4 ff ff f0 80 8f 20 f4 ff ff 10 f0 83 44 24 fc 00 48 8b 87 20 f4
> ff ff a8 08 74 51 <48> 8b 85 40 03 00 00 a8 08 75 46 8b 47 e8 48 89 fb
> 85 c0 74 09 80
> Jun 04 12:35:42 kernel: RSP: 0018:ffffafbfccdbbe68 EFLAGS: 00010202
> Jun 04 12:35:42 kernel: RAX: 0000000000000018 RBX: ffff97bf75f60c80
> RCX: ffff97bf7f9a0ee0
> Jun 04 12:35:42 kernel: RDX: ffff97bf7f9a0ee0 RSI: 0000000000000180
> RDI: ffff97bf75f60c80
> Jun 04 12:35:42 kernel: RBP: 0000000000000000 R08: 000073746e657665
> R09: 8080808080808080
> Jun 04 12:35:42 kernel: R10: ffffafbfc3207de8 R11: fefefefefefefeff
> R12: ffff97bf7f9a4d00
> Jun 04 12:35:42 kernel: R13: 0000000000000000 R14: ffff97bf75270180
> R15: 0ffff97bf7f9a4d0
> Jun 04 12:35:42 kernel: FS:  0000000000000000(0000)
> GS:ffff97bf7f980000(0000) knlGS:0000000000000000
> Jun 04 12:35:42 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jun 04 12:35:42 kernel: CR2: 0000000000000340 CR3: 0000000709a0a004
> CR4: 00000000001606e0
> Jun 04 12:35:42 kernel: Call Trace:
> Jun 04 12:35:42 kernel:  process_one_work+0x1f4/0x3e0
> Jun 04 12:35:42 kernel:  worker_thread+0x2d/0x3e0
> Jun 04 12:35:42 kernel:  ? process_one_work+0x3e0/0x3e0
> Jun 04 12:35:42 kernel:  kthread+0x113/0x130
> Jun 04 12:35:42 kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
> Jun 04 12:35:42 kernel:  ret_from_fork+0x35/0x40
> Jun 04 12:35:42 kernel: Modules linked in: tcp_diag inet_diag
> iptable_mangle xt_CHECKSUM ipt_MASQUERADE ipt_REJECT nf_reject_ipv4
> bridge stp llc nf_tables nfnetlink devlink af_packet msr nouveau
> edac_core x86_pkg_temp_thermal nls_iso8859_1 video intel_powerclamp
> ttm nls_cp437 drm_kms_helper vfat coretemp drm fat crct10dif_pclmul
> agpgart iptable_nat nf_nat_ipv4 nf_nat xt_conntrack crc32_pclmul
> snd_hda_codec_hdmi nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> libcrc32c ip6t_rpfilter i2c_algo_bit ghash_clmulni_intel fb_sys_fops
> syscopyarea ipt_rpfilter sysfillrect pcbc aesni_intel aes_x86_64
> crypto_simd cryptd sysimgblt ip6table_raw iptable_raw
> snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel xt_pkttype
> glue_helper snd_hda_codec nf_log_ipv6 intel_cstate uas snd_hda_core
> intel_uncore deflate e1000e snd_hwdep
> Jun 04 12:35:42 kernel:  snd_pcm iTCO_wdt joydev snd_timer mousedev
> mxm_wmi intel_wmi_thunderbolt nf_log_ipv4 evdev input_leds led_class
> snd nf_log_common xt_LOG efi_pstore intel_rapl_perf soundcore mac_hid
> pstore xt_tcpudp efivars ptp nvme mei_me mei pps_core i2c_i801
> nvme_core i2c_core lpc_ich wmi button ip6table_filter pcc_cpufreq
> ip6_tables iptable_filter atkbd libps2 serio loop cpufreq_powersave
> tun kvm_intel kvm irqbypass efivarfs ip_tables x_tables ipv6 crc_ccitt
> autofs4 ext4 crc32c_generic crc16 mbcache jbd2 fscrypto usb_storage
> bcache hid_logitech_hidpp crc64 raid1 md_mod hid_logitech_dj
> hid_generic usbhid hid sd_mod xhci_pci ahci xhci_hcd libahci libata
> ehci_pci ehci_hcd usbcore scsi_mod crc32c_intel usb_common rtc_cmos
> dm_mod
> Jun 04 12:35:42 kernel: CR2: 0000000000000340
> Jun 04 12:35:42 kernel: ---[ end trace 764634a58d34fb7c ]---
> Jun 04 12:35:43 kernel: RIP: 0010:update_writeback_rate+0x2f/0x2e0 [bcache]
> Jun 04 12:35:43 kernel: Code: 41 57 41 56 41 55 41 54 55 53 48 8b af
> 00 f4 ff ff f0 80 8f 20 f4 ff ff 10 f0 83 44 24 fc 00 48 8b 87 20 f4
> ff ff a8 08 74 51 <48> 8b 85 40 03 00 00 a8 08 75 46 8b 47 e8 48 89 fb
> 85 c0 74 09 80
> Jun 04 12:35:43 kernel: RSP: 0018:ffffafbfccdbbe68 EFLAGS: 00010202
> Jun 04 12:35:43 kernel: RAX: 0000000000000018 RBX: ffff97bf75f60c80
> RCX: ffff97bf7f9a0ee0
> Jun 04 12:35:43 kernel: RDX: ffff97bf7f9a0ee0 RSI: 0000000000000180
> RDI: ffff97bf75f60c80
> Jun 04 12:35:43 kernel: RBP: 0000000000000000 R08: 000073746e657665
> R09: 8080808080808080
> Jun 04 12:35:43 kernel: R10: ffffafbfc3207de8 R11: fefefefefefefeff
> R12: ffff97bf7f9a4d00
> Jun 04 12:35:43 kernel: R13: 0000000000000000 R14: ffff97bf75270180
> R15: 0ffff97bf7f9a4d0
> Jun 04 12:35:43 kernel: FS:  0000000000000000(0000)
> GS:ffff97bf7f980000(0000) knlGS:0000000000000000
> Jun 04 12:35:43 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Jun 04 12:35:43 kernel: CR2: 0000000000000340 CR3: 0000000709a0a004
> CR4: 00000000001606e0
> 


-- 

Coly Li
