Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB44C3757D2
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 17:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhEFPrM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 May 2021 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhEFPrL (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 May 2021 11:47:11 -0400
Received: from polaris.dblsaiko.net (polaris.dblsaiko.net [IPv6:2a01:4f9:c010:c011::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9B8C061574
        for <linux-bcache@vger.kernel.org>; Thu,  6 May 2021 08:46:13 -0700 (PDT)
Received: from invader.localnet (p200300D3870ff4007799D4fCc5f4C978.dip0.t-ipconnect.de [IPv6:2003:d3:870f:f400:7799:d4fc:c5f4:c978])
        by polaris.dblsaiko.net (Postfix) with ESMTPSA id B13207F4BF;
        Thu,  6 May 2021 17:40:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dblsaiko.net;
        s=dkim; t=1620315618;
        bh=FMvOItwWyfqz3ENsdNme9UjmUccfuVTIPjxCfFLD000=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=T9HaIQCIv0Q/ue3HteUvtj/ZLZi472HOYU6ibtZ8KvgtCa2KGMGpWAZWhEEnzVsyD
         6H11IYyTfvbZ6FirfMCvgURDohqMaa/dO4NhYHdI75V/d7XvY9rNlkevzB5CkWqw9E
         ecMIBzAsvGQgoG2hug29r7iZpKRzXk4Uwqf6LkJWso/Hmyf8vxx625WNFpehaolH7p
         jenuCcRDcyj3iX3Y+Sk5/e8V2vZRFc7goh5bBkkcJD6jLZ+7n0YPues+vCDPJrJu9d
         ceAjiMrDaZj4VK0hizR/ZEpEQ4xN0Sb5WGwI2TJPcMJKOgt4wGJjFeHeYIWUb3YHtp
         HgQWneYtjz2xQ==
From:   Marco Rebhan <me@dblsaiko.net>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date:   Thu, 06 May 2021 17:46:07 +0200
Message-ID: <2209740.ElGaqSPkdT@invader>
In-Reply-To: <4b6c9608-84e9-e20b-ac84-c4fd0a536f29@suse.de>
References: <5607192.MhkbZ0Pkbq@invader> <1783900.tdWV9SEqCh@invader> <4b6c9608-84e9-e20b-ac84-c4fd0a536f29@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4633445.GXAFRqVoOG"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

--nextPart4633445.GXAFRqVoOG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Marco Rebhan <me@dblsaiko.net>
To: Coly Li <colyli@suse.de>
Cc: linux-bcache@vger.kernel.org, victor@westerhu.is
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
Date: Thu, 06 May 2021 17:46:07 +0200
Message-ID: <2209740.ElGaqSPkdT@invader>
In-Reply-To: <4b6c9608-84e9-e20b-ac84-c4fd0a536f29@suse.de>
References: <5607192.MhkbZ0Pkbq@invader> <1783900.tdWV9SEqCh@invader> <4b6c9608-84e9-e20b-ac84-c4fd0a536f29@suse.de>

On Thursday, 6 May 2021 12:04:00 CEST Coly Li wrote:
> Before 5.12, the allocation failure returns a NULL pointer, so such
> issue was hidden. I will post a quick fix to emulate previous code
> logic without bothering bio_alloc_bioset().

Ah, I see. I guess that means then I can actually use this patch until 
that fix is mainlined :)

> Thanks for the quick test and verification.

Glad to help!

Thanks,
Marco
--nextPart4633445.GXAFRqVoOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUuA5X09baU5GfLYxyND744GinTYFAmCUDz8ACgkQyND744Gi
nTZTow/+OvXrBlHJTIynhpqvtmFYKtIyUvXMSFiNsPDalOyuHFf6QIsHvIOGnI9b
Rtazi1nNnY2lXZtqIAMctMdbbYsEmT4yRnBxGBACxjvbUqx0/WQ4hY8M2/KrlsJJ
SAAyn77oxGD43Fiw30c5ntstCDS6RK5pQNqH9xWEcm1mYBeRE0jh88DhnWcXaxrX
X3e7PynDYp7abZAcIPEPzHrvuSMAEpujqz2nxYmwkMOQ+FDHvMjrxU3pnc7iUWFl
JKmbWLOXUPh/3us95GAlIHlXDZWF0OUmkpaqeitlG1iei5OGuobSzoO3ToGemasj
mxboIafIKePbKFaFJwp1uyQrNAJoHIBFlCvgJ1xfxQ/VngSwgb6S93vJj9wHu3TS
+eokA91MRwR+24QGNldsd7Mcj+rQrgEBBDtjD5NTnaoQjBcKXR7ENUf4tsHULM/Y
+XNRGX6JadXv0UpJgJtxf3Kxd9iSpYMLUdV5iCG6hK/FW7kxwB1WvVKc5W6jfaxS
NbyqXXVpFAuAqxpOjbNHlDz9eXOCOf0Ycj8CPa6txC1TAq1FAKkJCMnq0oyACwJ2
DidPpuFD/Y2Wht4KC7nTP9R+h3i1EaN83I9WxjLf0+CYhTA5HdYZbfX5R2nWQ7px
tLoX0DfThjcQd4fwPvz/NVI8JJN8CQf+Xs0KDwfDpDsRAwo2PoE=
=eU18
-----END PGP SIGNATURE-----

--nextPart4633445.GXAFRqVoOG--



