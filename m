Return-Path: <linux-bcache+bounces-23-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93C5C7F6B6B
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 05:33:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 09263B20CFC
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Nov 2023 04:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C743F33F2;
	Fri, 24 Nov 2023 04:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: linux-bcache@vger.kernel.org
X-Greylist: delayed 922 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Nov 2023 20:33:16 PST
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BB284
	for <linux-bcache@vger.kernel.org>; Thu, 23 Nov 2023 20:33:16 -0800 (PST)
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 81A341FE2B;
	Thu, 23 Nov 2023 17:10:56 +0000 (UTC)
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 7809D132F8;
	Thu, 23 Nov 2023 17:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id SHgLCZ+HX2UoJwAAn2gu4w
	(envelope-from <colyli@suse.de>); Thu, 23 Nov 2023 17:10:55 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: bcache
From: Coly Li <colyli@suse.de>
In-Reply-To: <CAKHpHPRxKoOuuwaHbc-_bG03dkwyzfnAsK5Z==jWCUKryv-O3A@mail.gmail.com>
Date: Fri, 24 Nov 2023 01:08:31 +0800
Cc: linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <845C5DB2-16DB-4DE2-91D5-E8A06E9C10B8@suse.de>
References: <CAKHpHPRxKoOuuwaHbc-_bG03dkwyzfnAsK5Z==jWCUKryv-O3A@mail.gmail.com>
To: yubin hou <xiaobinbin432156@gmail.com>
X-Mailer: Apple Mail (2.3774.200.91.1.1)
X-Spamd-Bar: ++++++++++++
X-Spam-Score: 12.39
X-Rspamd-Server: rspamd1
X-Spam-Level: *
X-Rspamd-Queue-Id: 81A341FE2B
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=suse.de (policy=none);
	spf=softfail (smtp-out2.suse.de: 2a07:de40:b281:104:10:150:64:98 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Spamd-Result: default: False [12.39 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_SPAM(5.10)[100.00%];
	 SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:98:from];
	 TO_DN_SOME(0.00)[];
	 MV_CASE(0.50)[];
	 R_SPF_SOFTFAIL(4.60)[~all];
	 RCVD_COUNT_THREE(0.00)[3];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_TWO(0.00)[2];
	 FREEMAIL_TO(0.00)[gmail.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_MATCH_FROM(0.00)[];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[];
	 DMARC_POLICY_SOFTFAIL(0.10)[suse.de : No valid SPF, No valid DKIM,none]

Hi Yubin,

There is no product named openSUSE SLE15-SP3. If you mean openSUSE 15.3, =
it is out of life cycle for a while, a better choice should be updating =
to latest openSUSE version.
For SLE15-SP3, this is an Enterprise Linux product, you may ask support =
channel of the product vendor.

Thanks.

Coly Li

> 2023=E5=B9=B411=E6=9C=8823=E6=97=A5 14:40=EF=BC=8Cyubin hou =
<xiaobinbin432156@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> We found kernel panic in use bcache=E3=80=82 OS kernel use opensuse =
SLE15-SP3
>=20
> [6059997.631118] BUG: unable to handle page fault for address: =
0000000000010b83
> [6059997.631337] #PF: supervisor write access in kernel mode
> [6059997.631504] #PF: error_code(0x0002) - not-present page
> [6059997.631672] PGD 1380beb067 P4D 1380beb067 PUD 137a7ac067 PMD 0
> [6059997.631865] Oops: 0002 [#1] SMP NOPTI
> [6059997.631986] CPU: 27 PID: 0 Comm: swapper/27 Kdump: loaded
> Tainted: G           OE     N 5.3.18.20221118 #1 SLE15-SP3
> (unreleased)
> [6059997.632354] Hardware name: XFUSION 5288 V5/BC11SPSCB0, BIOS 8.58 =
05/29/2023
> [6059997.632585] RIP: 0010:_raw_spin_lock_irqsave+0x1e/0x40
> [6059997.632745] Code: 75 ff 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00
> 00 53 9c 58 0f 1f 44 00 00 48 89 c3 fa 66 0f 1f 44 00 00 31 c0 ba 01
> 00 00 00 <f0> 0f b1 17 75 09 48 89 d8 5b e9 93 11 2b 00 89 c6 e8 4c 0e
> 7b ff
> [6059997.633336] RSP: 0018:ffffa60647228df8 EFLAGS: 00010046
> [6059997.633505] RAX: 0000000000000000 RBX: 0000000000000292 RCX:
> 0000000080080007
> [6059997.633734] RDX: 0000000000000001 RSI: 0000000000000003 RDI:
> 0000000000010b83
> [6059997.633961] RBP: 0000000000000003 R08: 0000000000000001 R09:
> ffffffffc0cb6f01
> [6059997.634190] R10: ffff99854e5e0000 R11: 0000000000000001 R12:
> 0000000000000000
> [6059997.634418] R13: 0000000000010b83 R14: 0000000000000000 R15:
> 0000000000000000
> [6059997.634648] FS:  0000000000000000(0000) GS:ffff99943fe40000(0000)
> knlGS:0000000000000000
> [6059997.634906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [6059997.635092] CR2: 0000000000010b83 CR3: 00000017d31ac002 CR4:
> 00000000007706e0
> [6059997.635319] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [6059997.635548] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [6059997.635777] PKRU: 55555554
> [6059997.635868] Call Trace:
> [6059997.635954]  <IRQ>
> [6059997.636029]  try_to_wake_up+0x4c/0x510
> [6059997.636161]  ? bch_btree_exit+0x20/0x20 [bcache]
> [6059997.636307]  closure_sync_fn+0x18/0x20 [bcache]
> [6059997.636450]  blk_update_request+0x22d/0x3a0
> [6059997.636594]  scsi_end_request+0x28/0x120 [scsi_mod]
> [6059997.636749]  scsi_io_completion+0x78/0x500 [scsi_mod]
> [6059997.636905]  blk_done_softirq+0x8f/0xc0
> [6059997.637031]  __do_softirq+0xdf/0x2e9
> [6059997.637150]  irq_exit+0xdb/0xe0
> [6059997.637251]  do_IRQ+0x7f/0xd0
> [6059997.637350]  common_interrupt+0xf/0xf
> [6059997.637468]  </IRQ>
> [6059997.637537] RIP: 0010:cpu_idle_poll+0x40/0x190
> [6059997.637683] Code: 4b 0f 1f 44 00 00 fb 66 0f 1f 44 00 00 65 48 8b
> 04 25 c0 8b 01 00 48 8b 00 a8 08 74 14 eb 25 f3 90 65 48 8b 04 25 c0
> 8b 01 00 <48> 8b 00 a8 08 75 13 8b 05 2b 14 cd 00 85 c0 75 e4 e8 ba d7
> 7f ff
> [6059997.638274] RSP: 0018:ffffa60640633ec0 EFLAGS: 00000202 ORIG_RAX:
> ffffffffffffffde
> [6059997.645221] RAX: ffff998503e38000 RBX: 000000000000001b RCX:
> 000000000000001f
> [6059997.652279] RDX: 000000000000001b RSI: 00000000355563e5 RDI:
> ffff99943fe6d980
> [6059997.659380] RBP: 000000000000001b R08: 0000000000000002 R09:
> 000000000002c500
> [6059997.666523] R10: 0036c88572dd1ad2 R11: 0000000000000000 R12:
> 0000000000000000
> [6059997.673463] R13: 0000000000000000 R14: 0000000000000000 R15:
> 0000000000000000
> [6059997.680218]  do_idle+0x5b/0x280
> [6059997.686983]  ? do_idle+0x192/0x280
> [6059997.693639]  cpu_startup_entry+0x19/0x20
> [6059997.700546]  start_secondary+0x155/0x1a0
> [6059997.707121]  secondary_startup_64_no_verify+0xc2/0xd0
> [6059997.713703] Modules linked in: yrfs(OEN) nls_utf8(EN) isofs(EN)
> cdrom(EN) loop(EN) binfmt_misc(EN) xfs(EN) libcrc32c(EN) bcache(EN)
> crc64(EN) rdma_ucm(EN) ib_uverbs(EN) msr(EN) mptctl(EN) mptbase(EN)
> rdma_cm(EN) iw_cm(EN) ib_cm(EN) ib_core(EN) configfs(EN) tcp_diag(EN)
> inet_diag(EN) cpufreq_conservative(EN) cuse(EN) fuse(EN) af_packet(EN)
> bonding(EN) intel_rapl_msr(EN) intel_rapl_common(EN)
> isst_if_common(EN) skx_edac(EN) nfit(EN) libnvdimm(EN) rfkill(EN)
> x86_pkg_temp_thermal(EN) coretemp(EN) kvm_intel(EN) kvm(EN) sunrpc(EN)
> irqbypass(EN) nls_iso8859_1(EN) crc32_pclmul(EN) nls_cp437(EN)
> ipmi_si(EN) ghash_clmulni_intel(EN) vfat(EN) aesni_intel(EN)
> ipmi_devintf(EN) crypto_simd(EN) cryptd(EN) fat(EN) glue_helper(EN)
> wdat_wdt(EN) ipmi_msghandler(EN) efi_pstore(EN) pcspkr(EN) ses(EN)
> enclosure(EN) scsi_transport_sas(EN) ioatdma(EN) sg(EN) joydev(EN)
> mei_me(EN) dca(EN) mei(EN) i2c_i801(EN) lpc_ich(EN)
> acpi_power_meter(EN) button(EN) ip_tables(EN) x_tables(EN) ext4(EN)
> crc16(EN) mbcache(EN)
> [6059997.713740]  jbd2(EN) sd_mod(EN) t10_pi(EN) hid_generic(EN)
> uas(EN) usb_storage(EN) usbhid(EN) mlx5_core(EN) ahci(EN) xhci_pci(EN)
> mlxfw(EN) pci_hyperv_intf(EN) crc32c_intel(EN) libahci(EN)
> xhci_hcd(EN) tls(EN) libata(EN) megaraid_sas(EN) i40e(EN) usbcore(EN)
> scsi_mod(EN) efivarfs(EN) [last unloaded: yrfs]
> [6059997.795788] Supported: No, Unreleased kernel
> [6059997.804221] CR2: 0000000000010b83
>=20


