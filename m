Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37145F9DB9
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Oct 2022 13:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbiJJLip (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 10 Oct 2022 07:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiJJLil (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 10 Oct 2022 07:38:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E426F577
        for <linux-bcache@vger.kernel.org>; Mon, 10 Oct 2022 04:38:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AF51321997;
        Mon, 10 Oct 2022 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665401915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtHhWNfu9JcQGTHFO/Zc7K4V732w/eWe0jpwH91VwxQ=;
        b=uyVkKN0eeVQ9wnfD5SVjoLpsBcHuSicuOaMwh0nyxb3GeM6Butjr8Udu6zIxq6hLs22nD/
        DnLeERTklz4KhTRkSnte8kRRCBwku7VN0wBuTLOb0TaeiDfCOBgw/fn30H8OWupjk29Rgt
        Hm9gxFH9PfR1chw2xFinFwur6hoSrj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665401915;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BtHhWNfu9JcQGTHFO/Zc7K4V732w/eWe0jpwH91VwxQ=;
        b=xrrzDgTxLd/Ww6OllYmBLUk/wyfrByUayPM8ymfAyYqfXf2PPJPhFEMRwF6uOG838L8q0F
        UgUAChrULdw3FHDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5CEF513479;
        Mon, 10 Oct 2022 11:38:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id okddCjoERGOMSgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 10 Oct 2022 11:38:34 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: Feature Request - Full Bypass/Verify Mode
From:   Coly Li <colyli@suse.de>
In-Reply-To: <216bf3b3-b827-efbc-190-31e86de0a85b@ewheeler.net>
Date:   Mon, 10 Oct 2022 19:38:31 +0800
Cc:     Cobra_Fast <cobra_fast@wtwrp.de>, linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B74BCECB-964C-494F-8721-31D3BD1D205B@suse.de>
References: <5ff94948-9406-9b86-2ab3-db74fcb44d00@ezl.re>
 <216bf3b3-b827-efbc-190-31e86de0a85b@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B410=E6=9C=886=E6=97=A5 09:39=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, 5 Oct 2022, Cobra_Fast wrote:
>=20
>> Greetings,
>>=20
>> I am using bcache in conjunction with SnapRAID, which works on the =
FS-level,
>> and I have noticed that parity syncs as well as scrubs read data from =
the
>> cache rather than the backing device. This probably not a problem =
when
>> creating parity for new files, but could be a problem when running =
scrubs, as
>> the parity is never checked against data on disk since bcache hides =
it.
>=20
> Interesting.
>=20
>> I would therefore very much like a cache_mode that would bypass any =
and all
>> reads, that can be enabled for the duration of a SnapRAID sync or =
scrub. For
>> writes I suppose this mode should act the same as "none".
>>=20
>> This opportunity could be taken to verify data on cache as well; read =
from
>> both backing and cache and invalidate the cache page if it differs =
from the
>> backing data, while satisfying the actual read from backing in any =
case.
>=20
> assuming that one or the other is correct... I'm not sure bcache could=20=

> tell which block is valid, and SnapRAID doesn't know about the lldevs.
>=20
>> Perhaps something like this is already possible and I'm just not =
seeing it?
>> I know I can detach backing devices, but to my understanding that =
also
>> invalidates all its cached pages and I would obviously like to keep =
them for
>> this purpose.
>=20
> Well you can only read-validate pages that are not dirty...if its =
dirty=20
> you _must_ read from cache for consistency.
>=20
> You could put it in write_around mode and wait for dirty_bytes to be =
0,=20
> but I think it will still read from the cache if the page is hot.

Or set the cache mode to none after dirty data to be 0, before the sync =
or scrub.


>=20
> Detach sounds like the only option at the moment to get what you're=20
> seeking.  Future work could include adding a `readaround` to=20
> /sys/block/bcache0/bcache/cache_mode, but it would still have to read =
from=20
> the cache if dirty.  Or maybe if `readaround` hits a dirty block it =
evicts=20
> it and re-reads the backing device?  But that sounds messy and slow.


Indeed we already have a similar patch from Guoju Fang, see
	Message-Id: =
<1594610902-4428-1-git-send-email-fangguoju@gmail.com>

But we didn=E2=80=99t call it as readaround or writeonly because they =
are not any of them indeed. The behavior is to avoid refill cache if a =
read-miss happens. If this option is enabled from beginning, data will =
always be read from backing device expect for *dirty* data.

The reason for not having it in is naming, we don=E2=80=99t find a =
better name for the option yet.

Thanks.

Coly Li

