Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A7C6F6DCC
	for <lists+linux-bcache@lfdr.de>; Thu,  4 May 2023 16:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjEDOe4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 May 2023 10:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjEDOez (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 May 2023 10:34:55 -0400
Received: from sonic313-13.consmr.mail.bf2.yahoo.com (sonic313-13.consmr.mail.bf2.yahoo.com [74.6.133.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669DF10D9
        for <linux-bcache@vger.kernel.org>; Thu,  4 May 2023 07:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1683210883; bh=wXXPHiTw79FgkUEH0GyjQx89j8ie16Sauc8Lfu4bF2k=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=EB2IMeUcJAe4tTJmt6OdUupz31ar2fe1O4iGfInO6vuhlOFe96xWLEqAcwUTVEGBSS4scNUQ95x5o1FCgDFMtohKJNl42mn6zEEwu/QQdNkypQmEDkgR2QF0HvvRoom/q1H/PC7L03ZKNJmEFK4JMayggenM045vnw+bzzgQwKZG7ngGkfH8GSLOEPIctKKDdnAV4NXFRcdZzADmzAm8ojclyS/Jir52NgffHqeF8r9wzVPKRX6URVakIrpBpD0Jemr5VnDTXXyoDO81lC/m4rm/992FzuJkhzKh7KtsQApBC8Qy61Bl0oYQ9pxW76PMld83Z7JBMGfOwz08RxPDyw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1683210883; bh=Mvo+yvLvY1ENgx8JtwHm84L/u1fu7sRmpDvkAeZjUWZ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=sLoS43RNIR4/rP5t1MW4ljvb5eoG1Ff/ZSe34RXo1ka4820w7xhvkA2PWPXG4pZsYPEXVn9ZZzV+2rwdYvKkXZWpZxZ4TOQnIbU3jM7KkVvh23WUKbHkeedQiNI4Q328zstKRYWiThzXOm0OCQQZG0uOj998Qz+DD4CFVfk/FhIsxb7M8PbU8Zf2YLuHgjrCIx9Ne/F3tdlEeguO1aik+5wloCf4lozb4w5EdqbcXI4vvPGqZb/v02JZhT6Nd7ia7hDOvZJe1XMuHqKnqMSaMQAOXoBpPD5mRpryXHj05gbAxvMmjP7tl3ShbuDRDMtsfJMzj+cJEYV8kBqNnXefoA==
X-YMail-OSG: dDUIGV8VM1l4JbfPwvxxgohWZPIpv9Mcr.DfojKTvalJXFATDgGVvMvKFUyzITV
 XZppxXzyCGYmPK4qrMn7tk6GRnLDLuMlfYN0iu89yeHoZmLgUNN8e34rDXom7OcPpQUe1vDu3U38
 eITE1kWZpeBGYiz1PSEeWiBcZCdp5h2iOX7SK.kAAoy_9AnE5yGsiXY_fzeinx2o.S_x8STxm_4L
 aXlJ5hvVKNjX9rM7YrPpyvOBk4THvYj2ao6hwexxgjhmh_FQHFwtkISdEobQRF3QhCAfk_QTi5AM
 lW_o5N1PazKC21KgwKMlfbC1ZVbfhbxvF0CNkvMyIo8Zn0.5Q2y__WiN2OZskKtxX13eCEMpwOwt
 lWoxl7.IoQ_QDGpDwSJXfiwY8Bq6Id4gkwAqlDIzfdFPnAUSFj9gxqXQhVKDa3C9Gl16rxhXetcr
 7PRDSYuBWOsJIbCVFnhlhCjBld.EYPxfW5TiR1N1ZWDnxGSesROyyd4ncJzFxdzEOltwewdUdsi3
 .ceOEApYiMN0.Olo2qotKcvzPmZ22vn39MZdopNiJKqZ999KdXGNfo25PittoYxG0YUZX_i0bZJ0
 .rpGJGNgeeafa6Ct0ouz2MfXqgIYv818xnTlVphsT6V7L9JIAJ2.KboeC_6gyRVNQsameKKjBHPw
 _Hj7XtlNJq2P33d1pZg6uxY8wyAh8JWpW3QnWkb.QEV2fx57UoTwAQJwqAO7wH0ROxzW183ikgQF
 tkV.RDLCi8jL3kqp0Ru8R5rPMjbavG_XYyw1aDR1zARxwmYOCTUuG4sZxYGsuZue7fSMAZxE_Giv
 fyqlnukTbA.vppNbUeKi___4xSvESVRNzywOK8sgGNpZFMmGlyos_7tmdoiEovpW5de7PsCVzMje
 1d4wYfL_TCmH_c3uCHb9fnb0RWvxIL4kvrIbuiEs3dX1PeKWrPj3n_QJC06rwfyUb4s7RAXlh2jG
 EEnAH3LmWRXrZuA6VmmeRwCf7aOiKi01SKrkIQwMw72pfpdKToxs8nAqlhg6lMTFej7iPIfkBc6G
 QrniL7JX5Ro10OjYF5EF.Q5y7ZodGeHjuvGa9xtHeQGF8OtGvWtdQfM_dJupsdsoXpsuSKJeT6YX
 MYwlWBhyBb1N0duo1yei8wV9z1.3N2kTeibwWTH6jmWHrvhCRjhgmqXzDseBfOyLI7DK6Y_54Xio
 aVcDzt.SQ4m.crmqeUED4IAKzoKeCEfW9JodXxrYau1tD7dUFUpcu728WSUawGceGxvNnD1W2O08
 uFOrq4pGgIJrNDrm4YXIDgya2jrNE0tluKH4BRlBzSEPSqO9O4h7fhviajZPj0RJCqK3EpR.wWV.
 4bhyo6tNeuWzXJS73NeOE_t0xpAiMK4zsOa20G7V3DC0k.oHHm.M32x58QgKNIerViaG0ar3t8.v
 Aev1.0BHQjyTYFsQQ2P3Cjqd2KpwuWuGXPG0IJhTWwsgd0ATLDjHdB0Z2YTELSxYadnlO1ntqP.5
 A6yZatAIjH6c8rO3dTV.ZLkaeYkN8qEzKsoe6R9cfX4HsUi3bwB8AKHd_tT4XtZXv5Pb5GT6Wi8b
 Co3m_48cdxwuhk4Btdd83EVr5qqUpjE6z7WoMtEhE8mvkat0CbKN3MWdesvoJGFBzgUvq8UxpIIJ
 55I_UjuPu0BZt7eI9T_mt83aGPoGB74hkqZQYYdMV6_Qjr3NITBhGF6eAqAIM1PR.G850pNOma3d
 4XsO0OJWJXKEqlXjpyOnXAk9q.663SBS3zoEbucxu2Sk6tPBGhEZRXsQjK.gcqxzOZQKxye6KxZe
 TKoKVIa8Pyovi2hikd18tZ1l_8gj6wGZNyep2_obgS0AIUKhK_MSYIjZchn_GxJ5HMb98KDm5VOG
 DXN9bP4FJ3I_MLh1u89tfUeVz1OJJ0xokLyA8NWeX1i.N2hlO6760qJLrnhRRf6CDiERvdblZZYu
 _7KbDQVsrRlQPAm.ciOIx26CKrcVtXAtkmWig8veWEsTrSIiBHJD9fOTGFS7qrC_hsySMZ6FeWDl
 EhR0gdddWYiQS46kd2ImTgWruUtzSpFaAyBh9ME6eIC9DzeztKWlqyNtBoCDgSQkbZp_6SNlsJ07
 9PHyZkYgsvoboWHox4bMKbiBvNrNKHaZHttLkLDWjthSHiWPxIE0y3LJqlTm7s4Zp_qxQNsaxAZ_
 QsOwB7d1GmQSA4RbsqJiRfor0kqkqYIqb0vpGAOnD8ukoxdeKCD48VMCQ6T0n2Bxpiqzw9Mq7dYE
 gqNFBTOu2692z12G0MclTEFZm2AN_7xtcuesb_k0Unktzt8rtKhoWXGQf_FSMmw--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: c7ef4f0d-aecb-44f0-a3d2-1cc7b723e249
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Thu, 4 May 2023 14:34:43 +0000
Date:   Thu, 4 May 2023 14:34:33 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <230809962.2194275.1683210873801@mail.yahoo.com>
In-Reply-To: <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <6726BA46-A908-4EA5-BDD0-7FA13ADD384F@suse.de> <1806824772.518963.1681071297025@mail.yahoo.com> <125091407.524221.1681074461490@mail.yahoo.com> <1399491299.3275222.1681990558684@mail.yahoo.com> <98d8ab2f-93ff-4df9-a91a-d0fb65bf675@ewheeler.net> <95701AD2-A13A-4E79-AE27-AAEFF6AA87D3@suse.de>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21417 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

If I can help you with anything, please let me know.

Thanks!


Guys, can I take advantage and ask one more question? If you prefer, I'll o=
pen another topic, but as it has something to do with the subject discussed=
 here, I'll ask for now right here.

I decided to make (for now) a bash script to change the cache parameters tr=
ying a temporary workaround to solve the issue manually in at least one of =
my clusters.

So: I use in production cache_mode as writeback, writeback_percent to 2 (I =
think low is safer and faster for a flush, while staying at 10 hasn't shown=
 better performance in my case - i am wrong?). I use discard as false, as i=
t is slow to discard each bucket that is modified (I believe the discard wo=
uld need to be by large batches of free buckets). I use 0 (zero) in sequenc=
e_cutoff because using the bluestore file system (from ceph), it seems to m=
e that using any other value in this variable, bcache understands everythin=
g as sequential and bypasses it to the back disk. I also use congested_read=
_threshold_us and congested_write_threshold_us to 0 (zero) as it seems to g=
ive slightly better performance, lower latency. I always use rotational as =
1, never change it. They always say that for Ceph it works better, I've bee=
n using it ever since. I put these parameters at system startup.

So, I decided at 01:00 that I'm going to run a bash script to change these =
parameters in order to clear the cache and use it to back up my data from d=
atabases and others. So, I change writeback_percent to 0 (zero) for it to c=
lean all the dirt from the cache. Then I keep checking the status until it'=
s "cleared". I then pass the cache_mode to writethrough.
In the sequence I confirm if the cache remains "clean". Being "clean", I ch=
ange cache_mode to "none" and then comes the following line:

echo $cache_cset > /sys/block/$bcache_device/bcache/cache/unregister

Here ends the script that runs at 01:00 am.

So, then I perform backups of my data, without the reading of this data goi=
ng through and being all written in my cache. (Am I thinking correctly?)

Users will continue to use the system normally, however the system will be =
slower because the Ceph OSD will be working on top of the bcache device wit=
hout having a cache. But a lower performance at that time, for my case, is =
acceptable at that time.

After the backup is complete, at 05:00 am I run the following sequence:

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 wipefs -a /dev/nvme0=
n1p1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sleep 1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 blkdiscard /dev/nvme=
0n1p1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sleep 1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 makebcache=3D$(make-=
bcache --wipe-bcache -w 4k --bucket 256K -C /dev/$cache_device)
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sleep 1 cache_cset=
=3D$(bcache-super-show /dev/$cache_device | grep cset | awk '{ print $2 }')
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo $cache_cset > /=
sys/block/bcache0/bcache/attach

One thing to point out here is the size of the bucket I use (256K) which I =
defined according to the performance tests I did. While I didn't notice any=
 big performance differences during these tests, I thought 256K was the bes=
t performing smallest block I got with my NVMe device, which is an enterpri=
se device (with non-volatile cache), but I don't have information about the=
 size minimum erasure block. I did not find this information about the smal=
lest erase block of this device anywhere. I looked in several ways, the man=
ufacturer didn't inform me, the nvme-cli tool didn't show me either. Would =
256 really be a good number to use?

Anyway, after attaching the cache again, I return the parameters to what I =
have been using in production:

=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo writeback > /sy=
s/block/$bcache_device/bcache/cache_mode
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 1 > /sys/device=
s/virtual/block/$bcache_device/queue/rotational
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 1 > /sys/fs/bca=
che/$cache_cset/internal/gc_after_writeback
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 1 > /sys/block/=
$bcache_device/bcache/cache/internal/trigger_gc
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 2 > /sys/block/=
$bcache_device/bcache/writeback_percent
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 0 > /sys/fs/bca=
che/$cache_cset/cache0/discard
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 0 > /sys/block/=
$bcache_device/bcache/sequential_cutoff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 0 > /sys/fs/bca=
che/$cache_cset/congested_read_threshold_us
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 echo 0 > /sys/fs/bca=
che/$cache_cset/congested_write_threshold_us

I created the scripts in a test environment and it seems to have worked as =
expected.

My question: Would it be a correct way to temporarily solve the problem as =
a palliative? Is it safe to do it this way with a mounted file system, with=
 files in use by users and databases in working order? Are there greater ri=
sks involved in putting this into production? Do you see any problems or an=
ything that could be different?

Thanks!



Em quinta-feira, 4 de maio de 2023 =C3=A0s 01:56:23 BRT, Coly Li <colyli@su=
se.de> escreveu:=20







> 2023=E5=B9=B45=E6=9C=883=E6=97=A5 04:34=EF=BC=8CEric Wheeler <bcache@list=
s.ewheeler.net> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, 20 Apr 2023, Adriano Silva wrote:
>> I continue to investigate the situation. There is actually a performance=
=20
>> gain when the bcache device is only half filled versus full. There is a=
=20
>> reduction and greater stability in the latency of direct writes and this=
=20
>> improves my scenario.
>=20
> Hi Coly, have you been able to look at this?
>=20
> This sounds like a great optimization and Adriano is in a place to test=
=20
> this now and report his findings.
>=20
> I think you said this should be a simple hack to add early reclaim, so=20
> maybe you can throw a quick patch together (even a rough first-pass with=
=20
> hard-coded reclaim values)
>=20
> If we can get back to Adriano quickly then he can test while he has an=20
> easy-to-reproduce environment.=C2=A0 Indeed, this could benefit all bcach=
e=20
> users.

My current to-do list on hand is a little bit long. Yes I=E2=80=99d like an=
d plan to do it, but the response time cannot be estimated.


Coly Li


[snipped]
