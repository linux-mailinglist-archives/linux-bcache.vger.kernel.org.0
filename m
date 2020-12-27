Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAA42E3050
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Dec 2020 07:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgL0GZr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Dec 2020 01:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgL0GZq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Dec 2020 01:25:46 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA8FC061794
        for <linux-bcache@vger.kernel.org>; Sat, 26 Dec 2020 22:25:06 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id o13so17344026lfr.3
        for <linux-bcache@vger.kernel.org>; Sat, 26 Dec 2020 22:25:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oBV91PDrHhlg7ed6DGhj0Hk8y7OXlaZtYQH9qz2VyIE=;
        b=m2x74FWHq22bUNL46a74+TpYka6zRdlgtz4KKDfk+giUc/s+f8Xz1DbNnQ1nCyLux3
         lXgEDz+9ryE1m18tHrjPK4BEVm5FOkgsoCNfb+JQq6f8iLgx5/XyKHqoTw6EpBrO8gDp
         Dr/IPardIa/iSsM/zI2N1//lACX9GIqzHQFXfj6musszGp7qwkT3imU23WItA5iRg60I
         GVxT4wRSyOdhJNyeKhlyHPaMlpUZKOYzfnUR0+fuu7FGFmdlr5tSi3W101bi3Pw3DXTP
         cTUB/RX00yWsH8qKr0qKJRCQz41tZYvhbwK2A+jm8HdZLFbqo11hhVSLJMzV07ibwo92
         Co5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oBV91PDrHhlg7ed6DGhj0Hk8y7OXlaZtYQH9qz2VyIE=;
        b=WDJVxw7KpnJgCycDml0Vr11mKQr3QGNtJqeK6rUdgkwKcUb2aL9ZbNTqw+T/camdja
         GVwS8AH1CoUe4nsI4fvrdll83s7FheqP4tS8vqg1qfMoUBcNUI8LiTdgVsL11PlHsS8Y
         dvPhGYD4fn1tds2wOn3kC+xKYV1SE8/LiAcJIiMnlD+wjZVhmpxk3h1aT5IAXB/FB6vA
         cBzjUS18VytJZjtAALawEtRWgS+3cRiN4NzKlyednsDv5HD+uXDWVrkxLMJsDLxKlcMP
         dBPGy7w/EP2LjLg2jWHpopvwB4dk/cSsimZXjjdGfsoHs7t9GKQmYjf1aJiGwNc1LLbe
         Wq3Q==
X-Gm-Message-State: AOAM530X7vuwgLXHA2A4yipIzTr8aN8vjbHP42E3B5dzwWLAnHwJwBh7
        obD+VXpgZ0TARC1KBmNKWtH2C8/nqo7LDwFC23agpz8kDjSeiQ==
X-Google-Smtp-Source: ABdhPJz4+66K7a+MCbckiW3rpj8StdjmGeZfk38i6Etlp0sxEeh9tniC1wLIwWFiV+w17hqs1Y0KtbyEqspEz82p2UA=
X-Received: by 2002:a2e:2417:: with SMTP id k23mr19228884ljk.373.1609050304370;
 Sat, 26 Dec 2020 22:25:04 -0800 (PST)
MIME-Version: 1.0
From:   Nathan Dehnel <ncdehnel@gmail.com>
Date:   Sun, 27 Dec 2020 00:24:53 -0600
Message-ID: <CAEEhgEsdeEAzxw9F2jbAFiFhjdvQbRyqjbVg1L6Y0pN1Go4ceg@mail.gmail.com>
Subject: How to deal with with backing device dropping out
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I have a btrfs raid10 array, and occasionally a drive will disconnect
temporarily. After it reconnects though, it is no longer listed by
lsblk with a /dev/bcache* device under it, and it usually has a
different /dev/sd* drive letter as well, and "btrfs fi show"
subsequently reports the device as missing.

I have tried "echo  /dev/sd* > /sys/fs/bcache/register" but it does
not make the /dev/bcache* device reappear (not while the filesystem is
mounted, at least).

Is there any way to deal with this, short of rebooting?

NAME          MAJ:MIN  RM   SIZE RO TYPE  MOUNTPOINT
sdb             8:16    0 931.5G  0 disk
=E2=94=94=E2=94=80sdb1          8:17    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache0   251:0     0 931.5G  0 disk  /
sdc             8:32    0 931.5G  0 disk
=E2=94=94=E2=94=80sdc1          8:33    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache1   251:128   0 931.5G  0 disk
sdd             8:48    0 931.5G  0 disk
=E2=94=94=E2=94=80sdd1          8:49    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache2   251:256   0 931.5G  0 disk
sde             8:64    0 931.5G  0 disk
=E2=94=94=E2=94=80sde1          8:65    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache3   251:384   0 931.5G  0 disk
sdf             8:80    0 931.5G  0 disk
=E2=94=94=E2=94=80sdf1          8:81    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache4   251:512   0 931.5G  0 disk
sdg             8:96    0 931.5G  0 disk
=E2=94=94=E2=94=80sdg1          8:97    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache5   251:640   0 931.5G  0 disk
sdh             8:112   0 931.5G  0 disk
=E2=94=94=E2=94=80sdh1          8:113   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache6   251:768   0 931.5G  0 disk
sdi             8:128   0 931.5G  0 disk
=E2=94=94=E2=94=80sdi1          8:129   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache7   251:896   0 931.5G  0 disk
sdj             8:144   0 931.5G  0 disk
=E2=94=94=E2=94=80sdj1          8:145   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache8   251:1024  0 931.5G  0 disk
sdk             8:160   0 931.5G  0 disk
=E2=94=94=E2=94=80sdk1          8:161   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache9   251:1152  0 931.5G  0 disk
nvme0n1       259:0     0  13.4G  0 disk
=E2=94=9C=E2=94=80nvme0n1p1   259:1     0     2M  0 part
=E2=94=9C=E2=94=80nvme0n1p2   259:2     0   128M  0 part
=E2=94=94=E2=94=80nvme0n1p3   259:3     0  13.3G  0 part
  =E2=94=94=E2=94=80md0         9:0     0  13.3G  0 raid1
    =E2=94=9C=E2=94=80bcache0 251:0     0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache1 251:128   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache2 251:256   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache3 251:384   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache4 251:512   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache5 251:640   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache6 251:768   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache7 251:896   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache8 251:1024  0 931.5G  0 disk
    =E2=94=94=E2=94=80bcache9 251:1152  0 931.5G  0 disk
nvme1n1       259:4     0  13.4G  0 disk
=E2=94=9C=E2=94=80nvme1n1p1   259:5     0     2M  0 part
=E2=94=9C=E2=94=80nvme1n1p2   259:6     0   128M  0 part
=E2=94=94=E2=94=80nvme1n1p3   259:7     0  13.3G  0 part
  =E2=94=94=E2=94=80md0         9:0     0  13.3G  0 raid1
    =E2=94=9C=E2=94=80bcache0 251:0     0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache1 251:128   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache2 251:256   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache3 251:384   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache4 251:512   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache5 251:640   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache6 251:768   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache7 251:896   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache8 251:1024  0 931.5G  0 disk
    =E2=94=94=E2=94=80bcache9 251:1152  0 931.5G  0 disk

NAME          MAJ:MIN  RM   SIZE RO TYPE  MOUNTPOINT
sdb             8:16    0 931.5G  0 disk
=E2=94=94=E2=94=80sdb1          8:17    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache0   251:0     0 931.5G  0 disk  /
sdc             8:32    0 931.5G  0 disk
=E2=94=94=E2=94=80sdc1          8:33    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache1   251:128   0 931.5G  0 disk
sdd             8:48    0 931.5G  0 disk
=E2=94=94=E2=94=80sdd1          8:49    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache2   251:256   0 931.5G  0 disk
sde             8:64    0 931.5G  0 disk
=E2=94=94=E2=94=80sde1          8:65    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache3   251:384   0 931.5G  0 disk
sdf             8:80    0 931.5G  0 disk
=E2=94=94=E2=94=80sdf1          8:81    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache4   251:512   0 931.5G  0 disk
sdg             8:96    0 931.5G  0 disk
=E2=94=94=E2=94=80sdg1          8:97    0 931.5G  0 part
  =E2=94=94=E2=94=80bcache5   251:640   0 931.5G  0 disk
sdh             8:112   0 931.5G  0 disk
=E2=94=94=E2=94=80sdh1          8:113   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache6   251:768   0 931.5G  0 disk
sdi             8:128   0 931.5G  0 disk
=E2=94=94=E2=94=80sdi1          8:129   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache7   251:896   0 931.5G  0 disk
sdj             8:144   0 931.5G  0 disk
=E2=94=94=E2=94=80sdj1          8:145   0 931.5G  0 part
  =E2=94=94=E2=94=80bcache8   251:1024  0 931.5G  0 disk
sdk             8:160   0 931.5G  0 disk
=E2=94=94=E2=94=80sdk1          8:161   0 931.5G  0 part
nvme0n1       259:0     0  13.4G  0 disk
=E2=94=9C=E2=94=80nvme0n1p1   259:1     0     2M  0 part
=E2=94=9C=E2=94=80nvme0n1p2   259:2     0   128M  0 part
=E2=94=94=E2=94=80nvme0n1p3   259:3     0  13.3G  0 part
  =E2=94=94=E2=94=80md0         9:0     0  13.3G  0 raid1
    =E2=94=9C=E2=94=80bcache0 251:0     0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache1 251:128   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache2 251:256   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache3 251:384   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache4 251:512   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache5 251:640   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache6 251:768   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache7 251:896   0 931.5G  0 disk
    =E2=94=94=E2=94=80bcache8 251:1024  0 931.5G  0 disk
nvme1n1       259:4     0  13.4G  0 disk
=E2=94=9C=E2=94=80nvme1n1p1   259:5     0     2M  0 part
=E2=94=9C=E2=94=80nvme1n1p2   259:6     0   128M  0 part
=E2=94=94=E2=94=80nvme1n1p3   259:7     0  13.3G  0 part
  =E2=94=94=E2=94=80md0         9:0     0  13.3G  0 raid1
    =E2=94=9C=E2=94=80bcache0 251:0     0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache1 251:128   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache2 251:256   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache3 251:384   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache4 251:512   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache5 251:640   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache6 251:768   0 931.5G  0 disk
    =E2=94=9C=E2=94=80bcache7 251:896   0 931.5G  0 disk
    =E2=94=94=E2=94=80bcache8 251:1024  0 931.5G  0 disk
