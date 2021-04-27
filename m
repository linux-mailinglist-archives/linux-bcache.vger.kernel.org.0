Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EABE36CB76
	for <lists+linux-bcache@lfdr.de>; Tue, 27 Apr 2021 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbhD0THv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 27 Apr 2021 15:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhD0THv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 27 Apr 2021 15:07:51 -0400
X-Greylist: delayed 580 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Apr 2021 12:07:07 PDT
Received: from polaris.dblsaiko.net (polaris.dblsaiko.net [IPv6:2a01:4f9:c010:c011::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED73C061574
        for <linux-bcache@vger.kernel.org>; Tue, 27 Apr 2021 12:07:06 -0700 (PDT)
Received: from invader.localnet (p200300d387210900bd065Fb0a571C560.dip0.t-ipconnect.de [IPv6:2003:d3:8721:900:bd06:5fb0:a571:c560])
        by polaris.dblsaiko.net (Postfix) with ESMTPSA id 16BA47F7EB;
        Tue, 27 Apr 2021 20:52:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dblsaiko.net;
        s=dkim; t=1619549540;
        bh=Rw7eTuHf57Krt+czXZkpjfbtf+WJeGw+oohuhoqP1bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To;
        b=VudfA7nODvL4XR9yYxEBj/il3hSSm27Foxov4etktWB0zeuf0Qksz3e8dL9qZrF2J
         sznweidRgJqt3SRIxyGty9Sn39BJDpEjEpIUE+5lwqftBzvhGKLjtr22E/fAR1wn6/
         fMFaZ+ltKJgrluVfM1KqJHUE3XeQu3+zDNUE+z+jpyAJuCWfoqUf7HmAoGJZg+xtGy
         aMmZzGpqUsvJ/OOPZlHeXJpjaVk0o9aqMVcc2lLJKh9fch957juXllwzxoOg2VMI+U
         4Qix3OQRm6HLpdRqHWbJxDgOxQ+A2OYEK1pW6WyMGVmQXrsD2mAHjpLx1Y+vsU5+F6
         BeXS6pwW0SuZw==
From:   Marco Rebhan <me@dblsaiko.net>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date:   Tue, 27 Apr 2021 20:57:07 +0200
Message-ID: <5607192.MhkbZ0Pkbq@invader>
In-Reply-To: <210bc2f6-32c6-be3e-1c9a-40f635ba4580@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1692004.VLH7GnMWUR"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--nextPart1692004.VLH7GnMWUR
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Marco Rebhan <me@dblsaiko.net>
To: colyli@suse.de
Cc: linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date: Tue, 27 Apr 2021 20:57:07 +0200
Message-ID: <5607192.MhkbZ0Pkbq@invader>
In-Reply-To: <210bc2f6-32c6-be3e-1c9a-40f635ba4580@suse.de>

Hi,

I'm getting the same issue on kernel 5.12.0 after upgrading from 
5.11.16. For me, so far the error always occurs a short while after 
boot.

> Could you please help to apply a debug patch and gather some debug 
> information when it reproduces ?

I could do that as well, which patch should I apply?

Thanks,
Marco
--nextPart1692004.VLH7GnMWUR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUuA5X09baU5GfLYxyND744GinTYFAmCIXoMACgkQyND744Gi
nTa5Zw/+PGPdmx7X62hxgqZM1Aqysq2kU2YE2fbqU0FGnAz3l4PDm9aDLcuoLRia
jUr8HxT6y4tZcdBEaSXzyufGJLSmujtBDWaltmik0TqqpfBQI2l/kQI/zLsF0wm5
wFCYHViz8JqTHyPy/MmFv+nZJUT8nn8MMYXcw+kWBhcg6f86c7u8Lod+vaS1Dozd
MOUjNC0ALoXnuIjXwjvHHZwvVcdzQZuAosQgnFNKbjXB3LrN8BTEfpYMd/tTFcOr
oG43xQEBR5we2z6XDgAgiP6u3ziVXbMPH4+8HWbXV3zWsSOWxlHmBvbHecrYn7DR
Jmi0FRcUlb7veG+ViOlDaDu9BxFq6/cNAVDrYnkiRsoP288H/c+hhReqNZt2POR4
HwQVTfQKFzXMprBDYS6IcOmbIJ6AGH+f2gC6pI4d2ytFCYWuLtv0TtgVEr8k+5BI
+wBS81nz9vitgvmjAtWUxRV43k+pzZN6se9LMbsKpXc8u/LYP4Sy+YaUglhMArKw
Cx08y3kOrWP2dDOxnpLBvhzvC3lhWWMnT00EmtofamPGxpTCxPEkGX6m34yif7Kr
3z2ZizJV5XafDYiW2YMWsNXVqTl+aPM0mOoaWgErIOqqMBHEbIXXndBHTzUvI6FW
21mh+yskm1/gcDSEHlwae267uh240AaYR/FrXN1DZBwCbiVx/rw=
=A0Tw
-----END PGP SIGNATURE-----

--nextPart1692004.VLH7GnMWUR--



