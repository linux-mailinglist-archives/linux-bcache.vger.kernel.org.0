Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2800D53ADCB
	for <lists+linux-bcache@lfdr.de>; Wed,  1 Jun 2022 22:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiFAUnA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Jun 2022 16:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiFAUmh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Jun 2022 16:42:37 -0400
Received: from sonic313-14.consmr.mail.bf2.yahoo.com (sonic313-14.consmr.mail.bf2.yahoo.com [74.6.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C7C1D5A93
        for <linux-bcache@vger.kernel.org>; Wed,  1 Jun 2022 13:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1654115015; bh=Sj6cWzijNiLid1l5f1mucnt70q4+kCaKcJx1W31WgJY=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=kelUgNfX+j9oZKQ75Rv1q0P9IqGiE/vQBQ8wubTapZamumaWE6j9WwvqcuzAUUWxV4gTSywLfp+ww4ZbCS1wjGgfkV+LaH7LkExALo6WxgtCXjVyO4Ez3n+i2+MTAjwZAc/Vz+FCGIxCz8zBnjNPFwHkB0e6LC6NIjT/GIZjnH6E+wowKCaf2MO2tO7kao3na4EA62qXL6KL8m4sPtoHjYNGTcrZa6VMNRKWFSpJgSnvOVOleb8EwRXXZyLPIEbvFTQDuHv7H3CCXmInHSIUdBPEWrkKANQzApNikPls3kDc3vJ6p/8Rqs8+y+FsD3s4jdpV+rnFt3d0n+ODxfjdrA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654115015; bh=gzEbTFRIc3czt4heI80WPEghOTlb9Q+4vZEon2X1QzS=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=rfWOE5AOLPTUne8XPHPbndDHgbTBxTfnmExM0sVKDY4wCD1ZcE6HCs7TOi8g4aMzyiPlazMY21z+gJJzvGnN6Mvw/PP0qdvmmDWzYkbsgYl9D+aaRfzq2l6QoJj6eRBK4tgtsgRaG61DNhhw3RIBKMArnFA+yRysB3BoxXgE9aUwaOL2TWiyTfdRtu/Ty6cz4Nw3mgny1paf2n7ievS2MbSbCcWEObJThwR7bysh+5AG4A38bX4m0ZKxsade+J+jxrANO4T6Ykt4aGzjHyiSSZCW7+Lrjho3a+k+8c98R3cSEXPlf3Q2GjB4OVC9RWpEg6jqVQddhGfsuoFJVEsfWw==
X-YMail-OSG: 4nhryFkVM1kvrMoSs3HItA5Nr3t7j6Nprmu_It7ZuS9mOtA7r9qXBNs1A3rZ2M3
 sBGMNGnE4Drhj68kML8qJC7B8dhWet14tx.0RgzIHdBxSAYXV1K1fwFUxtZOLK0imI5vbVizxc6w
 FQ0CKMKIOq1gz9I7JchQA04LXYrM0FbETY9BgCJtGDcwFYcT0rwpXzkfddsZxwfzf2CZZwEvbjz8
 ISddNiZgSow97KEMM1_qZh9u8EWqOJDjcx0J650NSeA3QnMkZUxtLs7rbhPo2qHCC8QaMd.uozFk
 Q1LnN5bSfoJEPnFZ4yrt0z9A6jjzfQRsf1lJ8ICxM9QvckJs.XRaKFWGK0m5DDW6Qvwp.g0QwGLw
 63dn8p9K4PANe50rPD8U.7bmDnDdUzdA41bLZbH2RHXQxdITUnHkAryGaapryCKwvEQvISKTkrZ4
 TEsduDd2rF7qve08Hr3V5Is8kGtNGAWXZAc02pzjrtVF5AXWvzZqFFwxg.XDg.Pyu7VKB_NSgr_4
 Rau54zqLhC6qESZkf1xe6oGRVGRLk1Ex54JZInjarZIBUmNJZZOLnCRw4wWxK96.z2a6CoHFtD5t
 qmkd91gyaij551gfLb4Xtaca62md1LWWySAArtPiKn1lpsz8DgkZCKewMMylb3vxNF37Tu.oegxi
 sD.7Xt5X24BUKag62x1GOvMfY2Ne6DKhTPo4iic9zJdqoz1JiUklJHjZRXdceWSYlZp4NP8yKCGA
 kxvv1V9v1upvcghU4_sqmjzMBU9RZgtZ5YviK8VtG.8Y0HxFd_PKBL3.m0XMUTVSzpfxmzfBpkYS
 uDqSXdx12VriAXJHobOGvqvCLlbcqETav.o1Mi26J5bbsZXsoeXHI4zx.iTE8eQUCl3XeBguqJLx
 .UkXAo1u.sKIkacei8vAxLByBxHC0U2_S.RQGqqeLttQKLvAgZ26YEWFZ5eo3ztzcCMN4WpeCR87
 czBokzNcwMppDJaQZ0.GMLoGozQ0.JxiGcMiKEhXMCGosC82VpH0ULNW.mr79jp9L6s2XaE1ExI6
 fPLJEpYek1OpzY.leKeo_KJL7T523oJoFHvBcUWykIPaaTRrKKlLFdoRK9PBP8EPbt_hvuEXcMz5
 hs.FmEEHbVoJS6fUiw3sBknDKma.TsaW3LDLv.2sR2FwP5qQZYdM2qN.ve5Aj_vG715jFnREceEF
 CXTx7k2jMe7DaszRswd42BpsheiTXAB3r0Huo2722yga3Rb4fW1M8WnXl1zt8fgnSxSulABTWFzw
 8iklNiQKhtUGejtYrDMgn2NmlU90T0EpCkn90873b2Fy3t3vID7ho_70RaCmViGXJzb5LlNAUtEO
 5KuX.P5RomOlm.B0NaFHuYTpaFdIF.EVoaikj4YLYJWXGszeOI3AubpTMR0y0m25g.i6YaWgNb4P
 jz.AsGZZMdLEh51YEneSmkg3aYfHoM2evZVmdc4XsBxKbsCLBnkLp_r8ymMdDszPDhVR0Nfy8w5c
 gz1lxKGa3b2Aw1dsn9VQQL9_R.348LnJGwXcXp35nEYhEPzh7kwTRHXJUBDjkaQX3AHcBoBYJFSS
 zr6vv6lyFLt0V4UicCjo74GrtA75rcGf9yoKzXIXeBk8djKBTzsYTPg8dYDoOXK6lERebux2zH8i
 LzUNZa.qeE0zReZTKQM0ulqhNsR46Ouj7oJ6MG5c5_lFouA28zFScLrTWLIfQTqc19ibx2vG0DsA
 ULvByLt5N3oUIS1fzK5oBnh0MP6EyuWeGVAvEGjXfiNVm128BeGrtL7IlLbzuKsxKhIyXn5k4Bep
 McIkfMuYwAjJBItMiHE.DDLrSEo7lmm8Theot9C3hrmzIMRCDnfD7AScKISzb9QyEMdn92DCbqLR
 l5wjwbzO20jf3ubFNKxsAcwkzOrX5CJ2HE51zWuC_mlMncKhi.WI5gW0cBrnbg4.tyryV_i6J5na
 aPyaUYBVa14CrN52QBoPz5WrmL0AWxK8jlc_UVUDfRaRBABCc2bdtbTbLEwghUWMmo0JMbMprwgE
 SC1JeDR22Pn983bFWSN6B.BFEwvFDWt2hhe.xGYdJ5qBDvq0ZFi4SuqfIYxVh0ZIpxTklwq_h2qw
 iTRntU_RIxEm2UHHR3qLCNWW5qJlN1Fpb36mGy1GcPYJB.XkAbZisCR2nUGBT9Fp7jfZzQM66p4H
 QGnxcnDORoVhdZ3.PXQjFXzsX_eSa0vKpGyNcqmFkyEzRAIxFJ4e79Yx8kqqah9uE2caJSQojpjB
 _kUFFKT.BCAdZLm7zsAS50jSG
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.bf2.yahoo.com with HTTP; Wed, 1 Jun 2022 20:23:35 +0000
Date:   Wed, 1 Jun 2022 19:27:37 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Keith Busch <kbusch@kernel.org>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Message-ID: <1295433800.3263424.1654111657911@mail.yahoo.com>
In-Reply-To: <YpTKfHHWz27Qugi+@kbusch-mbp.dhcp.thefacebook.com>
References: <YoxuYU4tze9DYqHy@infradead.org> <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org> <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org> <24456292.2324073.1653742646974@mail.yahoo.com> <YpLmDtMgyNLxJgNQ@kbusch-mbp.dhcp.thefacebook.com> <2064546094.2440522.1653825057164@mail.yahoo.com> <YpTKfHHWz27Qugi+@kbusch-mbp.dhcp.thefacebook.com>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.20225 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Tankyou,

I don't know if my NVME's devices are 4K LBA. I do not think so. They are a=
ll the same model and manufacturer. I know that they work with blocks of 51=
2 Bytes, but that their latency is very high when processing blocks of this=
 size.

However, in all the tests I do with them with 4K blocks, the result is much=
 better. So I always use 4K blocks. Because in real life I don't think I'll=
 use blocks smaller than 4K.

> You can remove the kernel interpretation using passthrough commands. Here=
's an
> example comparing with and without FUA assuming a 512b logical block form=
at:
>=20
> =C2=A0 # echo "" | nvme write /dev/nvme0n1 --block-count=3D7 --data-size=
=3D4k --force-unit-access --latency
>=C2=A0=C2=A0 # echo "" | nvme write /dev/nvme0n1 --block-count=3D7 --data-=
size=3D4k --latency
>=20
> if you have a 4k LBA format, use "--block-count=3D0".
>=20
> And you may want to run each of the above several times to get an average=
 since
> other factors can affect the reported latency.

I created a bash script capable of executing the two commands you suggested=
 to me in a period of 10 seconds in a row, to get some more acceptable aver=
age. The result is the following:

root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write back=
' > $i; done
root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
write back
root@pve-21:~# ./nvme_write.sh
Total: 10 seconds, 3027 tests. Latency (us) : min: 29=C2=A0 /=C2=A0 avr: 37=
=C2=A0=C2=A0 /=C2=A0 max: 98
root@pve-21:~# ./nvme_write.sh --force-unit-access
Total: 10 seconds, 2985 tests. Latency (us) : min: 29=C2=A0 /=C2=A0 avr: 37=
=C2=A0=C2=A0 /=C2=A0 max: 111
root@pve-21:~#
root@pve-21:~# ./nvme_write.sh --force-unit-access --block-count=3D0
Total: 10 seconds, 2556 tests. Latency (us) : min: 404=C2=A0 /=C2=A0 avr: 4=
28=C2=A0=C2=A0 /=C2=A0 max: 492
root@pve-21:~# ./nvme_write.sh --block-count=3D0
Total: 10 seconds, 2521 tests. Latency (us) : min: 403=C2=A0 /=C2=A0 avr: 4=
28=C2=A0=C2=A0 /=C2=A0 max: 496
root@pve-21:~#
root@pve-21:~#
root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write thro=
ugh' > $i; done
root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
write through
root@pve-21:~# ./nvme_write.sh
Total: 10 seconds, 2988 tests. Latency (us) : min: 29=C2=A0 /=C2=A0 avr: 37=
=C2=A0=C2=A0 /=C2=A0 max: 114
root@pve-21:~# ./nvme_write.sh --force-unit-access
Total: 10 seconds, 2926 tests. Latency (us) : min: 29=C2=A0 /=C2=A0 avr: 36=
=C2=A0=C2=A0 /=C2=A0 max: 71
root@pve-21:~#
root@pve-21:~# ./nvme_write.sh --force-unit-access --block-count=3D0
Total: 10 seconds, 2456 tests. Latency (us) : min: 31=C2=A0 /=C2=A0 avr: 42=
8=C2=A0=C2=A0 /=C2=A0 max: 496
root@pve-21:~# ./nvme_write.sh --block-count=3D0
Total: 10 seconds, 2627 tests. Latency (us) : min: 402=C2=A0 /=C2=A0 avr: 4=
28=C2=A0=C2=A0 /=C2=A0 max: 509

Well, as we can see above, in almost 3k tests run in a period of ten second=
s, with each of the commands, I got even better results than I already got =
with ioping. I did tests with isolated commands as well, but I decided to w=
rite a bash script to be able to execute many commands in a short period of=
 time and make an average. And we can see an average of about 37us in any s=
ituation. Very low!

However, when using that suggested command --block-count=3D0 the latency is=
 very high in any situation, around 428us.

But as we see, using the nvme command, the latency is always the same in an=
y scenario, whether with or without --force-unit-access, having a differenc=
e only regarding the use of the command directed to devices that don't have=
 LBA or that aren't.

What do you think?

Tanks,


Em segunda-feira, 30 de maio de 2022 10:45:37 BRT, Keith Busch <kbusch@kern=
el.org> escreveu:=20





On Sun, May 29, 2022 at 11:50:57AM +0000, Adriano Silva wrote:

> So why the slowness? Is it just the time spent in kernel code to set FUA =
and Flush Cache bits on writes that would cause all this latency increment =
(84us to 1.89ms) ?


I don't think the kernel's handling accounts for that great of a difference=
. I
think the difference is probably on the controller side.

The NVMe spec says that a Write command with FUA set:

"the controller shall write that data and metadata, if any, to non-volatile
media before indicating command completion."

So if the memory is non-volatile, it can complete the command without writi=
ng
to the backing media. It can also commit the data to the backing media if i=
t
wants to before completing the command, but that's implementation specific
details.

You can remove the kernel interpretation using passthrough commands. Here's=
 an
example comparing with and without FUA assuming a 512b logical block format=
:

=C2=A0 # echo "" | nvme write /dev/nvme0n1 --block-count=3D7 --data-size=3D=
4k --force-unit-access --latency
=C2=A0 # echo "" | nvme write /dev/nvme0n1 --block-count=3D7 --data-size=3D=
4k --latency

If you have a 4k LBA format, use "--block-count=3D0".

And you may want to run each of the above several times to get an average s=
ince
other factors can affect the reported latency.
