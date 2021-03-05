Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046DF32E417
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Mar 2021 10:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCEJBX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 5 Mar 2021 04:01:23 -0500
Received: from mout.gmx.net ([212.227.17.22]:40515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhCEJA7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 5 Mar 2021 04:00:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614934857;
        bh=igxj5LgMmYbcBIHKFR3fz4BAwGgmoVOuqlu3GD1Rk2A=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=MGSzemqWITYMQwJxB9dZVs96BKWtzJXyAvmuBY9r4FQ+92L16QVfEVTuD8XveX9Lz
         69+L2f2Vg90u15AjFiIoPrQ+OKfS/SjdjYSFcPFMy4VHYy3CpPUNJNXV8jP4kCYj5A
         t+ZZbKh/VMOz/uXw0C4hi2h6CzdRKFheJYfbth80=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.25.85] ([103.52.188.137]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mv2xU-1lZUgi20WG-00qzsV; Fri, 05
 Mar 2021 10:00:57 +0100
Subject: Re: Large latency with bcache for Ceph OSD(new mail thread)
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <9b7dfd49-67b0-53b1-96e1-3b90c2d9d09a@gmx.com>
 <f6755b89-4d13-92a5-df1a-343602dec957@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <91cf3980-ed9d-a5f8-4f2d-d9a79b1cbed0@gmx.com>
Date:   Fri, 5 Mar 2021 17:00:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <f6755b89-4d13-92a5-df1a-343602dec957@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:ipOUIE5i5zm5oB2dKflm+ce+569Uh+Gu6LkZVLykciAjgdgmx7J
 gdV0J1QFVZ5qT8GyKDnoDP/SmemLmM582w6o/K20Mne+LX6pNa9Nj1BW8tFHQiV9rOaWbCF
 MLNfVVsIoKl4PgJDebzwfIN0dy0fmOaLehdlX9W6dsc81F+iZ78VXPCW3Z2lLaWgfia3CZT
 yzNwPADxpHJY5ZGuRUV5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oqGFe+d6zw8=:pUnyUfGE59xjjD/GIvNcQU
 FeqUjTzbMSXBQ3yH9BdSNwBPU0ABa5cExF3TuEtyuNSxLgcESKhkYD13DxgoiJ9KhSMttXPxJ
 jpLMF7sf69F7Le/v0N9DDKSSPGK7zPD7XyA8fkmxBOkaOoDL2J7KgfmSUM6Vqpujh79zpxeNA
 8C12e87NfRjekRH/UZ3f66eLHVh5aCYr1PBsqjO/aghD5YAHSu2vpronYim9SGSln7sxAugT/
 v65r/w7aGQlVzjwUm7TLghOEHlW9Hy0AuHeNM0BgDzdv0/PDzZKTTS+zqJhS+cwQZp9z0k6DO
 o8Ogiz4I4NcaCoYs7wPQwyG2fFZJGO8/JrIrlKTLtc/Npf5Y+zSi0FYYqZGOIr+OWH1LEQGwk
 iHZKOmxS1Lb47IaCAp8WshuyIBJw7vhLifYAf5Yuh0W8ZS+df6w7gPn/pchPr+dBINWf8p374
 oIwgy/W02K6YWottIrOw9GMeK1Kr3JH9c27h7xnIe6MhGQXBIxCkL+fB4h2QWlzVt3NPJrTed
 qUWVisWin4L4YwSjoAadqGDyE4PH7QcTIuKMBKCL5/kftRYfUDy/sBXO5yjVlMPY71s1DW41V
 DlANxhci89pNQp7/zvXgECKrDw//HM7c4jDGEH/rU1kG810z1rJy4r7Ru/TIu3vtH/hv/OBCw
 AMdk11UWL5P2CAot5+vqVELxksPqA1bJK6qqoB0ZYM++QS3QmisSo2Xd4QPzeTDSu7KrzBMo+
 3gsanqZKP0zWfTj/aIkFdQ1NrZ1WAhDHe2qxEDfB+iJrzDiwY+Ghm6sPYCefI/th//GOUyaii
 63kq6bKOJex6wpLFHEk9gVVuG2uwQNyvuGrXpS1vYha1wp9CA54OI7uBBMthKPYNjz9tK52W4
 0P18kufEdoGgVt0Jet6g==
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

I have test on 5.8.X,=C2=A0 but it doesn't help. I test on the same config=
 on another server(480G SSD + 8T HDD),

it can't reproduce, this really made me confused. I will compare the confi=
gs and try to find out the diffs.

Thanks.

Norman

>
> Thanks.
>
> Coly Li
