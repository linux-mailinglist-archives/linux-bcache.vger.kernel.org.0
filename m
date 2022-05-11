Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C79523378
	for <lists+linux-bcache@lfdr.de>; Wed, 11 May 2022 14:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiEKM5V (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 May 2022 08:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiEKM5T (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 May 2022 08:57:19 -0400
Received: from sonic302-2.consmr.mail.bf2.yahoo.com (sonic302-2.consmr.mail.bf2.yahoo.com [74.6.135.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB31495DE9
        for <linux-bcache@vger.kernel.org>; Wed, 11 May 2022 05:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1652273836; bh=T+z8VQzP19TamUoV0bDVi8ziWPc3EnEGIPxPbxXF5S0=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=mykYRpJ9LWfWd9cYVh5VjNzUgM3RDblQWzE4vlj0ZKW2FEnjYSduwA4nS6RYewakwK0ylYfPsKTtRCHokP6s/hZPuZtOj0dBKiothWFu3NO9tpxtSzAI2DbCcj/T6jNZcVP+zm2YgmrjOfgdVKzUrEL0qdlXJB+OzON4meG5qIdZzm9TkPwHmNo3ZD/SlM17kuO5ypIK2wENa0XUFyHE0fWJXS8EVzeM6IE5HdCFowotAil5hCYXU7xKJK76fvNOOjbZRCxHj3eBxUWT8yUcJPtshT3eR00KDVhr1bb3+TXVeNJnG+/NGvMBqpHREjLkpXtcxpQLmfCKFtDSBja2Yg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1652273836; bh=TAEw5YTW5Dk+dwnatiIdnwI5UHtf6/nm8Xdf8TM7WeQ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=Cpefy6khlDCxqx7fJU7ixpD+xApgVnBNhs5erpMn4E/VbAD4LRsvBjXGA8Y11QZbQZKl1QGJtabdnUkXr69jkwXF9tCbUcF7/ks0mCCSnGjU4v2eFLhJGfIAdvNmRtRa3YSWj7JFaPrl8kbm9r0pr49IFZ/zLAI9wrW0nRoXZH0FCNhX53pYITCXQfW1EyCzeR+kmRGd5krLO3EOx/19vpK0ZOpshk7pOaioDAzKSUUiH3Q5BgVFSOFDEZERO1L1/Lcs3Tx08QIP9Brk+IzCFiP1OKp61I8mibzNeEALkz9vKiPW/c4PbvdPOa4bw9uu0pyJjXh3466E6q0hsEW6qA==
X-YMail-OSG: lILvhiMVM1lTXUCS8oNlm91AjFJA.h3_kiIqFQ2lv2nGPAmoCnBBuqtiX60FGAx
 wriWisMt3CKQvqykKZ0_noRNGGHWhQUM5EyOc3kokE5okIJPYPJ6chZZOXT0Xh3dCQumbK_MD0UE
 z5EpgPqevBc45c3QSSXt3Hxnz_LQnCaFTcB81_8_smYp_BJEDjxr1W8sKrw_KZm0HsTAD_c6LJN0
 U6KLuX856ECtY0Chu0M6jFciTrDSq0jblG0Jx9kBqIR5cDcpEOzDLp4T_jjSdISn8fri3b4AMwUh
 TUBr4myIKLf8P.Eu0X5Y6XLi38BS6UHfKgSezKZVrBK67gCcdCyWVEBDHg.wXKU37x.yAr08c7GU
 6Wy3.tYUfqRdupHdt_D_HuicH9BbKTnd4uxHL1L_TxtVLghqKT3GzYePzfDLkb0D87J__FXecf_C
 0T8chjOe8qswLipLaL18NE22fvbJNBhHt1ZrowE3YDisrbRMAfmrktelIoppnbT6XibHdqB41esT
 hX_YaCZQJX3p84_ogckgp0ILZhYeH7_sgJJcdSbdaNmbZ9qAhi8y76E0lPWTkZJv9vdCoHz3Ma4R
 zniTHqmbISSYvMSGS5NTutzqnzhd9VuAQ6hOSmx4TjTkbRdITleIKH8RHZItENeTK_neGS7JivJT
 6COdiFIXS9xYihJE1bpd3cm7rreW8zA7n1aB1raILZ.Zc.SHvnx6qBfi3nlAb_bPINdCH1hGHITW
 uTkJo4PVeL3BkQ.IbD0rK3CJMfURGzcp5Gq8viadVkifBtL628A2rqaDcJwcS43ljseiFB2wWNbW
 KTqubItZzUQqaxJdlVBudcOdZHkAmOLaXf1h9Xe556CasElHQBRpGYMx.63GlSFPxmtPl49FOjGE
 ZtRCRsv9nSg9.YCerUaYFPGTqYQC71cMf39rwaxK2Jh43U_XbJBMT0zxMzTNVPVL2JNvFEyDO2FX
 yhkNh1pUxPwpJpBbc52npT2eOhpvwieT3qjQ63CecriYIxL5uNWYvs24sOPjmTnBSVWPwp4kzex2
 IBfRyYB2CFGMTv1PD.htzKIu3paD64R3E9lFXm8qixcAQRd6ff__Jek1Wj2EJqv0wpo0gKaGxhkG
 NX3sfcHX.PALs6zmXHkIpw_9U2IcK6xF.7Cxny1aimkWq0u0kCHtr1MUixvZkD4q.DR9li0lTNXb
 NG_plwIXlGXjJw2iHM27HLF2A2t_vPQHs6kygUJAWcTLvU0ONZBbCAc.4JgDi30Trn23SfzukUPU
 w31Ax.rFfWYkZJD4s15HYM4bEgQL4GKytnhNOOTZPguLT3Wy2SrqWWoLyq263wbz5HwtOVoeKxPB
 OwwXJ8Kox0LGWAFJTDH3WCoFD1GvD_WNZK9YGcVSEasnlrBcoO82qtp9T3xlSN0DXE8i0nJ.MlBn
 alLkvx37sktIOCu4Ru4qVYpyGQAfCaVZZqa2yuiFJLKX997d51CF2xYBKDNO596OgeOtCImNWvT3
 c_d0vPekFs_QvVth3_QJbBFt.GqZQaHdnkouxNDIYpVQ_e1Q36PZq9L9gzeQ4SsIqck2Jq97LbIm
 JkhKuLKdEpgB1iqLIjsg8Ccn_BMzaZnI0agZE5hWpeFMHPeI7QC8erg6PHezDjkCxkY.6ayRivqi
 GzAOcIB9tGEIlumQ8Me1O8LG21WtZx_dQtGTo2FgHpWsvjJIJUxgrFXPrO7t6a5lYMCl6QYoFEUY
 e_7JW6vaqzPnun4NFGcAl6OAXLCICWNzlOqWAW72FgSJnKVx5a90zkmMmtM0Y3sbrxEOQFR9CDVk
 f.1oLDvdj3oPOKmGu_8PjxUbGLZrR531IP4ePRjG5sIckAqR9FOOZWOfQdLJ50ElN41CSQ7PfApF
 KiFmEGwrFjMktCydmdev611QsE1e06BIKVLpscKWyTA6d0buAXqCI6Ldt3opsEG6pQt6N3APQ3y6
 lep8oKdrVK1QTEiFkrqR5A6tFNzMIP._.lXAUhAKrb738srK89PYFhyAsWnYyjqxohChHtd7r29a
 w0Iv8JQ5Nx.KXf6GEC2cnGWGH4yhgUwE1vcDRsIwRa9yIbDuSkKALoOT2JikSX0FuO6P_jpxsU8B
 outJwPeQgIotDWRB1UF_ZBERXHV491JzpcbtkOIWZ_ZQI1DquWOecpVxE.dtibqiMkzn98COQlKs
 dED4W9R3rZD4Olpx_S68dJpq9N_2I9AH3LJDN7rzznOsTrJfkhobkHfbFweH8z0SizZqX4UB0Tc0
 SLNa30MPjU18rBfzmRVTPUhpKfq4nP843XVpTsa7V4.dtyzbMiBdTOQQZT.JeJg--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Wed, 11 May 2022 12:57:16 +0000
Date:   Wed, 11 May 2022 12:58:48 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Matthias Ferdinand <bcache@mfedv.net>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Message-ID: <935414163.1122596.1652273928576@mail.yahoo.com>
In-Reply-To: <YntVm0jy5NY8ealB@xoff>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <YntVm0jy5NY8ealB@xoff>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.20188 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Tank you for your answer!

> bcache needs to do a lot of metadata work, resulting in a noticeable
> write amplification. My testing with bcache (some years ago and only with
> SATA SSDs) showed that bcache latency increases a lot with high amounts
> of dirty data

I'm testing with empty devices, no data.

Wouldn't write amplification be noticeable in dstat? Because it doesn't see=
m significant during the tests, since I monitor reads and writes in all dis=
ks in dstat.

> I also found performance to increase slightly when a bcache device
> was created with 4k block size instead of default 512bytes.

Are you talking about changing the block size for the cache device or the b=
acking device?

I tried switching to cache device but bcache gave error when trying to atta=
ch device afterwards. It only worked when I kept the values =E2=80=8B=E2=80=
=8Bas default (512). I was only able, in the creation of the cache, to chan=
ge the value of the bucket to 16K (which is what I found for information ab=
out my NVMe, but I don't even know if it's correct), but unfortunately that=
 didn't change the result of the IOPS or the latency.

> so I used to tune down writeback_percent, usually to 1,
> and used to keep the cache device size low at around 40GB.

I think it must be some fine tuning.

One curious thing I noticed, is that writing is always taking place on the =
flash, never on the spinning disk. This is expected and should give the sam=
e fast response as the flash device. However, this is not what happens when=
 going through bcache.=20

But when I remove the fsync flag in the test with fio, which tells the appl=
ication to wait for the write response, the 4K write happens much faster, r=
eaching 73.6 MB/s and 17k IOPS. This is half the device's performance, but =
it's more than enough for my case. The fsync flag makes no significant diff=
erence to the performance of my flash disk when testing directly on it. The=
 fact that bcache speeds up when the fsync flag is removed makes me believe=
 that bcache is not slow to write, but for some reason, bcache is taking a =
while to respond that the write is complete. I think that should be the poi=
nt!

And without fsync, ioping tests also speed up, albeit less. In this case, I=
 can see that the latency drops to something around 600~700us.

Nothing compared to the 84us obtained when recording directly to the flash =
device (with or without fsync). But it's still much better than the 1.5ms y=
ou get in bcache when you add the fsync flag to wait for the write response=
.

That is, what it looks like is that there is a wait placed by the bcache la=
yer between the write being sent to it, it waiting for the disk response, a=
nd then sending the response to the application. This is increasing latency=
 and consequently reducing performance. I think it must be some fine tuning=
 (or no?).

I think that this tool (bcache) is not used much, at least not in this way,=
 because I'm having difficulties getting feedback on the Internet. I didn't=
 even know where to get help.

In fact, the use of writes in small blocks with fsync and direct flags is n=
ot very common. It is commonly used in database servers and other data cent=
er storage tools that need to make sure that the data is physically written=
 to the device immediately after each operation. The problem is that these =
applications need to guarantee that the writes were actually performed and =
the disk caches are made of volatile memory, which does not guarantee the w=
rite, because a power failure can occur and then the data that was only in =
the cache is lost. That's why the request in each operation that the data b=
e written directly, without going through the cache and that the response c=
omes immediately.

This makes operations very slow in nature.

And everything is even slower when each operation has the small size of onl=
y 4K, for example. That is, for each requested write operation of only 4K, =
an instruction is sent along with it requesting that the data is not stoppe=
d in the disk cache (suspecting that the cache is a volatile memory) and th=
at the data is immediately written, with confirmation being of such recordi=
ng coming from the device afterwards. This significantly increases latency.

And that's why in these environments it is recommended to use RAID cards wi=
th cache and batteries that ignore the direct and fsync instructions, but g=
uarantee data saving, even in cases of power failure precisely because of t=
he batteries.

But still, nowadays with enterprise flash devices, containing tantalum capa=
citors that act as true built-in UPS, RAID arrays, besides being expensive,=
 are no longer considered so fast.

In this sense, flash devices with built-in supercapacitors also work by ign=
oring fsync flags and guaranteeing recording, even in cases of power failur=
e.

Thus, writings on these devices become so fast that it doesn't even seem li=
ke a physical write confirmation request was sent for each operation. The o=
perations are fast for the databases as well as any simple writes that woul=
d naturally occur to the cache of a consumer flash disk.=20

But enterprise data center flash disks are very expensive! So the idea woul=
d be to use spinning disks for write space, but use enterprise datacenter f=
lash disks (NVMe) as cache with bcache. So, theoretically, bcache would div=
ert writes (especially small ones) always directly to the NVMe drive and I =
would benefit from all the low latency, high throughput, and IOPs of the dr=
ive, on most writes and reads.

Unfortunately something is not working out as I imagined. Because something=
 is limiting IOPS and increasing latency a lot.

I think it might be something I'm doing wrong in the configuration. Or some=
 fine tuning I don't know how to do.




Thank you! The search continues. If anyone else can help, I'd appreciate it=
!

Em quarta-feira, 11 de maio de 2022 03:20:18 BRT, Matthias Ferdinand <bcach=
e@mfedv.net> escreveu:=20





On Tue, May 10, 2022 at 04:49:35PM +0000, Adriano Silva wrote:
> As we can see, the same test done on the bcache0 device only got 1548 IOP=
S and that yielded only 6.3 KB/s.
>=20
> This is much more than any spinning HDD could give me, but many times les=
s than the result obtained by NVMe.


Hi,

bcache needs to do a lot of metadata work, resulting in a noticeable
write amplification. My testing with bcache (some years ago and only with
SATA SSDs) showed that bcache latency increases a lot with high amounts
of dirty data, so I used to tune down writeback_percent, usually to 1,
and used to keep the cache device size low at around 40GB.
I also found performance to increase slightly when a bcache device
was created with 4k block size instead of default 512bytes.

Still quite a decrease in iops. Maybe you could monitor with iostat,
it gives those _await columns, there might be some hints.

Matthias


> I've noticed in several tests, varying the amount of jobs or increasing t=
he size of the blocks, that the larger the size of the blocks, the more I a=
pproximate the performance of the physical device to the bcache device. But=
 it always seems that the amount of IOPS is limited to somewhere around 150=
0-1800 IOPS (maximum). By increasing the amount of jobs, I get better resul=
ts and more IOPS, but if you divide the total IOPS by the amount of jobs, y=
ou can see that the IOPS are always limited in the range 1500-1800 per job.
>=20
> The commands used to configure bcache were:
>=20
> # echo writeback > /sys/block/bcache0/bcache/cache_mode
> # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
> ##
> ## Then I tried everything also with the commands below, but there was no=
 improvement.
> ##
> # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
>=20
>=20
> Monitoring with dstat, it is possible to notice that when activating the =
fio command, the writing is all done in the cache device (a second partitio=
n of NVMe), until the end of the test. The spinning disk is only written af=
ter the time has passed and it is possible to see the read on the NVMe and =
the write on the spinning disk (which means the transfer of data in the bac=
kground).
>=20
> --dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -=
net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- as=
ync
> =C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0=
 15m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 ti=
me=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |8462B 8000B|0.03 0.15 0.31|=C2=A0 1=C2=A0=
=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 250=C2=A0=C2=A0 383 |09-05 1=
5:19:47|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :4096B=C2=A0 454k:=C2=A0=C2=A0 0=
=C2=A0=C2=A0 336k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :1.00=C2=A0=C2=
=A0 184 :=C2=A0=C2=A0 0=C2=A0=C2=A0 170 |4566B 4852B|0.03 0.15 0.31|=C2=A0 =
2=C2=A0=C2=A0 2=C2=A0 94=C2=A0=C2=A0 1=C2=A0=C2=A0 0|1277=C2=A0 3470 |09-05=
 15:19:48|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0 8192B:=C2=A0=C2=A0 0=C2=A0 8022k:=C2=A0=C2=A0 0=C2=
=A0 6512k|=C2=A0=C2=A0 0=C2=A0 2.00 :=C2=A0=C2=A0 0=C2=A0 3388 :=C2=A0=C2=
=A0 0=C2=A0 3254 |3261B 2827B|0.11 0.16 0.32|=C2=A0 0=C2=A0=C2=A0 2=C2=A0 9=
3=C2=A0=C2=A0 5=C2=A0=C2=A0 0|4397=C2=A0=C2=A0=C2=A0 16k|09-05 15:19:49|=C2=
=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7310k:=C2=
=A0=C2=A0 0=C2=A0 6460k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3240 :=C2=A0=C2=A0 0=C2=A0 3231 |6773B 6428B|0.11 0.16 0.32|=C2=
=A0 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4190=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:50|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7313k:=C2=
=A0=C2=A0 0=C2=A0 6504k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3252 :=C2=A0=C2=A0 0=C2=A0 3251 |6719B 6201B|0.11 0.16 0.32|=C2=
=A0 0=C2=A0=C2=A0 2=C2=A0 92=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4482=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:51|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7313k:=C2=
=A0=C2=A0 0=C2=A0 6496k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3251 :=C2=A0=C2=A0 0=C2=A0 3250 |4743B 4016B|0.11 0.16 0.32|=C2=
=A0 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4243=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:52|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7329k:=C2=
=A0=C2=A0 0=C2=A0 6496k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3289 :=C2=A0=C2=A0 0=C2=A0 3245 |6107B 6062B|0.11 0.16 0.32|=C2=
=A0 1=C2=A0=C2=A0 1=C2=A0 90=C2=A0=C2=A0 8=C2=A0=C2=A0 0|4706=C2=A0=C2=A0=
=C2=A0 18k|09-05 15:19:53|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5373k:=C2=
=A0=C2=A0 0=C2=A0 4184k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 2946 :=C2=A0=C2=A0 0=C2=A0 2095 |6387B 6062B|0.26 0.19 0.33|=C2=
=A0 0=C2=A0=C2=A0 2=C2=A0 95=C2=A0=C2=A0 4=C2=A0=C2=A0 0|3774=C2=A0=C2=A0=
=C2=A0 12k|09-05 15:19:54|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 6966k:=C2=
=A0=C2=A0 0=C2=A0 5668k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3270 :=C2=A0=C2=A0 0=C2=A0 2834 |7264B 7546B|0.26 0.19 0.33|=C2=
=A0 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 5=C2=A0=C2=A0 0|4214=C2=A0=C2=A0=
=C2=A0 15k|09-05 15:19:55|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7271k:=C2=
=A0=C2=A0 0=C2=A0 6252k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3258 :=C2=A0=C2=A0 0=C2=A0 3126 |5928B 4584B|0.26 0.19 0.33|=C2=
=A0 0=C2=A0=C2=A0 2=C2=A0 93=C2=A0=C2=A0 5=C2=A0=C2=A0 0|4156=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:56|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7419k:=C2=
=A0=C2=A0 0=C2=A0 6504k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 3308 :=C2=A0=C2=A0 0=C2=A0 3251 |5226B 5650B|0.26 0.19 0.33|=C2=
=A0 2=C2=A0=C2=A0 1=C2=A0 91=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4433=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:57|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 6444k:=C2=
=A0=C2=A0 0=C2=A0 5704k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0 2873 :=C2=A0=C2=A0 0=C2=A0 2851 |6494B 8021B|0.26 0.19 0.33|=C2=
=A0 1=C2=A0=C2=A0 1=C2=A0 91=C2=A0=C2=A0 7=C2=A0=C2=A0 0|4352=C2=A0=C2=A0=
=C2=A0 16k|09-05 15:19:58|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |6030B 7204B|0.24 0.19 0.32|=C2=A0 0=C2=A0=
=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 209=C2=A0=C2=A0 279 |09-05 15:19:=
59|=C2=A0=C2=A0 0
