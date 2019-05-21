Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0B24865
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 08:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbfEUGuH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 02:50:07 -0400
Received: from mout.gmx.net ([212.227.15.18]:36783 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfEUGuH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 02:50:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1558421405;
        bh=SLMSk5MbDxB5+xHvxVxj/SO9Lym/i26YVPP9wjEQDc8=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=fADlwDEPmFjY2yLWFeMuERm1Nyxhku5OH45i5vAL1OYAyZyUzDDwXTyh3wMuYLaWt
         mgfAfI0NYQ9mPZrNHiTwIaOcpfwE1DNFHEZh7WowkSyHoyo86X2kZ3ZtuCjCtI1oX5
         IbBiZsWmzNd8vbSRLKCm8ju9/PtyIE+IymyS+g1g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LaoHI-1gn4D73KMS-00kTBE for
 <linux-bcache@vger.kernel.org>; Tue, 21 May 2019 08:50:05 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcache@vger.kernel.org
Subject: bcachefs raid10 questions
Date:   Tue, 21 May 2019 08:50:05 +0200
Message-ID: <14704760.XVjdDnQezj@t460-skr>
User-Agent: KMail/5.2.3 (Linux/4.19.0-0.bpo.2-amd64; KDE/5.28.0; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:WBw/Qsxn5IcWvlDSsSIHvF5B2KcxD2DMIFfrbIuddYcJ/ERiXm8
 Vk0hgdptWvgaEJCuNjH7aA3ouFxbhH/WPr09CT88iM8udnaxEEvbI4fD4CZ/25L9NxWCTsn
 vxA7ylmjYJrIfgEtxAkW8DiVtM7CAOvnNU8yD3bOGW2m21OpbqjHUeIpEv6Jhok0J947M5O
 NhtIJ9Gx+c3YeffyUG3RA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qbOm3ND8Ifk=:cVW6S2P45zCBcvLeOoyIIl
 nNltN6ZaF9FwoVXgffE309d0wijl4PwdkSGjYpoRH+F1KtWv3bQUOGchfKbjouabraCSdyUM9
 p8PH91Jowx9C0QEJ9sX8+j5idH6N+HhY0Reu9tgMV0l3QF0ThKezJjoZoKItQqPqtT8untUB2
 4fzAksUWlxWqRzuFxZsNy1as+P31O4eF68dQX2XJcnIbsPExs+AY/QeQNVh37tf1GYFr4I0PJ
 EZBlOyCYsnuW+xvKxFDlYplXp5/Ub38mQHbrW760daCzN5WpYCIgydeG4P8BBv6XXZPTIuAs7
 uD6PcwNUHkwVTNY3o7RfR575Ld2p42deVKq9cZdCi1Q9IVj6T7R7dmiPySr2PxS5rbsD5Cq+f
 FbtEAYiRhDSV165aWy2gGTcLv1r9bQJsd9O3AfUu7bP9Ef2uScP+ZSabUQnoypdv9fHohTeVi
 pANrP98zXGqLBrO0+UTQD5Ki1ZrKEvRKEhv+bmzmT8h0LZd8wnOMUbl+BKsl/wSqd9nCNbavp
 CL3CdlZPMUEU4KXuPBcKDo+12GoaaDbBRsDTQcuHY8qOtC6pKe/M4RKYwG8d3hrF8GLjZ9+48
 8yhchPkITLDRbh1miMimOXF9u+Wh3Oq6+jDL2E6jlf5SGICZkpVjEjSM170Tz5XGQ+Ffh5iRw
 9ZpoJJERh0sGphP349kFxqa8GrgsXhjz5wS2C2BH1i6iZDWqEb4f06sgvs7UDjOpRTb7g/ew1
 julOl5JNceg864bqPBnY8JnNQc5b1ROShZRDL1J9+DfTbuiwnkhUGgpUQJBVjeipDVs+Siwjb
 e//M44Wc5JxB9MxJYcQi5EhSAzieKCGujvY+BieJ41+f7Twu3+Sb8D0AJUmunfBPUSviJQ1LV
 Ak5MtxVdkCS0vKecr44S5yuUPek/nuOxIAjuy0VLRKvj6mQHc/VApqwtWE6uamJ+JEMRi6SRS
 NS6WBStdfzSHOI46evHIoVxTbvpUWSdnfd0PD8OPAxzzrN4oEuTHg
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

short question is that possible with bcachefs, I know it isn't with btrfs:

zpool status
 pool: nc_storage
state: ONLINE
 scan: scrub repaired 0B in 1h43m with 0 errors on Wed May 15 05:58:45 201=
9
config:

       NAME           STATE     READ WRITE CKSUM
       nc_storage     ONLINE       0     0     0
         mirror-0     ONLINE       0     0     0
           j1d03-hdd  ONLINE       0     0     0
           j2d03-hdd  ONLINE       0     0     0
         mirror-1     ONLINE       0     0     0
           j1d04-hdd  ONLINE       0     0     0
           j2d04-hdd  ONLINE       0     0     0
         mirror-2     ONLINE       0     0     0
           j1d05-hdd  ONLINE       0     0     0
           j2d05-hdd  ONLINE       0     0     0
         mirror-3     ONLINE       0     0     0
           j1d06-hdd  ONLINE       0     0     0
           j2d06-hdd  ONLINE       0     0     0
[...]
          mirror-16    ONLINE       0     0     0
            j1d18-hdd  ONLINE       0     0     0
            j2d18-hdd  ONLINE       0     0     0
        logs
          mirror-9     ONLINE       0     0     0
            j1d00-ssd  ONLINE       0     0     0
            j2d00-ssd  ONLINE       0     0     0
        cache
          j1d02-ssd    ONLINE       0     0     0
          j2d02-ssd    ONLINE       0     0     0

In this case I can lose a HBA Controller or a complete JBOD without losing=
 data. I think thats important in datacenters.
The same is with other RAID levels when the cross the harddisk over severa=
l jbods.

thanks in advance,

best regards
Stefan


