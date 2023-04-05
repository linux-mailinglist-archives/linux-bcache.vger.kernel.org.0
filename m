Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55566D86E6
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Apr 2023 21:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjDETbv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Apr 2023 15:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjDETbu (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Apr 2023 15:31:50 -0400
Received: from sonic321-26.consmr.mail.bf2.yahoo.com (sonic321-26.consmr.mail.bf2.yahoo.com [74.6.133.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DF15251
        for <linux-bcache@vger.kernel.org>; Wed,  5 Apr 2023 12:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680723108; bh=AWoV4G0L8Yr4Zr2CRPnOIU5XUoVC6Swya+ndfXQQQMA=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=RN9Wv/fRifPiOqwGCxV4mZ9sCra8V/+MXOHQw8f2VpUpmUBhWB9eolv4uFPrqNAo2Q+M7Ql4Zox0bPHfAujJJqBzhjCwFDU7/3hwQzVFO7z3+y9iQcfbGDPrLaChFrQh4zikkRjLeYxRBh9BjxKuiC8t0qqW5mygAoSBzOPSGwZQiLFmCAhM/kOLLo3xIKFlS0Lyt01VztOoVVAT17mpq9/a18IxDjo1UAYfH7esIrCN/p+bMhFM4TPGeYw3PTKKaQhXxOZugPFApt6levK+Yz1C3udgP7Xu9xNEYS6mKJZD8doZOErsmwYMOzUOZNSSASXy/FLdyb/0oqC37KRzeg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680723108; bh=nYjYjEsKG8dSQRcFMj5ukKgNb6lbOd9LJNNaGoI8khO=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=PRyMlH+l/W8gpJBmVxyGSZcEO9nJ0/d1Dx4I6krVC4Q7A0lMGKbPum4Y6Gl0+uqXc1O7loCJT4BlMOupx23H1Ac9DZlKtrGxzDmLxA4tgkql0MZcwbU/BdiMxe//2CJDYwh7It1RCL98bRhDpGYET54hVE/8YF3ErDpa8RUWDp0xXUKhT4aNiq9Lpbnr+EP78jAlimYv3h8LvnnPrGK2nL4/ZkTnNhBQ9d84mP5aqnnXHln1o8UiYsqNmiMn2HFCTQA2uk33JtmdNRKlb0u27c0kRULesbBgPV1Fb7Ciwg0NooQ/gIzcWcu/14zQA+Ye+FkIXrGRvE+viC/5zUwEkQ==
X-YMail-OSG: PaKW5UoVM1l9GqC03RqB.b_F8QD4WgH.c25Xs.RIHe1ZNW8_jhIHdcQzihiwFEu
 rMAkjvFYgc6cti7_1dupAZD4FSfp1ccI3IsidLe0Vp_u0EeEP5RLR6.1ggCBlI_PGVnNd9k01jd3
 W9ox2fctSi95jYETAtQWRzHewwcdJyds5ZrO6tqjL3xJcnFOgdapfidmUJM6ANiU.PxXQMRjoMZ3
 m7aKaYl6Zc0wDrn3rFlH5d3jzUYG3JZBI3pntu.FEEzUmFerhXeFBK4ctyf9.im4Nu6QAwqSf9o2
 r0VW_D3qWTM70GG8efBR4HhYUXvPQckpc6vE66g922K_JaGFSpYvoogfcApbivs2g4QM8hoYaktp
 4cpz3f0sdQx0KoOaX_OyqBevzl4NkeZsmpmEkvjAV5DNTUoiT0z8RA8MTFo0DHvKm2ZEtAGVAikm
 ZTbvt.BHSCCH4ldylZKSR2y65OYp1cZM_H7ShbjAI8FIi1jZEN4g6T3TdydnvMt3..zurUEY6rco
 AaDqYOv1T2A7lnGbX_5Z7aOAAT6sGYiG42_t8XB1_27yyS6XDxykXzmpEZ_T_rY_8ckUicwmhPXR
 2DGSAmlqTiBghr6wVqlTbT0WCe0VKpaDtmMTaPC0MbgGvq._TJIY.OyjOjtZhOC11E2RwfxIj94y
 Mpx7gTTlUk.6098sG1Xu7iHwMGrg5gCmb_FN2JzEwMGTHh_itBDxh9XwrONIzsXAJH4gMN.PBopP
 dwRuJw2JRcxShaZz77Xqe74f7V83tKQJNd_PfP9Wn4vDZ0nkEJYwvY_ht01dKXb4pod6hrljsPc6
 siFXZvsl219LyeR18wL7x0kgdQ6c3iutB2jAVpGJ2zfV1.cFig9tfZ4Do03KCZaHYB_GXQEvGOIR
 BBcKf2ryviL285Rr7udJ4bjpkCMGIGrHDRs0mMPri_dheurGvwyL0ua.pU2uM618y0j29tnrJn7U
 ONV_qk4JKAU3NJpHC2LFu2q_azgJ4k1B79.VUI2dDo2T7fxi1HGuLeuIIeKgX5ytC2N1R6M3rnmk
 Q3AOb47oUx4ol6mo3s_.0urs74qk2XWxYvuQvW1S11hZXQzIdisIYpdETj4zxUNJulD__FHJUhUQ
 FmLjlGGlObUCHCDNHvSl_E1MXaGVoXbsrDFLd_iVOA8AUrAx7O8jbOMOq1IYsIlNTz1OxpZtslDn
 VPD33_jAvTIZQaGDDqju9rgonZwPjj3Dt5LfSnJkiDV_oV6rmumdf1AKstCIUt6P7YYA.9q_aF.V
 0tpzqPcHmgR8B07NVWRXw17Y_.T_OGohPWoL5k0VUv8Smoq2DtmZcrYF73x20YeeVRxSneFi03M_
 KpWerVPZ2G1uDlc_jid0g2Ep1.KB6r_9S_OKndlf4QWTtbYYJQwCvGvgA3.CnM5b9cbEU1rQtja2
 DVuxC7VxMM.itSMlqRlf4zil1pf_ZjNLdKjZuXqPMsrfHNTpGiGqEyFtm.Q7T9MS4vW63t7_O83d
 INJD18rBxgs5KEFrFIQr0bel2fQ46VKmqE97tkjz0QDrYNIKH6tbVE2Lh0c2y42rl4cM5hJ5f329
 RZKkHNYs3KA9cxR9NPqtlEgOuTOJuiRumvRSPA.ucsQBdp55xd65cyjv1N74xl6n98fNDp.8zHjo
 kDwsNIsqMQFRY1ObIXiYfQZCzAxZ88NNtrLYUzUTspt0k_IXbt0y9JpInvw7uWdtqPHPYrG2Qo4u
 LHhuJ0moaa14KcFQyrz2Kuw4TITFx1VcYyCAXDRl4hyYgQvIQr_Lf.uxh2wOLdsyM9gnPHaznUEz
 KxactwMdY9GAdUe.kSF6FknuHmbOC9lV_t8N5hHjPhghYVhY5xYXwKtJ1lLPj6pOwTXr0tKQZuXx
 xwftgAGkadkFu_Wh.UySvzqTaM11hp7ipyge1x5mgePRMaYIR1R1LGUZEBJ99W8Ar41Ppi8ykeTh
 Jg9PFooKPAfxYJDgqGvMuRAGfuQvfxqNsqV1unRhbcOqGL5PE8pVslkSse77NNvjNCvHOFkmZcNW
 8hf0LHK4a0_sUkRq9vkmxtzF4.mhFFBeWfL2YGJrZvzFuPQGxw2RS.CmvS9Npg3L6grHEPFr1vX6
 DyDqwQfaJMTxu7cIImaNQFkVcgG7mJrwLy_sh920tp9RBAxptxbqK7nzBP8ILPUX.b.Lvcs9gh6X
 SFi0BYJ4_eNd2HebnUFB04PcDFc1D7cTiPgTnx0rlIgyvM00qWpVjLhL5bP.qtRazdWpVABJfGcP
 VsRug0sB4vzQH1q7yqfM-
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 7b706e4d-5b72-4b21-b70f-9351a619c595
Received: from sonic.gate.mail.ne1.yahoo.com by sonic321.consmr.mail.bf2.yahoo.com with HTTP; Wed, 5 Apr 2023 19:31:48 +0000
Date:   Wed, 5 Apr 2023 19:31:46 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <2054791833.3229438.1680723106142@mail.yahoo.com>
In-Reply-To: <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
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

Hello Coly.

Yes, the server is always on. I allowed it to stay on for more than 24 hour=
s with zero disk I/O to the bcache device. The result is that there are no =
movements on the cache or data disks, nor on the bcache device as we can se=
e:

root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
--dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 ---=
-system----
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ|=C2=A0=C2=A0=C2=A0=C2=A0 time=C2=A0=C2=A0=
=C2=A0 =C2=A0
=C2=A0 54k=C2=A0 154k: 301k=C2=A0 221k: 223k=C2=A0 169k|0.67=C2=A0 0.54 :6.=
99=C2=A0 20.5 :6.77=C2=A0 12.3 |05-04 14:45:50
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:51
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:52
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:53
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:54
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:55
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:56
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:57
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:58
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:45:59
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:00
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:01
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:02
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:03
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:04
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:05
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:06
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 14:46:07

It can stay like that for hours without showing any, zero data flow, either=
 read or write on any of the devices.

root@pve-00-005:~# cat /sys/block/bcache0/bcache/state
clean
root@pve-00-005:~#

But look how strange, in another command (priority_stats), it shows that th=
ere is still 1% of dirt in the cache. And 0% unused cache space. Even after=
 hours of server on and completely idle:

root@pve-00-005:~# cat /sys/devices/pci0000:80/0000:80:01.1/0000:82:00.0/nv=
me/nvme0/nvme0n1/nvme0n1p1/bcache/priority_stats
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 98%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1137
Sectors per Q:=C2=A0 36245232
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [12 26 42 60 80 127 164 237 322 42=
6 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 207=
6 2232 2350 2471 2594 2764]

Why is this happening?

> Can you try to write 1 to cache set sysfs file=20
> gc_after_writeback?=20
> When it is set, a gc will be waken up automatically after=20
> all writeback accomplished. Then most of the clean cache=20
> might be shunk and the B+tree nodes will be deduced=20
> quite a lot.

Would this be the command you ask me for?

root@pve-00-005:~# echo 1 > /sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb3f=
bbcd/internal/gc_after_writeback

If this command is correct, I already advance that it did not give the expe=
cted result. The Cache continues with 100% of the occupied space. Nothing h=
as changed despite the cache being cleaned and having written the command y=
ou recommended. Let's see:

root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 98%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1137
Sectors per Q:=C2=A0 36245232
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [12 26 42 60 80 127 164 237 322 42=
6 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 207=
6 2232 2350 2471 2594 2764]

But if there was any movement on the disks after the command, I couldn't de=
tect it:

root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
--dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 ---=
-system----
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ|=C2=A0=C2=A0=C2=A0=C2=A0 time=C2=A0=C2=A0=
=C2=A0 =C2=A0
=C2=A0 54k=C2=A0 153k: 300k=C2=A0 221k: 222k=C2=A0 169k|0.67=C2=A0 0.53 :6.=
97=C2=A0 20.4 :6.76=C2=A0 12.3 |05-04 15:28:57
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:28:58
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:28:59
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:00
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:01
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:02
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:03
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:04^C
root@pve-00-005:~#

Why were there no changes?

> Currently there is no such option for limit bcache=20
> in-memory B+tree nodes cache occupation, but when I/O=20
> load reduces, such memory consumption may drop very=20
> fast by the reaper from system memory management=20
> code. So it won=E2=80=99t be a problem. Bcache will try to use any=20
> possible memory for B+tree nodes cache if it is=20
> necessary, and throttle I/O performance to return these=20
> memory back to memory management code when the=20
> available system memory is low. By default, it should=20
> work well and nothing should be done from user.

I've been following the server's operation a lot and I've never seen less t=
han 50 GB of free RAM memory. Let's see:=20

root@pve-00-005:~# free=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 used=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 shared=C2=A0 buff/cache=C2=A0=C2=A0 available
Mem:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 131980688=C2=A0=C2=A0=C2=A0 726704=
48=C2=A0=C2=A0=C2=A0 19088648=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 76780=C2=
=A0=C2=A0=C2=A0 40221592=C2=A0=C2=A0=C2=A0 57335704
Swap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
root@pve-00-005:~#

There is always plenty of free RAM, which makes me ask: Could there really =
be a problem related to a lack of RAM?

> Bcache doesn=E2=80=99t issue trim request proactively.=20
> [...]
> In run time, bcache code only forward the trim request to backing device =
(not cache device).

Wouldn't it be advantageous if bcache sent TRIM (discard) to the cache temp=
orarily? I believe flash drives (SSD or NVMe) that need TRIM to maintain to=
p performance are typically used as a cache for bcache. So, I think that if=
 the TRIM command was used regularly by bcache, in the background (only for=
 clean and free buckets), with a controlled frequency, or even if executed =
by a manually triggered by the user background task (always only for clean =
and free buckets), it could help to reduce the write latency of the cache. =
I believe it would help the writeback efficiency a lot. What do you think a=
bout this?

Anyway, this issue of the free buckets not appearing is keeping me awake at=
 night. Could it be a problem with my Kernel version (Linux 5.15)?

As I mentioned before, I saw in the bcache documentation (https://docs.kern=
el.org/admin-guide/bcache.html) a variable (freelist_percent) that was supp=
osed to control a minimum rate of free buckets. Could it be a solution? I d=
on't know. But in practice, I didn't find this variable in my system (could=
 it be because of the OS version?)

Thank you very much!



Em quarta-feira, 5 de abril de 2023 =C3=A0s 10:57:58 BRT, Coly Li <colyli@s=
use.de> escreveu:=20







> 2023=E5=B9=B44=E6=9C=885=E6=97=A5 04:29=EF=BC=8CAdriano Silva <adriano_da=
_silva@yahoo.com.br> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hello,
>=20
>> It sounds like a large cache size with limit memory cache=20
>> for B+tree nodes?
>=20
>> If the memory is limited and all B+tree nodes in the hot I/O=20
>> paths cannot stay in memory, it is possible for such=20
>> behavior happens. In this case, shrink the cached data=20
>> may deduce the meta data and consequential in-memory=20
>> B+tree nodes as well. Yes it may be helpful for such=20
>> scenario.
>=20
> There are several servers (TEN) all with 128 GB of RAM, of which around 1=
00GB (on average) are presented by the OS as free. Cache is 594GB in size o=
n enterprise NVMe, mass storage is 6TB. The configuration on all is the sam=
e. They run Ceph OSD to service a pool of disks accessed by servers (others=
 including themselves).
>=20
> All show the same behavior.
>=20
> When they were installed, they did not occupy the entire cache. Throughou=
t use, the cache gradually filled up and=C2=A0 never decreased in size. I h=
ave another five servers in=C2=A0 another cluster going the same way. Durin=
g the night=C2=A0 their workload is reduced.

Copied.

>=20
>> But what is the I/O pattern here? If all the cache space=20
>> occupied by clean data for read request, and write=20
>> performance is cared about then. Is this a write tended,=20
>> or read tended workload, or mixed?
>=20
> The workload is greater in writing. Both are important, read and write. B=
ut write latency is critical. These are virtual machine disks that are stor=
ed on Ceph. Inside we have mixed loads, Windows with terminal service, Linu=
x, including a database where direct write latency is critical.


Copied.

>=20
>> As I explained, the re-reclaim has been here already.=20
>> But it cannot help too much if busy I/O requests always=20
>> coming and writeback and gc threads have no spare=20
>> time to perform.
>=20
>> If coming I/Os exceeds the service capacity of the=20
>> cache service window, disappointed requesters can=20
>> be expected.
>=20
> Today, the ten servers have been without I/O operation for at least 24 ho=
urs. Nothing has changed, they continue with 100% cache occupancy. I believ=
e I should have given time for the GC, no?

This is nice. Now we have the maximum writeback thoughput after I/O idle fo=
r a while, so after 24 hours all dirty data should be written back and the =
whole cache might be clean.

I guess just a gc is needed here.

Can you try to write 1 to cache set sysfs file gc_after_writeback? When it =
is set, a gc will be waken up automatically after all writeback accomplishe=
d. Then most of the clean cache might be shunk and the B+tree nodes will be=
 deduced quite a lot.


>=20
>> Let=E2=80=99s check whether it is just becasue of insuffecient=20
>> memory to hold the hot B+tree node in memory.
>=20
> Does the bcache configuration have any RAM memory reservation options? Or=
 would the 100GB of RAM be insufficient for the 594GB of NVMe Cache? For th=
at amount of Cache, how much RAM should I have reserved for bcache? Is ther=
e any command or parameter I should use to signal bcache that it should res=
erve this RAM memory? I didn't do anything about this matter. How would I d=
o it?
>=20

Currently there is no such option for limit bcache in-memory B+tree nodes c=
ache occupation, but when I/O load reduces, such memory consumption may dro=
p very fast by the reaper from system memory management code. So it won=E2=
=80=99t be a problem. Bcache will try to use any possible memory for B+tree=
 nodes cache if it is necessary, and throttle I/O performance to return the=
se memory back to memory management code when the available system memory i=
s low. By default, it should work well and nothing should be done from user=
.=20

> Another question: How do I know if I should trigger a TRIM (discard) for =
my NVMe with bcache?

Bcache doesn=E2=80=99t issue trim request proactively. The bcache program f=
rom bcache-tools may issue a discard request when you run,
=C2=A0=C2=A0=C2=A0 bcache make -C <cache device path>
to create a cache device.

In run time, bcache code only forward the trim request to backing device (n=
ot cache device).



Thanks.

Coly Li



>=20
[snipped]


