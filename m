Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3041B699FC8
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Feb 2023 23:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPWcL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Feb 2023 17:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBPWcL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Feb 2023 17:32:11 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72A943453
        for <linux-bcache@vger.kernel.org>; Thu, 16 Feb 2023 14:31:41 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 766DC85;
        Thu, 16 Feb 2023 14:31:14 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id kF-ASb5FDWAp; Thu, 16 Feb 2023 14:31:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 054AF40;
        Thu, 16 Feb 2023 14:31:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 054AF40
Date:   Thu, 16 Feb 2023 14:31:09 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Matthias Ferdinand <bcache@mfedv.net>
cc:     Stefan Boehringer <me@s-boehringer.org>,
        linux-bcache@vger.kernel.org
Subject: Re: bcache kernel panic
In-Reply-To: <Y+6b6fRbZK6zdcSv@xoff>
Message-ID: <89b48ee4-13bf-ebc-bf85-e2d6e5c294@ewheeler.net>
References: <54d572de-2d65-2a35-ae33-3a5a0cfe3db6@s-boehringer.org> <Y+5vKc/X+x9K/v0g@xoff> <23c21534-b729-113c-7ae2-14a8542a3311@s-boehringer.org> <Y+6b6fRbZK6zdcSv@xoff>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-1011986855-1676586239=:6562"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1011986855-1676586239=:6562
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 16 Feb 2023, Matthias Ferdinand wrote:
> On Thu, Feb 16, 2023 at 07:06:05PM +0100, Stefan Boehringer wrote:
> > Dear Mathias,
> > 
> > thank you for the update. I look forward to the update.

FYI: This is the bcache-specific update:

	https://lore.kernel.org/lkml/20230106060229.never.047-kees@kernel.org/

All it does is ignore the warning! You will not get the warning in your 
kernel logs; whatever issue you are having, this most certainly will 
_not_ fix it.

From the dmesg log you pasted, it looks like you are using a kernel 
provided by tumbleweed, so you might try building your own from the 
vanilla tree.

-Eric

> > For me, it is a hard crash as the screen goes green and I cannot input 
> > anything anymore. I still hear hard-drive activity, so the system 
> > seems to be still up (maybe usable via ssh, but haven't tried). I have 
> > to perform a hard reset.
> > 
> > I have not experienced any data loss.
> 
> Major nuisance on desktop or notebook machines indeed.
> 
> I am not a tumbleweed user, but for the time being you might want to go
> back to a slightly older kernel (e.g. on Arch Linux there is the
> fast-moving "linux" package and a separate "linux-lts" package).
> 
> I haven't seen machines locking up or lose keyboard/screen from a kernel
> WARN() (but also don't see many WARNs to begin with...).  Is this
> perhaps a hardening feature in SuSE/tumbleweed? Some people want WARN()s
> to be handled harshly, I found this discussion on lwn:
>     https://lwn.net/Articles/876209/
> If so, you could tune it to be less strict until bcache gets patched in
> the mainstream kernel.



> 
> Matthias
> 
> > 
> > Thank you, best,
> > 
> >     Stefan
> > 
> > On 2/16/23 19:00, Matthias Ferdinand wrote:
> > > Hi,
> > > 
> > > there has been a thread referencing "field-spanning writes" recently:
> > > 
> > >      https://www.spinics.net/lists/linux-bcache/msg11631.html
> > > 
> > > I understood this to be some kind of false positive, to be fixed in some
> > > later relase of 6.1.x kernels.
> > > 
> > > Does the system become unusable or is this green-screen just a warning?
> > > 
> > > Regards
> > > Matthias Ferdinand
> > > 
> > > 
> > > On Thu, Feb 16, 2023 at 05:58:15PM +0100, Stefan Boehringer wrote:
> > > > Dear bache maintainer,
> > > > 
> > > > I would like to report a kernel panic for bcache that is unfortunately not
> > > > reproducible. I get this error roughly once a week, resulting in a green
> > > > screen on my system. Please let me know, if I can provide further
> > > > information to fix the bug. Below dmesg output copy-pasted as instructed.
> > > > 
> > > > Thank you, best,
> > > > 
> > > >      Stefan
> > > > 
> > > > 
> > > > Feb 15 08:44:49.840548 myhost kernel: ------------[ cut here ]------------
> > > > 
> > > > Feb 15 08:44:49.840614 myhost kernel: memcpy: detected field-spanning write
> > > > (size 264) of single field "&i
> > > > ->j" at drivers/md/bcache/journal.c:152 (size 240)
> > > > Feb 15 08:44:49.840633 myhost kernel: WARNING: CPU: 7 PID: 755 at
> > > > drivers/md/bcache/journal.c:152 journal_
> > > > read_bucket+0x3df/0x490 [bcache]
> > > > Feb 15 08:44:49.840649 myhost kernel: Modules linked in: snd_hwdep(+) kvm(+)
> > > > snd_pcm videobuf2_vmalloc(+)
> > > > videobuf2_memops snd_timer videobuf2_v4l2 sr_mod(+) snd real
> > > > tek cdrom pcspkr efi_pstore k10temp videobuf2_common i2c_piix4
> > > > hid_plantronics(+) irqbypass pcc_cpufreq(-) mdio_devres joydev soundcore
> > > > cfg80211 libphy bcache tiny_power_button acpi_cpufreq button fuse configfs
> > > > dmi_sysfs ip_tables x_tables btusb btrtl btbcm btintel btmtk bluetooth
> > > > hid_generic uas ecdh_generic usbhid usb_storage rfkill amdgpu
> > > > crct10dif_pclmul crc32_pclmul polyval_clmulni polyval_generic gf128mul
> > > > drm_ttm_helper ttm ghash_clmulni_intel iommu_v2 xhci_pci gpu_sched
> > > > sha512_ssse3 xhci_pci_renesas xhci_hcd drm_buddy aesni_intel
> > > > drm_display_helper nvme crypto_simd usbcore cryptd cec ccp nvme_core
> > > > sp5100_tco rc_core amd_sfh video wmi btrfs blake2b_generic libcrc32c
> > > > crc32c_intel xor raid6_pq v4l2loopback(O) videodev mc sg dm_multipath dm_mod
> > > > scsi_dh_rdac scsi_dh_emc scsi_dh_alua msr efivarfs
> > > > Feb 15 08:44:49.840786 myhost kernel: CPU: 7 PID: 755 Comm: kworker/7:2
> > > > Tainted: G           O       6.1.10-1-default #1 openSUSE Tumbleweed
> > > > 22576c8b47239465c1855ce27337697dac36c24c
> > > > Feb 15 08:44:49.840809 myhost kernel: Hardware name: GIGABYTE
> > > > GB-BRR7H-4800/GB-BRR7H-4800, BIOS F5 05/05/2021
> > > > Feb 15 08:44:49.840827 myhost kernel: Workqueue: events
> > > > register_cache_worker [bcache]
> > > > Feb 15 08:44:49.840844 myhost kernel: RIP:
> > > > 0010:journal_read_bucket+0x3df/0x490 [bcache]
> > > > Feb 15 08:44:49.840860 myhost kernel: Code: 00 00 00 48 89 ee 48 c7 c2 70 c4
> > > > cb c0 48 c7 c7 a8 c4 cb c0 4c 89 5c 24 48 48 89 44 24 20 c6 05 21 c8 02 00
> > > > 01 e8 3e f5 65 f1 <0f> 0b 4c 8b 5c 24 48 48 8b 44 24 20 e9 6b ff ff ff 44 8b
> > > > 74 24 54
> > > > Feb 15 08:44:49.840884 myhost kernel: RSP: 0018:ffffb6fe01893c98 EFLAGS:
> > > > 00010282
> > > > Feb 15 08:44:49.840900 myhost kernel: RAX: 0000000000000000 RBX:
> > > > ffff95ebc2a3c000 RCX: 0000000000000027
> > > > Feb 15 08:44:49.840915 myhost kernel: RDX: ffff95f2af7e24e8 RSI:
> > > > 0000000000000001 RDI: ffff95f2af7e24e0
> > > > Feb 15 08:44:49.840932 myhost kernel: RBP: 0000000000000108 R08:
> > > > 0000000000000000 R09: ffffb6fe01893b40
> > > > Feb 15 08:44:49.840948 myhost kernel: R10: 0000000000000003 R11:
> > > > ffff95f2cf2ff228 R12: dead000000000122
> > > > Feb 15 08:44:49.840965 myhost kernel: R13: dead000000000100 R14:
> > > > ffff95ebc46a8400 R15: ffffb6fe01893e08
> > > > Feb 15 08:44:49.840981 myhost kernel: FS:  0000000000000000(0000)
> > > > GS:ffff95f2af7c0000(0000) knlGS:0000000000000000
> > > > Feb 15 08:44:49.840998 myhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
> > > > 0000000080050033
> > > > Feb 15 08:44:49.841014 myhost kernel: CR2: 00007f166249afe0 CR3:
> > > > 000000010323e000 CR4: 0000000000350ee0
> > > > Feb 15 08:44:49.841030 myhost kernel: Call Trace:
> > > > Feb 15 08:44:49.841047 myhost kernel:  <TASK>
> > > > Feb 15 08:44:49.841067 myhost kernel:  ? bch_btree_exit+0x20/0x20 [bcache
> > > > f7676faef63111511583961fa9b18ec07deb88c4]
> > > > Feb 15 08:44:49.841090 myhost kernel:  bch_journal_read+0x79/0x320 [bcache
> > > > f7676faef63111511583961fa9b18ec07deb88c4]
> > > > Feb 15 08:44:49.841108 myhost kernel: register_cache_worker+0x99f/0x11c0
> > > > [bcache f7676faef63111511583961fa9b18ec07deb88c4]
> > > > Feb 15 08:44:49.841125 myhost kernel:  ?
> > > > finish_task_switch.isra.0+0x90/0x2d0
> > > > Feb 15 08:44:49.841141 myhost kernel:  process_one_work+0x20c/0x3d0
> > > > Feb 15 08:44:49.841157 myhost kernel:  worker_thread+0x4a/0x3b0
> > > > Feb 15 08:44:49.841173 myhost kernel:  ? process_one_work+0x3d0/0x3d0
> > > > Feb 15 08:44:49.841188 myhost kernel:  kthread+0xd7/0x100
> > > > Feb 15 08:44:49.841203 myhost kernel:  ? kthread_complete_and_exit+0x20/0x20
> > > > Feb 15 08:44:49.841219 myhost kernel:  ret_from_fork+0x1f/0x30
> > > > Feb 15 08:44:49.841236 myhost kernel:  </TASK>
> > > > Feb 15 08:44:49.841251 myhost kernel: ---[ end trace 0000000000000000 ]---
> > > > Feb 15 08:44:49.848553 myhost kernel: sr 1:0:0:0: [sr0] scsi3-mmc drive:
> > > > 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> > > > Feb 15 08:44:49.848843 myhost kernel: cdrom: Uniform CD-ROM driver Revision:
> > > > 3.20
> > > > Feb 15 08:44:49.872544 myhost kernel: plantronics 0003:047F:1200.0004:
> > > > input,hiddev96,hidraw3: USB HID v1.11 Device [Plantronics Plantronics
> > > > Calisto 7200] on usb-0000:04:00.0-2.4/input3
> > > > Feb 15 08:44:49.876547 myhost kernel: sr 1:0:0:0: Attached scsi CD-ROM sr0
> > > > Feb 15 08:44:49.880540 myhost kernel: ------------[ cut here ]------------
> 
--8323328-1011986855-1676586239=:6562--
