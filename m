Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EACE344FB
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 13:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfFDLAl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 07:00:41 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:50375 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfFDLAl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 07:00:41 -0400
Received: by mail-it1-f196.google.com with SMTP id a186so32679249itg.0;
        Tue, 04 Jun 2019 04:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o1UzTMoQyopOip/dJyIQOvQqjI885b7Gn42CpjI0KJ4=;
        b=OHMmHP/KrSAfLiMP0r7JgejWCz49bYohUe29nT9ufqiQkduTigHuwDU03W3MdIQ2Js
         oFvnrK++hsI176fCfzQ3nq+HTo4wE3GuCjxCWLQQl6/cN+7I4aH0bsL1+o4g/xc9E74w
         XsizX+63z6q+73xwLs0rR8z+PYsLmFTqSYa1I3ONKxKH2pm3QgLs4cGglFyi1SbObBAx
         q/7bfST73AiaPjy9AnNkrR1JFIlwwqrB+bNZSrCCS2kDl5LsdBRtOqsI7oyC/0rOZ/NJ
         9H/SysIMxOvZo1iA6XrjQStlMBBZ4RzueI1jOLtbxg4K5DyCT6xgFWIomYqkmVqV5k4E
         BB2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=o1UzTMoQyopOip/dJyIQOvQqjI885b7Gn42CpjI0KJ4=;
        b=hrWGlP3TgN2+f6qDVREN5oqLZ3Y7JdLMyTd19Uc882dYQ+6cW/SfM7qHnfmuaI3fJT
         yp71Gy0+vnqfsV5mCX0Q9A+sYMZze0Ih1yBFpSbK/csMYpbL+kGHn/DXGyRyguLny69I
         xqpaIoz3r87R1qxOOr9/hcb/E8Za/mdv4j7LzWZi8t6MKY2z5+kijOGrmRa/zSR4ysVP
         fnLJNX6ggbC0G+DC/RlSWxNH7HHI4J+P9HiZbvQXLx0Q2GvlYEx9HHnKqn5qobtt3u2k
         naa1S+dOUDP5afUnwWjSVmD2GlRTsiQq3H8sxD5hwgmuVVqgwF8AZmq4y83ZgAhj0kFi
         ZeHw==
X-Gm-Message-State: APjAAAWpb8MxsyfLs6JvmmDiiZwTIfgtVlQ1lFw08+1iNHT4EzRCJREv
        C8FscFrM+U7Z9VjbNm8IWy38kK58jj0aMrm99g==
X-Google-Smtp-Source: APXvYqxkTo6c0bD5gJQ80S0cN+rImaUg47WYcV7nATdCAQcOqiwaZ3MfklymG7ARjNP5Bmf6wgutnbEmk4qb4jDfksg=
X-Received: by 2002:a24:6e8b:: with SMTP id w133mr6937839itc.82.1559646039916;
 Tue, 04 Jun 2019 04:00:39 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Bj=C3=B8rn_Forsman?= <bjorn.forsman@gmail.com>
Date:   Tue, 4 Jun 2019 13:00:28 +0200
Message-ID: <CAEYzJUH1L5qyWKN3_s4Sz81frho6nKB9bkyDoGxXCvLNO484ew@mail.gmail.com>
Subject: bcache: oops when writing to writeback_percent without a cache device
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi all,

I get a kernel oops from bcache when writing to
/sys/block/bcache0/bcache/writeback_percent and there is no attached
cache device. See the oops itself below my signature.

This is on Linux 4.19.46. I looked in git and see many commits to
bcache lately, but none seem to address this particular issue.

Background: I'm writing to .../writeback_percent with
systemd-tmpfiles. I'd rather not replace it with a script that figures
out whether or not the kernel will oops if writing to the sysfs file
-- the kernel should not oops in the first place.

--
Best regards,
Bj=C3=B8rn Forsman


Jun 04 12:35:42 kernel: BUG: unable to handle kernel NULL pointer
dereference at 0000000000000340
Jun 04 12:35:42 kernel: PGD 0 P4D 0
Jun 04 12:35:42 kernel: Oops: 0000 [#1] SMP PTI
Jun 04 12:35:42 kernel: CPU: 6 PID: 20266 Comm: kworker/6:220 Not
tainted 4.19.46 #1-NixOS
Jun 04 12:35:42 kernel: Hardware name: To Be Filled By O.E.M. To Be
Filled By O.E.M./X99 Extreme4/3.1, BIOS P3.60 04/06/2018
Jun 04 12:35:42 kernel: Workqueue: events update_writeback_rate [bcache]
Jun 04 12:35:42 kernel: RIP: 0010:update_writeback_rate+0x2f/0x2e0 [bcache]
Jun 04 12:35:42 kernel: Code: 41 57 41 56 41 55 41 54 55 53 48 8b af
00 f4 ff ff f0 80 8f 20 f4 ff ff 10 f0 83 44 24 fc 00 48 8b 87 20 f4
ff ff a8 08 74 51 <48> 8b 85 40 03 00 00 a8 08 75 46 8b 47 e8 48 89 fb
85 c0 74 09 80
Jun 04 12:35:42 kernel: RSP: 0018:ffffafbfccdbbe68 EFLAGS: 00010202
Jun 04 12:35:42 kernel: RAX: 0000000000000018 RBX: ffff97bf75f60c80
RCX: ffff97bf7f9a0ee0
Jun 04 12:35:42 kernel: RDX: ffff97bf7f9a0ee0 RSI: 0000000000000180
RDI: ffff97bf75f60c80
Jun 04 12:35:42 kernel: RBP: 0000000000000000 R08: 000073746e657665
R09: 8080808080808080
Jun 04 12:35:42 kernel: R10: ffffafbfc3207de8 R11: fefefefefefefeff
R12: ffff97bf7f9a4d00
Jun 04 12:35:42 kernel: R13: 0000000000000000 R14: ffff97bf75270180
R15: 0ffff97bf7f9a4d0
Jun 04 12:35:42 kernel: FS:  0000000000000000(0000)
GS:ffff97bf7f980000(0000) knlGS:0000000000000000
Jun 04 12:35:42 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 04 12:35:42 kernel: CR2: 0000000000000340 CR3: 0000000709a0a004
CR4: 00000000001606e0
Jun 04 12:35:42 kernel: Call Trace:
Jun 04 12:35:42 kernel:  process_one_work+0x1f4/0x3e0
Jun 04 12:35:42 kernel:  worker_thread+0x2d/0x3e0
Jun 04 12:35:42 kernel:  ? process_one_work+0x3e0/0x3e0
Jun 04 12:35:42 kernel:  kthread+0x113/0x130
Jun 04 12:35:42 kernel:  ? kthread_create_worker_on_cpu+0x70/0x70
Jun 04 12:35:42 kernel:  ret_from_fork+0x35/0x40
Jun 04 12:35:42 kernel: Modules linked in: tcp_diag inet_diag
iptable_mangle xt_CHECKSUM ipt_MASQUERADE ipt_REJECT nf_reject_ipv4
bridge stp llc nf_tables nfnetlink devlink af_packet msr nouveau
edac_core x86_pkg_temp_thermal nls_iso8859_1 video intel_powerclamp
ttm nls_cp437 drm_kms_helper vfat coretemp drm fat crct10dif_pclmul
agpgart iptable_nat nf_nat_ipv4 nf_nat xt_conntrack crc32_pclmul
snd_hda_codec_hdmi nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
libcrc32c ip6t_rpfilter i2c_algo_bit ghash_clmulni_intel fb_sys_fops
syscopyarea ipt_rpfilter sysfillrect pcbc aesni_intel aes_x86_64
crypto_simd cryptd sysimgblt ip6table_raw iptable_raw
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel xt_pkttype
glue_helper snd_hda_codec nf_log_ipv6 intel_cstate uas snd_hda_core
intel_uncore deflate e1000e snd_hwdep
Jun 04 12:35:42 kernel:  snd_pcm iTCO_wdt joydev snd_timer mousedev
mxm_wmi intel_wmi_thunderbolt nf_log_ipv4 evdev input_leds led_class
snd nf_log_common xt_LOG efi_pstore intel_rapl_perf soundcore mac_hid
pstore xt_tcpudp efivars ptp nvme mei_me mei pps_core i2c_i801
nvme_core i2c_core lpc_ich wmi button ip6table_filter pcc_cpufreq
ip6_tables iptable_filter atkbd libps2 serio loop cpufreq_powersave
tun kvm_intel kvm irqbypass efivarfs ip_tables x_tables ipv6 crc_ccitt
autofs4 ext4 crc32c_generic crc16 mbcache jbd2 fscrypto usb_storage
bcache hid_logitech_hidpp crc64 raid1 md_mod hid_logitech_dj
hid_generic usbhid hid sd_mod xhci_pci ahci xhci_hcd libahci libata
ehci_pci ehci_hcd usbcore scsi_mod crc32c_intel usb_common rtc_cmos
dm_mod
Jun 04 12:35:42 kernel: CR2: 0000000000000340
Jun 04 12:35:42 kernel: ---[ end trace 764634a58d34fb7c ]---
Jun 04 12:35:43 kernel: RIP: 0010:update_writeback_rate+0x2f/0x2e0 [bcache]
Jun 04 12:35:43 kernel: Code: 41 57 41 56 41 55 41 54 55 53 48 8b af
00 f4 ff ff f0 80 8f 20 f4 ff ff 10 f0 83 44 24 fc 00 48 8b 87 20 f4
ff ff a8 08 74 51 <48> 8b 85 40 03 00 00 a8 08 75 46 8b 47 e8 48 89 fb
85 c0 74 09 80
Jun 04 12:35:43 kernel: RSP: 0018:ffffafbfccdbbe68 EFLAGS: 00010202
Jun 04 12:35:43 kernel: RAX: 0000000000000018 RBX: ffff97bf75f60c80
RCX: ffff97bf7f9a0ee0
Jun 04 12:35:43 kernel: RDX: ffff97bf7f9a0ee0 RSI: 0000000000000180
RDI: ffff97bf75f60c80
Jun 04 12:35:43 kernel: RBP: 0000000000000000 R08: 000073746e657665
R09: 8080808080808080
Jun 04 12:35:43 kernel: R10: ffffafbfc3207de8 R11: fefefefefefefeff
R12: ffff97bf7f9a4d00
Jun 04 12:35:43 kernel: R13: 0000000000000000 R14: ffff97bf75270180
R15: 0ffff97bf7f9a4d0
Jun 04 12:35:43 kernel: FS:  0000000000000000(0000)
GS:ffff97bf7f980000(0000) knlGS:0000000000000000
Jun 04 12:35:43 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 04 12:35:43 kernel: CR2: 0000000000000340 CR3: 0000000709a0a004
CR4: 00000000001606e0
