Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49FE05221AC
	for <lists+linux-bcache@lfdr.de>; Tue, 10 May 2022 18:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347654AbiEJQxt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 May 2022 12:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbiEJQxq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 May 2022 12:53:46 -0400
Received: from sonic322-26.consmr.mail.bf2.yahoo.com (sonic322-26.consmr.mail.bf2.yahoo.com [74.6.132.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A71F2A3758
        for <linux-bcache@vger.kernel.org>; Tue, 10 May 2022 09:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com.br; s=s2048; t=1652201386; bh=c73vWzSiMHPK05LY7QFtadMDZQIIuErVJ/YoXm4EOZk=; h=Date:From:To:Subject:References:From:Subject:Reply-To; b=QCR57CvzzOqUDQ0oaYpf+dnQ0faaW8OH86uOOmMPHCjOHCDin0ObIp0+Z1OaWT1BbGFizaa1i45BzFsZSDU9kQEue6IUbAMVks12SUfJfKdPNCf7smDuN8VlVOACXcjAZRAlIVzlzSRbYzIFP+0m4MaCQV5zjy42PISfgMnnaoA/3twxThgSVfOqFegxV7MkevnyjVW0gxlPEOVekpHgoCJgjkImJ7QKw2UnKiowKVJcxVVRV3I0iRUnpAgmuzX9ZjAy2AkCe6f3lbkDJ7BDBhGH/qjJ/hTP9ElFVnX5dUw5IQB4PYoJRkSZ7G3RxRDVjplGUdJxxsKHTYx0e4e2Yw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1652201386; bh=/n0XhfCxtNr5tRc+a8eFH+O8ugmg1X0YbV1zCiUlPNm=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=YjzpTCHKSf4uEZEW2Ow6G7YnYCjKaFSIFe3zYfSWublbhJnjDQ4zH2k5CS1ago4kdc0nfZgYHe5TEKg8Q2iZZu9i+LqYO8yRzithIqck5We4HpK0lkrPadgSXasVubEti+CZ0Uoifg1FPWQJebfBfHfUzoCK1lprQQccKdsiDKEU8gn7Qx6liVcjdygIH5XthkkWBdA97Nup53CRP6WKDD0Eqzc8uZVE2tKgxKpv/ppImSpAnh0CcyuSCoRXOJMOt7TjEcPohqitiU1rt+AJ8/NW5TWmi7IRZ+np43jTjgkYbopzxcSMe9ksIXgBaSnJ6Qa3x8z7R5nKFpcRBgy+cA==
X-YMail-OSG: ql0.xQUVM1mT5O0aSXITWWURG48qIk04WoUa0s0ch2CLLaWm6B2IvdWR0.eE0hZ
 mwiEf3rAWztR.ov1kJNQDA.i74mn1rMsZdlJWOJCHUGT1Sokmro8wKA_kKTfLfTMRkEsaF.kdAuU
 kvrW5tfQFwDJwLF0E21dPEFrZ05JMcImQvCC.olSbchXB61qBnVg7mgWrHxXWLZqeKmbX6l.Xn4g
 rHoNVf1QNWXaBFwSGMwKj6itjXs_09jD86WYxEcsBeKWlJqdfn.olRT9DWtCqOwpNGZGfDZukwoK
 RckirAAed3qSsRVOFWEA3d9mMb7DcXgKGOptk2mZ35N0tZQMvez44evpWUI18LX68WMmlVwPd1HI
 EfhWgkWYDzENgEIvGSHsZDeD6pPmwZU6bLSJ0Cf1DSGxFmgE8uo_cre8bJnWKqzVDOoPp7RKCUDH
 L0WBMgXXKrPjVvJ2xnaNdRe1dsul5FaLWZYZ9gTGhSvDUQjh6v6RKoUZJqnMCPsqldSoASjXAhu5
 x29dVoAU8hkisBYIvBkR1BhwmaQjPYNkR6xDQP5599G.JHWdMn3QHe0xt9UPXNyZf_uuBvni2UvE
 vADaocUNDqt5UKKOeW3pYBXVRmumSXWflsGAwXZoG2jffrKky4p.8NY9A4ESifQiQWiZabAVVWce
 Gk77nQDApQE7LMTkzGPTNc.ZOqhXJZuQhBcGY0VNq0rjrM80MbIzXGSp1e4vnooECGVdz_6xE570
 04T4mXS_nOt_7ykgqrLG.iIbKBTNzspmuBhPdfbuVZqq9CuY70NbNBdkrFNChQiRKCxXHe1m_OBk
 zKPhXTb7aDBg2pTkEa4z5..7R.cPlOT_10WKI6FgHOz7dLZFVH3L7B_voffkJjy6CrvAOoqWlKHN
 UK_6lNoFvpqc6clxA_3_4kz1oVQub_1alIh.tajHhNaLWQv8jHH99mF3omYvubr7fIAidhGQEMz3
 AUrbYtsWmY_Y2YbyCDRIBOUgcSd2_lpCUz36rEXLyUNGFplsh0CYL1Ts6Lr3A53g.vI8qjMnyT40
 tpUo0SSmpKzvlIsyFsMduT2IieV4tqw.QOSP6TJNOr.0CQNde3rb5f..nk_5z.X.KiLWJYvG7aq6
 p9gAruvOTlWknwVMBrn9iv3unU.yc7vjJEM7TB6i5blPEqJtmsZpkYEWaaajrDAPUltzyYRtkENO
 CwXTH4RKP8_dyzb0wi8TgvfKrYxqaJAow9TOHNfZEVSiI6eYGt1uV96a0hOBSR__ERZorGgaOiy3
 T9GZcMOVvnlebUFotnF3LfXRdFzEwHktvVy_e5CZ5Vhw3Dz.deenixtqoVjtIhMrxsp2bWXBgikK
 FgDpRLRzE1VGb6SXI5tQc.guA5TVGwjwyk00WL.sUCwQYlf5bYRHyk9VUVOyR9L7KPL7GpxuonTa
 CDj6gpyjTyXqXfw9utqrnxSl9_nXDSlKRdavL6B_HA3_Ke3ccO3hwMS7FTEIp13FF3EOC1YhawIG
 QfZxBmMQCYtx6Iu5mzovskUUOcoAdT4Sd_hgJduGNjOirNmtM0n.V2jtrXer7LhMNC71PwyyHpeq
 JFu7TAYzDG2i25IX93s8xJPuR6AcOTzCygq9Gh5saoBhgENYY2IS1XZmtna9AzhWZ_rD4VEv3EfV
 pUIt1d94GQ0myl7B7lL4rB.bhUU0cvzpme.y0xozXWDMG7mWqrTCu9HCHC9BzBbKCVFDaBAZEJU7
 6CN1I5EBa6P1vxP71ePrL0pc2ww_6IXu5eFRq.2jq21dbXSrF9Ls1sdkFP16kWAYTVb7l_DWvqbA
 p.7LqcFFrTuDTpNxDqkqquhF4r2czM_2JfTk_KTAeeWo2qSFx.AbOvo3vIh1dlBxXE.gAjAnElue
 QXGnaOCGr24TNiSpxtAvf46kLKLzhaxXvB7VOcFwFAD9CMtExjyFiuZo0ZmnITo3IjCLR9kRgEjC
 V_Bu_Y_MTQNKtiaqNM52x_5HR1sovGE7Kk8TREU2KmEoYyoG8YCem567RzoujacxUSVgINtF3dP.
 IvBZET2qYYHxZfXuKmU3STpnJ18jsaW9nmjJfJoCbVlSQHvkJW9a7lZDFL45g9v231MeNU1IXOPq
 xspm2Z.l2SVsX4smQ3boAKg5Z4lddSV3C2o.vsLGE9syR_o69_Toc667wxPeE4Tud_l2TSd8p62R
 TJCU9tLPOH1jAh_hdBSu8FX.RBRLQm_Uz_V6D9me..2IGiA.HrVxlh4VvaVnmv4xb7g2MqBPUZYg
 qjslaCNjJgZE3
X-Sonic-MF: <adriano_da_silva@yahoo.com.br>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic322.consmr.mail.bf2.yahoo.com with HTTP; Tue, 10 May 2022 16:49:46 +0000
Date:   Tue, 10 May 2022 16:49:35 +0000 (UTC)
From:   Adriano Silva <adriano_da_silva@yahoo.com.br>
To:     Bcache Linux <linux-bcache@vger.kernel.org>
Message-ID: <958894243.922478.1652201375900@mail.yahoo.com>
Subject: Bcache in writes direct with fsync. Are IOPS limited?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <958894243.922478.1652201375900.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.20188 YMailNorrin
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello.

I'm trying to set up a flash disk NVMe as a disk cache for two or three iso=
lated (I will use 2TB disks, but in these tests I used a 1TB one) spinning =
disks that I have on a Linux 5.4.174 (Proxmox node).

I'm using a NVMe (960GB datacenter devices with tantalum capacitors) as a c=
ache.

The goal, depending on the results I get in benchmark tests, would be to se=
t up an identical configuration for all my ten hyperconverged Ceph nodes, p=
utting the OSD's to run on top of bcache and with DB/Wall on the same NVMe,=
 but on a separate partition .

Testing the fio in NVME, it performs well enough at 4K random writes, even =
using direct and fsync flags.

root@pve-20:~# fio --filename=3D/dev/nvme0n1p2 --direct=3D1 --fsync=3D1 --r=
w=3Drandwrite --bs=3D4K --numjobs=3D1 --iodepth=3D1 --runtime=3D10 --time_b=
ased --group_reporting --name=3Djournal-test --ioengine=3Dlibaio

=C2=A0 write: IOPS=3D32.9k, BW=3D129MiB/s (135MB/s)(1286MiB/10001msec); 0 z=
one resets
=C2=A0 lat (nsec)=C2=A0=C2=A0 : 1000=3D0.01%
=C2=A0 lat (usec)=C2=A0=C2=A0 : 2=3D0.01%, 20=3D0.01%, 50=3D99.73%, 100=3D0=
.12%, 250=3D0.01%
=C2=A0 lat (usec)=C2=A0=C2=A0 : 500=3D0.02%, 750=3D0.11%, 1000=3D0.01%
=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=3D11=
.59%, sys=3D18.37%, ctx=3D329115, majf=3D0, minf=3D14
=C2=A0 IO depths=C2=A0=C2=A0=C2=A0 : 1=3D200.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.=
0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 submit=C2=A0=C2=A0=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 complete=C2=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=C2=A0=C2=A0=C2=A0=C2=A0 issued rwts: total=3D0,329119,0,329118 short=3D0,0=
,0,0 dropped=3D0,0,0,0
=C2=A0=C2=A0=C2=A0=C2=A0 latency=C2=A0=C2=A0 : target=3D0, window=3D0, perc=
entile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
=C2=A0 WRITE: bw=3D129MiB/s (135MB/s), 129MiB/s-129MiB/s (135MB/s-135MB/s),=
 io=3D1286MiB (1348MB), run=3D10001-10001msec


But when I do the same test on bcache writeback, the performance drops a lo=
t. Of course, it's better than the performance of spinning disks, but much =
worse than when accessed directly from the NVMe device hardware.

root@pve-20:~# fio --filename=3D/dev/bcache0 --direct=3D1 --fsync=3D1 --rw=
=3Drandwrite --bs=3D4K --numjobs=3D1 --iodepth=3D1 --runtime=3D10 --time_ba=
sed --group_reporting --name=3Djournal-test --ioengine=3Dlibaio
=C2=A0 write: IOPS=3D1548, BW=3D6193KiB/s (6342kB/s)(60.5MiB/10001msec); 0 =
zone resets
=C2=A0 lat (usec)=C2=A0=C2=A0 : 50=3D0.41%, 100=3D31.42%, 250=3D66.20%, 500=
=3D1.01%, 750=3D0.31%
=C2=A0 lat (usec)=C2=A0=C2=A0 : 1000=3D0.15%
=C2=A0 lat (msec)=C2=A0=C2=A0 : 2=3D0.20%, 4=3D0.08%, 10=3D0.08%, 20=3D0.15=
%
=C2=A0 cpu=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : usr=3D3.=
72%, sys=3D11.67%, ctx=3D44541, majf=3D0, minf=3D12
Run status group 0 (all jobs):
=C2=A0 WRITE: bw=3D6193KiB/s (6342kB/s), 6193KiB/s-6193KiB/s (6342kB/s-6342=
kB/s), io=3D60.5MiB (63.4MB), run=3D10001-10001msec

Disk stats (read/write):
=C2=A0=C2=A0=C2=A0 bcache0: ios=3D0/30596, merge=3D0/0, ticks=3D0/8492, in_=
queue=3D8492, util=3D98.99%, aggrios=3D0/16276, aggrmerge=3D0/0, aggrticks=
=3D0/4528, aggrin_queue=3D578, aggrutil=3D98.17%
=C2=A0 sdb: ios=3D0/2, merge=3D0/0, ticks=3D0/1158, in_queue=3D1156, util=
=3D5.59%
=C2=A0 nvme0n1: ios=3D1/32550, merge=3D0/0, ticks=3D1/7898, in_queue=3D0, u=
til=3D98.17%


As we can see, the same test done on the bcache0 device only got 1548 IOPS =
and that yielded only 6.3 KB/s.

This is much more than any spinning HDD could give me, but many times less =
than the result obtained by NVMe.

I've noticed in several tests, varying the amount of jobs or increasing the=
 size of the blocks, that the larger the size of the blocks, the more I app=
roximate the performance of the physical device to the bcache device. But i=
t always seems that the amount of IOPS is limited to somewhere around 1500-=
1800 IOPS (maximum). By increasing the amount of jobs, I get better results=
 and more IOPS, but if you divide the total IOPS by the amount of jobs, you=
 can see that the IOPS are always limited in the range 1500-1800 per job.

The commands used to configure bcache were:

# echo writeback > /sys/block/bcache0/bcache/cache_mode
# echo 0 > /sys/block/bcache0/bcache/sequential_cutoff
##
## Then I tried everything also with the commands below, but there was no i=
mprovement.
##
# echo 0 > /sys/fs/bcache/<cache set>/congested_read_threshold_us
# echo 0 > /sys/fs/bcache/<cache set>/congested_write_threshold_us


Monitoring with dstat, it is possible to notice that when activating the fi=
o command, the writing is all done in the cache device (a second partition =
of NVMe), until the end of the test. The spinning disk is only written afte=
r the time has passed and it is possible to see the read on the NVMe and th=
e write on the spinning disk (which means the transfer of data in the backg=
round).

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
=C2=A0=C2=A0=C2=A0=C2=A0 0 |8462B 8000B|0.03 0.15 0.31|=C2=A0 1=C2=A0=C2=A0=
 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 250=C2=A0=C2=A0 383 |09-05 15:19:4=
7|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :4096B=C2=A0 454k:=C2=A0=C2=A0 0=
=C2=A0=C2=A0 336k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :1.00=C2=A0=C2=
=A0 184 :=C2=A0=C2=A0 0=C2=A0=C2=A0 170 |4566B 4852B|0.03 0.15 0.31|=C2=A0 =
2=C2=A0=C2=A0 2=C2=A0 94=C2=A0=C2=A0 1=C2=A0=C2=A0 0|1277=C2=A0 3470 |09-05=
 15:19:48|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0 8192B:=C2=A0=C2=A0 0=C2=A0 8022k:=C2=A0=C2=A0 0=C2=A0 =
6512k|=C2=A0=C2=A0 0=C2=A0 2.00 :=C2=A0=C2=A0 0=C2=A0 3388 :=C2=A0=C2=A0 0=
=C2=A0 3254 |3261B 2827B|0.11 0.16 0.32|=C2=A0 0=C2=A0=C2=A0 2=C2=A0 93=C2=
=A0=C2=A0 5=C2=A0=C2=A0 0|4397=C2=A0=C2=A0=C2=A0 16k|09-05 15:19:49|=C2=A0=
=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7310k:=C2=A0=
=C2=A0 0=C2=A0 6460k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3240 :=C2=A0=C2=A0 0=C2=A0 3231 |6773B 6428B|0.11 0.16 0.32|=C2=A0=
 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4190=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:50|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7313k:=C2=A0=
=C2=A0 0=C2=A0 6504k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3252 :=C2=A0=C2=A0 0=C2=A0 3251 |6719B 6201B|0.11 0.16 0.32|=C2=A0=
 0=C2=A0=C2=A0 2=C2=A0 92=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4482=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:51|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7313k:=C2=A0=
=C2=A0 0=C2=A0 6496k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3251 :=C2=A0=C2=A0 0=C2=A0 3250 |4743B 4016B|0.11 0.16 0.32|=C2=A0=
 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4243=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:52|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7329k:=C2=A0=
=C2=A0 0=C2=A0 6496k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3289 :=C2=A0=C2=A0 0=C2=A0 3245 |6107B 6062B|0.11 0.16 0.32|=C2=A0=
 1=C2=A0=C2=A0 1=C2=A0 90=C2=A0=C2=A0 8=C2=A0=C2=A0 0|4706=C2=A0=C2=A0=C2=
=A0 18k|09-05 15:19:53|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5373k:=C2=A0=
=C2=A0 0=C2=A0 4184k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 2946 :=C2=A0=C2=A0 0=C2=A0 2095 |6387B 6062B|0.26 0.19 0.33|=C2=A0=
 0=C2=A0=C2=A0 2=C2=A0 95=C2=A0=C2=A0 4=C2=A0=C2=A0 0|3774=C2=A0=C2=A0=C2=
=A0 12k|09-05 15:19:54|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 6966k:=C2=A0=
=C2=A0 0=C2=A0 5668k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3270 :=C2=A0=C2=A0 0=C2=A0 2834 |7264B 7546B|0.26 0.19 0.33|=C2=A0=
 0=C2=A0=C2=A0 1=C2=A0 93=C2=A0=C2=A0 5=C2=A0=C2=A0 0|4214=C2=A0=C2=A0=C2=
=A0 15k|09-05 15:19:55|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7271k:=C2=A0=
=C2=A0 0=C2=A0 6252k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3258 :=C2=A0=C2=A0 0=C2=A0 3126 |5928B 4584B|0.26 0.19 0.33|=C2=A0=
 0=C2=A0=C2=A0 2=C2=A0 93=C2=A0=C2=A0 5=C2=A0=C2=A0 0|4156=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:56|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 7419k:=C2=A0=
=C2=A0 0=C2=A0 6504k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 3308 :=C2=A0=C2=A0 0=C2=A0 3251 |5226B 5650B|0.26 0.19 0.33|=C2=A0=
 2=C2=A0=C2=A0 1=C2=A0 91=C2=A0=C2=A0 6=C2=A0=C2=A0 0|4433=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:57|=C2=A0=C2=A0 1B
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 6444k:=C2=A0=
=C2=A0 0=C2=A0 5704k|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 2873 :=C2=A0=C2=A0 0=C2=A0 2851 |6494B 8021B|0.26 0.19 0.33|=C2=A0=
 1=C2=A0=C2=A0 1=C2=A0 91=C2=A0=C2=A0 7=C2=A0=C2=A0 0|4352=C2=A0=C2=A0=C2=
=A0 16k|09-05 15:19:58|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |6030B 7204B|0.24 0.19 0.32|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 209=C2=A0=C2=A0 279 |09-05 15:19:59|=C2=
=A0=C2=A0 0


This means that the writeback cache mechanism appears to be working as it s=
hould, except for the performance limitation.

With ioping it is also possible to notice a limitation, as the latency of t=
he bcache0 device is around 1.5ms, while in the case of the raw device (a p=
artition of NVMe), the same test is only 82.1us.

root@pve-20:~# ioping -c10 /dev/bcache0 -D -Y -WWW -s4k
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D1 time=3D1.52 ms=
 (warmup)
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D2 time=3D1.60 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D3 time=3D1.55 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D4 time=3D1.59 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D5 time=3D1.52 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D6 time=3D1.44 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D7 time=3D1.01 ms=
 (fast)
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D8 time=3D968.6 u=
s (fast)
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D9 time=3D1.12 ms
4 KiB >>> /dev/bcache0 (block device 931.5 GiB): request=3D10 time=3D1.12 m=
s

--- /dev/bcache0 (block device 931.5 GiB) ioping statistics ---
9 requests completed in 11.9 ms, 36 KiB written, 754 iops, 2.95 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 968.6 us / 1.33 ms / 1.60 ms / 249.1 us

-------------------------------------------------------------------

root@pve-20:/# dstat -drnlcyt -D sdb,nvme0n1,bcache0 --aio
--dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -ne=
t/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- asyn=
c
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0 1=
5m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 time=
=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
=C2=A0332B=C2=A0 181k: 167k=C2=A0 937k:=C2=A0 20B=C2=A0 303k|0.01=C2=A0 11.=
2 :11.9=C2=A0 42.1 :0.00=C2=A0 5.98 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
 0 |0.10 0.31 0.36|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 392=C2=A0=C2=A0 904 |09-05 15:26:35|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |2200B 2506B|0.09 0.31 0.36|=C2=A0 0=C2=A0=C2=A0=
 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 437=C2=A0=C2=A0 538 |09-05 15:26:4=
0|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5632B:=C2=A0=
=C2=A0 0=C2=A0 4096B|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |8868B 8136B|0.09 0.31 0.36|=C2=A0=
 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 247=C2=A0=C2=A0 339 |09-0=
5 15:26:41|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5632B:=C2=A0=
=C2=A0 0=C2=A0 4096B|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |7318B 7372B|0.09 0.31 0.36|=C2=A0=
 0=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 520=C2=A0 2153 |09-0=
5 15:26:42|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5632B:=C2=A0=
=C2=A0 0=C2=A0 4096B|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |3315B 2768B|0.09 0.31 0.36|=C2=A0=
 1=C2=A0=C2=A0 0=C2=A0 97=C2=A0=C2=A0 2=C2=A0=C2=A0 0|1130=C2=A0 2214 |09-0=
5 15:26:43|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 5632B:=C2=A0=
=C2=A0 0=C2=A0 4096B|=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0=
 0=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |9526B=C2=A0=C2=A0 12k|0.09 0.31 0=
.36|=C2=A0 1=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 339=C2=A0=
=C2=A0 564 |09-05 15:26:44|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 6656B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 6.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |6142B 6536B|0=
.08 0.30 0.36|=C2=A0 0=C2=A0=C2=A0 1=C2=A0 98=C2=A0=C2=A0 0=C2=A0=C2=A0 0| =
316=C2=A0=C2=A0 375 |09-05 15:26:45|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 5632B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |3378B 3714B|0=
.08 0.30 0.36|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 191=
=C2=A0=C2=A0 328 |09-05 15:26:46|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 6656B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 6.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |=C2=A0 10k=C2=
=A0=C2=A0 21k|0.08 0.30 0.36|=C2=A0 1=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=
=C2=A0=C2=A0 0| 387=C2=A0=C2=A0 468 |09-05 15:26:47|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 5632B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |7650B 8602B|0=
.08 0.30 0.36|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 97=C2=A0=C2=A0 2=C2=A0=C2=A0 0| =
737=C2=A0 2627 |09-05 15:26:48|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 6144B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 5.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |9025B 8083B|0=
.08 0.30 0.36|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 335=
=C2=A0=C2=A0 510 |09-05 15:26:49|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B 5632B:=C2=A0=C2=A0 0=C2=A0 4096B|=C2=A0=C2=
=A0 0=C2=A0 1.00 :1.00=C2=A0 4.00 :=C2=A0=C2=A0 0=C2=A0 3.00 |=C2=A0 12k=C2=
=A0=C2=A0 11k|0.08 0.30 0.35|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0| 290=C2=A0=C2=A0 496 |09-05 15:26:50|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0 1.00 :1.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |5467B 5365B|0.08 0.30 0.35=
|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 404=C2=A0=C2=A0 30=
0 |09-05 15:26:51|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0 1.00 :1.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |7973B 7315B|0.08 0.30 0.35=
|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 195=C2=A0=C2=A0 30=
4 |09-05 15:26:52|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0 1.00 :1.00=C2=A0=C2=A0=C2=A0=C2=
=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |6183B 4929B|0.08 0.30 0.35=
|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 1=C2=A0=C2=A0 0| 683=C2=A0 254=
2 |09-05 15:26:53|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0 4096B:4096B=C2=A0=C2=A0 12k:=C2=A0=C2=A0 0=C2=A0=C2=A0=
=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0 1.00 :1.00=C2=A0 2.00 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |4995B 4998B|0.08 0.30 0.35|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 199=C2=A0=C2=A0 422 |09-05 15:26:54|=C2=
=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |8353B 8059B|0.07 0.29 0.35|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 164=C2=A0=C2=A0 217 |09-05 15:26:55|=C2=
=A0=C2=A0 0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

root@pve-20:~# ioping -c10 /dev/nvme0n1p2 -D -Y -WWW -s4k
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D1 time=3D81.2 us=
 (warmup)
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D2 time=3D82.7 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D3 time=3D82.4 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D4 time=3D94.4 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D5 time=3D95.1 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D6 time=3D67.5 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D7 time=3D85.1 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D8 time=3D63.5 us=
 (fast)
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D9 time=3D82.2 us
4 KiB >>> /dev/nvme0n1p2 (block device 300 GiB): request=3D10 time=3D86.1 u=
s

--- /dev/nvme0n1p2 (block device 300 GiB) ioping statistics ---
9 requests completed in 739.2 us, 36 KiB written, 12.2 k iops, 47.6 MiB/s
generated 10 requests in 9.00 s, 40 KiB, 1 iops, 4.44 KiB/s
min/avg/max/mdev =3D 63.5 us / 82.1 us / 95.1 us / 10.0 us

---------------------------------------------------------------------------=
--------------

root@pve-20:/# dstat -drnlcyt -D sdb,nvme0n1,bcache0 --aio
--dsk/sdb---dsk/nvme0n1-dsk/bcache0 ---io/sdb----io/nvme0n1--io/bcache0 -ne=
t/total- ---load-avg--- --total-cpu-usage-- ---system-- ----system---- asyn=
c
=C2=A0read=C2=A0 writ: read=C2=A0 writ: read=C2=A0 writ| read=C2=A0 writ: r=
ead=C2=A0 writ: read=C2=A0 writ| recv=C2=A0 send| 1m=C2=A0=C2=A0 5m=C2=A0 1=
5m |usr sys idl wai stl| int=C2=A0=C2=A0 csw |=C2=A0=C2=A0=C2=A0=C2=A0 time=
=C2=A0=C2=A0=C2=A0=C2=A0 | #aio
=C2=A0332B=C2=A0 181k: 167k=C2=A0 935k:=C2=A0 20B=C2=A0 302k|0.01=C2=A0 11.=
2 :11.9=C2=A0 42.0 :0.00=C2=A0 5.96 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
 0 |0.18 0.25 0.32|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 392=C2=A0=C2=A0 904 |09-05 15:30:49|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |4443B 4548B|0.16 0.25 0.32|=C2=A0 0=C2=A0=C2=A0=
 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 108=C2=A0=C2=A0 209 |09-05 15:30:55|=C2=
=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |352=
6B 3844B|0.16 0.25 0.32|=C2=A0 1=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0| 316=C2=A0=C2=A0 434 |09-05 15:30:56|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |585=
5B 4707B|0.16 0.25 0.32|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 146=C2=A0=C2=A0 277 |09-05 15:30:57|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |889=
7B 7349B|0.16 0.25 0.32|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 99=C2=A0=C2=A0 1=C2=A0=
=C2=A0 0| 740=C2=A0 2323 |09-05 15:30:58|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |780=
2B 7280B|0.15 0.24 0.32|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 118=C2=A0=C2=A0 235 |09-05 15:30:59|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |561=
0B 4593B|0.15 0.24 0.32|=C2=A0 2=C2=A0=C2=A0 0=C2=A0 98=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0| 667=C2=A0=C2=A0 682 |09-05 15:31:00|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |904=
6B 8254B|0.15 0.24 0.32|=C2=A0 4=C2=A0=C2=A0 0=C2=A0 96=C2=A0=C2=A0 0=C2=A0=
=C2=A0 0| 515=C2=A0=C2=A0 707 |09-05 15:31:01|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |532=
3B 5129B|0.15 0.24 0.32|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 191=C2=A0=C2=A0 247 |09-05 15:31:02|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |424=
9B 3549B|0.15 0.24 0.32|=C2=A0 0=C2=A0=C2=A0 0=C2=A0 98=C2=A0=C2=A0 2=C2=A0=
=C2=A0 0| 708=C2=A0 2565 |09-05 15:31:03|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0 4096B:=C2=A0=
=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 =
0 :=C2=A0=C2=A0 0=C2=A0 1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |757=
7B 7351B|0.14 0.24 0.32|=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=
=A0 0| 291=C2=A0=C2=A0 350 |09-05 15:31:04|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :2080k 4096B:=C2=A0=C2=A0 0=C2=A0=
=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :62.0=C2=A0 =
1.00 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |5731B 5692B|0.14 0.24 0.32|=
=C2=A0 0=C2=A0=C2=A0 0 100=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 330=C2=A0=C2=A0 462=
 |09-05 15:31:05|=C2=A0=C2=A0 0
=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=
=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 |=C2=A0=C2=A0 0=C2=A0=C2=
=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0 0 :=C2=A0=C2=A0 0=
=C2=A0=C2=A0=C2=A0=C2=A0 0 |7347B 5852B|0.14 0.24 0.32|=C2=A0 1=C2=A0=C2=A0=
 0=C2=A0 99=C2=A0=C2=A0 0=C2=A0=C2=A0 0| 306=C2=A0=C2=A0 419 |09-05 15:31:0=
6|=C2=A0=C2=A0 0



The cache was configured directly on one of the NVMe partitions (in this ca=
se, the first partition). I did several tests using fio and ioping, testing=
 on a partition on the NVMe device, without partition and directly on the r=
aw block, on a first partition, on the second, with or without configuring =
bcache. I did all this to remove any doubt as to the method. The results of=
 tests performed directly on the hardware device, without going through bca=
che are always fast and similar.

But tests in bcache are always slower. If you use writethrough, of course, =
it gets much worse, because the performance is equal to the raw spinning di=
sk.

Using writeback improves a lot, but still doesn't use the full speed of NVM=
e (honestly, much less than full speed).

But I've also noticed that there is a limit on writing sequential data, whi=
ch is a little more than half of the maximum write rate shown in direct tes=
ts by the NVMe device.

Processing doesn't seem to be going up like the tests.

Please would anyone know, what could be causing these limits?

Tanks
