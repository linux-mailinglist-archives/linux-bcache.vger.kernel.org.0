Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B52B5533E7
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 15:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349766AbiFUNnI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 09:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiFUNnH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 09:43:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0B4240A8
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jun 2022 06:43:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5F3831F8A3;
        Tue, 21 Jun 2022 13:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655818984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5KQvaol6BT1uqLRtFHcuqS0ji9YrWFytLTgrA8IyYUQ=;
        b=XKCniIKP2lptJ8As10BG6WdyHwvw0lNpLbKULrT4FpUbJ447tF5YpW2TS0jZNUB3dGDCLD
        4T9QaJatfB/cOJfanN6qxOtbIW9uKdkea4V31HKxTEJVxGVswHQr0SbCE1cin1c1rVEnm2
        uCqj6FBkNdP4kxD6iLWNYdbrHFzWg8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655818984;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5KQvaol6BT1uqLRtFHcuqS0ji9YrWFytLTgrA8IyYUQ=;
        b=Dr0XhRu77C7b7tRxFbrsj2yMdTg4xbE3BanO3VkJBh47G9h5HnoLnsW7eyRIw/QiD68GYs
        +IMjBGBA7Bz8iOAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6AF5713A88;
        Tue, 21 Jun 2022 13:43:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GhCODOfKsWIiNQAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 21 Jun 2022 13:43:03 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: trying to reproduce bcache journal deadlock
 https://www.spinics.net/lists/kernel/msg4386275.html
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv0FkOzyRk5aObkCWwWuwyEbDWNY2qvU=VQNrCr9jPx2EA@mail.gmail.com>
Date:   Tue, 21 Jun 2022 21:43:00 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <983E0EB0-0628-4874-B992-FC7D351D4853@suse.de>
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
 <20220621043543.zvxgekvcs34abim6@moria.home.lan>
 <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
 <CAC6jXv3Ar-Xb-tGOMQX4PsPc5GSu=7zf_37yWvGkss=HqYfBmw@mail.gmail.com>
 <44F3206D-9807-4416-9183-A613BEB4A1E2@suse.de>
 <CAC6jXv0FkOzyRk5aObkCWwWuwyEbDWNY2qvU=VQNrCr9jPx2EA@mail.gmail.com>
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



> 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 21:35=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
>=20
> thanks, so , I will also change uapi/linux/bcache.h SB_JOURNAL_BUCKETS
> to 8 but I noted the note in the kernel header file, which said "/*
> SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */" which I
> think is 32..

Hi Nikhil,

It=E2=80=99s fine, for me I modify it to 16, and 8 should work as well.

>=20
> As of now I have not built the backported patch into the kernel
> (Ubuntu-4.15.0-183.192) which I am simply using to reproduce the
> issue. Then I will build the patch into the kernel and verify that the
> deadlock isn't ever seen. My problem is simply reproducing it for now
> (without the fix compiled in). What I'm trying is (modify
> SB_JOURNAL_BUCKETS to 8 both in bcache-tools and kernel, and then
> created the bcache device and then filled it up by fio random writes
> of about 250 gb data, and then run constantly.. -
> https://pastebin.com/Sh3q6fXv .. not a reboot. Do you think in fact a
> reboot is needed to reproduce it, and this approach of
> de-register/register would not work to see the deadlock?)

Reboot is not necessary. You can also try to stop all the cache and =
backing devices and removed the bcache kernel module, and reload =
bcache.ko and re-register cache and backing device.

It is not easy to reproduce the deadlock, last time when I tried to do =
it, indeed I triggered another deadlock in journal code. This was why I =
stopped fixing the journal no-space deadlock because I though it would =
not happen in practice. This time I am not able to trigger the no-space =
deadlock, what I do is to observe whether there is enough space always =
reserved. If there is space reserved, then it won=E2=80=99t deadlock.


>=20
> Once I reproduce it successfully a few times, I'll compile in the
> backported patch and then verify I never see the deadlock again,
> that's the best I can do I guess in the circumstances.
>=20
> Thank you (and to Kent++ for helping me with the backport patch) for
> all the help with this! I am very grateful for your help and
> responses.
>=20

Indeed, I am not sure whether what you triggered is the journal no-space =
deadlock or other deadlock which was not fixed in 4.15 kernel. So I am =
not able to provide advice. For me, if I see there is always reserved =
journal space which can be used in registration time, then I believe the =
no-space deadlock won=E2=80=99t happen.


Coly Li




>=20
> On Tue, 21 Jun 2022 at 18:53, Coly Li <colyli@suse.de> wrote:
>>=20
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 13:40=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> I figured later that you probably meant for me to change the
>>> SB_JOURNAL_BUCKETS to 8 in bcache-tools and not the kernel?
>>>=20
>>> Regards,
>>> Nikhil.
>>=20
>>=20
>> Hi Nikhil,
>>=20
>> As I said in previous offline email, you should modify both =
bcache-tool and kernel code for SB_JOURNAL_BUCKETS, to 8 or 16, and =
recompile both.
>> With the patch it is very hard to reproduce the deadlock (because it =
is fixed by this patch), you may observe the free journal space in run =
time and reboot time. If there is alway at least 1 journal bucket =
reserved during run time, then you won=E2=80=99t observe the journal =
no-space deadlock in boot time.
>>=20
>> But 4.15 kernel is not robust enough for bcache (5.4+ is good and =
5.10+ is better), if you are stucked by other bugs during this testing, =
it is possible.
>>=20
>> Coly Li
>>=20
>>=20
>>>=20
>>> On Tue, 21 Jun 2022 at 11:06, Nikhil Kshirsagar =
<nkshirsagar@gmail.com> wrote:
>>>>=20
>>>> Thank you Kent,
>>>>=20
>>>> I've made this change, in include/uapi/linux/bcache.h and will =
build
>>>> the kernel with it to attempt to reproduce the issue, and create a =
new
>>>> bcache device. Just wondering if the note about it being divisible =
by
>>>> BITS_PER_LONG may restrict it to a minimum value of 32?
>>>>=20
>>>> #define SB_JOURNAL_BUCKETS              8
>>>> /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
>>>>=20
>>>> I have a "cache" nvme disk of about 350 tb and some slow disks, =
each
>>>> approx 300tb  which I will use to create the bcache device once the
>>>> kernel is installed. My bcache setup typically would look like,
>>>>=20
>>>> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>>>> sdb         8:16   0 279.4G  0 disk
>>>> =E2=94=94=E2=94=80bcache0 252:0    0 279.4G  0 disk
>>>> sdc         8:32   0 279.4G  0 disk
>>>> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
>>>> sdd         8:48   0 279.4G  0 disk
>>>> =E2=94=94=E2=94=80bcache1 252:128  0 279.4G  0 disk
>>>> nvme0n1   259:0    0 372.6G  0 disk
>>>> =E2=94=9C=E2=94=80bcache0 252:0    0 279.4G  0 disk
>>>> =E2=94=9C=E2=94=80bcache1 252:128  0 279.4G  0 disk
>>>> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
>>>>=20
>>>> Regards,
>>>> Nikhil.
>>>>=20
>>>> On Tue, 21 Jun 2022 at 10:05, Kent Overstreet =
<kent.overstreet@gmail.com> wrote:
>>>>>=20
>>>>> On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
>>>>>> Hello all,
>>>>>>=20
>>>>>> I am trying to reproduce the problem that
>>>>>> 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure =
how.
>>>>>> This is to verify and test its backport
>>>>>> (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for =
the
>>>>>> help with that backport!)
>>>>>>=20
>>>>>> Could this be reproduced by creating a bcache device with a =
smaller
>>>>>> journal size? And if so, is there some way to pass the journal =
size
>>>>>> argument during the creation of the bcache device?
>>>>>=20
>>>>> Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in =
the
>>>>> initialization path.
>>>>>=20
>>>>> Bonus points would be to tweak journal reclaim so that we're =
slower to reclaim
>>>>> to makes sure the journal stays full, and then test recovery.
>>=20

