Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6275E535831
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 06:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235836AbiE0EHh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 00:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbiE0EHf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 00:07:35 -0400
Received: from sonic315-15.consmr.mail.bf2.yahoo.com (sonic315-15.consmr.mail.bf2.yahoo.com [74.6.134.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE2931354
        for <linux-bcache@vger.kernel.org>; Thu, 26 May 2022 21:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1653624448; bh=Je9CNnmAmTKnRq/TBOdfI32lnfrb0ZY2saxl1SibsOQ=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=tsuJaCBU1p4zb8i+xVnKSsBZB1YPne6TfsMox5pDCQ73Z2uiSnUiTQHPRKjwbq48Pg+W/XB1UhdKvvEbrALFdwEHVtUcJ8yBPb/vaDkY7xe/5sXKJY5Nuz6nMA+x7PcbL9YUzaKP8jYA1MBEBy8AW7TOyr5Tx8UKT2nOHGM/vpZG0P1vl95/VLZXLvic+gY7ZK8rXEsW7xFr6rPTzOzFMHmV7jUrpAx3WTeLqw5AWXhTUuS6fiR+dGRERzfCnQYbzlJlp01hBAjUiIOvVpimhJD9ArJtDEpn/OwfR5Y074THLkgGAPVM4nA1uw0gAzi/Nai/EL5jndC+WtODfMJcYw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1653624448; bh=78pKc0+ApSUYpPfBPQrf64eB0572AgmrcoG+96pEMKA=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=XcOaZLjl7BR/R72c/948fj0tlUnoMmN7ZJSzlQ5l0jXKLlryE3clAFrBbbTbdPcbWtUvpnM4am0m9m/u0BVSdZCSW0wzYkhY2h3wcxcCKZeqqfYI8bhDAXLdaUh4oT8LyiT3d+N2tVU4RxI1XOfE6Xd6DmBeIwTm0lEUnjwYkLHw0Wb1p34Fh808rYvnzLGV8KEfKHuqMpa9u5ouproznnxYcxN6InlGMYbPg0zcr9ded5AXXb5bxhjDco8IHgQzSL5TFygBVGY2xU2ASm5KRiycP8iWV7yAZZ+wEJ4NkTlmO5xGeQua/CKlooXznifuemKMRymPm34kuTG4bk7Hiw==
X-YMail-OSG: uGSdijcVM1nIyQTGzRwGCCVfBkE9zYf3l0jnogHKLZgNp91e1H59ASMIcHvrn2f
 caTjeEuGqeXjqWoH6dUgWZN.nwg0LfT4ew_QhJKogzTuXMqHRXOJdaBk5_UgOWsPGo2MNlyqN2s5
 uCnj0eNcwsXPsO.yXsbdKEgkyJXgU5GQqfGU4Dox6EuOrgekANItI5SuuPAiGNAr4ytRLPj6Cu6D
 rdViENhlo40zHnmsDyYn.tW5tM2b0Ca9Iq8h.MCc_jOxW_S2lIYFXrJt1DGJ.rxVbMpIdDUwM2hh
 NZG1Qw3UOVPot31mw6wCT_4Ris3VzCf9Qumz0LSASA51mlWvwckqHqv4XVpQ3VMPivX9QYqE5C7e
 J.tTHcBBrgnEqWeEVpEgPjfna1ns0m.M27WfGX8VF.2mOcYfgtFopl_A14xDrZzs.06XQt1CgGud
 njtf67o8sKe5UNrLbEBUepSiP6Pwl.vs.xoe_AVSMxI83to1._V_Cm40mH4TSCuh.J8VtlR_fvln
 az0_ToS3rlM2t58BBXk7GCbSd.LVGb3Aits.qFXiVYc6E_bjYv6t2qpr_6zdvTQZIt9LdsxprT1l
 jg16Xf77CPgOaYdMSFlBIccgMaRMN7UnlUgqYi33Ozp71hCT3mrAmPv7b._cA9dMl7aR29kApV1D
 eBaLeeHkzZjW36dkuXl6RmDOZ7d..NsU433hHqZpcf3IhvSO_PE9NCd6eR32oohyDlp2p0qYuydk
 S6fGslktU.4Y0aAXQGCgVk_ln.7xqvJ7S_5xarxlPXKcELn4juStb6uSoogOVbdCJT1AjDLlCbae
 VNU.H0p19VjlJdeqmkI_9kGQ_ZQ.8tb1.nGhQQmP5QmoQIxPbpR0QZcZPzZvEMAVXgv7GMMY8c3R
 c.5BJmiIvqzaiJT_xX8CsBQEYMYHunSQoEGoKZWqsltuF71D2UX91.303OybfMg1QqoqBusSNC8J
 8N.cd8yvGhPKO02bfa6MhoFTY0ywiNnbZ1clch4iBv4H7eUIqR8GdP5v7Z3gVTXJjhcbaFIZawqk
 nKGBDcXQ7bnmTZeQW4r563x.rF5o15O8xHSF8oSHmOb6su_cfdlk5Z6ft31ZUD5_CxUBUKCtHTFW
 zcy_ngF48UMkwTXclh3MfdTToWyP68P.1Pm0MgsrjhRK8U8p6dA.KmVSCz.K5iyI2fGNvhz.TerM
 7o.kDtcqXho4wmt5HnRZA5aqDrEiibPil3O2_ANKgtwlZl172wURE.yLcLtT94ySuwKHKXTMxR6j
 Vig7ijVS2F.lgCmxTFL59ErFg7ROgBPcgsaAiTxMIkQ9MREjlQ1KmqzM5XWSE1.GEGdpIg2Fwa82
 VnKiq1fDeH.hMnk7b_3uNEWC8wkRD6SbzpcVSmYTwjygvUn6Nr1L.X7LA.bVoKdHA846cvOaz.nI
 mzqnCl3faOvkcnMAq8nORoBTpC5SszgdsY.iLD_Vg0N5.35epEZdpEzb09YPeabEAhV72QCwfL4r
 a4mozwM2GaremtLAI6iNMOcj12uN2xgSXqYUvsBeWJub7uMGwUN6LslgCOHIRW45kIaVtHEIBZS0
 xUNqxT0qDDvfCbS2wJV4aFbEZVjOLkgwdTPjRH4U8G.bN08xUX9gIYTRcBEsDiGUeigp5kJjm5gy
 H8cWwNij4Ldn82pKTTyF9pHu1RM84ZpNdrYHisGHxu1Nh37dAHJp9dLilNr1xfuuppDpogR_ymzu
 wx5bN7CmpMLWGB0oDrZHNxoIL.I9jRGMMSeI.preFbAHQFwOQ3McgbRglGn2nl1hIqBcQhf6azxP
 PRfHypfphvTvQhHPa4dqprb_WyDPD8LEipql9nOS7_vIEkV0zaWfERmBOkgUxJrmhuordzHzKGI5
 p1u5dQpV5aPvkpB5ctxsISESXjhj8vKrs7OjaaVpd93LlKW9O2.FAOyMZ8GdsMvXPmmokIpQcoyw
 6zrTa0m4FdJeKfPNrg7FDvLFiphOU7Ykn7MBxzYkLJaBDVfGv9w.VY_rJXWYZQHD1UB1DpyS4Ckj
 16OSir5p10tjm_uSg_mI0Qh6YOa.CVh5ZyYybzrDgovADNUou8nwXoloOX4_ND2ZSV.Xury8nMCE
 eAj5qoYwkS.ikY6bwx0kD_YEg84Pr9F.laEXCA1Wk_j7vOROgaxhpWqLwIXaRSdGidSUJAm5OGIQ
 glmDN2q73yxSHI0A0NMbBzzrzFd72uVFZI6oiLus2A894PrvwwDO6KYcj.SseZ47qTJQc02kYvCL
 T6SvL0BjiSjOTlZV89zUIWm6ArGbXoqzXRH084zzvAOJANi1wBYYM.RTzbFLWGMuciGwx
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Fri, 27 May 2022 04:07:28 +0000
Date:   Fri, 27 May 2022 04:07:21 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>, Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Matthias Ferdinand <bcache@mfedv.net>
Message-ID: <532745340.2051210.1653624441686@mail.yahoo.com>
In-Reply-To: <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net>
References: <958894243.922478.1652201375900.ref@mail.yahoo.com> <958894243.922478.1652201375900@mail.yahoo.com> <9d59af25-d648-4777-a5c0-c38c246a9610@ewheeler.net> <681726005.1812841.1653564986700@mail.yahoo.com> <8aac4160-4da5-453b-48ba-95e79fb8c029@ewheeler.net>
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

> Please confirm that this says "write back":

> ]# cat /sys/block/nvme0n1/queue/write_cache

No, this says "write through"


> ]# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; do=
ne
Done!

I can say that the performance of tests after the write back command for al=
l devices greatly worsens the performance of direct tests on NVME hardware.=
 Below you can see this.

What I realized doing the test was, right after doing the blkdiscard on the=
 first server the command took a long time, I think more than 1 minute to r=
eturn. After the return, when doing the ioping it increased the latency a l=
ot that I'm used to. So I turned the server off and on again to discard aga=
in and test. I noticed that he improved, as I demonstrate.

From my understanding of the tests, it was clear that the performance of di=
rect writes to NVME hardware on the two servers is very similar. Perhaps ex=
actly the same. Also in NVME, when writing 512 Bytes at a time, the latency=
 starts well but gets worse after a few write operations, which doesn't hap=
pen when writing 4K which always has better performance.

In all scenarios, when using write cache on /sys/block/nvme0n1/queue/write_=
cache, performance is severely degraded.

Also in all scenarios, when synchronization is required (parameter -Y), the=
 performance is slightly worse.

But between servers, there is no difference in bcache when the backup devic=
e is in RAM.

>I think in newer kernels that bcache is more aggressive at writeback.
>Using /dev/mapper/zero as above will help rule out backing device
>interference.=C2=A0 Also make sure you have the sysfs flags turned to enco=
urge
>it to write to SSD and not bypass

I actually went back to using the previous Kernel version (5.4) after I not=
iced that it wouldn't have improved performance. Today, both servers have v=
ersion 5.4.


Just below the result right after the blkdiscard that took a long time.

=3D=3D=3D=3D=3D=3D=3D=3D=3D
In first server

root@pve-20:~# cat /sys/block/nvme0n1/queue/write_cache
write through
root@pve-20:~# blkdiscard /dev/nvme0n1
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D544.6 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D388.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.44 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D656.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D1.71 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D1.83 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D702.2 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D582.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D1.15 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.07 m=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 9.54 ms, 4.50 KiB written, 943 iops, 471.9 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 388.1 us / 1.06 ms / 1.83 ms / 487.4 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D1.28 ms=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D678.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D725.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.25 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D794.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D493.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D1.10 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D1.06 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D971.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.11 m=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 8.19 ms, 4.50 KiB written, 1.10 k iops, 549.2 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 493.1 us / 910.3 us / 1.25 ms / 235.1 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D471.0 u=
s (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D1.06 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.17 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.29 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D830.5 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D1.31 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D1.40 ms=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D195.0 u=
s (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D841.2 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.22 m=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 9.32 ms, 36 KiB written, 965 iops, 3.77 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 195.0 us / 1.04 ms / 1.40 ms / 352.0 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D645.2 u=
s (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D1.20 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.41 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.39 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D978.4 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D75.8 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D68.6 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D74.0 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D73.7 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D67.0 u=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 5.34 ms, 36 KiB written, 1.68 k iops, 6.58 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 67.0 us / 593.7 us / 1.41 ms / 595.1 us
root@pve-20:~#

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Here, below the results after I shut down the first server and test again:

root@pve-20:~# blkdiscard /dev/nvme0n1
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D68.4 us=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D76.5 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D67.0 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D60.1 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D463.9 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D471.4 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D505.1 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D501.0 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D486.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D520.4 =
us (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 3.15 ms, 4.50 KiB written, 2.85 k iops, 1.39 MiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 60.1 us / 350.2 us / 520.4 us / 200.3 us
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D460.8 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D507.5 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D514.9 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D505.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D500.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D503.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D506.9 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D499.4 u=
s (fast)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D500.1 u=
s (fast)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D502.4 =
us

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 4.54 ms, 4.50 KiB written, 1.98 k iops, 991.0 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 499.4 us / 504.5 us / 514.9 us / 4.64 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D56.7 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D81.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D60.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D78.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D75.1 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D79.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D91.2 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D76.6 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D79.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D87.1 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 708.4 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 60.0 us / 78.7 us / 91.2 us / 8.20 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D86.6 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D72.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D60.5 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D70.5 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D72.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D60.2 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D83.5 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D60.4 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D86.0 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D61.2 u=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 627.7 us, 36 KiB written, 14.3 k iops, 56.0 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 60.2 us / 69.7 us / 86.0 us / 9.49 us
root@pve-20:~#

=3D=3D=3D=3D=3D=3D=3D=20
On the second server...
On the second server, blkdiscard didn't take long and the first result was =
the one below:

root@pve-21:~# cat /sys/block/nvme0n1/queue/write_cache
write through
root@pve-21:~# blkdiscard /dev/nvme0n1
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D60.7 us=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D71.9 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D77.4 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D61.2 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D468.2 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D497.0 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D491.8 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D490.6 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D494.4 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D493.9 =
us (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 3.15 ms, 4.50 KiB written, 2.86 k iops, 1.40 MiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 61.2 us / 349.6 us / 497.0 us / 197.8 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D494.5 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D490.6 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D490.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D489.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D492.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D488.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D496.0 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D492.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D493.0 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D508.0 =
us (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 4.44 ms, 4.50 KiB written, 2.03 k iops, 1013.5 KiB/=
s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 488.1 us / 493.3 us / 508.0 us / 5.60 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D84.9 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D75.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D76.5 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D76.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D77.6 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D78.8 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D84.2 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D85.0 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D79.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D97.1 u=
s (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 730.1 us, 36 KiB written, 12.3 k iops, 48.1 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 75.7 us / 81.1 us / 97.1 us / 6.48 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D80.8 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D77.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D70.9 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D69.1 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D72.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D68.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D71.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D86.7 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D93.2 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D64.8 u=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 674.3 us, 36 KiB written, 13.3 k iops, 52.1 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 64.8 us / 74.9 us / 93.2 us / 8.79 us
root@pve-21:~#

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
After switching to wirte back and going back to write through.
In first server...

oot@pve-20:~# for i in /sys/block/*/queue/write_cache; do echo 'write back'=
 > $i; done
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D2.31 ms=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D2.37 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D2.40 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D2.45 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D2.57 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D2.46 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D2.57 ms=
 (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D2.56 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D2.38 ms=
 (fast)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D2.48 m=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 22.2 ms, 4.50 KiB written, 404 iops, 202.4 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 2.37 ms / 2.47 ms / 2.57 ms / 75.2 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D1.16 ms=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D1.15 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.14 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.15 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D1.17 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D1.15 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D1.13 ms=
 (fast)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D1.14 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D1.22 ms=
 (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.20 m=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 10.5 ms, 4.50 KiB written, 860 iops, 430.1 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 1.13 ms / 1.16 ms / 1.22 ms / 27.6 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D2.03 ms=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D2.04 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D2.07 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D2.07 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D2.05 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D2.02 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D2.05 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D2.09 ms=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D2.04 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.99 m=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 18.4 ms, 36 KiB written, 489 iops, 1.91 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 1.99 ms / 2.04 ms / 2.09 ms / 29.0 us
root@pve-20:~#
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D703.4 u=
s (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D725.1 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D724.8 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D705.7 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D733.1 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D697.6 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D690.2 u=
s (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D688.4 u=
s (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D689.5 u=
s (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D671.7 =
us (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 6.33 ms, 36 KiB written, 1.42 k iops, 5.56 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 671.7 us / 702.9 us / 733.1 us / 19.6 us
root@pve-20:~#
root@pve-20:~# for i in /sys/block/*/queue/write_cache; do echo 'write thro=
ugh' > $i; done
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D82.6 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D89.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D61.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D74.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D89.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D62.5 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D74.1 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D81.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D78.1 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D84.3 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 694.9 us, 36 KiB written, 13.0 k iops, 50.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 61.7 us / 77.2 us / 89.4 us / 9.67 us
root@pve-20:~#

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
On=C2=A0 the second server...

root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write back=
' > $i; done
root@pve-21:~# blkdiscard /dev/nvme0n1
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D1.83 ms=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D2.39 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D2.40 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D2.21 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D2.44 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D2.34 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D2.34 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D2.42 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D2.22 ms=
 (fast)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D2.20 m=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 21.0 ms, 4.50 KiB written, 429 iops, 214.7 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 2.20 ms / 2.33 ms / 2.44 ms / 88.9 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D1.12 ms=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D663.6 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.12 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.11 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D1.11 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D1.16 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D1.18 ms=
 (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D1.11 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D1.16 ms
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.17 m=
s (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 9.78 ms, 4.50 KiB written, 920 iops, 460.2 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 663.6 us / 1.09 ms / 1.18 ms / 151.9 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D1.85 ms=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D1.81 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D1.82 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D1.82 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D2.01 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D1.99 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D1.98 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D1.95 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D1.83 ms
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D1.82 m=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 17.0 ms, 36 KiB written, 528 iops, 2.06 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 1.81 ms / 1.89 ms / 2.01 ms / 82.3 us
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D673.1 u=
s (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D667.1 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D688.2 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D653.1 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D661.5 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D663.3 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D698.0 u=
s (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D663.7 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D708.6 u=
s (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D677.2 =
us

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 6.08 ms, 36 KiB written, 1.48 k iops, 5.78 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 653.1 us / 675.6 us / 708.6 us / 17.7 us
root@pve-21:~#
root@pve-21:~# for i in /sys/block/*/queue/write_cache; do echo 'write thro=
ugh' > $i; done
root@pve-21:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D85.3 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D79.8 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D74.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D85.6 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D66.8 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D92.2 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D73.5 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D65.0 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D73.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D73.2 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 683.7 us, 36 KiB written, 13.2 k iops, 51.4 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 65.0 us / 76.0 us / 92.2 us / 8.17 us
root@pve-21:~#

As you can see from the tests, the write performance on NVME hardware is ho=
rrible when putting /sys/block/*/queue/write_cache as 'write back'.


=3D=3D=3D=3D=3D
Lets go..

root@pve-21:~# modprobe brd rd_size=3D$((128*1024))
root@pve-21:~# cat << EOT | dmsetup create zero
=C2=A0=C2=A0=C2=A0 0 262144 linear /dev/ram0 0
=C2=A0=C2=A0=C2=A0 262144 2147483648 zero
> EOT
root@pve-21:~# blkdiscard /dev/nvme0n1
root@pve-21:~# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --wri=
teback
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0563eaa85-43e9=
-491b-8c1f-f1b94a8f97c8
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00dcec849-9ee9-41a9-b220-b192=
3e93cdb1
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
nbuckets:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01831430
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
bucket_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01024
nr_in_set:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
nr_this_dev:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
first_bucket:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0acdd0f18-4198=
-43dd-847a-087058d80c25
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00dcec849-9ee9-41a9-b220-b192=
3e93cdb1
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
data_offset:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A016
root@pve-21:~#
root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D3.04 ms =
(warmup)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.98 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.88 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.95 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.78 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.92 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D1.87 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.87 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D1.87 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D1.83 ms

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 17.0 ms, 4.50 KiB written, 530 iops, 265.2 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 1.78 ms / 1.89 ms / 1.98 ms / 57.4 us
root@pve-21:~#
root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s512
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D1.12 ms =
(warmup)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.01 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.00 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.05 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.04 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.04 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D996.5 us=
 (fast)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.01 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D994.3 us=
 (fast)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D976.5 u=
s (fast)

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 9.11 ms, 4.50 KiB written, 987 iops, 493.9 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 976.5 us / 1.01 ms / 1.05 ms / 22.5 us
root@pve-21:~#
root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D1.43 ms =
(warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.39 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.38 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.40 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.40 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.43 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D1.39 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.42 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D1.41 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D1.40 ms

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 12.6 ms, 36 KiB written, 713 iops, 2.79 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 1.38 ms / 1.40 ms / 1.43 ms / 13.1 us
root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D676.0 us=
 (warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D638.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D659.5 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D650.2 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D644.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D644.4 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D652.1 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D641.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D658.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D642.7 u=
s

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 5.83 ms, 36 KiB written, 1.54 k iops, 6.03 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 638.0 us / 647.9 us / 659.5 us / 7.06 us
root@pve-21:~#

=3D=3D=3D=3D=3D=3D=3D=3D=3D
Now, bcache -w 4k

root@pve-21:~# blkdiscard /dev/nvme0n1
root@pve-21:~# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --wr=
iteback
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0c955591f-21af=
-467d-b26a-5ff567af2001
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08c477796-88ab-4b20-990a-cef8=
b2df040a
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
nbuckets:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01831430
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08
bucket_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01024
nr_in_set:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
nr_this_dev:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
first_bucket:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0ea89b843-a019=
-4464-8da5-377ba44f0e6b
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08c477796-88ab-4b20-990a-cef8=
b2df040a
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08
data_offset:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A016
root@pve-21:
root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
ioping: request failed: Invalid argument
root@pve-21:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D2.93 ms =
(warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D313.2 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D274.1 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D296.4 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D247.2 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D227.4 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D224.6 us=
 (fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D253.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D235.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D197.6 u=
s (fast)

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 2.27 ms, 36 KiB written, 3.96 k iops, 15.5 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 197.6 us / 252.2 us / 313.2 us / 34.7 us
root@pve-21:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D262.8 us=
 (warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D255.9 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D239.9 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D228.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D252.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D237.1 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D237.5 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D232.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D243.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D232.7 u=
s

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 2.16 ms, 36 KiB written, 4.17 k iops, 16.3 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 228.8 us / 240.0 us / 255.9 us / 8.62 us


=3D=3D=3D=3D=3D=3D=3D=3D=3D
On the first server

root@pve-20:~# modprobe brd rd_size=3D$((128*1024))
root@pve-20:~# cat << EOT | dmsetup create zero
>=C2=A0=C2=A0=C2=A0=C2=A0 0 262144 linear /dev/ram0 0
>=C2=A0=C2=A0=C2=A0=C2=A0 262144 2147483648 zero
> EOT
root@pve-20:~# blkdiscard /dev/nvme0n1
root@pve-20:~# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n1 --wri=
teback
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0f82f76a1-8f41=
-4a0a-9213-f4632fa372a4
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0d6ba5557-3055-4151-bd91-05db=
6a668ba7
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
nbuckets:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01831430
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
bucket_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01024
nr_in_set:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
nr_this_dev:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
first_bucket:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A05c3d1795-c484=
-4611-881f-bc991642aa76
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0d6ba5557-3055-4151-bd91-05db=
6a668ba7
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
data_offset:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A016
root@pve-20:~# ls /sys/fs/bcache/
d6ba5557-3055-4151-bd91-05db6a668ba7/ register
pendings_cleanup=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 regis=
ter_quiet
root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D3.05 ms =
(warmup)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.98 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.99 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.94 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.88 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.77 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D1.82 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.86 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D1.99 ms =
(slow)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D1.82 ms

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 17.1 ms, 4.50 KiB written, 527 iops, 263.9 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 1.77 ms / 1.89 ms / 1.99 ms / 76.6 us
root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s512
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D1.05 ms =
(warmup)
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.07 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.04 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.01 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.11 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.06 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D1.03 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.06 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D1.04 ms
512 B >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D1.06 ms

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 9.49 ms, 4.50 KiB written, 948 iops, 474.1 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 1.01 ms / 1.05 ms / 1.11 ms / 26.3 us
root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D1.47 ms =
(warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D1.57 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D1.57 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D1.52 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D1.11 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D1.02 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D1.03 ms =
(fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D1.04 ms =
(fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D1.45 ms
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D1.45 ms

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 11.8 ms, 36 KiB written, 765 iops, 2.99 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 1.02 ms / 1.31 ms / 1.57 ms / 232.7 us
root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D249.7 us=
 (warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D671.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D663.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D655.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D664.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D693.7 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D610.5 us=
 (fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D217.8 us=
 (fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D223.0 us=
 (fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D219.7 u=
s (fast)

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 4.62 ms, 36 KiB written, 1.95 k iops, 7.61 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 217.8 us / 513.1 us / 693.7 us / 208.2 us
root@pve-20:~#

root@pve-20:~# blkdiscard /dev/nvme0n1
root@pve-20:~# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0n1 --wr=
iteback
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0c0252cdb-6a3b=
-43c1-8c86-3f679dd61d06
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0e56ca07c-4b1a-4bea-8bd4-2cab=
b60cb4f0
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
nbuckets:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01831430
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08
bucket_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01024
nr_in_set:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
nr_this_dev:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A00
first_bucket:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A02c501dde-dd04=
-4294-9e35-8f3b57fdd75d
Set UUID:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0e56ca07c-4b1a-4bea-8bd4-2cab=
b60cb4f0
version:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A01
block_size:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A08
data_offset:=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A016
root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
ioping: request failed: Invalid argument
root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s512
ioping: request failed: Invalid argument
root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D2.91 ms =
(warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D227.9 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D353.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D193.2 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D189.0 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D340.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D259.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D254.9 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D285.3 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D282.7 u=
s

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 2.39 ms, 36 KiB written, 3.77 k iops, 14.7 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 189.0 us / 265.2 us / 353.8 us / 54.5 us
root@pve-20:~# ioping -c10 /dev/bcache0 -D -WWW -s4K
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D1 time=3D276.3 us=
 (warmup)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D2 time=3D224.6 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D3 time=3D226.8 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D4 time=3D240.1 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D5 time=3D237.4 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D6 time=3D231.6 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D7 time=3D238.1 us
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D8 time=3D199.1 us=
 (fast)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D9 time=3D240.4 us=
 (slow)
4 KiB >>> /dev/bcache0 (block device 1.00 TiB): request=3D10 time=3D280.5 u=
s (slow)

--- /dev/bcache0 (block device 1.00 TiB) ioping statistics ---
9 requests completed in 2.12 ms, 36 KiB written, 4.25 k iops, 16.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 199.1 us / 235.4 us / 280.5 us / 20.0 us
root@pve-20:~#


In addition to the request, I decided to add these results to help:

root@pve-20:~# ioping -c5 /dev/mapper/zero -D -Y -WWW -s512
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D14.4=
 us (warmup)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D19.9=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D23.4=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D17.5=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D19.4=
 us

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
4 requests completed in 80.2 us, 2 KiB written, 49.9 k iops, 24.4 MiB/s
generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s

min/avg/max/mdev =3D 17.5 us / 20.0 us / 23.4 us / 2.12 us

root@pve-20:~# ioping -c5 /dev/mapper/zero -D -WWW -s512
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D14.4=
 us (warmup)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D13.0=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D18.8=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D17.4=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D18.8=
 us

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
4 requests completed in 67.9 us, 2 KiB written, 58.9 k iops, 28.8 MiB/s
generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
min/avg/max/mdev =3D 13.0 us / 17.0 us / 18.8 us / 2.38 us
root@pve-20:~# ioping -c5 /dev/mapper/zero -D -Y -WWW -s4K
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D24.6=
 us (warmup)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D27.2=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D21.1=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D17.0=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D22.8=
 us

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
4 requests completed in 88.0 us, 16 KiB written, 45.4 k iops, 177.5 MiB/s
generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
min/avg/max/mdev =3D 17.0 us / 22.0 us / 27.2 us / 3.65 us
root@pve-20:~# ioping -c5 /dev/mapper/zero -D -WWW -s4K
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D22.9=
 us (warmup)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D15.7=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D21.5=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D21.1=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D24.3=
 us

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
4 requests completed in 82.6 us, 16 KiB written, 48.4 k iops, 189.2 MiB/s
generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
min/avg/max/mdev =3D 15.7 us / 20.6 us / 24.3 us / 3.09 us
root@pve-20:~#

root@pve-20:~# blkdiscard /dev/nvme0n1
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D82.7 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D78.6 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D63.2 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D72.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D75.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D82.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D71.9 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D84.8 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D95.6 us=
 (slow)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D84.9 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 709.1 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 63.2 us / 78.8 us / 95.6 us / 8.89 us
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D68.3 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D70.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D81.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D81.9 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D83.0 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D91.7 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D71.1 us=
 (fast)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D87.9 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D81.2 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D60.4 u=
s (fast)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 708.9 us, 36 KiB written, 12.7 k iops, 49.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 60.4 us / 78.8 us / 91.7 us / 9.18 us
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D59.2 us=
 (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D63.6 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D64.8 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D63.4 us
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D516.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D502.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D510.5 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D502.9 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D496.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D505.5 =
us (slow)

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 3.23 ms, 4.50 KiB written, 2.79 k iops, 1.36 MiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 63.4 us / 358.4 us / 516.1 us / 208.2 us
root@pve-20:~# ioping -c10 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D491.5 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D496.1 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D506.9 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D510.7 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D503.2 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D6 time=3D501.4 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D7 time=3D498.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D8 time=3D510.4 u=
s (slow)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D9 time=3D502.4 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D10 time=3D501.3 =
us

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
9 requests completed in 4.53 ms, 4.50 KiB written, 1.99 k iops, 993.1 KiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 496.1 us / 503.5 us / 510.7 us / 4.70 us
root@pve-20:~#


root@pve-21:~# ioping -c10 /dev/mapper/zero -D -Y -WWW -s512
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D13.4=
 us (warmup)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D22.6=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D15.3=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D26.1=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D15.2=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D6 time=3D20.8=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D7 time=3D24.9=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D8 time=3D15.2=
 us (fast)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D9 time=3D15.2=
 us (fast)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D10 time=3D15.=
7 us (fast)

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
9 requests completed in 171.0 us, 4.50 KiB written, 52.6 k iops, 25.7 MiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 15.2 us / 19.0 us / 26.1 us / 4.34 us
root@pve-21:~# ioping -c10 /dev/mapper/zero -D -WWW -s512
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D14.3=
 us (warmup)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D22.4=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D25.9=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D14.8=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D24.8=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D6 time=3D24.6=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D7 time=3D13.7=
 us (fast)
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D8 time=3D18.2=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D9 time=3D15.4=
 us
512 B >>> /dev/mapper/zero (block device 1.00 TiB): request=3D10 time=3D15.=
2 us

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
9 requests completed in 174.9 us, 4.50 KiB written, 51.5 k iops, 25.1 MiB/s
generated 10 requests in 9.00 s, 5 KiB, 1 iops, 568 B/s
min/avg/max/mdev =3D 13.7 us / 19.4 us / 25.9 us / 4.67 us
root@pve-21:~# ioping -c10 /dev/mapper/zero -D -Y -WWW -s4K
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D22.3=
 us (warmup)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D17.3=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D26.0=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D27.0=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D15.7=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D6 time=3D18.1=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D7 time=3D17.8=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D8 time=3D16.9=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D9 time=3D15.4=
 us (fast)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D10 time=3D15.=
5 us (fast)

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
9 requests completed in 169.7 us, 36 KiB written, 53.0 k iops, 207.2 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 15.4 us / 18.9 us / 27.0 us / 4.21 us
root@pve-21:~# ioping -c10 /dev/mapper/zero -D -WWW -s4K
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D1 time=3D22.4=
 us (warmup)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D2 time=3D15.3=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D3 time=3D26.1=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D4 time=3D15.0=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D5 time=3D15.0=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D6 time=3D17.8=
 us
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D7 time=3D15.3=
 us (fast)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D8 time=3D15.3=
 us (fast)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D9 time=3D15.0=
 us (fast)
4 KiB >>> /dev/mapper/zero (block device 1.00 TiB): request=3D10 time=3D14.=
9 us (fast)

--- /dev/mapper/zero (block device 1.00 TiB) ioping statistics ---
9 requests completed in 149.6 us, 36 KiB written, 60.2 k iops, 235.0 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 14.9 us / 16.6 us / 26.1 us / 3.47 us
root@pve-21:~#
root@pve-21:~# blkdiscard /dev/nvme0n1
root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D461.1 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D476.4 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D479.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D480.2 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D480.9 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
4 requests completed in 1.92 ms, 2 KiB written, 2.09 k iops, 1.02 MiB/s
generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
min/avg/max/mdev =3D 476.4 us / 479.2 us / 480.9 us / 1.73 us
root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s512
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D456.1 u=
s (warmup)
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D423.0 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D424.8 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D433.3 u=
s
512 B >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D446.3 u=
s

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
4 requests completed in 1.73 ms, 2 KiB written, 2.31 k iops, 1.13 MiB/s
generated 5 requests in 4.00 s, 2.50 KiB, 1 iops, 639 B/s
min/avg/max/mdev =3D 423.0 us / 431.9 us / 446.3 us / 9.23 us
root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -Y -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D88.9 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D79.8 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D70.9 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D94.3 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D72.8 us

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
4 requests completed in 317.7 us, 16 KiB written, 12.6 k iops, 49.2 MiB/s
generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
min/avg/max/mdev =3D 70.9 us / 79.4 us / 94.3 us / 9.20 us
root@pve-21:~# ioping -c5 /dev/nvme0n1 -D -WWW -s4K
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D1 time=3D86.4 us=
 (warmup)
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D2 time=3D119.0 u=
s
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D3 time=3D66.1 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D4 time=3D72.4 us
4 KiB >>> /dev/nvme0n1 (block device 894.3 GiB): request=3D5 time=3D73.1 us

--- /dev/nvme0n1 (block device 894.3 GiB) ioping statistics ---
4 requests completed in 330.6 us, 16 KiB written, 12.1 k iops, 47.3 MiB/s
generated 5 requests in 4.00 s, 20 KiB, 1 iops, 5.00 KiB/s
min/avg/max/mdev =3D 66.1 us / 82.7 us / 119.0 us / 21.2 us
root@pve-21:~#

Em quinta-feira, 26 de maio de 2022 17:28:36 BRT, Eric Wheeler <bcache@list=
s.ewheeler.net> escreveu:=20





On Thu, 26 May 2022, Adriano Silva wrote:
> This is a enterprise NVMe device with Power Loss Protection system. It=20
> has a non-volatile cache.
>=20
> Before purchasing these enterprise devices, I did tests with consumer=20
> NVMe. Consumer device performance is acceptable only on hardware cached=
=20
> writes. But on the contrary on consumer devices in tests with fio=20
> passing parameters for direct and synchronous writing (--direct=3D1=20
> --fsync=3D1 --rw=3Drandwrite --bs=3D4K --numjobs=3D1 --iodepth=3D 1) the=
=20
> performance is very low. So today I'm using enterprise NVME with=20
> tantalum capacitors which makes the cache non-volatile and performs much=
=20
> better when written directly to the hardware. But the performance issue=
=20
> is only occurring when the write is directed to the bcache device.
>=20
> Here is information from my Hardware you asked for (Eric), plus some=20
> additional information to try to help.
>=20
> root@pve-20:/# blockdev --getss /dev/nvme0n1
> 512
> root@pve-20:/# blockdev --report /dev/nvme0n1
> RO=C2=A0=C2=A0=C2=A0 RA=C2=A0=C2=A0 SSZ=C2=A0=C2=A0 BSZ=C2=A0=C2=A0 Start=
Sec=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Size=
=C2=A0=C2=A0 Device
> rw=C2=A0=C2=A0 256=C2=A0=C2=A0 512=C2=A0 4096=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 960197124096=C2=A0=C2=A0 /d=
ev/nvme0n1

> root@pve-20:~# nvme id-ctrl -H /dev/nvme0n1 |grep -A1 vwc
> vwc=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 0
> =C2=A0 [0:0] : 0=C2=A0=C2=A0 =C2=A0Volatile Write Cache Not Present

Please confirm that this says "write back":

]# cat /sys/block/nvme0n1/queue/write_cache=20

Try this to set _all_ blockdevs to write-back and see if it affects
performance (warning: power loss is unsafe for non-volatile caches after=20
this command):

]# for i in /sys/block/*/queue/write_cache; do echo 'write back' > $i; done

> An interesting thing to note is that when I test using fio with=20
> --bs=3D512, the direct hardware performance is horrible (~1MB/s).

I think you know this already, but for CYA:

=C2=A0 WARNING: THESE ARE DESTRUCTIVE WRITES, DO NOT USE ON PRODUCTION DATA=
!

Please post `ioping` stats for each server you are testing (some of these=
=20
you may have already posted, but if you can place them inline of this same=
=20
response it would be helpful so we don't need to dig into old emails).

]# blkdiscard /dev/nvme0n1

]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s512
]# ioping -c10 /dev/nvme0n1 -D -WWW -s512

]# ioping -c10 /dev/nvme0n1 -D -Y -WWW -s4k
]# ioping -c10 /dev/nvme0n1 -D -WWW -s4k

Next, lets rule out backing-device interference by creating a dummy
mapper device that has 128mb of ramdisk for persistent meta storage
(superblock, LVM, etc) but presents as a 1TB volume in size; writes
beyond 128mb are dropped:

=C2=A0=C2=A0=C2=A0 modprobe brd rd_size=3D$((128*1024))

=C2=A0=C2=A0=C2=A0 ]# cat << EOT | dmsetup create zero
=C2=A0=C2=A0=C2=A0 0 262144 linear /dev/ram0 0
=C2=A0=C2=A0=C2=A0 262144 2147483648 zero
=C2=A0=C2=A0=C2=A0 EOT

Then use that as your backing device:

=C2=A0=C2=A0=C2=A0 ]# blkdiscard /dev/nvme0n1
=C2=A0=C2=A0=C2=A0 ]# make-bcache -w 512 -B /dev/mapper/zero -C /dev/nvme0n=
1 --writeback

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
]# ioping -c10 /dev/bcache0 -D -WWW -s512

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
]# ioping -c10 /dev/bcache0 -D -WWW -s4k

Test again with -w 4096:
=C2=A0=C2=A0=C2=A0 ]# blkdiscard /dev/nvme0n1
=C2=A0=C2=A0=C2=A0 ]# make-bcache -w 4096 -B /dev/mapper/zero -C /dev/nvme0=
n1 --writeback

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
]# ioping -c10 /dev/bcache0 -D -WWW -s4k

# These should error with -w 4096 because 512 is too small:

]# ioping -c10 /dev/bcache0 -D -Y -WWW -s512
]# ioping -c10 /dev/bcache0 -D -WWW -s512

> root@pve-20:/# fio --filename=3D/dev/nvme0n1p2 --direct=3D1 --fsync=3D1 -=
-rw=3Drandwrite --bs=3D512 --numjobs=3D1 --iodepth=3D1 --runtime=3D5 --time=
_based --group_reporting --name=3Djournal-test --ioengine=3Dlibaio
> =C2=A0 write: IOPS=3D2087, BW=3D1044KiB/s (1069kB/s)(5220KiB/5001msec); 0=
 zone resets
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^^^^^^^^=20
> But the same test directly on the hardware with fio passing the
> parameter --bs=3D4K, the performance completely changes, for the better
> (~130MB/s).
>
> root@pve-20:/# fio --filename=3D/dev/nvme0n1p2 --direct=3D1 --fsync=3D1 -=
-rw=3Drandwrite --bs=3D4K --numjobs=3D1 --iodepth=3D1 --runtime=3D5 --time_=
based --group_reporting --name=3Djournal-test --ioengine=3Dlibaio
> =C2=A0 write: IOPS=3D31.9k, BW=3D124MiB/s (131MB/s)(623MiB/5001msec); 0 z=
one resets
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^^^^^^^^^
> Does anything justify this difference?

I think you may have discovered the problem and the `ioping`s above
might confirm that.

IOPS are a better metric here, not MB/sec because smaller IOs will
always be smaller bandwidth because they are smaller and RTT is a
factor.=C2=A0 However, IOPS are ~16x lower than the expected 8x difference
(512/4096=3D1/8) so something else is going on.=20

The hardware is probably addressed 4k internally "4Kn" (with even larger=20
erase pages that the FTL manages).=C2=A0 Sending it a bunch of 512-byte IOs=
 may=20
trigger a read-modify-write operation on the flash controller and is=20
(probably) spinning CPU cycles on the flash controller itself. A firmware=
=20
upgrade on the NVMe might help if they have addressed this.

This is speculaution, but assuming that internally the flash uses 4k=20
sectors, it is doing something like this (pseudo code):

=C2=A0=C2=A0=C2=A0 1. new_data =3D fetch_from_pcie()
=C2=A0=C2=A0=C2=A0 2. rmw =3D read_sector(LBA)
=C2=A0=C2=A0=C2=A0 3. memcpy(rmw+offset, new_data, 512)
=C2=A0=C2=A0=C2=A0 4. queue_write_to_flash(rmw, LBA)

> Maybe that's why when I create bcache with the -w=3D4K option the=20
> performance improves. Not as much as I'd like, but it gets better.
> [...]=20
> The buckets, I read that it would be better to put the hardware device=20
> erase block size. However, I have already tried to find this information=
=20
> by reading the device, also with the manufacturer, but without success.=
=20
> So I have no idea which bucket size would be best, but from my tests,=20
> the default of 512KB seems to be adequate.

It might be worth testing power-of-2 bucket sizes to see what works best
for your workload.=C2=A0 Note that `fio --rw=3Drandwrite` may not be
representative of your "real" workload so randwrite could be a good
place to start, but bench your real workload against bucket sizes to see
what works best.

> Eric, perhaps it is not such a simple task to recompile the Kernel with=
=20
> the suggested change. I'm working with Proxmox 6.4. I'm not sure, but I=
=20
> think the Kernel may have some adaptation. It is based on Kernel 5.4,=20
> which it is approved for.

Keith and Christoph corrected me; as noted above, this does the same=20
thing, so no need to hack on the kernel to change flush behavior:

=C2=A0=C2=A0=C2=A0 echo 'write back' > /sys/block/<DEV>/queue/write_cache

> Also listening to Coly's suggestion, I'll try to perform tests with the=
=20
> Kernel version 5.15 to see if it can solve. Would this version be good=20
> enough? It's just that, as I said above, as I'm using Proxmox, I'm=20
> afraid to change the Kernel version they provide.

I'm guessing proxmox doesn't care too much about the kernel version as
long as the modules you use are built.=C2=A0 Just copy your existing .confi=
g
(usually /boot/config-<version>) as
kernel-source-dir/.config and run `make oldconfig` (or `make menuconfig`
and save+exit, which is what I usually do).

> Eric, to be clear, the hardware I'm using has only 1 processor socket.

Ok, so not a cacheline bounce issue.

> I'm trying to test with another identical computer (the same=20
> motherboard, the same processor, the same NVMe, with the difference that=
=20
> it only has 12GB of RAM, the first having 48GB). It is an HP Z400=20
> Workstation with an Intel Xeon X5680 sixcore processor (12 threads),=20
> DDR3 1333MHz 10600E (old computer).

Is this second server still a single-socket?

> On the second computer, I put a newer version of the distribution that=20
> uses Kernel based on version 5.15. I am now comparing the performance of=
=20
> the two computers in the lab.
>=20
> On this second computer I had worse performance than the first one=20
> (practically half the performance with bcache), despite the performance=
=20
> of the tests done directly in NVME being identical.
>=20
> I tried going back to the same OS version on the first computer to try=20
> and keep the exact same scenario on both computers so I could first=20
> compare the two. I try to keep the exact same software configuration.=20
> However, there were no changes. Is it the low RAM that makes the=20
> performance worse in the second?

The amount of memory isn't an issue, but CPU clock speed or memory speed=20
might.=C2=A0 If server-2 has 2x sockets then make sure NVMe interrupts hit =
the=20
socket where it is attached.=C2=A0 Could be a PCIe version thing, but I=20
don't think you are saturating the PCIe link.

> I noticed a difference in behavior on the second computer compared to=20
> the first in dstat. While the first computer doesn't seem to touch the=20
> backup device at all, the second computer signals something a little=20
> different, as although it doesn't write data to the backup disk, it does=
=20
> signal IO movement. Strange no?
>=20
> Let's look at the dstat of the first computer:
>=20
> --dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -=
net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- as=
ync
> =C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0=
 15m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 ti=
me=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |6953B 7515B|0.13 0.26 0.26|=C2=A0 0=C2=A0=
=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 399=C2=A0=C2=A0 634 |25-05 0=
9:41:42|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0 8192B:4096B 2328k:=C2=A0=C2=A0 0=C2=A0 1168k|=C2=A0=
=C2=A0 0=C2=A0 2.00 :1.00=C2=A0=C2=A0 586 :=C2=A0=C2=A0 0=C2=A0=C2=A0 587 |=
9150B 2724B|0.13 0.26 0.26|=C2=A0 2=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 0=C2=
=A0=C2=A0 0|1093=C2=A0 3267 |25-05 09:41:43|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.8k:=C2=A0=C2=A0 0=C2=A0 14.7k|=C2=A0 1=
4k 9282B|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 94=C2=A0=C2=A0 2=C2=A0=
=C2=A0 0|=C2=A0 16k=C2=A0=C2=A0 67k|25-05 09:41:44|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.9k:=C2=A0=C2=A0 0=C2=A0 14.8k|=C2=A0 1=
0k 8992B|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 93=C2=A0=C2=A0 2=C2=A0=
=C2=A0 0|=C2=A0 16k=C2=A0=C2=A0 69k|25-05 09:41:45|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 58M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 29M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.9k:=C2=A0=C2=A0 0=C2=A0 14.8k|7281B 46=
51B|0.13 0.26 0.26|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 92=C2=A0=C2=A0 4=C2=A0=C2=
=A0 0|=C2=A0 16k=C2=A0=C2=A0 67k|25-05 09:41:46|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 59M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 30M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 15.2k:=C2=A0=C2=A0 0=C2=A0 15.1k|7849B 47=
29B|0.20 0.28 0.27|=C2=A0 1=C2=A0=C2=A0 4=C2=A0 94=C2=A0=C2=A0 2=C2=A0=C2=
=A0 0|=C2=A0 16k=C2=A0=C2=A0 69k|25-05 09:41:47|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 57M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 28M|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 14.4k:=C2=A0=C2=A0 0=C2=A0 14.4k|=C2=A0 1=
1k 8584B|0.20 0.28 0.27|=C2=A0 1=C2=A0=C2=A0 3=C2=A0 94=C2=A0=C2=A0 2=C2=A0=
=C2=A0 0|=C2=A0 15k=C2=A0=C2=A0 65k|25-05 09:41:48|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |4086B 7720B|0.20 0.28 0.27|=C2=A0 0=C2=A0=
=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 274=C2=A0=C2=A0 332 |25-05 09:41:=
49|=C2=A0=C2=A0 0
>=20
> Note that on this first computer, the writings and IOs of the backing=20
> device (sdb) remain motionless. While NVMe device IOs track bcache0=20
> device IOs at ~14.8K
>=20
> Let's see the dstat now on the second computer:
>=20
> --dsk/sdd---dsk/nvme0n1-dsk/bcache0 ---io/sdd----io/nvme0n1--io/bcache0 -=
net/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- as=
ync
> =C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0=
 15m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 ti=
me=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |9254B 3301B|0.15 0.19 0.11|=C2=A0 1=C2=A0=
=C2=A0 2=C2=A0 97=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 360=C2=A0=C2=A0 318 |26-05 0=
6:27:15|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0 8192B:4096B=C2=A0=C2=A0 19M:=C2=A0=C2=A0 0=C2=A0 960=
0k|=C2=A0=C2=A0 0=C2=A0 2402 :1.00=C2=A0 4816 :=C2=A0=C2=A0 0=C2=A0 4801 |8=
826B 3619B|0.15 0.19 0.11|=C2=A0 0=C2=A0=C2=A0 1=C2=A0 98=C2=A0=C2=A0 0=C2=
=A0=C2=A0 0|8115=C2=A0=C2=A0=C2=A0 27k|26-05 06:27:16|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 21M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2737 :=C2=
=A0=C2=A0 0=C2=A0 5492 :=C2=A0=C2=A0 0=C2=A0 5474 |4051B 2552B|0.15 0.19 0.=
11|=C2=A0 0=C2=A0=C2=A0 2=C2=A0 97=C2=A0=C2=A0 1=C2=A0=C2=A0 0|9212=C2=A0=
=C2=A0=C2=A0 31k|26-05 06:27:17|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 23M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2890 :=C2=
=A0=C2=A0 0=C2=A0 5801 :=C2=A0=C2=A0 0=C2=A0 5781 |4816B 2492B|0.15 0.19 0.=
11|=C2=A0 1=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 2=C2=A0=C2=A0 0|9976=C2=A0=
=C2=A0=C2=A0 34k|26-05 06:27:18|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 23M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2935 :=C2=
=A0=C2=A0 0=C2=A0 5888 :=C2=A0=C2=A0 0=C2=A0 5870 |4450B 2552B|0.22 0.21 0.=
12|=C2=A0 0=C2=A0=C2=A0 2=C2=A0 96=C2=A0=C2=A0 2=C2=A0=C2=A0 0|9937=C2=A0=
=C2=A0=C2=A0 33k|26-05 06:27:19|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0 22M:=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0 11M|=C2=A0=C2=A0 0=C2=A0 2777 :=C2=
=A0=C2=A0 0=C2=A0 5575 :=C2=A0=C2=A0 0=C2=A0 5553 |8644B 1614B|0.22 0.21 0.=
12|=C2=A0 0=C2=A0=C2=A0 2=C2=A0 98=C2=A0=C2=A0 0=C2=A0=C2=A0 0|9416=C2=A0=
=C2=A0=C2=A0 31k|26-05 06:27:20|=C2=A0=C2=A0 1B
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 2096k:=C2=
=A0=C2=A0 0=C2=A0 1040k|=C2=A0=C2=A0 0=C2=A0=C2=A0 260 :=C2=A0=C2=A0 0=C2=
=A0=C2=A0 523 :=C2=A0=C2=A0 0=C2=A0=C2=A0 519 |=C2=A0 10k 8760B|0.22 0.21 0=
.12|=C2=A0 0=C2=A0=C2=A0 1=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0|1246=C2=A0 =
3157 |26-05 06:27:21|=C2=A0=C2=A0 0
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |4083B 2990B|0.22 0.21 0.12|=C2=A0 0=C2=A0=
=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 390=C2=A0=C2=A0 369 |26-05 06:27:=
22|=C2=A0=C2=A0 0

> In this case, with exactly the same command, we got a very different=20
> result. While writes to the backing device (sdd) do not happen (this is=
=20
> correct), we noticed that IOs occur on both the NVMe device and the=20
> backing device (i think this is wrong), but at a much lower rate now,=20
> around 5.6K on NVMe and 2.8K on the backing device. It leaves the=20
> impression that although it is not writing anything to sdd device, it is=
=20
> sending some signal to the backing device in each two IO operations that=
=20
> is performed with the cache device. And that would be delaying the=20
> answer. Could it be something like this?

I think in newer kernels that bcache is more aggressive at writeback.=20
Using /dev/mapper/zero as above will help rule out backing device=20
interference.=C2=A0 Also make sure you have the sysfs flags turned to encou=
rge=20
it to write to SSD and not bypass:

=C2=A0=C2=A0=C2=A0 echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
=C2=A0=C2=A0=C2=A0 echo 10000000 > /sys/block/bcache0/bcache/cache/congeste=
d_read_threshold_us=20
=C2=A0=C2=A0=C2=A0 echo 10000000 > /sys/block/bcache0/bcache/cache/congeste=
d_write_threshold_us

> It is important to point out that the writeback mode is on, obviously,=20
> and that the sequential cutoff is at zero, but I tried to put default=20
> values or high values and there were no changes. I also tried changing=20
> congested_write_threshold_us and congested_read_threshold_us, also with=
=20
> no result changes.

Try this too:=20
=C2=A0=C2=A0=C2=A0 echo 300 > /sys/block/bcache0/bcache/writeback_delay

and make sure bcache is in writeback (echo writeback >=20
/sys/block/bcache0/bcache0/cache_mode) in case that was not configured on=
=20
server2.


-Eric

> The only thing I noticed different between the configurations of the two=
=20
> computers was btree_cache_size, which on the first is much larger (7.7M)=
=20
> m while on the second it is only 768K. But I don't know if this=20
> parameter is configurable and if it could justify the difference.
>=20
> Disabling Intel's Turbo Boost technology through the BIOS appears to=20
> have no effect.
>=20
> And we will continue our tests comparing the two computers, including to=
=20
> test the two versions of the Kernel. If anyone else has ideas, thanks!


>=20
> Em ter=C3=A7a-feira, 17 de maio de 2022 22:23:09 BRT, Eric Wheeler <bcach=
e@lists.ewheeler.net> escreveu:=20
>=20
>=20
>=20
>=20
>=20
> On Tue, 10 May 2022, Adriano Silva wrote:
> > I'm trying to set up a flash disk NVMe as a disk cache for two or three=
=20
> > isolated (I will use 2TB disks, but in these tests I used a 1TB one)=20
> > spinning disks that I have on a Linux 5.4.174 (Proxmox node).
>=20
> Coly has been adding quite a few optimizations over the years.=C2=A0 You =
might=20
> try a new kernel and see if that helps.=C2=A0 More below.
>=20
> > I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as=
=20
> > a cache.
> > [...]
> >
> > But when I do the same test on bcache writeback, the performance drops =
a=20
> > lot. Of course, it's better than the performance of spinning disks, but=
=20
> > much worse than when accessed directly from the NVMe device hardware.
> >
> > [...]
> > As we can see, the same test done on the bcache0 device only got 1548=
=20
> > IOPS and that yielded only 6.3 KB/s.
>=20
> Well done on the benchmarking!=C2=A0 I always thought our new NVMes perfo=
rmed=20
> slower than expected but hadn't gotten around to investigating.=20
>=20
> > I've noticed in several tests, varying the amount of jobs or increasing=
=20
> > the size of the blocks, that the larger the size of the blocks, the mor=
e=20
> > I approximate the performance of the physical device to the bcache=20
> > device.
>=20
> You said "blocks" but did you mean bucket size (make-bcache -b) or block=
=20
> size (make-bcache -w) ?
>=20
> If larger buckets makes it slower than that actually surprises me: bigger=
=20
> buckets means less metadata and better sequential writeback to the=20
> spinning disks (though you hadn't yet hit writeback to spinning disks in=
=20
> your stats).=C2=A0 Maybe you already tried, but varying the bucket size m=
ight=20
> help.=C2=A0 Try graphing bucket size (powers of 2) against IOPS, maybe th=
ere is=20
> a "sweet spot"?
>=20
> Be aware that 4k blocks (so-called "4Kn") is unsafe for the cache device,=
=20
> unless Coly has patched that.=C2=A0 Make sure your `blockdev --getss` rep=
orts=20
> 512 for your NVMe!
>=20
> Hi Coly,
>=20
> Some time ago you ordered an an SSD to test the 4k cache issue, has that=
=20
> been fixed?=C2=A0 I've kept an eye out for the patch but not sure if it w=
as released.
>=20
> You have a really great test rig setup with NVMes for stress
> testing bcache. Can you replicate Adriano's `ioping` numbers below?
>=20
> > With ioping it is also possible to notice a limitation, as the latency=
=20
> > of the bcache0 device is around 1.5ms, while in the case of the raw=20
> > device (a partition of NVMe), the same test is only 82.1us.
> >=20
> > root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D1 time=3D1.5=
2 ms (warmup)
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D2 time=3D1.6=
0 ms
> > 4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D3 time=3D1.5=
5 ms
> >
> > root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D1 time=3D81.=
2 us (warmup)
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D2 time=3D82.=
7 us
> > 4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D3 time=3D82.=
4 us
>=20
> Wow, almost 20x higher latency, sounds convincing that something is wrong=
.
>=20
> A few things to try:
>=20
> 1. Try ioping without -Y.=C2=A0 How does it compare?
>=20
> 2. Maybe this is an inter-socket latency issue.=C2=A0 Is your server=20
> =C2=A0 multi-socket?=C2=A0 If so, then as a first pass you could set the =
kernel=20
> =C2=A0 cmdline `isolcpus` for testing to limit all processes to a single=
=20
> =C2=A0 socket where the NVMe is connected (see `lscpu`).=C2=A0 Check `hwl=
oc-ls`
> =C2=A0 or your motherboard manual to see how the NVMe port is wired to yo=
ur
> =C2=A0 CPUs.
>=20
> =C2=A0 If that helps then fine tune with `numactl -cN ioping` and=20
> =C2=A0 /proc/irq/<n>/smp_affinity_list (and `grep nvme /proc/interrupts`)=
 to=20
> =C2=A0 make sure your NVMe's are locked to IRQs on the same socket.
>=20
> 3a. sysfs:
>=20
> > # echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
>=20
> good.
>=20
> > # echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
> > # echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us
>=20
> Also try these (I think bcache/cache is a symlink to /sys/fs/bcache/<cach=
e set>)
>=20
> echo 10000000 > /sys/block/bcache0/bcache/cache/congested_read_threshold_=
us=20
> echo 10000000 > /sys/block/bcache0/bcache/cache/congested_write_threshold=
_us
>=20
>=20
> Try tuning journal_delay_ms:=20
> =C2=A0 /sys/fs/bcache/<cset-uuid>/journal_delay_ms
> =C2=A0 =C2=A0 Journal writes will delay for up to this many milliseconds,=
 unless a=20
> =C2=A0 =C2=A0 cache flush happens sooner. Defaults to 100.
>=20
> 3b: Hacking bcache code:
>=20
> I just noticed that journal_delay_ms says "unless a cache flush happens=
=20
> sooner" but cache flushes can be re-ordered so flushing the journal when=
=20
> REQ_OP_FLUSH comes through may not be useful, especially if there is a=20
> high volume of flushes coming down the pipe because the flushes could kil=
l=20
> the NVMe's cache---and maybe the 1.5ms ping is actual flash latency.=C2=
=A0 It
> would flush data and journal.
>=20
> Maybe there should be a cachedev_noflush sysfs option for those with some=
=20
> kind of power-loss protection of there SSD's.=C2=A0 It looks like this is=
=20
> handled in request.c when these functions call bch_journal_meta():
>=20
> =C2=A0=C2=A0=C2=A0 1053: static void cached_dev_nodata(struct closure *cl=
)
> =C2=A0=C2=A0=C2=A0 1263: static void flash_dev_nodata(struct closure *cl)
>=20
> Coly can you comment about journal flush semantics with respect to=20
> performance vs correctness and crash safety?
>=20
> Adriano, as a test, you could change this line in search_alloc() in=20
> request.c:
>=20
> =C2=A0=C2=A0=C2=A0 - s->iop.flush_journal=C2=A0 =C2=A0 =3D op_is_flush(bi=
o->bi_opf);
> =C2=A0=C2=A0=C2=A0 + s->iop.flush_journal=C2=A0 =C2=A0 =3D 0;
>=20
> and see how performance changes.
>=20
> Someone correct me if I'm wrong, but I don't think flush_journal=3D0 will=
=20
> affect correctness unless there is a crash.=C2=A0 If that /is/ the perfor=
mance=20
> problem then it would narrow the scope of this discussion.
>=20
> 4. I wonder if your 1.5ms `ioping` stats scale with CPU clock speed: can=
=20
> =C2=A0 you set your CPU governor to run at full clock speed and then slow=
est=20
> =C2=A0 clock speed to see if it is a CPU limit somewhere as we expect?
>=20
> =C2=A0 You can do `grep MHz /proc/cpuinfo` to see the active rate to make=
 sure=20
> =C2=A0 the governor did its job.=C2=A0=20
>=20
> =C2=A0 If it scales with CPU then something in bcache is working too hard=
.=C2=A0=20
> =C2=A0 Maybe garbage collection?=C2=A0 Other devs would need to chime in =
here to=20
> =C2=A0 steer the troubleshooting if that is the case.
>=20
>=20
> 5. I'm not sure if garbage collection is the issue, but you might try=20
> =C2=A0 Mingzhe's dynamic incremental gc patch:
> =C2=A0=C2=A0=C2=A0 https://www.spinics.net/lists/linux-bcache/msg11185.ht=
ml
>=20
> 6. Try dm-cache and see if its IO latency is similar to bcache: If it is=
=20
> =C2=A0 about the same then that would indicate an issue in the block laye=
r=20
> =C2=A0 somewhere outside of bcache.=C2=A0 If dm-cache is better, then tha=
t confirms=20
> =C2=A0 a bcache issue.
>=20
>=20
> > The cache was configured directly on one of the NVMe partitions (in thi=
s=20
> > case, the first partition). I did several tests using fio and ioping,=
=20
> > testing on a partition on the NVMe device, without partition and=20
> > directly on the raw block, on a first partition, on the second, with or=
=20
> > without configuring bcache. I did all this to remove any doubt as to th=
e=20
> > method. The results of tests performed directly on the hardware device,=
=20
> > without going through bcache are always fast and similar.
> >=20
> > But tests in bcache are always slower. If you use writethrough, of=20
> > course, it gets much worse, because the performance is equal to the raw=
=20
> > spinning disk.
> >=20
> > Using writeback improves a lot, but still doesn't use the full speed of=
=20
> > NVMe (honestly, much less than full speed).
>=20
> Indeed, I hope this can be fixed!=C2=A0 A 20x improvement in bcache would=
=20
> be awesome.
>=20
> > But I've also noticed that there is a limit on writing sequential data,=
=20
> > which is a little more than half of the maximum write rate shown in=20
> > direct tests by the NVMe device.
>=20
> For sync, async, or both?
>=20
>=20
> > Processing doesn't seem to be going up like the tests.
>=20
>=20
> What do you mean "processing" ?
>=20
> -Eric
>=20
>=20
>=20
