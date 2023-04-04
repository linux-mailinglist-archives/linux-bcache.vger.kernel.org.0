Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BF66D5AA0
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Apr 2023 10:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234020AbjDDIUI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Apr 2023 04:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjDDIUH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Apr 2023 04:20:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD996193
        for <linux-bcache@vger.kernel.org>; Tue,  4 Apr 2023 01:20:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D077D2045E;
        Tue,  4 Apr 2023 08:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680596403; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05vGWwZTeL+pTid8Hru+8Vf/nETVGSoMfJsKOTrgnBw=;
        b=TyQUFeovzKdaQuRryGqgnX84PLeFO6CCsF+07xR4fEbhT8MKIpgjh2jdbU4O/qTITqU8Vr
        /1/Ziy1c1Som6/7ZDKzNz/Dq+XTbjd7ij5T3rqLAeplxftbji9p9wHA03gc5IrVM3N7HPx
        ygy9QHvzrT5+8m4bfgt0ymOpHAFvfwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680596403;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05vGWwZTeL+pTid8Hru+8Vf/nETVGSoMfJsKOTrgnBw=;
        b=t1+SkoSWaDRvQ7dgrUxZbAsb41mrO5yWZUkV8gtTgLkJBFpgmhf+HoU5PPq8Bkhg8AjOW7
        37dDnZOweWDMU0Cg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DFCC13920;
        Tue,  4 Apr 2023 08:20:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pc8RG7LdK2TWDgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 04 Apr 2023 08:20:02 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: Writeback cache all used.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
Date:   Tue, 4 Apr 2023 16:19:50 +0800
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>,
        Adriano Silva <adriano_da_silva@yahoo.com.br>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
 <1012241948.1268315.1680082721600@mail.yahoo.com>
 <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
 <1121771993.1793905.1680221827127@mail.yahoo.com>
 <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net>
 <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de>
 <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net>
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



> 2023=E5=B9=B44=E6=9C=884=E6=97=A5 03:27=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, 3 Apr 2023, Coly Li wrote:
>>> 2023=E5=B9=B44=E6=9C=882=E6=97=A5 08:01=EF=BC=8CEric Wheeler =
<bcache@lists.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Fri, 31 Mar 2023, Adriano Silva wrote:
>>>> Thank you very much!
>>>>=20
>>>>> I don't know for sure, but I'd think that since 91% of the cache =
is
>>>>> evictable, writing would just evict some data from the cache =
(without
>>>>> writing to the HDD, since it's not dirty data) and write to that =
area of
>>>>> the cache, *not* to the HDD. It wouldn't make sense in many cases =
to
>>>>> actually remove data from the cache, because then any reads of =
that data
>>>>> would have to read from the HDD; leaving it in the cache has very =
little
>>>>> cost and would speed up any reads of that data.
>>>>=20
>>>> Maybe you're right, it seems to be writing to the cache, despite it=20=

>>>> indicating that the cache is at 100% full.
>>>>=20
>>>> I noticed that it has excellent reading performance, but the =
writing=20
>>>> performance dropped a lot when the cache was full. It's still a =
higher=20
>>>> performance than the HDD, but much lower than it is when it's half =
full=20
>>>> or empty.
>>>>=20
>>>> Sequential writing tests with "_fio" now show me 240MB/s of =
writing,=20
>>>> which was already 900MB/s when the cache was still half full. Write=20=

>>>> latency has also increased. IOPS on random 4K writes are now in the =
5K=20
>>>> range. It was 16K with half used cache. At random 4K with Ioping,=20=

>>>> latency went up. With half cache it was 500us. It is now 945us.
>>>>=20
>>>> For reading, nothing has changed.
>>>>=20
>>>> However, for systems where writing time is critical, it makes a=20
>>>> significant difference. If possible I would like to always keep it =
with=20
>>>> a reasonable amount of empty space, to improve writing responses. =
Reduce=20
>>>> 4K latency, mostly. Even if it were for me to program a script in=20=

>>>> crontab or something like that, so that during the night or =
something=20
>>>> like that the system executes a command for it to clear a =
percentage of=20
>>>> the cache (about 30% for example) that has been unused for the =
longest=20
>>>> time . This would possibly make the cache more efficient on writes =
as=20
>>>> well.
>>>=20
>>> That is an intersting idea since it saves latency. Keeping a few =
unused=20
>>> ready to go would prevent GC during a cached write.=20
>>>=20
>>=20
>> Currently there are around 10% reserved already, if dirty data =
exceeds=20
>> the threshold further writing will go into backing device directly.
>=20
> It doesn't sound like he is referring to dirty data.  If I understand=20=

> correctly, he means that when the cache is 100% allocated (whether or =
not=20
> anything is dirty) that latency is 2x what it could be compared to =
when=20
> there are unallocated buckets ready for writing (ie, after formatting =
the=20
> cache, but before it fully allocates).  His sequential throughput was =
4x=20
> slower with a 100% allocated cache: 900MB/s at 50% full after a =
format,=20
> but only 240MB/s when the cache buckets are 100% allocated.
>=20

It sounds like a large cache size with limit memory cache for B+tree =
nodes?

If the memory is limited and all B+tree nodes in the hot I/O paths =
cannot stay in memory, it is possible for such behavior happens. In this =
case, shrink the cached data may deduce the meta data and consequential =
in-memory B+tree nodes as well. Yes it may be helpful for such scenario.

But what is the I/O pattern here? If all the cache space occupied by =
clean data for read request, and write performance is cared about then. =
Is this a write tended, or read tended workload, or mixed?

It is suspicious that the meta data I/O to read-in missing B+tree nodes =
contributes the I/O performance degrade. But this is only a guess from =
me.


>> Reserve more space doesn=E2=80=99t change too much, if there are =
always busy=20
>> write request arriving. For occupied clean cache space, I tested =
years=20
>> ago, the space can be shrunk very fast and it won=E2=80=99t be a =
performance=20
>> bottleneck. If the situation changes now, please inform me.
>=20
> His performance specs above indicate that 100% occupided but clean =
cache=20
> increases latency (due to release/re-allocate overhead).  The =
increased=20
> latency reduces effective throughput.
>=20

Maybe, increase a bit memory may help a lot. But if this is not a server =
machine, e.g. laptop, increasing DIMM size might be unfeasible for now =
days models.

Let=E2=80=99s check whether the memory is insufficient for this case =
firstly.


>>> Coly, would this be an easy feature to add?
>>=20
>> To make it, the change won=E2=80=99t be complexed. But I don=E2=80=99t =
feel it may solve=20
>> the original writing performance issue when space is almost full. In =
the=20
>> code we already have similar lists to hold available buckets for =
future=20
>> data/metadata allocation.
>=20
> Questions:=20
>=20
> - Right after a cache is formated and attached to a bcache volume, =
which=20
>  list contains the buckets that have never been used?

All buckets on cache are allocated in sequential-like order, no such =
dedicate list to track never-used buckets. There are arrays to trace the =
buckets dirty state and get number, but not for this purpose. Maintain =
such list is expensive when cache size is large.

>=20
> - Where does bcache insert back onto that list?  Does it?

Even for synchronized bucket invalidate by fifo/lru/random, the =
selection is decided in run time by heap sort, which is still quite =
slow. But this is on the very slow code path, doesn=E2=80=99t hurt too =
much. more.


>=20
>> But if the lists are empty, there is still time required to do the =
dirty=20
>> writeback and garbage collection if necessary.
>=20
> True, that code would always remain, no change there.
>=20
>>> Bcache would need a `cache_min_free` tunable that would =
(asynchronously)=20
>>> free the least recently used buckets that are not dirty.
>>=20
>> For clean cache space, it has been already.
>=20
> I'm not sure what you mean by "it has been already" - do you mean this =
is=20
> already implemented?  If so, what/where is the sysfs tunable (or=20
> hard-coded min-free-buckets value) ?

For read request, gc thread is still waken up time to time. See the code =
path,

cached_dev_read_done_bh() =3D=3D> cached_dev_read_done() =3D=3D> =
bch_data_insert() =3D=3D> bch_data_insert_start() =3D=3D> wake_up_gc()

When read missed in cache, writing the clean data from backing device =
into cache device still occupies cache space, and default every 1/16 =
space allocated/occupied, the gc thread is waken up asynchronously.


>=20
>> This is very fast to shrink clean cache space, I did a test 2 years =
ago,=20
>> it was just not more than 10 seconds to reclaim around 1TB+ clean =
cache=20
>> space. I guess the time might be much less, because reading the=20
>> information from priorities file also takes time.
>=20
> Reclaiming large chunks of cache is probably fast in one shot, but=20
> reclaiming one "clean but allocated" bucket (or even a few buckets) =
with=20
> each WRITE has latency overhead associated with it.  Early reclaim to =
some=20
> reasonable (configrable) minimum free-space value could hide that =
latency=20
> in many workloads.
>=20

As I explained, the re-reclaim has been here already. But it cannot help =
too much if busy I/O requests always coming and writeback and gc threads =
have no spare time to perform.

If coming I/Os exceeds the service capacity of the cache service window, =
disappointed requesters can be expected.=20


> Long-running bcache volumes are usually 100% allocated, and if freeing=20=

> batches of clean buckets is fast, then doing it early would save =
metadata=20
> handling during clean bucket re-allocation for new writes (and maybe=20=

> read-promotion, too).

Let=E2=80=99s check whether it is just becasue of insuffecient memory to =
hold the hot B+tree node in memory.

Thanks.

Coly Li

