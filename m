Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F70553386
	for <lists+linux-bcache@lfdr.de>; Tue, 21 Jun 2022 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348884AbiFUNYF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 Jun 2022 09:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351584AbiFUNXf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 Jun 2022 09:23:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D98718B2F
        for <linux-bcache@vger.kernel.org>; Tue, 21 Jun 2022 06:23:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1C88B21C92;
        Tue, 21 Jun 2022 13:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655817813; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htlQHi5WA9dDSLmNWqt6FnwGB2gJ/73yqM4GMRR0DQ0=;
        b=IH8KhPA389732/bGpHoDIZdSNmGKBBA/yMAjAi0nYTA/AcxiEERrrOqb4J31vaqr8VlbFK
        iCk1jcEGFpY5MO/e0N81b2mcPYMnoz+rg65N0bCNTEfJw8IQVhcdub/m7BmRC9DIFa2OaW
        4wlyN1aZw7hsJSapSmW1wWma8qoTNDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655817813;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=htlQHi5WA9dDSLmNWqt6FnwGB2gJ/73yqM4GMRR0DQ0=;
        b=WrU0sx+22h96iDHcpRYq59+PubdbmzYWe06beSBB/UwynHrJC8J/tYzwQ6ppVtBw4StJnB
        799fAgEyJz4k5cCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC24813A88;
        Tue, 21 Jun 2022 13:23:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1mwSKVPGsWKrKgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 21 Jun 2022 13:23:31 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: trying to reproduce bcache journal deadlock
 https://www.spinics.net/lists/kernel/msg4386275.html
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv3Ar-Xb-tGOMQX4PsPc5GSu=7zf_37yWvGkss=HqYfBmw@mail.gmail.com>
Date:   Tue, 21 Jun 2022 21:23:28 +0800
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <44F3206D-9807-4416-9183-A613BEB4A1E2@suse.de>
References: <CAC6jXv1hTHhPdZNOhbSOzQTW+pBfAXfpGkxJfjjBmS8bYaHfZw@mail.gmail.com>
 <20220621043543.zvxgekvcs34abim6@moria.home.lan>
 <CAC6jXv27xfHQVFTX_U944qSStY=k9WLzPENh-tpBimcA7kms-w@mail.gmail.com>
 <CAC6jXv3Ar-Xb-tGOMQX4PsPc5GSu=7zf_37yWvGkss=HqYfBmw@mail.gmail.com>
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



> 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 13:40=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> I figured later that you probably meant for me to change the
> SB_JOURNAL_BUCKETS to 8 in bcache-tools and not the kernel?
>=20
> Regards,
> Nikhil.


Hi Nikhil,

As I said in previous offline email, you should modify both bcache-tool =
and kernel code for SB_JOURNAL_BUCKETS, to 8 or 16, and recompile both.
With the patch it is very hard to reproduce the deadlock (because it is =
fixed by this patch), you may observe the free journal space in run time =
and reboot time. If there is alway at least 1 journal bucket reserved =
during run time, then you won=E2=80=99t observe the journal no-space =
deadlock in boot time.

But 4.15 kernel is not robust enough for bcache (5.4+ is good and 5.10+ =
is better), if you are stucked by other bugs during this testing, it is =
possible.

Coly Li


>=20
> On Tue, 21 Jun 2022 at 11:06, Nikhil Kshirsagar =
<nkshirsagar@gmail.com> wrote:
>>=20
>> Thank you Kent,
>>=20
>> I've made this change, in include/uapi/linux/bcache.h and will build
>> the kernel with it to attempt to reproduce the issue, and create a =
new
>> bcache device. Just wondering if the note about it being divisible by
>> BITS_PER_LONG may restrict it to a minimum value of 32?
>>=20
>> #define SB_JOURNAL_BUCKETS              8
>> /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
>>=20
>> I have a "cache" nvme disk of about 350 tb and some slow disks, each
>> approx 300tb  which I will use to create the bcache device once the
>> kernel is installed. My bcache setup typically would look like,
>>=20
>> NAME      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
>> sdb         8:16   0 279.4G  0 disk
>> =E2=94=94=E2=94=80bcache0 252:0    0 279.4G  0 disk
>> sdc         8:32   0 279.4G  0 disk
>> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
>> sdd         8:48   0 279.4G  0 disk
>> =E2=94=94=E2=94=80bcache1 252:128  0 279.4G  0 disk
>> nvme0n1   259:0    0 372.6G  0 disk
>> =E2=94=9C=E2=94=80bcache0 252:0    0 279.4G  0 disk
>> =E2=94=9C=E2=94=80bcache1 252:128  0 279.4G  0 disk
>> =E2=94=94=E2=94=80bcache2 252:256  0 279.4G  0 disk
>>=20
>> Regards,
>> Nikhil.
>>=20
>> On Tue, 21 Jun 2022 at 10:05, Kent Overstreet =
<kent.overstreet@gmail.com> wrote:
>>>=20
>>> On Tue, Jun 21, 2022 at 09:11:10AM +0530, Nikhil Kshirsagar wrote:
>>>> Hello all,
>>>>=20
>>>> I am trying to reproduce the problem that
>>>> 32feee36c30ea06e38ccb8ae6e5c44c6eec790a6 fixes, but I am not sure =
how.
>>>> This is to verify and test its backport
>>>> (https://pastebin.com/fEYmPZqC) onto kernel 4.15 (Thanks Kent for =
the
>>>> help with that backport!)
>>>>=20
>>>> Could this be reproduced by creating a bcache device with a smaller
>>>> journal size? And if so, is there some way to pass the journal size
>>>> argument during the creation of the bcache device?
>>>=20
>>> Change SB_JOURNAL_BUCKETS to 8 and make a new cache, it's used in =
the
>>> initialization path.
>>>=20
>>> Bonus points would be to tweak journal reclaim so that we're slower =
to reclaim
>>> to makes sure the journal stays full, and then test recovery.

