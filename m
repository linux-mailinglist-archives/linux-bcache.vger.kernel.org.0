Return-Path: <linux-bcache+bounces-1202-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AD8B47C04
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Sep 2025 17:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9288D1788E2
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Sep 2025 15:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A203827F178;
	Sun,  7 Sep 2025 15:25:08 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50D158535
	for <linux-bcache@vger.kernel.org>; Sun,  7 Sep 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.191.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757258708; cv=none; b=CtJg//DBJTpqpLzWH7O7Zi6Z2+B7IKjs8qEmtgpno8Ijij5+WRWqTV/dIdGxo3xvKiB9nDb+i2uZiR8BsGg9gNKdOkmcsmTgbWjjlMOIG9HUC9mCNAO9yuWdVohM7GU7fYT2BsmivhY0yjFkcA0f8SaTCaHubSHxnHTUKfqhJIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757258708; c=relaxed/simple;
	bh=2mLggywtNyhjEokMa3tAMhBjBZweVsYv6qUz7XP1pGQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zvl6Mxe4nD3Akh/How/dyTDyPeyWRzqq7HuQrU4JqMN7DhyJSTVOEupp0BImZu14MKHmse4Kk59H/WhmtCGTKF23nV2qANnPucfpu9qGw+R7SDdTMipFcBZcbtjjJh1dq1RnkZ78QwpRCoGvuJK8AzhSmcqffkF9qKl4xKmQT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk; spf=pass smtp.mailfrom=esperi.org.uk; arc=none smtp.client-ip=81.187.191.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=esperi.org.uk
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
	by mail.esperi.org.uk (8.17.2/8.17.2) with ESMTPS id 587EbotS029876
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
	for <linux-bcache@vger.kernel.org>; Sun, 7 Sep 2025 15:37:51 +0100
From: Nix <nix@esperi.org.uk>
To: linux-bcache@vger.kernel.org
Subject: gen wraparound warning: is this a problem?
Emacs: no job too big... no job.
Date: Sun, 07 Sep 2025 15:37:50 +0100
Message-ID: <87a536e3b5.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=1 Fuz1=1

So, out of the blue, I just got this for my long-standing writearound
bcache setup (which covers my rootfs and $HOME, so I kind of care that
it keeps working):

[3997629.262213] WARNING: CPU: 0 PID: 222478 at drivers/md/bcache/alloc.c:81 bch_inc_gen+0x3c/0x40
[3997629.278998] Modules linked in: vfat fat intel_uncore_frequency intel_uncore_frequency_common
[3997629.295763] CPU: 0 UID: 0 PID: 222478 Comm: kworker/0:9 Tainted: G        W           6.15.6-00002-g0d4613ee4427-dirty #2 NONE 
[3997629.329334] Tainted: [W]=WARN
[3997629.345701] Hardware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.1029.090220201031 09/02/2020
[3997629.362413] Workqueue: bcache bch_data_insert_keys
[3997629.378983] RIP: 0010:bch_inc_gen+0x3c/0x40
[3997629.395389] Code: 0f 89 c2 48 89 e5 2a 56 07 0f b6 b1 1a 06 00 00 40 38 f2 0f 42 d6 88 91 1a 06 00 00 48 8b 17 80 ba 1a 06 00 00 60 77 02 5d c3 <0f> 0b 5d c3 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 8b 87 30 03 00
[3997629.428514] RSP: 0018:ffffa7dba31b7a00 EFLAGS: 00010202
[3997629.444857] RAX: 0000000000000045 RBX: 000007ffffffffff RCX: ffff9e5e0d140000
[3997629.461276] RDX: ffff9e5e0d140000 RSI: 0000000000000060 RDI: ffff9e5e00ee4000
[3997629.477509] RBP: ffffa7dba31b7a00 R08: 0000000000000001 R09: 0000000000000000
[3997629.493394] R10: 000e33d2971e5c02 R11: 0000000000000004 R12: 0000000000000002
[3997629.509021] R13: 0000000000000001 R14: ffffa7dba31b7ac8 R15: ffff9e5e149b5000
[3997629.524515] FS:  0000000000000000(0000) GS:ffff9e7d6d275000(0000) knlGS:0000000000000000
[3997629.539853] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[3997629.555063] CR2: 00000000328da018 CR3: 00000007d6c41002 CR4: 00000000003726f0
[3997629.570252] Call Trace:
[3997629.585190]  <TASK>
[3997629.599881]  make_btree_freeing_key+0xf0/0x130
[3997629.614450]  btree_split+0x4c9/0x6b0
[3997629.628797]  ? cpu_rmap_get+0x40/0x40
[3997629.642981]  bch_btree_insert_node+0x2c2/0x390
[3997629.657004]  btree_insert_fn+0x24/0x50
[3997629.670750]  bch_btree_map_nodes_recurse+0x3c/0x170
[3997629.684371]  ? bch_btree_insert_check_key+0x1b0/0x1b0
[3997629.697940]  ? bch_btree_ptr_bad+0x49/0xe0
[3997629.711187]  ? bch_btree_node_get.part.0+0x79/0x2c0
[3997629.724089]  ? rwsem_wake.isra.0+0x70/0x70
[3997629.736874]  bch_btree_map_nodes_recurse+0xf3/0x170
[3997629.749516]  ? bch_btree_insert_check_key+0x1b0/0x1b0
[3997629.762012]  __bch_btree_map_nodes+0x189/0x1a0
[3997629.774179]  ? bch_btree_insert_check_key+0x1b0/0x1b0
[3997629.786202]  bch_btree_insert+0xca/0x130
[3997629.797987]  ? ipi_sync_rq_state+0x40/0x40
[3997629.809575]  bch_data_insert_keys+0x36/0xe0
[3997629.820919]  process_one_work+0x14b/0x300
[3997629.831940]  worker_thread+0x2c3/0x400
[3997629.842820]  ? flush_rcu_work+0x40/0x40
[3997629.853452]  kthread+0xe8/0x1e0
[3997629.863718]  ? kthread_cancel_delayed_work_sync+0x20/0x20
[3997629.873923]  ret_from_fork+0x36/0x50
[3997629.883866]  ? kthread_cancel_delayed_work_sync+0x20/0x20
[3997629.893642]  ret_from_fork_asm+0x11/0x20
[3997629.903209]  </TASK>

[4001476.794864] WARNING: CPU: 10 PID: 408 at drivers/md/bcache/alloc.c:81 __bch_invalidate_one_bucket+0xba/0xc0
[4001476.804157] Modules linked in: vfat fat intel_uncore_frequency intel_uncore_frequency_common
[4001476.813375] CPU: 10 UID: 0 PID: 408 Comm: bcache_allocato Tainted: G        W           6.15.6-00002-g0d4613ee4427-dirty #2 NONE 
[4001476.832090] Tainted: [W]=WARN
[4001476.841130] Hardware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.1029.090220201031 09/02/2020
[4001476.850542] RIP: 0010:__bch_invalidate_one_bucket+0xba/0xc0
[4001476.859914] Code: 24 48 89 f2 48 8b 78 08 4c 89 e6 48 29 ca 48 b9 ab aa aa aa aa aa aa aa 48 c1 fa 02 48 0f af d1 e8 fb c6 01 00 e9 6a ff ff ff <0f> 0b eb 96 0f 0b 0f 1f 44 00 00 55 48 89 e5 41 54 49 89 f4 53 48
[4001476.879592] RSP: 0018:ffffa7db80a2fe50 EFLAGS: 00010202
[4001476.889576] RAX: ffff9e5e0d140000 RBX: ffffa7db80976af0 RCX: 0000000000000061
[4001476.899666] RDX: ffff9e5e0d140000 RSI: ffffa7db80976af0 RDI: ffff9e5e00ee4000
[4001476.909659] RBP: ffffa7db80a2fe60 R08: ffffa7db808e82a8 R09: 0000000000000102
[4001476.919519] R10: 000000000000040b R11: ffff9e5e00ee0000 R12: ffff9e5e00ee4000
[4001476.929322] R13: 00000000000003ff R14: ffffa7db808ff30c R15: ffff9e5e00ee4000
[4001476.938978] FS:  0000000000000000(0000) GS:ffff9e7d6d4f5000(0000) knlGS:0000000000000000
[4001476.948860] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[4001476.958735] CR2: 00007f8d3fbff6d8 CR3: 00000007d6c41006 CR4: 00000000003726f0
[4001476.968744] Call Trace:
[4001476.978687]  <TASK>
[4001476.988541]  bch_invalidate_one_bucket+0x17/0x80
[4001476.998509]  bch_allocator_thread+0xb05/0xc90
[4001477.008447]  ? bch_invalidate_one_bucket+0x80/0x80
[4001477.018391]  kthread+0xe8/0x1e0
[4001477.028309]  ? kthread_cancel_delayed_work_sync+0x20/0x20
[4001477.038348]  ret_from_fork+0x36/0x50
[4001477.048346]  ? kthread_cancel_delayed_work_sync+0x20/0x20
[4001477.058448]  ret_from_fork_asm+0x11/0x20
[4001477.068493]  </TASK>

These both map to this in bch_inc_gen():

        WARN_ON_ONCE(ca->set->need_gc > BUCKET_GC_GEN_MAX);

Is this something the admin needs to do something about? (And, if it's
not and bcache recovers smoothly, as so far it seems to -- though I
haven't tried to remount it since the warning -- why do we warn about
it at all?)

