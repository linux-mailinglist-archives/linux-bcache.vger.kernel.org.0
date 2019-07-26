Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A675F19
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Jul 2019 08:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfGZGfd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 26 Jul 2019 02:35:33 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:46875 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbfGZGfd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 26 Jul 2019 02:35:33 -0400
Received: by mail-vs1-f42.google.com with SMTP id r3so35366073vsr.13
        for <linux-bcache@vger.kernel.org>; Thu, 25 Jul 2019 23:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dihptPS7qzTnzYasf9qJX5UUwlifJwjKMMIJAa9qbkg=;
        b=bxsc+JHoySM8mARIYk0v57YpMU1GzDPNbK0/QXKlX/BdTskhynRRcahC3gvu8wxRtv
         4TY6BEknvlOqvC5FeIaO/mfCng22g+2//NLi/DI+SbGui7CXIVquYaXLqPQMK+0O9oI6
         zhgYvDW+DXmAfjZKRQ3bixIyWkijGnCztOv8l+BTxICOIEPGNoqRQHgHNIIGrKfsANzD
         KbSsIzMU5a5TBdorOfAY5RoKxaooXKMIqdTQaHlkInk6m4m+9Hr9GHxkg6nmd1CTrzxu
         /gjIYTxUIHdRtnG4GQMbK/I7/xZBQEM6AiyWlRKjcFVlMH73aDmwkREv86hSvMyAciu1
         bQpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dihptPS7qzTnzYasf9qJX5UUwlifJwjKMMIJAa9qbkg=;
        b=O7yADXE430yM62LV6JLPqyjaJYXbsqDx+SYVKwnctgKNYMkr/3hHgYE3v8X+bJbhSg
         UV+qnNyZmWIQW/+Ktv2hDTDpQf4Vcoi/iYldz81Nn0ATYW13qq7C09lbKq6cemMA9k6Q
         gooq4PuPHBgp6e8BhEyKqO50vwKcWVeeowKTx/XagFxyNW9WriEvzLaak1j8cB9XuLlX
         QvSBE4qycpOd+An9rd+gkrLDpqBhrRvzMq/ZQlSFtISDeH0w8vWk5BByKH3MpZ086Rrk
         XddUyjjEkEsyDxJ6r9ccsIPefByxNIB0VQLG4wJL2O3ifaVUTGWR4GJ2lpSPZCCLlx39
         fkcQ==
X-Gm-Message-State: APjAAAWCLOa5JMZ7vk2x3UQUNIsLalJnizq1N38dMVTv0atRUX9h6aDv
        37lnHFbA/ASOHDIGJKQVFAlYZ4OGiLvmrtbRX7T8tver
X-Google-Smtp-Source: APXvYqy500zJ4j1LOOlOaNqgPseB2abt4DBG0wllsYtYVFibrfS5PRu3PRIAbQd/8KXQWLN/83+lgTY40S55ImH0jQY=
X-Received: by 2002:a67:d00d:: with SMTP id r13mr61279835vsi.100.1564122932507;
 Thu, 25 Jul 2019 23:35:32 -0700 (PDT)
MIME-Version: 1.0
From:   Mike <1100100@gmail.com>
Date:   Fri, 26 Jul 2019 02:35:21 -0400
Message-ID: <CAECVvTXrwhpjtHpXFv8m_EmcNT286nvZU5Gk_k5DGJyNbbM7VA@mail.gmail.com>
Subject: make && make install bcachefs-tools errors
To:     linux-bcache@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hello bcachefs,

My first attempt at installing/configuring the filesystem on CentOS 7
and it appears the tools install is throwing a few warnings and
errors.  Can anyone confirm whether the errors indicate the install is
broken; or, are the errors non-critical?

Thanks for your help.

~# make && make install
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Iraid -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DZSTD_STATIC_LINKING_ONLY
-DNO_BCACHEFS_CHARDEV -DNO_BCACHEFS_FS -DNO_BCACHEFS_SYSFS
-DVERSION_STRING=3D'"v0.1-72-g692eadd"'  -Wno-unused-but-set-variable
-I/usr/include/blkid -I/usr/include/uuid     -c -o crypto.o crypto.c
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Iraid -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DZSTD_STATIC_LINKING_ONLY
-DNO_BCACHEFS_CHARDEV -DNO_BCACHEFS_FS -DNO_BCACHEFS_SYSFS
-DVERSION_STRING=3D'"v0.1-72-g692eadd"'  -Wno-unused-but-set-variable
-I/usr/include/blkid -I/usr/include/uuid     -c -o libbcachefs.o
libbcachefs.c
libbcachefs.c: In function =E2=80=98bch2_super_write=E2=80=99:
libbcachefs.c:315:9: warning: missing braces around initializer
[-Wmissing-braces]
  struct nonce nonce =3D { 0 };
         ^
libbcachefs.c:315:9: warning: (near initialization for =E2=80=98nonce.d=E2=
=80=99)
[-Wmissing-braces]
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Iraid -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DZSTD_STATIC_LINKING_ONLY
-DNO_BCACHEFS_CHARDEV -DNO_BCACHEFS_FS -DNO_BCACHEFS_SYSFS
-DVERSION_STRING=3D'"v0.1-72-g692eadd"'  -Wno-unused-but-set-variable
-I/usr/include/blkid -I/usr/include/uuid     -c -o libbcachefs/acl.o
libbcachefs/acl.c
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Iraid -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DZSTD_STATIC_LINKING_ONLY
-DNO_BCACHEFS_CHARDEV -DNO_BCACHEFS_FS -DNO_BCACHEFS_SYSFS
-DVERSION_STRING=3D'"v0.1-72-g692eadd"'  -Wno-unused-but-set-variable
-I/usr/include/blkid -I/usr/include/uuid     -c -o
libbcachefs/alloc_background.o libbcachefs/alloc_background.c
cc -std=3Dgnu89 -O2 -g -MMD -Wall -Wno-pointer-sign -fno-strict-aliasing
-I. -Iinclude -Iraid -D_FILE_OFFSET_BITS=3D64 -D_GNU_SOURCE
-D_LGPL_SOURCE -DRCU_MEMBARRIER -DZSTD_STATIC_LINKING_ONLY
-DNO_BCACHEFS_CHARDEV -DNO_BCACHEFS_FS -DNO_BCACHEFS_SYSFS
-DVERSION_STRING=3D'"v0.1-72-g692eadd"'  -Wno-unused-but-set-variable
-I/usr/include/blkid -I/usr/include/uuid     -c -o
libbcachefs/alloc_foreground.o libbcachefs/alloc_foreground.c
libbcachefs/alloc_foreground.c: In function =E2=80=98__writepoint_find=E2=
=80=99:
libbcachefs/alloc_foreground.c:746:2: warning: implicit declaration of
function =E2=80=98cds_hlist_for_each_entry_rcu_2=E2=80=99
[-Wimplicit-function-declaration]
  hlist_for_each_entry_rcu(wp, head, node)
  ^
libbcachefs/alloc_foreground.c:746:37: error: =E2=80=98node=E2=80=99 undecl=
ared (first
use in this function)
  hlist_for_each_entry_rcu(wp, head, node)
                                     ^
libbcachefs/alloc_foreground.c:746:37: note: each undeclared
identifier is reported only once for each function it appears in
libbcachefs/alloc_foreground.c:747:3: error: expected =E2=80=98;=E2=80=99 b=
efore =E2=80=98if=E2=80=99
   if (wp->write_point =3D=3D write_point)
   ^
make: *** [libbcachefs/alloc_foreground.o] Error 1
