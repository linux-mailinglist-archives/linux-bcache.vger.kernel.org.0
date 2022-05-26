Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B980535459
	for <lists+linux-bcache@lfdr.de>; Thu, 26 May 2022 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbiEZUVi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 26 May 2022 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbiEZUVh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 26 May 2022 16:21:37 -0400
Received: from sonic302-3.consmr.mail.bf2.yahoo.com (sonic302-3.consmr.mail.bf2.yahoo.com [74.6.135.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92E0226121
        for <linux-bcache@vger.kernel.org>; Thu, 26 May 2022 13:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1653596493; bh=r8pUdLcyAnM3V4B01jph4FPhG2xhlcSdV2orA9IoRTQ=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=lo5Zzj77mI852NZMxd50FMSeLb+hasrIAzYYuf7q288LsTnBf5fT1blEBIKJozkfJosVnmTm3JLfaDAhpHnLcpL6TzBMcdAaWo2jotxykthgFqIXNGwhDzZ+ApqrFgsugqu3L5dtP/9VGYro5/0n2gItLb3sshBzAJoHxYfE3xDl9gjMKEdiw4vuFa8GBgbSovg0qSIxQFvdP7+pUIAYek0egS1yyZgVKnl5ByyuCC4pldpK6y4PXcDbNCnlp5lkG9JnPtYqswtoiSa11MbRC86+9Ah/Ww9On0oDUnRu5Gi9VDpXuoSPr8DKfnrctr+SgcQE97xIVMDCagF0NVCtvQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653596493; bh=ZrUiV0ibLp7RCfLacEzmYn6ibgMKRGFqf2uoHYgh4fJ=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=Aal9jP3MbhJx5dSt6Yn5Y2+N2xD/OAD3Fa/LP1mplQrYXQKCUHnsBGuy8FrW1gCEYL9khYhac+4+HvUoADaoTxcBbfQp35aGJvVpa/Ff7ZRgq9SMxLX00v88dT1/KmRYGVIQH/vyTpoA8B/q5UAvH5i8pjDv2tqqPGTuKK2Y6CtgaFhPX0nOGl4xk1zllGJ9zCbx184izkq6NGwUHWvPUHdtDOeLV1nVJUkRJoicVqvxqnHTBxroDGQdnqmgRU408ElmbSwYxUpJ69kuvjg/sKoT1F3EbVLglDsXKmxSmDW9/3guvsdgTO1oMdUoswLLZdfKai7v3oJoI+tzGLNs+A==
X-YMail-OSG: 82Pb6TcVM1k8ToT3YuPJmnl4vKIt0ez5yyFqf1Vd4ouMm_W1OEN0pTxVMJCIf5d
 qV4SdvrivWu3JI1mfL4Us3NVtS94DJqsfCHkLxWcJI7X53mp7mCTWtYJpR6vh6KuSwPBeGwk7qOi
 x_n_q6kuTkBq7UnXIALieJFkZJauCS6byOHbZZ_8gi1h0piEMQ8vpOcjGgifJeXH87dr38I6h8VU
 7Aa1NXiSGehFJazmQslyRwkQgjwcejLFxspXo41dufh9it0qp1d6PaovLLTeHnCFwCzxJ0soHs8t
 NThOYTtcH3aKgZxwKTgleNYQUJNIqxoyjApW4fE8ujBIwTveILRxQ7oF2D4dxPCIvOSqXVzGSHI2
 J8TM6GEcX8XXwDKx9vUWxXpBoyG2OMogztu8Lbn3myruByOMoMrwDHpgY4j8B3AHXxLiiRIVFBNf
 jLPvQ6Z8DA96ulhzdYCyGnm0Bv96YI3mdUdmyUOtLFFQ_.uVu6I5D35iyQA3JGj_3fqZyC.Q6CPl
 kb5F4gRugTXa0bm6vwd0YCoNJtJfAhS7VqPSMmVJdTxVKV4y_jcR6sxyjvneqKD0.2Ove8auhYFJ
 ozkP9ZetHN6aXzAXlPKiwPGpFS.MFhYGlwAHNvoBEZeGV6_rT84xdS5WH2naYWduGLnrdiAcuSYm
 L9NHh2nUgKdIEG_6wEo48lJI9fxNl85kClALESa143u_zybMvsvMQrq8QzBTciAeePY1pctK1Zd0
 WEndoyk9GOUpHLwh2y7hMCrsTp3Y4bLfZSxbse7hTFC1woinCxXClNgA1pKMCCgO0Lmn6q1VH.Mz
 wtfL6BIPPeDci7W314P5My8oOA3bh2zP13bKj.99GiYIJvF.BQZcySjD.TSTGId5A1UOXTqHU00p
 srq3TN_dRoltui1WMPspY29O_pFdlCg2kMsFFqNXfslezjhTWA1zYPX5W.yQQs6YoF11TxVnCBnc
 0dMXhL9J0_2UKIti_KejThp_7.f.a8noMUF9AWjGn7xZp0k1_nxIQNB3HkaierzmKV4oxuKfjZLN
 RbdeM9gDn2uhSSlZLYmv2ikEEkBZl9nPcbFyw1sgHU3d3nWZiO3IDaIUO5ltldlgjAFQNtagVC6q
 2BAA8f2sJsHVLiIAm1Q3FESHT1l3RvQRMhUkNIMW2jtUQDTOPFnlpFIRJCY.QjJUSZdZzm2oV8qB
 Rbngf_cmzw25ga6lk51yxOfc_UGeXrdR1OiImrr.e5k9xHA.Cq8Iau2ldOAJ0ctueVotuXPCfD6v
 xqWRLgb8mDCyy2prDIKaz6Oo.hb_G.rEDAR64a3qOXxBThhkdXzZjT068IG_NxFUBaRNWWngUKyx
 1.RNbckCTAv3whIgph7KV_7LxFd155LaXyO34LIbiTI_W3XbIV8EQ76R4.uhkqYDKwUNwHvSqahD
 ef800GViyDSsQpBMcmJ7CwPSYSqJWHD4.y9UBqhgpsFSITHVMee0xjSWjQXTwJDEE3ColQ3D5CKN
 T6A3obSVXYDAI9yHFMluPgFAvzPIcWgygeFkbdpXUIUcAgrBpbCHOyeAXf8yWb9WA19ojZvM8S.h
 c6nW68sapVsjAsXYap8R0k0cVgxiNFqBO.7fr3eib53Di5psiphZPz8SKpE4IReyypW33zid90hb
 vyHNvZH7UxrJbaizWHRzBmXTktljCDLP6PrfiUl9hXqNc1shWIqCKb2ag9YQYTWRbUdHex46VI3w
 4JMwSqsQ0JIejan8nUtQjPpbU.Zdjtj_HPeKx7X2Ces84bKPMyDQ52aOgtt3propD7BIlM.jDl0n
 VMiOX2_9bOvuYkRuPkjlfO_aVpDpEIT1QyZqhmo8Act6bv6AhXccuEjinScLxObmao1VY50_9nQQ
 rlmSEd5YC.iGLjfBmHkEwXKTANnFTCu6h1JT45ANPKptk2XrzBsWIqEKitKG7WTdw._hTrDddAs1
 1BCMEXXQSjr.bgqly2kLkepjgs_pK4x0OxQuyJD7QJsp1mF3xkwijdCyvf532XCiEthiLB.nf9gF
 px9TkonNt2xzcDbrV9MAWSW_DaYohKM_vGYAwhItsL7q.TdEVN37CGJrt57iUB8jGCGTTsIrfEbS
 Xe8Z6bNS0Q06P4xbFrWXLp4Evcl_38cMNbllQ91fkMoRCUVR26RtRsVH191.W5QYMwS.6eDJBzwY
 ThB09Pz_XOrey3M4GM8EWPRBG7TRoj6zgcH7kFEMxih48ZrVKG_Dld.seH_IemaQeNgwFeFFqvla
 Ap6KrqSnc.7_FQLNr7RenHZghsmRzoKVhxETBn6xdVQ2_DJY6a8C4sTqE5Q--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.bf2.yahoo.com with HTTP; Thu, 26 May 2022 20:21:33 +0000
Date:   Thu, 26 May 2022 20:20:09 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>, Coly Li <colyli@suse.de>
Message-ID: <906613199.1970273.1653596409423@mail.yahoo.com>
In-Reply-To: <681726005.1812841.1653564986700@mail.yahoo.com>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <681726005.1812841.1653564986700@mail.yahoo.com>
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

Hi People,

Thanks for answering.

This is a enterprise NVMe device with Power Loss Protection system. It has =
a non-volatile cache.

Before purchasing these enterprise devices, I did tests with consumer NVMe.=
 Consumer device performance is acceptable only on hardware cached writes. =
But on the contrary on consumer devices in tests with fio passing parameter=
s for direct and synchronous writing (--direct=3D1 --fsync=3D1 --rw=3Drandw=
rite --bs=3D4K --numjobs=3D1 --iodepth=3D 1) the performance is very low. S=
o today I'm using enterprise NVME with tantalum capacitors which makes the =
cache non-volatile and performs much better when written directly to the ha=
rdware. But the performance issue is only occurring when the write is direc=
ted to the bcache device.

Here is information from my Hardware you asked for (Eric), plus some additi=
onal information to try to help.

root@pve-20:/# blockdev --getss /dev/nvme0n1
512
root@pve-20:/# blockdev --report /dev/nvme0n1
RO=C2=A0=C2=A0=C2=A0 RA=C2=A0=C2=A0 SSZ=C2=A0=C2=A0 BSZ=C2=A0=C2=A0 StartSe=
c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=C2=
=A0=C2=A0 Device
rw=C2=A0=C2=A0 256=C2=A0=C2=A0 512=C2=A0 4096=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 960197124096=C2=A0=C2=A0 /dev/=
nvme0n1
root@pve-20:/# blockdev --getioopt /dev/nvme0n1
512
root@pve-20:/# blockdev --getiomin /dev/nvme0n1
512
root@pve-20:/# blockdev --getpbsz /dev/nvme0n1
512
root@pve-20:/# blockdev --getmaxsect /dev/nvme0n1
256
root@pve-20:/# blockdev --getbsz /dev/nvme0n1
4096
root@pve-20:/# blockdev --getsz /dev/nvme0n1
1875385008
root@pve-20:/# blockdev --getra /dev/nvme0n1
256
root@pve-20:/# blockdev --getfra /dev/nvme0n1
256
root@pve-20:/# blockdev --getdiscardzeroes /dev/nvme0n1
0
root@pve-20:/# blockdev --getalignoff /dev/nvme0n1
0

root@pve-20:~# nvme id-ctrl -H /dev/nvme0n1 |grep -A1 vwc
vwc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
=C2=A0 [0:0] : 0=C2=A0=C2=A0 =C2=A0Volatile Write Cache Not Present
root@pve-20:~#


root@pve-20:~# nvme id-ctrl /dev/nvme0n1
NVME Identify Controller:
vid=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x1c5c
ssvid=C2=A0=C2=A0=C2=A0=C2=A0 : 0x1c5c
sn=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : EI6.........................=
...D2Q=C2=A0 =C2=A0
mn=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : HFS960GD0MEE-5410A=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0
fr=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 40033A00
rab=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1
ieee=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : ace42e
cmic=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
mdts=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 5
cntlid=C2=A0=C2=A0=C2=A0 : 0
ver=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 10200
rtd3r=C2=A0=C2=A0=C2=A0=C2=A0 : 90f560
rtd3e=C2=A0=C2=A0=C2=A0=C2=A0 : ea60
oaes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
ctratt=C2=A0=C2=A0=C2=A0 : 0
rrls=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
oacs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x6
acl=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 3
aerl=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 3
frmw=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0xf
lpa=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x2
elpe=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 254
npss=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 2
avscc=C2=A0=C2=A0=C2=A0=C2=A0 : 0x1
apsta=C2=A0=C2=A0=C2=A0=C2=A0 : 0
wctemp=C2=A0=C2=A0=C2=A0 : 353
cctemp=C2=A0=C2=A0=C2=A0 : 361
mtfa=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
hmpre=C2=A0=C2=A0=C2=A0=C2=A0 : 0
hmmin=C2=A0=C2=A0=C2=A0=C2=A0 : 0
tnvmcap=C2=A0=C2=A0 : 0
unvmcap=C2=A0=C2=A0 : 0
rpmbs=C2=A0=C2=A0=C2=A0=C2=A0 : 0
edstt=C2=A0=C2=A0=C2=A0=C2=A0 : 2
dsto=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
fwug=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
kas=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
hctma=C2=A0=C2=A0=C2=A0=C2=A0 : 0
mntmt=C2=A0=C2=A0=C2=A0=C2=A0 : 0
mxtmt=C2=A0=C2=A0=C2=A0=C2=A0 : 0
sanicap=C2=A0=C2=A0 : 0
hmminds=C2=A0=C2=A0 : 0
hmmaxd=C2=A0=C2=A0=C2=A0 : 0
nsetidmax : 0
anatt=C2=A0=C2=A0=C2=A0=C2=A0 : 0
anacap=C2=A0=C2=A0=C2=A0 : 0
anagrpmax : 0
nanagrpid : 0
sqes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x66
cqes=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x44
maxcmd=C2=A0=C2=A0=C2=A0 : 0
nn=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 1
oncs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x14
fuses=C2=A0=C2=A0=C2=A0=C2=A0 : 0
fna=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0x4
vwc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
awun=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 255
awupf=C2=A0=C2=A0=C2=A0=C2=A0 : 0
nvscc=C2=A0=C2=A0=C2=A0=C2=A0 : 1
nwpc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
acwu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
sgls=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
mnan=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
subnqn=C2=A0=C2=A0=C2=A0 :
ioccsz=C2=A0=C2=A0=C2=A0 : 0
iorcsz=C2=A0=C2=A0=C2=A0 : 0
icdoff=C2=A0=C2=A0=C2=A0 : 0
ctrattr=C2=A0=C2=A0 : 0
msdbd=C2=A0=C2=A0=C2=A0=C2=A0 : 0
ps=C2=A0=C2=A0=C2=A0 0 : mp:7.39W operational enlat:1 exlat:1 rrt:0 rrl:0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rwt:0 rwl:0 idle_pow=
er:2.02W active_power:4.02W
ps=C2=A0=C2=A0=C2=A0 1 : mp:6.82W operational enlat:1 exlat:1 rrt:1 rrl:1
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rwt:1 rwl:1 idle_pow=
er:2.02W active_power:2.02W
ps=C2=A0=C2=A0=C2=A0 2 : mp:4.95W operational enlat:1 exlat:1 rrt:2 rrl:2
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rwt:2 rwl:2 idle_pow=
er:2.02W active_power:2.02W
root@pve-20:~#

root@pve-20:~# nvme id-ns /dev/nvme0n1
NVME Identify Namespace 1:
nsze=C2=A0=C2=A0=C2=A0 : 0x6fc81ab0
ncap=C2=A0=C2=A0=C2=A0 : 0x6fc81ab0
nuse=C2=A0=C2=A0=C2=A0 : 0x6fc81ab0
nsfeat=C2=A0 : 0
nlbaf=C2=A0=C2=A0 : 0
flbas=C2=A0=C2=A0 : 0x10
mc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
dpc=C2=A0=C2=A0=C2=A0=C2=A0 : 0
dps=C2=A0=C2=A0=C2=A0=C2=A0 : 0
nmic=C2=A0=C2=A0=C2=A0 : 0
rescap=C2=A0 : 0
fpi=C2=A0=C2=A0=C2=A0=C2=A0 : 0
dlfeat=C2=A0 : 0
nawun=C2=A0=C2=A0 : 0
nawupf=C2=A0 : 0
nacwu=C2=A0=C2=A0 : 0
nabsn=C2=A0=C2=A0 : 0
nabo=C2=A0=C2=A0=C2=A0 : 0
nabspf=C2=A0 : 0
noiob=C2=A0=C2=A0 : 0
nvmcap=C2=A0 : 0
nsattr=C2=A0=C2=A0 =C2=A0: 0
nvmsetid: 0
anagrpid: 0
endgid=C2=A0 : 0
nguid=C2=A0=C2=A0 : 00000000000000000000000000000000
eui64=C2=A0=C2=A0 : ace42e610000189f
lbaf=C2=A0 0 : ms:0=C2=A0=C2=A0 lbads:9=C2=A0 rp:0 (in use)
root@pve-20:~#

If anyone needs any more information about the hardware, please ask.

An interesting thing to note is that when I test using fio with --bs=3D512,=
 the direct hardware performance is horrible (~1MB/s).

root@pve-20:/# fio --filename=3D/dev/nvme0n1p2 --direct=3D1 --fsync=3D1 --r=
w=3Drandwrite --bs=3D512 --numjobs=3D1 --iodepth=3D1 --runtime=3D5 --time_b=
ased --group_reporting --name=3Djournal-test --ioengine=3Dlibaio
journal-test: (g=3D0): rw=3Drandwrite, bs=3D(R) 512B-512B, (W) 512B-512B, (=
T) 512B-512B, ioengine=3Dlibaio, iodepth=3D1
fio-3.12
Starting 1 process
Jobs: 1 (f=3D1): [w(1)][100.0%][w=3D1047KiB/s][w=3D2095 IOPS][eta 00m:00s]
journal-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1715926: Mon May 23 =
14:05:28 2022
=C2=A0 write: IOPS=3D2087, BW=3D1044KiB/s (1069kB/s)(5220KiB/5001msec); 0 z=
one resets
=C2=A0=C2=A0=C2=A0 slat (nsec): min=3D3338, max=3D90998, avg=3D12760.92, st=
dev=3D3377.45
=C2=A0=C2=A0=C2=A0 clat (usec): min=3D32, max=3D945, avg=3D453.85, stdev=3D=
27.03
=C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D46, max=3D953, avg=3D467.16, std=
ev=3D27.79
=C2=A0=C2=A0=C2=A0 clat percentiles (usec):
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0 404],=C2=A0 5.00th=3D[=C2=
=A0 420], 10.00th=3D[=C2=A0 429], 20.00th=3D[=C2=A0 433],
=C2=A0=C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0 437], 40.00th=3D[=C2=A0 453], =
50.00th=3D[=C2=A0 465], 60.00th=3D[=C2=A0 465],
=C2=A0=C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0 469], 80.00th=3D[=C2=A0 469], =
90.00th=3D[=C2=A0 474], 95.00th=3D[=C2=A0 474],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0 494], 99.50th=3D[=C2=A0 502], =
99.90th=3D[=C2=A0 848], 99.95th=3D[=C2=A0 889],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.99th=3D[=C2=A0 914]
=C2=A0=C2=A0 bw (=C2=A0 KiB/s): min=3D 1033, max=3D 1056, per=3D100.00%, av=
g=3D1044.22, stdev=3D 9.56, samples=3D9
=C2=A0=C2=A0 iops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D 2066, =
max=3D 2112, avg=3D2088.67, stdev=3D19.14, samples=3D9
=C2=A0 lat (usec)=C2=A0=C2=A0 : 50=3D0.03%, 100=3D0.01%, 500=3D99.38%, 750=
=3D0.44%, 1000=3D0.14%
=C2=A0 fsync/fdatasync/sync_file_range:
=C2=A0=C2=A0=C2=A0 sync (nsec): min=3D74, max=3D578, avg=3D279.19, stdev=3D=
45.25
=C2=A0=C2=A0=C2=A0 sync percentiles (nsec):
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0 151],=C2=A0 5.00th=3D[=C2=
=A0 179], 10.00th=3D[=C2=A0 235], 20.00th=3D[=C2=A0 249],
=C2=A0=C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0 255], 40.00th=3D[=C2=A0 278], =
50.00th=3D[=C2=A0 294], 60.00th=3D[=C2=A0 298],
=C2=A0=C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0 314], 80.00th=3D[=C2=A0 314], =
90.00th=3D[=C2=A0 330], 95.00th=3D[=C2=A0 334],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0 346], 99.50th=3D[=C2=A0 350], =
99.90th=3D[=C2=A0 374], 99.95th=3D[=C2=A0 386],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.99th=3D[=C2=A0 498]
=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=3D3.=
40%, sys=3D5.38%, ctx=3D10439, majf=3D0, minf=3D12
=C2=A0 IO depths=C2=A0=C2=A0=C2=A0 : 1=3D200.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.=
0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 issued rwts: total=3D0,10439,0,10438 short=3D0,0,0=
,0 dropped=3D0,0,0,0
=C2=A0=C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0, window=3D0, perc=
entile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
=C2=A0 WRITE: bw=3D1044KiB/s (1069kB/s), 1044KiB/s-1044KiB/s (1069kB/s-1069=
kB/s), io=3D5220KiB (5345kB), run=3D5001-5001msec

Disk stats (read/write):
=C2=A0 nvme0n1: ios=3D58/10171, merge=3D0/0, ticks=3D10/4559, in_queue=3D0,=
 util=3D97.64%

But the same test directly on the hardware with fio passing the parameter -=
-bs=3D4K, the performance completely changes, for the better (~130MB/s).

root@pve-20:/# fio --filename=3D/dev/nvme0n1p2 --direct=3D1 --fsync=3D1 --r=
w=3Drandwrite --bs=3D4K --numjobs=3D1 --iodepth=3D1 --runtime=3D5 --time_ba=
sed --group_reporting --name=3Djournal-test --ioengine=3Dlibaio
journal-test: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096B-4096=
B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
fio-3.12
Starting 1 process
Jobs: 1 (f=3D1): [w(1)][100.0%][w=3D125MiB/s][w=3D31.9k IOPS][eta 00m:00s]
journal-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1725642: Mon May 23 =
14:13:50 2022
=C2=A0 write: IOPS=3D31.9k, BW=3D124MiB/s (131MB/s)(623MiB/5001msec); 0 zon=
e resets
=C2=A0=C2=A0=C2=A0 slat (nsec): min=3D2942, max=3D87863, avg=3D3222.02, std=
ev=3D1233.34
=C2=A0=C2=A0=C2=A0 clat (nsec): min=3D865, max=3D1238.6k, avg=3D25283.31, s=
tdev=3D24400.58
=C2=A0=C2=A0=C2=A0=C2=A0 lat (usec): min=3D24, max=3D1243, avg=3D28.63, std=
ev=3D24.45
=C2=A0=C2=A0=C2=A0 clat percentiles (usec):
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0=C2=A0 23],=C2=A0 5.00th=
=3D[=C2=A0=C2=A0 23], 10.00th=3D[=C2=A0=C2=A0 23], 20.00th=3D[=C2=A0=C2=A0 =
23],
=C2=A0=C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0=C2=A0 24], 40.00th=3D[=C2=A0=
=C2=A0 24], 50.00th=3D[=C2=A0=C2=A0 24], 60.00th=3D[=C2=A0=C2=A0 25],
=C2=A0=C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0=C2=A0 26], 80.00th=3D[=C2=A0=
=C2=A0 26], 90.00th=3D[=C2=A0=C2=A0 26], 95.00th=3D[=C2=A0=C2=A0 29],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0=C2=A0 35], 99.50th=3D[=C2=A0=
=C2=A0 41], 99.90th=3D[=C2=A0 652], 99.95th=3D[=C2=A0 725],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.99th=3D[=C2=A0 766]
=C2=A0=C2=A0 bw (=C2=A0 KiB/s): min=3D125696, max=3D129008, per=3D99.98%, a=
vg=3D127456.33, stdev=3D1087.63, samples=3D9
=C2=A0=C2=A0 iops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : min=3D31424, =
max=3D32252, avg=3D31864.00, stdev=3D271.99, samples=3D9
=C2=A0 lat (nsec)=C2=A0=C2=A0 : 1000=3D0.01%
=C2=A0 lat (usec)=C2=A0=C2=A0 : 2=3D0.01%, 20=3D0.01%, 50=3D99.59%, 100=3D0=
.24%, 250=3D0.01%
=C2=A0 lat (usec)=C2=A0=C2=A0 : 500=3D0.02%, 750=3D0.10%, 1000=3D0.02%
=C2=A0 lat (msec)=C2=A0=C2=A0 : 2=3D0.01%
=C2=A0 fsync/fdatasync/sync_file_range:
=C2=A0=C2=A0=C2=A0 sync (nsec): min=3D43, max=3D435, avg=3D68.51, stdev=3D1=
0.83
=C2=A0=C2=A0=C2=A0 sync percentiles (nsec):
=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 1.00th=3D[=C2=A0=C2=A0 59],=C2=A0 5.00th=
=3D[=C2=A0=C2=A0 60], 10.00th=3D[=C2=A0=C2=A0 61], 20.00th=3D[=C2=A0=C2=A0 =
63],
=C2=A0=C2=A0=C2=A0=C2=A0 | 30.00th=3D[=C2=A0=C2=A0 64], 40.00th=3D[=C2=A0=
=C2=A0 65], 50.00th=3D[=C2=A0=C2=A0 66], 60.00th=3D[=C2=A0=C2=A0 67],
=C2=A0=C2=A0=C2=A0=C2=A0 | 70.00th=3D[=C2=A0=C2=A0 70], 80.00th=3D[=C2=A0=
=C2=A0 73], 90.00th=3D[=C2=A0=C2=A0 77], 95.00th=3D[=C2=A0=C2=A0 80],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.00th=3D[=C2=A0 122], 99.50th=3D[=C2=A0 147], =
99.90th=3D[=C2=A0 177], 99.95th=3D[=C2=A0 189],
=C2=A0=C2=A0=C2=A0=C2=A0 | 99.99th=3D[=C2=A0 251]
=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=3D10=
.72%, sys=3D19.54%, ctx=3D159367, majf=3D0, minf=3D11
=C2=A0 IO depths=C2=A0=C2=A0=C2=A0 : 1=3D200.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.=
0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 issued rwts: total=3D0,159384,0,159383 short=3D0,0=
,0,0 dropped=3D0,0,0,0
=C2=A0=C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0, window=3D0, perc=
entile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
=C2=A0 WRITE: bw=3D124MiB/s (131MB/s), 124MiB/s-124MiB/s (131MB/s-131MB/s),=
 io=3D623MiB (653MB), run=3D5001-5001msec

Disk stats (read/write):
=C2=A0 nvme0n1: ios=3D58/155935, merge=3D0/0, ticks=3D10/3823, in_queue=3D0=
, util=3D98.26%

Does anything justify this difference?

Maybe that's why when I create bcache with the -w=3D4K option the performan=
ce improves. Not as much as I'd like, but it gets better.

I also noticed that when I use the --bs=3D4K parameter (or indicating even =
larger blocks) and use the --ioengine=3Dlibaio parameter together in the di=
rect test on the hardware, the performance improves a lot, even doubling th=
e speed in the case of blocks of 4K Without --ioengine=3Dlibaio, direct har=
dware is somewhere around 15K IOPS at 60.2 MB/s, but using this library, it=
 goes to 32K IOPS and 130MB/s;

That's why I have standardized using this parameter (--ioengine=3Dlibaio) i=
n tests.

The buckets, I read that it would be better to put the hardware device eras=
e block size. However, I have already tried to find this information by rea=
ding the device, also with the manufacturer, but without success. So I have=
 no idea which bucket size would be best, but from my tests, the default of=
 512KB seems to be adequate.=20

Responding to Coly, I did tests using fio to directly write to the block de=
vice NVME (/dev/nvme0n1), without going through any partitions. Performance=
 is always slightly better on hardware when writing directly to the block w=
ithout a partition. But the difference is minimal. This difference also see=
ms to be reflected in bcache, but it is also very small (insignificant).

I've already noticed that, increasing the number of jobs, the performance o=
f the bcache0 device improves a lot, reaching almost equal to the performan=
ce of tests done directly on the Hardware.=20

Eric, perhaps it is not such a simple task to recompile the Kernel with the=
 suggested change. I'm working with Proxmox 6.4. I'm not sure, but I think =
the Kernel may have some adaptation. It is based on Kernel 5.4, which it is=
 approved for.

Also listening to Coly's suggestion, I'll try to perform tests with the Ker=
nel version 5.15 to see if it can solve. Would this version be good enough?=
 It's just that, as I said above, as I'm using Proxmox, I'm afraid to chang=
e the Kernel version they provide.

Eric, to be clear, the hardware I'm using has only 1 processor socket.

I'm trying to test with another identical computer (the same motherboard, t=
he same processor, the same NVMe, with the difference that it only has 12GB=
 of RAM, the first having 48GB). It is an HP Z400 Workstation with an Intel=
 Xeon X5680 sixcore processor (12 threads), DDR3 1333MHz 10600E (old comput=
er). On the second computer, I put a newer version of the distribution that=
 uses Kernel based on version 5.15. I am now comparing the performance of t=
he two computers in the lab.

On this second computer I had worse performance than the first one (practic=
ally half the performance with bcache), despite the performance of the test=
s done directly in NVME being identical.

I tried going back to the same OS version on the first computer to try and =
keep the exact same scenario on both computers so I could first compare the=
 two. I try to keep the exact same software configuration. However, there w=
ere no changes. Is it the low RAM that makes the performance worse in the s=
econd?

I noticed a difference in behavior on the second computer compared to the f=
irst in dstat. While the first computer doesn't seem to touch the backup de=
vice at all, the second computer signals something a little different, as a=
lthough it doesn't write data to the backup disk, it does signal IO movemen=
t. Strange no?

Let's look at the dstat of the first computer:

--dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -ne=
t/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- asyn=
c
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0 1=
5m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 time=
=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |6953B 7515B|0.13 0.26 0.26|=C2=A0 0=C2=A0=C2=A0=
 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 399=C2=A0=C2=A0 634 |25-05 09:41:4=
2|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 8192B:4096B 2328k:=C2=A0=C2=A0 0=C2=A0 1168k|=C2=A0=C2=
=A0 0=C2=A0 2.00 :1.00=C2=A0=C2=A0 586 :=C2=A0=C2=A0 0=C2=A0=C2=A0 587 |915=
0B 2724B|0.13 0.26 0.26|=C2=A0 2=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0|1093=C2=A0 3267 |25-05 09:41:43|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.8k:=C2=A0=C2=A0 0=C2=A0 14.7k|=C2=A0 14k =
9282B|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 94=C2=A0=C2=A0 2=C2=A0=C2=
=A0 0|=C2=A0 16k=C2=A0=C2=A0 67k|25-05 09:41:44|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.9k:=C2=A0=C2=A0 0=C2=A0 14.8k|=C2=A0 10k =
8992B|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 93=C2=A0=C2=A0 2=C2=A0=C2=
=A0 0|=C2=A0 16k=C2=A0=C2=A0 69k|25-05 09:41:45|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.9k:=C2=A0=C2=A0 0=C2=A0 14.8k|7281B 4651B=
|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 92=C2=A0=C2=A0 4=C2=A0=C2=A0 0=
|=C2=A0 16k=C2=A0=C2=A0 67k|25-05 09:41:46|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
59M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 30M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 15.2k:=C2=A0=C2=A0 0=C2=A0 15.1k|7849B 4729B=
|0.20 0.28 0.27|=C2=A0 1=C2=A0=C2=A0 4=C2=A0 94=C2=A0=C2=A0 2=C2=A0=C2=A0 0=
|=C2=A0 16k=C2=A0=C2=A0 69k|25-05 09:41:47|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
57M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 28M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.4k:=C2=A0=C2=A0 0=C2=A0 14.4k|=C2=A0 11k =
8584B|0.20 0.28 0.27|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 94=C2=A0=C2=A0 2=C2=A0=C2=
=A0 0|=C2=A0 15k=C2=A0=C2=A0 65k|25-05 09:41:48|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |4086B 7720B|0.20 0.28 0.27|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 274=C2=A0=C2=A0 332 |25-05 09:41:49|=C2=
=A0=C2=A0 0

Note that on this first computer, the writings and IOs of the backing devic=
e (sdb) remain motionless. While NVMe device IOs track bcache0 device IOs a=
t ~14.8K

Let's see the dstat now on the second computer:

--dsk/sdd---dsk/nvme0n1-dsk/bcache0 ---io/sdd----io/nvme0n1--io/bcache0 -ne=
t/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- asyn=
c
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0 1=
5m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 time=
=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |9254B 3301B|0.15 0.19 0.11|=C2=A0 1=C2=A0=C2=A0=
 2=C2=A0 97=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 360=C2=A0=C2=A0 318 |26-05 06:27:1=
5|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 8192B:4096B=C2=A0=C2=A0 19M:=C2=A0=C2=A0 0=C2=A0 9600k=
|=C2=A0=C2=A0 0=C2=A0 2402 :1.00=C2=A0 4816 :=C2=A0=C2=A0 0=C2=A0 4801 |882=
6B 3619B|0.15 0.19 0.11|=C2=A0 0=C2=A0=C2=A0 1=C2=A0 98=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0|8115=C2=A0=C2=A0=C2=A0 27k|26-05 06:27:16|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
21M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2737 :=C2=A0=
=C2=A0 0=C2=A0 5492 :=C2=A0=C2=A0 0=C2=A0 5474 |4051B 2552B|0.15 0.19 0.11|=
=C2=A0 0=C2=A0=C2=A0 2=C2=A0 97=C2=A0=C2=A0 1=C2=A0=C2=A0 0|9212=C2=A0=C2=
=A0=C2=A0 31k|26-05 06:27:17|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
23M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2890 :=C2=A0=
=C2=A0 0=C2=A0 5801 :=C2=A0=C2=A0 0=C2=A0 5781 |4816B 2492B|0.15 0.19 0.11|=
=C2=A0 1=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 2=C2=A0=C2=A0 0|9976=C2=A0=C2=
=A0=C2=A0 34k|26-05 06:27:18|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
23M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2935 :=C2=A0=
=C2=A0 0=C2=A0 5888 :=C2=A0=C2=A0 0=C2=A0 5870 |4450B 2552B|0.22 0.21 0.12|=
=C2=A0 0=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 2=C2=A0=C2=A0 0|9937=C2=A0=C2=
=A0=C2=A0 33k|26-05 06:27:19|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 =
22M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2777 :=C2=A0=
=C2=A0 0=C2=A0 5575 :=C2=A0=C2=A0 0=C2=A0 5553 |8644B 1614B|0.22 0.21 0.12|=
=C2=A0 0=C2=A0=C2=A0 2=C2=A0 98=C2=A0=C2=A0 0=C2=A0=C2=A0 0|9416=C2=A0=C2=
=A0=C2=A0 31k|26-05 06:27:20|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 2096k:=C2=A0=
=C2=A0 0=C2=A0 1040k|=C2=A0=C2=A0 0=C2=A0=C2=A0 260 :=C2=A0=C2=A0 0=C2=A0=
=C2=A0 523 :=C2=A0=C2=A0 0=C2=A0=C2=A0 519 |=C2=A0 10k 8760B|0.22 0.21 0.12=
|=C2=A0 0=C2=A0=C2=A0 1=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0|1246=C2=A0 315=
7 |26-05 06:27:21|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |4083B 2990B|0.22 0.21 0.12|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 390=C2=A0=C2=A0 369 |26-05 06:27:22|=C2=
=A0=C2=A0 0

In this case, with exactly the same command, we got a very different result=
. While writes to the backing device (sdd) do not happen (this is correct),=
 we noticed that IOs occur on both the NVMe device and the backing device (=
i think this is wrong), but at a much lower rate now, around 5.6K on NVMe a=
nd 2.8K on the backing device. It leaves the impression that although it is=
 not writing anything to sdd device, it is sending some signal to the backi=
ng device in each two IO operations that is performed with the cache device=
. And that would be delaying the answer. Could it be something like this?

It is important to point out that the writeback mode is on, obviously, and =
that the sequential cutoff is at zero, but I tried to put default values =
=E2=80=8B=E2=80=8Bor high values =E2=80=8B=E2=80=8Band there were no change=
s. I also tried changing congested_write_threshold_us and congested_read_th=
reshold_us, also with no result changes.

The only thing I noticed different between the configurations of the two co=
mputers was btree_cache_size, which on the first is much larger (7.7M) m wh=
ile on the second it is only 768K. But I don't know if this parameter is co=
nfigurable and if it could justify the difference.

Disabling Intel's Turbo Boost technology through the BIOS appears to have n=
o effect.

And we will continue our tests comparing the two computers, including to te=
st the two versions of the Kernel. If anyone else has ideas, thanks!

Em ter=C3=A7a-feira, 17 de maio de 2022 22:23:09 BRT, Eric Wheeler <bcache@=
lists.ewheeler.net> escreveu:=20





On Tue, 10 May 2022, Adriano Silva wrote:
> I'm trying to set up a flash disk NVMe as a disk cache for two or three=
=20
> isolated (I will use 2TB disks, but in these tests I used a 1TB one)=20
> spinning disks that I have on a Linux 5.4.174 (Proxmox node).

Coly has been adding quite a few optimizations over the years.=C2=A0 You mi=
ght=20
try a new kernel and see if that helps.=C2=A0 More below.

> I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as=
=20
> a cache.
> [...]
>
> But when I do the same test on bcache writeback, the performance drops a=
=20
> lot. Of course, it's better than the performance of spinning disks, but=
=20
> much worse than when accessed directly from the NVMe device hardware.
>
> [...]
> As we can see, the same test done on the bcache0 device only got 1548=20
> IOPS and that yielded only 6.3 KB/s.

Well done on the benchmarking!=C2=A0 I always thought our new NVMes perform=
ed=20
slower than expected but hadn't gotten around to investigating.=20

> I've noticed in several tests, varying the amount of jobs or increasing=
=20
> the size of the blocks, that the larger the size of the blocks, the more=
=20
> I approximate the performance of the physical device to the bcache=20
> device.

You said "blocks" but did you mean bucket size (make-bcache -b) or block=20
size (make-bcache -w) ?

If larger buckets makes it slower than that actually surprises me: bigger=
=20
buckets means less metadata and better sequential writeback to the=20
spinning disks (though you hadn't yet hit writeback to spinning disks in=20
your stats).=C2=A0 Maybe you already tried, but varying the bucket size mig=
ht=20
help.=C2=A0 Try graphing bucket size (powers of 2) against IOPS, maybe ther=
e is=20
a "sweet spot"?

Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device,=
=20
unless Coly has patched that.=C2=A0 Make sure your `blockdev --getss` repor=
ts=20
512 for your NVMe!

Hi Coly,

Some time ago you ordered an an SSD to test the 4k cache issue, has that=20
been fixed?=C2=A0 I've kept an eye out for the patch but not sure if it was=
 released.

You have a really great test rig setup with NVMes for stress
testing bcache. Can you replicate Adriano's `ioping` numbers below?

> With ioping it is also possible to notice a limitation, as the latency=20
> of the bcache0 device is around 1.5ms, while in the case of the raw=20
> device (a partition of NVMe), the same test is only 82.1us.
>=20
> root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D1 time=3D1.52 =
ms (warmup)
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D2 time=3D1.60 =
ms
> 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D3 time=3D1.55 =
ms
>
> root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D1 time=3D81.2 =
us (warmup)
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D2 time=3D82.7 =
us
> 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D3 time=3D82.4 =
us

Wow, almost 20x higher latency, sounds convincing that something is wrong.

A few things to try:

1. Try ioping without -Y.=C2=A0 How does it compare?

2. Maybe this is an inter-socket latency issue.=C2=A0 Is your server=20
=C2=A0 multi-socket?=C2=A0 If so, then as a first pass you could set the ke=
rnel=20
=C2=A0 cmdline `isolcpus` for testing to limit all processes to a single=20
=C2=A0 socket where the NVMe is connected (see `lscpu`).=C2=A0 Check `hwloc=
-ls`
=C2=A0 or your motherboard manual to see how the NVMe port is wired to your
=C2=A0 CPUs.

=C2=A0 If that helps then fine tune with `numactl -cN ioping` and=20
=C2=A0 /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`) t=
o=20
=C2=A0 make sure your NVMe's are locked to IRQs on the same socket.

3a. sysfs:

> # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff

good.

> # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us

Also try these (I think bcache/cache is a symlink to /sys/fs/bcache/<cache =
set>)

echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_us=
=20
echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold_u=
s


Try tuning journal_delay_ms:=20
=C2=A0 /sys/fs/bcache/<cset-uuid>/journal_delay_ms
=C2=A0 =C2=A0 Journal writes will delay for up to this many milliseconds, u=
nless a=20
=C2=A0 =C2=A0 cache flush happens sooner. Defaults to 100.

3b: Hacking bcache code:

I just noticed that journal_delay_ms says "unless a cache flush happens=20
sooner" but cache flushes can be re-ordered so flushing the journal when=20
REQ_OP_FLUSH comes through may not be useful, especially if there is a=20
high volume of flushes coming down the pipe because the flushes could kill=
=20
the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.=C2=A0 =
It
would flush data and journal.

Maybe there should be a cachedev_noflush sysfs option for those with some=
=20
kind of power-loss protection of there SSD's.=C2=A0 It looks like this is=
=20
handled in request.c when these functions call bch_journal_meta():

=C2=A0=C2=A0=C2=A0 1053: static void cached_dev_nodata(struct closure *cl)
=C2=A0=C2=A0=C2=A0 1263: static void flash_dev_nodata(struct closure *cl)

Coly can you comment about journal flush semantics with respect to=20
performance vs correctness and crash safety?

Adriano, as a test, you could change this line in search_alloc() in=20
request.c:

=C2=A0=C2=A0=C2=A0 - s->iop.flush_journal=C2=A0 =C2=A0 =3D op_is_flush(bio-=
>bi_opf);
=C2=A0=C2=A0=C2=A0 + s->iop.flush_journal=C2=A0 =C2=A0 =3D 0;

and see how performance changes.

Someone correct me if I'm wrong, but I don't think flush_journal=3D0 will=
=20
affect correctness unless there is a crash.=C2=A0 If that /is/ the performa=
nce=20
problem then it would narrow the scope of this discussion.

4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can=20
=C2=A0 you set your CPU governor to run at full clock speed and then slowes=
t=20
=C2=A0 clock speed to see if it is a CPU limit somewhere as we expect?

=C2=A0 You can do `grep MHz /proc/cpuinfo` to see the active rate to make s=
ure=20
=C2=A0 the governor did its job.=C2=A0=20

=C2=A0 If it scales with CPU then something in bcache is working too hard.=
=C2=A0=20
=C2=A0 Maybe garbage collection?=C2=A0 Other devs would need to chime in he=
re to=20
=C2=A0 steer the troubleshooting if that is the case.


5. I'm not sure if garbage collection is the issue, but you might try=20
=C2=A0 Mingzhe's dynamic incremental gc patch:
=C2=A0=C2=A0=C2=A0 https://www.spinics.net/lists/linux-bcache/msg11185.html

6. Try dm-cache and see if its IO latency is similar to bcache: If it is=20
=C2=A0 about the same then that would indicate an issue in the block layer=
=20
=C2=A0 somewhere outside of bcache.=C2=A0 If dm-cache is better, then that =
confirms=20
=C2=A0 a bcache issue.


> The cache was configured directly on one of the NVMe partitions (in this=
=20
> case, the first partition). I did several tests using fio and ioping,=20
> testing on a partition on the NVMe device, without partition and=20
> directly on the raw block, on a first partition, on the second, with or=
=20
> without configuring bcache. I did all this to remove any doubt as to the=
=20
> method. The results of tests performed directly on the hardware device,=
=20
> without going through bcache are always fast and similar.
>=20
> But tests in bcache are always slower. If you use writethrough, of=20
> course, it gets much worse, because the performance is equal to the raw=
=20
> spinning disk.
>=20
> Using writeback improves a lot, but still doesn't use the full speed of=
=20
> NVMe (honestly, much less than full speed).

Indeed, I hope this can be fixed!=C2=A0 A 20x improvement in bcache would=
=20
be awesome.

> But I've also noticed that there is a limit on writing sequential data,=
=20
> which is a little more than half of the maximum write rate shown in=20
> direct tests by the NVMe device.

For sync, async, or both?


> Processing doesn't seem to be going up like the tests.


What do you mean "processing" ?

-Eric

