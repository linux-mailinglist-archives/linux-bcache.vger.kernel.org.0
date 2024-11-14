Return-Path: <linux-bcache+bounces-787-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 004919C8B7A
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Nov 2024 14:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7956A1F24E57
	for <lists+linux-bcache@lfdr.de>; Thu, 14 Nov 2024 13:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2E11FAEE3;
	Thu, 14 Nov 2024 13:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EKxggTIX"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983E1F8918;
	Thu, 14 Nov 2024 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731589860; cv=none; b=Jk37FcBvEvB3NwR8A6puR10W3WQATvdFaSQxKH36CjmcmAk45yUKcRRXuH2BTY/sXGVhChiV2/kfVoZcvu/ak5ZnHiOoLp0ElrIKV9203osjiIPC6aGuToZ6ae8KrDl+6+f5xWHZTkcMgOmnm14rmO8xQvpI3UStUflZTxpVOu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731589860; c=relaxed/simple;
	bh=7TCW1nEHBuKs8gce/BHqeiS2uS4gFsawmPxDdJf3jnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTes4uIeS6hOkJbHdSAEy3Ct8dC2HLiPTXDoG3wLeJZjTkwqq4xxCXxrjGtOO9VuiFy8/NSUlS7v98w35X00SWsQ+gwGtMYVjF2lxCCfYTrGazBIs3IZ8VtnoX0QjR1GqY8cSG5O/xPXSsLOrwMtnILrg6J6xN0ujpvTUXCmt68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EKxggTIX; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5ee645cf763so250751eaf.2;
        Thu, 14 Nov 2024 05:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731589858; x=1732194658; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K23ZnxwrTCv6hkGLIEIe2KNWpiMS6jpTwORnNpzQKPo=;
        b=EKxggTIXywgGjYKO29sS67kl+wbk4bcHPLs8olZnsFqK6PuxorAahiUL3xmwzmkTfP
         HCXBPtEhhKkpofwARhXBnyj4vUrejotEGdoe6f3ejEHMKItzcpct1wF7K5WgA1CnfS9S
         MKHtJU2PLY6q9kli0MN+yhxBO4bhHKIS8bGR8gHREuNJmkwNGEMC71cmwczjUvLyDozx
         U1FO3fCHapGWjeiK5ZYv0omDDcI0j8VT6bMMHLMAqdzWW0/40oy0CKp64X7d1MEXUZ0S
         VXeZ7QSnj7XiHK2XcEfsSL8S4ItkcN+5u191WFRnEYoCcjWKeEQ4n5ptNbj2p5DgdszF
         ChVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731589858; x=1732194658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K23ZnxwrTCv6hkGLIEIe2KNWpiMS6jpTwORnNpzQKPo=;
        b=Vq/PnHPw9c+Ns0SYVhXboD0JjVoNerjs9H5VNxlDItgO8GS/C6iE+2RGgQR1U6tAmP
         N+PA3bOJpbHjHqetZ2hhsGP3RCu55W12r5hvBTGy/yjeuCwHmo6r8bG/EVklw3nnCl8C
         xo6WWPftZhEurUZrLA9usIV87UHBE6JcFcq3Z1IgU+OntcBHTrlzOAn5AEvCrBNZ1zPW
         YF5d5Pl4qUd5ioHiuUcoPhLoguo8ociGyB39sEPmKPXh8K5GbmUuXqDzBDxcROFew3a/
         fgojLYOnxiCM1m86+ZCFeucKtuDNQNAAj5icjzDtIN1wowkoNWfn6hpVQT7DvVKCB+3j
         B4ig==
X-Forwarded-Encrypted: i=1; AJvYcCVh8z25h8cTk6FSew79KFqAFmpOu6J49vFRk+e0g8TjyzR5r8HygnyA4RZ/q2diFlpy8Q8QdPrGzVuC8zE=@vger.kernel.org, AJvYcCWCc3sMY9Mnni1J5CrJ16VYFa+t0V5rzwHbOGwcAFJXgS5ppQSSgsjdgZIsTWJizlWL+rqiddlIHJNIFLtJ@vger.kernel.org
X-Gm-Message-State: AOJu0YySAZLqm0tapZAQvLNXFIdJ89LyJ/eaMrKja6GHPW/rk+vvI0fS
	ElOjWYRuXTHrEePX4jHGAkc/pYekixxQFdFld00brS6RQ7lhszZClVec3KuHOUg9/dBHAhayuLJ
	M5vsenElx4Db5DM5nQIgfT1TJ0A0=
X-Google-Smtp-Source: AGHT+IHpQuFEYMip0JhyGeR1GxNXzdf72kfgui3J+vlRuutLYrNPSGVb/18TQoas9LrHX3aSS05MmmlcZ5afICkiYfI=
X-Received: by 2002:a05:6359:5104:b0:1c3:8c84:e08c with SMTP id
 e5c5f4694b2df-1c66f13505bmr627284655d.10.1731589857794; Thu, 14 Nov 2024
 05:10:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAsfc_omvbgaSpmxqPPD9Jf4P2H-fEU97ADfRzJ0jULxGJehwg@mail.gmail.com>
 <TYZPR02MB78424F31FF023102693D2DB2A65A2@TYZPR02MB7842.apcprd02.prod.outlook.com>
 <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
In-Reply-To: <15077D4C-8DE9-4751-9492-51D972B3E4C3@suse.de>
From: liequan che <liequanche@gmail.com>
Date: Thu, 14 Nov 2024 21:10:46 +0800
Message-ID: <CAAsfc_r_6mZ2HesDOQWU-0F2KXhz=EJ_nHeR4bLanXNnAiduTg@mail.gmail.com>
Subject: [PATCH] bcache:fix oops in cache_set_flush
To: Coly Li <colyli@suse.de>
Cc: "mingzhe.zou@easystack.cn" <mingzhe.zou@easystack.cn>, Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcache <linux-bcache@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi colyli and mingzhe.zou:
  I am trying to reproduce this problem, maybe it is a random problem.
It is triggered only when IO error reading priorities occurs.
  The same operation was performed on three servers, replacing the 12T
disk with a 16T disk. Only one server triggered the bug. The on-site
operation steps are as follows:
1. Create a bache device.
make-bcache -C /dev/nvme2n1p1 -B /dev/sda --writeback --force --wipe-bcache
/dev/sda is a 12T SATA disk.
/dev/nvme2n1p1 is the first partition of the nvme disk. The partition
size is 1024G.
The partition command is parted -s --align optimal /dev/nvme2n1 mkpart
primary 2048s 1024GiB
2. Execute fio test on bcache0

cat /home/script/run-fio-randrw.sh
bcache_name=3D$1
if [ -z "${bcache_name}" ];then
echo bcache_name is empty
exit -1
fi

fio --filename=3D/dev/${bcache_name} --ioengine=3Dlibaio --rw=3Drandrw
--bs=3D4k --size=3D100% --iodepth=3D128 --numjobs=3D4 --direct=3D1 --name=
=3Drandrw
--group_reporting --runtime=3D30 --ramp_time=3D5 --lockmem=3D1G | tee -a
./randrw-iops_k1.log
Execute bash run-fio-randrw.sh multiple times bcache0
2. Shutdown
poweroff
No bcache data clearing operation was performed
3. Replace the 12T SATA disk with a 16T SATA disk
After shutting down, unplug the 12T hard disk and replace it with a
16T hard disk.
4. Adjust the size of the nvme2n1 partition to 1536G
parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
Kernel panic occurs after partitioning is completed
5. Restart the system, but cannot enter the system normally. It is
always in the restart state.
6. Enter the rescue mode through the CD, clear the nvme2n1p1 super
block information. After restarting again, you can enter the system
normally.
wipefs -af /dev/nvme2n1p1
7. Repartition again, triggering kernel panic again.
parted -s --align optimal /dev/nvme2n1 mkpart primary 2048s 1536GiB
The same operation was performed on the other two servers, and no
panic was triggered.
The server with the problem was able to enter the system normally
after the root of the cache_set structure was determined to be empty.
I updated the description of the problem in the link below.
bugzilla: https://gitee.com/openeuler/kernel/issues/IB3YQZ
 Your suggestion was correct. I removed the unnecessary btree_cache
iserr_or_null check.
  ------------
  If the bcache cache disk contains damaged data,
when the bcache cache disk partition is directly operated,
the system-udevd service is triggered to call the bcache-register
program to register the bcache device,resulting in kernel oops.

 Signed-off-by: cheliequan  <cheliequan@inspur.com>

---
 drivers/md/bcache/super.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fd97730479d8..c72f5576e4da 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1741,8 +1741,10 @@ static void cache_set_flush(struct closure *cl)
        if (!IS_ERR_OR_NULL(c->gc_thread))
                kthread_stop(c->gc_thread);

-       if (!IS_ERR(c->root))
-               list_add(&c->root->list, &c->btree_cache);
+       if (!IS_ERR_OR_NULL(c->root)) {
+               if (!list_empty(&c->root->list))
+                       list_add(&c->root->list, &c->btree_cache);
+       }

        /*
         * Avoid flushing cached nodes if cache set is retiring
--=20
2.33.0

Coly Li <colyli@suse.de> =E4=BA=8E2024=E5=B9=B411=E6=9C=8813=E6=97=A5=E5=91=
=A8=E4=B8=89 21:54=E5=86=99=E9=81=93=EF=BC=9A
>
>
>
> > 2024=E5=B9=B411=E6=9C=8813=E6=97=A5 16:58=EF=BC=8Cmingzhe.zou@easystack=
.cn =E5=86=99=E9=81=93=EF=BC=9A
> >
> > Hi, cheliequan and Coly:
> >
> > I saw some dmesg printing information from https://gitee.com/openeuler/=
kernel/issues/IB3YQZ
> >
>
> This is a distribution issue, not upstream bug.
>
> The kernel is based on 5.10 kernel. If it can be confirmed to reproduce w=
ith latest upstream kernel, I can take a look.
>
> Thanks.
>
> Coly Li
> >
> >
>
> [snipped]
>

