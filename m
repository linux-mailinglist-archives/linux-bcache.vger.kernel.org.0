Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D79556F7B2F
	for <lists+linux-bcache@lfdr.de>; Fri,  5 May 2023 04:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjEECsy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 May 2023 22:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjEECsx (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2023 22:48:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D0F12090
        for <linux-bcache@vger.kernel.org>; Thu,  4 May 2023 19:48:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E3C8F1F8BA;
        Fri,  5 May 2023 02:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683254925; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyX9ygz0wYZgnSBQM6zp9hJh3Ov25d1vSN4G2eEsCGg=;
        b=aX0hpyk+mjxlAK1/fUJ/6kY980aLZ97MrCk/4Ei211JItgSfAsu8yJls+cbS7Z5oFka7bd
        fVeI2O+oIEGTMTxH4FyjuGSC3KyyQr//BnNwVJ89oNDeSpB3rxtoI9jvf7ON7jymCIhag2
        OsKvXxhVZN5MHNjQD4UTR6doaO/3Z6U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683254925;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyX9ygz0wYZgnSBQM6zp9hJh3Ov25d1vSN4G2eEsCGg=;
        b=Xx+R+JqikwetRD1/dHlBW6fY9/AK5Ej9v+jlEcsvSWYvUlE0DU/7JOckJfYyJ2HdGo/VWv
        KizEoUXPN4+C8XCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19667134AF;
        Fri,  5 May 2023 02:48:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rcjkNYxuVGSGMwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 05 May 2023 02:48:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Bcache btree cache size bug
From:   Coly Li <colyli@suse.de>
In-Reply-To: <LO0P265MB457433BA5B3E01C555CAAC75EF6D9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
Date:   Fri, 5 May 2023 10:48:32 +0800
Cc:     Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <08ECC377-24C7-46C6-B527-1E8FBB45B03E@suse.de>
References: <LO0P265MB45742A9C654C2EB4EB3775CEEFD99@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
 <CAHykVA5ADwoio5Bhz3wLniufFNrOtT_fA4QR+DFr1EqbN2WpOA@mail.gmail.com>
 <LO0P265MB45748D7C230EF69DAF91D17FEFDE9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
 <LO0P265MB457433BA5B3E01C555CAAC75EF6D9@LO0P265MB4574.GBRP265.PROD.OUTLOOK.COM>
To:     Benard Bsc <benard_bsc@outlook.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=884=E6=97=A5 22:38=EF=BC=8CBenard Bsc =
<benard_bsc@outlook.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> I've tried to upgrade the system to the latest kernel available: =
5.4.0-139 and I have attempted to swap out the raid controller in case =
it was faulty but none of those things have helped the situation. Once =
again even within the same deployment 2 nodes are experiencing this =
problem but another one is fine, despite the fact that they all seem to =
be the same.
>=20
> Is there anything else that can be checked/done besides upgrading the =
distro? Since this is a HWE kernel I was under the impression that it =
should be supported until 2028. Are there any hidden configuration =
parameters which could have perhaps caused this issue?=20
>=20
> Regards
>=20
> Benard
>=20
>=20
> From: Benard Bsc <benard_bsc@outlook.com>
> Sent: 10 February 2023 10:44
> To: Andrea Tomassetti <andrea.tomassetti-opensource@devo.com>
> Cc: linux-bcache@vger.kernel.org <linux-bcache@vger.kernel.org>
> Subject: Re: Bcache btree cache size bug=20
> =20
> On Thu, 2023-02-09 at 17:07 +0100, Andrea Tomassetti wrote:
>> On Thu, Feb 9, 2023 at 1:22 PM <benard_bsc@outlook.com> wrote:
>>> I believe I have found a bug in bcache where the btree grows out of
>>> control and makes operations like garbage collection take a very
>>> large
>>> amount of time affecting client IO. I can see periodic periods
>>> where
>>> bcache devices stop responding to client IO and the cache device
>>> starts
>>> doing a lage amount of reads. In order to test the above I
>>> triggered gc
>>> manually using 'echo 1 > trigger_gc' and observing the cache set.
>>> Once
>>> again a large amount of reads start happening on the cache device
>>> and
>>> all the bcache devices of that cache set stop responding. I believe
>>> this is becouse gc blocks all client IO while its happening (might
>>> be
>>> wrong). Checking the stats I can see that the
>>> 'btree_gc_average_duration_ms'  is almost 2 minutes
>>> (btree_gc_average_duration_ms) which seems excessively large to me.
>>> Furthermore doing something like checking bset_tree_stats will just
>>> hang and cause a similar performance impact.
>>>=20
>>> An interesting thing to note is that after garbage collection the
>>> number of btree nodes is lower but the btree cache actually grows
>>> in
>>> size.
>>>=20
>>> Example:
>>> /sys/fs/bcache/c_set# cat btree_cache_size
>>> 5.2G
>>> /sys/fs/bcache/c_set# cat internal/btree_nodes
>>> 28318
>>> /sys/fs/bcache/c_set# cat average_key_size
>>> 25.2k
>>>=20
>>> Just for reference I have a similar environment (which is busier
>>> and
>>> has more data stored) which doesnt experience this issue and the
>>> numbers for the above are:
>>> /sys/fs/bcache/c_set# cat btree_cache_size
>>> 840.5M
>>> /sys/fs/bcache/c_set# cat internal/btree_nodes
>>> 3827
>>> /sys/fs/bcache/c_set# cat average_key_size
>>> 88.3k
>>>=20
>>> Kernel version: 5.4.0-122-generic
>>> OS version: Ubuntu 18.04.6 LTS
>> Hi Bernard,
>> your linux distro and kernel version are quite old. There are good
>> chances that things got fixed in the meanwhile. Would it be possible
>> for you to try to reproduce your bug with a newer kernel?
>>=20
>> Regards,
>> Andrea
>>> bcache-tools package: 1.0.8-2ubuntu0.18.04.1
>>>=20
>>> I am able to provide more info if needed
>>> Regards
>>>=20
> Hi Andrea,
>=20
> Thank you very much for your email. Unfortunately due to the nature of
> this system and the other software running on it I am unable to =
upgrade
> the kernel/distro at the moment. I am also unsure that I will be able
> to reproduce this bug as even on other deployments with the same
> version of bcache/kernel this problem does not seem to be happening. =
Is
> there some information I can gather from the existing environment
> without changing the software versions?

The patches which limit B+tree node in-memory cache were merged in Linux =
v5.6, if the kernel you used doesn=E2=80=99t have these patches =
backported, the mentioned situation may still exist.

For non-distro kernel, the latest kernel might be a choice. For distro =
kernel, it can be helpful if the distro kernel maintainers have the =
bcache fixes in.

Coly Li=20

