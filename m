Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26156584393
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jul 2022 17:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbiG1PvU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jul 2022 11:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiG1PvS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jul 2022 11:51:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE131A81F
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jul 2022 08:51:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B96431FA2C;
        Thu, 28 Jul 2022 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659023475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mhb9KKuPTKUezwI9DAY5M7lJMPAOJZS/xfg9Kg4lyMg=;
        b=e38UCoRHVLI326+du1jIaWQhMVXNnUFsQ3dLtDWjqCIOFbjDdsHnRa1+VqkezS255CApu/
        fpMzoiHfl5bwg2jveC+tvDqNIbVQub+ya0k92i0V+NXzv8Adpf/DL1yad/0zVjWAFwrcnQ
        PuJLCYrurLhOxYhkuV4pI9F0GMSAArM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659023475;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mhb9KKuPTKUezwI9DAY5M7lJMPAOJZS/xfg9Kg4lyMg=;
        b=Iuwb2IQXhjZtpZ9ZnnFdxG4Cv+PJtqEPlHif3nRrpkBtEqmNTdqLNkJqMobKrqa9cBNyrY
        7QMaoWq8f74SLuBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5308713427;
        Thu, 28 Jul 2022 15:51:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uj7rAnCw4mIQBQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 28 Jul 2022 15:51:12 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: bcache I/O performance tests on 5.15.0-40-generic
From:   Coly Li <colyli@suse.de>
In-Reply-To: <37577c49-6d0-e5f4-2ea3-51128526526e@ewheeler.net>
Date:   Thu, 28 Jul 2022 23:51:04 +0800
Cc:     Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1E966D2E-1B9E-46DD-BF79-A3FEDAF227ED@suse.de>
References: <CAC6jXv0FoE60HEuc7tDMXEA27hkoMkZm5d6gt4NCRkAh2w3WvA@mail.gmail.com>
 <8C0D66FE-FF1D-469D-A209-10E95F79D2FA@suse.de>
 <37577c49-6d0-e5f4-2ea3-51128526526e@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=886=E6=97=A5 04:49=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Sat, 25 Jun 2022, Coly Li wrote:
>>> 2022=E5=B9=B46=E6=9C=8825=E6=97=A5 14:29=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hello,
>>>=20
>>> I've been doing some performance tests of bcache on =
5.15.0-40-generic.
>>>=20
>>> The baseline figures for the fast and slow disk for random writes =
are
>>> consistent at around 225MiB/s and 3046KiB/s.
>>>=20
>>> But the bcache results inexplicably drop sometimes to 10Mib/s, for
>>> random write test using fio like this -
>>>=20
>>> fio --rw=3Drandwrite --size=3D1G --ioengine=3Dlibaio --direct=3D1
>>> --gtod_reduce=3D1 --iodepth=3D128 --bs=3D4k --name=3DMY_TEST1
>>>=20
>>> WRITE: bw=3D168MiB/s (176MB/s), 168MiB/s-168MiB/s (176MB/s-176MB/s),
>>> io=3D1024MiB (1074MB), run=3D6104-6104msec
>>> WRITE: bw=3D283MiB/s (297MB/s), 283MiB/s-283MiB/s (297MB/s-297MB/s),
>>> io=3D1024MiB (1074MB), run=3D3621-3621msec
>>> WRITE: bw=3D10.3MiB/s (10.9MB/s), 10.3MiB/s-10.3MiB/s
>>> (10.9MB/s-10.9MB/s), io=3D1024MiB (1074MB), run=3D98945-98945msec
>>> WRITE: bw=3D8236KiB/s (8434kB/s), 8236KiB/s-8236KiB/s
>>> (8434kB/s-8434kB/s), io=3D1024MiB (1074MB), run=3D127317-127317msec
>>> WRITE: bw=3D9657KiB/s (9888kB/s), 9657KiB/s-9657KiB/s
>>> (9888kB/s-9888kB/s), io=3D1024MiB (1074MB), run=3D108587-108587msec
>>> WRITE: bw=3D4543KiB/s (4652kB/s), 4543KiB/s-4543KiB/s
>>> (4652kB/s-4652kB/s), io=3D1024MiB (1074MB), run=3D230819-230819msec
>>>=20
>>> This seems to happen after 2 runs of 1gb writes (cache disk is 4gb =
size)
>>>=20
>>> Some details are here - https://pastebin.com/V9mpLCbY , I will share
>>> the full testing results soon, but just was wondering about this
>>> performance drop for no apparent reason once the cache gets about =
50%
>>> full.
>>=20
>>=20
>> It seems you are stuck by garbage collection. 4GB cache is small, the=20=

>> garbage collection might be invoked quite frequently. Maybe you can =
see=20
>> the output of =E2=80=99top -H=E2=80=99 to check whether there is =
kernel thread named=20
>> bache_gc.
>=20
> Hi Nikhil,
>=20
> Do you have Mingzhe's GC patch? It might help:
> https://www.spinics.net/lists/linux-bcache/msg11185.html
>=20
> Coli, did Mingzhe's patch get into your testing tree? It looks like it=20=

> could be a good addition to bcache.

No. This patch just reduce the early gc action to make IO faster, and =
accumulates a large gc action finally to cause more lower I/O period.
The later larger gc may cause longer unpredictable  time I/O stuck, =
which doesn=E2=80=99t follow current bcache behavior.

It may be helpful for some I/O workloads, but for continuous heavy I/O =
loads, it won=E2=80=99t help too much.

Coly Li=
