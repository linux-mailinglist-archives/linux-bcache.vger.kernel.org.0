Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052451B54C
	for <lists+linux-bcache@lfdr.de>; Mon, 13 May 2019 13:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfEMLxd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 May 2019 07:53:33 -0400
Received: from schatzi.steelbluetech.co.uk ([92.63.139.240]:62939 "EHLO
        schatzi.steelbluetech.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727690AbfEMLxd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 May 2019 07:53:33 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2019 07:53:33 EDT
Received: from [10.0.5.25] (tv.ehuk.net [10.0.5.25])
        by schatzi.steelbluetech.co.uk (Postfix) with ESMTP id 9377CBFE30;
        Mon, 13 May 2019 12:43:55 +0100 (BST)
DKIM-Filter: OpenDKIM Filter v2.10.3 schatzi.steelbluetech.co.uk 9377CBFE30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ehuk.net; s=default;
        t=1557747835; bh=pEoIjfbjGSDlaIxaoqIjaiYrb2hFuDmsCUH59Tz+V7w=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JonNhcGY2MztKFk2vV3dcwHwwCYU5mquRYMO2U1L4lG9/8fOk61CmDcE2IlVC5eHE
         h0OtghhAXgCS3phss9BkHBPzkr95fN2yr3CuJaREDSz39oDy+6YYEr6vj1z8OxwuPS
         ioyLxQPVSeja4aojoUWiLpwZYnl17iTgpoo/AFII=
Reply-To: eddie@ehuk.net
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Pierre JUHEN <pierre.juhen@orange.fr>, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com, Rolf Fokkens <rolf@rolffokkens.nl>
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <c9a78d32-5752-6106-9a13-6afd9d4d75b3@orange.fr>
From:   Eddie Chapman <eddie@ehuk.net>
Message-ID: <8cb0dec8-efeb-c9c9-ad9f-e32f14e77c0e@ehuk.net>
Date:   Mon, 13 May 2019 12:43:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c9a78d32-5752-6106-9a13-6afd9d4d75b3@orange.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/05/2019 18:41, Pierre JUHEN wrote:
> Hi,
> 
> the bug is present in 5.0.11, 5.0.13 et 5.0.14 (rawhide).
> 
> Please see :
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1708315
> 
> I guess it will be a tough one, since it's seems clearly linked to the 
> gcc version, since the same code works under Fedora 29 (gcc 8), and 
> fails under Fedora 30 (gcc 9).
> 
> Regards,
> 
> Pierre
> 

I haven't upgraded to any 5.x release yet and still using gcc 8.3 but 
seeing that this particular issue appears to trigger upon attaching the 
cache device, it made me wonder if an issue I have encountered recently 
could be related and therefore some help. If it is not then I apologise 
for the noise.

The issue I have encountered recently, which I had not before, is an 
Oops on bootup, after upgrading to stable 4.19.38 from an earlier 4.19 
release. Specifically it occurs when doing one of these in a startup 
script (haven't been able to narrow down exactly which yet):

echo writeback > /sys/block/bcach0/bcache/cache_mode
echo 4200000000 > /sys/block/bcach0/bcache/sequential_cutoff
echo 50 > /sys/block/bcach0/bcache/writeback_percent
echo 0 > /sys/block/bcach0/bcache/cache/congested_write_threshold_us
echo 0 > /sys/block/bcach0/bcache/cache/congested_read_threshold_us

I managed to get some of the Oops in my serial terminal, but 
unfortunately some lines of it were corrupted when the machine rebooted 
and subsequent serial output overwrote them.  But these are the lines 
which did not get overwritten:

[  205.046081] BUG: unable to handle kernel NULL pointer dereference at 
0000000000000340
[  205.053962] PGD 0 P4D 0
[  205.056506] Oops: 0000 [#1] SMP NOPTI
[  205.060220] CPU: 2 PID: 27 Comm: kworker/2:0 Tainted: G        W  O 
  T 4.19.38-rc1 #1
[  205.068266] Hardware name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 
3.5c       03/18/2016
[  205.076489] Workqueue: events update_writeback_rate [bcache]
[  205.082166] RIP: 0010:update_writeback_rate+0x2f/0x300 [bcache]
[  205.088161] Code: 41 57 41 56 41 55 41 54 55 53 4c 8b a7 00 f4 ff ff 
f0 80 8f 20 f4 ff ff 10 f0 83 44 24 fc 00 48 8b 87 20 f4 ff ff a8 08 74 
57 <49> 8b 84 24 40 03 00 00 48 c1 e8 03 83 e0 01 48 89 c5 75 43 8b 47
[  205.107050] RSP: 0018:ffffc900032ffe68 EFLAGS: 00010202
[  205.107052] RAX: 0000000000000018 RBX: ffff8884c3620c80 RCX: 
ffff8884178a01e0
[  205.107052] RDX: 0000000000000001 RSI: ffff8884c3620c88 RDI: 
ffff8884c3620c80
[  205.107053] RBP: ffff8884178a01c0 R08: 0000000000000000 R09: 
000073746e657665
[  205.107054] R10: 8080808080808080 R11: 0000002f93e8e556 R12: 
0000000000000000
[  205.107054] R13: 0000000000000000 R14: ffff888415b13c80 R15: 
ffff8884c3620c88
[  205.107056] FS:  0000000000000000(0000) GS:ffff888417880000(0000) 
knlGS:0000000000000000
[  205.107057] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  205.107057] CR2: 0000000000000340 CR3: 00000002c479c000 CR4: 
00000000000406e0
[  205.107058] Call Trace:
[  205.107066]  process_one_work+0x1a7/0x3a0
[  205.107075]  worker_thread+0x30/0x390

There is some more Call Trace but as I say it is corrupted by subsequent 
serial data.  I will try and capture full oops if I get time this week, 
and hopefully a full crash dump.

The fact that it occurred on updating to a very recent 4.19 stable 
release, and that the other issue you guys have experienced with 
corruption is with a very recent kernel, makes me wonder if perhaps a 
recent change somewhere else in the kernel that is present in 5.x and 
been backported to stable could be causing both issues.

I'm not sure if my issue actually would have led to corruption as I 
discarded completely the bcache data right after I had the oops, and 
re-created it without a cache device and now run it like that (maybe it 
is the exact same issue). I plan to add cache device again when I get 
time. So sorry for the incomplete bug report for now, as I say hope to 
get time to investigate more fully soon.

Eddie
