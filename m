Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6E5A83F5
	for <lists+linux-bcache@lfdr.de>; Wed, 31 Aug 2022 19:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiHaRDL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 31 Aug 2022 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiHaRCp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 31 Aug 2022 13:02:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFC5B49;
        Wed, 31 Aug 2022 10:02:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4D8B02208E;
        Wed, 31 Aug 2022 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661965361; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0qnttkL+CYtRVTaS49rAHU9Us+WvSecGU2DXZi0PyQ=;
        b=bslYp23XXRYcLlhzFd9AByPhyqDerdkGWi1eNixAggLbTSOuqgP9do149pQ4bUlYGi/OLn
        LA70OgzUIFwsDG8Ku2swD/ySV0nQEeh6VX8vXJLqLGMU36Ca6BjSjqTQsbg0VJKol532mZ
        kskJFy+csx1uXISENcw5TYP2YL711Ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661965361;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0qnttkL+CYtRVTaS49rAHU9Us+WvSecGU2DXZi0PyQ=;
        b=I5IAwqJyMQ47BgTj3yIlmzvtHclY2b0tKiJTI/jZwAC/edF4i0y96z19iKdpKHFkwVaDcv
        2ZKxxqMkxXWhdfCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A6CD13A7C;
        Wed, 31 Aug 2022 17:02:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SJv6Jy+UD2NuFAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 31 Aug 2022 17:02:39 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 2/3] bcache: Convert to lib/time_stats
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220831165437.l27raas6k5nlqsdg@moria.home.lan>
Date:   Thu, 1 Sep 2022 01:02:37 +0800
Cc:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F91055C-4253-42CD-8A4A-8B8EA2CF1D6E@suse.de>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
 <20220829165344.2958640-3-kent.overstreet@linux.dev>
 <14ACCED7-D24D-4AC4-8677-F7F4630A840A@suse.de>
 <20220831165437.l27raas6k5nlqsdg@moria.home.lan>
To:     Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=881=E6=97=A5 00:54=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Sep 01, 2022 at 12:00:17AM +0800, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B48=E6=9C=8830=E6=97=A5 00:53=EF=BC=8CKent Overstreet =
<kent.overstreet@linux.dev> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> This patch converts bcache to the new generic time_stats code
>>> lib/time_stats.c. The new code is from bcachefs, and has some =
changes
>>> from the version in bcache:
>>>=20
>>> - we now use ktime_get_ns(), not local_clock(). When the code was
>>>  originally written multi processor systems that lacked synchronized
>>>  TSCs were still common, and so local_clock() was much cheaper than
>>>  sched_clock() (though not necessarily fully accurate, due to TSC
>>>  drift). ktime_get_ns() should be cheap enough on all common =
hardware
>>>  now, and more standard/correct.
>>>=20
>>> - time_stats are now exported in a single file in sysfs, which means =
we
>>>  can improve the statistics we keep track of without changing all
>>>  users. This also means we don't have to manually specify which =
units
>>>  (ms, us, ns) a given time_stats should be printed in; that's =
handled
>>>  dynamically.
>>>=20
>>> - There's a lazily-allocated percpu buffer, which now needs to be =
freed
>>>  with time_stats_exit().
>>>=20
>>> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>>> Cc: Coly Li <colyli@suse.de>
>>=20
>> Hi Kent,
>>=20
>> Overall I am OK with the change to bcache code. You may add
>> 	Acked-by: Coly Li <colyli@suse.de>
>> in future version of this patch.
>>=20
>> In bcache-tools, they don=E2=80=99t read the changed sysfs files =
(including bcache-status), IMHO changing the output format won=E2=80=99t =
be problem for upstream.
>>=20
>> My only question is, how to understand the time_stats_to_text() =
output format,
>> count:          3
>> rate:           0/sec
>> frequency:      4 sec
>> avg duration:   4 sec
>> max duration:   4 sec
>> quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 =
5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 =
5360836048 5360836048 5360836048 5360836048
>>=20
>> Fro the above output, what are =E2=80=9Crate=E2=80=9D, =
=E2=80=9Cfrequence=E2=80=9D and =E2=80=9Cquantiles=E2=80=9D for?
>=20
> Rate and frequency are inverses - in this example, we're seeing 4 =
events per
> second.
>=20

Can I understand that rate =3D 1/frequency ?  Then frequency 4 is around =
to rate 0.

> The quantiles are for the duration, they give you an idea of the =
statistical
> distribution, see https://en.wikipedia.org/wiki/Quantile

I wanted to ask how to read the quantiles line. Does it mean that 1 ns =
is equally divided by 15 segments, and the counter values are for the =
divided 1/15 ns segments?

>=20
> In the near future, the quantiles will be removed and replaced with =
standard
> deviation, true and weighted - the quantiles algorithm isn't super =
accurate, we
> can give more accurate numbers with standard deviation.

Quantiles are much humane, standard deviation is scared=E2=80=A6 Just =
FYI LOL.

Thanks.

Coly Li

