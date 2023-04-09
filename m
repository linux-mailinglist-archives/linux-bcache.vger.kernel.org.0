Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670296DC15B
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Apr 2023 22:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjDIUPQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Apr 2023 16:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDIUPP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Apr 2023 16:15:15 -0400
Received: from sonic305-3.consmr.mail.bf2.yahoo.com (sonic305-3.consmr.mail.bf2.yahoo.com [74.6.133.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0D13598
        for <linux-bcache@vger.kernel.org>; Sun,  9 Apr 2023 13:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1681071312; bh=0dUvSeulfbZqUac4MFsfI4ifB1orWT6XGek2/VI0Ptw=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=AIhFBJ2eNLIboaGlXN/CcLAsnPxSXiSiw7NeTOI4/iP26edcdXCqLOUKT+ScOBbx7XM3tsk/h2OSLDhzcsesva+A/DRbz2+lrzxvP2XJDdpQ2Lb4yfszxqpwDErPF6CmaERS8MFdrOwEnaf3zRQdlgNgGS5+KYnKUN6drxGxZg3u2Xkb/H5OmzKKddJ/gABRLEa+PWhYHRk2KvShAgQXbPqNCgu3WYQQgPW/+qqH9tVL15PAHylq7XovSeMBeYbZsB36enA1zwJno6aH/LjHGRDzXcJwDArkgHSrkjtEb3+OMtKzZT7AGDnkIQD5hzFOA6BS72t9ukl3aDJopesi5Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1681071312; bh=TjHttEgpi+zPENigv23ih/85p405G5298bRObxvb7FE=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=QKwxjLGfSjvkZqvXn7SoppSm6ZND6mQZ4S0UTBryMQE9s+5D3KqY7i6ZcMx/SmPIZqWtTZgczvNR+TQaY1KIGGsxWkwdvDCe6Llc5QeSN0kJ0xX4cqAKeO+hotya+C/aUTC3FfvinkdMPtWVT2Yp0zEkGrIMyLAwVsJJ+UNASGR2i3x3d0l9N3ok43fntO6px/Hh2Gic8pWwpEdx/mLirdfu5ZB7aFz0dkqfxWoxs75Jyzhg8yS3p5YTRa3YLwWpW/ZHVTTmCsD5MO6BS6sRq8bhPyJ8suuMybEgzK/bpapRjQ4saCOnu/srOZYGMs5xDn7E9mFAOk6LT4DA2XCIOA==
X-YMail-OSG: MkoV0LoVM1loKniFKlLBafHsS9XVtmKEKb5Zg2heaPs2nrH_nHpG1FIfkrR20mA
 XR6gtqGSSfskebXBqC4fSODqG_7TF6.J5DIeny7pCyuJ3hUNgRvpCQbpnr7nAgmk8.D7Tm7KQT1r
 JbJ1GwxfyEE6.JCa8Dmh2vJmQi4XgJO3hxOfDIHXNELx6opyjTZvlyxzPSvJCMW5rTCo9fLKqaIP
 ZMDrcAPrCwynWoYtXPt9RDCWNazf8Lj2ICO25Szm8bmzWo9u5zSJlacf1InlgYC7V2.C.O0P2yGe
 UhQSEixOSJcIIUuBOJyYEJpiacDRGMZxCIe3JqiEGiOopkO91s2bK3OhMUYjY9tqwEGt7CfINmaQ
 LBmLcx63yQWcYu9oFrtSB5XxFR_6GFaB6.axdIvJmS1kiP8htTwnlaYiZKNfu655fScdCC35yQm2
 OQzHT7Ikv7TC9s_NSm9JKvUrCSw.LZHxabMSEQSoMb9Ar1NELrG5KJZEbuan3HHwyD2MKKYLt4ra
 Wup_Iu1nPhZZBU5iFdN74jkxE0PG1yms6dmzGtdhm2_6XnTvYG_rhNw_2Jx7EsSUwImb29aA6Y1L
 qMkBECgwWrCEsHgTAugdcD7xEjvo9EQmES2PUzDbFTczEAtT.JT8bgo4.HL2CblyyWnlT3C9aImA
 brfWH.JlkyC9zoaN6AHvITx0mvnBSQCOmYvCRxOATDdfXmwjrquxXTIRN0MjZ__OrlJIHemlonb_
 yfzm8e99DEQupxBqOBdVVWqKoQKUtgAVgwR5h3C8tc2k.LttzQheuZDL5.cdWZaIFB4ShUFHVjJn
 uAzKZqJGl3uBEBe63c.RG0dOhh1RMB7sLA2nKqmOsSuUmjuLFOlE7jnmcfTcb2b6XqcJV4mAWoii
 PiTTq7Dd08j3R4geu10e7ZMfvBNBAAJCG5e3DHKWYpFlfe2Y2Xt2KD5sp5TPkeZhj19zpLRKqfs7
 XzRhfAspphhDkSF264J3w_8TpePVI3038QG4umKdqXF2Su_kRm3aqk4sW8Ea6FXifXcUVwicFaLH
 _4r0hq.Ou6BfODPfDcyPUPKqbwhT_KlPtnEm_XXZhpAFLKVYjmI.SUhMjUxAxrvLpHdRGjkRQIDp
 pR7kOMeby_32.XK5Tjuzateww.8_kSgwQzJOXYZhpas8oYCpIW3Rrf8g2SFIcxFtPc8AFj6VVLyW
 khS9Tyb2loGVwewzjfTVYw.wg2jpQZSxBw5A0FoINyNKOuHNiLMiYb35Sownaz7eM2sXQ0GAYiCD
 V9VG7UoYxNRnYPC_BSdo9VGWyrkx4jr9Zhq.jueCXjySwZnPjf4jVvy6CIWcUqY0W07LZJmbF0P1
 urHOLBo0P4CJF8Kjb9Uw4FPfo7IdYKevwTtp37.7OUATdHXD6ix1.1UWAGB_yn_WtdAEvflTo7E1
 L1EsE43utluSyAT3_wX8GDm38Z342e..hx1CZhkHlxeQ5XmUeeKw0X0NCEBytB1H8BsKJlrsl8ke
 KjzvkPHYEW4l1wDoJU21glwZLBqFuFpfc44iWaOGUz.ytyPc_SyoUG5WaP.kOH_NlGFLPSNq_SfK
 RcVi2mrdoq_fnLdxO60t_PHCPCS0sRyq.2rjkG4aSS58VFuuL4.zPa0ZfNoNj4EBI3gU0CY4rbdm
 QN8Fr4QQXGcCV7sze.nCEGI_Ofe_BbsJoaCx.oMH_4nn3.HzTOUNBIJVLz_Z5Zz63AUr4yEXfN2s
 LSI5eAeCcGzHjvhmk7qwCey9rIQ8ctjqChIqWAV7r5iuGLRiTxXNJESW7OtMucBrdOpxoqJs1DBm
 BLlbEFPkJOW2nweDf85gtuDEKIl53_6sErVHradkmRSD0esDkaUDhMZKWBKmM2d5K0LOeYXt.wIr
 tiTNMsT8zr5n71uw2L.jZb.lRnpIJ.332LoyVeverAo5TIcO1a5YrBKfYmm45J1qcY0_MedvTfk2
 hNjdfIuN_9iZS2y6oRG3.lqAFe_U2vf4Tk6lldtUM4Fc7jT.Jo2BZQv7bM9BvMxidE9q3lVVpzGr
 29SpXZrjxVxY.dKeokf97mYNKoaNcvCvU_topN743ROpUH3CZ6vat0jLuq4SMtV1UUJOwFMtzR_6
 sXhQyVpofG4ZQmfsEalEa6wAPM6jigm3JKUN.3sIVyzTI41lBjfN2bZ634uxw2kR3eFdUIR0lKq1
 605y2nYMY9ZSw693DQXPk9mgCbg1WwrjegWghmUa8xVm1n4HixDEWv0XW._phaHjDK9ik_Ryh2BG
 tvbfVKxu7lj4Gxrm6FWpv.Z86ECyuNlPfm3llqNZ.3lZbjZnGrg--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: cda92d35-1f0f-423b-9feb-4c478a3f68e4
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sun, 9 Apr 2023 20:15:12 +0000
Date:   Sun, 9 Apr 2023 20:14:57 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <1806824772.518963.1681071297025@mail.yahoo.com>
In-Reply-To: <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21365 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Eric !

> Did you try to trigger gc after setting gc_after_writeback=3D1?
>=20
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo 1 > /sys/block/bcache0/bcache/cache/inte=
rnal/trigger_gc
>=20
> The `gc_after_writeback=3D1` setting might not trigger until writeback
> finishes, but if writeback is already finished and there is no new IO the=
n
> it may never trigger unless it is forced via `tigger_gc`
>=20
> -Eric


Yes, I use the two commands indicated several times, one after the other, f=
irst one, then the other, then in reversed order... successive times, after=
 hours of zero disk writing/reading. On more than one server. I tested it o=
n all my servers actually. And in all, the results are similar, there is no=
 significant cache space flush.

And to make matters worse, in other performance tests, I realized that depe=
nding on the size of the block I manipulate, the difference in performance =
is frightening. With 4MB blocks I can write 691MB/s with freshly formatted =
cache.

root@pve-01-007:~# ceph tell osd.0 bench=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=
=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0
{=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=
=A0
=C2=A0=C2=A0=C2=A0=C2=A0bytes_written: 1073741824,=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0blocksize: 4194304,=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0elapsed_sec: 1.5536911500000001,=C2=A0=C2=A0 =C2=A0=
=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0
=C2=A0=C2=A0=C2=A0=C2=A0bytes_per_sec: 691090905.67967761,
=C2=A0=C2=A0=C2=A0=C2=A0iops: 164.76891176216068
}=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=
=A0
root@pve-01-007:~#

In the same test I only get 142MB/s when all cache is occupied.

root@pve-00-005:~# ceph tell osd.0 bench
{
=C2=A0=C2=A0=C2=A0=C2=A0bytes_written: 1073741824,
=C2=A0=C2=A0=C2=A0=C2=A0blocksize: 4194304,
=C2=A0=C2=A0=C2=A0=C2=A0elapsed_sec: 7.5302066820000002,
=C2=A0=C2=A0=C2=A0=C2=A0bytes_per_sec: 142591281.93209398,
=C2=A0=C2=A0=C2=A0=C2=A0iops: 33.996410830520148
}
root@pve-00-005:~#

That is, with the cache after all occupied, the bcache can write with only =
21% of the performance obtained with the newly formatted cache. It doesn't =
look like we're talking about exactly the same hardware... Same NVME, same =
processors, same RAM, same server, same OS, same bcache settings..... If yo=
u format the cache, it returns to the original performance.

I'm looking at the bcache source code to see if I can pick up anything that=
 might be useful to me. But the code is big and complex. I confess that it =
is not quick to understand.

I created a little C program to try and call a built-in bcache function for=
 testing, but I spent Sunday and couldn't even compile the program. It is f=
unny.

But what would the garbage collector be in this case? What I understand is =
that the "garbage" would be parts of buckets (blocks) that would not have b=
een reused and were "lost" outside the c->free list and also outside the fr=
ee_inc list. I think that would help yes, but maybe in a very limited way. =
Is this the condition of most buckets that are in use?

As it seems to me (I could be talking nonsense), what would solve the probl=
em would be to get bcache to allocate an adequate amount of buckets in the =
c->free list. I see this being mentioned in bcache/alloc.c

Would it be through invalidate_buckets(ca) called through the bch_allocator=
_thread(void *arg) thread? I don't know. What is limiting the action of thi=
s thread? I could not understand.

But here in my anxious ignorance, I'm left thinking maybe this was the way,=
 a way to call this function to invalidate many clean buckets in the lru or=
der and discard them. So I looked for an external interface that calls it, =
but I didn't find it.

Thank you very much!

Em domingo, 9 de abril de 2023 =C3=A0s 13:37:32 BRT, Coly Li <colyli@suse.d=
e> escreveu:=20







> 2023=E5=B9=B44=E6=9C=886=E6=97=A5 03:31=EF=BC=8CAdriano Silva <adriano_da=
_silva@yahoo.com.br> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello Coly.
>=20
> Yes, the server is always on. I allowed it to stay on for more than 24 ho=
urs with zero disk I/O to the bcache device. The result is that there are n=
o movements on the cache or data disks, nor on the bcache device as we can =
see:
>=20
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 -=
---system----
>=C2=A0 read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ|=C2=A0 =C2=A0 time=C2=A0 =C2=A0=20
>=C2=A0 54k=C2=A0 154k: 301k=C2=A0 221k: 223k=C2=A0 169k|0.67=C2=A0 0.54 :6=
.99=C2=A0 20.5 :6.77=C2=A0 12.3 |05-04 14:45:50
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:51
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:52
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:53
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:54
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:55
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:56
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:57
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:58
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:45:59
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:00
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:01
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:02
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:03
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:04
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:05
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:06
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 14:46:07
>=20
> It can stay like that for hours without showing any, zero data flow, eith=
er read or write on any of the devices.
>=20
> root@pve-00-005:~# cat /sys/block/bcache0/bcache/state
> clean
> root@pve-00-005:~#
>=20
> But look how strange, in another command (priority_stats), it shows that =
there is still 1% of dirt in the cache. And 0% unused cache space. Even aft=
er hours of server on and completely idle:
>=20
> root@pve-00-005:~# cat /sys/devices/pci0000:80/0000:80:01.1/0000:82:00.0/=
nvme/nvme0/nvme0n1/nvme0n1p1/bcache/priority_stats
> Unused:=C2=A0 =C2=A0 =C2=A0 =C2=A0 0%
> Clean:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 98%
> Dirty:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1%
> Metadata:=C2=A0 =C2=A0 =C2=A0 0%
> Average:=C2=A0 =C2=A0 =C2=A0 =C2=A0 1137
> Sectors per Q:=C2=A0 36245232
> Quantiles:=C2=A0 =C2=A0 =C2=A0 [12 26 42 60 80 127 164 237 322 426 552 65=
1 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2=
350 2471 2594 2764]
>=20
> Why is this happening?
>=20
>> Can you try to write 1 to cache set sysfs file=20
>> gc_after_writeback?=20
>> When it is set, a gc will be waken up automatically after=20
>> all writeback accomplished. Then most of the clean cache=20
>> might be shunk and the B+tree nodes will be deduced=20
>> quite a lot.
>=20
> Would this be the command you ask me for?
>=20
> root@pve-00-005:~# echo 1 > /sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb=
3fbbcd/internal/gc_after_writeback
>=20
> If this command is correct, I already advance that it did not give the ex=
pected result. The Cache continues with 100% of the occupied space. Nothing=
 has changed despite the cache being cleaned and having written the command=
 you recommended. Let's see:
>=20
> root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_st=
ats
> Unused:=C2=A0 =C2=A0 =C2=A0 =C2=A0 0%
> Clean:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 98%
> Dirty:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1%
> Metadata:=C2=A0 =C2=A0 =C2=A0 0%
> Average:=C2=A0 =C2=A0 =C2=A0 =C2=A0 1137
> Sectors per Q:=C2=A0 36245232
> Quantiles:=C2=A0 =C2=A0 =C2=A0 [12 26 42 60 80 127 164 237 322 426 552 65=
1 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2076 2232 2=
350 2471 2594 2764]
>=20
> But if there was any movement on the disks after the command, I couldn't =
detect it:
>=20
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 -=
---system----
>=C2=A0 read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ|=C2=A0 =C2=A0 time=C2=A0 =C2=A0=20
>=C2=A0 54k=C2=A0 153k: 300k=C2=A0 221k: 222k=C2=A0 169k|0.67=C2=A0 0.53 :6=
.97=C2=A0 20.4 :6.76=C2=A0 12.3 |05-04 15:28:57
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:28:58
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:28:59
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:29:00
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:29:01
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:29:02
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:29:03
>=C2=A0 =C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =C2=A0 0 :=C2=A0 0=C2=A0 =
=C2=A0 0 |05-04 15:29:04^C
> root@pve-00-005:~#
>=20
> Why were there no changes?

Thanks for the above information. The result is unexpected from me. Let me =
check whether the B+tree nodes are not shrunk, this is something should be =
improved. And when the write erase time matters for write requests, normall=
y it is the condition that heavy write loads coming. In such education, the=
 LBA of the collected buckets might be allocated out very soon even before =
the SSD controller finishes internal write-erasure by the hint of discard/t=
rim. Therefore issue discard/trim right before writing to this LBA doesn=E2=
=80=99t help on any write performance and involves in extra unnecessary wor=
kload into the SSD controller.

And for nowadays SATA/NVMe SSDs, with your workload described above, the wr=
ite performance drawback can be almost ignored

>=20
>> Currently there is no such option for limit bcache=20
>> in-memory B+tree nodes cache occupation, but when I/O=20
>> load reduces, such memory consumption may drop very=20
>> fast by the reaper from system memory management=20
>> code. So it won=E2=80=99t be a problem. Bcache will try to use any=20
>> possible memory for B+tree nodes cache if it is=20
>> necessary, and throttle I/O performance to return these=20
>> memory back to memory management code when the=20
>> available system memory is low. By default, it should=20
>> work well and nothing should be done from user.
>=20
> I've been following the server's operation a lot and I've never seen less=
 than 50 GB of free RAM memory. Let's see:=20
>=20
> root@pve-00-005:~# free=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 t=
otal=C2=A0 =C2=A0 =C2=A0 =C2=A0 used=C2=A0 =C2=A0 =C2=A0 =C2=A0 free=C2=A0 =
=C2=A0 =C2=A0 shared=C2=A0 buff/cache=C2=A0 available
> Mem:=C2=A0 =C2=A0 =C2=A0 131980688=C2=A0 =C2=A0 72670448=C2=A0 =C2=A0 190=
88648=C2=A0 =C2=A0 =C2=A0 76780=C2=A0 =C2=A0 40221592=C2=A0 =C2=A0 57335704
> Swap:=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0
> root@pve-00-005:~#
>=20
> There is always plenty of free RAM, which makes me ask: Could there reall=
y be a problem related to a lack of RAM?

No, this is not because of insufficient memory. From your information the m=
emory is enough.

>=20
>> Bcache doesn=E2=80=99t issue trim request proactively.=20
>> [...]
>> In run time, bcache code only forward the trim request to backing device=
 (not cache device).
>=20
> Wouldn't it be advantageous if bcache sent TRIM (discard) to the cache te=
mporarily? I believe flash drives (SSD or NVMe) that need TRIM to maintain =
top performance are typically used as a cache for bcache. So, I think that =
if the TRIM command was used regularly by bcache, in the background (only f=
or clean and free buckets), with a controlled frequency, or even if execute=
d by a manually triggered by the user background task (always only for clea=
n and free buckets), it could help to reduce the write latency of the cache=
. I believe it would help the writeback efficiency a lot. What do you think=
 about this?

There was such attempt but indeed doesn=E2=80=99t help at all. The reason i=
s, bcache can only know which bucket can be discarded when it is handled by=
 garbage collection.=20


>=20
> Anyway, this issue of the free buckets not appearing is keeping me awake =
at night. Could it be a problem with my Kernel version (Linux 5.15)?
>=20
> As I mentioned before, I saw in the bcache documentation (https://docs.ke=
rnel.org/admin-guide/bcache.html) a variable (freelist_percent) that was su=
pposed to control a minimum rate of free buckets. Could it be a solution? I=
 don't know. But in practice, I didn't find this variable in my system (cou=
ld it be because of the OS version?)

Let me look into this=E2=80=A6


Thanks.

Coly Li
