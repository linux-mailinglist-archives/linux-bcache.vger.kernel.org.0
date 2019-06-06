Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74351373AC
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jun 2019 13:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfFFL7M (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jun 2019 07:59:12 -0400
Received: from mout.gmx.net ([212.227.15.15]:56449 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbfFFL7L (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jun 2019 07:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1559822349;
        bh=MC2UyKkDsv5O+C/MCxJC/h3GUFah0HD8zVpHVApl1GQ=;
        h=X-UI-Sender-Class:Subject:From:To:In-Reply-To:References:Date;
        b=M9yfivhb4XMYuADhYJifRU6YH26g4YxnMNQFPZZbCffXhpybcuIz1YyYnAryhU3rp
         vns6Uu/3q1uHKAJps5V82/sWxQqFB0ThRVxUIhQ3+YeUWbvobGDhuh8kMwQ/D29mN5
         CP57DRxTLkwjCRF47D4I8fC/mf0XuHnS/BCmWtH4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([94.79.149.170]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MAgvb-1hOB0g0RJb-00BtZk; Thu, 06
 Jun 2019 13:59:09 +0200
Message-ID: <27c86f7bc6d3be1cd9502d32f7c3eb91cf08acc9.camel@gmx.de>
Subject: Re: bcache corrupted cache
From:   Massimo Burcheri <massimo.burcheri@gmx.de>
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
In-Reply-To: <f92ff036-5d97-0934-7c5d-0348840c67da@suse.de>
References: <05050ff38ce81f5aa3be938d5bff5b83bd7171e4.camel@gmx.de>
         <f92ff036-5d97-0934-7c5d-0348840c67da@suse.de>
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAA3NCSVQICAjb4U/gAAAABlBMVEX///8AAABVwtN+AAAACXBIWXMAAA7EAAAOxAGVKw4bAAABGUlEQVQYlUWQsUoDQRCGv71LjB7KSSBwwZCTgFhY2EYIHmJnZRMLo5AXUMRCBMHcE6iPoGBlINpoZXGVeQTFKqSxMgYtTBFcZw7EKfZn2Z2Z7//hr2ysZ+5tqFLmWKVaKKs0vWd9TJx2AibmoQcupj6CCZirqTgzA5hmsdtQWe5/xAREX7uJ3MLP9x4lyieNO5mcOxyM8HH79y/4Cdn9R3JDsts/uGO82yOMJf/ah1Y8tfQEIQt7Z7rCawtNiUpHFgYUdgTxgI1NAW6SvxoqWabbw0Bd5jpQibTNBC1F4nIMk2TWhTqIs+fSVpzfCsVR9eaiJf5W6mtWXK7O+vKR4nWkSYSuFbP4No3Ht6dpSN9pSMYmaXI1/usXT0FM3SoTKAAAAAAASUVORK5CYII=
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-EW3wbWkpAFzaI/6e7XG/"
Date:   Thu, 06 Jun 2019 13:54:08 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 
X-Provags-ID: V03:K1:TLmfFylWhh8JIcVyAptB7Hew/DBJCIjOpBBrSrsiT02J1/x98h9
 Etr420TQevE8pSGF9nK4sQO2WH4GgTvdyDn7H6iRCmQGi7UligNvZB5lx2E0fN3owPB8mEL
 0TI/H+8ZMORnt1ciqmlufQzijtCl8ZKjHvFu0o5rRanm3S4n/Q/vexgTJzO7E9a4mUvK+LY
 HFrNui2KSPVQDciZxZ+Cg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xI0V0QqUi3c=:uq+DxrtqsGlrBjIS0kWyZc
 MPH0iFmxxJN5ZnKGQzXuy0ig2syuYxSXy4/kHxltbsB6W8+vV9ltzlO6nVKlRk97l4Sbt1Z+H
 igHORY876DuyOMSipIWVHsCtdO4jJ1hAx53kG81aG3zx9hBMuWrQMKw8Vg3U2tDeVZMpOFoJT
 S4t2ZU/kfz+lbNKCfLhpVttoagZBhWNaa9Xr0M2YTReZWruykwdYE7jt37Fm6PT1rbrtPkGKH
 hTLx0xvsl9gqCPm/IDmUSRS1AynDV3JSYuRq5+3VooKATacJyTBmqruT6DuIBNDHktonM/r6V
 CKqMtGTazYXverOXQy0wNLl+YPBdcAT4qHQuM9wZhacHQAvptdvpjyeusIa8eyku62NKraX7a
 L2rwnGVWq1nhMDxVTrOyW3Hw5NegVCQGAtNrPPnNo935zMGiHdmy1sguAJccWARLPH+wIK8Ru
 PrwcMqRdI9hfstYbHmzfvR5bNJB7ziLZwWYZOXtbaalv75RKlPWsgHfihKTUNflO7/6wWMty7
 47bkFn2+tME7W6HGZqTUzqmaKwIyfKei3prfMqPmh8fGbp8YeEerEbKygaf+lZbPYmwD1Iydy
 Uz+ifhcu6Rxsjfd9kz3nShCIhhtKldYUXuvv2iivz/Y0Qp98RJOKiHAud6JUQtkoeOebOChQC
 RZMq86155mZweYcfSzUkp4OTrS2yvgRPpdMnLUyM430MDfABkLkPHok9c1HloCyR/DnfQ8WbZ
 M6fqB1RuOWyzG5b6ZRBiYjompyG/eCPLUkiIjRd0VJLOeDRCJcOEqLy7OuGLmNM3boqRnorGW
 VIfp0+FelF0gIsBvd35waJbOGRo0DCXDzxUq0W6SPePYdoCtbl24220diATCXqfCLMJI4mC/Q
 pBdbCHknV79JqddUaW9MAGAqavqgxDiqyOnydJNXkU531Waah+/rmZ15PLRHjfE6Mu7wvXx5u
 4QL8jnCc1CuyF0p1tMDWLYihVISRDu48=
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


--=-EW3wbWkpAFzaI/6e7XG/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-06-06 at 19:38 +0800, Coly Li wrote:
> What is your gcc version ?

That Gentoo had some gcc-9.1 enabled, however the running kernel was create=
d
earlier, probably using gcc-8.3.0.

The OpenSuse TW live where I tried to register the caching device manually,=
 I
don't know what the kernel and tools are built with. zypper info gcc says 9=
-1.2,=20
so I guess this was the toolchain for creation as well.

> This one is important, if I can have the kernel message or call trace
> of this segfault it will be very helpful.

That one I don't have anymore. I can try with some 5.1.5 kernel later..

> > Is my bcache definitely lost?

> I am not sure for the dirty data on cache, but for the backing device
> you may have most of data back. Considering there is btrfs on top of
> it, a fsck is required.
>=20
> You may try to run the backing device wihtout attaching cache device by:
>   echo 1 > /sys/block/bcache0/bcache/running

Read my initial post, I did so. I was able to do a luksOpen. But the btrfs
inside was corrupted when I tried 'filesystem check' and 'mount' on that.

Best regards,
Massimo

--=-EW3wbWkpAFzaI/6e7XG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEjdL61EKP3VOAA+I8lQj3p5VSZjIFAlz4/uAACgkQlQj3p5VS
ZjJ//Q//UHzx8w4VjWg/2nATIHwd4C9oMDQkCQ1ot7aWeyUPwsG/Rebjw/UTMOXw
K864y3eAf4MUv7GYQi8yujrUVbgY+ISZKBPdVVYfylMxGL4ioLHp3TrJi6SYSFdw
NVHYQv+xdddGs4pw7uk4o6MEHfQdjyuFuUWoZiBJ50n6y2vfkFsAkZxeoHYy3rFe
DZ6qU7hRQgeO8usI4d2ORoLoXYuQS27u7dl4RLHz4u8NAs5ThgwiyQjETUOsvACV
/hH8h+WYzsevTuwqqJH6ODiGwUUVJ165tc0dh7MKSjzCxkXLJalMh9eZhVtmWDbO
MqwvMoMx/mEgZ0vjzkaKOrLc4qFXm5N2e/3jnmWGiVfu9m+tAac0cs8uzI4vN+nh
O9x7M2HJ1GNiYoBxT3JA588KevbRHnJLj0hlpeGepMhGaPoZzoXkMW4tyy4Snyip
H6wt3Uj1T5/2Iu0OcugN3X9tOiVKSBCrNc3TStAre+iXSOaX9X7OpNrlJpsVZxAW
Y6xUVID8Vnh+nhrKj+gln0ife7Lwvh3H5YSyG+Q6Ig96Fl49mQ9ngb05MYpdhSEf
7i38EdksgVeyKdnCaqpxQqOuf5GWBpp9vuYhmfSlhtAVWNhk7/GjvJAgPMCjvOqY
dyQeLoruPbEbQ5DK2C6qYf/W3N7wI+Yy2WuUul5oUGAT/T4aSpg=
=SrMV
-----END PGP SIGNATURE-----

--=-EW3wbWkpAFzaI/6e7XG/--

