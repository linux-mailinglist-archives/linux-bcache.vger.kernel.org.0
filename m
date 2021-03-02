Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8832AF57
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 04:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhCCARw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Mar 2021 19:17:52 -0500
Received: from mout.gmx.net ([212.227.17.21]:39555 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1577086AbhCBFma (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 00:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614663647;
        bh=vuF4asm5oftnr0ailpx2QxWzLruw3F+JLEa0u6Q/iz0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=bSC+pfyU2JXcnedNBCzpoIPZqWorJDIAAIH1FjECMK1k8kwuyPnbxEtYBsNe/liKo
         oDBfGCfOEOA3p5iydEdCUP/ZsQFKGkGSqzHwYvG+ALyfryTF7g/VRmedwMNaziF/3z
         cNvCQX+fTa3AlFSOiJF2bKF67dm1GShikoMmfcKY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mwwdf-1m1Ehk2IJ9-00yTu4; Tue, 02
 Mar 2021 06:30:28 +0100
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
Message-ID: <e67ea64d-7e36-761d-0e28-cc0d1012c3aa@gmx.com>
Date:   Tue, 2 Mar 2021 13:30:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <04770825-b1d2-8ec0-2345-77d49d99631a@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:xDgdIpJFStLSXW2RLKUWYAHjPp/5talER5FW8ivrkP11vqfNqM7
 vVBWqAf0Qfu/KAD83otSeT0kHwnZlOaDEj5ZR4L1f2DotH8KCXYKJdUlW0osxd7L7O3k+DZ
 gYSv3UJjEQqeAVnHMyMDVN6iWLEam5DssGsZngvjs0tpnJbZGWifqRvAVxMhNoXszKbBHX+
 w9h4TQAjyLjCqDw4Hy/IA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QcwdvkAQ6Ok=:Jlo5MXft9h7U8pJa8yHiaY
 6lTfiXUR3keB5WcCfL5vHZLoy5oOJLnuiCx4lfCbAwxingA9NbEZn5s4yaDsyGzzK7IGXhiOo
 6oSNds/8PGfHDiAfFme4rL4jEN/tDKi64EvnQ6i5YtFdEQKfumq72N3Md8Sh3K39i5suczZx3
 UOpsMAFe7kD97NPkDe4nmwK1vkap04GSoJ18rh3upGaZNYwOmKSn0/aDEqnEUrSuQ915hx7Jy
 yF2p+q3FS/SyZQ9n/kWoeLL5B6Q8QOoKTosebCVQ+9Bj9UYAD+OvKXhB+wEPFkXaKcG/pi+B3
 RPHWCH5BKa7G/kG4/0slKAq4HMi+2mvFBKnHxX74lbJ2CpFSBoLiQnLO5SdeVtpEk17Rua2gh
 yWjGlhnbcZnUb4MK+xLLAoySRMpuf/aNFg2Z1cIOOY8VNRVcQjENN88zlcPHmujbOVZLTx9Dn
 CnX4mvVq+FwqOfa25r9sbbVRaioMVR1TGRzb5pL8imHQ3bD51q8U2rsBU8wUxPGOReO5j6pcV
 xAS2p1/Mh/tQZr6Zq677fE0VX7VO4QNPwNDLG/wg32395wRtssC3iaf7scqv3EgC4gzDM1YYk
 s8kw4cUeGbyId2WEqy5fE51EZHQlwV6nRqcr7NECGeyxgv+saALKOZH5K9m4Y9CiuoKWYXSQU
 NjFtmzNr9yx2DlnBZPyHgztcN8lemMFh03iFsZz3snE5Svmp9xZHSpBL7x2HOedSxWasiKFCb
 a1jgnZ8uojrctpGNqIwEKUoz0yJuqMToZitEI3bKD7aYuCBAKXLCZJVObPsWiGbUcek1vdQ/8
 zSTbK+2n2TSV2JsYgz598940Jqc31xrbMF/veOIc5+phZIaP4KzTYsj5l8HQy6Ek7dCz5KCDQ
 +jd0C8H8P2KLEJOYE8+g==
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
