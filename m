Return-Path: <linux-bcache+bounces-435-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA788C35E3
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2024 11:50:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BB1F1F2135A
	for <lists+linux-bcache@lfdr.de>; Sun, 12 May 2024 09:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A2D11CA9;
	Sun, 12 May 2024 09:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b="A2oKGjgM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21FEEB3
	for <linux-bcache@vger.kernel.org>; Sun, 12 May 2024 09:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715507435; cv=none; b=nFlWITCOKHXUXoTR3nTr2Zc9KLQtfPs2mZmB92q9me0p+bbNEPjrC0uTpw/CwmA+29AaEhJHfEEhzLRSm5eairRrM/k4RmJ5tuJAh+RT40m/aKl2Ez7JTPuoqyfvDQcvA1PMYtk0X14ROKYOLAS3pZ9WIIuKeUmMO2bje7LYSCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715507435; c=relaxed/simple;
	bh=rubAUKmsRhn+0/ZWG9sdedv6sbJoZ2LhmUjB8AOlLAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Jw1GIboJ13ewqhOmG4NhseyR2Lx6dOq1R0jo0TlhuGvfO9UOuKpMngDleU9uPBc4ibpN6yGOCcngkc3c/1eeL38XtrlKT6sGwlo4R4f+ttj4AlqbTEfrX4jIJBAohBSCSmDcFKtqPrdga2eFruA4Im3ylTNzPUkjCKSNeIRY1+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr; spf=pass smtp.mailfrom=orange.fr; dkim=pass (2048-bit key) header.d=orange.fr header.i=@orange.fr header.b=A2oKGjgM; arc=none smtp.client-ip=80.12.242.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=orange.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=orange.fr
Received: from [192.168.1.7] ([90.48.117.243])
	by smtp.orange.fr with ESMTPA
	id 65husj9M2afxB65husSD4A; Sun, 12 May 2024 11:41:26 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.fr;
	s=t20230301; t=1715506886;
	bh=5qx9l6ozvKr8uaPOxKn2U3rwKWlHX/Cc2R7F8Ke1pUw=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=A2oKGjgMyMuTFM9/ByeqXVV3rHFtHgeX29oM1jBIOK8gyg4fvNX0aA8XSL2GbKBlX
	 9vdsU4Q/D6e1jGDKUoSGJh/wN6OBaN+1Xyld1uV6gUxwmEM8pdwxeX7TpyqOu9v0LJ
	 gNAiCLa7VxxYG5bxR3usc0+pMibjXBRoYjaJY0SkjH4xTtyvdv/kb8bUf34rnjz1kz
	 8jJutMX9O9cP7AF5mcXXwJCVD/LcNRAixflf2LoyRvryj8Fo9X5tjsf5XCayRAwek0
	 oeUpf7QyagE+xuZ44p1aRnJoWJxo1BEnLM8xRV/CwWcU+g2R459NxGa++CNgdEEjYt
	 POb7rXZwisPqw==
X-ME-Helo: [192.168.1.7]
X-ME-Auth: cGllcnJlLmp1aGVuQG9yYW5nZS5mcg==
X-ME-Date: Sun, 12 May 2024 11:41:26 +0200
X-ME-IP: 90.48.117.243
Message-ID: <1be3d08b-4c85-4031-b674-549289395e45@orange.fr>
Date: Sun, 12 May 2024 11:41:26 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Kernel error with 6.8.9
To: Bcache Linux <linux-bcache@vger.kernel.org>
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de>
 <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de>
 <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de>
 <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de>
 <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de>
 <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
 <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
 <82DDC16E-F4BF-4F8D-8DB8-352D9A6D9AF5@suse.de>
 <ea18e5b9-2d10-c459-ffec-fe7012fad345@easystack.cn>
 <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
Content-Language: fr
From: "Pierre Juhen (IMAP)" <pierre.juhen@orange.fr>
In-Reply-To: <CAJhEC04czCGuwdS3AC8JdzKax4aX9i4D7BJ01xgi3PKCpgzwzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I use bcache on an nvme partition as frontend and md array ass backend.

I have the following error since I updated to kernel 6.8.9.

  UBSAN: array-index-out-of-bounds in drivers/md/bcache/bset.c:1098:3
[    7.138127] index 4 is out of range for type 'btree_iter_set [4]'
[    7.138129] CPU: 9 PID: 645 Comm: bcache-register Not tainted 
6.8.9-200.fc39.x86_64 #1
[    7.138131] Hardware name: Gigabyte Technology Co., Ltd. B550M 
DS3H/B550M DS3H, BIOS F1 12/07/2022
[    7.138133] Call Trace:
[    7.138135]  <TASK>
[    7.138137]  dump_stack_lvl+0x64/0x80
[    7.138143]  __ubsan_handle_out_of_bounds+0x95/0xd0
[    7.138148]  bch_btree_iter_push+0x4ca/0x4e0 [bcache]
[    7.138160]  bch_btree_node_read_done+0xca/0x3f0 [bcache]
[    7.138171]  bch_btree_node_read+0xe4/0x1d0 [bcache]
[    7.138180]  ? __pfx_closure_sync_fn+0x10/0x10
[    7.138183]  bch_btree_node_get.part.0+0x156/0x320 [bcache]
[    7.138192]  ? __pfx_up_write+0x10/0x10
[    7.138197]  register_bcache+0x1f31/0x2230 [bcache]
[    7.138212]  kernfs_fop_write_iter+0x136/0x1d0
[    7.138217]  vfs_write+0x29e/0x470
[    7.138222]  ksys_write+0x6f/0xf0
[    7.138224]  do_syscall_64+0x83/0x170
[    7.138229]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138232]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138234]  ? xas_find+0x75/0x1d0
[    7.138237]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138239]  ? next_uptodate_folio+0xa5/0x2e0
[    7.138243]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138245]  ? filemap_map_pages+0x474/0x550
[    7.138248]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138251]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138253]  ? do_fault+0x246/0x490
[    7.138256]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138258]  ? __handle_mm_fault+0x827/0xe40
[    7.138262]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138264]  ? __count_memcg_events+0x69/0x100
[    7.138267]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138269]  ? count_memcg_events.constprop.0+0x1a/0x30
[    7.138271]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138273]  ? handle_mm_fault+0xa2/0x360
[    7.138275]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138277]  ? do_user_addr_fault+0x304/0x690
[    7.138281]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138282]  ? srso_alias_return_thunk+0x5/0xfbef5
[    7.138285]  entry_SYSCALL_64_after_hwframe+0x78/0x80
[    7.138287] RIP: 0033:0x7f2dba570ee4
[    7.138292] Code: c7 00 16 00 00 00 b8 ff ff ff ff c3 66 2e 0f 1f 84 
00 00 00 00 00 f3 0f 1e fa 80 3d 85 74 0d 00 00 74 13 b8 01 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 54 c3 0f 1f 00 55 48 89 e5 48 83 ec 20 4
8 89
[    7.138293] RSP: 002b:00007ffe3e2f1df8 EFLAGS: 00000202 ORIG_RAX: 
0000000000000001
[    7.138295] RAX: ffffffffffffffda RBX: 00007ffe3e2f1e6c RCX: 
00007f2dba570ee4
[    7.138297] RDX: 000000000000000f RSI: 00007ffe3e2f1e6c RDI: 
0000000000000003
[    7.138298] RBP: 00007ffe3e2f1e30 R08: 0000000000000073 R09: 
0000000000000001
[    7.138299] R10: 0000000000000000 R11: 0000000000000202 R12: 
000000000000000f
[    7.138300] R13: 00007ffe3e2f1e7b R14: 00007ffe3e2f1e6c R15: 
00007ffe3e2f1e40
[    7.138303]  </TASK>

The error is repeated  15 times while  reboot

  (I have a 12 threads processors).

Pierre


