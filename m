Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693FD6D13F3
	for <lists+linux-bcache@lfdr.de>; Fri, 31 Mar 2023 02:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCaAUQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 Mar 2023 20:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjCaAUP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 Mar 2023 20:20:15 -0400
Received: from sonic320-24.consmr.mail.bf2.yahoo.com (sonic320-24.consmr.mail.bf2.yahoo.com [74.6.128.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF6312065
        for <linux-bcache@vger.kernel.org>; Thu, 30 Mar 2023 17:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680221837; bh=rfIYLLSaBo44DiDOq/tjfRdNR2GLSR68cLk2ZHqLZN8=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=WIezRg0by61bkgbIDHPV+XXgWd+P1PvhpT5t/QauueYMvdikOAQr42o1M2JKEFFO4g3/TdWijxMh2SqobDLlt24nMdfLEEHRNFu8cTJgTe5KRFVZtX1tA1IYfEqzEi5fvsyFg36qoJDviU075CJ1pGU2nlbxNWxx2D7OhJUdsOS/0N28bmeSEHew84x5WXNBUNK3tYgIEzPmqbq3yY64ofrELT7ju/nhep+Ni+gaMvvztDHrA0mBe3g5URy3zjxUqpM7lMMJ1ag9GsYHwzFWBuNHlqfGVwqioYftB4vjpDHls/oSTViZ9pEBF6psiqNVZGjTmppQyNks5s66+G2KKg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680221837; bh=zzsRZHSOtdVOWnLJj7oXEijDZiaoqco/frQGUAt3IXN=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=hSyHNAncj/CqBBarC8X6OsvVvUQBvKrkePXu659msWNkXGiKdmoXYGjAIU134K5bKwsXnwFKXmpAwA7Tyh3RcMquL1ZtV+KbUJMFULlmPziHgEkKkm52qg9HzR95Esh7meK70C6Qnxktg9SlDqeCDR5uhsFU7/MQ2Rzov1SV/HM78ZK0ySowyuetsbJ7O+s/qOI2R6dRwShCnYMK2+x8Palf2ej15KiegTY3IzM9T+VC9cXadfKLjZkln8hpeolHz9uUY0h53N1OukunveWICTKjaSSF6R0x7FETZiUi86AmEz2nVVS08U7lDIIo4CdLFz+mqqY/BRATrlxt7z2D/A==
X-YMail-OSG: pIOdDdQVM1k_9t1Gfiks_fzP7xamHt3qVPnz.hfi_JssLjtdaXihjt9uY1_rJpq
 BAd.l0TzMyTOuvq95GUBfotNGNVQ8UIZwDh6eDcH38SumkRRr40RibCwz56J_Vg4pyIqLlDxwbD2
 qe7nsjJg6SMDZ9oPH9Ejk.8k7L8pCo.xf4_YQ.NbVD3xsToDGU1xEsdJNQy9U2w8kGxgdJEqmXTi
 csmytv9pfb3NteYS42GusGpFNlbA7La8T8FEje2yLhViQSqWESwg6pp6gBVrxWDygmDogOKhf9qU
 b6IG8qH0Y0kEw0RABWVMNbAZLIHx4nTfDqKOt1qYf3E4KiMkAnJ.cz06CgndD3D79E1XVwNSrZBJ
 CyEgIgenD5jjdTaVpEydaGI2DSRmNFXztU6WU3QHBg1c.w84ecZh8QlYqIlJSkYhQA3GrTkEBJRx
 3iokpBLNK1naGwIN9bHUiUJKYAO9SxJy4ZDBtBogJ07v5s4UCHMfHzYhs5C_TqLFkAXgIvzAQB09
 RMSzTJjGa25w4k0hLkRkHWJhbC5gHdh5MTvRvszes66iqaEAaYJ4wjnsUfdayT23lszyaHLrALiA
 KOCQjP8DhC9S6pns10TVzTJVIiGKmxdTqorH.Ln1AEZJETx5ULgznsEoQnjT0l.xKp8vav6y5bV2
 gbMQxHqkHSC8HZeBoLWDS1bJrzRxN1kLA78pqvqjmp.VodfDsdXW0F9rkPHwWaEd.BZZA9i.uxS5
 gNwsE6I_raZAqlq9yfhfSEXR44H8Z_258DYp8fv7sbzcfBgTJi.syzW7XSd3iU7utH_MKyBcIkEF
 muH5NF3JfSUluHft9N2ZlUXvQgNkbw_WL6F2H_EZLcum4KNo88A8VPDTj559ZJq3_4tg73zsKxBQ
 7aApjDVBCFVXFG2VQPzAnZSCu2me1ameBW18unAl4jt7QCnCovtvDa7pT_SAr.TcJAJ97Oga0HQU
 14XiHYgG66aYwHfVcC.6GVolRfUwFPJIjWOCYuNovIjLTX3uKh9IhiC4FVrYeEV4R8KKfCcZX2jE
 tVPi09pF3cgmF0gY_XTy6utZmUnMeUKNywsuPYX4svMfsWVpAqMpfpkkE2nsZd415hlNvoogGpdz
 GTrKBejwFAnwdW327GPyK4AcEO0ymVIKxofgRjO3EI1IzywJCruck3dDponKSFbbokG17k_8jr4H
 lyZaKbupzpkRlqqsrwHpdXQW.jGm28FF77GWt7KCwM2jvM80LyuWmoRR9Hhjk85NGIHEUPEWqvre
 Hg8LeAECYcSVftV.gnHIYDmTK_wPsCCoIDsfpeWbFc1gV6G5mOiwSIc1NplBhKzuvtz1h9kJcW5j
 IG.in4eroSpfk5fySvfKlAJM4JQGnMaIwdmmEVUr4D1XNPtigDMgEBZDJ5SjnQ8WpXJvvPlFBhzm
 OTNQ8nlyYWstQ4KEdlagCQkrVE0Pm13ENlF5QPX0KG1TPrDSl1uN4.s8MnxUUuMKJfzeUgqdRwcS
 3aT_X6iBTjg1zexlQmBvkWIpoy..6PtNobwkPWBZcUhLzFMZetBOZ_hwpLCTxgx6CNdJAeeHMYlc
 I0A_mRYUMtdsZvRBKkJPbsazjJRb7gsaGIDikfB8mwlCsmzSEGB.d6irTkGx52fHgvfbgK5FtbDm
 QM0znE1tGHK2lyMOrzkjR1.L7yN3dwn6wO7Xyv5H88iQfybToGhGOHQ47MEpanOzhRJ_OBS9ByRs
 E6PrgxWdyH.jHRoLkXgvA3uX6CfnFTPgXSfxB.QT5eKvuMF3ZT3kgGkdVhXpihuUxdZ8eW1NYsu3
 BZ1nCoHHOCwqmfWV08Myw6oqhZWLAHNLwss9CLrUXGc9DJaCizqJyTLr0a6Hjgk5MIej4GThlybu
 NU54iBQwFPZ8AsbFUNoia78J2bIlzgq3NF9dmk.G7pbfVjpRgLJtT.Q0dkAhI7JSCaiJ5qt3eeqK
 iQgizHv4deVsN0AMPHRHRfqg5pjcgon3YlPxk9hkDoQ9zqmfoy9_s2rmHpV8JTwr1M0b3ZPI8.VH
 ywAtmrxbIIEr1ELgf8gHbALN1k5.Ox5axYLydh4vq4SE1ukW17D88ONwoDFTrAGjJg7HJwKGdn_w
 XvZTQq7HeuXXRizlmv_jfsHS12.FMvXszYa_MlXWticK_wiaNPRAT9Pd1FReGGovQaH6bxuSFpMT
 cKGRrAZfjRx1VlH.erV2jZLT9fECFc6tLJkow1d4qWAlKeAmFA70eryKNwgn2ApzYsNsHkZXXy4G
 QiAwrYtOIf4_inwpo3tztLTtgw19F_dXb1j78sWjk_mAObMYmPg--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: ebc89be2-a9bf-421c-a9ba-7376ec735799
Received: from sonic.gate.mail.ne1.yahoo.com by sonic320.consmr.mail.bf2.yahoo.com with HTTP; Fri, 31 Mar 2023 00:17:17 +0000
Date:   Fri, 31 Mar 2023 00:17:07 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <1121771993.1793905.1680221827127@mail.yahoo.com>
In-Reply-To: <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21284 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thank you very much!

> I don't know for sure, but I'd think that since 91% of the cache is
> evictable, writing would just evict some data from the cache (without
> writing to the HDD, since it's not dirty data) and write to that area of
> the cache, *not* to the HDD. It wouldn't make sense in many cases to
> actually remove data from the cache, because then any reads of that data
> would have to read from the HDD; leaving it in the cache has very little
> cost and would speed up any reads of that data.

Maybe you're right, it seems to be writing to the cache, despite it indicat=
ing that the cache is at 100% full.

I noticed that it has excellent reading performance, but the writing perfor=
mance dropped a lot when the cache was full. It's still a higher performanc=
e than the HDD, but much lower than it is when it's half full or empty.

Sequential writing tests with "_fio" now show me 240MB/s of writing, which =
was already 900MB/s when the cache was still half full. Write latency has a=
lso increased. IOPS on random 4K writes are now in the 5K range. It was 16K=
 with half used cache. At random 4K with Ioping, latency went up. With half=
 cache it was 500us. It is now 945us.

For reading, nothing has changed.

However, for systems where writing time is critical, it makes a significant=
 difference. If possible I would like to always keep it with a reasonable a=
mount of empty space, to improve writing responses. Reduce 4K latency, most=
ly. Even if it were for me to program a script in crontab or something like=
 that, so that during the night or something like that the system executes =
a command for it to clear a percentage of the cache (about 30% for example)=
 that has been unused for the longest time . This would possibly make the c=
ache more efficient on writes as well.

If anyone knows a solution, thanks!



On 3/29/23 02:38, Adriano Silva wrote:
> Hey guys,
>
> I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device =
each consisting of an HDD block device and an NVMe cache. But I am noticing=
 what I consider to be a problem: My cache is 100% used even though I still=
 have 80% of the space available on my HDD.
>
> It is true that there is more data written than would fit in the cache. H=
owever, I imagine that most of them should only be on the HDD and not in th=
e cache, as they are cold data, almost never used.
>
> I noticed that there was a significant drop in performance on the disks (=
writes) and went to check. Benchmark tests confirmed this. Then I noticed t=
hat there was 100% cache full and 85% cache evictable. There was a bit of d=
irty cache. I found an internet message talking about the garbage collector=
, so I tried the following:
>
> echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc
>
> That doesn't seem to have helped.
>
> Then I collected the following data:
>
> --- bcache ---
> Device /dev/sdc (8:32)
> UUID 38e81dff-a7c9-449f-9ddd-182128a19b69
> Block Size 4.00KiB
> Bucket Size 256.00KiB
> Congested? False
> Read Congestion 0.0ms
> Write Congestion 0.0ms
> Total Cache Size 553.31GiB
> Total Cache Used 547.78GiB (99%)
> Total Unused Cache 5.53GiB (1%)
> Dirty Data 0B (0%)
> Evictable Cache 503.52GiB (91%)
> Replacement Policy [lru] fifo random
> Cache Mode writethrough [writeback] writearound none
> Total Hits 33361829 (99%)
> Total Missions 185029
> Total Bypass Hits 6203 (100%)
> Total Bypass Misses 0
> Total Bypassed 59.20MiB
> --- Cache Device ---
>=C2=A0 =C2=A0=C2=A0 Device /dev/nvme0n1p1 (259:1)
>=C2=A0 =C2=A0=C2=A0 Size 553.31GiB
>=C2=A0 =C2=A0=C2=A0 Block Size 4.00KiB
>=C2=A0 =C2=A0=C2=A0 Bucket Size 256.00KiB
>=C2=A0 =C2=A0=C2=A0 Replacement Policy [lru] fifo random
>=C2=A0 =C2=A0=C2=A0 Discard? False
>=C2=A0 =C2=A0=C2=A0 I/O Errors 0
>=C2=A0 =C2=A0=C2=A0 Metadata Written 395.00GiB
>=C2=A0 =C2=A0=C2=A0 Data Written 1.50 TiB
>=C2=A0 =C2=A0=C2=A0 Buckets 2266376
>=C2=A0 =C2=A0=C2=A0 Cache Used 547.78GiB (99%)
>=C2=A0 =C2=A0=C2=A0 Cache Unused 5.53GiB (0%)
> --- Backing Device ---
>=C2=A0 =C2=A0=C2=A0 Device /dev/sdc (8:32)
>=C2=A0 =C2=A0=C2=A0 Size 5.46TiB
>=C2=A0 =C2=A0=C2=A0 Cache Mode writethrough [writeback] writearound none
>=C2=A0 =C2=A0=C2=A0 Readhead
>=C2=A0 =C2=A0=C2=A0 Sequential Cutoff 0B
>=C2=A0 =C2=A0=C2=A0 Sequential merge? False
>=C2=A0 =C2=A0=C2=A0 state clean
>=C2=A0 =C2=A0=C2=A0 Writeback? true
>=C2=A0 =C2=A0=C2=A0 Dirty Data 0B
>=C2=A0 =C2=A0=C2=A0 Total Hits 32903077 (99%)
>=C2=A0 =C2=A0=C2=A0 Total Missions 185029
>=C2=A0 =C2=A0=C2=A0 Total Bypass Hits 6203 (100%)
>=C2=A0 =C2=A0=C2=A0 Total Bypass Misses 0
>=C2=A0 =C2=A0=C2=A0 Total Bypassed 59.20MiB
>
> The dirty data has disappeared. But the cache remains 99% utilization, do=
wn just 1%. Already the evictable cache increased to 91%!
>
> The impression I have is that this harms the write cache. That is, if I n=
eed to write again, the data goes straight to the HDD disks, as there is no=
 space available in the Cache.
>
> Shouldn't bcache remove the least used part of the cache?

I don't know for sure, but I'd think that since 91% of the cache is=20
evictable, writing would just evict some data from the cache (without=20
writing to the HDD, since it's not dirty data) and write to that area of=20
the cache, *not* to the HDD. It wouldn't make sense in many cases to=20
actually remove data from the cache, because then any reads of that data=20
would have to read from the HDD; leaving it in the cache has very little=20
cost and would speed up any reads of that data.

Regards,
-Martin


>
> Does anyone know why this isn't happening?
>
> I may be talking nonsense, but isn't there a way to tell bcache to keep a=
 write-free space rate in the cache automatically? Or even if it was manual=
ly by some command that I would trigger at low disk access times?
>
> Thanks!

