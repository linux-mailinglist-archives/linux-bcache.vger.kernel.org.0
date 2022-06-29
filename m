Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5742E55F9EF
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 10:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiF2H7W (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 03:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiF2H7W (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 03:59:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D3339167
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 00:59:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1137C1FADE;
        Wed, 29 Jun 2022 07:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656489560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pn0S8qs34p5wJbIxEwbU+pD7+G0bhHRnBY01iXS9zM8=;
        b=HSWhon6gOtcHV58GYn0wsjh2jRjsWqgMe1Vp8h333ITWXknG6QuQy5jnbLCc2FjGhH4p/p
        ib6CUzuIUK7HvsTEzLFKLwHcz/vLnExrqybmQi+bdO+3bCS7YefqO5liCv3usLFoXfs4ml
        0MMUGKf+zm3KRWpoWFEeON0+ebgUU4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656489560;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pn0S8qs34p5wJbIxEwbU+pD7+G0bhHRnBY01iXS9zM8=;
        b=TooxxkZEznDEiP8CLZuozSLLVUka0r6/fQ4c69U5goECTY5LU595ETHmjNbd/aNpp3d2IN
        xxxUK7o7V9TNLoDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 741AE133D1;
        Wed, 29 Jun 2022 07:59:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yYJ0EVcGvGLrXQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 29 Jun 2022 07:59:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: seeing this stace trace on kernel 5.15
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
Date:   Wed, 29 Jun 2022 15:59:16 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <44AB6083-5B5B-42FA-9E67-084CA2E6BAF3@suse.de>
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de>
 <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de>
 <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
To:     Nikhil Kshirsagar <nkshirsagar@gmail.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 15:56=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> 60gb slow hdd, 15gb fast nvme cache. shall i file upstream bug for =
this issue?


If you may trigger this on upstream kernel or stable kernel, please do =
it.


Coly Li




>=20
> On Wed, 29 Jun 2022 at 13:20, Coly Li <colyli@suse.de> wrote:
>>=20
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 15:02=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi Coly,
>>>=20
>>> I see the same bug on upstream kernel when I tried with
>>> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/  (
>>> cod/mainline/v5.15.50 (767db4b286c3e101ac220b813c873f492d9e4ee8)
>>=20
>>=20
>> Can you help to try the linux-stable tree, or the latest upstream =
Linus tree? Then I can have a clean code base.
>>=20
>>>=20
>>> Reads seem to trigger it, not writes. So this test triggered it -
>>>=20
>>> fio --name=3Dread_iops --directory=3D/home/ubuntu/bcache_mount =
--size=3D12G
>>> --ioengine=3Dlibaio --direct=3D1 --verify=3D0 --bs=3D4K =
--iodepth=3D128
>>> --rw=3Drandread --group_reporting=3D1
>>>=20
>>> https://pastebin.com/KyVSfnik has all the details.
>>=20
>>=20
>> OK, I will try to reproduce with above operation. What is the =
preferred cache and backing device sizes to reproduce the soft lockup?
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>=20


