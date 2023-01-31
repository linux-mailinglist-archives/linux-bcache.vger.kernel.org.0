Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDDF46831DF
	for <lists+linux-bcache@lfdr.de>; Tue, 31 Jan 2023 16:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232728AbjAaPvr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 31 Jan 2023 10:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjAaPvq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 31 Jan 2023 10:51:46 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED1615CA0
        for <linux-bcache@vger.kernel.org>; Tue, 31 Jan 2023 07:51:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CFEC6206C7;
        Tue, 31 Jan 2023 15:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675180303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwhLWPrg+HeNKo4WvD/QWVVLg5L92od03KN5AyUkhQI=;
        b=qCyyoWSLDREXln4VJ7kUkE1VAHlJ6oiDsKstyTLAkYkHVFh2bcQDShsN4++390iM1JRmCu
        zadUXYvGOCF2+bpAHM3XTTWNX94JtcwpwGwiUsfahT6YHKYcBfxm4shoO/VY6qGN+pKXPF
        9EtrwAkEM2uBegGq2D2em80w7G+pjoI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675180303;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TwhLWPrg+HeNKo4WvD/QWVVLg5L92od03KN5AyUkhQI=;
        b=md03R63xeKku2MQFuvznwhYtY0aXzmaQlOGPCNXjITQoB2AuHjV+r14DSgjmlm+FzY0OFT
        qNvb/3KXbbNiJwBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE26A138E8;
        Tue, 31 Jan 2023 15:51:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id BcVFLg452WONbAAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 Jan 2023 15:51:42 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: Multi-Level Caching
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com>
Date:   Tue, 31 Jan 2023 23:51:30 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA6912BA-7DE5-466E-8E85-9EB58FCFC81D@suse.de>
References: <CAHykVA6L3bQkGJ11N3jG_QSgPbyr40zc8rBNPPwBN9a5RHwC6Q@mail.gmail.com>
To:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B41=E6=9C=8826=E6=97=A5 19:30=EF=BC=8CAndrea Tomassetti =
<andrea.tomassetti-opensource@devo.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
> I know that bcache doesn't natively support multi-level caching but I
> was playing with it and found this interesting "workaround":
>  make-bcache -B /dev/vdb -C /dev/vdc
> the above command will generate a /dev/bcache0 device that we can now
> use as backing (or cached) device:
>  make-bcache -B /dev/bcache0 -C /dev/vdd
> This will make the kernel panic because the driver is trying to create
> a duplicated "bcache" folder under /sys/block/bcache0/ .
> So, simply patching the code inside register_bdev to create a folder
> "bcache2" if "bcache" already exists does the trick.
> Now I have:
> vdb                       252:16   0    5G  0 disk
> =E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
>  =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk =
/mnt/bcache1
> vdc                       252:32   0   10G  0 disk
> =E2=94=94=E2=94=80bcache0                 251:0    0    5G  0 disk
>  =E2=94=94=E2=94=80bcache1               251:128  0    5G  0 disk =
/mnt/bcache1
> vdd                       252:48   0    5G  0 disk
> =E2=94=94=E2=94=80bcache1                 251:128  0    5G  0 disk =
/mnt/bcache1
>=20
> Is anyone using this functionality? I assume not, because by default
> it doesn't work.
> Is there any good reason why this doesn't work by default?
>=20
> I tried to understand how data will be read out of /dev/bcache1: will
> the /dev/vdd cache, secondly created cache device, be interrogated
> first and then will it be the turn of /dev/vdc ?
> Meaning: can we consider that now the layer structure is
>=20
> vdd
> =E2=94=94=E2=94=80vdc
>       =E2=94=94=E2=94=80bcache0
>             =E2=94=94=E2=94=80bcache1
> ?

IIRC, there was a patch tried to achieve similar purpose. I was not =
supportive for this idea because I didn=E2=80=99t see really useful use =
case.
In general, extra layer cache means extra latency in the I/O path. What =
I see in practical deployments are, people try very hard to minimize the =
cache layer and place it close to application.

Introduce stackable bcache for itself may work, but I don=E2=80=99t see =
real usage yet, and no motivation to maintain such usage still.

Thanks.

Coly Li=
