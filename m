Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CB23307B6
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Mar 2021 06:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhCHFrn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Mar 2021 00:47:43 -0500
Received: from mout.gmx.net ([212.227.15.15]:37897 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhCHFrZ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Mar 2021 00:47:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1615182443;
        bh=UOHZ/Q+z+H+Fugbbs4CkrrGZ7FVUIY7CDDYvvepZJhc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Lnoh89jsCX5M08ibf1iGHElcySgplc+wbXLPlRRrJ8KqT7MYx8O7lP8IBQceJ4J3c
         fdztVcaZ95z3VgBBTOIgf0ybdn9YpCUiydjv6bOuea1IkRqmL6Uj7K8BpFUXPhvxk2
         cv+2GLgICOK8nZYrvBCRTcaHmgCLw1V4VQ4JZ7q8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MEUzA-1lZ1hg1xcY-00G1TB; Mon, 08
 Mar 2021 06:47:23 +0100
Subject: Re: Large latency with bcache for Ceph OSD(new mail thread)
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <9b7dfd49-67b0-53b1-96e1-3b90c2d9d09a@gmx.com>
 <f6755b89-4d13-92a5-df1a-343602dec957@suse.de>
 <91cf3980-ed9d-a5f8-4f2d-d9a79b1cbed0@gmx.com>
 <1fa52fcb-1886-148f-2d55-02060dce7f93@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <e6b0eea4-2624-26f0-6f6d-11e900eb3f0b@gmx.com>
Date:   Mon, 8 Mar 2021 13:47:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1fa52fcb-1886-148f-2d55-02060dce7f93@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:BqkQ9Nb8/MAKELkqjw5LIDAFif8b7fzC7zD8feYK8Rdz5/5G1s2
 gwyWHMkopRAX+ygQT9frIZCl9Hrx7pbFBSwEBPOEEF1UwhVAM/pbUeopJpyK4qvQb5ZP5lj
 Mk6i9zkRap58DFIVJO74Wbh7ZmYHWxzG4R0ZUpM16UxYEdFpwMx70IyzRzjclQARt0Vnw8G
 RXoJIyAFuQ0pEFLe+AG4Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hn2yBUJ1NlQ=:42LU6PRwfifDpqpfloe6G7
 iU5mEAts3v1A8ysEkkqmmP+WFrOuwjYZNIpVkDP5HIAUFDh7KHZVvL1J2EbxLpUXtKtnvQfa5
 UMLegs/jloNolJJjoi8AVmJcMC8lpZWbzroOcJ4HF4HqFLGHY8Im3ltaeYqZVSejFNzUcLWyH
 Y9yP5XEKMnm0k7SRy+FwYYgID9P08/Nw8mI/qg9kis7Opm8ZqWMuoj1uYAbhhak+Q8spCUYHY
 IrDCSCZKIpZx/59b0ooR3g8ZtMPRgcDVwkQHfjFtMwCDVVNqe5/3PpiiOhAmO2zpUVIwi5Fxo
 H+7nzSZVjgnnLjUaoZWzE4EX2ttNitnuCoIJxr/HiRtutXo3ezS0qUfBpf4Zf3+pDwCwNYcIQ
 HSVXCX09XqRGN9BbdSjRInDoe0dDvast76/fSQ/p9uZrnS7gI9NryDRGt1RQN8M+DluiGAtCB
 Gnsnb6RDRbYjshgoDMbXqXta2jITLr0mV7PlAYpjRCtf+8IdtT9GU/KCWX179wwxfh+ehiuz+
 ujO3aV3g6tCW02SKIN/8yczHQKAw+WEEC2eJwsSl+j9aeVthAVBP1CKh6OOHkJQxpyXBmGTER
 5Tu77a0JEW6U3gHjvJDQdRb2luPohUdn16pjL3rqklGfN4wvQndmLJSE0nYqx7ufjJGUksmb9
 0bzq6zNa6nKcmwKm4nQBMOFUNs3uj6v5kvm2ByZlUAsYGAWIl+3XhajxTjVrAa8x51HKGoSWc
 5tVlXV1eQMLCifN4i/XqNBxvDRs5ys0jTM0Feo5epFdX08s4EhI5h2Mp/jhSNHxkT2x6YMk7z
 sIPI15neE23IMitfnfGZhWGKA4pvVW/FfEbZjOJW+SRI+NScmrSY5OKlLK8n6RlU1dqGFlsDL
 RRVmbrRNkd6+PmmP1F3w==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On 2021/3/5 =E4=B8=8B=E5=8D=886:03, Coly Li wrote:
> On 3/5/21 5:00 PM, Norman.Kern wrote:
>> On 2021/3/2 =E4=B8=8B=E5=8D=889:20, Coly Li wrote:
>>> On 3/2/21 6:20 PM, Norman.Kern wrote:
>>>> Sorry for creating a new mail thread(the origin is so long...)
>>>>
>>>>
>>>> I made a test again and get more infomation:
>>>>
>>>> root@WXS0089:~# cat /sys/block/bcache0/bcache/dirty_data
>>>> 0.0k
>>>> root@WXS0089:~# lsblk /dev/sda
>>>> NAME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MAJ:MIN RM=C2=A0=C2=A0 SIZE RO TYP=
E MOUNTPOINT
>>>> sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:0=C2=A0=C2=A0=
=C2=A0 0 447.1G=C2=A0 0 disk
>>>> `-bcache0 252:0=C2=A0=C2=A0=C2=A0 0=C2=A0 10.9T=C2=A0 0 disk
>>>> root@WXS0089:~# cat /sys/block/sda/bcache/priority_stats
>>>> Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
>>>> Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29%
>>>> Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 70%
>>>> Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
>>>> Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49
>>>> Sectors per Q:=C2=A0 29184768
>>>> Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [1 2 3 5 6 8 9 11 13 14 16 1=
9 21 23 26 29 32 36 39 43 48 53 59 65 73 83 94 109 129 156 203]
>>>> root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-4959631915=
4b/internal/gc_after_writeback
>>>> 1
>>>> You have new mail in /var/mail/root
>>>> root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-4959631915=
4b/cache_available_percent
>>>> 28
>>>>
>>>> I read the source codes and found if cache_available_percent > 50, it=
 should wakeup gc while doing writeback, but it seemed not work right.
>>>>
>>> If gc_after_writeback is enabled, and after it is enabled and the cach=
e
>>> usage > 50%, a tag BCH_DO_AUTO_GC will be set to c->gc_after_writeback=
.
>>> Then when the writeback completed the gc thread will wake up in force.
>>>
>>> so the auto gc after writeback will be triggered when,
>>> 1, the bcache device is in writeback mode
>>> 2, gc_after_writeback set to 1
>>> 3, After 2) done, the cache usage exceeds 50% threshold.
>>> 4, writeback rate set to maximum rate when the bcache device is idle (=
no
>>> regular I/O request)
>>> 5, after the writeback accomplished, the gc thread will be waken up.
>>>
>>> But /sys/block/bcache0/bcache/dirty_data is 0.0k doesn't mean the
>>> writeback is accomplished. It is possible the writeback thread still
>>> goes through all btree keys for the last try even all the dirty data a=
re
>>> flushed. Therefore you should check whether the writeback thread is
>>> still active before a conclusion is made that the writeback is complet=
ed.
>>>
>>> BTW, do you try a Linux v5.8+ kernel and see how things are ?
>> I have test on 5.8.X,=C2=A0 but it doesn't help. I test on the same con=
fig on another server(480G SSD + 8T HDD),
>>
> What do you mean on "doesn't help" ?  Do you mean the force gc does not
> trigger, or something else.
The=C2=A0 cache_available_percent didn't reset to 100 automatically after =
all I/O done for a very long time. I must echo 1 to trigger_gc to help it =
recovered.
>
>> it can't reproduce, this really made me confused. I will compare the co=
nfigs and try to find out the diffs.
> For which behavior that it don't reproduce ?
The problem of cache_available_percent not being recovered automatically.
>
> Thanks.
>
> Coly Li
