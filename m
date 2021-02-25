Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE67B3248DC
	for <lists+linux-bcache@lfdr.de>; Thu, 25 Feb 2021 03:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbhBYCXm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 24 Feb 2021 21:23:42 -0500
Received: from mout.gmx.net ([212.227.17.22]:43307 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhBYCXm (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 24 Feb 2021 21:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614219728;
        bh=6hUOQX6f82gvMuxzwmg2FCHNDbFWHryypB+CZ1EUbbo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=TVYYelE2dEVWgavpx4U+cS73R9uoiSqBHPl5K+AypC2h7jl3eCOCGuw9D2DdpMuXW
         ISRoxXoUlxYcE6jaXcvj9+vr7tetDZknVZ+OtcvfVgWo8pTbqo5UUdBmosCLy9IfKG
         vyR87nZgojOLq5n9AjPAjQVFwp3hQ2C3XPe7ZYiE=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [10.10.213.91] ([103.52.188.137]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MvbG2-1m4SWP3u8E-00si9B; Thu, 25
 Feb 2021 03:22:08 +0100
Subject: Re: Large latency with bcache for Ceph OSD
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, axboe@kernel.dk,
        linux-bcache@vger.kernel.org
References: <3f3e20a3-c165-1de1-7fdd-f0bd4da598fe@gmx.com>
 <632258f7-b138-3fba-456b-9da37c1de710@gmx.com>
 <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
From:   "Norman.Kern" <norman.kern@gmx.com>
Message-ID: <d8f5aa09-ab43-bc03-8316-13fc0f3cde78@gmx.com>
Date:   Thu, 25 Feb 2021 10:22:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <5867daf1-0960-39aa-1843-1a76c1e9a28d@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:Mh5Bz/vVOrfBgI71gdpeQQvMvy70IjURIM0sERzPMcl1NoeSSUb
 6EswDjfcxi4y2K7CjzOBVQuamQCJprTOF0kTo/wdl8mgi5+Uu4oC2cOK2Mb/SfJ05Fr1HcK
 GNsGCKFcCPUQimqvk+YqpLyoz5R35lR1crhcafD4D+FUoWdHm6qGSLRce+Jv0gUTq8Vfyyh
 EZbCyO0atausQum9T1uWg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LSjSPGqandc=:ze0YSHsStnRpx6Elq3tJYo
 qv7+OmkjlZaVQByJYrSAPd1r+A5LKOh5r/LuG0maJLurTBOYykeqyRVubuCFJAGVc2VGr97zr
 rIFCHBj39EiaY0SlSwWVrsOH6U0aHkm3Y6rqlaqZjuhherjntOOMsYG3CTa2/XGfsHZwPKLet
 S0Cg9iK4WYvde032oUQ8hwEMfxj/E+yqMRWOt2s3rN0Afxqij5VUZtMhASXs4Jysgkou466w+
 1yxkk6yeEpe7kDOw6Gu9gOfGJENjVP+rIiPodkXW+CKXBEQ7vySF/46cz34O+kPox+94KRD+G
 LeGzsPrg2IcIGGEhbT56+K4lkf6bx8vdT2AHCvJJo2sy/3is98CzUd3eDWd5XHf48VlMIEVrk
 aIrglAfqnRyAAGIMgtocm5W9o73f4PAtlMsCZNH9zn6evRYf27gEvH0ummqOBf4PUicWgy5ts
 LqUlAhdNa/iZkMngRlSEcw7qeUehQQCYz2OMjhidTQU86G0gqch71MNiIRHzuWyS95LeLMJth
 pSLpEinQIUbXGkZlFmoiKQ4dH1T+owF6bw8W+3H8cCAL7E9NauqA2KFs7Jf14aJ0z02DCoQfv
 05ByW/JLTchDWEgxSdunTUDUqi6cFRIXg1hG84hcVis91BJLjr8SgNGwa0WKspTeO2k8/6Nvl
 MqT1zCNNsmUs7cRyFczTfJgxBB6jPYmR2+XeNbnUK+WWuBNPOT7XFIwp05mbiteBDvMIqIEY+
 EqPKvZNatLFjkFLAUqnsctmeTBFiyt7yhYn+QSa8Ovi5ffu1E1MFyLuwqzB+hvUXjzXWVfN+i
 oDuh6TvlLqfjEqFEphMZF6aal3/BTKi7dAIES6DSe54pgA2ptc5PH9yIakcCzNc5FqkRFpkBD
 sufbZUkUAahoXTcIYtsg==
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


On 2021/2/24 =E4=B8=8B=E5=8D=884:52, Coly Li wrote:
> On 2/22/21 7:48 AM, Norman.Kern wrote:
>> Ping.
>>
>> I'm confused on the SYNC I/O on bcache. why SYNC I/O must be writen bac=
k
>> for persistent cache?=C2=A0 It can cause some latency.
>>
>> @Coly, can you give help me to explain why bcache handle O_SYNC like th=
is.?
>>
>>
> Hmm, normally we won't observe the application issuing I/Os on backing
> device except for,
> - I/O bypass by SSD congestion
> - Sequential I/O request
> - Dirty buckets exceeds the cutoff threshold
> - Write through mode
>
> Do you set the write/read congestion threshold to 0 ?

Thanks for you reply.

I have set the threshold to zero, all configs:

#make-bcache -C -b 4m -w 4k --discard --cache_replacement_policy=3Dlru /de=
v/sdm
#make-bcache -B --writeback -w 4KiB /dev/sdn --wipe-bcache
congested_read_threshold_us =3D 0
congested_write_threshold_us =3D 0

# I tried to set sequential_cutoff to 0, but it didn't solve it.

sequential_cutoff =3D 4194304
writeback_percent =3D 40
cache_mode =3D writeback

I renew the cluster=EF=BC=8C run for hours and reproduced the problem. I c=
heck the cache status:

root@WXS0106:/root/perf-tools# cat /sys/fs/bcache/d87713c6-2e76-4a09-8517-=
d48306468659/cache_available_percent
29
root@WXS0106:/root/perf-tools# cat /sys/fs/bcache/d87713c6-2e76-4a09-8517-=
d48306468659/internal/cutoff_writeback_sync
70
'Dirty buckets exceeds the cutoff threshold' caused the problem, is my con=
fig wrong or other reasons?

>
> Coly Li
>
>> On 2021/2/18 =E4=B8=8B=E5=8D=883:56, Norman.Kern wrote:
>>> Hi guys,
>>>
>>> I am testing ceph with bcache, I found some I/O with O_SYNC writeback
>>> to HDD, which caused large latency on HDD, I trace the I/O with iosnoo=
p:
>>>
>>> ./iosnoop=C2=A0 -Q -ts -d '8,192
>>>
>>> Tracing block I/O for 1 seconds (buffered)...
>>> STARTs=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ENDs=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 COMM=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 PID=C2=A0=C2=A0=C2=A0 TYPE DEV
>>> BLOCK=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BYTES=C2=A0=C2=A0=C2=
=A0=C2=A0 LATms
>>>
>>> 1809296.292350=C2=A0 1809296.319052=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578940240=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 26.70
>>> 1809296.292330=C2=A0 1809296.320974=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4577938704=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 28.64
>>> 1809296.292614=C2=A0 1809296.323292=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4600404304=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 30.68
>>> 1809296.292353=C2=A0 1809296.325300=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578343088=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 32.95
>>> 1809296.292340=C2=A0 1809296.328013=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578055472=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 35.67
>>> 1809296.292606=C2=A0 1809296.330518=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578581648=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 37.91
>>> 1809295.169266=C2=A0 1809296.334041=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 4244996360=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1164.78
>>> 1809296.292618=C2=A0 1809296.336349=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4602631760=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 43.73
>>> 1809296.292618=C2=A0 1809296.338812=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4602632976=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 46.19
>>> 1809296.030103=C2=A0 1809296.342780=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22180=C2=A0 WS=C2=A0=C2=A0 8,192
>>> 4741276048=C2=A0=C2=A0 131072=C2=A0=C2=A0 312.68
>>> 1809296.292347=C2=A0 1809296.345045=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4609037872=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 52.70
>>> 1809296.292620=C2=A0 1809296.345109=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4609037904=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 52.49
>>> 1809296.292612=C2=A0 1809296.347251=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578937616=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 54.64
>>> 1809296.292621=C2=A0 1809296.351136=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4612654992=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 58.51
>>> 1809296.292341=C2=A0 1809296.353428=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578220656=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 61.09
>>> 1809296.292342=C2=A0 1809296.353864=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578220880=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 61.52
>>> 1809295.167650=C2=A0 1809296.358510=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 4923695960=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1190.86
>>> 1809296.292347=C2=A0 1809296.361885=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4607437136=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 69.54
>>> 1809296.029363=C2=A0 1809296.367313=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22180=C2=A0 WS=C2=A0=C2=A0 8,192
>>> 4739824400=C2=A0=C2=A0 98304=C2=A0=C2=A0=C2=A0 337.95
>>> 1809296.292349=C2=A0 1809296.370245=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4591379888=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 77.90
>>> 1809296.292348=C2=A0 1809296.376273=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4591289552=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 83.92
>>> 1809296.292353=C2=A0 1809296.378659=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4578248656=C2=A0=C2=A0 16384=C2=A0=C2=A0=C2=A0=C2=A0 86.31
>>> 1809296.292619=C2=A0 1809296.384835=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4617494160=C2=A0=C2=A0 65536=C2=A0=C2=A0=C2=A0=C2=A0 92.22
>>> 1809295.165451=C2=A0 1809296.393715=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 1355703120=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1228.26
>>> 1809295.168595=C2=A0 1809296.401560=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 1122200=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1232.96
>>> 1809295.165221=C2=A0 1809296.408018=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 960656=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1242=
.80
>>> 1809295.166737=C2=A0 1809296.411505=C2=A0 bstore_kv_fi 17266=C2=A0 WS=
=C2=A0=C2=A0 8,192
>>> 57682504=C2=A0=C2=A0=C2=A0=C2=A0 4096=C2=A0=C2=A0=C2=A0 1244.77
>>> 1809296.292352=C2=A0 1809296.418123=C2=A0 tp_osd_tp=C2=A0=C2=A0=C2=A0 =
22191=C2=A0 R=C2=A0=C2=A0=C2=A0 8,192
>>> 4579459056=C2=A0=C2=A0 32768=C2=A0=C2=A0=C2=A0 125.77
>>>
>>> I'm confused why write with O_SYNC must writeback on the backend
>>> storage device?=C2=A0 And when I used bcache for a time,
>>>
>>> the latency increased a lot.(The SSD is not very busy), There's some
>>> best practices on configuration?
>>>
