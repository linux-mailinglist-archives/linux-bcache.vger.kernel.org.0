Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1C6CD6A5
	for <lists+linux-bcache@lfdr.de>; Wed, 29 Mar 2023 11:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjC2Jke (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 Mar 2023 05:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjC2Jkd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 Mar 2023 05:40:33 -0400
Received: from sonic301-2.consmr.mail.bf2.yahoo.com (sonic301-2.consmr.mail.bf2.yahoo.com [74.6.129.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F593210D
        for <linux-bcache@vger.kernel.org>; Wed, 29 Mar 2023 02:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680082830; bh=yQ94tA1pjFf7MHOPnL3CIu/Q/cikSStLPuJOjHkJOFM=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=WutfOfFtyD8Baiw1/iKYYgtnbW8QeYuYtl5j0Tt3giHWrDX30WgnVtSA6u7lClLEUNf2ERMw1xGs84QUtbdsbe2E4dPAOMQ7oX0GymbiMZbUelimGiHmAsJIoKRirmpl2rZvsNpkx0teOtjCaIuc8hyOV/KOz/XRbdAZUG9MbxlQk4BeZd6i8EnsJjljHh7qvbeAarguUfHV7NojkMfP38vcgwhKXl/0e+WNKoi0gYfSjuuiSBhuRIen/azsa/UbOLpupCBV7OJRtbAXP1AU00L91+n+dBqR3nxLZIfeJp9qxsvq1xaIoIa1AqfRt7EJm6dLSNlzk1Pvztz4aB2H3Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680082830; bh=XvA2MtJOdlQeseblrPycfL1psmWun4ETX5n1on8ZenB=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=AMM0VXzN/kULjVRB+17qE3KIlmOQRXtXx3CK3YD1Jh5AdCCTtR0wnipysl1P15sKDQUBjucpX4jgdTZd+dEmzj+UGu/eLJrzbgqZlm7uz4M2KtUdX2jgCUXOV/QuCbehdVkD8H51hQ6fxZvTlSAQDhsIeGnjfbuxAFblm+YTpFJ4IYKYzvEWRovM1hNvasjypHGmhUDqYt2EAEDZGL74Uhfh3LpSyKJU+H81/6dRjG98b4P2PLcFcOwmgz2C7VDGfXvYC721wR8z6TUIwrJgJi0MN7nAtIDj+bl+tKaPDDPeNu9fKJ+8SQj8gEXylTK0zkJmjxlj49nrtqohqRTrNg==
X-YMail-OSG: fCSv56AVM1nuTlz8uJJiqltp_tLu0w4vEKXZxa8TkumPIl9bB2TTfpd6UHAIPvE
 z.ms3e_LVgTwBAqJClpX8.lBSmQjk9DluQiJo1MK.gq414OnKom7kyVoRlG7x4enUTXoILWq7Ofg
 .4ZSXqrSb8wGU.W1ItmSADwHFtnqeUGu0fmEfxHKFrm.5f_4uOii8q8ExkP3U65y.OI5B7kNeWI0
 MfRo8FZhTy8Mgspl015yqlE7Mc9aOqp3c6kFTsOB19VSKzD5o8FhcrxgdCk4hF3G3F2pX2F7Czg6
 T42wHKRZwjQkuyqpfYhuh9A36muaFkXoJrZbkpbaaAbPzS5PrrEoY_sncjQc8PBwl2xWtB6deznG
 .lXxXZqG3SvxA7RB46n_mI7TbYuW4oWuvmmOx83XIZPrbT.mCIaZt1755II2A215AlqUVRpuSngB
 jT6dtV6Q3MQqcduP2kdS.RloVfd5f399xg_sv3kZbClMvE4W9._jK0BlBOqJzx2Owm_ua0hJa9iS
 FyfNfx9g0AL.6Z6IDDoYy9WL92lyeegmT_Ll4Kznd7Veu7MercBWpATQ2hnOrhDdVpaW1JdGPh8y
 mWWJhvGqk9.XvXlv4yTlH7yxh2rW2Q.hKYiFiBLW7M5mACBoldXRSD0hZyYgG5cKbFSFlysGa37P
 v80lwzJwhwXeWmvPw7njoWx6dHaHc0LH0t7PF0rxAzIGl.D531_lGFK2Wf1bN_Bsc5dddXzIXECS
 P57DaNRCcu2tT9Y11eiWsnoh9UdRRecIIXTmspxHzERqKgwxnKRIqz9Wj0yAGtbQ6tv3HVXEkzeK
 RHMXrhROynncvPX_T2aVE4nGNw8OHopR6uTwjuhDxFwZ.fZvfEcDfJruf4GUA34zSmJZ19nfm32H
 ShdOPZlhwzeG69ZZtnxr_WQRILcwT7ULVQFFavJ6GNgp7hkF0rbZTTzjO0fC2Z2hfB31yCN9TkwI
 YRREdnhJY.9r4UcRUYyuS.SvNmBkqoWWxrDfUL8aX1IwrDJnwc36v7Kma_GHTQ2yYrmSGyazErVP
 ICBZDqT.c2RKIl8fijrSwZTN0i6tcDtxXpPnZRRKdljzxXXFjZrZF7Qz51AFqWDB5TMGz3gBhFyw
 09fFnolblgn52efjjeoqcbz_xIXVOm4TNyZWPJKTcljZKx5RIHGOmKj.tQOYDTbbuHtyEZH0oaMi
 JMiUDWCGat3NHaAK7Pu7aFovxXhVe1qAjTEdydk6xeMqRR_bShpXJOhJnT6jpSEs53zuqkkj2nME
 bSDvZcad5Vs9cu9bvH8YJ2.5mkmxA.D4lzixkmTutwQ6fYlucsEO8qdIATTGgbsxFgwe.BIcZRWp
 JdKwded4f61C09BBV2CURc87vc76uUPpk1fcmgMn2JtA8n.CUK0tkL702O2MUjQ30j2fwXYNySrZ
 arh8DG.fcgmMpRZLM9n1CSsxAmCc9dY8Wmgd8_J.n2BwSAfHhst.riXuXFZUe9tXtEyE8qjj4pHH
 1amOKJGuPu9jgdPvE5Ube_exeadZuWjNGeKispT7BQvRA4mODPgFWYhqtADTiCyJR4t2JFAtmoMt
 E5.05LRwX1LlfcXobdGWk7.MF6OXw7v3MhJzG_hnOn24tXaxnZ3whkQhusYx15kBq4W7oL0_JWtF
 Kvx4CUrvIpLha2HIx0NT4l9gagHAklydJTxKNUrnOy927brHWmQMGDl3v.G2CGqGS8QJVCnSw5ua
 7b60gE4q0lRl_535j1Nl45mH5WK_BotiupB7osQdLdxn7_GAvmvjiCwZAU.rkVhswRH.TQbC.sMz
 cSC5xsR7UH7qInyyXnwvUn4I7YhSDOrtBqdxEyy6f66w7x09VzBRcY.hmocZuv5yeuZ5sPOOgweb
 nD8.PNgQNRF81pvIAmK6nhk0ixAjvMaS0vzQ9ezLnyArhuqNpEnKYwHdKWZ2tr3G9owA8VLkeD6m
 fxkfzAoTBMDmpjKbDdz.77.grwN8cTmqr2eWk8nvXrYEy5K_XFqGzq0EDtX3rTxAFxk0BofvwwsL
 0NGOaonoL07VVroqfeeqtzRSZsjy5eoVwQB17TWye1_XUE5HQX0OW1dniQplnfQqcKEPvFWXwcYT
 jL.K7OTNA7EJoKgnWrxNWd7Pm0DlnomnYUYDZXl4pMzpHiSclsQoSPvBHou3IIwoBWXNL0DH2xRt
 HEpKgI0vWs2lKV2rKerpl9NUxXkDznEYyaL8nqpAp9dZbknUADR6D6hLvMI0hVIDWXASLnocMbZg
 -
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: a0df7180-4053-4d10-9eed-270763a66ba7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.bf2.yahoo.com with HTTP; Wed, 29 Mar 2023 09:40:30 +0000
Date:   Wed, 29 Mar 2023 09:38:41 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Bcache Linux <linux-bcache@vger.kernel.org>
Message-ID: <1012241948.1268315.1680082721600@mail.yahoo.com>
Subject: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.21284 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hey guys,

I'm using bcache to support Ceph. Ten Cluster nodes have a bcache device ea=
ch consisting of an HDD block device and an NVMe cache. But I am noticing w=
hat I consider to be a problem: My cache is 100% used even though I still h=
ave 80% of the space available on my HDD.

It is true that there is more data written than would fit in the cache. How=
ever, I imagine that most of them should only be on the HDD and not in the =
cache, as they are cold data, almost never used.

I noticed that there was a significant drop in performance on the disks (wr=
ites) and went to check. Benchmark tests confirmed this. Then I noticed tha=
t there was 100% cache full and 85% cache evictable. There was a bit of dir=
ty cache. I found an internet message talking about the garbage collector, =
so I tried the following:

echo 1 > /sys/block/bcache0/bcache/cache/internal/trigger_gc

That doesn't seem to have helped.

Then I collected the following data:

--- bcache ---
Device /dev/sdc (8:32)
UUID 38e81dff-a7c9-449f-9ddd-182128a19b69
Block Size 4.00KiB
Bucket Size 256.00KiB
Congested? False
Read Congestion 0.0ms
Write Congestion 0.0ms
Total Cache Size 553.31GiB
Total Cache Used 547.78GiB (99%)
Total Unused Cache 5.53GiB (1%)
Dirty Data 0B (0%)
Evictable Cache 503.52GiB (91%)
Replacement Policy [lru] fifo random
Cache Mode writethrough [writeback] writearound none
Total Hits 33361829 (99%)
Total Missions 185029
Total Bypass Hits 6203 (100%)
Total Bypass Misses 0
Total Bypassed 59.20MiB
--- Cache Device ---
=C2=A0=C2=A0 Device /dev/nvme0n1p1 (259:1)
=C2=A0=C2=A0 Size 553.31GiB
=C2=A0=C2=A0 Block Size 4.00KiB
=C2=A0=C2=A0 Bucket Size 256.00KiB
=C2=A0=C2=A0 Replacement Policy [lru] fifo random
=C2=A0=C2=A0 Discard? False
=C2=A0=C2=A0 I/O Errors 0
=C2=A0=C2=A0 Metadata Written 395.00GiB
=C2=A0=C2=A0 Data Written 1.50 TiB
=C2=A0=C2=A0 Buckets 2266376
=C2=A0=C2=A0 Cache Used 547.78GiB (99%)
=C2=A0=C2=A0 Cache Unused 5.53GiB (0%)
--- Backing Device ---
=C2=A0=C2=A0 Device /dev/sdc (8:32)
=C2=A0=C2=A0 Size 5.46TiB
=C2=A0=C2=A0 Cache Mode writethrough [writeback] writearound none
=C2=A0=C2=A0 Readhead
=C2=A0=C2=A0 Sequential Cutoff 0B
=C2=A0=C2=A0 Sequential merge? False
=C2=A0=C2=A0 state clean
=C2=A0=C2=A0 Writeback? true
=C2=A0=C2=A0 Dirty Data 0B
=C2=A0=C2=A0 Total Hits 32903077 (99%)
=C2=A0=C2=A0 Total Missions 185029
=C2=A0=C2=A0 Total Bypass Hits 6203 (100%)
=C2=A0=C2=A0 Total Bypass Misses 0
=C2=A0=C2=A0 Total Bypassed 59.20MiB

The dirty data has disappeared. But the cache remains 99% utilization, down=
 just 1%. Already the evictable cache increased to 91%!

The impression I have is that this harms the write cache. That is, if I nee=
d to write again, the data goes straight to the HDD disks, as there is no s=
pace available in the Cache.

Shouldn't bcache remove the least used part of the cache?

Does anyone know why this isn't happening?

I may be talking nonsense, but isn't there a way to tell bcache to keep a w=
rite-free space rate in the cache automatically? Or even if it was manually=
 by some command that I would trigger at low disk access times?

Thanks!
