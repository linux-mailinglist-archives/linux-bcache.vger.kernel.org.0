Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02B6632AEF8
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 04:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbhCCALy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Mar 2021 19:11:54 -0500
Received: from mout.gmx.net ([212.227.15.19]:45213 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240706AbhCBCFx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Mar 2021 21:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614650635;
        bh=vuF4asm5oftnr0ailpx2QxWzLruw3F+JLEa0u6Q/iz0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=J3vMVIkQhE2CS6WsVY2LesmwrUrxzKoNhn8dzZ4QG+mS5iIG8zDVnuHmZPfcCJQoR
         2invWuX8AcP/UjqswIVL/oAsvEA0/ggmTGRm8HcP34r6EMh+XSyQAXM9yZUFyjhvPr
         50E3fxLkjnVu+Z14J2H3sDlerd8QVYiMueaQDctw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1Mel3n-1loaa73Hcb-00anph; Tue, 02
 Mar 2021 03:03:55 +0100
Subject: Re: Large latency with bcache for Ceph OSD
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
 <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
 <07bcb6c8-21e1-11de-d1f0-ffd417bd36ff@gmx.com>
 <cfe2746f-18a7-a768-ea72-901793a3133e@gmx.com>
 <96daa0bf-c8e1-a334-14cb-2d260aed5115@suse.de>
 <b808dde3-cb58-907b-4df0-e0eb2938b51e@gmx.com>
 <04770825-b1d2-8ec0-2345-77d49d99631a@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <8eb6739c-090d-f925-333e-df34a6d05101@gmx.com>
Date:   Tue, 2 Mar 2021 10:03:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <04770825-b1d2-8ec0-2345-77d49d99631a@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:zcUrsm3jMU5IwCt0k0hA8Cjb5TdcuCwoIFrRQMq33on95yaWdf1
 FKjkrI5Z8xufqT1DiDc2eUtRB9HpekTxQu+vjV46gw31LL7UrnqSoS5xJB/k3MMOZ8zJCmP
 JsgiGCaURW6jvyMWgRT/zL4hlGCW/ET6K59LpWPY0QE3C1tHtGeg6CCll61fjZKVKHGtBBn
 A9BV+t47sie7WBTA9z3UA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mv90uQif5z0=:mkPZnt/wAzgCji6VgOJveB
 1f4EKQWxRHBiHrPiJxSu/+LY9k9C7xeeY3CRh69qmwh/t9NjjFjJm63vKx42nej7TjZN9GJh7
 OjeuL0QxP7YUDb7/uuatHAJFNRE+Qa09O/szoUK99lGojTqxSxZO4UMdpc8Fv8GaDxGLrymhk
 rENMJWZ4ZHom2LibiDweuPgZ9tBY8NfOg6pza4DxSVw5W/p2++yYwUtH/9AKkJIcBBT8iR6gR
 Up0dVsWBxMHtKqQp3LhgHXL7DZMigxJkW9fRgOAqsjjfTRhXjOKxzdUHMz368Pgd5ZBn5dKvX
 p7o8Ltb0h6X/Kp6GAXBNbjy58gfwBEQjsxsJZP3f862ttw+XrWwoR+swBknlPKpa43kMtwBwu
 St4YJAGElaG/D2345KpU5qqPHu2V19AkHtpy2gdMEKYQaKg6FxInZY8HjRaVKhYr+DeVu8LV1
 QyYb+OyLOoKL1s+Q9oLFzmqeCOxJkBcLv3P6r9y6rDptMLxCfkeXKK45EkJnaT/c4rMCVLmKp
 NeGdihft1aDpLCfnq557u/eEJHRIu9gBNbs7epPjK5QHvOCgheY+RfeHja0iepkogG3n5BfxY
 rIgy9CjsgLgqHH/3I2adhWPGyRfKQFaAz9m4rhQLxVpZxqb5GfD+lN63lDwpH3pFfq/6BLu9d
 QzqXjCfkCgD/rx1t7vwwRJ/GU05wveQ6gxMiPwtVIOMBrGqOP+T4F8PMw39+i4hRnMoFJhDFo
 zXXt+lfdZleTUXz1UfzFkxFEZCpRc6XFBUei1jiMveVeHnlqhGgcltC1m/UCaQWLqES74qZf9
 X8eaBqPK5WE8Mpu5AvIIOAe3Y/59oC6BKg5B1D8BUoiOgcjN9wa4H6TCuT0sKkGOmfbFgshAO
 nFI8b+r4uqhXmppGpGVg==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On 2021/2/26 =E4=B8=8B=E5=8D=885:54, Coly Li wrote:
> On 2/26/21 4:57 PM, Norman.Kern wrote:
> [snipped]
>>> You may try to trigger a gc by writing to
>>> sys/fs/bcache/<cache-set-uuid>/internal/trigger_gc
>>>
>> When all cache had written back, I triggered gc, it recalled.
>>
>> root@WXS0106:~# cat /sys/block/bcache0/bcache/cache/cache_available_per=
cent
>> 30
>>
>> root@WXS0106:~# echo 1 > /sys/block/bcache0/bcache/cache/internal/trigg=
er_gc
>> root@WXS0106:~# cat /sys/block/bcache0/bcache/cache/cache_available_per=
cent
>> 97
>>
>> Why must I trigger gc manually? Is not a default action of bcache-gc th=
read? And I found it can only work when all dirty data written back.
>>
> 1, GC is automatically triggered after some mount of data consumed. I
> guess it is just not about time in your situation.
>
> 2, Because the gc will shrink all cached clean data, which is very
> unfriendly for read-intend workload. Therefore gc_after_writeback is
> defaulted as 0, when this sysfs file content set to 1, a gc will trigger
> after the writeback accomplished.

I made a test again and get more infomation:

root@WXS0089:~# cat /sys/block/bcache0/bcache/dirty_data
0.0k
root@WXS0089:~# lsblk /dev/sda
NAME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MAJ:MIN RM=C2=A0=C2=A0 SIZE RO TYPE MOU=
NTPOINT
sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:0=C2=A0=C2=A0=C2=A0 =
0 447.1G=C2=A0 0 disk
`-bcache0 252:0=C2=A0=C2=A0=C2=A0 0=C2=A0 10.9T=C2=A0 0 disk
root@WXS0089:~# cat /sys/block/sda/bcache/priority_stats
Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29%
Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 70%
Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49
Sectors per Q:=C2=A0 29184768
Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [1 2 3 5 6 8 9 11 13 14 16 19 21 =
23 26 29 32 36 39 43 48 53 59 65 73 83 94 109 129 156 203]
root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b/in=
ternal/gc_after_writeback
1
You have new mail in /var/mail/root
root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b/ca=
che_available_percent
28

I read the source codes and found if cache_available_percent > 50, it shou=
ld wakeup gc while doing writeback, but it seemed not work right.

>
> Coly Li
>
>
>
>
