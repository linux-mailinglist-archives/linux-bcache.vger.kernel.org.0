Return-Path: <linux-bcache+bounces-1064-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B338CAB7AD2
	for <lists+linux-bcache@lfdr.de>; Thu, 15 May 2025 03:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0674C4A6B25
	for <lists+linux-bcache@lfdr.de>; Thu, 15 May 2025 01:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E85B2239E8A;
	Thu, 15 May 2025 01:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITlM9HhO"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C995721ABDC
	for <linux-bcache@vger.kernel.org>; Thu, 15 May 2025 01:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747271108; cv=none; b=HF/qN0zpapDNfIsP0R5NWRE+8hOEufulZ65lDMh2xAt8iSa/qzPwocDTZ0a3jWoQVFU/19Wpvo25qMB5GU/15t6c2oK4SYVe9oNs0kSftiR0+Om1mJx4XNffSdNZEEYlD8y2Ipf+IHQu4y0dthJ4dQh3Vil41NU0ooYOShCQ1BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747271108; c=relaxed/simple;
	bh=mQHRA3C4kNNUPtoBkjU/8j9PZHgrIKCSH7nrD+80RVQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=irnZKUuMX3g9PYCk2uZpoL91Xr/DPqUFApOESGjFXNlZOrH5OA/PSheSHNVGaaV8/ov6VugPOtR920VqJjnzEfCYlFEF4S/AmLBEfc9ztXd/FDYmYJAOwzejMkl+8br+tA3XrV8V4lEIqYU3OI9XoV6kNuHX9oRsHzCgueEdgAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ITlM9HhO; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5fce6c7598bso4964a12.0
        for <linux-bcache@vger.kernel.org>; Wed, 14 May 2025 18:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747271105; x=1747875905; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jryyScViGwfyr5BFWO+kmIHDngi7cayDlaE6TwoEBI=;
        b=ITlM9HhONEHN0FJ7j7OmGfqi07X/1r/IFm3CHphNVKDHKewKCtADKa2NDIDJ3e6Itr
         KRQc5JwGMPLteNmrvl6ks790LFweMzLIMXYK5ErxsAO4ZzbU8aMMC2dyrWTGSj758fCJ
         vs1hCkK9ROunlF0z7LZa04vAVsGgYCMtxzAfGJ5Qhxs+B2pIGUhxseFGYkMRswdRhAdI
         o2uCbSECOA/7LGK1SX3ehRJ1Eg6ZRddgNvNf4e3rtBqHaTPJCl5mOB2VnrvedRUR4sEz
         91U2IO/3GUGl6+6GBxM7LdzlkkzBj+BJx2ryznporkvCPmnLDVtzHfAHHY71N3V+K3u1
         gErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747271105; x=1747875905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jryyScViGwfyr5BFWO+kmIHDngi7cayDlaE6TwoEBI=;
        b=kUoIh4RTdEpxOTH2Q7PErGwyReji8DoYFofiPKdI1T5EZ0ZO3SU6IHyYgdXOay268w
         beJ5oTlpbW1Ax1hyE7RKyODfbPBnNlrbH7BbL4eUId7t79IpGJBBkQamfgwdzdtnfO3j
         5PBYZPY/GWQccRCWL2z8bMUqR++YiRavUtYzhfFer1XmDIUQaXCa6MDa9I7gC4NLq6ax
         UqJ8p0vvS+Ic7fBmSOXb+bDLaJIbUMKYn/QRR4dlgqIrPigkNLjnuNad6FUIo0cKOm98
         5r8X18RGbSjiw38UDewEBfLgSW0+RbMnkpiQ2N51o36HWJqYH8Wv+PzOdt+YV6/uOkLb
         Yx/w==
X-Forwarded-Encrypted: i=1; AJvYcCUBE0LRqE8IxMl5OPQ769fMvNNmkpG8mBTAYf/7JZq4GSkUMEuLja/mq5iPxY2b0Fjt5c6HKlWYGIxTtvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMk/C/M3UoFwQQUFhD0f/OAT7F+BANWROo9IuzPRdgQWp9B45j
	v1bLnksy2+kFSjuGBx8xslMLeJM5pjGsRUCojI/NDXrw72SwxkMBS24CUPOJyK9g+lNe4xYW8Nr
	9sOKJax6rfUWuLsA8U7qRhhif3BlwapqQIaX/wcSL
X-Gm-Gg: ASbGncvhmLBmDgus/GTZDC0VM/DeI0YwotNUFACiZEjMkwWFu78I6DAEKvCL750X/zM
	Z6xOKKGm6jCGMiKzKgvx64LDpwJZi8iBVlvZRQe6RAWUaU+ZZeeQDe74VpCDwv4/8O4R1yJRbjT
	FxcEq3SPksZ9+hwEx+6Ex50KJt4d8xbAAd5Dw/PFM+lkpqDpFGSumyi6K0bKBUV5eNDTmr8dNh3
	Q==
X-Google-Smtp-Source: AGHT+IGmlcEriAazArYS2n6axPqaGJTlgsvWxUO7ZHzR8373ez3x/XhdZqslVmaiy9KLbqrAKg2h7KR6DVDuCIU57aA=
X-Received: by 2002:a50:cd19:0:b0:5fc:a9f0:3d15 with SMTP id
 4fb4d7f45d1cf-5ffce28bb43mr22472a12.1.1747271104792; Wed, 14 May 2025
 18:05:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx> <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
In-Reply-To: <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Wed, 14 May 2025 18:04:53 -0700
X-Gm-Features: AX0GCFsdwE0gCPUSFKyTiyIAZUCpsbNnLlxY7rPjy98E49KIeg3yVXUz5pa6qYo
Message-ID: <CAJhEC05cPVvm0COsy3YDhKR5_epVOQtrQTLzuBDP8h1HGQQKmA@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <colyli@kernel.org>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Here is the link to the changes to bcache and invalidate_buckets_lru()
specifically.

https://lore.kernel.org/linux-bcache/20240524152958.919343-16-visitorckw@gm=
ail.com/T/#u

On Wed, May 14, 2025 at 5:58=E2=80=AFPM Robert Pang <robertpang@google.com>=
 wrote:
>
> Hi Coly,
>
> My apologies for the delay in providing this update; comprehensive testin=
g
> takes some time to complete.
>
> As you suggested, I conducted extensive tests for 24 hours against the
> latest 6.14.5 Linux kernel, exploring more configurations to get a comple=
te
> picture:
>
> 1. 4KB block size with writethrough mode
> 2. 4KB block size with writeback mode (70% dirty)
> 3. 1MB block size with writethrough mode
>
> The detailed results, available at [1], consistently demonstrate that our=
 patch
> is effective in significantly reducing latency during garbage collection.=
 This
> holds true for both the default writethrough mode and the 70% writeback m=
ode.
> As anticipated, with 1MB block sizes, we observed no difference in latenc=
y
> because the number of btree nodes is much smaller.
>
> [1] https://gist.github.com/robert-pang/817fa7c11ece99d25aabc0467a9427d8
>
> However, during these tests, we've uncovered a new and distinct latency p=
roblem
> that appears to be introduced in the recent Linux kernel. This issue mani=
fests
> as frequent and periodic latency spikes that occur outside of garbage
> collection.
> Below is a snippet of the latency data illustrating this:
>
> time (s)  median (ms)  max (ms)
> 60810   2.28     679.37
> 60840   2.32   2,434.24 *
> 60870   2.46   2,434.24 *
> 60900   2.52   2,434.24 *
> 60930   2.63     566.15
> 60960   2.82     566.15
> 60990   2.82     566.15
> 61020   2.78     471.79
> 61050   2.93   2,028.54 *
> 61080   3.11   2,028.54 *
> 61110   3.29   2,028.54 *
> 61140   3.42     679.37
> 61170   3.42     679.37
> 61200   3.41     679.37
> 61230   3.30     566.15
> 61260   2.93   1,690.45 *
> 61290   2.75   1,690.45 *
> 61320   2.72   1,690.45 *
> 61350   2.88   1,408.71 *
> 61380   5.07   1,408.71 *
> 61410 107.94   1,408.71 **
> 61440  65.28   1,408.71 **
> 61470  45.41   2,028.54 **
> 61500  72.45   2,028.54 **
> 61530  55.37   2,028.54 **
> 61560  40.73   1,408.71 **
> 61590  11.48   1,690.45 **
> 61620   2.92   1,690.45 *
> 61650   2.54   1,690.45 *
> 61680   2.58     679.37
> 61710   2.78     679.37
>
> ** garbage collection
> * cache replacement
>
> Based on the consistent periodicity of these spikes, we deduce that they =
are
> linked to the invalidate_buckets_lru() function during cache replacement.=
 This
> function was recently modified to use min heap operations [2]. To confirm=
 our
> hypothesis, we reverted the relevant commits and re-ran the tests. Result=
s show
> that the latency spikes completely disappeared, positively confirming tha=
t the
> min heap changes introduce this regression. Furthermore, these changes al=
so
> reduce the effectiveness of our GC patch. It appears that the min heap ch=
anges
> reduce heap sort speed somehow in invalidate_buckets_lr() and in GC.
>
> [2] https://lore.kernel.org/linux-bcache/ZxzkLJmhn3a%2F1ALQ@visitorckw-Sy=
stem-Product-Name/T/#m0dd24ba0c63615de465d3fec72dc73febb0f7a94
>
> You may download the full test result data from these links.
>
> https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file=
-bcache-latency-4kb-no-patch-csv
> https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file=
-bcache-latency-4kb-with-patch-csv
> https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file=
-bcache-latency-4kb-wb-no-patch-csv
> https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file=
-bcache-latency-4kb-wb-with-patch-csv
> https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file=
-bcache-latency-1mb-no-patch-csv
> https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file=
-bcache-latency-1mb-with-patch-csv
> https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file=
-bcache-latency-4kb-no-patch-min-heap-reverted-csv
> https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file=
-bcache-latency-4kb-with-patch-min-heap-reverted-csv
>
> Best regards
> Robert Pang
>
> On Sat, May 3, 2025 at 10:33=E2=80=AFAM Coly Li <colyli@kernel.org> wrote=
:
> >
> > On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
> > > Hi Coly,
> > >
> > > Please disregard the test results I shared over a week ago. After dig=
ging
> > > deeper into the recent latency spikes with various workloads and by
> > > instrumenting the garbage collector, I realized that the earlier GC l=
atency
> > > patch, "bcache: allow allocator to invalidate bucket in gc" [1], wasn=
't
> > > backported to the Linux 6.6 branch I tested my patch against. This om=
ission
> > > explains the much higher latency observed during the extended test be=
cause the
> > > allocator was blocked for the entire GC. My sincere apologies for the
> > > inconsistent results and any confusion this has caused.
> > >
> >
> > Did you also backport commit 05356938a4be ("bcache: call force_wake_up_=
gc()
> > if necessary in check_should_bypass()") ? Last time when you pushed me =
to
> > add commit a14a68b76954 into mainline kernel, I tested a regression fro=
m this
> > patch and fixed it. Please add this fix if you didn't, otherwise the te=
sting
> > might not be completed.
> >
> >
> > > With patch [1] back-patched and after a 24-hour re-test, the fio resu=
lts clearly
> > > demonstrate that this patch effectively reduces front IO latency duri=
ng GC due
> > > to the smaller incremental GC cycles, while the GC duration increase =
is still
> > > well within bounds.
> > >
> >
> > From the performance result in [2], it seems the max latency are reduce=
d,
> > but higher latency period are longer. I am not sure whether this is a h=
appy
> > result.
> >
> > Can I have a download link for the whole log? Then I can look at the
> > performance numbers more close.
> >
> > > Here's a summary of the improved latency:
> > >
> > > Before:
> > >
> > > Median latency (P50): 210 ms
> > > Max latency (P100): 3.5 sec
> > >
> > > btree_gc_average_duration_ms:381138
> > > btree_gc_average_frequency_sec:3834
> > > btree_gc_last_sec:60668
> > > btree_gc_max_duration_ms:825228
> > > bset_tree_stats:
> > > btree nodes: 144330
> > > written sets: 283733
> > > unwritten sets: 144329
> > > written key bytes: 24993783392
> > > unwritten key bytes: 11777400
> > > floats: 30936844345385
> > > failed: 5776
> > >
> > > After:
> > >
> > > Median latency (P50): 25 ms
> > > Max latency (P100): 0.8 sec
> > >
> > > btree_gc_average_duration_ms:622274
> > > btree_gc_average_frequency_sec:3518
> > > btree_gc_last_sec:8931
> > > btree_gc_max_duration_ms:953146
> > > bset_tree_stats:
> > > btree nodes: 175491
> > > written sets: 339078
> > > unwritten sets: 175488
> > > written key bytes: 29821314856
> > > unwritten key bytes: 14076504
> > > floats: 90520963280544
> > > failed: 6462
> > >
> > > The complete latency data is available at [2].
> > >
> > > I will be glad to run further tests to solidify these findings for th=
e inclusion
> > > of this patch in the coming merge window. Let me know if you'd like m=
e to
> > > conduct any specific tests.
> >
> > Yes, more testing are necessary, from 512 Bytes block size to 1 MiB or
> > 8MiB block size. We need to make sure it won't introduce performance
> > regression in other workload or circumstances.
> >
> > I don't have plan to submit this patch in this merge window, and please=
 don't
> > push me. For performance improvement change, I prefer the defalt
> > configuration will cover most of work loads, so more testing and perfor=
amce
> > data are desired. E.g. the patch you mentioned (commit a14a68b76954 "bc=
ache:
> > allow allocator to invalidate bucket in gc"), it had been deployed in E=
asy
> > Stack product environment for 20+ months before it got merged.
> >
> > Thanks.
> >
> > >
> > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3Da14a68b76954e73031ca6399abace17dcb77c17a
> > > [2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f91=
80f
> >
> > [snipped]
> >
> > --
> > Coly Li

