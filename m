Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF623E08B6
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Oct 2019 18:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729666AbfJVQXi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Oct 2019 12:23:38 -0400
Received: from mail1.g1.pair.com ([66.39.3.162]:17020 "EHLO mail1.g1.pair.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731132AbfJVQXh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Oct 2019 12:23:37 -0400
Received: from mail1.g1.pair.com (localhost [127.0.0.1])
        by mail1.g1.pair.com (Postfix) with ESMTP id 0A7DD54744A;
        Tue, 22 Oct 2019 12:23:37 -0400 (EDT)
Received: from harpe.intellique.com (labo.djinux.com [82.225.196.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail1.g1.pair.com (Postfix) with ESMTPSA id 6CB1360B032;
        Tue, 22 Oct 2019 12:23:36 -0400 (EDT)
Date:   Tue, 22 Oct 2019 18:23:41 +0200
From:   Emmanuel Florac <eflorac@intellique.com>
To:     Coly Li <colyli@suse.de>
Cc:     Teodor Milkov <tm@del.bg>, linux-bcache@vger.kernel.org
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
Message-ID: <20191022182341.58739ca5@harpe.intellique.com>
In-Reply-To: <224a181d-06a6-2517-865d-c71595487187@suse.de>
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
        <224a181d-06a6-2517-865d-c71595487187@suse.de>
Organization: Intellique
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/s45qbEvwmyOluiMyTjw+WMZ"; protocol="application/pgp-signature"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--Sig_/s45qbEvwmyOluiMyTjw+WMZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Sun, 20 Oct 2019 14:34:25 +0800
Coly Li <colyli@suse.de> =C3=A9crivait:

> So far we only have a single B+tree to contain and index all bkeys. If
> the cached data is large, this could be slow. So I suggest to create
> more partition and make individual cache set on each partition. In my
> personal testing, I suggest the maximum cache set size as 2-4TB.

Urgh. 2/4 TB is the size of common SSDs nowadays. A good use case for
bcache would be caching a 100 TB RAID array with a couple of TB of
SSDs. Too bad I have to fallback on using LVM cache instead.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/s45qbEvwmyOluiMyTjw+WMZ
Content-Type: application/pgp-signature
Content-Description: Signature digitale OpenPGP

-----BEGIN PGP SIGNATURE-----

iEYEARECAAYFAl2vLQ0ACgkQX3jQXNUicVZp2QCgtjT+HcqNpb1dCf30N1ukDP3h
s74AoO74xv5GUr9VUmuqUH3bJBbdQub3
=Fo7m
-----END PGP SIGNATURE-----

--Sig_/s45qbEvwmyOluiMyTjw+WMZ--
