Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3034CDB2CE
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Oct 2019 18:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503053AbfJQQv3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Oct 2019 12:51:29 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:25448 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503041AbfJQQv3 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Oct 2019 12:51:29 -0400
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Oct 2019 12:51:27 EDT
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 6D482547624;
        Thu, 17 Oct 2019 12:43:45 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 1109560B02D;
        Thu, 17 Oct 2019 12:43:44 -0400 (EDT)
Date:   Thu, 17 Oct 2019 18:43:50 +0200
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Teodor Milkov <tm@del.bg>
Cc:     linux-bcache@vger.kernel.org
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
Message-ID: <20191017184350.19def760@harpe.intellique.com>
In-Reply-To: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/as4jUp=agqAIJzd44N8v/nu"; protocol="application/pgp-signature"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--Sig_/as4jUp=agqAIJzd44N8v/nu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 17 Oct 2019 18:21:24 +0300
Teodor Milkov <tm@del.bg> =C3=A9crivait:

> Hello,
>=20
> I've tried using bcache with a large 6.4TB NVMe device, but found it=20
> takes long time to register after clean reboot -- around 10 minutes.=20
> That's even with idle machine reboot.
>=20
> Things look like this soon after reboot:
>=20
> root@node420:~# ps axuww |grep md12
> root=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 9768 88.1=C2=A0 0.0=C2=A0=C2=A0 2268=
=C2=A0=C2=A0 744 pts/0=C2=A0=C2=A0=C2=A0 D+=C2=A0=C2=A0 16:20 0:25=20
> /lib/udev/bcache-register /dev/md12
>=20
>=20
> Device=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
r/s=C2=A0=C2=A0=C2=A0=C2=A0 w/s=C2=A0=C2=A0=C2=A0=C2=A0 rMB/s=C2=A0=C2=A0=
=C2=A0=C2=A0 wMB/s rrqm/s=C2=A0=C2=A0 wrqm/s=C2=A0=20
> %rrqm=C2=A0 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz=C2=A0 svctm=C2=
=A0 %util
> nvme0n1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 420.00=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 52.50=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00 0=
.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00
> 0.00 0.00=C2=A0=C2=A0=C2=A0 0.30=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 1.04=
=C2=A0=C2=A0 128.00 0.00=C2=A0=C2=A0 2.38=C2=A0 99.87
> nvme1n1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 417.67=C2=A0=C2=A0=C2=
=A0 0.00=C2=A0=C2=A0=C2=A0=C2=A0 52.21=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.00 0=
.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00
> 0.00 0.00=C2=A0=C2=A0=C2=A0 0.30=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 1.03=
=C2=A0=C2=A0 128.00 0.00=C2=A0=C2=A0 2.39 100.00
> md12=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 838.00=
=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 104.75=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 0.00 0.00=C2=A0=C2=A0=C2=A0=C2=A0 0.00
> 0.00 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00=
=C2=A0=C2=A0 128.00 0.00=C2=A0=C2=A0 0.00=C2=A0=C2=A0 0.00
>=20
> As you can see nvme1n1, which is Micron 9200, is reading with the
> humble 52MB/s (417r/s), and that is very far bellow it's capabilities
> of 3500MB/s & 840K IOPS.
>=20
> At the same time it seems like the bcache-register process is
> saturating the CPU core it's running on, so maybe that's the
> bottleneck?
>=20
> Tested with kernels 4.9 and 4.19.
>=20
> 1. Is this current state of affairs -- i.e. this known/expected=20
> behaviour with such a large cache?
>=20
> 2. If this isn't expected -- any ideas how to debug or fix it?
>=20
> 3. What is max recommended cache size?

I can't say anything of much help, but a few months ago when I tried
adding a 800 GB NVMe drive as a cache, I had to drop it after a loooong
wait for initialisation, with the same problem as you had: very little
IO on the NVMe drive, one core at 100%, and initialisation actually (as
far as I can tell) never ends.

My bet is that there's some overflow/math error that prevents bcache to
work properly with large caches. That's a pity because new NVMe SSDs
are quite cheap.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/as4jUp=agqAIJzd44N8v/nu
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl2omkYACgkQX3jQXNUicVaeLwCg2hHdDqvM+z/KaQZFmWDAt42h
cYwAoPm/dOUlet57M3Dac7PjDAZ6LUGt
=WHO5
-----END PGP SIGNATURE-----

--Sig_/as4jUp=agqAIJzd44N8v/nu--
