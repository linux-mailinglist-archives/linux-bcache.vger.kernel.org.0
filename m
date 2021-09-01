Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77AAD3FDD49
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Sep 2021 15:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243062AbhIAN0A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Sep 2021 09:26:00 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:43502 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbhIAN0A (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Sep 2021 09:26:00 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Sep 2021 09:26:00 EDT
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 181DFo2h018476
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO)
        for <linux-bcache@vger.kernel.org>; Wed, 1 Sep 2021 14:15:50 +0100
From:   Nix <nix@esperi.org.uk>
To:     linux-bcache@vger.kernel.org
Subject: 5.11: WARN on long-running system
Emacs:  Our Lady of Perpetual Garbage Collection
Date:   Wed, 01 Sep 2021 14:15:50 +0100
Message-ID: <87o89c4et5.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=1 Fuz1=1 Fuz2=1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

One long-running 5.11.8 system (yes, I know, an upgrade is overdue)
using bcache for almost all its fses just WARN_ONed on me:

Aug 29 04:11:47 loom warning: [6083976.304807] WARNING: CPU: 3 PID: 407 at drivers/md/bcache/alloc.c:81 __bch_invalidate_one_bucket+0xcb/0xd1
Aug 29 04:11:47 loom warning: [6083976.313994] Modules linked in: vfat fat
Aug 29 04:11:47 loom warning: [6083976.322954] CPU: 3 PID: 407 Comm: bcache_allocato Tainted: G        W         5.11.8-00023-g95756d87a72e-dirt
y #3
Aug 29 04:11:47 loom warning: [6083976.332178] Hardware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.0024.021320181901 02/1
3/2018
Aug 29 04:11:47 loom warning: [6083976.341401] RIP: 0010:__bch_invalidate_one_bucket+0xcb/0xd1
Aug 29 04:11:47 loom warning: [6083976.350445] Code: 7b 44 04 01 0f 83 7b ff ff ff 48 8b 05 3e b0 03 01 48 85 c0 74 0f 48 8b 78 08 4c 89 ea 4c 8
9 e6 e8 3a bd 01 00 e9 5b ff ff ff <0f> 0b eb 87 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f
Aug 29 04:11:47 loom warning: [6083976.369285] RSP: 0018:ffffa2a080aabe30 EFLAGS: 00010202
Aug 29 04:11:47 loom warning: [6083976.378441] RAX: ffff9cc0875a0000 RBX: ffffa2a080a8a4dc RCX: 0000000000000061
Aug 29 04:11:47 loom warning: [6083976.387617] RDX: ffff9cc0875a0000 RSI: ffffa2a080a8a4dc RDI: ffff9cc080ff4000
Aug 29 04:11:47 loom warning: [6083976.396696] RBP: ffffa2a080aabe48 R08: 0000000000000a63 R09: 00000000000000ff
Aug 29 04:11:47 loom warning: [6083976.405776] R10: 00000000000003ff R11: ffffa2a080a88f04 R12: ffff9cc080ff4000
Aug 29 04:11:47 loom warning: [6083976.414893] R13: ffff9cc080ff0000 R14: ffffa2a080a892ac R15: ffff9cc080ff4000
Aug 29 04:11:47 loom warning: [6083976.423978] FS:  0000000000000000(0000) GS:ffff9cdf7f8c0000(0000) knlGS:0000000000000000
Aug 29 04:11:47 loom warning: [6083976.433268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 29 04:11:47 loom warning: [6083976.442310] CR2: 00007fc4cc1f7500 CR3: 0000000c0560a001 CR4: 00000000003726e0
Aug 29 04:11:47 loom warning: [6083976.451396] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Aug 29 04:11:47 loom warning: [6083976.460407] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Aug 29 04:11:47 loom warning: [6083976.469429] Call Trace:
Aug 29 04:11:47 loom warning: [6083976.478340]  bch_invalidate_one_bucket+0x17/0x7a
Aug 29 04:11:47 loom warning: [6083976.487254]  bch_allocator_thread+0xbfb/0xd43
Aug 29 04:11:47 loom warning: [6083976.496274]  kthread+0x12c/0x145
Aug 29 04:11:47 loom warning: [6083976.505118]  ? bch_invalidate_one_bucket+0x80/0x7a
Aug 29 04:11:47 loom warning: [6083976.514080]  ? __kthread_bind_mask+0x70/0x66
Aug 29 04:11:47 loom warning: [6083976.523060]  ret_from_fork+0x1f/0x2a
Aug 29 04:11:47 loom warning: [6083976.532051] ---[ end trace 0d64a5c236f9bdf8 ]---

I don't know what the implications of this warning are, though the
system still seems to be running happily. BUCKET_GC_GEN_MAX is only 96,
which seems quite low and quite likely to be hit... ubt I don't know
what that constant means so I could be totally wrong.

It is notable that the unused % of this cache volume has fallen to only
3%: it's quite likely that this warning was emitted when it finally
(after three years or so!) ran out of free space and did its first
forced GC. I'm not sure how to tell.
