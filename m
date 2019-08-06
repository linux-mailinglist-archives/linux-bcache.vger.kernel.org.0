Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C6C83110
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2019 13:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfHFL7l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Aug 2019 07:59:41 -0400
Received: from mout.gmx.net ([212.227.15.18]:34953 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726092AbfHFL7l (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Aug 2019 07:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565092779;
        bh=PYk3jQ8/NboEONrBKQpsTKc1gjB25V5qeM42aFCPZNo=;
        h=X-UI-Sender-Class:From:To:Subject:Date:In-Reply-To:References;
        b=OfeO0nB8YSdu4x8M9IavVkvP9utkCZTN7sZmq8Vfc4r3DaI5yezEGcwH3uSsBX0/B
         tl//EzbadpPJEWSRorGrJcAfAsnwyzm2nLSPcv5UGXB0U3hga042C2hJXzcxa2UKKB
         v3Ap/2ZixG5w4vzPwJoR8PUfviUPHHvSEKpra5D4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MIu7d-1hsU5K2icr-002blm for
 <linux-bcache@vger.kernel.org>; Tue, 06 Aug 2019 13:59:39 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     linux-bcache@vger.kernel.org
Subject: Re: bcachefs raid10 questions
Date:   Tue, 06 Aug 2019 13:59:39 +0200
Message-ID: <3434925.2TXZg96isB@t460-skr>
In-Reply-To: <14704760.XVjdDnQezj@t460-skr>
References: <14704760.XVjdDnQezj@t460-skr>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:HSnrR3h8FjTsTZ35VP3P01oJuAFJCVmO7zY9pt17xRu8tjycfoY
 gxQZO4m60Ot8prCxuLK2Q6afqtVQFau6VvjSA4VSq68R3qqW9VuSOAnl4J7x6P2NpDcwEED
 ECXnMkP5ZaDab432GHrBeZTmPVHrukL85Td+bx566EBjYUbJ9XdUU6SkPtKChkI/gPSM4q3
 Fhf5KgJUywBsKNGEzmW8g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jlxJIyW5Vzs=:tQ+N2cFIgvsB9oOTJLWsBl
 X9WRifcxtiK57bHiL9kOnBFkPSjMBziR/HN7iuaCJKbSHqd1ve7W/sppWcLapAS6CgqLa8vnO
 C/intRP7Fs0ue7YF/zaWUM/dKhlnUNxLQrST3aQaSHq24FKUL7m/N1X5L9hHd19dcdSP/7UOT
 JMH/M2RU3VLNEycvoWgEymaS3OqnUgdoR4MWQUSx9HYPY6U0AoR386+5mooojbeCe2Z4S/k8v
 Aj66/c8/QZPnwtNStnvWhrZIFPAPA4viMpsivCjvFdgWWEc+fBP8nYkmtlUeRxYMcVhKDj1mx
 H6/gO7KJYwk3ZqJFh/PqRfgv5SrFEHhTzfIzjhYnzGyd8VgqZA7/8DWurV13TePMz50utngaF
 VxdhBwt9Rvu0grkBj3QXoa9xvZdUEm3zylvnmLv/isgSOfAtttQbSrBisHlcRe4Ch+gUwbbHW
 lyhU6KNXWDaqaWaZ+pUkfduhyhXFbf5uFBfQuf6FMaWtWl4LTe3Ldgz4b9koWvHrn+1n+br6a
 TEKaTSYIE5B29Z88nczjiZC+LAnnGRG9FabiELe7lilhz0jfkO2/2bdjeEMMtJo7xR48OATuX
 my/twHrGw5DqR+poz/7FeK5ntqIEv4i5tuZIGy+kFjGCcuww0X6NMdyZl/vfVU46Dq4K54XNp
 0gcxDABUbF38DlVoUP994JB662FV9PJckZmPxXFro5unzJ/pvqEZ7Dh0Lcd/l73t2Jl1TChi5
 9SBMiwX8LOjZ+B7cZnS+RXDKLjggDvBdq/qnc+7biLf2P+33gmg9sqMoVBO2cOP/OvEMAXrEs
 JvSYhHRzcCRoAeAjtzBHvem1IU3UPrHTu++z+sZL+DbvhcmxIFJZ1M2H7RiEV1AbFyGcUNCxt
 XD+qmvFHwZBhdxuXQF2H5NrF7EBrG9HnRlExWPEcEOmKeBBVkzI5UtkLwcvhAb+mifv52Qyod
 v9EWApm9nL/KIxelTbBL6UhOQ2puTSAlhcKmnwh1/vopOTrIPw7ghwiSzk/+KNEuphXDpZuqb
 U+u9O033OSWjLWyPnJC3ErDJPhdfJRQ4C2bMEJule4dHCt6o671C0g61a/JlOX8ReHAlNKU7R
 kgEfrbG0fYncc5QUxjctx3hsyGCJk3taXOcxCOsh1em3xTlid6+jtwWmQy+GhoQNlf+IbRX59
 QTqL4=
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello,

so far I got no answer, so I will try it again ;-)

best regards
Stefan

On Tuesday, May 21, 2019 8:50:05 AM CEST you wrote:
> Hello,
>
> short question is that possible with bcachefs, I know it isn't with btrf=
s:
>
> zpool status
>  pool: nc_storage
> state: ONLINE
>  scan: scrub repaired 0B in 1h43m with 0 errors on Wed May 15 05:58:45 2=
019
> config:
>
>        NAME           STATE     READ WRITE CKSUM
>        nc_storage     ONLINE       0     0     0
>          mirror-0     ONLINE       0     0     0
>            j1d03-hdd  ONLINE       0     0     0
>            j2d03-hdd  ONLINE       0     0     0
>          mirror-1     ONLINE       0     0     0
>            j1d04-hdd  ONLINE       0     0     0
>            j2d04-hdd  ONLINE       0     0     0
>          mirror-2     ONLINE       0     0     0
>            j1d05-hdd  ONLINE       0     0     0
>            j2d05-hdd  ONLINE       0     0     0
>          mirror-3     ONLINE       0     0     0
>            j1d06-hdd  ONLINE       0     0     0
>            j2d06-hdd  ONLINE       0     0     0
> [...]
>           mirror-16    ONLINE       0     0     0
>             j1d18-hdd  ONLINE       0     0     0
>             j2d18-hdd  ONLINE       0     0     0
>         logs
>           mirror-9     ONLINE       0     0     0
>             j1d00-ssd  ONLINE       0     0     0
>             j2d00-ssd  ONLINE       0     0     0
>         cache
>           j1d02-ssd    ONLINE       0     0     0
>           j2d02-ssd    ONLINE       0     0     0
>
> In this case I can lose a HBA Controller or a complete JBOD without losi=
ng data. I think thats important in datacenters.
> The same is with other RAID levels when the cross the harddisk over seve=
ral jbods.
>
> thanks in advance,
>
> best regards
> Stefan
>
>


