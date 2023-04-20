Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460CA6E92EA
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Apr 2023 13:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjDTLgk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Apr 2023 07:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjDTLgj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Apr 2023 07:36:39 -0400
Received: from sonic308-1.consmr.mail.bf2.yahoo.com (sonic308-1.consmr.mail.bf2.yahoo.com [74.6.130.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9FE6A4B
        for <linux-bcache@vger.kernel.org>; Thu, 20 Apr 2023 04:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1681990560; bh=zWgvvn6ekdKdejfM3RgdJsfdzH0224Q5aEu61Lod9PU=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=SLnof93SOmTAQhpz6z2c/JCa0BIcrQAf5H9VV39ms0pJt9QufHPSwjc5D2kyoQrmjZbxCpu+eqbFVesLpb6+UXNaz31tiRM4E8BelYLWi9z9U+FQe4Wj29QYaTZ/AjBcrVBSaVdpody5wrjPSVj5g1V6DNqR/HkM0vpdu2dUmduGQ9b81dkIYecoFQ/BW0NzxQ9Edg5TZ2IBsboMVZJVj8ITx9vVx3E5fCA9lsXLHLuTrlUyFTebAGvfS1bwzU1rkMXRsJVo09Bv70j756W9Fa1TKItr0YwoJ619w88VphMSwAWCBl6Lf2EJSPchppazEAh7JTLxOj2liCvdgI1/Bg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1681990560; bh=3+z550PYqomI07xDiAcVsqfKpBLYpKvQ2nzC1yTyLKJ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=eNkgBuhOwSZ9OHZK9DmG4GwrXYoiawEvjgEF0iMCFUwBr6/nHGbRIXmyrw2FA8JpS86J5WNxbLUiTIaYFXFN52ShByO2NMMpA3F9DT5Yq8dzRahUhQnOwwdabf66TEzm5UsLvh/YaG+OsGOKDHmoMeafLj3GTBDZUgV30d/rNlMtXL38BJjoDMW5qrP4tQFwVPkGCJOrGndXp4PLk6+DX8upkQbhsAKo1wnJTxMOpz2ENgwmRufGApg4M7t06qs6tfscZi6DVfUnDBlEvnLV4SI3Err1EFRsFyANU+/9Z4Ke4oOsQreaZIZNnUZC8Ds4F2XDD7wiQfHXgGVgQB3RZw==
X-YMail-OSG: idEPjyEVM1mlR6xt.Htwi2buGhjYpbknx94FshkwSQHrP0Wd.lViu_T4AxfdumC
 iQ5rBpYXvaTvEQAFGGjHsMMXUCCSJALiU5dIuAMmZnmHgSyV3bYVCJYYvnVo5XVq6EobZi63uydX
 zU5sMmpNNxfO.TntNotNDoFj7tGBpLhkETFbX6j7D4F8TGS1Kj_hILDZ3DR0BxRucNoseothkwD6
 EM6WKm3quDkOmoq0umb9WYDBdpr7xURnXgGwgMZ7EmI9sfp3HW8Qmhrw8H4JA9xjIZtiVVoEHdWe
 xhzP6sb5.JwzKbVF_JqP6YazcK4PVLFGuXDVrS1skRPUuE2hGJ.iasjrAlCELKbFWusQU7uyLUPF
 cMa.1_t7WZWmHMkqbZ1lKYLUwi1XCVXNDqgW0fPkAJsWSwgS_QEOJYcaRXXObIdPV9Srjn5Z6SHJ
 sDbQnKO4OOPxaZnVgL0K1sLxzapNo_64GVILrYg39Oue2g2K7jVYsuGQMf6zKUAF9qf4rFOff_mT
 8m2BiammK_zdfRoUp6KIlD3gMX3b2ibzNBRDfz3QOGqVGR.cuCnOn3nfyUERgqXw09y5d0zbYMXZ
 G3BWC6qyrx6_MFQeZHAeCu9KDthB4QKnHlBOdU7ifVkIO46jZSxOrk4MsozBfTks1mguklxxX.2Y
 RaiBoIR9XA0p3L54J42U0qw4rggBcwsWHLzI4qqUkYt3NgDZtuWkgBj8L2MfkA0WMvsyY3HLsJqh
 Pv6__BVM7QxjopIO3YKBMZZJAvRXToWvOWPhJn3gurs.KxhLgp2V2MtxMMHm3XiaEhKF_Nv4zA7i
 S5kDiTH3gtbCubMk.CIp05PPABVcHH7c_DV33MqdfLeOVoZwF0wiDlbpZp90g8h1KZDbk9CY99HB
 nk6MCNmIQKJLplSW7FN2DH6z5js7nUnf39GankklKisJ0t_AWPXtYI4pVWdN0L_ZgB2XaspZUpLf
 ljRvm1D5eP5hdEuNJRLHlNSIEvk1Mwt_pC0G8xylLh2kf._PhS_z0MrJZmNtevMSUsj9A.euPpn7
 Yg86B6QlI2mHxQTTeQdDhNOcpeJZPNIEtUOkeueTN4LjzS.HMSsKyD14P4HY_.xreErU8f1mH1hW
 6F_RdNeL106TZY0G9COfC..Cx0FF70Oyv.wNtP8phLdZ6M7fmYD38iTvW2UhTYdB8AZ1P8CnvaDC
 4n.E6Cm6vzmjoVVRJfDr83QqAm6VqwVyB8XnNj72VWeH2pHMiHZFiwavXM3SPO5kc2eTTqsJrQWX
 mm3PO4A5JLrcD27rhGNXiABVhDLWqFdmwqDkwaNP.8SkmAqvQ3V79SNwJhTAljgxLhdx98y8Sw_p
 ohn3QZwjApdJXluhWOOSAcynODfzz4WlH2HB7Nz6YApg8aw4s34.JpYmiRLoYdwrIadPJ5ebc0o6
 y_W0GRDOV.ubgyzMyh7ePe22d6RSnSlXNnvRowMVAZFVEXj8ZkzTQ.llWWie9ok5zHnlgulNKzFI
 yFjjrPnMO.sCDl_Ije_IQYhoSO3XcRi1tQz4vLdI.Itiwhsb_0jyNnD5pqFzJSK6nTg4ACxCj8kF
 GYiqvvmpH0SQqOSXp4viNS6kOyVkPpgOeAfgMmWhoYAeFaTFrVQZ5lhjal0QVsvwYuDIlN.xuEjO
 d1l0CD9D9VfeaNssJhKFzGQYoHxkRmOmQh.Es9me1T_2zFZhV.o5bMg4pMtc1XsDCzLwnXbckzL_
 NEQh_mfl0pRyqGn_xsM98Z_v9rcuAcIXg2ibBWL0xGc_w._w29xDC8WD9u5Zp8gSkuF11F7OVzSd
 iw4TFL2vaYB53FbOnLnFC0ScCRll6Wd9v.BFXNj.OHD2YQu0ZExnCvqxKPZKBppuI4t3PoWDFGbV
 G7miqlNUMaoyQPDNHICdGw1oPQkZtJdHr4VQrnf7FI_aecmmWjvXMZ1FAnPOFaMepUTjU6Lvf988
 3QKl7X9Kx8nC9Dj2mQ0VfDZOfLvS4yquune8Oij0S6XDRODvaOrAKjXc0eU.dk9BjKZQsqZD1Ad2
 6FFHIhlfLQDFHrBZSasqGJRLG0kyjjnZ0OBAcuBrV1EyQtpg.0LXdvBOQEN1qJF96PS4g3XsqdR5
 WoPJ0JXAkOcJPTF8GASBjG6nZpNU1MRFbAXjyLNOAba5xtYDT.ohwyjGxgYu3VQrjthg.7UWTn_U
 xpORgqPvkc_SRTnz5oo79I.HiH27GT.bOCXdMNWEuiEbY1vo3ibny3nm6dujKOQUxNi6q_r_SQAq
 rWaHTJPzKfLC5ABiYZo5z3CHzvwoLxH6SuJL.ykgkTACbGH6l0w--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 3c42dcd7-7029-4ef9-bfed-e8749830af78
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.bf2.yahoo.com with HTTP; Thu, 20 Apr 2023 11:36:00 +0000
Date:   Thu, 20 Apr 2023 11:35:58 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <1399491299.3275222.1681990558684@mail.yahoo.com>
In-Reply-To: <125091407.524221.1681074461490@mail.yahoo.com>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21365 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey guys. All right with you?

I continue to investigate the situation. There is actually a performance ga=
in when the bcache device is only half filled versus full. There is a reduc=
tion and greater stability in the latency of direct writes and this improve=
s my scenario.

But it should be noted that the difference is noticed when we wait for the =
device to rest (organize itself internally) after being cleaned. Maybe for =
him to clear his internal caches?

I thought about keeping gc_after_writeback on all the time and also turning=
 on bcache's discard option to see if that improves. But my back device is =
an HDD.

One thing that wasn't clear to me since the last conversation is about the =
bcache discard option, because Coly even said that the discard would be pas=
sed only to the back device. However, Eric pulled up a snippet of source co=
de that supposedly could indicate something different, asking Coly if there=
 could be a mistake. Anyway Coly, can you confirm whether or not the discar=
d is passed on to the buckets deleted from the cache? Or does it confirm th=
at it would really only be for the back device?

Thank you all!



Em domingo, 9 de abril de 2023 =C3=A0s 18:07:41 BRT, Adriano Silva <adriano=
_da_silva@yahoo.com.br> escreveu:=20





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

