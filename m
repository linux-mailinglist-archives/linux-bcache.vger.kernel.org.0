Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16EE21A0B1
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jul 2020 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGINUR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Jul 2020 09:20:17 -0400
Received: from mout.gmx.net ([212.227.17.21]:43919 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726896AbgGINUR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 09:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1594300815;
        bh=DWBPYzCQ1Dijkr68XLD0vVXVmeEdczM3njsbU2c0X0c=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BsZCyYa3XlSlN01RPA7zmSc8bOeMGFYjbNO2T+d8rXcOClXmrM7gkzvsPraHT+ZDX
         iuZ9TcddaEmXntqSqvFkLQKZS1BUPM2+Ened/42wpDKJiNFnc+4WMDxb2A7bfKk23y
         7FkFDDNRKpbRdaarM6mD7qhDSdleU70cKlrfyCwg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from t460-skr.localnet ([194.94.225.9]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M59C8-1jsQXb1nka-0017jg; Thu, 09
 Jul 2020 15:20:15 +0200
From:   Stefan K <shadow_7@gmx.net>
To:     kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: how does the caching works in bcachefs
Date:   Thu, 09 Jul 2020 15:20:14 +0200
Message-ID: <2900215.XKtEbqh0OK@t460-skr>
In-Reply-To: <20200708220220.GA109921@zaphod.evilpiepirate.org>
References: <2308642.L3yuttUQlX@t460-skr> <20200708220220.GA109921@zaphod.evilpiepirate.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:JKvV8twuq1oH59OVsIir+OsJMP1+WWUpt8QCRlerYtTcmZSfz7t
 /pQIZdw3t+8glfL6wd52zh+Elae4z5ya0u+rjGA4HEC/b6GXCXohrBbD/MJes+GTsXyR5et
 UUhHZSQDH8SJ0Vs9jcHqEcYnW7gtK0Kr0YyW0hlNuo9iSD/Yim6fbTo0X3HxtYKOAvxHm+Z
 gQoacEyZmpPiHHCZRT72g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qGpyHOj0nIc=:EyfEQGHYeC4+VXIQVC9+dH
 RjBhpvM7TwttSCHdIzY4fByu42yvxstoN+JPWF0snY5uQRIrfFANt2Zg1z+hwDlP8vVHuaM9L
 uqX6N6RVcOO+xI0ZNUPEu/rgzNNacxOpPSFy7bZ9GMH0TrrmM2BFnetqpy0cQl/jIX0FM5yCG
 TXu+1X/3Hn+0oKXuqB9pa+LZwE+Zj5rDwslaYh+TNG9uvNX1ZHYbCDWRAVAxjenCd4h8ovCVg
 d3t0R5f1YLeWnf7Lw4fjLQ7kVwvkXeHYj6FIVlTIJwSaC+Yv/0OJRUUVBLCcW8qeqE7Llgizj
 zgiXEJxtEmX0itZ3JexT0U0FjXnFyFeIJgBk9RyTwZDGODQ9TshbH6py3DNbFL5ZUe+CeK2Q0
 Wk4aQw77GC/VEAVq1/K+KqPRljGS8PlTjqLR9ZP6M9jT3pZg5QlU0NAMA7g3OcTLZsSTjdZ3R
 aqTH+7STwBoHD4g18zsz3P5R1Gcb46qBRZlolbo89skDRho0oNqnVrTUhqEtwyEGusDTcQphe
 4enXblX3AGrCrFE9PQxz+5W4Q/g1hNIjQcuNRNY+b9zE7upeaCgC9QpSGnas8D/qg1ExpbWAe
 fTv/2PclApbFDOY2MEJqRTkaSMgnJq6Qmx5JfNHWRv8mo5NNTB7fckBr/XxGnHnBTSVivwPMj
 gIpQFvYdgUkI+ygpl8VXW6/zimV8A4h2OM1OxWqaQAteoFBREkwIlgOo4Mu13sZQOVRHqOlZ0
 v0spl7r07jETbVQJYh5dO++fXXO3U7btD/lgChSJPuRfTdbSFatuCzwbHp0icrRF+GBHGHWU7
 7PHOwokbkukkOI0KszLDpWAbq3gwsuPJyTnHlm+BH1r4DJLL/0C/HBiy+Ua4OGXr6SfY9yGkh
 i9jAAPmXyluHcLPdaX2ypgqdnuaEmPaTZdZSdOLZspjR9nQfrHIppyRWTFHHq8SzMoHSm8otp
 AVcin46W3gB7ccc/pXuGQxU8+/e1a4fLYpvoMKJseLmwf/L8/qokTP6D6vWJqEvxofaDJ4Gp0
 LwSnaQpst4W3ksokVVGPeW3W2furL/oiYP+NgLzORzd7yllUOCdANO3NRdNOuv4VHH8HZB6at
 eiI6RFET3d46AF7SmNtlWJlSDWc+L3x1cnIpR5iMYl+w2+DdEhA//1S8Uwam2VCadI4/MeEai
 gRaWbr9iL9kZ4YWWMQHHV8ALS7stidd6JqDOt5d68xQBJNfkwJ8F6NBJWyym+tveZtlzXku0p
 XUS70F2ma8Aq3SB0f
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi and thanks!

> LRU, same as bcache.
do you plan to change this , since LRU is not very efficient (in compariso=
n to other), maybe 2Q or ARC[1-4]

> [...]
> And you can pin specific files/folders to a device, by setting foregroun=
d target
> to that device and setting background target and promote target to nothi=
ng.
ok thank you very much! That must be documented somewhere ;-)


[1] https://en.ru.is/media/skjol-td/cache_comparison.pdf
[2] https://dbs.uni-leipzig.de/file/ARC.pdf
[3] http://people.cs.vt.edu/~butta/docs/sigmetrics05_kernelPrefetch.pdf
[4] http://www.vldb.org/conf/1994/P439.PDF

On Thursday, July 9, 2020 12:37:29 AM CEST kent.overstreet@gmail.com wrote=
:
> On Wed, Jul 08, 2020 at 11:46:00PM +0200, Stefan K wrote:
> > Hello,
> >
> > short question: how does the caching works with bcachefs? Is it like  =
"first
> > in first out" or is it more complex like the ARC system in zfs?
>
> LRU, same as bcache.
>
> > The same with the write-cache,  will be everything written to the SSD/=
NVMe
> > (Cache) and then to the HDD? When will will the filesystem say "its wr=
itten to
> > disk"? And what happens with the data on the write cache if we have a
> > powerfail?
>
> Disks that are used as caches are treated no differently from other disk=
s by the
> filesystem. If you want bcachefs to not rely on a specific disk, you can=
 set its
> durability to 0, and then it'll basically only be used as a writethrough=
 cache.
>
> >
> > And can I say have this file/folder always in the cache, while it work=
s "normal" ?
>
> Yes.
>
> So caching is configured differently, specifically so that it can be con=
figured
> on a per file/directory basis. Instead of having a notion of "cache devi=
ce",
> there are options for
>  - foregroud target: which device or group of devices are used for foreg=
round
>    writes
>  - background target: if enabled, the rebalance thread will in the backg=
round
>    move data to this target in the background, leaving a cached copy on =
the
>    foreground target
>  - promote target: if enabled, when data is read and it doesn't exist in=
 this
>    target, a cached copy will be added there
>
> So these options can be set to get you writeback mode, by setting foregr=
ound
> target and promote target to your SSD and background target to your HDD.
>
> And you can pin specific files/folders to a device, by setting foregroun=
d target
> to that device and setting background target and promote target to nothi=
ng.
>



