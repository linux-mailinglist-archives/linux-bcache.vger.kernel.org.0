Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2177AEFC9
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Sep 2023 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbjIZPhi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Sep 2023 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235053AbjIZPhg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Sep 2023 11:37:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959EF121
        for <linux-bcache@vger.kernel.org>; Tue, 26 Sep 2023 08:37:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 58DC81F897;
        Tue, 26 Sep 2023 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1695742648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwfGGbKwC2Nh7YyDfBtMY2U9WM7MzNd/FDV8Ua3yxRs=;
        b=U2WVss67he3zxZKNSCwoAid2+bPZwN34VMErXP9daNYGM42OU2JbvzMTOXhULJkAbGp5L8
        r42RSXYwMIEFuLs+Yu5Q1JbzRPtrJlBIwCCBj9nIG/8sk2Ry6Pr0jhMuwqh/HIX4oKqEip
        gpgmtCka77ziZ8SZ161/dv2k4iP+51o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1695742648;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwfGGbKwC2Nh7YyDfBtMY2U9WM7MzNd/FDV8Ua3yxRs=;
        b=RePk7aCWtq/w9V9W7xID0TA2xTatf4bMYq7e4VISXD5UUrmwr5zOPH97TNJUGwQ/BXWZx1
        DbEtTPyZnGMdThAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4906D13434;
        Tue, 26 Sep 2023 15:37:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ui24Arf6EmWZBQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 26 Sep 2023 15:37:27 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: Unusual value of optimal_io_size prevents bcache initialization
From:   Coly Li <colyli@suse.de>
In-Reply-To: <8e19179-342d-6449-8c9-531fe3fbd16@ewheeler.net>
Date:   Tue, 26 Sep 2023 23:37:14 +0800
Cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EA8BF47E-F728-4A80-A07E-CD5A38935490@suse.de>
References: <4fd61b55-195f-8dc5-598e-835bd03a00ec@devo.com>
 <iymfluasxp5webd4hbgxqsuzq6jbeojti7lfue5e4wd3xcdn4x@fcpmy7uxgsie>
 <f3bbd0b9-1783-e924-4b8c-c825d8eb2ede@devo.com>
 <7BFB15E2-7FC6-40F8-8E26-8F23D12F2CD2@suse.de>
 <8e19179-342d-6449-8c9-531fe3fbd16@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.700.6)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B49=E6=9C=8826=E6=97=A5 04:41=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>>=20

[snipped]

>>=20
>>>>> Another consideration, stripe_sectors_dirty and =
full_dirty_stripes, the two
>>>>> arrays allocated using n, are being used just in writeback mode, =
is this
>>>>> correct? In my specific case, I'm not planning to use writeback =
mode so I
>>>>> would expect bcache to not even try to create those arrays. Or, at =
least, to
>>>>> not create them during initialization but just in case of a change =
in the
>>>>> working mode (i.e. write-through -> writeback).
>>>> Indeed, Mingzhe Zou (if I remember correctly) submitted a patch for =
this
>>>> idea, but it is blocked by other depending patches which are not =
finished
>>>> by me. Yes I like the idea to dynamically allocate/free =
d->stripe_sectors_dirty
>>>> and d->full_dirty_stripes when they are necessary. I hope I may =
help to make
>>>> the change go into upstream sooner.
>>>> I will post a patch for your testing.
>>> This would be great! Thank you very much! On the other side, if =
there's anything I can do to help I would be glad to contribute.
>>=20
>> I will post a simple patch for the reported memory allocation failure =
for you to test soon.
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>>=20
>=20
>=20
> Hi Coly and Andrea:
>=20
> Years ago I wrote a patch to make stripe_size and=20
> partial_stripes_expensive configurable:
>=20
> https://lore.kernel.org/lkml/yq1fspvq99j.fsf@ca-mkp.ca.oracle.com/T/
>=20
> A modern version of this could be merged with bcache-tools support. =
There=20
> are still RAID controllers that either do not report io_opt, and =
Andrea's=20
> issue highlights the problem with io_opt being too small.

We should try best to avoid the on-disk format change, before adding new =
member into bcache super block a new incompatible feature bit is =
required, other wise old format running on new kernel will be =
problematic. I replied this in the original discussion.

And adding a sysfs interface to change the bcache stripe size might =
introduce more unnecessary troubles. IMHO I=E2=80=99d prefer to increase =
the minimal bcache stripe size which still may work fine with writeback =
code.

Coly Li


