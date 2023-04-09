Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDF86DC176
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Apr 2023 23:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDIVII (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Apr 2023 17:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjDIVIH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Apr 2023 17:08:07 -0400
Received: from sonic308-2.consmr.mail.bf2.yahoo.com (sonic308-2.consmr.mail.bf2.yahoo.com [74.6.130.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABDA2D4F
        for <linux-bcache@vger.kernel.org>; Sun,  9 Apr 2023 14:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1681074484; bh=/lm6rQ4hM5FTWJHyI4IySY+Y2T9ILsCe01ge8uJyfCE=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=eG+L/+u9hE6k3WGsBfFpZl6WjLmCRhGzJtwyj3GAMdC4QQaGK1aYFFkSPxEG89QNmLm6ScUrlTd2Xk3P3jjIIMA1wxB4IieSRYJFjDTT2BF+yocXErEw0OEVut3rNWbFIu/vObBKcTMH73KdmgCBNHtXof/jULJQJydbl9iL7165lbKMAJWWrElYhGZHp3DfKJGUXF7rDwIbIcrvLb2QCQkql2sVa0SjkbHcKqZ/TSgfkud0i3hgnxEcz3jsq4ItArDRGfDhjVt2XGnA1o4K/R2coJpGYMFF9cg8JbRt+vS4+U8nOYpKbUUUWujHr8OqOBqhlEChm9CYwoX2dwu8tw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1681074484; bh=V5yotdti0i9QABNaL3jYC7rJOdlnzRFO/IZWKxqXNB4=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=spRQ7ks+iVEEUkwr1h9Hvh3nAkpZW1y8LiFoy8DQ6P+AE/TOWFXLY+Z2kC3zIyOVjSBNMitxF/tgWd3QAvWEaIu9gG/m4CbaYO1emyC9s8FVhm4cb0cPbvqRYGIsTh1GMDduNMiIWwto+uiLq8mvF+oomXsmPcQr4ZPxKqiJiQSuaa7LTupqQKzn2UzxoVJ4JhM3eNrclMKBfN3yWRSyaPyEC0WL3BEdGcesqnnWjSDMgdvp59WBy98rL4CyrPCt55WqlKhXBzcdqwiDgGoT4QcbTkcRlJI0yAdH60vkm7URE6SjcrFqmUDmoAFLompRXFG1akw9YwxCK0XujYh1cA==
X-YMail-OSG: e0ayUZoVM1n.b6z3mhfQKHXiOq95oEmtxvb9bV41XA0721aJK0niydIU1ebYcuZ
 VLiUm_C6hOkikuOkJ_.KzRGzL108zee26EYy0E7xroATqQpY25K8Au2aIkq_Pd2YV7qu.nvdKsHE
 dPlWrRrKL3d9SS32k34BKODQMB0Y8fYysvjSq8f2bJLEx7j8k9umCDneclaeVkyB8iKB0Cu5iXll
 AYT0pw0_fsPovLAzSIj5KhWMS.KbujcH7HAhufrt76XUY37k933IPfMSoreHz4zoPlWCQHNDjW9O
 eHPLA0Rsp02uHyD0biyidj5nhKc839rq6NN96Kw1GkVDLTBezmd1msU5XykXCWa7HrCfgfv1J6yz
 8AwJplOhr10fNj.v5vL4X1VS8SNuAOPXzWDTejrAzpwjTEF7wqSaMPAePMlnoaPDqHkVDQwRnNiQ
 AZy2v4Y5tXE3ICjTgLdYrj8sO8TOp1_tiut0fgzSfL49fuYRj1h.SVdha4AiCoqYc.xpn8HXlWw6
 BevItfFfmiwidASqghO3StsLIoL0sKUEAjMZl7K02VrRN9QVkZDJu_NQnj5CoFoBZAPGFY40yRDo
 edI5YTbGaang1zvG6EdItTrsJmesiOhicjDzCJQUOAxR5lO0dVg_7cr2ETefbmhtjQwxwHnJsbfw
 zVMEoY5Ja85iZbmOnFCWuSm5dQls0f8w._gvNr5gJntIacI9buQ7Bnc1139NyZgsbc8xy1phGR8D
 v09MdYPyzOcl5Apa2jy.qKTi3HEVzkB.1aEdGmtNobixUiSZRzhLllGKa5p1mtTna6Ayziu7PSdT
 0Q8PplDU39Roi.BWpEiS9rK6m3rLkYsCtx8K.HcdOuItwwElghB43CgYSNeDWotoqzQmxfAWQfy6
 hWXcLpdGvnFXNSINZjkwE.XEOU4nc_lMCRTFMaJFY5rmLnbcyLYDPtD3PFtToCFWBszmT2nm.oRU
 4Rhi.GLmKA7q2Z.GbBD9rcrxdjNEyUSyl6nXQXsnzu45h8O6a4CwagQZZpN2sP1dNGeVQOAXjni1
 iIRPDXPgKV5Hmzxa3jsgoFY8M2uIz19t2MWolsw96z59eDohkBrDng.NDAALK.qNHCGs7alH7qTT
 odWzoYV1YhzWEuVbfgD.2rKIe_uXNYzRLv_LmfGKIiXoJ1KDnnw8jlm8YAI5iuTE3_Z0oVs0GnJ3
 PGrenewBzlXrwlUbzGqYfvZVqy64Lgzx9iVk8ZGoAMcq5r7cDo7zTSN6u1tJRs6rASjsbl2ATZmu
 p1LR0pxvtEXnmX4u1R2SUDF7cOnFIUqmc.maBlhjCEMKYMySUPXt7DsB1JR.LFVyOQssxv0GLavZ
 EVl8eJG9vKIxMUjPVpngzKhR4pEtG2DesMlDenp05yb5KOT3S.Qu7V6bRYGS0gp79CQ_R2bKCANx
 lfAYyWI4Cy1YERirQxwn3wUiA3uMPT97btd6rrM6Do8pRbp6QOO7Lk.z9aCwMf151kGvPw9R2ZnG
 uTFvPlsoQ54bGLH_KfbBTXE2HiEzu2faxEOzUC9q8tmT2m2VxKLfmZsnrB_.Y.3tp6qDry9cVBJd
 .9sKQ7YutDNZvDOP3rRH9ZoFrzR_d7aa9rS6cGXqXyfHeznxZKUU5vE2nS8CgiBPXl0H7oLinQ_.
 q3apg8Fxq36tG4w8AFEwoGdde3thk2N0.x.yPHIsk9mUjjsLyLO7KzWRKcC3yAVcJiLRw9MrLBci
 92_WZniDayTHU3f5FdLA3.Bb0aO4eINsR8JjDdCjumfSgIQzN72.7Wu6tlV_MKaMAQbqBLW1AQP6
 e4CSjpzrtc3bIT4NePY_DZDhrq9y9_BXx3AECbYytxFZqqr0joTtrwbgscibwS5RyGkDzo_ronyq
 I21a9vO09DkFonpI3zjiP7t2FuA5Jyx9O.85n20abNtPKsq35tQhd82P82cB3XdXIf9Lej7THRz6
 Xznail9t9BzcBFBDZY8crhPNemHUizzZ.XxHeCwesgTOWDpsmoUoOl8a3RHXtbLMVMst2AjI8uaE
 wPb.bL4iO3VmZgiob0H4QQDiGY989sO3SrZRxJkJmvbgkFUQDDTTnalTPt6Kcy3mHWRtdolPTHuu
 cK3PEF6cqHHIn8gdVelHUpXjjlPNFvt..X7q4O8cxTMNaFPlcKfaTZFztYQlYBLECVoP.26WL8Hm
 Tt9_zK1oWizc0YhfYBMNlzWKmco0Jj_a63phVYeeSmuvhKNjjtpplMXS4MAswve02OShyHbnqDXg
 4Lp.Z5jPlCJDtlSyu0lelAA--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: daeb59c2-eb14-47a4-9673-e200902049d5
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Sun, 9 Apr 2023 21:08:04 +0000
Date:   Sun, 9 Apr 2023 21:07:41 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <125091407.524221.1681074461490@mail.yahoo.com>
In-Reply-To: <1806824772.518963.1681071297025@mail.yahoo.com>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21365 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly!=20

Talking about the TRIM (discard) made in the cache...

> There was such attempt but indeed doesn=E2=80=99t help at all.=20
> The reason is, bcache can only know which bucket can=20
> be discarded when it is handled by garbage collection.

Come to think of it, I spoke to Eric before something curious, but I could =
be wrong. What I understand about the "garbage collector" is that the "garb=
age" would be parts of buckets (blocks) that would not have been reused and=
 were "lost" outside the c->free list and also outside the free_inc list. I=
f I'm correct in my perception, I think the garbage collector would help ve=
ry little in my case. Of course, all help is welcome. But I'm already think=
ing about the bigger one.

If I think correctly, I don't think that in my case most of the buckets wou=
ld be collected by the garbage collector. Because it is data that has not b=
een erased in the file system. They would need to be cleaned (saved to the =
mass device) and after some time passed without access, removed from the ca=
che. That is, in the cache would only be hot data. That is recently accesse=
d data (LRU), but never allowing the cache to fill completely.

Using the same logic that bcache already uses to choose a bucket to be eras=
ed and replaced (in case the cache is already completely full and a new wri=
te is requested), it would do the same, allocating empty space by erasing t=
he data in the bucket (in many buckets) previously whenever you notice that=
 the cache is very close to being full. You can do this in the background, =
asynchronously. So in this case I understand that TRIM/discard should help =
a lot. Do not you think?

So my question would be: is bcache capable of ranking recently accessed buc=
kets, differentiating into lines (levels) of more or less recently accessed=
 buckets?

I think the variable I mentioned, which I saw in the kernel documentation (=
freelist_percent), may have been designed for this purpose.

Coly, thank you very much!



Em domingo, 9 de abril de 2023 =C3=A0s 17:14:57 BRT, Adriano Silva <adriano=
_da_silva@yahoo.com.br> escreveu:=20


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

