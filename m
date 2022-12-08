Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6579647238
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Dec 2022 15:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiLHOxU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Dec 2022 09:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLHOxG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Dec 2022 09:53:06 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A122ED7D;
        Thu,  8 Dec 2022 06:53:04 -0800 (PST)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1p3IGl-0006kQ-BB; Thu, 08 Dec 2022 15:53:03 +0100
Message-ID: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
Date:   Thu, 8 Dec 2022 15:53:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US, de-DE
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcache@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira <alexpereira@disroot.org>
Subject: =?UTF-8?Q?=5bregression=5d_Bug=c2=a0216785_-_=22memcpy=3a_detected_?=
 =?UTF-8?Q?field-spanning_write=2e=2e=2e=22_warnings_with_bcache?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1670511185;0d3d8e8c;
X-HE-SMSGID: 1p3IGl-0006kQ-BB
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting some of
https://bugzilla.kernel.org/show_bug.cgi?id=216785 :

>  Alexandre Pereira 2022-12-07 18:51:55 UTC
> 
> Testing linux kernel 6.1-rc8, I have several kernel erros regarding bcache.
> 
> For context, I have a bcache configuration that is working without issues on 6.0.x and previous versions.
> 
> The errors:
> 
> dez 07 18:33:45 stormtrooper kernel: ------------[ cut here ]------------
> dez 07 18:33:45 stormtrooper kernel: memcpy: detected field-spanning write (size 264) of single field "&i->j" at drivers/md/bcache/journal.c:152 (size 240)
> dez 07 18:33:45 stormtrooper kernel: WARNING: CPU: 12 PID: 182 at drivers/md/bcache/journal.c:152 journal_read_bucket+0x476/0x5a0 [bcache]
> dez 07 18:33:45 stormtrooper kernel: Modules linked in: snd_timer crypto_simd sp5100_tco snd cryptd tpm_crb(+) pcc_cpufreq(-) rapl gigabyte_wmi wmi_bmof ccp k10temp dca s>
> dez 07 18:33:45 stormtrooper kernel: CPU: 12 PID: 182 Comm: kworker/12:1 Not tainted 6.1.0-rc8-1-cachyos-rc-lto #1 338e4715ba3f0cf5a31b9c6d6a0812b10d93e6a7
> dez 07 18:33:45 stormtrooper kernel: Hardware name: Gigabyte Technology Co., Ltd. X470 AORUS ULTRA GAMING/X470 AORUS ULTRA GAMING-CF, BIOS F62d 10/13/2021
> dez 07 18:33:45 stormtrooper kernel: Workqueue: events register_cache_worker [bcache]
> dez 07 18:33:45 stormtrooper kernel: RIP: 0010:journal_read_bucket+0x476/0x5a0 [bcache]
> dez 07 18:33:45 stormtrooper kernel: Code: 18 e9 63 fd ff ff c6 05 30 af 02 00 01 b9 f0 00 00 00 48 c7 c7 c6 e8 d5 c1 48 8b 74 24 30 48 c7 c2 8d cb d5 c1 e8 6a f0 96 f3 <>
> dez 07 18:33:45 stormtrooper kernel: RSP: 0018:ffffb1688085fbc8 EFLAGS: 00010246
> dez 07 18:33:45 stormtrooper kernel: RAX: 3e6a0611f0c96400 RBX: ffffb1688085fd58 RCX: 0000000000000027
> dez 07 18:33:45 stormtrooper kernel: RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffff9e38eed21688
> dez 07 18:33:45 stormtrooper kernel: RBP: ffff9e35c50f1600 R08: 0000000000000000 R09: ffff9e38ff247140
> dez 07 18:33:45 stormtrooper kernel: R10: 00000000ffffffff R11: ffff9e38ff2f7140 R12: ffff9e35c50f1618
> dez 07 18:33:45 stormtrooper kernel: R13: ffffb1688085fd58 R14: 0000000000000001 R15: ffff9e35d82d8000
> dez 07 18:33:45 stormtrooper kernel: FS:  0000000000000000(0000) GS:ffff9e38eed00000(0000) knlGS:0000000000000000
> dez 07 18:33:45 stormtrooper kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> dez 07 18:33:45 stormtrooper kernel: CR2: 00007fb814ccffe0 CR3: 0000000107b72000 CR4: 0000000000350ee0
> dez 07 18:33:45 stormtrooper kernel: Call Trace:
> dez 07 18:33:45 stormtrooper kernel:  <TASK>
> dez 07 18:33:45 stormtrooper kernel:  ? __closure_sync+0xa0/0xa0 [bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
> dez 07 18:33:45 stormtrooper kernel:  bch_journal_read+0xa0/0x350 [bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
> dez 07 18:33:45 stormtrooper kernel:  ? __kernfs_new_node+0x1c5/0x230
> dez 07 18:33:45 stormtrooper kernel:  run_cache_set+0xb8/0x8f0 [bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
> dez 07 18:33:45 stormtrooper kernel:  ? kernfs_add_one+0x20a/0x250
> dez 07 18:33:45 stormtrooper kernel:  register_cache_worker+0xb8b/0xce0 [bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
> dez 07 18:33:45 stormtrooper kernel:  process_one_work+0x23a/0x3f0
> dez 07 18:33:45 stormtrooper kernel:  worker_thread+0x280/0x5c0
> dez 07 18:33:45 stormtrooper kernel:  ? worker_clr_flags+0x40/0x40
> dez 07 18:33:45 stormtrooper kernel:  kthread+0x149/0x170
> dez 07 18:33:45 stormtrooper kernel:  ? kthread_blkcg+0x30/0x30
> dez 07 18:33:45 stormtrooper kernel:  ret_from_fork+0x1f/0x30
> dez 07 18:33:45 stormtrooper kernel:  </TASK>
> dez 07 18:33:45 stormtrooper kernel: ---[ end trace 0000000000000000 ]---

See the ticket for more details.

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced v6.0..v6.1-rc8
https://bugzilla.kernel.org/show_bug.cgi?id=216785
#regzbot title bcache: memcpy: detected field-spanning write...
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
