Return-Path: <linux-bcache+bounces-18-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A391D7F0BB1
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:45:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAD3280C34
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44E65681;
	Mon, 20 Nov 2023 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="svAUjuKO";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="uu0VxRN7"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE57186;
	Sun, 19 Nov 2023 21:44:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id E57BD1F7AB;
	Mon, 20 Nov 2023 05:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700459084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1ZQnkFo8012v8eZitW0g/5EI8k5yTKn/qCr9xz6TNE=;
	b=svAUjuKOMOCU64iWK5vbG00xG37Z2Nzsta+tkcfRbxJfSlkYLBSe6eLARGH48qL+SAhRyV
	8CjdBPWiw0WIuH3c/BpRKNTFNRtgQ7LLwia+2CS/3hVQc8A2627hKvPdv0LSfsej/J2kvu
	vGEERYnNiaYZtpfH8jaCHGzB6tMMeVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700459084;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1ZQnkFo8012v8eZitW0g/5EI8k5yTKn/qCr9xz6TNE=;
	b=uu0VxRN7kPyevfv2Ko9lZzXO71muiKosJwE32r0rXdw/iTETuVG9mak3oVZ4WbGKwAVLsp
	yLKk7YDHIGvZYbBw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id E88F22CFAB;
	Mon, 20 Nov 2023 05:26:22 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	stable@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 07/10] bcache: fixup multi-threaded bch_sectors_dirty_init() wake-up race
Date: Mon, 20 Nov 2023 13:25:00 +0800
Message-Id: <20231120052503.6122-8-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231120052503.6122-1-colyli@suse.de>
References: <20231120052503.6122-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++++++++++++++++++
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [27.09 / 50.00];
	 ARC_NA(0.00)[];
	 BAYES_SPAM(5.10)[99.99%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 RWL_MAILSPIKE_GOOD(-1.00)[149.44.160.134:from];
	 VIOLATED_DIRECT_SPF(3.50)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_NO_TLS_LAST(0.10)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 GREYLIST(0.00)[pass,meta]
X-Spam-Score: 27.09
X-Rspamd-Queue-Id: E57BD1F7AB
X-Spam: Yes

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

We get a kernel crash about "unable to handle kernel paging request":

```dmesg
[368033.032005] BUG: unable to handle kernel paging request at ffffffffad9ae4b5
[368033.032007] PGD fc3a0d067 P4D fc3a0d067 PUD fc3a0e063 PMD 8000000fc38000e1
[368033.032012] Oops: 0003 [#1] SMP PTI
[368033.032015] CPU: 23 PID: 55090 Comm: bch_dirtcnt[0] Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-147.5.1.es8_24.x86_64 #1
[368033.032017] Hardware name: Tsinghua Tongfang THTF Chaoqiang Server/072T6D, BIOS 2.4.3 01/17/2017
[368033.032027] RIP: 0010:native_queued_spin_lock_slowpath+0x183/0x1d0
[368033.032029] Code: 8b 02 48 85 c0 74 f6 48 89 c1 eb d0 c1 e9 12 83 e0
03 83 e9 01 48 c1 e0 05 48 63 c9 48 05 c0 3d 02 00 48 03 04 cd 60 68 93
ad <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 02
[368033.032031] RSP: 0018:ffffbb48852abe00 EFLAGS: 00010082
[368033.032032] RAX: ffffffffad9ae4b5 RBX: 0000000000000246 RCX: 0000000000003bf3
[368033.032033] RDX: ffff97b0ff8e3dc0 RSI: 0000000000600000 RDI: ffffbb4884743c68
[368033.032034] RBP: 0000000000000001 R08: 0000000000000000 R09: 000007ffffffffff
[368033.032035] R10: ffffbb486bb01000 R11: 0000000000000001 R12: ffffffffc068da70
[368033.032036] R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
[368033.032038] FS:  0000000000000000(0000) GS:ffff97b0ff8c0000(0000) knlGS:0000000000000000
[368033.032039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[368033.032040] CR2: ffffffffad9ae4b5 CR3: 0000000fc3a0a002 CR4: 00000000003626e0
[368033.032042] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[368033.032043] bcache: bch_cached_dev_attach() Caching rbd479 as bcache462 on set 8cff3c36-4a76-4242-afaa-7630206bc70b
[368033.032045] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[368033.032046] Call Trace:
[368033.032054]  _raw_spin_lock_irqsave+0x32/0x40
[368033.032061]  __wake_up_common_lock+0x63/0xc0
[368033.032073]  ? bch_ptr_invalid+0x10/0x10 [bcache]
[368033.033502]  bch_dirty_init_thread+0x14c/0x160 [bcache]
[368033.033511]  ? read_dirty_submit+0x60/0x60 [bcache]
[368033.033516]  kthread+0x112/0x130
[368033.033520]  ? kthread_flush_work_fn+0x10/0x10
[368033.034505]  ret_from_fork+0x35/0x40
```

The crash occurred when call wake_up(&state->wait), and then we want
to look at the value in the state. However, bch_sectors_dirty_init()
is not found in the stack of any task. Since state is allocated on
the stack, we guess that bch_sectors_dirty_init() has exited, causing
bch_dirty_init_thread() to be unable to handle kernel paging request.

In order to verify this idea, we added some printing information during
wake_up(&state->wait). We find that "wake up" is printed twice, however
we only expect the last thread to wake up once.

```dmesg
[  994.641004] alcache: bch_dirty_init_thread() wake up
[  994.641018] alcache: bch_dirty_init_thread() wake up
[  994.641523] alcache: bch_sectors_dirty_init() init exit
```

There is a race. If bch_sectors_dirty_init() exits after the first wake
up, the second wake up will trigger this bug("unable to handle kernel
paging request").

Proceed as follows:

bch_sectors_dirty_init
    kthread_run ==============> bch_dirty_init_thread(bch_dirtcnt[0])
            ...                         ...
    atomic_inc(&state.started)          ...
            ...                         ...
    atomic_read(&state.enough)          ...
            ...                 atomic_set(&state->enough, 1)
    kthread_run ======================================================> bch_dirty_init_thread(bch_dirtcnt[1])
            ...                 atomic_dec_and_test(&state->started)            ...
    atomic_inc(&state.started)          ...                                     ...
            ...                 wake_up(&state->wait)                           ...
    atomic_read(&state.enough)                                          atomic_dec_and_test(&state->started)
            ...                                                                 ...
    wait_event(state.wait, atomic_read(&state.started) == 0)                    ...
    return                                                                      ...
                                                                        wake_up(&state->wait)

We believe it is very common to wake up twice if there is no dirty, but
crash is an extremely low probability event. It's hard for us to reproduce
this issue. We attached and detached continuously for a week, with a total
of more than one million attaches and only one crash.

Putting atomic_inc(&state.started) before kthread_run() can avoid waking
up twice.

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a1d760916246..3accfdaee6b1 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -1025,17 +1025,18 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 		if (atomic_read(&state.enough))
 			break;
 
+		atomic_inc(&state.started);
 		state.infos[i].state = &state;
 		state.infos[i].thread =
 			kthread_run(bch_dirty_init_thread, &state.infos[i],
 				    "bch_dirtcnt[%d]", i);
 		if (IS_ERR(state.infos[i].thread)) {
 			pr_err("fails to run thread bch_dirty_init[%d]\n", i);
+			atomic_dec(&state.started);
 			for (--i; i >= 0; i--)
 				kthread_stop(state.infos[i].thread);
 			goto out;
 		}
-		atomic_inc(&state.started);
 	}
 
 out:
-- 
2.35.3


