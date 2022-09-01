Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484F95A8B5A
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Sep 2022 04:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiIACUK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 22:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiIACUJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 22:20:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F8018361;
        Wed, 31 Aug 2022 19:20:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2953022026;
        Thu,  1 Sep 2022 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661998806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5+KTbBI0lr0N4U2DBYmtt5UsQfzNdVRm+NI2VPlVFw=;
        b=ZcSKLBb3XeldGLBBQmnssBWgugLlWR/UmwlCRtp48ER/otLpjsR33v8bXzWsPL2/TII18b
        c9CaKi9P9KCcNA3VFYmf0HkW3neyH25V6iJrh1uuUdypeyovvajpsbpaiM3obt/fmUhpzX
        HbWkf5Dx1tXClIzInxeHo9Kos77IMkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661998806;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z5+KTbBI0lr0N4U2DBYmtt5UsQfzNdVRm+NI2VPlVFw=;
        b=0JSKMp2jiujV2rUgrH8rhd3FefiBDoHAikyQavStCd9WbEuz8gePjjMCvPjKLiYIr8fmCl
        xpZzu65KYQyVoPAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 671DE133DD;
        Thu,  1 Sep 2022 02:20:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eM/0CdQWEGNCTwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 01 Sep 2022 02:20:04 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 2/3] bcache: Convert to lib/time_stats
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220831173639.sb6bhg5xvn4gbkiu@moria.home.lan>
Date:   Thu, 1 Sep 2022 10:19:59 +0800
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <20DDF7B2-8433-49EE-8F9F-CB335D2E7B6C@suse.de>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-3-kent.overstreet@linux.dev>
 <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
 <20220831165437.l27raas6k5nlqsdg@moria.home.lan>
 <1F91055C-4253-42CD-8A4A-8B8EA2CF1D6E@suse.de>
 <20220831173639.sb6bhg5xvn4gbkiu@moria.home.lan>
To:     Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=881=E6=97=A5 01:36=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Sep 01, 2022 at 01:02:37AM +0800, Coly Li wrote:
>> Can I understand that rate =3D 1/frequency ?  Then frequency 4 is =
around to rate 0.
>=20
> Correct, rate =3D 1/frequency.
>=20
>>> The quantiles are for the duration, they give you an idea of the =
statistical
>>> distribution, see https://en.wikipedia.org/wiki/Quantile
>>=20
>> I wanted to ask how to read the quantiles line. Does it mean that 1 =
ns is
>> equally divided by 15 segments, and the counter values are for the =
divided
>> 1/15 ns segments?
>=20
> It is the 15 boundaries between 16 equal segments, yes.
>=20
>> Quantiles are much humane, standard deviation is scared=E2=80=A6 Just =
FYI LOL.
>=20
> That's valuable feedback then, maybe we'll keep both. The more =
expensive part of
> time stats is just ingesting data points, but we've got a percpu =
buffer frontend
> for that - just doing a bit more moth doesn't cost much.

I don=E2=80=99t have more question so far. Thanks for the detailed =
replay.

Coly Li=
