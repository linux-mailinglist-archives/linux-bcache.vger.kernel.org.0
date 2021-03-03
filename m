Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E198232BD64
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 23:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbhCCPyj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Mar 2021 10:54:39 -0500
Received: from mout.gmx.net ([212.227.17.20]:58413 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242396AbhCCD2O (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 22:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614741941;
        bh=Dbl45cYffM5VpBIUPk3aPwijqlx22eo8BibXzeyHTpA=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=FFJZU9w878QZNIgGE7AIcB530Gb8uX2kHutABSkzBx1ImYEUrLAuiRwZ9bh/KvlRI
         qe4xMgD7EMul1aASa5um6GKcvQXZkN63MiIFH4HAkXI+bruYnvFls9Fk9sbI6HPgkc
         cDfB085t7yVxNM7pLV2yBmVNn1a0oy3lCNUaCWlU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MSKu0-1lO0Fg34A4-00ScLs; Wed, 03
 Mar 2021 04:25:41 +0100
Subject: Re: Large latency with bcache for Ceph OSD(new mail thread)
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <9b7dfd49-67b0-53b1-96e1-3b90c2d9d09a@gmx.com>
 <f6755b89-4d13-92a5-df1a-343602dec957@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <f7b3c407-386f-ab3d-092d-890478abd2c9@gmx.com>
Date:   Wed, 3 Mar 2021 11:25:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <f6755b89-4d13-92a5-df1a-343602dec957@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:WhGy41qMcy29eNrypJcrubMAdwVFszEDZZ8RDJx8QZTR6ZVQmXW
 JKXNrJO8AnRBfnBMrgcrqGSQeCiwcgFWISrnP+qfAzQtJTiUnZ+YvMCuLpDaGbXPnUTjWEb
 9TgUDZD1X6CZTpoilFMDnAtQvueMlMNPWLlfRYbx/tKiiK4JfzTAxAkYiIMyiFmkXajbY+u
 MLJoFp+e8NC0NU4hmcHRg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RR+Ia3bucGc=:kyBnJsTtx7xZoGvLiFalEs
 uOYgqdU/7UHXhYXYE2Wz/sPeNgoGOdkR6n7uHGZUcMgJn19TeWjMok/iBHdZNCAnXgnZ/jceN
 uPPB3C2cVR+O7WOXKJrk6TZ7R9EKRtPrOFWFhuYOlSI7FN+Rq9ArIm39kQNlv1rH6tmbgt7g0
 lmTFdQe7F23lvamu5u3zWpt7jHGSmgEtMbZVZw9uWwvO6iErXpMSnXvW0IRq/L5PHbF6lJzn+
 6zy4AFoY6Qqr0+JxNNK/hD7BmQjZEfzJSQonKFC3eDLrRayk84PTXoAX9FUkeo5sglqPWqLjm
 OaGMCDsvHr5wyUUYlFsoN2owXa2mUXef0ksBdcwIKjR9+pD/0QXnhNMI/QpO7HO61WrWyEH7p
 7r5HMkFUPN9Nn3H+hQPbKzei5F7zTWYs61aqH/T40RMucDgxy4KwFHwE2w4BUR8gt6H1YdnHd
 eyYqBGEapU8fFmZDeRfeaphuNFkfkryiSTDuuFwgHQ926lm+XDvuy1+xFeyV+oMOpuaykD2kL
 OMVdkydCx1EPHOk2BJ5Qc6kvex4GyexTaKxJ8r4UAg5yDRcMYM/gK8Ho6+9nwGtcqBEAykIhc
 T+xH3i+Se9ygdKwxGYKktXffz/VkVijz/91MalgEF2mD3SZKLrlktlFsUiMcci1Hs7brjvRb9
 Nf0HyJQ1liJFE11ESpS9Yb8+UEq3flDzJW/aLA20h1rqAFU21VPig822SjbkNCpMNm4b3RD5e
 htmP0AsT1e5V1StiRWc2lrz2D61ub+csRlSphkMZMF1oAsOodn+NzpbiPrt4J9QpplBLZbzOo
 91kTdMHVVxGdJNLy12W1+ihWCo6QHFFiLPnSu62d/E9bsK4Njql+yeShmuU51K+WSXdYuYtQ7
 +/hNzUKCCrcyYSVWlzZQ==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On 2021/3/2 =E4=B8=8B=E5=8D=889:20, Coly Li wrote:
> On 3/2/21 6:20 PM, Norman.Kern wrote:
>> Sorry for creating a new mail thread(the origin is so long...)
>>
>>
>> I made a test again and get more infomation:
>>
>> root@WXS0089:~# cat /sys/block/bcache0/bcache/dirty_data
>> 0.0k
>> root@WXS0089:~# lsblk /dev/sda
>> NAME=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 MAJ:MIN RM=C2=A0=C2=A0 SIZE RO TYPE =
MOUNTPOINT
>> sda=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 8:0=C2=A0=C2=A0=C2=
=A0 0 447.1G=C2=A0 0 disk
>> `-bcache0 252:0=C2=A0=C2=A0=C2=A0 0=C2=A0 10.9T=C2=A0 0 disk
>> root@WXS0089:~# cat /sys/block/sda/bcache/priority_stats
>> Unused:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1%
>> Clean:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 29%
>> Dirty:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 70%
>> Metadata:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0%
>> Average:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 49
>> Sectors per Q:=C2=A0 29184768
>> Quantiles:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 [1 2 3 5 6 8 9 11 13 14 16 19 =
21 23 26 29 32 36 39 43 48 53 59 65 73 83 94 109 129 156 203]
>> root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b=
/internal/gc_after_writeback
>> 1
>> You have new mail in /var/mail/root
>> root@WXS0089:~# cat /sys/fs/bcache/066319e1-8680-4b5b-adb8-49596319154b=
/cache_available_percent
>> 28
>>
>> I read the source codes and found if cache_available_percent > 50, it s=
hould wakeup gc while doing writeback, but it seemed not work right.
>>
> If gc_after_writeback is enabled, and after it is enabled and the cache
> usage > 50%, a tag BCH_DO_AUTO_GC will be set to c->gc_after_writeback.
> Then when the writeback completed the gc thread will wake up in force.
>
> so the auto gc after writeback will be triggered when,
> 1, the bcache device is in writeback mode
> 2, gc_after_writeback set to 1
> 3, After 2) done, the cache usage exceeds 50% threshold.
> 4, writeback rate set to maximum rate when the bcache device is idle (no
> regular I/O request)
> 5, after the writeback accomplished, the gc thread will be waken up.
>
> But /sys/block/bcache0/bcache/dirty_data is 0.0k doesn't mean the
> writeback is accomplished. It is possible the writeback thread still
> goes through all btree keys for the last try even all the dirty data are
> flushed. Therefore you should check whether the writeback thread is
> still active before a conclusion is made that the writeback is completed=
.
>
> BTW, do you try a Linux v5.8+ kernel and see how things are ?
I stoped all rw tests for almost the whole day and no iops from iostat. Wh=
en I echo 1 to trigger_gc the

cache_available_percent changed for 29 to 100 in seconds.
I will have a test on 5.8.0-44.

>
> Thanks.
>
> Coly Li
