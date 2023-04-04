Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288EB6D6E08
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Apr 2023 22:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbjDDU3J (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Apr 2023 16:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjDDU3I (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Apr 2023 16:29:08 -0400
Received: from sonic308-2.consmr.mail.bf2.yahoo.com (sonic308-2.consmr.mail.bf2.yahoo.com [74.6.130.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA5D49EB
        for <linux-bcache@vger.kernel.org>; Tue,  4 Apr 2023 13:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680640144; bh=OCFchnKheLmiYO4m5Qf4vE4rNTt93FZnIFD9qfTrV5Q=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=Un+MnTdD4FvNo+/1ON4OIL+Ylk9HpJFStHqHGsKAs7uMB70QexiFMcYNlRXgxLz9IMz+871whkZRCUw+D7PLw18b2Vd3VCDEsqy5uU3JRKfOhPN3uBgQfLAi/DxI8WTPlNbArpMgd7VKcQXQHf8IqaUD/nTCPCsBD3Bnp540dool5wjRIEvJ4LyJwyiX+9t/ANTl9RtTZ0w+hTWqaZHHYL9vI6h9/qnkb3ous6oDkrQeNepA1lcrVCiMayQfF5sIDnZ4VdLoBK2xhBL8gGrAH3dgpshzFlG/DAlZi/r1/4GQ1MI8g6AjAqnO7ETvmkLc440uipsQYFHjFYD7huPcSA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680640144; bh=Q/u3TGLxKSUYxWwg8GYjJdKQ5yB9Yfn/H0pe//i+7Bh=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=AhjDHhNox02bMvXzEDycUYG8eqUovhVBvkjTqyxFYVxAhsDvd12HrkHGbwyKte54GEOLm1dR82JdmzQOcOz+N992RTTVm8AGavMrKGTz1jLIXnjL2ZrSsP4lOrqIAPDGSwIqBLcskosjmTcCEyjXp/fVS8BmPbbwTtg4RfNM96TLxrHtiE5m6g9Lk9Vyb2sfPmA6L2HOv7+A4GpHiHJ4xLhVWX+oHq9opbRPj3NCurGJZnrOu41o8rWByint+9amalOy/zVks7kGZXMZF943mZRTUeqf1rFrWrWdJwjUuH7XoV8FQPPN+9j7dw+k0EJepAeUzZLQYfzVTFOMJEx1fg==
X-YMail-OSG: r5g8CGYVM1n_ma4ufq7GqJYuqYFDjDc9Z1fVYdyAc2hf15isjEyKGPx2KGhk_oF
 MxYgex5d1yBWb48qa_5BvKNK72czIkLHPwkQSee015ySYdAxsBafnQXXyFK.PmXHkZ5lG1fzMpqQ
 PXRQNIe4t30ndfhgefeWsd1bIrtf.0xQo58PchapdhVl8Zb8ECxw0s97VbrMJCW_OlXQr__TRNzo
 ILbYukoKJsCzlayj4RT3tNo1EUMoJHPWfqKVE1W5MUkssYZuwx5fvkMV8KLVJb5KV2I4r.iQG8fv
 nnQmjwWlgMd4wnaH4E8xpWlhZ2EF47_Bs7cx.68dlA1vPUFuFGwfxxY6kT8_xtamD_gtmRvN8MYD
 .7luJgmPL4Gr3VbJ_tBmiwSdDz1NTPuwRoWkhZI2rjxDqraolMwyskF2cTRgPNUeHV_FiT1kwIKd
 DKEzxcTK6sAeYkjFAh3zeyrm2pOH.PofIy7QMEuV9149yP.Hn.Odx9oJZBC_cENvWgOjR63Ulxxf
 XCxA8UcSJdbOIaXovfDqZDB_x_TnwVi56G81sNV0qdSQWZpxvg1Klp0KAnASjZRGETeuKN5F1YPd
 Cqx8cgkuarIhMU2wS77BvnCyshLFdqnJJMuENdayzphbvSezWO3oZW5uwGzGK6XSaeFoZXMOohyh
 UcNomfnqOta_ETRUlUNRbgduGHs.097aoUAMz3YO_pLTZnJzWEVID58f8S57rB4QadmsIoJO_KGo
 6bRGXWxsNVgfu6qVi24TpSMkHnlHiMqGKSGLWw6.v9u4uLmE91h5w6x9AoEjmI7AWCPujVQ3Ws8w
 mma3chxsupfAZ_y2jsIo8_Dryeh0s1flLcEcYn8REEehavrW.DY8tZMRumuBYYtTzjFEHSTZYfUI
 UWZR12JzOh2HPA7i7amXd0TADXuSWP39Tq0XjAYrSgThD3PJBXyP7J_LkxeseXWzT6HrDvL9p6Pq
 OZURZq2YT.W_fRbpkxDaRWEkssBTBPLt4.j1HoY8ehQItEyTjIp3Auc5wZkV9bvvulU8v6gN5o5F
 oHZhSqHExrLXtf6YW2FRSEyhw4T0wOoFcc75wPMst9Y7QO0o0IMqqlFEv59Y2U.2C9yzPZlpduKn
 RcmZL_sQMfZA8kEXikYGn7FcOraTJcL2U3QPIZjS7Ixd2jf7qg9jm35eIrAs0fLgM.5tdmLdIYud
 GmHtTqSUHGdFLkvR6BkZeaoWVu0N_tzrfdhmqlLIBIw.iAJvd81JvhdEssus4W1cIrhmiZwPMPk.
 HDvfSfOV.AEdZ50JUdY61uzqWSLOn4tL_bfM9buPrNi3gx0VKev2eZR20ZDWO9L2E4yrfBEyswUc
 C3.Ge6jp1VnyZfbtOBNOTe13_QNslKhrxg3W5T5d0E4YMW1LXJ7hl_IOpjmMSHVr9JzN1Jy8MSeT
 qUfkj7a9lOnNtJ9sRh4wfOKFvIMxO4qKYpVBQ1a_jukcLjxDDo_disHPcQ3AiTRLURq6rSXCbOCc
 tvB6saF_nXWnqN3ayGPrgJE6peP._PSjz.5.LzNdMYPydOIptSvQibGtSVcLm4Fyci0zdnHOsRw0
 boXfY9ISUaUzwBP.JNuqW_aOY1jhLsK4rB_2pLtPR2WKuMXjiT4BQxANB7WqzhlDQ3bg6lfeheuE
 wFPlHaB79tz1YIObAj5iHD8RM.Vsz607xeo524syd4BR.n5cDt2OdUsNHteam_SC70Cik1XEC0lA
 _skknFH2sLkk5ufU0ItBv27nxTj8qg5uGaoUuJT05_x66F2RwiCqEl.Xx8um4mjX4EqHf9oWid1I
 15S1jbuDYUZzQgsMqL3HmbsWd3axLu3jfACreqXe3TYbk8t7_BCRDpZTEcCU2Q7IzxkNZ7jT40Hx
 AqylOJaL3_ibdiiQsWc2YGnRZkl3Pbxi3e7Q9r2stRi22VjFihA6meYIb6BE1_skAi5yC8Nt959k
 mnEs_rmJhjFziPhupkj4QoJfEwE.gWKoXOjy.CV77lBmIstD2pGnfCc9f.eVEEJAAuXZElz7ENIl
 UpSBAtYRZMzWmZYEVJ7Vj4hJ1yaLHRpScAwG6mnBwD1N_j99PQkhQRhPflWwtaDGX0NCM0hogU_N
 DzA33idFGEtdVnqfbYP1EBR2XbrsdM94lffacYTCWxD.FgM5BgINU.BZIzWfVK4fYGF18HPD1aCw
 FxHcKnepNV2__xg9zEqDay1Djk3TZXp0IfKoVYmGmN37Pm09jma0SYyb_2VOQf4bPcUUJs_2IMN5
 8TTsZSAQZhbEBbeXNyI3StDPWkeUq1wRHlfHx.ITpY_IgzHizot7cz0miGuawVQ--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 9527562a-7d7d-47d0-82bc-ba75231bae96
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Tue, 4 Apr 2023 20:29:04 +0000
Date:   Tue, 4 Apr 2023 20:29:00 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <1783117292.2943582.1680640140702@mail.yahoo.com>
In-Reply-To: <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21284 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

> It sounds like a large cache size with limit memory cache=20
> for B+tree nodes?

> If the memory is limited and all B+tree nodes in the hot I/O=20
> paths cannot stay in memory, it is possible for such=20
> behavior happens. In this case, shrink the cached data=20
> may deduce the meta data and consequential in-memory=20
> B+tree nodes as well. Yes it may be helpful for such=20
> scenario.

There are several servers (TEN) all with 128 GB of RAM, of which around 100=
GB (on average) are presented by the OS as free. Cache is 594GB in size on =
enterprise NVMe, mass storage is 6TB. The configuration on all is the same.=
 They run Ceph OSD to service a pool of disks accessed by servers (others i=
ncluding themselves).

All show the same behavior.

When they were installed, they did not occupy the entire cache. Throughout =
use, the cache gradually filled up and=C2=A0 never decreased in size. I hav=
e another five servers in=C2=A0 another cluster going the same way. During =
the night=C2=A0 their workload is reduced.

> But what is the I/O pattern here? If all the cache space=20
> occupied by clean data for read request, and write=20
> performance is cared about then. Is this a write tended,=20
> or read tended workload, or mixed?

The workload is greater in writing. Both are important, read and write. But=
 write latency is critical. These are virtual machine disks that are stored=
 on Ceph. Inside we have mixed loads, Windows with terminal service, Linux,=
 including a database where direct write latency is critical.

> As I explained, the re-reclaim has been here already.=20
> But it cannot help too much if busy I/O requests always=20
> coming and writeback and gc threads have no spare=20
> time to perform.

> If coming I/Os exceeds the service capacity of the=20
> cache service window, disappointed requesters can=20
> be expected.

Today, the ten servers have been without I/O operation for at least 24 hour=
s. Nothing has changed, they continue with 100% cache occupancy. I believe =
I should have given time for the GC, no?

> Let=E2=80=99s check whether it is just becasue of insuffecient=20
> memory to hold the hot B+tree node in memory.

Does the bcache configuration have any RAM memory reservation options? Or w=
ould the 100GB of RAM be insufficient for the 594GB of NVMe Cache? For that=
 amount of Cache, how much RAM should I have reserved for bcache? Is there =
any command or parameter I should use to signal bcache that it should reser=
ve this RAM memory? I didn't do anything about this matter. How would I do =
it?

Another question: How do I know if I should trigger a TRIM (discard) for my=
 NVMe with bcache?


Best regards,





Em ter=C3=A7a-feira, 4 de abril de 2023 =C3=A0s 05:20:06 BRT, Coly Li <coly=
li@suse.de> escreveu:=20




> 2023=E5=B9=B44=E6=9C=884=E6=97=A5 03:27=EF=BC=8CEric Wheeler <bcache@list=
s.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Mon, 3 Apr 2023, Coly Li wrote:
>>> 2023=E5=B9=B44=E6=9C=882=E6=97=A5 08:01=EF=BC=8CEric Wheeler <bcache@li=
sts.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On Fri, 31 Mar 2023, Adriano Silva wrote:
>>>> Thank you very much!
>>>>=20
>>>>> I don't know for sure, but I'd think that since 91% of the cache is
>>>>> evictable, writing would just evict some data from the cache (without
>>>>> writing to the HDD, since it's not dirty data) and write to that area=
 of
>>>>> the cache, *not* to the HDD. It wouldn't make sense in many cases to
>>>>> actually remove data from the cache, because then any reads of that d=
ata
>>>>> would have to read from the HDD; leaving it in the cache has very lit=
tle
>>>>> cost and would speed up any reads of that data.
>>>>=20
>>>> Maybe you're right, it seems to be writing to the cache, despite it=20
>>>> indicating that the cache is at 100% full.
>>>>=20
>>>> I noticed that it has excellent reading performance, but the writing=
=20
>>>> performance dropped a lot when the cache was full. It's still a higher=
=20
>>>> performance than the HDD, but much lower than it is when it's half ful=
l=20
>>>> or empty.
>>>>=20
>>>> Sequential writing tests with "_fio" now show me 240MB/s of writing,=
=20
>>>> which was already 900MB/s when the cache was still half full. Write=20
>>>> latency has also increased. IOPS on random 4K writes are now in the 5K=
=20
>>>> range. It was 16K with half used cache. At random 4K with Ioping,=20
>>>> latency went up. With half cache it was 500us. It is now 945us.
>>>>=20
>>>> For reading, nothing has changed.
>>>>=20
>>>> However, for systems where writing time is critical, it makes a=20
>>>> significant difference. If possible I would like to always keep it wit=
h=20
>>>> a reasonable amount of empty space, to improve writing responses. Redu=
ce=20
>>>> 4K latency, mostly. Even if it were for me to program a script in=20
>>>> crontab or something like that, so that during the night or something=
=20
>>>> like that the system executes a command for it to clear a percentage o=
f=20
>>>> the cache (about 30% for example) that has been unused for the longest=
=20
>>>> time . This would possibly make the cache more efficient on writes as=
=20
>>>> well.
>>>=20
>>> That is an intersting idea since it saves latency. Keeping a few unused=
=20
>>> ready to go would prevent GC during a cached write.=20
>>>=20
>>=20
>> Currently there are around 10% reserved already, if dirty data exceeds=
=20
>> the threshold further writing will go into backing device directly.
>=20
> It doesn't sound like he is referring to dirty data.=C2=A0 If I understan=
d=20
> correctly, he means that when the cache is 100% allocated (whether or not=
=20
> anything is dirty) that latency is 2x what it could be compared to when=
=20
> there are unallocated buckets ready for writing (ie, after formatting the=
=20
> cache, but before it fully allocates).=C2=A0 His sequential throughput wa=
s 4x=20
> slower with a 100% allocated cache: 900MB/s at 50% full after a format,=
=20
> but only 240MB/s when the cache buckets are 100% allocated.
>=20

It sounds like a large cache size with limit memory cache for B+tree nodes?

If the memory is limited and all B+tree nodes in the hot I/O paths cannot s=
tay in memory, it is possible for such behavior happens. In this case, shri=
nk the cached data may deduce the meta data and consequential in-memory B+t=
ree nodes as well. Yes it may be helpful for such scenario.

But what is the I/O pattern here? If all the cache space occupied by clean =
data for read request, and write performance is cared about then. Is this a=
 write tended, or read tended workload, or mixed?

It is suspicious that the meta data I/O to read-in missing B+tree nodes con=
tributes the I/O performance degrade. But this is only a guess from me.


>> Reserve more space doesn=E2=80=99t change too much, if there are always =
busy=20
>> write request arriving. For occupied clean cache space, I tested years=
=20
>> ago, the space can be shrunk very fast and it won=E2=80=99t be a perform=
ance=20
>> bottleneck. If the situation changes now, please inform me.
>=20
> His performance specs above indicate that 100% occupided but clean cache=
=20
> increases latency (due to release/re-allocate overhead).=C2=A0 The increa=
sed=20
> latency reduces effective throughput.
>=20

Maybe, increase a bit memory may help a lot. But if this is not a server ma=
chine, e.g. laptop, increasing DIMM size might be unfeasible for now days m=
odels.

Let=E2=80=99s check whether the memory is insufficient for this case firstl=
y.


>>> Coly, would this be an easy feature to add?
>>=20
>> To make it, the change won=E2=80=99t be complexed. But I don=E2=80=99t f=
eel it may solve=20
>> the original writing performance issue when space is almost full. In the=
=20
>> code we already have similar lists to hold available buckets for future=
=20
>> data/metadata allocation.
>=20
> Questions:=20
>=20
> - Right after a cache is formated and attached to a bcache volume, which=
=20
>=C2=A0 list contains the buckets that have never been used?

All buckets on cache are allocated in sequential-like order, no such dedica=
te list to track never-used buckets. There are arrays to trace the buckets =
dirty state and get number, but not for this purpose. Maintain such list is=
 expensive when cache size is large.

>=20
> - Where does bcache insert back onto that list?=C2=A0 Does it?

Even for synchronized bucket invalidate by fifo/lru/random, the selection i=
s decided in run time by heap sort, which is still quite slow. But this is =
on the very slow code path, doesn=E2=80=99t hurt too much. more.


>=20
>> But if the lists are empty, there is still time required to do the dirty=
=20
>> writeback and garbage collection if necessary.
>=20
> True, that code would always remain, no change there.
>=20
>>> Bcache would need a `cache_min_free` tunable that would (asynchronously=
)=20
>>> free the least recently used buckets that are not dirty.
>>=20
>> For clean cache space, it has been already.
>=20
> I'm not sure what you mean by "it has been already" - do you mean this is=
=20
> already implemented?=C2=A0 If so, what/where is the sysfs tunable (or=20
> hard-coded min-free-buckets value) ?

For read request, gc thread is still waken up time to time. See the code pa=
th,

cached_dev_read_done_bh() =3D=3D> cached_dev_read_done() =3D=3D> bch_data_i=
nsert() =3D=3D> bch_data_insert_start() =3D=3D> wake_up_gc()

When read missed in cache, writing the clean data from backing device into =
cache device still occupies cache space, and default every 1/16 space alloc=
ated/occupied, the gc thread is waken up asynchronously.


>=20
>> This is very fast to shrink clean cache space, I did a test 2 years ago,=
=20
>> it was just not more than 10 seconds to reclaim around 1TB+ clean cache=
=20
>> space. I guess the time might be much less, because reading the=20
>> information from priorities file also takes time.
>=20
> Reclaiming large chunks of cache is probably fast in one shot, but=20
> reclaiming one "clean but allocated" bucket (or even a few buckets) with=
=20
> each WRITE has latency overhead associated with it.=C2=A0 Early reclaim t=
o some=20
> reasonable (configrable) minimum free-space value could hide that latency=
=20
> in many workloads.
>=20

As I explained, the re-reclaim has been here already. But it cannot help to=
o much if busy I/O requests always coming and writeback and gc threads have=
 no spare time to perform.

If coming I/Os exceeds the service capacity of the cache service window, di=
sappointed requesters can be expected.=20


> Long-running bcache volumes are usually 100% allocated, and if freeing=20
> batches of clean buckets is fast, then doing it early would save metadata=
=20
> handling during clean bucket re-allocation for new writes (and maybe=20
> read-promotion, too).

Let=E2=80=99s check whether it is just becasue of insuffecient memory to ho=
ld the hot B+tree node in memory.

Thanks.


Coly Li
