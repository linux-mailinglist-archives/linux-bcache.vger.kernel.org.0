Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F0E536D08
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiE1M6I (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344012AbiE1M6H (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:58:07 -0400
Received: from sonic306-1.consmr.mail.bf2.yahoo.com (sonic306-1.consmr.mail.bf2.yahoo.com [74.6.132.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42DD19C03
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1653742684; bh=1eRQMwaOKT2Bc6cBj3gzgowRYwxeqWFwBekJ6yC1C0M=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=MbOkhZe82tjdvVoGimYdPcmxZXeu2ylQXr3L8qivRh/nHIiHEhQVaHcjnXZCAuSa1ORM4bXbcZ3cgrs7udVD1G4cAP1iP+AGi08eqZA46MgDki2RPRBhYPUhVR6f2JdSCQXY44/MPuWxbJv9RN5+pYIcpilvl4JmjPnTQsZpZBYO3ZCaXnvb5mUbFZtuBeZ4pNaBY+arlFnUOREMJnqVbar2yhaFbN17A5dIHc8oy/dxZ8sy8Gip4XkafoSGPCK7jCBAS8UO1O6JEaOOkyWDWOyuUN1Eejdr09TTbtjdku1KFpCfH6PK1Cj4S6p0q1K5npm2NjYvd8+mQnLXWK2SOg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653742684; bh=LdwejD+C4r8MPU1RlkxJGwtj3PrJGIgnLK0beExl+6N=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=QR9A2sFdoYB9ieGQIhXNHOe1NZ+eKuOpN0BBGNM1JVAu6+W2Hy+UXpLYTpc3ovibgjwFG9m6y7BesX2yCy3NOT1ZEpnV/fu7iljCqIaheNzbXuTd4FENBFRWMdU9j8fPDBJul50U+c2bU8JKNyU47JxHT85gAGA2kI/A7dyAFGMBnKI/OPhgtU1Mny1G/ROiN2QxiXQauzNyyLnp3ixraMGhOi5g91AXYUz/y1kuWhtRVQJ25mvqmtsymVE81WTYXYDzcxYrzR832wcZqq95dguL4epkfHpUvWCtfUffU6HkTnldpPM3pJwRBswbneTowEpFmOGBk6UnI6UgRfKfTw==
X-YMail-OSG: RVu0pscVM1njk9_6BqwtDx1FAZd4N4XoE_n8ix0fvrGP.kd1_U393pwEEo1hbyC
 C7y4UtDyn252QL7XzCiSmmCunL2NH.ZktJiVlAMsnJacZDeWrqYxmN2DWANMhIAudNOXNMPzL7fk
 2a6hiFxpDLjHoJRZLaQLqRD7eo5Vz_rpxgeLJzeHShyCrx.dzOddG288RXZr7tWTaM8eFer6UZXo
 raOzClH39u197ZgnKoWrVR5uZsAAWBFbxI8GeIbUs6tj_3t8FrqGDhVG0fYozICY8JuDXS9YfcHM
 JkqaDJfGPHPVPlaCGPSd1_ubK_wTrH0.5YFr9qT8wuLBL1LH5.uJhohO_t20650iDPM_HtfjkhV7
 hvfKS9sCjSnFGcPgkEk0xccdN68wvjVvDPocDCFyM.ac6pjWuWfSvsXlIHCnAb6ElHTuOXrEapvl
 f6FAycQRyqWMqmO3yZ9ZU4VTYc4DEUZRKoJVOcKugisjQZrrKurJ.tPeAmqSIgx6u0dPzp5cp29k
 F8Q02vqqt_Qy4..nvvd6Y9n6tppxDKIcm3wYo_m0G1SjKJV4yeq2Uh_aCDtphku1TqpPHveOFZ1F
 APkBvfWTnvAzt03gg64EM4gA2cvaptRldgp9m.nX_qy3roC0.M9992jwG8ECzSCfiuUpzuNgDXiZ
 .lLSne2S6qinxupOo7dWR60CvBN0QbThQVGAmiHvcLo8qpnNnclk2G2Z3kCK43BIkaX0i.Wd3GAk
 1S6WG0ZgLh5DcOtRSibdKWCnaxi.pQVJTYWFN0amEjiXk4DPSnKd0ixXCMIlxdGO.bBfZ2dg09yR
 E_e0xHKEvxOuD5P2k5I420lKJnR2JnNyrD6jubSZ9DzGY5fSRKzpFGq6oP5lNrtFTXLB0wZ.KqWR
 keSSzRxMAfVJt9zvq7bILgqbokiyaL.qLMiVwCrkyI.ylvLvkQBkETtebuNYTtdEw_Bm34HhchtJ
 f3tZV2TUNXHC2w5b824rfIDeI6ZTydR3gH8xAWC7n1saLuHUYHiBU76L9ynkMHQWDYLnpMlc0AT_
 fSaZV8sg6JxDM_i7k.2.SZkVTEapJlKPI25JDPDMrJc8aDO2qdoviumd0cfhQ3d1CESd1MOUQ.jc
 WCKWyKB60MsKUHqGwBuK3MY23m8woQtpaFxLJwr_oJ1kQ57veJNNQ4W1Sn8NXjQykPFbL4CpjBqI
 HGIo0qjOdc376KHlXSEMpamNZVZQxz5wdZ_Z55Bwqbi5g_Cs.bWFvtoAgU74wF.v7G6MREy5T6cB
 g0vvDwQaFgqrrTWxljBTbBlKpj2iFv2bjfFdXgre8GaeMZrSmq04NZ..A8uAceIj3wz8Ig7ZJ9F8
 j2XVXQss6KiTJDQVlMTpm29QWrpDG9EtM.Nlypw05cXOrOydBHQ4dAwz9EA7dfnnb2dq1QcN6yGd
 KugIenTzsynmI4ClnoNEQiqCHI10JVgVSipJBMxxPxdW6ViMCuF3NGreZXkol9psgvNOYZuC0YG3
 t9NNQdu0iuvXnTCXVboacMjpbe8biFcSY_hWZLubJmr3aRAQzHYvDxrYi1NRhzbJQJVEsqKEoP1H
 7F8aimaYHuBBpS9eyUZXsFvPftOjCUWxdhtVW6FAY1vF3NrGNjVVs1Iv0r9nTBbB_iOWgYDcV64U
 7LQKP3f7zAnzsrKz_zxvW4gCJ8z0IWBXlKPEHpr1cyt7Nhdtb_iuhXtJhMnS13Uym.l1ept7y.MA
 JJF_jkcJLycaAqrIPbJwe07j0oHP9EGYvXeoNGOqsEDth5YsxS38xY53KJn3XNbAEKqQfqbuLxkW
 XSPAeRQCH3tOAt8oaIVCQV5IQHmXTMCYKcJWGqD_vURMoulY7TjUTNG9RkWJgfuGM9cwamgozvZi
 WA2LSVIQ6yx5MX38QK8uFCDWv6b.pmS1addgtCntKArGR0aOYS4oHAiPRMU5tgAbn9t1_gr0Gx_V
 oJ5YlKWkhAOVSbvHTGV5AhpN58nkhpGbvHqjj2eSIIqmpP3tSVsxnemLMLsjEOk93Hsh6gBbrtev
 M8PyavI5BnnuP0CrfCAY9Xl5UoZdwjMi9KJ0NkW3kYJPpwidCrMxWqjDgLrfEeKf9iqbX3OaM2hy
 BJRKpH_vWAgNIJr0SRb6gqFppKODnf2HpjaMa8_S8W_CLwSl7B8CS.AT_Wx_p0K90qx7YpN3LbZf
 B9mk7YNre.W80hnyU50X7tEDC57mUTR36YJrmt26KRhMPWFP_DQMvtOdm..APsT.jdpzaUN4_Gv3
 WPdoFyhBg0_7mbK96YQ--
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.bf2.yahoo.com with HTTP; Sat, 28 May 2022 12:58:04 +0000
Date:   Sat, 28 May 2022 12:57:26 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Christoph Hellwig <hch@infradead.org>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>,
        Coly Li <colyli@suse.de>,
        Eric Wheeler <bcache@lists.ewheeler.net>,
        Keith Busch <kbusch@kernel.org>
Message-ID: <24456292.2324073.1653742646974@mail.yahoo.com>
In-Reply-To: <YpGsKDQ1aAzXfyWl@infradead.org>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <27ef674d-67e-5739-d5d8-f4aa2887e9c2@ewheeler.net> <YoxuYU4tze9DYqHy@infradead.org> <5486e421-b8d0-3063-4cb9-84e69c41b7a3@ewheeler.net> <Yo1BRxG3nvGkQoyG@kbusch-mbp.dhcp.thefacebook.com> <7759781b-dac-7f84-ff42-86f4b1983ca1@ewheeler.net> <Yo28kDw8rZgFWpHu@infradead.org> <a2ed37b8-2f4a-ef7a-c097-d58c2b965af3@ewheeler.net> <YpGsKDQ1aAzXfyWl@infradead.org>
Subject: Re: [RFC] Add sysctl option to drop disk flushes in bcache? (was:
 Bcache in writes direct with fsync)
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

Dear Christoph,

> Once you do that, the block layer ignores all flushes and FUA bits, so
> yes it is going to be a lot faster.=C2=A0 But also completely unsafe beca=
use
> it does not provide any data durability guarantees.

Sorry, but wouldn't it be the other way around? Or did I really not underst=
and your answer?

Sorry, I don't know anything about kernel code, but wouldn't it be the othe=
r way around?

It's just that, I may not be understanding. And it's likely that I'm not, b=
ecause you understand more about this, I'm new to this subject. I know very=
 little about it, or almost nothing.

But it's just that I've read the opposite about it.

=C2=A0Isn't "write through" to provide more secure writes?

I also see that "write back" would be meant to be faster. No?

But I understand that when I do a write with direct ioping (-D) and with fo=
rced sync (-Y), then an enterprise NVME device with PLP (Power Loss Protect=
ion) like mine here should perform very well because in theory, the message=
s are sent to the hardware by the OS with an instruction for the Hardware t=
o ignore the cache (correct?), but the NVME device will still put it in its=
 local cache and give an immediate response to the OS saying that the data =
has been written, because he knows his local cache is a safe place for this=
 (in theory).

On the other hand, answering why writing is slow when "write back" is activ=
ated is intriguing. Could it be the software logic stack involved to do the=
 Write Back? I don't know.


Em s=C3=A1bado, 28 de maio de 2022 01:59:30 BRT, Christoph Hellwig <hch@inf=
radead.org> escreveu:=20





On Fri, May 27, 2022 at 06:52:22PM -0700, Eric Wheeler wrote:

> Adriano who started this thread (cc'ed) reported that setting=20
> queue/write_cache to "write back" provides much higher latency on his NVM=
e=20
> than "write through"; I tested a system here and found the same thing.
>
> [...]
>
> Is this expected?


Once you do that, the block layer ignores all flushes and FUA bits, so
yes it is going to be a lot faster.=C2=A0 But also completely unsafe becaus=
e
it does not provide any data durability guarantees.

