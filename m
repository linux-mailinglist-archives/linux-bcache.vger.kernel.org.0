Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3BA64725E
	for <lists+linux-bcache@lfdr.de>; Thu,  8 Dec 2022 16:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiLHPBX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 8 Dec 2022 10:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiLHPBW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 8 Dec 2022 10:01:22 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E1BF71;
        Thu,  8 Dec 2022 07:01:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4D70622979;
        Thu,  8 Dec 2022 15:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1670511680; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKzmK6z02O8+TjGlM2Z9m8lIEVpVKoDP62zKS2+flPc=;
        b=cRLAlXglppfGYZDwd3pbOH4Aso3QPaSKrXIoX1S59qdrLtss6g5/OQhnKpALSu9UsrlrfY
        9hN2wOA1q1/KU7PxmDm9ys0CSvAuh4mxKRb3jAmYH+k8eL5U2XG+TUrEXD0yzM+OdBKebt
        /0sVe8pskS1Xca+rxnohcb+VLJ682kQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1670511680;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKzmK6z02O8+TjGlM2Z9m8lIEVpVKoDP62zKS2+flPc=;
        b=blVoLOPIFH9WedWqXjRIeJ2+YBagVvbgFd7kd2eobfdWGvKK1P0NGAJ65VuwoGZPbojdVr
        dDfvNKPD7ujVPeBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9E3A113416;
        Thu,  8 Dec 2022 15:01:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bZLRGT78kWPdegAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 08 Dec 2022 15:01:18 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: =?utf-8?Q?Re=3A_=5Bregression=5D_Bug=C2=A0216785_-_=22memcpy=3A_d?=
 =?utf-8?Q?etected_field-spanning_write=2E=2E=2E=22_warnings_with_bcache?=
From:   Coly Li <colyli@suse.de>
In-Reply-To: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
Date:   Thu, 8 Dec 2022 23:01:05 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexandre Pereira <alexpereira@disroot.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <8A5CF22A-CDF5-4FA8-B6EE-BE7437A7E527@suse.de>
References: <19200730-a3ba-6f4f-bb81-71339bdbbf73@leemhuis.info>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=888=E6=97=A5 22:53=EF=BC=8CThorsten Leemhuis =
<regressions@leemhuis.info> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi, this is your Linux kernel regression tracker speaking.
>=20
> I noticed a regression report in bugzilla.kernel.org. As many (most?)
> kernel developer don't keep an eye on it, I decided to forward it by
> mail. Quoting some of
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216785 :
>=20
>> Alexandre Pereira 2022-12-07 18:51:55 UTC
>>=20
>> Testing linux kernel 6.1-rc8, I have several kernel erros regarding =
bcache.
>>=20
>> For context, I have a bcache configuration that is working without =
issues on 6.0.x and previous versions.
>>=20
>> The errors:
>>=20
>> dez 07 18:33:45 stormtrooper kernel: ------------[ cut here =
]------------
>> dez 07 18:33:45 stormtrooper kernel: memcpy: detected field-spanning =
write (size 264) of single field "&i->j" at =
drivers/md/bcache/journal.c:152 (size 240)
>> dez 07 18:33:45 stormtrooper kernel: WARNING: CPU: 12 PID: 182 at =
drivers/md/bcache/journal.c:152 journal_read_bucket+0x476/0x5a0 [bcache]
>> dez 07 18:33:45 stormtrooper kernel: Modules linked in: snd_timer =
crypto_simd sp5100_tco snd cryptd tpm_crb(+) pcc_cpufreq(-) rapl =
gigabyte_wmi wmi_bmof ccp k10temp dca s>
>> dez 07 18:33:45 stormtrooper kernel: CPU: 12 PID: 182 Comm: =
kworker/12:1 Not tainted 6.1.0-rc8-1-cachyos-rc-lto #1 =
338e4715ba3f0cf5a31b9c6d6a0812b10d93e6a7
>> dez 07 18:33:45 stormtrooper kernel: Hardware name: Gigabyte =
Technology Co., Ltd. X470 AORUS ULTRA GAMING/X470 AORUS ULTRA GAMING-CF, =
BIOS F62d 10/13/2021
>> dez 07 18:33:45 stormtrooper kernel: Workqueue: events =
register_cache_worker [bcache]
>> dez 07 18:33:45 stormtrooper kernel: RIP: =
0010:journal_read_bucket+0x476/0x5a0 [bcache]
>> dez 07 18:33:45 stormtrooper kernel: Code: 18 e9 63 fd ff ff c6 05 30 =
af 02 00 01 b9 f0 00 00 00 48 c7 c7 c6 e8 d5 c1 48 8b 74 24 30 48 c7 c2 =
8d cb d5 c1 e8 6a f0 96 f3 <>
>> dez 07 18:33:45 stormtrooper kernel: RSP: 0018:ffffb1688085fbc8 =
EFLAGS: 00010246
>> dez 07 18:33:45 stormtrooper kernel: RAX: 3e6a0611f0c96400 RBX: =
ffffb1688085fd58 RCX: 0000000000000027
>> dez 07 18:33:45 stormtrooper kernel: RDX: 0000000000000000 RSI: =
0000000000000002 RDI: ffff9e38eed21688
>> dez 07 18:33:45 stormtrooper kernel: RBP: ffff9e35c50f1600 R08: =
0000000000000000 R09: ffff9e38ff247140
>> dez 07 18:33:45 stormtrooper kernel: R10: 00000000ffffffff R11: =
ffff9e38ff2f7140 R12: ffff9e35c50f1618
>> dez 07 18:33:45 stormtrooper kernel: R13: ffffb1688085fd58 R14: =
0000000000000001 R15: ffff9e35d82d8000
>> dez 07 18:33:45 stormtrooper kernel: FS:  0000000000000000(0000) =
GS:ffff9e38eed00000(0000) knlGS:0000000000000000
>> dez 07 18:33:45 stormtrooper kernel: CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
>> dez 07 18:33:45 stormtrooper kernel: CR2: 00007fb814ccffe0 CR3: =
0000000107b72000 CR4: 0000000000350ee0
>> dez 07 18:33:45 stormtrooper kernel: Call Trace:
>> dez 07 18:33:45 stormtrooper kernel:  <TASK>
>> dez 07 18:33:45 stormtrooper kernel:  ? __closure_sync+0xa0/0xa0 =
[bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
>> dez 07 18:33:45 stormtrooper kernel:  bch_journal_read+0xa0/0x350 =
[bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
>> dez 07 18:33:45 stormtrooper kernel:  ? __kernfs_new_node+0x1c5/0x230
>> dez 07 18:33:45 stormtrooper kernel:  run_cache_set+0xb8/0x8f0 =
[bcache de8d79cf2937e54690676a125d53bc2d3cfbb49a]
>> dez 07 18:33:45 stormtrooper kernel:  ? kernfs_add_one+0x20a/0x250
>> dez 07 18:33:45 stormtrooper kernel:  =
register_cache_worker+0xb8b/0xce0 [bcache =
de8d79cf2937e54690676a125d53bc2d3cfbb49a]
>> dez 07 18:33:45 stormtrooper kernel:  process_one_work+0x23a/0x3f0
>> dez 07 18:33:45 stormtrooper kernel:  worker_thread+0x280/0x5c0
>> dez 07 18:33:45 stormtrooper kernel:  ? worker_clr_flags+0x40/0x40
>> dez 07 18:33:45 stormtrooper kernel:  kthread+0x149/0x170
>> dez 07 18:33:45 stormtrooper kernel:  ? kthread_blkcg+0x30/0x30
>> dez 07 18:33:45 stormtrooper kernel:  ret_from_fork+0x1f/0x30
>> dez 07 18:33:45 stormtrooper kernel:  </TASK>
>> dez 07 18:33:45 stormtrooper kernel: ---[ end trace 0000000000000000 =
]---
>=20
> See the ticket for more details.
>=20
> BTW, let me use this mail to also add the report to the list of =
tracked
> regressions to ensure it's doesn't fall through the cracks:
>=20
> #regzbot introduced v6.0..v6.1-rc8
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216785
> #regzbot title bcache: memcpy: detected field-spanning write...
> #regzbot ignore-activity
>=20
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' =
hat)
>=20
> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> reports and sometimes miss something important when writing mails like
> this. If that's the case here, don't hesitate to tell me in a public
> reply, it's in everyone's interest to set the public record straight.


Thanks. I was notice and knew this regression already.

We don=E2=80=99t have too much commit since Linux v6.0, let me try to =
reproduce it and check how it comes.

Coly Li



