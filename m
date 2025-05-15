Return-Path: <linux-bcache+bounces-1063-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA484AB7ACC
	for <lists+linux-bcache@lfdr.de>; Thu, 15 May 2025 02:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D3774C5572
	for <lists+linux-bcache@lfdr.de>; Thu, 15 May 2025 00:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 288B022ACD3;
	Thu, 15 May 2025 00:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3f/IidED"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1640DDDC5
	for <linux-bcache@vger.kernel.org>; Thu, 15 May 2025 00:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747270697; cv=none; b=I0JAchgXUhdGOgpehhl9sT+HtpprT6YdrhUOib6HV8H7DDRgyDvuThOhO06q5oy5wZN2JOyZBjBk4Ep1bnHVPd8tTmyZEcAERJXQz+dpBr8ua2WMAq5WgKx9TiGbLAq2ohVHubhmv+WJghR+58K65kP9KB28PAxejMDuMDH2Dwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747270697; c=relaxed/simple;
	bh=rXwpEQdgsCIxRFFU+Y7R/EGsPxbHY9gSpxE0z71tr/M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XfavsW1T2gMKMCo8/ZmboYzKXYfV5uo/qlqrydGcje5qIGJyw9KBmFxSgjDv4X2nnW4CEpiJ51Eg3Mx+QIZ/ih593OYirQoWN820brti33WHGZ5SggdzniGOrZ1FIZT4TAfYi+PexVwsRZ7GsrOV2d66Txz79NpRDl+kVGwFUN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3f/IidED; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5fce6c7598bso4931a12.0
        for <linux-bcache@vger.kernel.org>; Wed, 14 May 2025 17:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747270693; x=1747875493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bGAuq5EekgmWrpqJ07GPGWq/DJSH+srpC6qqAic3jw=;
        b=3f/IidEDn7gGSH1M/vCBRJB1Jm7Qv/0Y29tHEpuvW/v5U549jt5lE8qpozM9olBxNx
         ZPOPnhlUkYLIfhMJveEe7i4XkcPtFTjJ2c1vKp3Ig0GKzQMR8hjTCRemoHqrt1Z04u6F
         ZeW4IEqN9v/Rdi/3YrRTO/Ltfi1mC7u+ZgwkS2nupqnofjTCkELNyUxvKU/EgLI/N22O
         irjQLg3Rodumja5ORIxed2OEqY6UJWHymS3g5LaY3AMWsdsJM+luR6PeWyWOkKfmfutd
         OGLj+mW3Ahcud2MspZ8WzxSK/ljVaIDNx01oqXurdSoDNgeB/rodE+5vGMltItTahpIB
         s3Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747270693; x=1747875493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+bGAuq5EekgmWrpqJ07GPGWq/DJSH+srpC6qqAic3jw=;
        b=BveIBqLJtW8XxRne9f2/Sb/GcHDv6pcq0OW7hHATlm43NFBvfyxreLIU8/mKtM7hD+
         kHYwQ1hSGOyMz+v1g3CDJLXS6ebFNA4EsAKriCDHBWTgK6l9KhTlA+ZYV64IAFe4G8FD
         u+Mkj+JxLp/8Uk1+lgRAIrvFnPVIcnzWUvRagEnJbKzjJOzxvuMa7nOpPNHVs/fUtQ+D
         CzdKIJa4FnqWfhWqbA0J7bEbvJImt9iGiOqkI6mJolhvUxMGzx6MGI+IRK2jCg25uGhE
         Ev/OtS0ZlnBmqhlGIWP2K/0Dzze8R1ZZUY6NvuAe97DNWsvCaSwPaF3jiGnej81YHepv
         l5sg==
X-Forwarded-Encrypted: i=1; AJvYcCU4WWc+tv8PHL1xvndRdAW0XsP9x1APsuZDjkmYUW9tl8IqbHGHEuw9vLjBS+o9yThjxUHMp/cnsGjcyWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxikHU6vvyynDfq5vb0iuPR2QGIlQ3N96oy1fKNza3Tm33ImEPL
	D0BaGCqJyUqoXC5lmfZ6nFo18GbuBZGwGlfZh28b+uYWhPgZqHVjksxVeWkcvxURJK+WHCG1tfY
	6wb0FxXcepnVkMJ9Rv5sUZ2+OEZG8HkxxOx2zXn8a
X-Gm-Gg: ASbGncvPWZZ1JwbwxT1/ue6eOzEUtHMEbYHr7PPFdy2fnAJEBzyamdIl5hDJ9h+26l+
	MJ6eqbx4J8HDNIdBec1msySQCJwTC9cxJcD8RHaw1V6I74PbyNCEwNzTNUTCmjOu5ncELzSKsGR
	Wut/Ic96Pz0m4R8Bz2ScctMOED1lIr8AucCh58i95gRApdgtDw71XyKmJZSoHVpZI=
X-Google-Smtp-Source: AGHT+IGeT7fbDb8XBJ4g+KnYX+6AmA2ptUvn6bFqe2U73oZ9A9pj4Q+32PbVKUA/TupBhk2YiB6ybI7bOjq9IH5HpfA=
X-Received: by 2002:a50:c049:0:b0:5fd:28:c3f6 with SMTP id 4fb4d7f45d1cf-5ffc9dbe5b8mr39446a12.4.1747270693116;
 Wed, 14 May 2025 17:58:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com> <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
In-Reply-To: <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
From: Robert Pang <robertpang@google.com>
Date: Wed, 14 May 2025 17:58:01 -0700
X-Gm-Features: AX0GCFuv1g3gIhCwYk4jSS3wq_saU58AyuN4F6TXHOm-rjTMs5oB2luQ1tWsMKg
Message-ID: <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <colyli@kernel.org>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly,

My apologies for the delay in providing this update; comprehensive testing
takes some time to complete.

As you suggested, I conducted extensive tests for 24 hours against the
latest 6.14.5 Linux kernel, exploring more configurations to get a complete
picture:

1. 4KB block size with writethrough mode
2. 4KB block size with writeback mode (70% dirty)
3. 1MB block size with writethrough mode

The detailed results, available at [1], consistently demonstrate that our p=
atch
is effective in significantly reducing latency during garbage collection. T=
his
holds true for both the default writethrough mode and the 70% writeback mod=
e.
As anticipated, with 1MB block sizes, we observed no difference in latency
because the number of btree nodes is much smaller.

[1] https://gist.github.com/robert-pang/817fa7c11ece99d25aabc0467a9427d8

However, during these tests, we've uncovered a new and distinct latency pro=
blem
that appears to be introduced in the recent Linux kernel. This issue manife=
sts
as frequent and periodic latency spikes that occur outside of garbage
collection.
Below is a snippet of the latency data illustrating this:

time (s)  median (ms)  max (ms)
60810   2.28     679.37
60840   2.32   2,434.24 *
60870   2.46   2,434.24 *
60900   2.52   2,434.24 *
60930   2.63     566.15
60960   2.82     566.15
60990   2.82     566.15
61020   2.78     471.79
61050   2.93   2,028.54 *
61080   3.11   2,028.54 *
61110   3.29   2,028.54 *
61140   3.42     679.37
61170   3.42     679.37
61200   3.41     679.37
61230   3.30     566.15
61260   2.93   1,690.45 *
61290   2.75   1,690.45 *
61320   2.72   1,690.45 *
61350   2.88   1,408.71 *
61380   5.07   1,408.71 *
61410 107.94   1,408.71 **
61440  65.28   1,408.71 **
61470  45.41   2,028.54 **
61500  72.45   2,028.54 **
61530  55.37   2,028.54 **
61560  40.73   1,408.71 **
61590  11.48   1,690.45 **
61620   2.92   1,690.45 *
61650   2.54   1,690.45 *
61680   2.58     679.37
61710   2.78     679.37

** garbage collection
* cache replacement

Based on the consistent periodicity of these spikes, we deduce that they ar=
e
linked to the invalidate_buckets_lru() function during cache replacement. T=
his
function was recently modified to use min heap operations [2]. To confirm o=
ur
hypothesis, we reverted the relevant commits and re-ran the tests. Results =
show
that the latency spikes completely disappeared, positively confirming that =
the
min heap changes introduce this regression. Furthermore, these changes also
reduce the effectiveness of our GC patch. It appears that the min heap chan=
ges
reduce heap sort speed somehow in invalidate_buckets_lr() and in GC.

[2] https://lore.kernel.org/linux-bcache/ZxzkLJmhn3a%2F1ALQ@visitorckw-Syst=
em-Product-Name/T/#m0dd24ba0c63615de465d3fec72dc73febb0f7a94

You may download the full test result data from these links.

https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-b=
cache-latency-4kb-no-patch-csv
https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-b=
cache-latency-4kb-with-patch-csv
https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-b=
cache-latency-4kb-wb-no-patch-csv
https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-b=
cache-latency-4kb-wb-with-patch-csv
https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-b=
cache-latency-1mb-no-patch-csv
https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-b=
cache-latency-1mb-with-patch-csv
https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-b=
cache-latency-4kb-no-patch-min-heap-reverted-csv
https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-b=
cache-latency-4kb-with-patch-min-heap-reverted-csv

Best regards
Robert Pang

On Sat, May 3, 2025 at 10:33=E2=80=AFAM Coly Li <colyli@kernel.org> wrote:
>
> On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
> > Hi Coly,
> >
> > Please disregard the test results I shared over a week ago. After diggi=
ng
> > deeper into the recent latency spikes with various workloads and by
> > instrumenting the garbage collector, I realized that the earlier GC lat=
ency
> > patch, "bcache: allow allocator to invalidate bucket in gc" [1], wasn't
> > backported to the Linux 6.6 branch I tested my patch against. This omis=
sion
> > explains the much higher latency observed during the extended test beca=
use the
> > allocator was blocked for the entire GC. My sincere apologies for the
> > inconsistent results and any confusion this has caused.
> >
>
> Did you also backport commit 05356938a4be ("bcache: call force_wake_up_gc=
()
> if necessary in check_should_bypass()") ? Last time when you pushed me to
> add commit a14a68b76954 into mainline kernel, I tested a regression from =
this
> patch and fixed it. Please add this fix if you didn't, otherwise the test=
ing
> might not be completed.
>
>
> > With patch [1] back-patched and after a 24-hour re-test, the fio result=
s clearly
> > demonstrate that this patch effectively reduces front IO latency during=
 GC due
> > to the smaller incremental GC cycles, while the GC duration increase is=
 still
> > well within bounds.
> >
>
> From the performance result in [2], it seems the max latency are reduced,
> but higher latency period are longer. I am not sure whether this is a hap=
py
> result.
>
> Can I have a download link for the whole log? Then I can look at the
> performance numbers more close.
>
> > Here's a summary of the improved latency:
> >
> > Before:
> >
> > Median latency (P50): 210 ms
> > Max latency (P100): 3.5 sec
> >
> > btree_gc_average_duration_ms:381138
> > btree_gc_average_frequency_sec:3834
> > btree_gc_last_sec:60668
> > btree_gc_max_duration_ms:825228
> > bset_tree_stats:
> > btree nodes: 144330
> > written sets: 283733
> > unwritten sets: 144329
> > written key bytes: 24993783392
> > unwritten key bytes: 11777400
> > floats: 30936844345385
> > failed: 5776
> >
> > After:
> >
> > Median latency (P50): 25 ms
> > Max latency (P100): 0.8 sec
> >
> > btree_gc_average_duration_ms:622274
> > btree_gc_average_frequency_sec:3518
> > btree_gc_last_sec:8931
> > btree_gc_max_duration_ms:953146
> > bset_tree_stats:
> > btree nodes: 175491
> > written sets: 339078
> > unwritten sets: 175488
> > written key bytes: 29821314856
> > unwritten key bytes: 14076504
> > floats: 90520963280544
> > failed: 6462
> >
> > The complete latency data is available at [2].
> >
> > I will be glad to run further tests to solidify these findings for the =
inclusion
> > of this patch in the coming merge window. Let me know if you'd like me =
to
> > conduct any specific tests.
>
> Yes, more testing are necessary, from 512 Bytes block size to 1 MiB or
> 8MiB block size. We need to make sure it won't introduce performance
> regression in other workload or circumstances.
>
> I don't have plan to submit this patch in this merge window, and please d=
on't
> push me. For performance improvement change, I prefer the defalt
> configuration will cover most of work loads, so more testing and perforam=
ce
> data are desired. E.g. the patch you mentioned (commit a14a68b76954 "bcac=
he:
> allow allocator to invalidate bucket in gc"), it had been deployed in Eas=
y
> Stack product environment for 20+ months before it got merged.
>
> Thanks.
>
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Da14a68b76954e73031ca6399abace17dcb77c17a
> > [2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f9180=
f
>
> [snipped]
>
> --
> Coly Li

