Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968506CF8C8
	for <lists+linux-bcache@lfdr.de>; Thu, 30 Mar 2023 03:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjC3BjG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Mar 2023 21:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3BjF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Mar 2023 21:39:05 -0400
Received: from sonic317-27.consmr.mail.bf2.yahoo.com (sonic317-27.consmr.mail.bf2.yahoo.com [74.6.129.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA874EEB
        for <linux-bcache@vger.kernel.org>; Wed, 29 Mar 2023 18:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680140343; bh=8IUXF4MbNIqIJwKNz1OXRifYChzG/zjp9FL3s4Nnsn0=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=hVq4DfDVipkgBhkKDHgcjIlSMxFLLarjnBuwiuHjgXqI0Ch/fc7HwZN2fKUl6000mG1Fov91bIWdD9flFBFNxVMhn7+XD2OxUjzzD+2G7/MbSUNcRM+JFBLREGvl3r+p9mb41LS/icQazU2SJfs1NFrX1NWWNESnSl4p+AutRqmBASJ2QzIhGczmqBj1oXuSzmcteOQbQtMrhAE/LwlUZn++rZUc+crivBnIbtte8je46AB9ykMmAtbU9Brc5mXiSsz8bErqW4UXfx6jg7uQEwUqFWp5fVHjZswmpFhi5WMVCFpzk+Y6WHSbLxk+/6ZyaT30N63rmewYJFsA6N3zRw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680140343; bh=6+jdTcPo/s+LdSK3rHbM2s2RIg0+IpvpnRTe8xYpR9h=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=e3+JtolGTcasChyvHpbBVK0ArAbLBnoNGacSP1V2Tokl/KZz5yDfGBVsK4Y4uZ6P/mcQLzcZFb7pQTfYa5ktHEbEYCSIJsp+j4suAF6jaE/A1FRaF07piSuLXEKRWbIbdr5MUYRKGiiPBZ51Iw8D62+knrWlTIAhF73Oe/FGvWm4426H0LBrSR5pE+BSFY83FkqylxXgPN+XmEbStFOldxd2TaAUfQdnL5a+eRrf8e+5m2Er6XZ2jLVFh7iRY+crHZqZ4y+3iWHKlBD3reZbV7CYDdhYy/kukq0InvTh5mjP4uYsYuZWhV3n+oigWgsTtg2Wpu7PMCvLZ3Z+K7VEzw==
X-YMail-OSG: mbUwU_YVM1lxZiq79.jmOhJPotZ4_aQ6f.0lKTzU6daNn_txrvGeGVTm98gZ1fc
 IupQCfNlr9qcEfdei2KeGS6wNpjxamYsgfpIIApOmy7q0pCqrkryCmceVnwNY3.4ndV6mD.8Cfp3
 IeYyxF0SzyYn3IL_CVTUWjd2UmvjZjtd3lrgvGlao.vS5UGgtcvgWb.l48WIrHQnUI6bhUmdAYgY
 JhMCnAlKZLpUuakRl9vJjSiUQcKy3.xe6uqIwhd4GApmzNm1pb8P7vhkRo_vqDoWnwTCUwzUfUUW
 bssAVF7SuXWOCH80CH.QvUH_7DOHl8CXJYASDO9DPobY.9OQWSTFwq5oANTygl98t_AeG6rWtAbP
 pee4A9r2Gi7UKJ7E7vN8iODvBUty6Ig5GGr8sGiR.s.MLJSHh0WOL9owMHiB0EHZuujdUtceEVaF
 3xsBbOEcbMcqE_EdY0sMg_GlZUyFVroJ107WxIPfYay7gTEinfVO0RLC7s_faI1rjfJr_ZNuhERI
 4J69kPtEldv_pLXFrOsVm6GVpPWJKK5GoG7RZ_jtdQ1aLrFYkiiWZ7QPYgkufslWqLh9wgr.ZaAX
 gdREOB0dCK.YAkOcM6kbEqpBt7hCbvBFsTlMmRat2g3C64_EVALnHWWLFjfxE8QpD.9CQo5wG_qY
 0N6QJTOcD32GUPoU30TxFi9igsvGH2KRxlxbAAzGO4qeZdwXY0JwD9wMd9nPnZmZaGFYOt2TZVOi
 ire95y6aCPFaX9e4pfovUIePNivDdaM8jtgcYlf4oQ6B_2cKPhuvt4zxRNGJcH5eb0TguxYvAUtg
 _rH9akShL7Or6udXOY8l4INmm_xniFvr570AraFJj0rS3eTD__smtxwlrYkkY6CwgYAdpQGNSsUb
 cqCADEn7vZam.U9YVSK0mNNrtGxn2BgubIclylgzUj4ADlm8ZWm5_3Fm_yJN0pjpVrkak0E.yJd2
 _7.npzQGKjPy9eKOGflqPOiLvHYWbO6hF2CeyersSY309CVoW6hpfR33LVMWueNffWe12dJ1_wVa
 cWsJ9eAf1KxAPUIsh9MU1rsojXnqxgj2uDqeaap3o4Wxkr6.E2EtolsVE.k.gRH5eUMbD.6wZ87R
 23I3MqcsJzsKhnzEq9lRVZvoW8aFMcuiw__4L4e4Fgrjuofgn2VPt3M1pwg40xd6wJ9JNCmf.kae
 1_2jB2Ylv.i_MNDp1Twieu_zl9E50zK5BUbyP5XMC5Src1Tbgg7wqQxHEpLL_8gU9FPre8ngReUd
 VGLEbovh2vc81BJXhiY_3uVYoXpaIHz4NgspMT3RyDfUzUOthjsJxfXnR_0aUD2vTvj9joyS0BIo
 4hHXe01Wa5CjiLXpMn_2kTjA_CH.5laSu1ljBT4kFU3M07CGYdw5tmWtP4olPkB41z5cE8ZXq9FB
 dOuC8kOu0debKsBu1AQZ58x8UdcXsb6WMVb4o8DtjFFqaQsoHe8isRHoTtjDrFs_bJpOa3vhgUE_
 5jo2OLUJ6hBWqXK2BpBVv8nyg.qQXq.krN2Pb9Hl4q1sIRu6MvY491fBMsRwaiWtwgVgNK2Moir9
 X5wdo0emca5R.17CTcy9vsoqgUHUzL1gHpO..MXTvsR6Wmu_nCeJtOss6EVO_XPl.L3IRsIfTTLG
 QljAoSjeGMuGaquLnc4iTbyCL0Vt2uE4zC._rXnrvc19Squ6KDyHDpWLktld.odfJJWJPh0f4sat
 v.islpeRDd4POJclNhw9roomF9Vmnm5Q9UuixyYJ7QE4Xg3CcElcYkz3jF4FCKPCSjFkzkhkW4qI
 e1SnvOuTkqF8HH6Mce.KT1Ne8jarM6_k.nyIRlwp0YCL_4.O0n3tLcs0pYTfO8s7HTPyHx1390nD
 GsctDiU_7m_udVFmRRCYJanfE89WsHL_vMr9OGgHud8tdeJQyIfAfSY31mVVpfeopGZuEWwMWPZX
 XEQJp8n1uXdfAC7X3oLCH5RWbEpPjrqxHyOEMeGQ1pR4fy0syA20g67GVcVKovXAcgsupEeW8UDs
 EmJB5GYp7Jiz_j8AgfQZktdhaF_Gic5FMeGzSTPQpVTOQ2l0Kg56O5kQ0C07TdiPVquX7FJTfaFI
 siexmyjs1u6aJpm1q35VSOnBRJmsq4TPuj4cHm65KO7YLLy7Q1n41ax1Lk8_F.qs12kHhu1V4udk
 c7ENALpzzBNA3i0Qf8uylda5N9Qk_W__sHE_ulhM08HS7kaJuUjpy4ehBhZK18FYzoYWqj3Uqe4N
 MUhPMZDiSb1hnJiJPq79eKPtzzn2rJoCDVBfP5PxgBEXnVZTMFw--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 9fc33148-57a4-49b5-ba88-2c469cb9c690
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Thu, 30 Mar 2023 01:39:03 +0000
Date:   Thu, 30 Mar 2023 01:38:28 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
Message-ID: <1796560585.1518472.1680140308938@mail.yahoo.com>
In-Reply-To: <680c7a6-f9ab-329d-95a8-97b457a634e5@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <680c7a6-f9ab-329d-95a8-97b457a634e5@ewheeler.net>
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

Hello!

I use Kernel version 5.15, the default version of the Proxmox Virtualizatio=
n Environment. I will try to change the kernel as soon as possible.

Is there anything interim I can do to improvise while I can't switch kernel=
 versions?

Strangely, it doesn't reduce cache usage even when the computer is complete=
ly idle, with virtually no disk activity.

Thanks!



Em quarta-feira, 29 de mar=C3=A7o de 2023 =C3=A0s 16:18:39 BRT, Eric Wheele=
r <bcache@lists.ewheeler.net> escreveu:=20





On Wed, 29 Mar 2023, Adriano Silva wrote:

> Hey guys,
>=20
> I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device=
=20
> each consisting of an HDD block device and an NVMe cache. But I am=20
> noticing what I consider to be a problem: My cache is 100% used even=20
> though I still have 80% of the space available on my HDD.
>=20
> It is true that there is more data written than would fit in the cache.=
=20
> However, I imagine that most of them should only be on the HDD and not=20
> in the cache, as they are cold data, almost never used.
>=20
> I noticed that there was a significant drop in performance on the disks=
=20
> (writes) and went to check. Benchmark tests confirmed this. Then I=20
> noticed that there was 100% cache full and 85% cache evictable. There=20
> was a bit of dirty cache. I found an internet message talking about the=
=20
> garbage collector, so I tried the following:
>=20
> echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc

What kernel version are you running?=C2=A0 There are some gc cache fixes ou=
t=20
there, about v5.18 IIRC, that might help things.

--
Eric Wheeler




>=20
> That doesn't seem to have helped.
>=20
> Then I collected the following data:
>=20
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
> =C2=A0=C2=A0 Device /dev/nvme0n1p1 (259:1)
> =C2=A0=C2=A0 Size 553.31GiB
> =C2=A0=C2=A0 Block Size 4.00KiB
> =C2=A0=C2=A0 Bucket Size 256.00KiB
> =C2=A0=C2=A0 Replacement Policy [lru] fifo random
> =C2=A0=C2=A0 Discard? False
> =C2=A0=C2=A0 I/O Errors 0
> =C2=A0=C2=A0 Metadata Written 395.00GiB
> =C2=A0=C2=A0 Data Written 1.50 TiB
> =C2=A0=C2=A0 Buckets 2266376
> =C2=A0=C2=A0 Cache Used 547.78GiB (99%)
> =C2=A0=C2=A0 Cache Unused 5.53GiB (0%)
> --- Backing Device ---
> =C2=A0=C2=A0 Device /dev/sdc (8:32)
> =C2=A0=C2=A0 Size 5.46TiB
> =C2=A0=C2=A0 Cache Mode writethrough [writeback] writearound none
> =C2=A0=C2=A0 Readhead
> =C2=A0=C2=A0 Sequential Cutoff 0B
> =C2=A0=C2=A0 Sequential merge? False
> =C2=A0=C2=A0 state clean
> =C2=A0=C2=A0 Writeback? true
> =C2=A0=C2=A0 Dirty Data 0B
> =C2=A0=C2=A0 Total Hits 32903077 (99%)
> =C2=A0=C2=A0 Total Missions 185029
> =C2=A0=C2=A0 Total Bypass Hits 6203 (100%)
> =C2=A0=C2=A0 Total Bypass Misses 0
> =C2=A0=C2=A0 Total Bypassed 59.20MiB
>=20
> The dirty data has disappeared. But the cache remains 99% utilization, do=
wn just 1%. Already the evictable cache increased to 91%!
>=20
> The impression I have is that this harms the write cache. That is, if I n=
eed to write again, the data goes straight to the HDD disks, as there is no=
 space available in the Cache.
>=20
> Shouldn't bcache remove the least used part of the cache?
>=20
> Does anyone know why this isn't happening?
>=20
> I may be talking nonsense, but isn't there a way to tell bcache to keep a=
 write-free space rate in the cache automatically? Or even if it was manual=
ly by some command that I would trigger at low disk access times?
>=20
> Thanks!
>=20
