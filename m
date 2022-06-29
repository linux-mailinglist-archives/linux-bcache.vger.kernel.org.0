Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2965D55FA38
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 10:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiF2IRi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 04:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF2IRh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 04:17:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAE53BA7B
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 01:17:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9AFAD1F9BE;
        Wed, 29 Jun 2022 08:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656490655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHiBwAtn5aq9ffsyukFR654tHfBnrP9R0Pngb85ir7w=;
        b=Hk/4QLAqf7Lw85dQEUK/RRxWBjsE8FoRhOVqhCb6bX6UegLvjhIxLYS05KT3y7Cb3Tbm11
        b6tB7UoJ+MbqYnFe7GnQMPtPgiDLbklmABgIomq2IdwYlK6n7EpkPv+IgdM4W3C3Nx6/hs
        QOVHCi6qdJeUkem83AbwydWMbMbaqMo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656490655;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHiBwAtn5aq9ffsyukFR654tHfBnrP9R0Pngb85ir7w=;
        b=q29hqb2xngFmYFDoWYtpaD+mPV7npqRSZjX8djuuk+GqkacZZd+oXSQbNgTiwRm4byJb7E
        x9wgpT+7clM6lEAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2C74132C0;
        Wed, 29 Jun 2022 08:17:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OsN0L54KvGLHZQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 29 Jun 2022 08:17:34 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: seeing this stace trace on kernel 5.15
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
Date:   Wed, 29 Jun 2022 16:17:32 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de>
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de>
 <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de>
 <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
 <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
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



> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 16:09=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> Note I used partitions for the bcache as well as the hdd, not sure if
> that's a factor.
>=20
> the kernel is upstream kernel -
>=20
> # uname -a
> Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
> 14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux


Hi Nikhil,

I don=E2=80=99t find the commit id =
767db4b286c3e101ac220b813c873f492d9e4ee8 fro neither Linus tree nor =
stable tree.

The tree you mentioned at =
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/cod/mainline/v5.15=
.50 (767db4b286c3e101ac220b813c873f492d9e4ee8), I am not sure whether it =
is a clone of Linus tree or stable tree. Maybe you may try v5.15.50 from =
the stable tree =
(git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git), then =
we can focus on identical code base.

Thanks.

Coly Li


>>>>>>=20

[snipped]
>>>>>>=20
>>>>>> Is this a bug? It's in writeback mode. I'd setup the cache and =
run stuff like,
>>>>>>=20
>>>>>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>>>>>>=20
>>>>>> I had also echoed 0 into congested_read_threshold_us,
>>>>>> congested_write_threshold_us.
>>>>>>=20
>>>>>> echo writeback > /sys/block/bcache0/bcache/cache_mode
>>>>>=20
>>>>> Where do you get the kernel? If this is stable kernel, could you =
give me the HEAD commit id?
>>>>>=20
>>>>> Coly Li
>>>>>=20
>>>=20

