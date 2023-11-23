Return-Path: <linux-bcache+bounces-22-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D72147F5873
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Nov 2023 07:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66CECB20C4A
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Nov 2023 06:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 195FB5D8EC;
	Thu, 23 Nov 2023 06:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENbxTS09"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FCED47
	for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2023 22:40:13 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5cca8b559b3so5499017b3.0
        for <linux-bcache@vger.kernel.org>; Wed, 22 Nov 2023 22:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700721613; x=1701326413; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xvPww7AhWG3CbfGrbWKUdfSKgO/CUCH4EsWQ+UgDO0s=;
        b=ENbxTS09hhKdQ8up2EqYEyYWGwk7nMvXbPcBbiT4gKW6aW9LYQBn6SZUfJfiPxlQ5x
         SFs17xdAzkG13sCZkGIULUSKqGK+gs/tStD3xhuPQLPgeqTNp0rnRuxiTtgdeoiHOIBt
         WzrbeS8VnlfdmX7yussVS7/0mBfn6CdXsjRYKvPbd8DoJ6Tj0iGrLkUe2SXBvsT7gMvn
         2KHmO7pSX44J5d/Y0urVY5pWVb2Ci5T7KCVdkwHVeL/3GjxHhVe1ACmcytBksdNHYpWe
         gZpnLVtOKKcmYLagbvg4yreq1y8/lYQCvQA7UPq4KGZp1xO+S1jGwjMP3woanpuZFkj8
         IIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700721613; x=1701326413;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xvPww7AhWG3CbfGrbWKUdfSKgO/CUCH4EsWQ+UgDO0s=;
        b=a0HjVav0fZqoB1CKRUjrdimwiuAsrfUGwkADbTynzCw84828+Os6CaK349pREY+Dzi
         rtL2YauW1CAgumn+GXENOOO9cLzw6TUGCrQv+7IoIRGzLd/w5IUXF29Dp5gxTRufSsxT
         h966rrYujHc3j8xJ4wFoFlIyqwD3HSjmwaUYi0C7GYtD1Ajo4wYJF1uQs8ED9XFkc+CG
         bl5NUkAERQtd5wcqeS31K3z8jQ/CwaAajXo/A2rV7VeVD8b9dvUq2qNYxgBCJLO6kI0I
         QygCACG1/6doiMScsLZXjNMkewZg/zHhBokZMupxTTx1Ch5QKBLtHs/6B3KDU1ikvz5Q
         vB2w==
X-Gm-Message-State: AOJu0YwHGFKF4oArvrRb9qh4x96l5ykWFk1khxCc5HLIv5uRH24RAfI1
	CsHf1FoUx5cnC78kBaJ5+uoMHncMfsJ7ZWuy27xr1rVi/No=
X-Google-Smtp-Source: AGHT+IGzP5DE8Xw3OxUIiTklUWbNtuDAGoPSo8fx/9TagJ8Ty2ZzQBblrv4/h9HIAZkXnYRtUSzNYeDlwSdRhgI5yug=
X-Received: by 2002:a0d:db94:0:b0:5cc:3bb6:2dbb with SMTP id
 d142-20020a0ddb94000000b005cc3bb62dbbmr4404442ywe.22.1700721612730; Wed, 22
 Nov 2023 22:40:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: yubin hou <xiaobinbin432156@gmail.com>
Date: Thu, 23 Nov 2023 14:40:01 +0800
Message-ID: <CAKHpHPRxKoOuuwaHbc-_bG03dkwyzfnAsK5Z==jWCUKryv-O3A@mail.gmail.com>
Subject: bcache
To: linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We found kernel panic in use bcache=E3=80=82 OS kernel use opensuse SLE15-S=
P3

[6059997.631118] BUG: unable to handle page fault for address: 000000000001=
0b83
[6059997.631337] #PF: supervisor write access in kernel mode
[6059997.631504] #PF: error_code(0x0002) - not-present page
[6059997.631672] PGD 1380beb067 P4D 1380beb067 PUD 137a7ac067 PMD 0
[6059997.631865] Oops: 0002 [#1] SMP NOPTI
[6059997.631986] CPU: 27 PID: 0 Comm: swapper/27 Kdump: loaded
Tainted: G           OE     N 5.3.18.20221118 #1 SLE15-SP3
(unreleased)
[6059997.632354] Hardware name: XFUSION 5288 V5/BC11SPSCB0, BIOS 8.58 05/29=
/2023
[6059997.632585] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
[6059997.632745] Code: 75 ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
00 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01
00 00 00 <f0> 0f b1 17 75 09 48 89 d8 5b e9 93 11 2b 00 89 c6 e8 4c 0e
7b ff
[6059997.633336] RSP: 0018:ffffa60647228df8 EFLAGS: 00010046
[6059997.633505] RAX: 0000000000000000 RBX: 0000000000000292 RCX:
0000000080080007
[6059997.633734] RDX: 0000000000000001 RSI: 0000000000000003 RDI:
0000000000010b83
[6059997.633961] RBP: 0000000000000003 R08: 0000000000000001 R09:
ffffffffc0cb6f01
[6059997.634190] R10: ffff99854e5e0000 R11: 0000000000000001 R12:
0000000000000000
[6059997.634418] R13: 0000000000010b83 R14: 0000000000000000 R15:
0000000000000000
[6059997.634648] FS:  0000000000000000(0000) GS:ffff99943fe40000(0000)
knlGS:0000000000000000
[6059997.634906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[6059997.635092] CR2: 0000000000010b83 CR3: 00000017d31ac002 CR4:
00000000007706e0
[6059997.635319] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[6059997.635548] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[6059997.635777] PKRU: 55555554
[6059997.635868] Call Trace:
[6059997.635954]  <IRQ>
[6059997.636029]  try_to_wake_up+0x4c/0x510
[6059997.636161]  ? bch_btree_exit+0x20/0x20 [bcache]
[6059997.636307]  closure_sync_fn+0x18/0x20 [bcache]
[6059997.636450]  blk_update_request+0x22d/0x3a0
[6059997.636594]  scsi_end_request+0x28/0x120 [scsi_mod]
[6059997.636749]  scsi_io_completion+0x78/0x500 [scsi_mod]
[6059997.636905]  blk_done_softirq+0x8f/0xc0
[6059997.637031]  __do_softirq+0xdf/0x2e9
[6059997.637150]  irq_exit+0xdb/0xe0
[6059997.637251]  do_IRQ+0x7f/0xd0
[6059997.637350]  common_interrupt+0xf/0xf
[6059997.637468]  </IRQ>
[6059997.637537] RIP: 0010:cpu_idle_poll+0x40/0x190
[6059997.637683] Code: 4b 0f 1f 44 00 00 fb 66 0f 1f 44 00 00 65 48 8b
04 25 c0 8b 01 00 48 8b 00 a8 08 74 14 eb 25 f3 90 65 48 8b 04 25 c0
8b 01 00 <48> 8b 00 a8 08 75 13 8b 05 2b 14 cd 00 85 c0 75 e4 e8 ba d7
7f ff
[6059997.638274] RSP: 0018:ffffa60640633ec0 EFLAGS: 00000202 ORIG_RAX:
ffffffffffffffde
[6059997.645221] RAX: ffff998503e38000 RBX: 000000000000001b RCX:
000000000000001f
[6059997.652279] RDX: 000000000000001b RSI: 00000000355563e5 RDI:
ffff99943fe6d980
[6059997.659380] RBP: 000000000000001b R08: 0000000000000002 R09:
000000000002c500
[6059997.666523] R10: 0036c88572dd1ad2 R11: 0000000000000000 R12:
0000000000000000
[6059997.673463] R13: 0000000000000000 R14: 0000000000000000 R15:
0000000000000000
[6059997.680218]  do_idle+0x5b/0x280
[6059997.686983]  ? do_idle+0x192/0x280
[6059997.693639]  cpu_startup_entry+0x19/0x20
[6059997.700546]  start_secondary+0x155/0x1a0
[6059997.707121]  secondary_startup_64_no_verify+0xc2/0xd0
[6059997.713703] Modules linked in: yrfs(OEN) nls_utf8(EN) isofs(EN)
cdrom(EN) loop(EN) binfmt_misc(EN) xfs(EN) libcrc32c(EN) bcache(EN)
crc64(EN) rdma_ucm(EN) ib_uverbs(EN) msr(EN) mptctl(EN) mptbase(EN)
rdma_cm(EN) iw_cm(EN) ib_cm(EN) ib_core(EN) configfs(EN) tcp_diag(EN)
inet_diag(EN) cpufreq_conservative(EN) cuse(EN) fuse(EN) af_packet(EN)
bonding(EN) intel_rapl_msr(EN) intel_rapl_common(EN)
isst_if_common(EN) skx_edac(EN) nfit(EN) libnvdimm(EN) rfkill(EN)
x86_pkg_temp_thermal(EN) coretemp(EN) kvm_intel(EN) kvm(EN) sunrpc(EN)
irqbypass(EN) nls_iso8859_1(EN) crc32_pclmul(EN) nls_cp437(EN)
ipmi_si(EN) ghash_clmulni_intel(EN) vfat(EN) aesni_intel(EN)
ipmi_devintf(EN) crypto_simd(EN) cryptd(EN) fat(EN) glue_helper(EN)
wdat_wdt(EN) ipmi_msghandler(EN) efi_pstore(EN) pcspkr(EN) ses(EN)
enclosure(EN) scsi_transport_sas(EN) ioatdma(EN) sg(EN) joydev(EN)
mei_me(EN) dca(EN) mei(EN) i2c_i801(EN) lpc_ich(EN)
acpi_power_meter(EN) button(EN) ip_tables(EN) x_tables(EN) ext4(EN)
crc16(EN) mbcache(EN)
[6059997.713740]  jbd2(EN) sd_mod(EN) t10_pi(EN) hid_generic(EN)
uas(EN) usb_storage(EN) usbhid(EN) mlx5_core(EN) ahci(EN) xhci_pci(EN)
mlxfw(EN) pci_hyperv_intf(EN) crc32c_intel(EN) libahci(EN)
xhci_hcd(EN) tls(EN) libata(EN) megaraid_sas(EN) i40e(EN) usbcore(EN)
scsi_mod(EN) efivarfs(EN) [last unloaded: yrfs]
[6059997.795788] Supported: No, Unreleased kernel
[6059997.804221] CR2: 0000000000010b83

