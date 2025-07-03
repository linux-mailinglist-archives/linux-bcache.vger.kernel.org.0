Return-Path: <linux-bcache+bounces-1155-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B7269AF7FE7
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jul 2025 20:24:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AFE41888500
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jul 2025 18:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1680D2F5C52;
	Thu,  3 Jul 2025 18:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="KwjzmyrN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77732F5473;
	Thu,  3 Jul 2025 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751566883; cv=none; b=QvTD3IcpOgFXFNbvqCVZSMfg7EM8nwwiWErMZXKopuHm2/g0Cnw6fNGA1+6N91eHkfHT6Y0NQhL2fHWZ0GdzYRtwmBfLhor4IAuPlAVsHZOhdqnzUQxhYMkJ8XLqTPl6sk3W6lSqPcR/4Im2zfV4I0PiVThRNfwT1P27IKNpF4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751566883; c=relaxed/simple;
	bh=3iACZNAuN9nKVxr6mJF18JcL732AdKXi3lsmFG3/zmo=;
	h=Date:From:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EGN7agZx0ElMi/yQ3ioUBcFG6plFUhqyF3XDEKomoH3dgphrbTcD8Ys3Kwgw5QGTCB2p7GGtN30GQpti5WAJe77NHJ8pe9HdyJoXZ5TGMMZ2J+qCColK8b0AChqPP0J8P+Lz8xdNmh0kPW0mFBAZ4HLT9OjfxZxRqPp1eYeSjfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=KwjzmyrN; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1751566878;
	bh=3iACZNAuN9nKVxr6mJF18JcL732AdKXi3lsmFG3/zmo=;
	h=Date:From:Cc:Subject:From;
	b=KwjzmyrNdvojjc0FcGCE4iEx2w6ieVuZpIDxq20ZnVErb15tistzsPmUQSFb6yzwD
	 SxSzrBdMgDP3qVCHxyNglGpZb4uM6fNg6XdFm3OMaXVtyW4XKldDhE+L/Mvq41GnJm
	 AGDoOm9Y/seeIENghfba7IEm5OhawmuL/CJUC6ZCWjylw7sGfcRNSKhGwxSjEWcql3
	 u2uSJvQ9j/SObFBbxcGFWPRUqGL4qGB2FbMrcK4WIwnBsJK8voDIjQPxFJsiM14DjX
	 oemdUoREirEX9UQqjtFmoXD0yqiDPkKHvHpsG4Jvxnu64VN2TqmAmsjzbgmgNYuiC+
	 7ms5vSygZ3n6A==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id DA6826B6;
	Thu,  3 Jul 2025 20:21:18 +0200 (CEST)
Date: Thu, 3 Jul 2025 20:21:18 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Coly Li <colyli@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcache: fix "for/take a while" typos
Message-ID: <vabrss3eucpl4xhvyrqflqj4rgtpzhv76wjtlqldlafdonkgjr@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4ylhdbo5nsuet76i"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--4ylhdbo5nsuet76i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
v1: https://lore.kernel.org/lkml/h2ieddqja5jfrnuh3mvlxt6njrvp352t5rfzp2cvnr=
ufop6tch@tarta.nabijaczleweli.xyz/t/#u

 drivers/md/bcache/bcache.h  | 2 +-
 drivers/md/bcache/request.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d33e40d26ea..7318d9800370 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -499,7 +499,7 @@ struct gc_stat {
  * won't automatically reattach).
  *
  * CACHE_SET_STOPPING always gets set first when we're closing down a cach=
e set;
- * we'll continue to run normally for awhile with CACHE_SET_STOPPING set (=
i.e.
+ * we'll continue to run normally for a while with CACHE_SET_STOPPING set =
(i.e.
  * flushing dirty data).
  *
  * CACHE_SET_RUNNING means all cache devices have been registered and jour=
nal
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..87b4341cb42c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -257,7 +257,7 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
=20
 	/*
 	 * But if it's not a writeback write we'd rather just bail out if
-	 * there aren't any buckets ready to write to - it might take awhile and
+	 * there aren't any buckets ready to write to - it might take a while and
 	 * we might be starving btree writes for gc or something.
 	 */
=20
--=20
2.39.5

--4ylhdbo5nsuet76i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmhmyh4ACgkQvP0LAY0m
WPFb/RAAhUaZGYwDjdqRoAqZ4TvfB2hAZg6+r8naz2z9DlDKdiucWHCfxZ8j/CR8
OuVvLwMIQkh2KCkNMCcBJ51T9J1AaZ6UM3B56Hf3v9u9wElZPXMv27o9lzc9fZJq
ypB61rP0y5vtdCVzQmbIlYtrxrPsRzq9U8GdrmrK8uGqTQPb0O9F/G5HTjet2pcc
jGcADzjMrAcFiro3Ziqt3rCOwK61Cr7CYwhOPbG+6EkhpqUBIb+OhrpCJdSsoAaN
yJemqHbaZruMcPJc4ffMMynsYski334LEDmSlu+VurnUCW9lnFgULDqHUCFbYKzn
Vfe1sGzc/LQk9l12ewpWc+koL8RtCBq10vdY3zR5xoZsam3Lp8O+x/VPH3rhQXJ+
aR39gT5gaRNfhPPRUtDIxWJfRF27oQ0Vq13Gv9qMzKkUvMJXwOtkrwW2bEMMFXZq
HYERpHtdTsbcsrmFVSd1MNQRZrO6kjcqk08VNWEGCryrNyAjcWBd3krCFH1a75/a
xnWti6sLbSDVOoJgZgFZQT/Z3JEVAZW/2x7UInS/6Kd0nixcc9nXOTMKW6+D70WQ
hwBgxqD/sq7+NTxT7imQwL1gtLz4KOkFYF6T/5P9dpArI9HCndRrefqFskZcIzX6
AP/pieZyhqKsQBJVEv1g5Z61MYwBL7UIXGFVUGexM8ohsuOELuY=
=X+wZ
-----END PGP SIGNATURE-----

--4ylhdbo5nsuet76i--

