Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73156D3DEC
	for <lists+linux-bcache@lfdr.de>; Mon,  3 Apr 2023 09:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjDCHOz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 3 Apr 2023 03:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjDCHOi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 3 Apr 2023 03:14:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7D05FFA
        for <linux-bcache@vger.kernel.org>; Mon,  3 Apr 2023 00:14:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1307C1F74B;
        Mon,  3 Apr 2023 07:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680506065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7JOCtYJk+4gv5zle+sFMMG2M8GRrxuWscdyrzbu0iO4=;
        b=1Ab+Yj7Zm+3nVqMfui8fkncC3IJNVfH8STNrOO3/DpFesGacmk07gWvIY4annzbTb//n30
        soXwnyrmeWBO8g0xWryDIUFHC2Y6tnk3QJOdMorKvimRKC0R3ahqxE6mmlTCeGhVJWqKa7
        BaPXSXPrGfNsPN3gfkJopXI/bJz/I28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680506065;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7JOCtYJk+4gv5zle+sFMMG2M8GRrxuWscdyrzbu0iO4=;
        b=f8MWUyoRzo+56rJhnDv3+Pdn+Fkw7how05fTZ0WtsKFuPel0TQmlIliy4Dj+4CUTMhD77D
        yf6d2CiQutytjGCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E013A13416;
        Mon,  3 Apr 2023 07:14:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VHbWKc98KmQRGQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 03 Apr 2023 07:14:23 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Writeback cache all used.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
Date:   Mon, 3 Apr 2023 15:14:11 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
 <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
 <1121771993.1793905.1680221827127@mail.yahoo.com>
 <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2023=E5=B9=B44=E6=9C=882=E6=97=A5 08:01=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, 31 Mar 2023, Adriano Silva wrote:
>> Thank you very much!
>>=20
>>> I don't know for sure, but I'd think that since 91% of the cache is
>>> evictable, writing would just evict some data from the cache =
(without
>>> writing to the HDD, since it's not dirty data) and write to that =
area of
>>> the cache, *not* to the HDD. It wouldn't make sense in many cases to
>>> actually remove data from the cache, because then any reads of that =
data
>>> would have to read from the HDD; leaving it in the cache has very =
little
>>> cost and would speed up any reads of that data.
>>=20
>> Maybe you're right, it seems to be writing to the cache, despite it=20=

>> indicating that the cache is at 100% full.
>>=20
>> I noticed that it has excellent reading performance, but the writing=20=

>> performance dropped a lot when the cache was full. It's still a =
higher=20
>> performance than the HDD, but much lower than it is when it's half =
full=20
>> or empty.
>>=20
>> Sequential writing tests with "_fio" now show me 240MB/s of writing,=20=

>> which was already 900MB/s when the cache was still half full. Write=20=

>> latency has also increased. IOPS on random 4K writes are now in the =
5K=20
>> range. It was 16K with half used cache. At random 4K with Ioping,=20
>> latency went up. With half cache it was 500us. It is now 945us.
>>=20
>> For reading, nothing has changed.
>>=20
>> However, for systems where writing time is critical, it makes a=20
>> significant difference. If possible I would like to always keep it =
with=20
>> a reasonable amount of empty space, to improve writing responses. =
Reduce=20
>> 4K latency, mostly. Even if it were for me to program a script in=20
>> crontab or something like that, so that during the night or something=20=

>> like that the system executes a command for it to clear a percentage =
of=20
>> the cache (about 30% for example) that has been unused for the =
longest=20
>> time . This would possibly make the cache more efficient on writes as=20=

>> well.
>=20
> That is an intersting idea since it saves latency. Keeping a few =
unused=20
> ready to go would prevent GC during a cached write.=20
>=20

Currently there are around 10% reserved already, if dirty data exceeds =
the threshold further writing will go into backing device directly.

Reserve more space doesn=E2=80=99t change too much, if there are always =
busy write request arriving. For occupied clean cache space, I tested =
years ago, the space can be shrunk very fast and it won=E2=80=99t be a =
performance bottleneck. If the situation changes now, please inform me.

> Coly, would this be an easy feature to add?
>=20

To make it, the change won=E2=80=99t be complexed. But I don=E2=80=99t =
feel it may solve the original writing performance issue when space is =
almost full. In the code we already have similar lists to hold available =
buckets for future data/metadata allocation. But if the lists are empty, =
there is still time required to do the dirty writeback and garbage =
collection if necessary.

> Bcache would need a `cache_min_free` tunable that would =
(asynchronously)=20
> free the least recently used buckets that are not dirty.
>=20

For clean cache space, it has been already. This is very fast to shrink =
clean cache space, I did a test 2 years ago, it was just not more than =
10 seconds to reclaim around 1TB+ clean cache space. I guess the time =
might be much less, because reading the information from priorities file =
also takes time.



Coly Li


