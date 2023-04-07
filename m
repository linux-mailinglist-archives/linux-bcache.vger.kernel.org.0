Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BA46DA7F0
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Apr 2023 05:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbjDGDQS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Apr 2023 23:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjDGDQQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Apr 2023 23:16:16 -0400
Received: from sonic314-15.consmr.mail.bf2.yahoo.com (sonic314-15.consmr.mail.bf2.yahoo.com [74.6.132.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526AD8A79
        for <linux-bcache@vger.kernel.org>; Thu,  6 Apr 2023 20:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1680837372; bh=OmV7gU52TEYgyUORgbcZx1dv+L5C8BCOKvywOWue66A=; h=Date:From:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=BUDeOordKfGwj8pSEKNmOkONf/XKWuJvByiuirm28434Qcjw4LQLRST40XimhZpKNMSmseFAXb0aF7t+NNknw2GCOQhQx2ZPvk7CjOJEqtqN5xafvUkDF+SIXnHyz2ZkR0ifItnMTTvFQGe3gc81bVWdMeb+2K/wDeIiK7PrPTsOla9pZhEYFdbt48rcAvHz9U6iUrproq5IMUA8U1e2NmEdsblUY5/beDLNAJkJ/QUybHAxFONHaYSxCGMHZqAT3qaFIVw84cDoG4vnsMPOpFbpNItO0AhY3umPA70jjrHNzeDMSMWaMfg8AIZ35J1gEpNpSBT4WQ134nzTrV/xEA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1680837372; bh=R0+1/LZToZrnmwOw3kWORCivlvvu+lyUAhkCBx3VR+n=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=n4KtCZYYU345Ry6qdW8xeNaBYZ6rh+k3PcwlCYVBO93kaJmgBm8Jk9WKUHLmQG4hx843xvlYedXkjsQb1qVIHDKuwWk/pB02PrKmMoCLys/63aVAJrJgLzjAPrB5sRVdFq/mVEZ/Qa/C6US6ubqAXJ19Vo+CC4sq9/s0TyoBotI1xBj3+Q2LRb+hbRtpP5ty6GN4KV9B4ogbn81HBuTIeO8VPqvjUfx5iFKQiB3kQbF3nVe33gZ7GOq6+pnachJ5A5Yw5TTV0jsQ6HP52wu3V6w4t23tOuuz/HCwKFENu3wO1FPnET6wplWax5tPlkvAtmntuujBZhS2YdUw6b45Yw==
X-YMail-OSG: AV_oaVEVM1ncQ62nYtI7_dzOdk8I_PQHv0jUkvgrZ94Gud9st0PK35.xvge8pZj
 kKcAndcEdJroiolK86dR.ZCpSDuSqpcc0AuefclEmUIauBHeAOmqP_dEUVRCZ_VYfIACeGpIZ9j7
 fkFeHiebCFCjCzu6oQN.Q17ecG7S1vyIS9uLrR.gfy1Xw4cHdMwUrW1w1jQZMtJIpYvTvMVnUF1m
 c8fQpT7KxOo.trKT9nnt5t6dIOCCgzwaj9v8MHVHeRcd5GpaA1TzIOMF_iF53JdbTT6HJsJcHs.c
 dkambu5PV7vodm4TtoaKu3cT_KAU_Eh4G9WyLr2vI3AXsZyhGMzH0tjtArfNSnh4kaelthQd.sTd
 K.Jz6HZ1IURN8aV6hTyzu26wYP5aLF1OLqeL3hXDWtApXRViIAyxW5_gOgEdbduFWKQepAE8OJ60
 UWJ9yn99PWv.GNnCObkj.3AoZICZq6fY8ErYuimwG2ljhcTikqqoDnwmGFqh_AQlo8O4nei4iDXe
 WIVfeXVY4o0ZG4fd9q2KKDlrtPOS_LEhP1P_BKtLeEF.i3hmXDyNNHQDmZq6uwL_QooiC88oU3LM
 VvQSY3jhsKgETwZqw14ijV4QROB_7N.aRFso3VrE5XtEUxSXctjrOtVtjwykJubkJRdUpIyjzvMz
 3strPZMXxIJkcGiHmqbHnAitc6pa4RSU_yx1TlVuDoaURhi8V1cJyX_1jWeJbaeh4Mf6loD6.abh
 yQII1zuBKP98WE4r4ZsTIWzDmB0NtLCgm68cR90mRXhzf83hVYMV3f3IbjhSwIc1LbyNoKlqisIk
 oUmCUlSO95tFC4bFfixKOzSbYYmX10uQYbnY9B0Do2pNzaHmoLVAC2gb0gtIywVOa36rE1wRJyzG
 ssorz42Rb6k_0eFBgm8ALulojG12zNtLKPiGWb6YrNqgTaIIGrDcFzKzlzbj4EVWSZ9iM_FqWQfi
 QftjbW4lmwy7Ds2N9jB60ASVQWa_TAFLn_VjA5aqSrlEsphQDIJvC5L6IAsL.lue2yY.3n5QxgnD
 0BcY697_5_yuqY.XvZUc4P56dWURiWtHqZKyh36dgxf8S4BxA1OGyjo1xomI7HoUMgw5efY4mYM.
 wsONsEO7HAgMUhkYeYSA8co5V61lqA3gAA7woWhC9twpv8VcR4jznmMSV0lXp6TL1icSLUPJFyma
 cULaZzMeTZ7g6trFZFV7D7dO12cX.4z9OIcPCQei3uH8hmoLK5qDOeM5CSagXnZrrlUNWAzB2wZX
 BnSya7MVZ4ZuC2or50RjDAkNpXNuBNhOJAGZj_YLf9aQNjXw4J.Cyvck4WdEb6jvMKD193LAO1JA
 uAp15CZ8fQ_mdG0gZD.HE_fgV9c4Y8FsDbgpif57vJiEbdUKEGGXOd_rvqDH1ozZkS9zl6Damg21
 l45G87S7n2Z1gaSktPwBXj7Hx_wylRcXiYRzjVsT3VSPEj_cKDX6jq0D67zl.ZfgOggtjjAfXj2r
 KtIvAtltNmOAjQL3_HyTcbbMR1ijSBgFfoSDHQBAWL9_EyY99KnWHxnupWMtQXTw8qdGn0EueCt1
 o.mHDLWZYrcOwa7Z9rBRnNH_PDf6cL4lbgDZxUWG9p56Y_vs8PRFnk8tPX.BrHIrv.GPTmjtctxq
 DIlENL6edsaq3dz3IKXhLfhLwVDrvzeHse_mj2bS5V2rOrMbDAy3KTyQJPAk9B0YlpQFJMZ.l8y4
 UEc.pz6YKGn7F4iOTGgUbMAebndqv3wJFkREY4hi7Q5oUIbW9zAEZK.JlCCz5oo8.FUX9gVOhouN
 aJpNMYz4IU52USL_OEfk1.hZf3c4Pftvq5RGJWgVaeGFOPiZdgckYSXlo_4dwai0Jr6VgM7ja5Nq
 QSNfvtB0nIcJMdrhfkJYN5iFLYl2EZEJTU__bpCSk0EBuqMXBfLPZ0E7vl7fpA_jo5cqgKQNr_GU
 SjDv0iELc9h9DTGlBW7wpaeplk8rbRLvaYMBvDHbsxUubD0QLACchyGNgjmE9Uij0mjfaz1xmFVg
 sakm9WFOpVxoCcWNwTOj_qq5fOqU.m3YeuxR3aMkau9rsSHElXhlm1Nl8xKruWAdGjlxAW00HtyZ
 hdX8kN8J_OVphHpDylF7LVdfz1Ln7jUWuPkZzVWIII52VDEWZccIsaz67QiJgtgkjnIFudShHBR9
 Bb_VsK6N1omo6mL1jrI8VkPHk.OuWXjOyR87lKCxKuUC2oQBLzrFhwUPJ9qes3KdpjxDWxqz0ZvQ
 1mTTKgU7u67yJVy7dTpc0_BT6aVSmpCo1dfAWOcGreiYrwt2UuU1iMDY-
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
X-Sonic-ID: 5a6cf8d8-6d1d-4224-9aa1-b786da1bc6f8
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Fri, 7 Apr 2023 03:16:12 +0000
Date:   Fri, 7 Apr 2023 03:15:17 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     Coly Li <colyli@suse.de>,
        Bcache Linux <linux-bcache@vger.kernel.org>,
        Martin McClure <martin.mcclure@gemtalksystems.com>
Message-ID: <1507475147.102769.1680837317867@mail.yahoo.com>
In-Reply-To: <ceb1db27-11ef-36d1-3fa1-9df09c822c16@ewheeler.net>
References: <1012241948.1268315.1680082721600.ref@mail.yahoo.com> <1012241948.1268315.1680082721600@mail.yahoo.com> <e0e6c881-f1e4-f02c-ce76-1dbc6170ff1f@gemtalksystems.com> <1121771993.1793905.1680221827127@mail.yahoo.com> <eca36733-cdbd-6e16-2436-906ab2a38da9@ewheeler.net> <E69AB364-712A-41A3-91EB-46F85A8F3E69@suse.de> <fd12e250-92a8-74f-e24-f7cc62a5b4a4@ewheeler.net> <D4D242AA-D5C3-46B6-AE83-4BE52D2E504B@suse.de> <1783117292.2943582.1680640140702@mail.yahoo.com> <A48EBD27-D83B-4552-8EEC-838162B76BC4@suse.de> <2054791833.3229438.1680723106142@mail.yahoo.com> <ceb1db27-11ef-36d1-3fa1-9df09c822c16@ewheeler.net>
Subject: Re: Writeback cache all used.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.21365 YMailNorrin
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello Eric,

> The `gc_after_writeback=3D1` setting might not trigger until writeback
> finishes, but if writeback is already finished and there is no new IO the=
n
> it may never trigger unless it is forced via `tigger_gc`

Yes, I tried both commands, but I didn't get the expected result and contin=
ued with (almost) no free cache.

After executing the two commands, some dirty data was cleaned and some free=
 space was left in the cache. But almost insignificant.

However, it stopped there. It has not increased any more available space. I=
 tried again both commands and there were no changes again.

See that on all computers, I have from 185 to a maximum of 203 GB of total =
disk occupied in a 5.6TB bcache device.

root@pve-00-005:~# ceph osd df
ID=C2=A0 CLASS=C2=A0 WEIGHT=C2=A0=C2=A0 REWEIGHT=C2=A0 SIZE=C2=A0=C2=A0=C2=
=A0=C2=A0 RAW USE=C2=A0 DATA=C2=A0=C2=A0=C2=A0=C2=A0 OMAP=C2=A0=C2=A0=C2=A0=
=C2=A0 META=C2=A0=C2=A0=C2=A0=C2=A0 AVAIL=C2=A0=C2=A0=C2=A0 %USE=C2=A0 VAR=
=C2=A0=C2=A0 PGS=C2=A0 STATUS
=C2=A00=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 185 GiB=C2=A0=C2=A0 68 GiB=C2=A0=C2=A0=C2=A0 6 KiB=C2=A0 1.3 GiB=
=C2=A0 5.4 TiB=C2=A0 3.25=C2=A0 0.95=C2=A0=C2=A0 24=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 up
=C2=A01=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 197 GiB=C2=A0=C2=A0 80 GiB=C2=A0 2.8 MiB=C2=A0 1.4 GiB=C2=A0 5.4 T=
iB=C2=A0 3.46=C2=A0 1.01=C2=A0=C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up
=C2=A02=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 203 GiB=C2=A0=C2=A0 86 GiB=C2=A0 2.8 MiB=C2=A0 1.6 GiB=C2=A0 5.4 T=
iB=C2=A0 3.56=C2=A0 1.04=C2=A0=C2=A0 30=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up
=C2=A03=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 197 GiB=C2=A0=C2=A0 80 GiB=C2=A0 2.8 MiB=C2=A0 1.5 GiB=C2=A0 5.4 T=
iB=C2=A0 3.45=C2=A0 1.01=C2=A0=C2=A0 31=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 up
=C2=A04=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 194 GiB=C2=A0=C2=A0 76 GiB=C2=A0=C2=A0=C2=A0 5 KiB=C2=A0 361 MiB=
=C2=A0 5.4 TiB=C2=A0 3.39=C2=A0 0.99=C2=A0=C2=A0 26=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 up
=C2=A05=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 187 GiB=C2=A0=C2=A0 69 GiB=C2=A0=C2=A0=C2=A0 5 KiB=C2=A0 1.1 GiB=
=C2=A0 5.4 TiB=C2=A0 3.27=C2=A0 0.96=C2=A0=C2=A0 25=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 up
=C2=A06=C2=A0=C2=A0=C2=A0 hdd=C2=A0 5.57269=C2=A0=C2=A0 1.00000=C2=A0 5.6 T=
iB=C2=A0 202 GiB=C2=A0=C2=A0 84 GiB=C2=A0=C2=A0=C2=A0 5 KiB=C2=A0 1.5 GiB=
=C2=A0 5.4 TiB=C2=A0 3.54=C2=A0 1.04=C2=A0=C2=A0 28=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 up
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TOTAL=C2=A0=C2=A0=
 39 TiB=C2=A0 1.3 TiB=C2=A0 543 GiB=C2=A0 8.4 MiB=C2=A0 8.8 GiB=C2=A0=C2=A0=
 38 TiB=C2=A0 3.42=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =C2=A0
MIN/MAX VAR: 0.95/1.04=C2=A0 STDDEV: 0.11
root@pve-00-005:~#

But when I look inside the bcache devices, the caches are all pretty much f=
ull, with a maximum of 5% free (at best). This after many hours stopped and=
 after the aforementioned commands.

root@pve-00-001:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1145
Sectors per Q:=C2=A0 36244576
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [8 24 39 56 84 112 155 256 392 476=
 605 714 825 902 988 1070 1184 1273 1369 1475 1568 1686 1775 1890 1994 2088=
 2212 2323 2441 2553 2693]
root@pve-00-001:~#

root@pve-00-002:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1143
Sectors per Q:=C2=A0 36245072
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [10 25 42 78 107 147 201 221 304 4=
44 529 654 757 863 962 1057 1146 1264 1355 1469 1568 1664 1773 1885 2001 21=
11 2241 2368 2490 2613 2779]
root@pve-00-002:~#

root@pve-00-003:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 97%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 971
Sectors per Q:=C2=A0 36244400
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [8 21 36 51 87 127 161 181 217 278=
 435 535 627 741 825 919 993 1080 1165 1239 1340 1428 1503 1611 1716 1815 1=
945 2037 2129 2248 2357]
root@pve-00-003:~#

root@pve-00-004:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 94%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1133
Sectors per Q:=C2=A0 36243024
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [10 26 41 57 92 121 152 192 289 44=
0 550 645 806 913 989 1068 1170 1243 1371 1455 1567 1656 1746 1887 1996 210=
7 2201 2318 2448 2588 2729]
root@pve-00-004:~#

root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 97%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1076
Sectors per Q:=C2=A0 36245312
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [10 25 42 59 93 115 139 218 276 36=
8 478 568 676 770 862 944 1090 1178 1284 1371 1453 1589 1700 1814 1904 1990=
 2147 2264 2386 2509 2679]
root@pve-00-005:~#

root@pve-00-006:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1085
Sectors per Q:=C2=A0 36244688
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [10 27 45 68 101 137 175 234 365 4=
48 547 651 757 834 921 1001 1098 1185 1283 1379 1470 1575 1673 1781 1892 19=
94 2102 2216 2336 2461 2606]
root@pve-00-006:~#

root@pve-00-007:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_stat=
s
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 95%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1061
Sectors per Q:=C2=A0 36244160
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [10 24 40 56 94 132 177 233 275 32=
6 495 602 704 846 928 1014 1091 1180 1276 1355 1471 1572 1665 1759 1862 195=
2 2087 2179 2292 2417 2537]
root@pve-00-007:~#

As you can see, out of 7 servers, they all range from 2 to a maximum of 5% =
unused space. Though none have even 4% of the mass disk space occupied.

Little has changed after many hours with the system on but no new writes or=
 reads to the bcache device. Only this time I turned on the virtual machine=
, but it stayed on for a short time. Even so, as you can see, almost nothin=
g has changed and there are still disks with no cache space available. I ca=
n bet that, in this situation, with a few minutes of use, the disks will al=
l be 100% full again.

It's even a funny situation, because the usable space used (with real data)=
 in the bcache device doesn't reach half of what is actually occupied in th=
e cache. It's as if it keeps in the cache, even data that has already been =
deleted from the device.

Is there a solution?

Grateful,

Em quinta-feira, 6 de abril de 2023 =C3=A0s 18:21:20 BRT, Eric Wheeler <bca=
che@lists.ewheeler.net> escreveu:=20



On Wed, 5 Apr 2023, Adriano Silva wrote:
> > Can you try to write 1 to cache set sysfs file=20
> > gc_after_writeback?=20
> > When it is set, a gc will be waken up automatically after=20
> > all writeback accomplished. Then most of the clean cache=20
> > might be shunk and the B+tree nodes will be deduced=20
> > quite a lot.
>=20
> Would this be the command you ask me for?
>=20
> root@pve-00-005:~# echo 1 > /sys/fs/bcache/a18394d8-186e-44f9-979a-8c07cb=
3fbbcd/internal/gc_after_writeback
>=20
> If this command is correct, I already advance that it did not give the=20
> expected result. The Cache continues with 100% of the occupied space.=20
> Nothing has changed despite the cache being cleaned and having written=20
> the command you recommended. Let's see:

Did you try to trigger gc after setting gc_after_writeback=3D1?

=C2=A0 =C2=A0 =C2=A0 =C2=A0 echo 1 > /sys/block/bcache0/bcache/cache/intern=
al/trigger_gc

The `gc_after_writeback=3D1` setting might not trigger until writeback=20
finishes, but if writeback is already finished and there is no new IO then=
=20
it may never trigger unless it is forced via `tigger_gc`

-Eric


> root@pve-00-005:~# cat /sys/block/bcache0/bcache/cache/cache0/priority_st=
ats
> Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
> Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 98%
> Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
> Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
> Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1137
> Sectors per Q:=C2=A0 36245232
> Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [12 26 42 60 80 127 164 237 322 =
426 552 651 765 859 948 1030 1176 1264 1370 1457 1539 1674 1786 1899 1989 2=
076 2232 2350 2471 2594 2764]
>=20
> But if there was any movement on the disks after the command, I couldn't =
detect it:
>=20
> root@pve-00-005:~# dstat -drt -D sdc,nvme0n1,bcache0
> --dsk/sdc---dsk/nvme0n1-dsk/bcache0 ---io/sdc----io/nvme0n1--io/bcache0 -=
---system----
> =C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ:=
 read=C2=A0 writ: read=C2=A0 writ|=C2=A0=C2=A0=C2=A0=C2=A0 time=C2=A0=C2=A0=
=C2=A0 =C2=A0
> =C2=A0 54k=C2=A0 153k: 300k=C2=A0 221k: 222k=C2=A0 169k|0.67=C2=A0 0.53 :=
6.97=C2=A0 20.4 :6.76=C2=A0 12.3 |05-04 15:28:57
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:28:58
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:28:59
\> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0=20
|05-04 15:29:00
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:01
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:02
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:03
> =C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=
=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=
=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |05-04 15:29:04^C
> root@pve-00-005:~#
>=20
> Why were there no changes?
>=20
> > Currently there is no such option for limit bcache=20
> > in-memory B+tree nodes cache occupation, but when I/O=20
> > load reduces, such memory consumption may drop very=20
> > fast by the reaper from system memory management=20
> > code. So it won=E2=80=99t be a problem. Bcache will try to use any=20
> > possible memory for B+tree nodes cache if it is=20
> > necessary, and throttle I/O performance to return these=20
> > memory back to memory management code when the=20
> > available system memory is low. By default, it should=20
> > work well and nothing should be done from user.
>=20
> I've been following the server's operation a lot and I've never seen less=
 than 50 GB of free RAM memory. Let's see:=20
>=20
> root@pve-00-005:~# free=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 used=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 free=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 shared=C2=A0 buff/cache=C2=A0=C2=A0 available
> Mem:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 131980688=C2=A0=C2=A0=C2=A0 7267=
0448=C2=A0=C2=A0=C2=A0 19088648=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 76780=
=C2=A0=C2=A0=C2=A0 40221592=C2=A0=C2=A0=C2=A0 57335704
> Swap:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0
> root@pve-00-005:~#
>=20
> There is always plenty of free RAM, which makes me ask: Could there reall=
y be a problem related to a lack of RAM?
>=20
> > Bcache doesn=E2=80=99t issue trim request proactively.=20
> > [...]
> > In run time, bcache code only forward the trim request to backing devic=
e (not cache device).
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
>=20
> Anyway, this issue of the free buckets not appearing is keeping me awake =
at night. Could it be a problem with my Kernel version (Linux 5.15)?
>=20
> As I mentioned before, I saw in the bcache documentation (https://docs.ke=
rnel.org/admin-guide/bcache.html) a variable (freelist_percent) that was su=
pposed to control a minimum rate of free buckets. Could it be a solution? I=
 don't know. But in practice, I didn't find this variable in my system (cou=
ld it be because of the OS version?)
>=20
> Thank you very much!
>=20
>=20
>=20
> Em quarta-feira, 5 de abril de 2023 =C3=A0s 10:57:58 BRT, Coly Li <colyli=
@suse.de> escreveu:=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> > 2023=E5=B9=B44=E6=9C=885=E6=97=A5 04:29=EF=BC=8CAdriano Silva <adriano_=
da_silva@yahoo.com.br> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > Hello,
> >=20
> >> It sounds like a large cache size with limit memory cache=20
> >> for B+tree nodes?
> >=20
> >> If the memory is limited and all B+tree nodes in the hot I/O=20
> >> paths cannot stay in memory, it is possible for such=20
> >> behavior happens. In this case, shrink the cached data=20
> >> may deduce the meta data and consequential in-memory=20
> >> B+tree nodes as well. Yes it may be helpful for such=20
> >> scenario.
> >=20
> > There are several servers (TEN) all with 128 GB of RAM, of which around=
 100GB (on average) are presented by the OS as free. Cache is 594GB in size=
 on enterprise NVMe, mass storage is 6TB. The configuration on all is the s=
ame. They run Ceph OSD to service a pool of disks accessed by servers (othe=
rs including themselves).
> >=20
> > All show the same behavior.
> >=20
> > When they were installed, they did not occupy the entire cache. Through=
out use, the cache gradually filled up and=C2=A0 never decreased in size. I=
 have another five servers in=C2=A0 another cluster going the same way. Dur=
ing the night=C2=A0 their workload is reduced.
>=20
> Copied.
>=20
> >=20
> >> But what is the I/O pattern here? If all the cache space=20
> >> occupied by clean data for read request, and write=20
> >> performance is cared about then. Is this a write tended,=20
> >> or read tended workload, or mixed?
> >=20
> > The workload is greater in writing. Both are important, read and write.=
 But write latency is critical. These are virtual machine disks that are st=
ored on Ceph. Inside we have mixed loads, Windows with terminal service, Li=
nux, including a database where direct write latency is critical.
>=20
>=20
> Copied.
>=20
> >=20
> >> As I explained, the re-reclaim has been here already.=20
> >> But it cannot help too much if busy I/O requests always=20
> >> coming and writeback and gc threads have no spare=20
> >> time to perform.
> >=20
> >> If coming I/Os exceeds the service capacity of the=20
> >> cache service window, disappointed requesters can=20
> >> be expected.
> >=20
> > Today, the ten servers have been without I/O operation for at least 24 =
hours. Nothing has changed, they continue with 100% cache occupancy. I beli=
eve I should have given time for the GC, no?
>=20
> This is nice. Now we have the maximum writeback thoughput after I/O idle =
for a while, so after 24 hours all dirty data should be written back and th=
e whole cache might be clean.
>=20
> I guess just a gc is needed here.
>=20
> Can you try to write 1 to cache set sysfs file gc_after_writeback? When i=
t is set, a gc will be waken up automatically after all writeback accomplis=
hed. Then most of the clean cache might be shunk and the B+tree nodes will =
be deduced quite a lot.
>=20
>=20
> >=20
> >> Let=E2=80=99s check whether it is just becasue of insuffecient=20
> >> memory to hold the hot B+tree node in memory.
> >=20
> > Does the bcache configuration have any RAM memory reservation options? =
Or would the 100GB of RAM be insufficient for the 594GB of NVMe Cache? For =
that amount of Cache, how much RAM should I have reserved for bcache? Is th=
ere any command or parameter I should use to signal bcache that it should r=
eserve this RAM memory? I didn't do anything about this matter. How would I=
 do it?
> >=20
>=20
> Currently there is no such option for limit bcache in-memory B+tree nodes=
 cache occupation, but when I/O load reduces, such memory consumption may d=
rop very fast by the reaper from system memory management code. So it won=
=E2=80=99t be a problem. Bcache will try to use any possible memory for B+t=
ree nodes cache if it is necessary, and throttle I/O performance to return =
these memory back to memory management code when the available system memor=
y is low. By default, it should work well and nothing should be done from u=
ser.=20
>=20
> > Another question: How do I know if I should trigger a TRIM (discard) fo=
r my NVMe with bcache?
>=20
> Bcache doesn=E2=80=99t issue trim request proactively. The bcache program=
 from bcache-tools may issue a discard request when you run,
> =C2=A0=C2=A0=C2=A0 bcache make -C <cache device path>
> to create a cache device.
>=20
> In run time, bcache code only forward the trim request to backing device =
(not cache device).
>=20
>=20
>=20
> Thanks.
>=20
> Coly Li
>=20
>=20
>=20
> >=20
> [snipped]
>=20
>=20
>=20
