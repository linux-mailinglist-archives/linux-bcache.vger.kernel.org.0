Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31BC6FBD13
	for <lists+linux-bcache@lfdr.de>; Tue,  9 May 2023 04:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjEICVp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 May 2023 22:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234213AbjEICVo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 May 2023 22:21:44 -0400
Received: from sonic301-1.consmr.mail.bf2.yahoo.com (sonic301-1.consmr.mail.bf2.yahoo.com [74.6.129.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EBCAA5F8
        for <linux-bcache@vger.kernel.org>; Mon,  8 May 2023 19:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1683598900; bh=abhXS+zpBrq7Qj9nD/tYv69IapRH00TazNY4dxKpUBo=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=sQvKlzQOaYNxejTiLRXmBh1E1JkjlJw0yLEItKOld3xizeh2m1G8AmgzsS0j28YKVm0CjXmi3nMhJbV8JOkPsPtZGoa6/WOHwhLmhLFw0ovFTsLyREPvg8pc6LA1Y4xMJEfdQI4JwQD7TEb7wTV/j8Hw0UWHMeByn916MBRJA3lDSHBpFXQ+MeQU6PuM89ixLhUdPfD+J6pUl98wuo9ueB7QeU+/T/mhE0+tT+QIkmj12C8BIcSk22mf/Bn+aIn8Im2O4hBdQZG1RTg9vjqVM156/wJVBq7RSMBaxsJMIbh7OeaFZ/29jguNjOezpHCKK8jB5NKGHtFloG/bduwp5g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1683598900; bh=fuYmuijv2V/Qn6VRlDdEh/AvzXXkGu3h85juZbkzaLe=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=YHfTD2po2h9qrxKCG6XOOjgYl+qzi4eJDb353Sr0ple4KPMl7c4MmI38HjFmWZ4DeCqxgG6mOhmPmenfBFePsaSX74nYBORiEhDIhOIaxYb5LJr0Pb749PXSvamUCZ9AC8a1IBAl/5qkblyamWt1uHoW8HhFKkn1FYiKblp+NgT5kKXgz5lumbyYVGMJvYyge/IqlY6Bqg8pSz2GqDZmyglwZXqejIpTdNp2cwUMEi34rauXnZgsHCCqIFYrsdeJTZb0RcZKRJr+G8JxfFSYhQR/LSkI6p7bcYV2aPY6QbM5syvFJwqZsWiQYvt9wRR8lUrgSmNOoAdtnfamyUyhvw==
X-YMail-OSG: YmWSG28VM1nExGP5hw0kb8hZbdTs2Llqd8tpI4L.PSisz_hM4LFTxm01pq_jNjc
 DjgQ1mANF_kLSon9.jhoaVBwnU1_1YSFuBU8gF1VFh2ea1QI4xXV8vFF6UysBebIJmDyVRBUAwuI
 suF8ZraoWNm71rhQxr23fzT4QZcp_SEAteizupEz01cdG5k5gW8f7RzIBmJK41DqI6HOELm.f9EH
 FroVizHyI41Gkd577dIEWUznYu5g3UM6VjP.H978gN8sRkvXhdqDxnKAR_FCo7EuiybfIxZJuNeh
 tqfOD1btU8ZmJCAq79L9NkjDRqS0T3l2WQDL4fcktkcQ9zWJ45DUPnogv0H_Y_xSXjJ4p1H8Ftf9
 oWVHMwxTV35w1cuAAiGuh8v1z2SVvrXBGuGjV0RCP3eEhPi0nMetI.6kBg82EHL1ZsINJ7mwUKOn
 QvxS46Bo_lK2DZFrjwo5.O.9npmoIMX_IrC68n.bhW7U7hi2Yqh3rCkTVO8P88PX72Sw4vNsl6xu
 Ip7.YTt5DX0V6Mu0Jh5EVOZlZWv9TLFnLJ9fDVFT9O0a47r_RTeA_ufvdCzUw0OCDtt3aYjmczlx
 tSDAnDOHgFND1M7P8nqw1kqGMVBW6q0nSVkzdgz.skLz5yWyHqNqHdmeRO2smY0sakTOBePWG6.9
 UUul7tWoUo_FWiW0qpYUUciPpawFtrEluxXtV.di9OpZRA2ymbjufjpFlfltBtyaDCWin6AvapC1
 jayFDRPZmYh8GjX3CZrhdMw4qD5yKCToMcF.PZz3yBCexlMKteaR9oWYH3VCrXoH29BL0wrgBBBS
 jM6ec8ZeCaYaiY2ZGAUcTfT4b_VEguhgp8dbw9sqSk0uChRpIl0M3Dk74asis8BjnNx8FKvIDpZC
 dXoTlsEtmNTsPdVYClRcll90vS.9WbcCMrkDayOpABuKL0Hfl2u14sMDKyHfAJ1dYXh.8Mqn.fWs
 0qnpbOpskBU4OEwZWyEHSsSTwCLvaWS6KQ75ULH1IU_EUBT6RWivPd_1OOSMf3FysKOygkjQrsSC
 IYuX9MIbnvwfz1_BM_F0FRh9.IBG6NY88W906VTQQiHrvM9HbHVDKtDflCzAxUqMyT7grKmdU236
 Qse9JJlNGvOwlQTQoyPRT9adD24hWTIYQxZwZ7vUni47RPwEOpKIikXC2Bbi5DblwjAD_Cl5l0Qe
 X_wdfZOvAQDDVawSEjDqrOMkQerjtQin_LSknNMkQ7wrUQ1RZK4EQF6bW.dvmnLVlnWNM_lyJUPH
 Br86bxeN6O5Ae.fEshnu2xW34K0.Tg8M8drvXRxBsAkK4Wyzj.FpDMklPAwLR5MCnic5RHFRO.CW
 tTqo6yJ06TSP98JOzaADn564tGscIEL1oU1JNYAUpwyYhh39YX9wmsMLKM40EyOeQ31wJB3ucAkh
 SMLAnc8D1khER.5x4FHVGPj0Ye0Zq43UJlbCDzjTMTuMnLmZpByiKjqnu8JJnJ9pDpcbfbe5dEXI
 CDtUtmvKs8BSt_kIXNP8bbbNHXLwRhD1.cqJ8vBheU80J3kptnXYW1Z2qnrylkhkqK24ewRa.DmY
 vpgzyJmBe_2dk0xw8SC0WAsuP72GOWx61xCSAAEHY_EufXlKgui2dR9m8_AnMd_MtpJkMym.i7__
 DCfz24kZ0snBgKAtY5AzH8GYskivzaYFjs9DMy01rsF5YUVSF.32EOBOfmBIksF1rY8x5Jbu1kAZ
 Gzy0T6XMvLPlSmUUt1aaQJLarOQiJLNVyeg..BGSvfN2smunv3lfwLk7pXaq5mkwr4eqqNYULj4a
 oG1s0.49H6utdYFam7RhcGI0GEDrle1pOSrsuIvVGQRs.uxnkXzLjR_MBoFUa8L9SL.rMLoiZRvz
 NmUoFqSTdsDUCnpEB.E9yWdnBm2Ymgr0v1G7pLNjXzv3KPiLmFlF0GR9ZkA3i9B2_kaEXT3BQJ3z
 oDStSslJBHMBlyN_lKmxnFlOuW8t3m1Kw30YD_9dVBpVN_EKhkCYKOvQwUZFh6Z327Y0615dKdyq
 oCxsvMJ4DIMLyvsWuFfxhfA9w2djVT_Z3iB0a4THKXpYzsEaX5dC8t6S1whvCMwBPGUnbgjwuwK9
 6_LIhveTIX9ynAQqjnbRK9UKvz0CPX2OMir3e9mlXYnstqmtAFsYr0.C8QUP2bw0.3U1ItnX1n92
 xGfVWxhRntgkyQY30e9sBzcLpVkIlP_7Ghzsqt_YbdqiK3PMYv7HihTojSSBa3.ZJUlNsTa575iH
 AhbyWo.A3Mb5KarvP36zaZA3qlBCkfJI5Pf7OqUp39glJieUVrjicRTbaDA--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 9cac7a5c-74c0-4614-9f80-cbac6b1484e8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Tue, 9 May 2023 02:21:40 +0000
Date:   Tue, 9 May 2023 02:21:35 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Coly Li <colyli@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <2050992229.3201284.1683598895474@mail.yahoo.com>
In-Reply-To: <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com> <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de> <29836c81-3388-cf59-99b1-15bbf0eaac@ewheeler.net>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21417 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thanks.Hi Guys,

Eric:

I got the parameters with this script, although I also checked / sys, doing=
 the math everything is right.

https://gist.github.com/damoxc/6267899


Thanks.


Em segunda-feira, 8 de maio de 2023 =C3=A0s 21:42:26 BRT, Eric Wheeler <bca=
che@lists.ewheeler.net> escreveu:=20





On Thu, 4 May 2023, Coly Li wrote:
> > 2023=E5=B9=B45=E6=9C=883=E6=97=A5 04:34=EF=BC=8CEric Wheeler <bcache@li=
sts.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > On Thu, 20 Apr 2023, Adriano Silva wrote:
> >> I continue to investigate the situation. There is actually a performan=
ce=20
> >> gain when the bcache device is only half filled versus full. There is =
a=20
> >> reduction and greater stability in the latency of direct writes and th=
is=20
> >> improves my scenario.
> >=20
> > Hi Coly, have you been able to look at this?
> >=20
> > This sounds like a great optimization and Adriano is in a place to test=
=20
> > this now and report his findings.
> >=20
> > I think you said this should be a simple hack to add early reclaim, so=
=20
> > maybe you can throw a quick patch together (even a rough first-pass wit=
h=20
> > hard-coded reclaim values)
> >=20
> > If we can get back to Adriano quickly then he can test while he has an=
=20
> > easy-to-reproduce environment.=C2=A0 Indeed, this could benefit all bca=
che=20
> > users.
>=20
> My current to-do list on hand is a little bit long. Yes I=E2=80=99d like =
and=20
> plan to do it, but the response time cannot be estimated.

I understand.=C2=A0 Maybe I can put something together if you can provide s=
ome=20
pointers since you are _the_ expert on bcache these days.=C2=A0 Here are a =
few=20
questions:

Q's for Coly:

- It looks like it could be a simple change to bch_allocator_thread().=C2=
=A0=20
=C2=A0 Is this the right place?=20
=C2=A0 https://elixir.bootlin.com/linux/v6.3-rc5/source/drivers/md/bcache/a=
lloc.c#L317
=C2=A0 =C2=A0 - On alloc.c:332
=C2=A0=C2=A0=C2=A0 if (!fifo_pop(&ca->free_inc, bucket))
=C2=A0 =C2=A0 =C2=A0 does it just need to be modified to something like thi=
s:
=C2=A0=C2=A0=C2=A0 if (!fifo_pop(&ca->free_inc, bucket) ||=20
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 total_unused_cache_percent() < 20)
=C2=A0 =C2=A0 =C2=A0 if so, where does bcache store the concept of "Total U=
nused Cache" ?

- If I'm going about it wrong above, then where is the code path in bcache=
=20
=C2=A0 that frees a bucket such that it is completely unused (ie, as it was
=C2=A0 after `make-bcache -C`?)


Q's Adriano:

Where did you get these cache details from your earlier post?=C2=A0 In /sys=
=20
somewhere, probably, but I didn't find them:

=C2=A0=C2=A0=C2=A0 Total Cache Size 553.31GiB
=C2=A0=C2=A0=C2=A0 Total Cache Used 547.78GiB (99%)
=C2=A0=C2=A0=C2=A0 Total Unused Cache 5.53GiB (1%)
=C2=A0=C2=A0=C2=A0 Dirty Data 0B (0%)
=C2=A0=C2=A0=C2=A0 Evictable Cache 503.52GiB (91%)




--
Eric Wheeler



>=20
> Coly Li
>=20
> [snipped]
