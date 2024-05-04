Return-Path: <linux-bcache+bounces-426-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B478BB926
	for <lists+linux-bcache@lfdr.de>; Sat,  4 May 2024 04:05:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4899BB20D08
	for <lists+linux-bcache@lfdr.de>; Sat,  4 May 2024 02:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4F06539C;
	Sat,  4 May 2024 02:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dFFfbDnE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DC210D
	for <linux-bcache@vger.kernel.org>; Sat,  4 May 2024 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714788297; cv=none; b=eEIt8G2bFOcrK/Uw9lQ9hyTveUJmbNsYNmjt5lTm3mU84p4aBMYmiLOJFhHQ8PbL7+/t6WQW4hxWXEtcM8YHmBDdQsPkap8wEEvByuvZplqu2LrLOog0d8DoYxxn3gb0cwsH1+In+OghYR/IGP/1sli4uVRubyh+jd4V1cYiI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714788297; c=relaxed/simple;
	bh=7lTbR25TU/d+Z9Osi1a0rpHKrR4f1Fsv5dB0zDQEFTU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UdGFNja/NXIYU7+DD46aCdQPEtG9fLQpamkMjc0VK0etGomVeva20tpgum6TZhAmEo3n8Tg33W9bUG+/9wdUcCregFh6U6FvrPDhMA+A9dqAUyrlSrijzuiOR8V8knpjZ5NHFok3JVsR0o0fSTEj+7pTtqzbs9ftNsDeVhuXNtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dFFfbDnE; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-41bff91ecdcso15195e9.1
        for <linux-bcache@vger.kernel.org>; Fri, 03 May 2024 19:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714788294; x=1715393094; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/BOQObgWQycCIMnV+f3nznv5WyajhvWVZjMqyX1mspk=;
        b=dFFfbDnE8m8zeTvLYlTkoZ1mclz2nDbvJKw95zDFj2jNgrTuKygkaS/gHpG4skMoOP
         Npx85oLefUEjWLE+kfHCOuNgqa8EI3NJm8I6aMQQLzAktVLtCGyFP5XY+uARr3JxTqny
         /Rf8kwmGgSrROtgpZdr312j8JdphsT757Fg0SbI3v/qdEuYAmkQMcCEb7fWoaQPOI1QN
         Hkx26VBnd6Wyt1fR9Lz5cQlKlM3TuKFXSBdLZVq4358If15txmV6tAtpQEeNX8CErlGE
         d9Omts3iki2ekTUEhwJ/vRtRCBfjfyHLLEa+t9wHumsfiX7JKuA/jsBKWjg1bdDtAueT
         OJzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714788294; x=1715393094;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BOQObgWQycCIMnV+f3nznv5WyajhvWVZjMqyX1mspk=;
        b=tNgmzT3ZBoFhq/4xJ7v2ZLDToyRAjytpY+j14Zk1a2Uc2aHflxdlbuEULDlgtXUMJL
         MdCNyjkPnKeq2VE0TR7J4g5UX5EZcZGp2CLHBFn+1yDYquQCE89GqvoTE7R8XFlWf0IR
         3FB9DOy4AXTLgKfHDJefMXe0ekbRgl9bZYWRpjbNCzfzQf0s2kykLEqE51mtfpj/bJo+
         HYK9Wj8O3pDxr+AeOnZQfYIELW5qUVkVotrMTDk6nA3y51657unsrCQMLFjIMRLJVhqr
         E9QNYeEQd93GXU34VzFAznrWSlpTyZ5+jQi7R94i0NaMA1dy7IzpsoFJEFDDtm32vsjZ
         bXuA==
X-Forwarded-Encrypted: i=1; AJvYcCXOLH1Q+S9V0cXtwBv0JgPehTVabaEK3/2WstE0zO33pZmbY+jSl/gQ9jIg/I08Satq490KM1/D56knlGPW4ABrge674pXoWW0ktmhv
X-Gm-Message-State: AOJu0YwDJqAxBztXDK2z3cTVBKdrGqB8CUYfWK9TlWwmhG/dSIzhPnHc
	KlGgiy/nhIn8HfLq0Ck4++cSRwtfklalsn0Hlpj0HfdJAg/fuobk1winoOwr+gCDWk5V6U1MjmL
	82OF+uH28AKwtfuKRfJZobAYVljdYe0Z50gdjEq6yOXgghJY7fZEx
X-Google-Smtp-Source: AGHT+IG3vwfRRN8r/zRLXwTRPZ032sRDegOz0s3UqpBX2KiERFDzejdFEuqQFsyAtjI/JkLXQO/0RpTYBFxy7Xu1TBs=
X-Received: by 2002:a05:600c:450e:b0:419:fa3c:fb46 with SMTP id
 5b1f17b1804b1-41e62e2afa1mr465185e9.5.1714788293795; Fri, 03 May 2024
 19:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1ddde040-9bde-515a-1d4d-b41de472a702@suse.de> <20240315224527.694458-1-robertpang@google.com>
 <584A2724-ACA2-4000-A8D2-50B6AA5684A7@suse.de> <CAJhEC06dsqq2y4MNCW7t52cPc1=PbStGTBOddZofg4vqGKkQsA@mail.gmail.com>
 <5B79FFA6-1995-4167-8318-3EDCC6F0B432@suse.de> <CAJhEC07hAWsW5Aq0=hCCAXJGKU47L_n8a0mQ-SjOq2wqGAj_gA@mail.gmail.com>
 <CAJhEC05TrboyqKAn0i5D72LWBs7bZ05qFrPedgmNWy8A7qYmOA@mail.gmail.com>
 <C787D2E8-6D03-4F4D-9633-2237AA0B2BE7@suse.de> <CAJhEC05hzf2zVyJabVExFNF0esiLovc+WLHOY_YhV22OUdGFZw@mail.gmail.com>
 <5C71FFC2-B22E-4FC2-852F-F40BFDEDFB2C@suse.de> <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
In-Reply-To: <C659682B-4EAB-4022-A669-1574962ECE82@suse.de>
From: Robert Pang <robertpang@google.com>
Date: Fri, 3 May 2024 19:04:41 -0700
Message-ID: <CAJhEC04+VUKqUpMfACF0pSiwtdaJaOsb50dp_VbyhahPS6KE5A@mail.gmail.com>
Subject: Re: [PATCH v2] bcache: allow allocator to invalidate bucket in gc
To: Coly Li <colyli@suse.de>
Cc: Dongsheng Yang <dongsheng.yang@easystack.cn>, 
	Bcache Linux <linux-bcache@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000001ef5070617974308"

--0000000000001ef5070617974308
Content-Type: multipart/alternative; boundary="0000000000001ef5050617974306"

--0000000000001ef5050617974306
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,

> Can I know In which kernel version did you test the patch?

I tested in both Linux kernels 5.10 and 6.1.

> I didn=E2=80=99t observe obvious performance advantage of this patch.

This patch doesn't improve bcache performance. Instead, it eliminates the
IO stall in bcache that happens due to bch_allocator_thread() getting
blocked and waiting on GC to finish when GC happens.

/*
* We've run out of free buckets, we need to find some buckets
* we can invalidate. First, invalidate them in memory and add
* them to the free_inc list:
*/
retry_invalidate:
allocator_wait(ca, ca->set->gc_mark_valid &&  <--------
       !ca->invalidate_needs_gc);
invalidate_buckets(ca);

From what you showed, it looks like your rebase is good. As you
already noticed, the original patch was based on 4.x kernel so the bucket
traversal in btree.c needs to be adapted for 5.x and 6.x kernels. I
attached the patch rebased to 6.9 HEAD for your reference.

But to observe the IO stall before the patch, please test with a read-write
workload so GC will happen periodically enough (read-only or read-mostly
workload doesn't show the problem). For me, I used the "fio" utility to
generate a random read-write workload as follows.

# Pre-generate a 900GB test file
$ truncate -s 900G test

# Run random read-write workload for 1 hour
$ fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dlibaio
--name=3Dlatency_test --filename=3Dtest --bs=3D8k --iodepth=3D1 --size=3D90=
0G
 --readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_lat_log=3Dlat
--log_avg_msec=3D1000 --log_max_value=3D1

We include the flags "--write_lat_log=3Dlat --log_avg_msec=3D1000
--log_max_value=3D1" so fio will dump the second-by-second max latency into=
 a
log file at the end of test so we can when stall happens and for how long:

E.g.

$ more lat_lat.1.log
(format: <time-ms>,<max-latency-ns>,,,)
...
777000, 5155548, 0, 0, 0
778000, 105551, 1, 0, 0
802615, 24276019570, 0, 0, 0 <---- stalls for 24s with no IO possible
802615, 82134, 1, 0, 0
804000, 9944554, 0, 0, 0
805000, 7424638, 1, 0, 0

I used a 375 GB local SSD (cache device) and a 1 TB network-attached
storage (backing device). In the 1-hr run, GC starts happening about 10
minutes into the run and then happens at ~ 5 minute intervals. The stall
duration ranges from a few seconds at the beginning to close to 40 seconds
towards the end. Only about 1/2 to 2/3 of the cache is used by the end.

Note that this patch doesn't shorten the GC either. Instead, it just avoids
GC from blocking the allocator thread by first sweeping the buckets and
marking reclaimable ones quickly at the beginning of GC so the allocator
can proceed while GC continues its actual job.

We are eagerly looking forward to this patch to be merged in this coming
merge window that is expected to open in a week to two.

Thanks
Robert


On Fri, May 3, 2024 at 11:28=E2=80=AFAM Coly Li <colyli@suse.de> wrote:

>
>
> > 2024=E5=B9=B45=E6=9C=884=E6=97=A5 02:23=EF=BC=8CColy Li <colyli@suse.de=
> =E5=86=99=E9=81=93=EF=BC=9A
> >
> >
> >
> >> 2024=E5=B9=B44=E6=9C=8811=E6=97=A5 14:44=EF=BC=8CRobert Pang <robertpa=
ng@google.com> =E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> HI Coly
> >>
> >> Thank you for submitting it in the next merge window. This patch is
> >> very critical because the long IO stall measured in tens of seconds
> >> every hour is a serious issue making bcache unusable when it happens.
> >> So we look forward to this patch.
> >>
> >> Speaking of this GC issue, we gathered the bcache btree GC stats after
> >> our fio benchmark on a 375GB SSD cache device with 256kB bucket size:
> >>
> >> $ grep .
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_*
> >>
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_ave=
rage_duration_ms:45293
> >>
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_ave=
rage_frequency_sec:286
> >>
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_las=
t_sec:212
> >>
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_gc_max=
_duration_ms:61986
> >> $ more
> /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree_nodes
> >> 5876
> >>
> >> However, fio directly on the SSD device itself shows pretty good
> performance:
> >>
> >> Read IOPS 14,100 (110MiB/s)
> >> Write IOPS 42,200 (330MiB/s)
> >> Latency: 106.64 microseconds
> >>
> >> Can you shed some light on why CG takes so long (avg 45 seconds) given
> >> the SSD speed? And is there any way or setting to reduce the CG time
> >> or lower the GC frequency?
> >>
> >> One interesting thing we observed is when the SSD is encrypted via
> >> dm-crypt, the GC time is shortened ~80% to be under 10 seconds. Is it
> >> possible that GC writes the blocks one-by-one synchronously, and
> >> dm-crypt's internal queuing and buffering mitigates the GC IO latency?
> >
> > Hi Robert,
> >
> > Can I know In which kernel version did you test the patch?
> >
>
> Sorry I missed a bit more information here.
>
> > I do a patch rebase and apply it on Linux v6.9. With a 4TB SSD as cache
> device, I didn=E2=80=99t observe obvious performance advantage of this pa=
tch.
>
> When I didn=E2=80=99t see obvious performance advantage, the testing was =
on a 512G
> Intel Optane memory (with pmem driver) as cache device.
>
>
> > And occasionally I a bit more GC time. It might be from my rebase
> modification in bch_btree_gc_finish(),
>
> And for the above situation, it was on a 4TB NVMe SSD.
>
>
> I guess maybe it was from my improper patch rebase. Once Dongsheng posts =
a
> new version for the latest upstream kernel bcache code, I will test the
> patch again.
>
>
> Thanks.
>
> Coly Li

--0000000000001ef5050617974306
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Coly,<br><br>&gt; Can I know In which kernel version di=
d you test the patch?<br><br>I tested in both Linux kernels 5.10 and 6.1.<b=
r><br>&gt; I didn=E2=80=99t observe obvious performance advantage of this p=
atch.<br><br>This patch doesn&#39;t improve bcache performance. Instead, it=
 eliminates the IO stall in bcache that happens due to bch_allocator_thread=
() getting blocked and waiting on GC to finish when GC happens.<br><br>/*<b=
r>* We&#39;ve run out of free buckets, we need to find some buckets<br>* we=
 can invalidate. First, invalidate them in memory and add<br>* them to the =
free_inc list:<br>*/<br>retry_invalidate:<br>allocator_wait(ca, ca-&gt;set-=
&gt;gc_mark_valid &amp;&amp; =C2=A0&lt;--------<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0!ca-&gt;invalidate_needs_gc);<br>invalidate_buckets(ca);<br><br>From wha=
t you showed, it looks like your rebase is good. As you already=C2=A0notice=
d, the original patch was based on 4.x kernel so the bucket traversal in bt=
ree.c needs to be adapted for 5.x and 6.x kernels. I attached the patch reb=
ased to 6.9 HEAD for your reference.<div><br><div>But to observe the IO sta=
ll before the patch, please test with a read-write workload so GC will happ=
en periodically enough (read-only or read-mostly workload doesn&#39;t show =
the problem). For me, I used the &quot;fio&quot; utility to generate a rand=
om read-write workload as follows.<br><br># Pre-generate a 900GB test file<=
br>$ truncate -s 900G test<br><br># Run random read-write workload for 1 ho=
ur<br>$ fio --time_based --runtime=3D3600s --ramp_time=3D2s --ioengine=3Dli=
baio --name=3Dlatency_test --filename=3Dtest --bs=3D8k --iodepth=3D1 --size=
=3D900G =C2=A0--readwrite=3Drandrw --verify=3D0 --filename=3Dfio --write_la=
t_log=3Dlat --log_avg_msec=3D1000 --log_max_value=3D1 <br><br>We include th=
e flags &quot;--write_lat_log=3Dlat --log_avg_msec=3D1000 --log_max_value=
=3D1&quot; so fio will dump the second-by-second max latency into a log fil=
e at the end of test so we can when stall happens and for how long:<br><br>=
E.g.<br><br>$ more lat_lat.1.log<br>(format: &lt;time-ms&gt;,&lt;max-latenc=
y-ns&gt;,,,)<br>...<br>777000, 5155548, 0, 0, 0<br>778000, 105551, 1, 0, 0<=
br>802615, 24276019570, 0, 0, 0 &lt;---- stalls for 24s with no IO possible=
<br>802615, 82134, 1, 0, 0<br>804000, 9944554, 0, 0, 0<br>805000, 7424638, =
1, 0, 0<br><br>I used a 375 GB local SSD (cache device) and a 1 TB network-=
attached storage (backing device). In the 1-hr run, GC starts happening abo=
ut 10 minutes into the run and then happens at ~ 5 minute intervals. The st=
all duration ranges from a few seconds at the beginning to close to 40 seco=
nds towards the end. Only about 1/2 to 2/3 of the cache is used by the end.=
<br><br>Note that this patch doesn&#39;t shorten the GC either. Instead, it=
 just avoids GC from blocking the allocator thread by first sweeping the bu=
ckets and marking reclaimable ones quickly at the beginning of GC so the al=
locator can proceed while GC continues its actual job.<br><br>We are eagerl=
y looking forward to this patch to be merged in this coming merge window th=
at is expected to open in a week to two.</div></div><div><br></div><div>Tha=
nks</div><div>Robert</div></div><br><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Fri, May 3, 2024 at 11:28=E2=80=AFAM Coly =
Li &lt;<a href=3D"mailto:colyli@suse.de">colyli@suse.de</a>&gt; wrote:<br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
<br>
&gt; 2024=E5=B9=B45=E6=9C=884=E6=97=A5 02:23=EF=BC=8CColy Li &lt;<a href=3D=
"mailto:colyli@suse.de" target=3D"_blank">colyli@suse.de</a>&gt; =E5=86=99=
=E9=81=93=EF=BC=9A<br>
&gt; <br>
&gt; <br>
&gt; <br>
&gt;&gt; 2024=E5=B9=B44=E6=9C=8811=E6=97=A5 14:44=EF=BC=8CRobert Pang &lt;<=
a href=3D"mailto:robertpang@google.com" target=3D"_blank">robertpang@google=
.com</a>&gt; =E5=86=99=E9=81=93=EF=BC=9A<br>
&gt;&gt; <br>
&gt;&gt; HI Coly<br>
&gt;&gt; <br>
&gt;&gt; Thank you for submitting it in the next merge window. This patch i=
s<br>
&gt;&gt; very critical because the long IO stall measured in tens of second=
s<br>
&gt;&gt; every hour is a serious issue making bcache unusable when it happe=
ns.<br>
&gt;&gt; So we look forward to this patch.<br>
&gt;&gt; <br>
&gt;&gt; Speaking of this GC issue, we gathered the bcache btree GC stats a=
fter<br>
&gt;&gt; our fio benchmark on a 375GB SSD cache device with 256kB bucket si=
ze:<br>
&gt;&gt; <br>
&gt;&gt; $ grep . /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/inter=
nal/btree_gc_*<br>
&gt;&gt; /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree=
_gc_average_duration_ms:45293<br>
&gt;&gt; /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree=
_gc_average_frequency_sec:286<br>
&gt;&gt; /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree=
_gc_last_sec:212<br>
&gt;&gt; /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/internal/btree=
_gc_max_duration_ms:61986<br>
&gt;&gt; $ more /sys/fs/bcache/31c945a7-d96c-499b-945c-d76a1ab0beda/interna=
l/btree_nodes<br>
&gt;&gt; 5876<br>
&gt;&gt; <br>
&gt;&gt; However, fio directly on the SSD device itself shows pretty good p=
erformance:<br>
&gt;&gt; <br>
&gt;&gt; Read IOPS 14,100 (110MiB/s)<br>
&gt;&gt; Write IOPS 42,200 (330MiB/s)<br>
&gt;&gt; Latency: 106.64 microseconds<br>
&gt;&gt; <br>
&gt;&gt; Can you shed some light on why CG takes so long (avg 45 seconds) g=
iven<br>
&gt;&gt; the SSD speed? And is there any way or setting to reduce the CG ti=
me<br>
&gt;&gt; or lower the GC frequency?<br>
&gt;&gt; <br>
&gt;&gt; One interesting thing we observed is when the SSD is encrypted via=
<br>
&gt;&gt; dm-crypt, the GC time is shortened ~80% to be under 10 seconds. Is=
 it<br>
&gt;&gt; possible that GC writes the blocks one-by-one synchronously, and<b=
r>
&gt;&gt; dm-crypt&#39;s internal queuing and buffering mitigates the GC IO =
latency?<br>
&gt; <br>
&gt; Hi Robert,<br>
&gt; <br>
&gt; Can I know In which kernel version did you test the patch?<br>
&gt; <br>
<br>
Sorry I missed a bit more information here.<br>
<br>
&gt; I do a patch rebase and apply it on Linux v6.9. With a 4TB SSD as cach=
e device, I didn=E2=80=99t observe obvious performance advantage of this pa=
tch.<br>
<br>
When I didn=E2=80=99t see obvious performance advantage, the testing was on=
 a 512G Intel Optane memory (with pmem driver) as cache device.<br>
<br>
<br>
&gt; And occasionally I a bit more GC time. It might be from my rebase modi=
fication in bch_btree_gc_finish(),<br>
<br>
And for the above situation, it was on a 4TB NVMe SSD.<br>
<br>
<br>
I guess maybe it was from my improper patch rebase. Once Dongsheng posts a =
new version for the latest upstream kernel bcache code, I will test the pat=
ch again.<br>
<br>
<br>
Thanks.<br>
<br>
Coly Li</blockquote></div>

--0000000000001ef5050617974306--
--0000000000001ef5070617974308
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-bcache-allow-allocator-to-invalidate-bucket-in-gc.patch"
Content-Disposition: attachment; 
	filename="0001-bcache-allow-allocator-to-invalidate-bucket-in-gc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lvrg46lb0>
X-Attachment-Id: f_lvrg46lb0

LS0tCiBkcml2ZXJzL21kL2JjYWNoZS9hbGxvYy5jICB8IDExICsrKysrLS0tLS0tCiBkcml2ZXJz
L21kL2JjYWNoZS9iY2FjaGUuaCB8ICAxICsKIGRyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMgIHwg
MTEgKysrKysrKysrLS0KIDMgZmlsZXMgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgOCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL21kL2JjYWNoZS9hbGxvYy5jIGIvZHJpdmVy
cy9tZC9iY2FjaGUvYWxsb2MuYwppbmRleCBjZTEzYzI3MmMzODcuLjk4MmIzNmQxMjkwNyAxMDA2
NDQKLS0tIGEvZHJpdmVycy9tZC9iY2FjaGUvYWxsb2MuYworKysgYi9kcml2ZXJzL21kL2JjYWNo
ZS9hbGxvYy5jCkBAIC0xMjksMTIgKzEyOSwxMSBAQCBzdGF0aWMgaW5saW5lIGJvb2wgY2FuX2lu
Y19idWNrZXRfZ2VuKHN0cnVjdCBidWNrZXQgKmIpCiAKIGJvb2wgYmNoX2Nhbl9pbnZhbGlkYXRl
X2J1Y2tldChzdHJ1Y3QgY2FjaGUgKmNhLCBzdHJ1Y3QgYnVja2V0ICpiKQogewotCUJVR19PTigh
Y2EtPnNldC0+Z2NfbWFya192YWxpZCk7Ci0KLQlyZXR1cm4gKCFHQ19NQVJLKGIpIHx8CisJcmV0
dXJuICgoYi0+cmVjbGFpbWFibGVfaW5fZ2MgfHwgY2EtPnNldC0+Z2NfbWFya192YWxpZCkgJiYK
KwkJKCghR0NfTUFSSyhiKSB8fAogCQlHQ19NQVJLKGIpID09IEdDX01BUktfUkVDTEFJTUFCTEUp
ICYmCiAJCSFhdG9taWNfcmVhZCgmYi0+cGluKSAmJgotCQljYW5faW5jX2J1Y2tldF9nZW4oYik7
CisJCWNhbl9pbmNfYnVja2V0X2dlbihiKSkpOwogfQogCiB2b2lkIF9fYmNoX2ludmFsaWRhdGVf
b25lX2J1Y2tldChzdHJ1Y3QgY2FjaGUgKmNhLCBzdHJ1Y3QgYnVja2V0ICpiKQpAQCAtMTQ4LDYg
KzE0Nyw3IEBAIHZvaWQgX19iY2hfaW52YWxpZGF0ZV9vbmVfYnVja2V0KHN0cnVjdCBjYWNoZSAq
Y2EsIHN0cnVjdCBidWNrZXQgKmIpCiAJYmNoX2luY19nZW4oY2EsIGIpOwogCWItPnByaW8gPSBJ
TklUSUFMX1BSSU87CiAJYXRvbWljX2luYygmYi0+cGluKTsKKwliLT5yZWNsYWltYWJsZV9pbl9n
YyA9IDA7CiB9CiAKIHN0YXRpYyB2b2lkIGJjaF9pbnZhbGlkYXRlX29uZV9idWNrZXQoc3RydWN0
IGNhY2hlICpjYSwgc3RydWN0IGJ1Y2tldCAqYikKQEAgLTM1Miw4ICszNTIsNyBAQCBzdGF0aWMg
aW50IGJjaF9hbGxvY2F0b3JfdGhyZWFkKHZvaWQgKmFyZykKIAkJICovCiAKIHJldHJ5X2ludmFs
aWRhdGU6Ci0JCWFsbG9jYXRvcl93YWl0KGNhLCBjYS0+c2V0LT5nY19tYXJrX3ZhbGlkICYmCi0J
CQkgICAgICAgIWNhLT5pbnZhbGlkYXRlX25lZWRzX2djKTsKKwkJYWxsb2NhdG9yX3dhaXQoY2Es
ICFjYS0+aW52YWxpZGF0ZV9uZWVkc19nYyk7CiAJCWludmFsaWRhdGVfYnVja2V0cyhjYSk7CiAK
IAkJLyoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oIGIvZHJpdmVycy9t
ZC9iY2FjaGUvYmNhY2hlLmgKaW5kZXggNGU2YWZhODk5MjFmLi4xZDMzZTQwZDI2ZWEgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWQvYmNhY2hlL2JjYWNoZS5oCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hl
L2JjYWNoZS5oCkBAIC0yMDAsNiArMjAwLDcgQEAgc3RydWN0IGJ1Y2tldCB7CiAJdWludDhfdAkJ
Z2VuOwogCXVpbnQ4X3QJCWxhc3RfZ2M7IC8qIE1vc3Qgb3V0IG9mIGRhdGUgZ2VuIGluIHRoZSBi
dHJlZSAqLwogCXVpbnQxNl90CWdjX21hcms7IC8qIEJpdGZpZWxkIHVzZWQgYnkgR0MuIFNlZSBi
ZWxvdyBmb3IgZmllbGQgKi8KKwl1aW50MTZfdAlyZWNsYWltYWJsZV9pbl9nYzoxOwogfTsKIAog
LyoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVlLmMgYi9kcml2ZXJzL21kL2Jj
YWNoZS9idHJlZS5jCmluZGV4IDE5NmNkYWNjZTM4Zi4uZGVkNTU5NTg3ODJkIDEwMDY0NAotLS0g
YS9kcml2ZXJzL21kL2JjYWNoZS9idHJlZS5jCisrKyBiL2RyaXZlcnMvbWQvYmNhY2hlL2J0cmVl
LmMKQEAgLTE3NDAsMTggKzE3NDAsMjEgQEAgc3RhdGljIHZvaWQgYnRyZWVfZ2Nfc3RhcnQoc3Ry
dWN0IGNhY2hlX3NldCAqYykKIAogCW11dGV4X2xvY2soJmMtPmJ1Y2tldF9sb2NrKTsKIAotCWMt
PmdjX21hcmtfdmFsaWQgPSAwOwogCWMtPmdjX2RvbmUgPSBaRVJPX0tFWTsKIAogCWNhID0gYy0+
Y2FjaGU7CiAJZm9yX2VhY2hfYnVja2V0KGIsIGNhKSB7CiAJCWItPmxhc3RfZ2MgPSBiLT5nZW47
CisJCWlmIChiY2hfY2FuX2ludmFsaWRhdGVfYnVja2V0KGNhLCBiKSkKKwkJCWItPnJlY2xhaW1h
YmxlX2luX2djID0gMTsKKwogCQlpZiAoIWF0b21pY19yZWFkKCZiLT5waW4pKSB7CiAJCQlTRVRf
R0NfTUFSSyhiLCAwKTsKIAkJCVNFVF9HQ19TRUNUT1JTX1VTRUQoYiwgMCk7CiAJCX0KIAl9CiAK
KwljLT5nY19tYXJrX3ZhbGlkID0gMDsKIAltdXRleF91bmxvY2soJmMtPmJ1Y2tldF9sb2NrKTsK
IH0KIApAQCAtMTc2OCw2ICsxNzcxLDExIEBAIHN0YXRpYyB2b2lkIGJjaF9idHJlZV9nY19maW5p
c2goc3RydWN0IGNhY2hlX3NldCAqYykKIAljLT5nY19tYXJrX3ZhbGlkID0gMTsKIAljLT5uZWVk
X2djCT0gMDsKIAorCWNhID0gYy0+Y2FjaGU7CisJZm9yX2VhY2hfYnVja2V0KGIsIGNhKQorCSAg
ICBpZiAoYi0+cmVjbGFpbWFibGVfaW5fZ2MpCisJCWItPnJlY2xhaW1hYmxlX2luX2djID0gMDsK
KwogCWZvciAoaSA9IDA7IGkgPCBLRVlfUFRSUygmYy0+dXVpZF9idWNrZXQpOyBpKyspCiAJCVNF
VF9HQ19NQVJLKFBUUl9CVUNLRVQoYywgJmMtPnV1aWRfYnVja2V0LCBpKSwKIAkJCSAgICBHQ19N
QVJLX01FVEFEQVRBKTsKQEAgLTE3OTUsNyArMTgwMyw2IEBAIHN0YXRpYyB2b2lkIGJjaF9idHJl
ZV9nY19maW5pc2goc3RydWN0IGNhY2hlX3NldCAqYykKIAogCWMtPmF2YWlsX25idWNrZXRzID0g
MDsKIAotCWNhID0gYy0+Y2FjaGU7CiAJY2EtPmludmFsaWRhdGVfbmVlZHNfZ2MgPSAwOwogCiAJ
Zm9yIChrID0gY2EtPnNiLmQ7IGsgPCBjYS0+c2IuZCArIGNhLT5zYi5rZXlzOyBrKyspCi0tIAo=
--0000000000001ef5070617974308--

