Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C6B6D7DDA
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Apr 2023 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238264AbjDENiT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Apr 2023 09:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237308AbjDENiS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Apr 2023 09:38:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1CA1FE0;
        Wed,  5 Apr 2023 06:38:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 85F391FDCA;
        Wed,  5 Apr 2023 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680701895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJB6JausIoM2TpCFlcltYiVgxIJXfNDhv2tfVNi51a8=;
        b=PSWCa6+E70vuHh8QdAwk1rqmwZDX3NrtK++R8IoUBNtVSgDM9yuYupFVFE2ZfCmvd9Ztt7
        W3HW7PK6YTFtj+eBLB6Cn47zwpkJtWqwYMEubGXb45nU56Yq34764kpuikzCPrwO9VeY8a
        KqnUvAbIhHeD61QIUrvaQkyH8NK6nsU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680701895;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJB6JausIoM2TpCFlcltYiVgxIJXfNDhv2tfVNi51a8=;
        b=WtRZHSH/HeN4sTFozH5y/rc1Nr4xWAsB1hYSZJlePOuelk7+lPQeqqkmgSz/CDw70aAIwh
        zbfMDjtmyyMaEmCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A4A013A10;
        Wed,  5 Apr 2023 13:38:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4GgQCMZ5LWRSbgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 05 Apr 2023 13:38:14 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] bcache: make kobj_type structures constant
From:   Coly Li <colyli@suse.de>
In-Reply-To: <4cc38847-a967-487b-8efe-81b741ab6782@t-8ch.de>
Date:   Wed, 5 Apr 2023 21:38:01 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F63C6A45-E428-4557-9995-FDB43CE243B3@suse.de>
References: <20230214-kobj_type-bcache-v1-1-cf00ead7bee7@weissschuh.net>
 <125CA8D6-D3B7-42FB-83BE-DCA688F2ACAF@suse.de>
 <20230214152119.epkfhkojqjvokqmv@t-8ch.de>
 <9DE71214-283C-4410-B5A4-22DFDA7021F4@suse.de>
 <4cc38847-a967-487b-8efe-81b741ab6782@t-8ch.de>
To:     =?utf-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B44=E6=9C=885=E6=97=A5 01:38=EF=BC=8CThomas Wei=C3=9Fschuh =
<linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> On 2023-02-15 00:16:03+0800, Coly Li wrote:
>>> 2023=E5=B9=B42=E6=9C=8814=E6=97=A5 23:21=EF=BC=8CThomas Wei=C3=9Fschuh=
 <linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Tue, Feb 14, 2023 at 05:51:09PM +0800, Coly Li wrote:
>>>>=20
>>>>=20
>>>>> 2023=E5=B9=B42=E6=9C=8814=E6=97=A5 11:13=EF=BC=8CThomas Wei=C3=9Fsch=
uh <linux@weissschuh.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> Since commit ee6d3dd4ed48 ("driver core: make kobj_type =
constant.")
>>>>> the driver core allows the usage of const struct kobj_type.
>>>>>=20
>>>>> Take advantage of this to constify the structure definitions to =
prevent
>>>>> modification at runtime.
>>>>>=20
>>>>=20
>>>> How the const structure definition can prevent modification at run =
time?
>>>=20
>>> It will be put into .rodata instead of .data by the compiler.
>>> The .rodata section is mapped as read-only via the pagetable.
>>>=20
>>> See Documentation/security/self-protection.rst
>>> "Function pointers and sensitive variables must not be writable".
>>=20
>> I see. Thanks for the information.
>>=20
>> This patch will be added into my testing queue, and submitted later.
>=20
> It seems this was not submitted.
> Or did I miss it?

No I don=E2=80=99t submit it yet. It is not emergent fix, and stay with =
other testing patches together.

Do you want it to go now?

Coly Li

