Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD4561397
	for <lists+linux-bcache@lfdr.de>; Thu, 30 Jun 2022 09:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiF3HsB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 30 Jun 2022 03:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiF3HsB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 30 Jun 2022 03:48:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354D13B2B8
        for <linux-bcache@vger.kernel.org>; Thu, 30 Jun 2022 00:48:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EBDAB1F98B;
        Thu, 30 Jun 2022 07:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656575278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtVzkSiuO9CXpp77yEYTET5W6yapA+7vlZqrwlCGzR4=;
        b=J/RBA1KIgN4PT06ALEaDNh4x/6k8PjQxYxs2QSJ/YPIWdaq/eVOlhyleT1dGs3mDhFUV6D
        rTJtu6upEcDazdrcaTLmrglNRNjawzBr31a3JiUSH90vp5q1TMt5bI7JH2Nadn8QgD2SNh
        LHdRnY9jj9e/eXPPmt6goW0/LydUTJs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656575278;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vtVzkSiuO9CXpp77yEYTET5W6yapA+7vlZqrwlCGzR4=;
        b=YfGW3JFO/9YTaA1/HKvKS7059Z8bfjq7RcESCNPH5kouz8HCdb6Q+RGdOZSsBHyF7rClEj
        xTMCuX8nuu1JwVCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 30C5113A5C;
        Thu, 30 Jun 2022 07:47:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xFFpOy1VvWILOAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 30 Jun 2022 07:47:57 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: bcache I/O performance tests on 5.15.0-40-generic
From:   Coly Li <colyli@suse.de>
In-Reply-To: <CAC6jXv1mHjUO8OZ8W0LJkH-z8dQ=hZkk9Au8NVTFLfSj2J88zg@mail.gmail.com>
Date:   Thu, 30 Jun 2022 15:47:55 +0800
Cc:     linux-bcache@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <17866A38-10B2-42E9-931E-84EA5656D560@suse.de>
References: <CAC6jXv0FoE60HEuc7tDMXEA27hkoMkZm5d6gt4NCRkAh2w3WvA@mail.gmail.com>
 <8C0D66FE-FF1D-469D-A209-10E95F79D2FA@suse.de>
 <CAC6jXv18FhR9M9ckSrYOe+vzhQe022VfPb4dWaY7AnSn1M7qfg@mail.gmail.com>
 <CAC6jXv0yOZ98XqG=quDcONuZ9ggqK4doM8EzVTc=Sk1m-H=_Xw@mail.gmail.com>
 <F1BAF641-4818-4574-8467-3CD0AC3E8DE7@suse.de>
 <CAC6jXv2u_0s-hvj4J4gurfoxgKNHFcHYq9F8cfcf-s6oG+pU+Q@mail.gmail.com>
 <E5629229-E51D-470F-9A6E-53434EF9F7FF@suse.de>
 <CAC6jXv1mHjUO8OZ8W0LJkH-z8dQ=hZkk9Au8NVTFLfSj2J88zg@mail.gmail.com>
To:     Nikhil Kshirsagar <nkshirsagar@gmail.com>
X-Mailer: Apple Mail (2.3696.100.31)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 15:39=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Yes, I understand, but if you see the graphs, for a 12gb random write
> IO (with a 15gb SSD, so enough cache in theory for entire write),
> bcache gets speeds very close to SLOW DISK! (3MB/s consistently, while
> dmcache gets 400mb/s consistently except the first run where it "warms
> up"), so that is why I wanted to understand whether there's any
> tunable to get the "close to ssd" or even 300-400MB/s speed (ssd speed
> is 500mb/s avg)
>=20
> Regards,
> Nikhil.


Every time when around 900MB data written into cache device, gc thread =
will be triggered awake to work. And when the dirty data exceeds around =
1.5G, writeback thread will start and throttle front end write speed. =
With more dirty data, more throttle for front end I/Os. And when dirty =
data exceeds 70% cache size, which is around 10.5G in your case, all =
following I/Os will go directly into backing device and not synced.

I guess this is why you may observe slow I/O speed for your testing, =
which looks like as expected IMHO.

Coly Li


>=20
>=20
> On Thu, 30 Jun 2022 at 13:06, Coly Li <colyli@suse.de> wrote:
>>=20
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 15:26=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> Thank you for the clarification. But my testing results show that =
even with 15GB cache device, if I write 12gb, it still slow down, so you =
do not get  "close to ssd" speed for such IO write.. even if its smaller =
than cache size.
>>>=20
>>> Attached results of testing comparing dm-cache with bcache. command =
used was "fio --rw=3Drandwrite --size=3D12G --ioengine=3Dlibaio =
--direct=3D1 --gtod_reduce=3D1 --iodepth=3D128 --bs=3D4k"
>>>=20
>>>=20
>>=20
>> I cannot tell why dmcache is so good from your performance number. =
But if the peak write speed is around 550MB/s, it may take around 20 =
seconds. What happens if the I/O testing may take longer, e.g. 1 hours?
>>=20
>> BTW, people cannot get =E2=80=9Cclose to ssd=E2=80=9D speed on =
bcache, for each write/read I/O request, bcache will update B+tree =
index, cache data, write journal, and maybe split B+tree node, and the =
I/O procedure might be interfered by I/Os from gc and writeback. So it =
is good enough, but cannot be close to SSD speed.
>>=20
>> Coly Li
>>=20
>>>=20
>>>=20
>>> -Nikhil.
>>>=20
>>> On Thu, 30 Jun 2022 at 12:19, Coly Li <colyli@suse.de> wrote:
>>>>=20
>>>>=20
>>>>=20
>>>>> 2022=E5=B9=B46=E6=9C=8830=E6=97=A5 13:07=EF=BC=8CNikhil Kshirsagar =
<nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>=20
>>>>> HI Coly,
>>>>>=20
>>>>> even after turning it on by echo 1 into
>>>>> /sys/fs/bcache/<UUID>/internal/gc_after_writeback
>>>>=20
>>>> gc_after_writeback is a switch to triger a gc operation when =
writeback finished to flush all dirty data to backing device. Which =
might be good for future writing I/Os.
>>>> It doesn=E2=80=99t help to gc performance.
>>>>=20
>>>>=20
>>>>=20
>>>>>=20
>>>>> I still see [bcache_gc] threads appear about 70% into writing the =
8 gb
>>>>> IO into 10 gb cache.. so with the result that 8gb write takes very
>>>>> long, in spite of having more than enough ssd cache for it..
>>>>>=20
>>>>=20
>>>> This is as designed. Gc thread is triggered when every 1/16 cache =
space is used, if there is no gc, the whole bcache process is very =
probably to be locked up, due to no space for meta-data or cached data.
>>>>=20
>>>> This is why I suggest a larger cache device. And gc is unavoidable, =
when cache device is small, all allocation will wait for gc to make more =
free room. And in order to make more available free space, the dirty =
sectors should be written back to backing device, which is why you see =
everything is slow down.
>>>>=20
>>>>=20
>>>> Coly Li
>>>>=20
>>>>=20
>>>>=20
>>>>> Regards,
>>>>> Nikhil.
>>>>>=20
>>>>> On Thu, 30 Jun 2022 at 09:54, Nikhil Kshirsagar =
<nkshirsagar@gmail.com> wrote:
>>>>>>=20
>>>>>> Thanks Coly!
>>>>>>=20
>>>>>> Can garbage collection be turned off, by echo 1 into
>>>>>> /sys/fs/bcache/<UUID>/internal/gc_after_writeback ?
>>>>>>=20
>>>>>> The issue I'm seeing is, garbage collection causes write =
performance
>>>>>> (writeback mode) to drop whenever the cache gets 50% full.
>>>>>>=20
>>>>>> With a 10gb cache device, an 8 GB write (using fio randwrite) =
should
>>>>>> give SSD like speed, but it does not. I am wondering if its due =
to the
>>>>>> gc threads.
>>>>>>=20
>>>>>> Regards,
>>>>>> Nikhil.
>>>>>>=20
>>>>>> On Sat, 25 Jun 2022 at 17:38, Coly Li <colyli@suse.de> wrote:
>>>>>>>=20
>>>>>>>=20
>>>>>>>=20
>>>>>>>> 2022=E5=B9=B46=E6=9C=8825=E6=97=A5 14:29=EF=BC=8CNikhil =
Kshirsagar <nkshirsagar@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>>>>>=20
>>>>>>>> Hello,
>>>>>>>>=20
>>>>>>>> I've been doing some performance tests of bcache on =
5.15.0-40-generic.
>>>>>>>>=20
>>>>>>>> The baseline figures for the fast and slow disk for random =
writes are
>>>>>>>> consistent at around 225MiB/s and 3046KiB/s.
>>>>>>>>=20
>>>>>>>> But the bcache results inexplicably drop sometimes to 10Mib/s, =
for
>>>>>>>> random write test using fio like this -
>>>>>>>>=20
>>>>>>>> fio --rw=3Drandwrite --size=3D1G --ioengine=3Dlibaio --direct=3D1=

>>>>>>>> --gtod_reduce=3D1 --iodepth=3D128 --bs=3D4k --name=3DMY_TEST1
>>>>>>>>=20
>>>>>>>> WRITE: bw=3D168MiB/s (176MB/s), 168MiB/s-168MiB/s =
(176MB/s-176MB/s),
>>>>>>>> io=3D1024MiB (1074MB), run=3D6104-6104msec
>>>>>>>> WRITE: bw=3D283MiB/s (297MB/s), 283MiB/s-283MiB/s =
(297MB/s-297MB/s),
>>>>>>>> io=3D1024MiB (1074MB), run=3D3621-3621msec
>>>>>>>> WRITE: bw=3D10.3MiB/s (10.9MB/s), 10.3MiB/s-10.3MiB/s
>>>>>>>> (10.9MB/s-10.9MB/s), io=3D1024MiB (1074MB), run=3D98945-98945msec=

>>>>>>>> WRITE: bw=3D8236KiB/s (8434kB/s), 8236KiB/s-8236KiB/s
>>>>>>>> (8434kB/s-8434kB/s), io=3D1024MiB (1074MB), =
run=3D127317-127317msec
>>>>>>>> WRITE: bw=3D9657KiB/s (9888kB/s), 9657KiB/s-9657KiB/s
>>>>>>>> (9888kB/s-9888kB/s), io=3D1024MiB (1074MB), =
run=3D108587-108587msec
>>>>>>>> WRITE: bw=3D4543KiB/s (4652kB/s), 4543KiB/s-4543KiB/s
>>>>>>>> (4652kB/s-4652kB/s), io=3D1024MiB (1074MB), =
run=3D230819-230819msec
>>>>>>>>=20
>>>>>>>> This seems to happen after 2 runs of 1gb writes (cache disk is =
4gb size)
>>>>>>>>=20
>>>>>>>> Some details are here - https://pastebin.com/V9mpLCbY , I will =
share
>>>>>>>> the full testing results soon, but just was wondering about =
this
>>>>>>>> performance drop for no apparent reason once the cache gets =
about 50%
>>>>>>>> full.
>>>>>>>=20
>>>>>>>=20
>>>>>>> It seems you are stuck by garbage collection. 4GB cache is =
small, the garbage collection might be invoked quite frequently. Maybe =
you can see the output of =E2=80=99top -H=E2=80=99 to check whether =
there is kernel thread named bache_gc.
>>>>>>>=20
>>>>>>> Anyway, 4GB cache is too small.
>>>>>>>=20
>>>>>>> Coly Li
>>>>>>>=20
>>>>=20
>>=20

