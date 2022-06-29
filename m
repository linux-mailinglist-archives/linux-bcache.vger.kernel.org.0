Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B4F5600EF
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Jun 2022 15:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiF2NAb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Jun 2022 09:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiF2NAa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Jun 2022 09:00:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FECC39802
        for <linux-bcache@vger.kernel.org>; Wed, 29 Jun 2022 06:00:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1BAD61FA76;
        Wed, 29 Jun 2022 13:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656507628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEAx9LSxHxwgY57mhrIsJvzxLwNLNz/UjQh1wC9cENM=;
        b=U3pMjZLuOVQTVj2oGfHOWP2u5ogP15sTTlpolg/Lm/f7DrHANVmSOyEG1F7R75Kbs/QiMa
        PD/v4QSNNEGYqxwT1J0tH9BD6TeoWTBC5P3Bg3ABryudiI5Az4iMELNm7ge8r+DL9wMxdQ
        BZxwmSf9LeCVbHhYY7OFzwpogTGvBgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656507628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eEAx9LSxHxwgY57mhrIsJvzxLwNLNz/UjQh1wC9cENM=;
        b=SzE7zyigLYUgnllHRWlF5ilgzQLSJSTkVa4jnim5CNlKdIl9TXsKWM0X6wlu2LDC7h6WzD
        vKZonxMMf7VNfOBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 83D1B132C0;
        Wed, 29 Jun 2022 13:00:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2FZKFetMvGKSYgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 29 Jun 2022 13:00:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: seeing this stace trace on kernel 5.15
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
Date:   Wed, 29 Jun 2022 21:00:24 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <57EBEC71-97EB-4B03-9E30-DFA87BCC622D@suse.de>
References: <CAC6jXv07ejbwOtqBLxLtV+Bc-ibBuSNgB+hTgY2QtAXH2tuN3Q@mail.gmail.com>
 <342D4E30-B29D-4C19-8DE5-90726F97282A@suse.de>
 <CAC6jXv1SvSQfjrCEX0R9gcYOuVO0AJSfcZoaW9gvSdCRr=Yfew@mail.gmail.com>
 <AB9B7785-A53B-4015-9217-5D56CFF8E482@suse.de>
 <CAC6jXv310pcJ5oEJ98cQBeM9iEhSLOUEuSMbtoP5nSL37T17KA@mail.gmail.com>
 <CAC6jXv1wRjYsDmkR_BjExQ6-kgF+8bAhy84AnVqgObDg1_BEvA@mail.gmail.com>
 <A6B77C96-E453-4631-BB3C-10B46C41A6FE@suse.de>
 <CAC6jXv2d3KizHWn+TTiwtzEThbu8UBwgD8fSf7i8AHjyXQFCCQ@mail.gmail.com>
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



> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 18:33=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> please use this as a reference, this is the source code to refer to
> for the kernel i was able to reproduce this on
> (https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/)
>=20
>=20

Oh, I didn=E2=80=99t know this. Thanks for the hint.


> commit 18a33c8dabb88b50b860e0177a73933f2c0ddf68 (tag: v5.15.50)
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat Jun 25 15:18:40 2022 +0200
>=20
>    Linux 5.15.50
>=20
>    Link: =
https://lore.kernel.org/r/20220623164322.288837280@linuxfoundation.org
>    Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>    Tested-by: Shuah Khan <skhan@linuxfoundation.org>
>    Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
>    Tested-by: Jon Hunter <jonathanh@nvidia.com>
>    Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
>    Tested-by: Ron Economos <re@w6rz.net>
>    Tested-by: Guenter Roeck <linux@roeck-us.net>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> I am able to reproduce this bug on older kernels too, like 5.4.0-121.
> I will also test the latest upstream kernel soon.
>=20


Thanks.

Coly Li


> Regards,
> Nikhil.
>=20
> On Wed, 29 Jun 2022 at 13:47, Coly Li <colyli@suse.de> wrote:
>>=20
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 16:09=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Hi Coly,
>>>=20
>>> Note I used partitions for the bcache as well as the hdd, not sure =
if
>>> that's a factor.
>>>=20
>>> the kernel is upstream kernel -
>>>=20
>>> # uname -a
>>> Linux bronzor 5.15.50-051550-generic #202206251445 SMP Sat Jun 25
>>> 14:51:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
>>=20
>>=20
>> Hi Nikhil,
>>=20
>> I don=E2=80=99t find the commit id =
767db4b286c3e101ac220b813c873f492d9e4ee8 fro neither Linus tree nor =
stable tree.
>>=20
>> The tree you mentioned at =
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.15.50/cod/mainline/v5.15=
.50 (767db4b286c3e101ac220b813c873f492d9e4ee8), I am not sure whether it =
is a clone of Linus tree or stable tree. Maybe you may try v5.15.50 from =
the stable tree =
(git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git), then =
we can focus on identical code base.
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>=20
>>>>>>>>=20
>>=20
>> [snipped]
>>>>>>>>=20
>>>>>>>> Is this a bug? It's in writeback mode. I'd setup the cache and =
run stuff like,
>>>>>>>>=20
>>>>>>>> echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>>>>>>>>=20
>>>>>>>> I had also echoed 0 into congested_read_threshold_us,
>>>>>>>> congested_write_threshold_us.
>>>>>>>>=20
>>>>>>>> echo writeback > /sys/block/bcache0/bcache/cache_mode
>>>>>>>=20
>>>>>>> Where do you get the kernel? If this is stable kernel, could you =
give me the HEAD commit id?
>>>>>>>=20
>>>>>>> Coly Li
>>>>>>>=20
>>>>>=20
>>=20

