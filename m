Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9583140229D
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Sep 2021 06:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhIGEN5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 7 Sep 2021 00:13:57 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47500 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhIGENz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 7 Sep 2021 00:13:55 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D06D11FF56;
        Tue,  7 Sep 2021 04:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630987965; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXHDeE6Y5bjC3Wl5ZROa/tSQLU8STQxKbdI9qcA8Omc=;
        b=eG7M2QJd8H2+NMElnt/rHKbdK7NRhVQs3XZQzGRQLAdyYN+xXbtfkthQ5P4YDylSqo5IbP
        9LtiTpvzYE9wFKntz3IhtRWvMWATqsUYNhAAWLIeXb25KuWpV/8VQD+UNmiDBkK2KstD4J
        M4WFy4cjNe1F4rWZiGGWb1JDpg2UtTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630987965;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXHDeE6Y5bjC3Wl5ZROa/tSQLU8STQxKbdI9qcA8Omc=;
        b=AcarLtQpX1gnvXz47LF198k+tn4VWujeHCyD1jThLM/7kISTAUGWs9vggFpD4k9fS87Fwo
        6j++DJLKFxBcBICA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 569F813AC5;
        Tue,  7 Sep 2021 04:12:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sIr0AL3mNmE6GgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 07 Sep 2021 04:12:45 +0000
Subject: Re: 5.11: WARN on long-running system
To:     Nix <nix@esperi.org.uk>
References: <87o89c4et5.fsf@esperi.org.uk>
From:   Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Message-ID: <52ea2e1a-041d-b182-f345-c8c531dd4613@suse.de>
Date:   Tue, 7 Sep 2021 12:12:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87o89c4et5.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 9/1/21 9:15 PM, Nix wrote:
> One long-running 5.11.8 system (yes, I know, an upgrade is overdue)
> using bcache for almost all its fses just WARN_ONed on me:
>
> Aug 29 04:11:47 loom warning: [6083976.304807] WARNING: CPU: 3 PID: 407 at drivers/md/bcache/alloc.c:81 __bch_invalidate_one_bucket+0xcb/0xd1
> Aug 29 04:11:47 loom warning: [6083976.313994] Modules linked in: vfat fat
> Aug 29 04:11:47 loom warning: [6083976.322954] CPU: 3 PID: 407 Comm: bcache_allocato Tainted: G        W         5.11.8-00023-g95756d87a72e-dirt
> y #3
> Aug 29 04:11:47 loom warning: [6083976.332178] Hardware name: Intel Corporation S2600CWR/S2600CWR, BIOS SE5C610.86B.01.01.0024.021320181901 02/1
> 3/2018
> Aug 29 04:11:47 loom warning: [6083976.341401] RIP: 0010:__bch_invalidate_one_bucket+0xcb/0xd1
> Aug 29 04:11:47 loom warning: [6083976.350445] Code: 7b 44 04 01 0f 83 7b ff ff ff 48 8b 05 3e b0 03 01 48 85 c0 74 0f 48 8b 78 08 4c 89 ea 4c 8
> 9 e6 e8 3a bd 01 00 e9 5b ff ff ff <0f> 0b eb 87 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 0f
> Aug 29 04:11:47 loom warning: [6083976.369285] RSP: 0018:ffffa2a080aabe30 EFLAGS: 00010202
> Aug 29 04:11:47 loom warning: [6083976.378441] RAX: ffff9cc0875a0000 RBX: ffffa2a080a8a4dc RCX: 0000000000000061
> Aug 29 04:11:47 loom warning: [6083976.387617] RDX: ffff9cc0875a0000 RSI: ffffa2a080a8a4dc RDI: ffff9cc080ff4000
> Aug 29 04:11:47 loom warning: [6083976.396696] RBP: ffffa2a080aabe48 R08: 0000000000000a63 R09: 00000000000000ff
> Aug 29 04:11:47 loom warning: [6083976.405776] R10: 00000000000003ff R11: ffffa2a080a88f04 R12: ffff9cc080ff4000
> Aug 29 04:11:47 loom warning: [6083976.414893] R13: ffff9cc080ff0000 R14: ffffa2a080a892ac R15: ffff9cc080ff4000
> Aug 29 04:11:47 loom warning: [6083976.423978] FS:  0000000000000000(0000) GS:ffff9cdf7f8c0000(0000) knlGS:0000000000000000
> Aug 29 04:11:47 loom warning: [6083976.433268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Aug 29 04:11:47 loom warning: [6083976.442310] CR2: 00007fc4cc1f7500 CR3: 0000000c0560a001 CR4: 00000000003726e0
> Aug 29 04:11:47 loom warning: [6083976.451396] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> Aug 29 04:11:47 loom warning: [6083976.460407] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Aug 29 04:11:47 loom warning: [6083976.469429] Call Trace:
> Aug 29 04:11:47 loom warning: [6083976.478340]  bch_invalidate_one_bucket+0x17/0x7a
> Aug 29 04:11:47 loom warning: [6083976.487254]  bch_allocator_thread+0xbfb/0xd43
> Aug 29 04:11:47 loom warning: [6083976.496274]  kthread+0x12c/0x145
> Aug 29 04:11:47 loom warning: [6083976.505118]  ? bch_invalidate_one_bucket+0x80/0x7a
> Aug 29 04:11:47 loom warning: [6083976.514080]  ? __kthread_bind_mask+0x70/0x66
> Aug 29 04:11:47 loom warning: [6083976.523060]  ret_from_fork+0x1f/0x2a
> Aug 29 04:11:47 loom warning: [6083976.532051] ---[ end trace 0d64a5c236f9bdf8 ]---
>
> I don't know what the implications of this warning are, though the
> system still seems to be running happily. BUCKET_GC_GEN_MAX is only 96,
> which seems quite low and quite likely to be hit... ubt I don't know
> what that constant means so I could be totally wrong.
>
> It is notable that the unused % of this cache volume has fallen to only
> 3%: it's quite likely that this warning was emitted when it finally
> (after three years or so!) ran out of free space and did its first
> forced GC. I'm not sure how to tell.
Hi Nix,

I have the similar feeling as yours, that it has been a long time after 
previous gc running. I have no idea why the gc didn't run for such long 
time (this bucket was reused for 96 times). Let me try to find if there 
is any clue why the gc does not work for such long time.

Thanks for the information.

Coly Li
