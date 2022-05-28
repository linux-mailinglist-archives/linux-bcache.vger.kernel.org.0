Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B1F536CC2
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbiE1MJl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiE1MJk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:09:40 -0400
Received: from sonic305-2.consmr.mail.bf2.yahoo.com (sonic305-2.consmr.mail.bf2.yahoo.com [74.6.133.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB231AD82
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1653739776; bh=H5L4m69rzGzQqjA7M5tyN77YTAw6uBdpg2oYX5DtiWM=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=HKfnMlpK5XTWsKWYNLAH88pGDnAQp8aSXCkVFkRl3aBxvURFpaBQhwRQJObUIdVsyj+AEmgVRyEzNqIXXQqw+XtgsIVFrRG1zkJvadr/yzcFl44la8QVpFKE5dWgUdvkfkDgiwAPqJv+evBtYPebFjBTp+oQ9l1TSdzBNFwr6V/AlpCiYIhloDeQbTXqqCL/9/aK+eV9bslFSiNQ4kvMz6hXnoiJOogHCF1UMUsd3ChJSMdUbgDLnyhwSRbPoFPV5+IuXxcqItBja0RrCROlx3mTUDW6aaGXxxERg7adBgzv0QnaqxX4viJNGPI63GFURzWIBwXuKzSkVMmFWyPukg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653739776; bh=WEcheklIH2n9la4KzTg9fMXd+AYiNySYWDlGFXwAQi1=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=bgJocDmzwSWSVWpWvjfbvuQbO3LVfiOZSAHGz3Wo3HW6CAKu/6zA5V/e0d4Ac1Sxn3d6tylihVhSAwGNoFNrwSLxM9lHFHIsFJ1xMlkYhspI4P0hUNnldkKmoavP+sQ8zo7JkoIiyy6bwvfUYytYQ6+Tk1C9xqpmvQSF2DrdHMvqet8BLeNvD7Pp+92v/4Cvh7rFc6AyTo6Dz7sPRk66HsWYf89g7E98sackxeotwM9b4ZjJPrjOPq+AWsvsvW/T4Uk2aht+oBMwUXepMhSTuMXJ1VoX1UPNBIVN41ydwg7KSuuv+IOQ8jB91/Y1wfakOLC+qimoyO3WEUnUSK5UBQ==
X-YMail-OSG: _CxJbtgVM1m3m4jvlbqNvGSzOQB7BQS0D8T0kvBygUJdKEn6umMBVJyjQWjynYS
 7N29ZsoL2F2CEpaiXsbqok4K8RlCfnLx9LcXFEmIXP7gaz2u5_CaA1lxKQiXvItTpfQ7gxRbVagn
 PWWTRX4QkByHlPrBt8Q_uR5pvEN3TPVdlwhRbim2_cAsR6Pai3ZApx9n9FxB_xI3SRGWLMzoq88D
 0YkdK9T2IH0ofV4mv_SehIxqwJs3N9Tb9zOhp5xtC4opbh1e7BK3T_VJmBIoVFhNzXrQ5JVLipCW
 1j.lUUS3FCI_11HpSgLR3wca6El9I84lQ7WGDLjwkiL7aLNxH0Y2T4lFNIBwo8zJkWUAASC7FtwX
 gz0Ql2xlhTosI9G_pwZAIlKwZlecH_7DSKh.6Hh26fK4ZPdzFwXj18G58hfNYEcIWg5HCMcFcQY0
 3.hgst.T5bxWQLCL1cwlXNFfYp.TbG_HV.2xp0C5gTIBSEGmib_KLpuEacEl3Ht1mwZOeXZKOVKg
 zMiggeGx.KussXbfZvCNZMYA_7ve0pr8qgzGAsiIkov85tyKalO2W5y9iKS_nm4ET9xadawFSbuL
 p5MTNSFyxZTV8LAympLFjjAKv7ByBrrf_FjRLH19g4V5Y3j_d5yF3__8u_SKtLSywVdRH0dYEzK_
 TcNwuuar5lKyX8l8fnTTibQmBp6gnS7wMhqZKO2R_iMCzaJpvJbWcRKdLTqmExRIo6..tEseTFoP
 DBEuLyVTZBJ8F1cKhx8dYZJvREANvaywcekpTTkhbpAq1o47wo14EcLVnIoZdcMGSt2F8O.9RQKb
 ueishqhCQMdquH7ku7RWTTyY.8iXAeVobpFe4.jneDyOy9KXuYIWd7jz3oQ.BFvV2E6saEjMb6_s
 pOeLaRkahDGewP3Jh22.v06KvxkfcN90nWtjrJ7fTvJpaIHMLKcj7C02Z2lTjtE5SKEntiK0rnAI
 3ou7TlMdn2lT8_gaK.PhdQacFYRvcQYp2wp6A0MlvO9acKB3_jVWRiYFb8egizoyMW5n5bEbWOoq
 mfY1_BHVg_FM.cf.keoAlmYYWaqOK1GC4z2lVGumjJQ_MqszgXaxsslJlb0kmfcjeoRoyd93lK8j
 iBIS0vXzgS0_BFz7y9ppXV8IBAllzwmkikr83RrnPxGpIP_7aBKXoQfuPCiYCreIIk_lfCCflY_x
 pK92hLXXBHSnT16wt2rxbivo7QQxQ0Gx6e6VdXVpGbvykGbPQpsG6XWUFpgSJ6mwPKt17zZUw381
 M1bg91tQX3k22oThKei9_6EeUaTAij1XPYUaFSlm0gIiaL8Rg1IT2BVgRvXtUQ7z1Rm9iRtMfwMh
 zyJBTlMPNhWCOS_JgfOd6BpmDEYCueQrhWcptAjGbJGmxm5b38RredpOQn8t4.DZWlCnse54tEtM
 7rGLSFB0.V7cZI6e8fw9mrufBzR2mnIbjlb2HKxy_GUXpj43qGUd3bsmZN2KI6GMp862Jeb8dNH.
 UuRYr_ez_z3D8Q3YLDNWqIKZFSQFTiyHnmv5HNNzxRciwcd6wOsxkhabgpGWIv3LSWyHhgxDVJ76
 Blkh.w5nMefLZamfD..r7ZfcAb26mjyu8Wm0CWzEtwq0dASe3mKEJxowZe8uQ4pwzgzv94gjDgCT
 65AACKfJc1b0XkACySvfoZtzTfga0yuZ._XrWv8s481heO2GkuUvuMHvCA4gio2Sc5m0MNf9TqEL
 gI5sTFPR3lCToSp_cjrDpQsm59LWu6mzh3irCN1N4SwqG56pXwzUhLVOL8GjxXhn9r6IlP1PPpbe
 UdJRpJFPenHpnwQGjYnNSYVTwTr8kYZJ3YKOdEfZfpZNmsJ4cS8Hiy2ZYpM7VuPAPNgJnXaytqMA
 6rFbUe5qavh_v7fOSZ4mVSxLAW5fkKqqph5W9vf3WI8nLfCty6sMqfX9r4HXbr4GMuU58YZEMQE6
 NHxbITOK42dl50NdoiLloIbuA7Oxz8FDlbPDqMaROZz5zMGPdChJg7evuaZ4kT3EqEnlwSdcQaTC
 NG5B5oI.VvzDlP8pf0I7UzG60z86iipo4LH2ZExBfRjlc12HGCDwB7rnLaeKed6ZUQlX_vIpRChH
 nPLeJeiREFYRxFQS_6xFCRTTcUumAcyvx1XXWfOCtBvHhbiqJhnLaWeTIq5Een0JUjS.9aNORkS1
 GZyYXwwIzd3kKzbK2cm4dwzUZOb5fJtL2Whxm97H0OCEjgAJMQe7uJfrYGXR1tpyhssBEBrLawig
 Xpd6B4psjd2azEFnTAuTL3TaCtHT3avPuMFHzr9F3z899QmzWCckdrAzZkHM1HQ--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Sat, 28 May 2022 12:09:36 +0000
Date:   Sat, 28 May 2022 12:09:02 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Matthias Ferdinand <bcache@mfedv.net>
Cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>
Message-ID: <1978768894.2323492.1653739742429@mail.yahoo.com>
In-Reply-To: <YpHNts38gQMJspip@xoff>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <681726005.1812841.1653564986700@mail.yahoo.com> <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net> <532745340.2051210.1653624441686@mail.yahoo.com> <5b164113-364b-76a8-5bcc-94c1cec868db@ewheeler.net> <YpHNts38gQMJspip@xoff>
Subject: Re: Bcache in writes direct with fsync. Are IOPS limited?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.20225 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Tankyou Eric, Matthias, Coly..


> Disk controllers seem to interpret FLUSH CACHE / FUA differently.
> If bcache would set FUA for cache device writes while running fio
> directly on the nvme device would not, that might explain the timing
> difference.

Matthias,=C2=A0thanks a lot for helping!

I believe this test was not aimed at the Ceph context. Although my ultimate=
 goal is to run Ceph (this you are correct), Ceph is still off.=C2=A0Turnin=
g on Ceph will be my next step, after getting a solid cached device setup. =
And these direct and synchronized disk-based tests is useful for Ceph, but =
also can be useful to get an idea of =E2=80=8B=E2=80=8Bhow it will work for=
 other applications too, such as an Oracle database engine, PostgreSQL, or =
other database engines.=20

On the other hand, I believe that this result is obtained by the fact that =
an enterprise NVME with PLP (Power Loss Protection) is very fast for direct=
 writes. More than expected from OS caching mechanisms. If I'm not mistaken=
, the test was about the OS caching mechanism.

Eric,

I don't see big problems in creating the bcache using -w 4096. But there mi=
ght be some situation that it degrades the performance trying to write in 5=
12 Bytes, as you said.. This can worry in production environment?

Anyway, the performance even using -w 4096 was still way below the native N=
VME performance. Is this because of the metadata headers?

I noticed one thing via the dstat tool (seems useful for checking the data =
flow and the flow of I/O operations to the devices in real time):

For each write of a 4K block to bcache, it results in a 16K write to the ca=
che device (NVME). This seems to represent that bcache writes an excess 12K=
B (three times the size of the 4K block) as a form of header, metadata, or =
whatever, some useful mapping information from it, for each 4K block writte=
n. That's right? Is correct?

If this is correct, it might explain why I still only have 1/4 of the perfo=
rmance of NVME writing 4KB blocks, even if I format bcache with -w 4096. Be=
cause if for every 4KB block I write to bcache, it needs writing 4X that sa=
me amount of data to the cache device, it's obvious that I'm only going to =
get 25% of the hardware performance.

That's it ?

Another thing that's intrigued me now, is the difference in performance of =
bcache from one server to the other... Although I believe that this must be=
 some configuration, because the hardware is identical, I can't imagine whi=
ch one. I even hit the memory to be the same on both machines, even the SAT=
A position of the disks, so there is no difference. But even so, the second=
 machine insists on having half the performance of the first, just in the c=
ache.

And again by dstat, I verify that there are zero Bytes written or read to t=
he backing device, while 4K blocks are written to the bcache device and NVM=
E hardware. And that's correct, I think. But at the same time, dstat indica=
tes that I/O operations are taking place to the backing device. And this do=
es not occur on the first server, only on the second. It seems clear to me =
that this behavior is halving the performance on the second server. But why=
? Why are there IO operations destined for the backup device with "zero" by=
tes written or read? What kind of IO operation could write or read zero Byt=
es? And why would they occur?

This is one more step of research..

If anyone has an idea, I'd appreciate it.

Thank you all!



Em s=C3=A1bado, 28 de maio de 2022 04:22:51 BRT, Matthias Ferdinand <bcache=
@mfedv.net> escreveu:=20





On Fri, May 27, 2022 at 06:27:53PM -0700, Eric Wheeler wrote:
> > I can say that the performance of tests after the write back command fo=
r=20
> > all devices greatly worsens the performance of direct tests on NVME=20
> > hardware. Below you can see this.
>=20
> I wonder what is going on there!=C2=A0 I tried the same thing on my syste=
m and=20
> 'write through' is faster for me, too, so it would be worth investigating=
.

In Ceph context, it seems not unusual to disable SSD write back cache
and see much improved performance (or the other way round: see
surprisingly low performance with write back cache enabled):

=C2=A0 =C2=A0 https://yourcmc.ru/wiki/Ceph_performance#Drive_cache_is_slowi=
ng_you_down

Disk controllers seem to interpret FLUSH CACHE / FUA differently.
If bcache would set FUA for cache device writes while running fio
directly on the nvme device would not, that might explain the timing
difference.

Regards
Matthias
