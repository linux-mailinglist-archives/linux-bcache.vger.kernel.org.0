Return-Path: <linux-bcache+bounces-1154-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7302AAF7C53
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jul 2025 17:34:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D038A5875A1
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Jul 2025 15:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBB4619DF4A;
	Thu,  3 Jul 2025 15:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HHoyi7C5"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC26314B092
	for <linux-bcache@vger.kernel.org>; Thu,  3 Jul 2025 15:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556535; cv=none; b=k+bPBW3pJ8ER97VWgzZnjoD7TpOnlIj+1p278cIRKDuBewN6488aYQMexEmaWcmstT5zu5+fUe5ALc01jI2EApm1t+ld9fMUtG+WYsmPGnUoCkgrSpVvEueflvT0WJiZOcogN9R1DfZ3hY4zpL+rL0ooZICVHb3le8n+NimZAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556535; c=relaxed/simple;
	bh=Y9hEGy8YgztKFhgZta1ZaUwnw9vBcGL3/9vpG8LzKlY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n73TzKgyGCGH09DUtZHjIChgmj1fjb4SFaXjZJK68MeOGsoBvbSPsWCuLY/9u3yBwBNv4IIT17yDe/XLdt4tHcdvjU5eVL+b6mDa5BuvUuj7v6ZEgrjVv6dkLB8sllw2dw616fsknyiI+r02nFnluIX2zUFi+o2ghLGbyfGN0fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HHoyi7C5; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4a7fc24ed5cso356311cf.1
        for <linux-bcache@vger.kernel.org>; Thu, 03 Jul 2025 08:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751556533; x=1752161333; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lJXnqLJk3vvAqmG3VkICw1lKfUboZHv285EtpMzvs08=;
        b=HHoyi7C5XdsmbFOqS2W265NZc7WUq3cuFbxnziBqEYKWlP5zXDOcCvKf2+A/L+IV3u
         6bhaooVwyQ6V1GrS+jwsAuraMNLuMYO+mbb4vWR5iTxomfcJFExxbO7MLCE1MO6ortb9
         K6syS2gqVG+x/N5O0V2QfEtUjf6UNWKVYA2JYmy+gzh3dLHFkXoipLd8SciNYyj5pJxf
         qTa4wR9BfbQNkn4QqVW46Y+4dk97G6HC6J4O2useCsB1XdEXmeSbGRamnJB+ntZHXOku
         1W0HVdTu57Hfw/J5gGQvbyB/fKo0gHaXVOobSkaHWh3LbyUEl6oACqXb45WI4QgUZ5ED
         bGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751556533; x=1752161333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lJXnqLJk3vvAqmG3VkICw1lKfUboZHv285EtpMzvs08=;
        b=YglgvMkuj8zoRdZDyQuNuPQruzxSr0vZxv6odvPtuWTYpks6j6FbFLEUTJy2hBdyv0
         DlnBjLzCrhNPDXmGsErZys82LJX2b6UuQYWsK4FaCBXZhhe7JgeU0sqR/luTp9iBLgnR
         nZG6wuUvxQnGrd/4nvx8DT9AfyrZv6YjnlGbPZjzlg6YEFeS6mSmX77BUGtBymKnZbFp
         53AEGygC2MTsysAAbtD6n9spOhpfORjGHd4U99EedgbegeebLJYpRarb9wWdcOa+deaq
         XaiIhgp4FM+FNh5BcdHb/xahvlE+4HjrhxbQlSq1hKe2lQyQV3F8txl5is0QLMBPK2xL
         3xkQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5qw3F3X+MRG5E/uk5dQpOlUE2do7fYQEJ822XX3K9NDeGSNB/4MVu5jfGBvvl5MO6u1u3CTas9gfL5Bc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3crnP55aupJAMwuz4CGuXr3poUJ98JzOVJ/MuIcz+EsOhf9Fn
	QbFQDtz2CImxSWbo/SryA2i27DkLw9P4ccQ2JA61hnDJg3DmtUnYr5YGDZhynYcjSrGeTKfYmaZ
	qA7bIOqFbwAOottVHkGYV3eVARsflBJzErE6g7UNi
X-Gm-Gg: ASbGnct5u1Z8dbAlkAav/OGLlzGnWKkPmL1b6Vun2LtU1sLU/GKC9KHjI7AgHCHY1G5
	BgOGDA7TEIgR2dermV3OrN1/54zFQkMmWOEOCBVXXMvW0BkQRFQyEKTND6M5Y6ljPMkgQyW4Clm
	muqlFoOH5a3zNZGWT7C/e9cAf9zwNAZGmP9Pmnp40RBtGY
X-Google-Smtp-Source: AGHT+IFsmdQzmxyq/PS1AuAnDH67N3Svon0obtCr+fp3JjJ+sxgvOA6Yr1iQX84AAxFA0VXu6Hx0gizCY2IufULlFAo=
X-Received: by 2002:a05:622a:4708:b0:4a6:f9d2:b547 with SMTP id
 d75a77b69052e-4a992c2e906mr691791cf.20.1751556532420; Thu, 03 Jul 2025
 08:28:52 -0700 (PDT)
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
Date: Thu, 3 Jul 2025 23:28:40 +0800
X-Gm-Features: Ac12FXzzMd8ZeJ9dp3d_7QI0C7yK5SdWgduY_x3FOot3NW_K5lje0oLuM_NckbY
Message-ID: <CAJhEC05tF6zthgSD2VmUHap2kYGgTWXz+uq4KOrGg_GAV_KKQQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Coly Li <colyli@kernel.org>
Cc: Coly Li <i@coly.li>, Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>, Kuan-Wei Chiu <visitorckw@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Coly

I'm writing to provide an update on this bcache GC latency patch.

With the min heap regression addressed by the recent revert [1], I am
going to initiate a rerun of our last test set [2]. I will share the
results as soon as they are available.

To ensure this patch is fully qualified for the next merge window, I'm
eager to perform any further tests you deem necessary. What additional
test scenarios would you recommend?"

Best regards
Robert Pang

[1] https://lore.kernel.org/linux-bcache/20250614202353.1632957-1-visitorck=
w@gmail.com/T/#m86a71f8030c26f8f366f9442e33f2a236a5a2eac
[2] https://lore.kernel.org/linux-bcache/wtfuhfntbi6yorxqtpcs4vg5w67mvyckp2=
a6jmxuzt2hvbw65t@gznwsae5653d/T/#me50a9ddd0386ce602b2f17415e02d33b8e29f533

On Thu, May 15, 2025 at 8:58=E2=80=AFAM Robert Pang <robertpang@google.com>=
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

