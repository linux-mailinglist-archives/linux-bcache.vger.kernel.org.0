Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D368A37503B
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 09:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbhEFHhP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 May 2021 03:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhEFHhO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 May 2021 03:37:14 -0400
Received: from polaris.dblsaiko.net (polaris.dblsaiko.net [IPv6:2a01:4f9:c010:c011::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD2C061574
        for <linux-bcache@vger.kernel.org>; Thu,  6 May 2021 00:36:16 -0700 (PDT)
Received: from invader.localnet (p200300D3870Ff4007799d4FCc5f4C978.dip0.t-ipconnect.de [IPv6:2003:d3:870f:f400:7799:d4fc:c5f4:c978])
        by polaris.dblsaiko.net (Postfix) with ESMTPSA id 7FFAE7F4BF;
        Thu,  6 May 2021 09:30:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dblsaiko.net;
        s=dkim; t=1620286223;
        bh=/J48kgPnd8jlRm0kdHhropv0QbB8zT45Ep0bQtOQjCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=qaAtX5aIv/c0DAFeqc+iNfLkf0ioJ7E556GJMu/wbM31+YI3ENoUvfkGrzMMPk9af
         qgl+sidct8dcojmBrCd4Y0HU8bYV6MuWPRpe6HDWb9/b5wAzU+pAM7y8eXujlaK8ZQ
         GCwgT3d6txIQ82ImqZHEIXuqTnTY6PgRgXa7PdjhLBlzJXarNeCjV9f16XY6k44kRD
         Qs2miUF2AJPdJLooGHORllqDEcASj/rabFRFvb2M0d6QgDhUJWXyZN8LDk7N6EK33L
         byaJWKwRrNbzCHQ6o1lkoUF9wgAEKH6ZXah7nMTkSoHwFni26N9XQyFUwNF/EnBWBo
         /wFmVnfm/J+wQ==
From:   Marco Rebhan <me@dblsaiko.net>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date:   Thu, 06 May 2021 09:36:13 +0200
Message-ID: <1783900.tdWV9SEqCh@invader>
In-Reply-To: <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de>
References: <5607192.MhkbZ0Pkbq@invader> <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2064133.irdbgypaU6"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--nextPart2064133.irdbgypaU6
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Marco Rebhan <me@dblsaiko.net>
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date: Thu, 06 May 2021 09:36:13 +0200
Message-ID: <1783900.tdWV9SEqCh@invader>
In-Reply-To: <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de>
References: <5607192.MhkbZ0Pkbq@invader> <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de>

On Thursday, 6 May 2021 04:50:06 CEST Coly Li wrote:
> Could you please try the attached patch ?  If a suspicious bio
> allocation happens, this patch will print out a warning kernel message
> and avoid the BUG() panic.

Looks like the patch works. Here's a dmesg log that comes from starting
up a game with a bunch of large files (which I'm guessing are what
makes this happen more often?)

[   39.284230] bcache: cached_dev_cache_miss() inserting bio is too large: 344 iovecs, not intsert.
[   65.415896] bcache: cached_dev_cache_miss() inserting bio is too large: 282 iovecs, not intsert.
[   65.446327] bcache: cached_dev_cache_miss() inserting bio is too large: 946 iovecs, not intsert.
[   88.116826] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
[   88.957691] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
[   89.020544] bcache: cached_dev_cache_miss() inserting bio is too large: 332 iovecs, not intsert.
[   90.531875] bcache: cached_dev_cache_miss() inserting bio is too large: 261 iovecs, not intsert.
[  111.464124] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
[  111.497049] bcache: cached_dev_cache_miss() inserting bio is too large: 262 iovecs, not intsert.
[  111.638928] bcache: cached_dev_cache_miss() inserting bio is too large: 318 iovecs, not intsert.
[  155.884142] bcache: cached_dev_cache_miss() inserting bio is too large: 447 iovecs, not intsert.
[  156.146070] bcache: cached_dev_cache_miss() inserting bio is too large: 512 iovecs, not intsert.
[  156.223795] bcache: cached_dev_cache_miss() inserting bio is too large: 277 iovecs, not intsert.
[  156.326145] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
[  156.602906] bcache: cached_dev_cache_miss() inserting bio is too large: 290 iovecs, not intsert.
[  156.646365] bcache: cached_dev_cache_miss() inserting bio is too large: 341 iovecs, not intsert.
[  156.671285] bcache: cached_dev_cache_miss() inserting bio is too large: 501 iovecs, not intsert.
[  157.216087] bcache: cached_dev_cache_miss() inserting bio is too large: 258 iovecs, not intsert.
[  165.010961] bcache: cached_dev_cache_miss() inserting bio is too large: 413 iovecs, not intsert.
[  165.386483] bcache: cached_dev_cache_miss() inserting bio is too large: 260 iovecs, not intsert.

Thanks,
Marco
--nextPart2064133.irdbgypaU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUuA5X09baU5GfLYxyND744GinTYFAmCTnG0ACgkQyND744Gi
nTb2NRAArwgIa7RkDDoJBf59NWmxFxmiLh9GqCVieUdlEPO149K+BzFtZj1vKWwM
HlEYE/EiRTrNjSRRJuz4qsAjSc/kofdngu88EEVN6P9lxU969xiZ2v8OrFpauXEK
E1bzppQDG4EZKk/pF8y5gosjOh+TPHFWx6imz0m60QtjCwaNO53lYcyWZGUWoOKA
Rx+8xD8zQAVsXS2AMwSjwuhF7XNuJ3BapnDI0wllOVpGysvYi59eBvdN5o5IubQJ
NP5Za+YMCwMYo7h5KCGfTvRti8eHtif7MhUphiX9bgoK1iiXaZrzxKzoD+A0qz6x
6tshoPUaMxcZekmGxmUvuaCWCPr98ub1PI1mGbqQWrtP+aW23zU1ubgD0x1UZNaV
96qaVaGYsXpGKRE1S0oq1JRF+foBVOO4HjdhaGofEyRb276ABiYnac7IIRWxAeNi
TJ6i1ymNMYs90dpEz89x+yHyzK4plr/3Yygph137msr2VMfW+iL9FfbE6kgmEAh5
AoBmRMaABbC84Q7fgx37VfQtgpjpo1/PsVu8It8LZhKNkhtwWwiIiNhFr/a2B8az
rg+iv6j12/HMROFz7m4GEIyoeP8zXvlutohM+qz8SDZs6JOhFcfJjJgH9oRqqqCR
Z7Fv7Lg2bMDErUAOvXssjKy2YPKQfLbHss2kwiS43kzHg+j0Mc0=
=mQ/K
-----END PGP SIGNATURE-----

--nextPart2064133.irdbgypaU6--



