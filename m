Return-Path: <linux-bcache+bounces-1067-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 84AD4ABA0AE
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 18:15:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E66C189B059
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 16:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987121632DD;
	Fri, 16 May 2025 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W0g2UcjU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC581D5175
	for <linux-bcache@vger.kernel.org>; Fri, 16 May 2025 16:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747412105; cv=none; b=XlUk8KWH5Eu6FJO60/jCVnkewGC9uvlchYqHiayB2C2vhUwocoZUl+aY5hegdUDrE8HMWGqPo1kB6FfsFhjjWScW48cD2rOFOeJwBemAft60GeeygeIF12oUy02i2rrlgCjW4Q+whkow0QQTdHC1PYI5nO3bzZEirWvEp3xAj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747412105; c=relaxed/simple;
	bh=Dw/I6/OorbzqeRGVQkDWDzJsr1j29q4sjsBMwJDbiEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEC/qh+WtaLRv4IiLd8MElaRIk9SQ4jwT/NxhzzaupHTPfmRIHT32PcTulqG9/yV2gm6WSLRf8glK5J+MCZqyHc26eWGivzVJMPsPhKC22Ay7Fbja9yJGS5bPHehOTbKJGHgq7CwhBtIizC1p8gmJlDhsrBaayycwXJ5ZNxIlNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W0g2UcjU; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b26ef4791a5so778822a12.1
        for <linux-bcache@vger.kernel.org>; Fri, 16 May 2025 09:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747412103; x=1748016903; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3WTZLS16FkHJe815Kq4M2LJRgyuyO466+SPm6OorTio=;
        b=W0g2UcjUWrver7+gMFanfF8PmKVQL9adUoMiwQqX5OWE3z35crtpogVoKWZtmko+Z9
         adbFKTTmVZsGfKJIi0ijd5Yw5oZyla/9H3nuZ2UhWbcHTX8TxStTW81OsH4cc6bT43P4
         NmW0XezxXvnyxVWPAPJtZRBwrdkcKJrBgoltrQnAPKENFP9fbY/ic24ZtDEYUJdENi8w
         CYo168t3viEUwRhzXT5a/TP/yUwI51DqmGnMlvJB2gMk/zA+3GmVwV3tdmKkg78O7idk
         fkVwhp6dnlN3oDYMZ3/rk9aU7PsyqDrpA+Yc3SNydCdwj7zel6FVHJpvlq30AtePquY3
         VP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747412103; x=1748016903;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3WTZLS16FkHJe815Kq4M2LJRgyuyO466+SPm6OorTio=;
        b=Edd9mTyG2e1sj4w3YCQ4M0lMt0/R6Zjbo0lzTe83XLvP9JzSNL/pjd+4w6TMS5m1bN
         pvfpsC359LAurunEgwXH5se4j1eDnuHUk+jLnRkou0oxGRhM/l0KdRVDqG2/kVwZnnpc
         t9Ty57b18tbz7TJTz7IW2zBbtre5rcPua2kd9S9g6hhfBceEHDz4prDiiUMRn5BjNweC
         OPeyc1mLplOumy3nvH81A5WdKd9EXY4yq5iLG+fx7rBmPhTy9qNIcN2CNBGByVsv9Oo0
         cMdtvh4v3x7wdn9V60Y/lfx8tv/MoVrN/DAPA8gk+KSrhiCoYqIzbqc8g4sdZ58HkCzk
         a+yQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKmKZ6uGaJMdUGtwp4GM8NxU9Ilq1j+Siknv6QHjarc76MopM0CWhDYw9Yo5AJHQEydmiaSjKRcR9A8MM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKEsCWW8ksEf8N2Qs0yUg/12iu7IWw0NShApmFOxeEGFFVogzD
	peL7rc9yCcDLXItwTzaEv1UKNf0w/YRbb83rLj0VdVzxaQTFyfYzSaoh
X-Gm-Gg: ASbGnct9/zDu0bOj0FZBXr2UF3i6ssPFnJWh73noaHzR3HhC/PVIXlRnT6SRqpsn/We
	O63dYvRA3Mp159SiJZ2e37+Hdr5UVK9y+ED5fzpFn2sS99D6VJOpUC/iC3xHRoNOpyUlPPViklA
	SRvou2VJUNMWKCUw/l+Y3V0iWQYpxefWsbs+ssPPe4bECMOJ8Oyo14J4eppqYWuFy1KkowRls42
	pn1av/PJ+LWYMFV5X3/tY7SlhKoeoa/qHaa/sH7Gs27XCFB8shfzkvcrcYKd8GLOqq2FXBIh4AS
	Ys50pBrc1ira9FHuY75kKXtpKB3C/vIm6v56V64MDUcX7CEr8PmpqK7cYImpCGUad9PGReuicq+
	aZS4=
X-Google-Smtp-Source: AGHT+IG04sVn9GvIbSleHjqLYM1WogHp2viB1WYjQGIf3zX6BW4w/zJ8XZJ+gO0vQIY0FN0Vu5wbRw==
X-Received: by 2002:a17:902:d4c4:b0:22e:6c96:ebd8 with SMTP id d9443c01a7336-231d43dc98bmr55169965ad.11.1747412102519;
        Fri, 16 May 2025 09:15:02 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231e069c59dsm13248105ad.7.2025.05.16.09.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 09:15:01 -0700 (PDT)
Date: Sat, 17 May 2025 00:14:59 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Robert Pang <robertpang@google.com>
Cc: Coly Li <colyli@kernel.org>, Coly Li <i@coly.li>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Message-ID: <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
References: <20250414224415.77926-1-robertpang@google.com>
 <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>

On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
> Hi Kuan-Wei,
> 
> Thank you for your prompt response. I tested your suggested patch to
> inline the min heap operations for 8 hours and it is still ongoing.
> Unfortunately, basing on the results so far, it didn't resolve the
> regression, suggesting inlining isn't the issue.
> 
> After reviewing the commits in lib/min_heap.h, I noticed commit
> c641722 ("lib min_heap: optimize number of comparisons in
> min_heapify()") and it looked like a potential candidate. I reverted
> this commit (below) and ran the tests. While the test is still
> ongoing, the results for the past 3 hours show that the latency spikes
> during invalidate_buckets_lru() disappeared after this change,
> indicating that this commit is likely the root cause of the
> regression.
> 
> My hypothesis is that while commit c641722 was designed to reduce
> comparisons with randomized input [1], it might inadvertently increase
> comparisons when the input isn't as random. A scenario where this
> could happen is within invalidate_buckets_lru() before the cache is
> fully populated. In such cases, many buckets are unfilled, causing
> new_bucket_prio() to return zero, leading to more frequent
> compare-equal operations with other unfilled buckets. In the case when
> the cache is populated, the bucket priorities fall in a range with
> many duplicates. How will heap_sift() behave in such cases?
> 
> [1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@gmail.com/
> 

You're very likely correct.

In scenarios where the majority of elements in the heap are identical,
the traditional top-down version of heapify finishes after just 2
comparisons. However, with the bottom-up version introduced by that
commit, it ends up performing roughly 2 * log₂(n) comparisons in the
same case.

That said, reverting the commit would increase the number of
comparisons by about 2x in cases where all elements in the heap are
distinct, which was the original motivation for the change. I'm not
entirely sure what the best way would be to fix this regression without
negatively impacting the performance of the other use cases.

Regards,
Kuan-Wei

> Best regards,
> Robert
> 
> ---
>  include/linux/min_heap.h | 46 +++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 1160bed6579e..2d16e6747e36 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -257,34 +257,32 @@ static __always_inline
>  void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t
> elem_size,
>   const struct min_heap_callbacks *func, void *args)
>  {
> - const unsigned long lsbit = elem_size & -elem_size;
> + void *left, *right, *parent, *smallest;
>   void *data = heap->data;
>   void (*swp)(void *lhs, void *rhs, void *args) = func->swp;
> - /* pre-scale counters for performance */
> - size_t a = pos * elem_size;
> - size_t b, c, d;
> - size_t n = heap->nr * elem_size;
> -
> - if (!swp)
> - swp = select_swap_func(data, elem_size);
> 
> - /* Find the sift-down path all the way to the leaves. */
> - for (b = a; c = 2 * b + elem_size, (d = c + elem_size) < n;)
> - b = func->less(data + c, data + d, args) ? c : d;
> -
> - /* Special case for the last leaf with no sibling. */
> - if (d == n)
> - b = c;
> -
> - /* Backtrack to the correct location. */
> - while (b != a && func->less(data + a, data + b, args))
> - b = parent(b, lsbit, elem_size);
> + for (;;) {
> + if (pos * 2 + 1 >= heap->nr)
> + break;
> 
> - /* Shift the element into its correct place. */
> - c = b;
> - while (b != a) {
> - b = parent(b, lsbit, elem_size);
> - do_swap(data + b, data + c, elem_size, swp, args);
> + left = data + ((pos * 2 + 1) * elem_size);
> + parent = data + (pos * elem_size);
> + smallest = parent;
> + if (func->less(left, smallest, args))
> + smallest = left;
> +
> + if (pos * 2 + 2 < heap->nr) {
> + right = data + ((pos * 2 + 2) * elem_size);
> + if (func->less(right, smallest, args))
> + smallest = right;
> + }
> + if (smallest == parent)
> + break;
> + do_swap(smallest, parent, elem_size, swp, args);
> + if (smallest == left)
> + pos = (pos * 2) + 1;
> + else
> + pos = (pos * 2) + 2;
>   }
>  }
> 
> -- 
> 
> On Thu, May 15, 2025 at 12:12 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Hi Robert,
> >
> > On Wed, May 14, 2025 at 05:58:01PM -0700, Robert Pang wrote:
> > > Hi Coly,
> > >
> > > My apologies for the delay in providing this update; comprehensive testing
> > > takes some time to complete.
> > >
> > > As you suggested, I conducted extensive tests for 24 hours against the
> > > latest 6.14.5 Linux kernel, exploring more configurations to get a complete
> > > picture:
> > >
> > > 1. 4KB block size with writethrough mode
> > > 2. 4KB block size with writeback mode (70% dirty)
> > > 3. 1MB block size with writethrough mode
> > >
> > > The detailed results, available at [1], consistently demonstrate that our patch
> > > is effective in significantly reducing latency during garbage collection. This
> > > holds true for both the default writethrough mode and the 70% writeback mode.
> > > As anticipated, with 1MB block sizes, we observed no difference in latency
> > > because the number of btree nodes is much smaller.
> > >
> > > [1] https://gist.github.com/robert-pang/817fa7c11ece99d25aabc0467a9427d8
> > >
> > > However, during these tests, we've uncovered a new and distinct latency problem
> > > that appears to be introduced in the recent Linux kernel. This issue manifests
> > > as frequent and periodic latency spikes that occur outside of garbage
> > > collection.
> > > Below is a snippet of the latency data illustrating this:
> > >
> > > time (s)  median (ms)  max (ms)
> > > 60810   2.28     679.37
> > > 60840   2.32   2,434.24 *
> > > 60870   2.46   2,434.24 *
> > > 60900   2.52   2,434.24 *
> > > 60930   2.63     566.15
> > > 60960   2.82     566.15
> > > 60990   2.82     566.15
> > > 61020   2.78     471.79
> > > 61050   2.93   2,028.54 *
> > > 61080   3.11   2,028.54 *
> > > 61110   3.29   2,028.54 *
> > > 61140   3.42     679.37
> > > 61170   3.42     679.37
> > > 61200   3.41     679.37
> > > 61230   3.30     566.15
> > > 61260   2.93   1,690.45 *
> > > 61290   2.75   1,690.45 *
> > > 61320   2.72   1,690.45 *
> > > 61350   2.88   1,408.71 *
> > > 61380   5.07   1,408.71 *
> > > 61410 107.94   1,408.71 **
> > > 61440  65.28   1,408.71 **
> > > 61470  45.41   2,028.54 **
> > > 61500  72.45   2,028.54 **
> > > 61530  55.37   2,028.54 **
> > > 61560  40.73   1,408.71 **
> > > 61590  11.48   1,690.45 **
> > > 61620   2.92   1,690.45 *
> > > 61650   2.54   1,690.45 *
> > > 61680   2.58     679.37
> > > 61710   2.78     679.37
> > >
> > > ** garbage collection
> > > * cache replacement
> > >
> > > Based on the consistent periodicity of these spikes, we deduce that they are
> > > linked to the invalidate_buckets_lru() function during cache replacement. This
> > > function was recently modified to use min heap operations [2]. To confirm our
> > > hypothesis, we reverted the relevant commits and re-ran the tests. Results show
> > > that the latency spikes completely disappeared, positively confirming that the
> > > min heap changes introduce this regression. Furthermore, these changes also
> > > reduce the effectiveness of our GC patch. It appears that the min heap changes
> > > reduce heap sort speed somehow in invalidate_buckets_lr() and in GC.
> >
> > Thank you for reporting this regression and for taking the time to
> > perform such thorough testing.
> >
> > My current hypothesis is that the root cause may be related to the
> > earlier change where the min heap API was converted from inline to
> > non-inline [1]. As a result, the comparison function used by the min
> > heap is now invoked via an indirect function call instead of a direct
> > one, which introduces significant overhead - especially when
> > CONFIG_MITIGATION_RETPOLINE is enabled, as the cost of indirect calls
> > can be quite substantial in that case.
> >
> > I understand that running these tests takes considerable time, but
> > could you try the attached diff to see if it addresses the regression?
> >
> > Regards,
> > Kuan-Wei
> >
> > [1]: https://lore.kernel.org/lkml/20241020040200.939973-2-visitorckw@gmail.com/
> >
> > diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> > index 8998e61efa40..862e7118f81d 100644
> > --- a/drivers/md/bcache/alloc.c
> > +++ b/drivers/md/bcache/alloc.c
> > @@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct cache *ca)
> >                 if (!bch_can_invalidate_bucket(ca, b))
> >                         continue;
> >
> > -               if (!min_heap_full(&ca->heap))
> > -                       min_heap_push(&ca->heap, &b, &bucket_max_cmp_callback, ca);
> > +               if (!min_heap_full_inline(&ca->heap))
> > +                       min_heap_push_inline(&ca->heap, &b, &bucket_max_cmp_callback, ca);
> >                 else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap), ca)) {
> >                         ca->heap.data[0] = b;
> > -                       min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_callback, ca);
> > +                       min_heap_sift_down_inline(&ca->heap, 0, &bucket_max_cmp_callback, ca);
> >                 }
> >         }
> >
> > -       min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
> > +       min_heapify_all_inline(&ca->heap, &bucket_min_cmp_callback, ca);
> >
> >         while (!fifo_full(&ca->free_inc)) {
> >                 if (!ca->heap.nr) {
> > @@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache *ca)
> >                         wake_up_gc(ca->set);
> >                         return;
> >                 }
> > -               b = min_heap_peek(&ca->heap)[0];
> > -               min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
> > +               b = min_heap_peek_inline(&ca->heap)[0];
> > +               min_heap_pop_inline(&ca->heap, &bucket_min_cmp_callback, ca);
> >
> >                 bch_invalidate_one_bucket(ca, b);
> >         }
> >
> > >
> > > [2] https://lore.kernel.org/linux-bcache/ZxzkLJmhn3a%2F1ALQ@visitorckw-System-Product-Name/T/#m0dd24ba0c63615de465d3fec72dc73febb0f7a94
> > >
> > > You may download the full test result data from these links.
> > >
> > > https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-bcache-latency-4kb-no-patch-csv
> > > https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-bcache-latency-4kb-with-patch-csv
> > > https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-bcache-latency-4kb-wb-no-patch-csv
> > > https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-bcache-latency-4kb-wb-with-patch-csv
> > > https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-bcache-latency-1mb-no-patch-csv
> > > https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-bcache-latency-1mb-with-patch-csv
> > > https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-bcache-latency-4kb-no-patch-min-heap-reverted-csv
> > > https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-bcache-latency-4kb-with-patch-min-heap-reverted-csv
> > >
> > > Best regards
> > > Robert Pang
> > >
> > > On Sat, May 3, 2025 at 10:33 AM Coly Li <colyli@kernel.org> wrote:
> > > >
> > > > On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
> > > > > Hi Coly,
> > > > >
> > > > > Please disregard the test results I shared over a week ago. After digging
> > > > > deeper into the recent latency spikes with various workloads and by
> > > > > instrumenting the garbage collector, I realized that the earlier GC latency
> > > > > patch, "bcache: allow allocator to invalidate bucket in gc" [1], wasn't
> > > > > backported to the Linux 6.6 branch I tested my patch against. This omission
> > > > > explains the much higher latency observed during the extended test because the
> > > > > allocator was blocked for the entire GC. My sincere apologies for the
> > > > > inconsistent results and any confusion this has caused.
> > > > >
> > > >
> > > > Did you also backport commit 05356938a4be ("bcache: call force_wake_up_gc()
> > > > if necessary in check_should_bypass()") ? Last time when you pushed me to
> > > > add commit a14a68b76954 into mainline kernel, I tested a regression from this
> > > > patch and fixed it. Please add this fix if you didn't, otherwise the testing
> > > > might not be completed.
> > > >
> > > >
> > > > > With patch [1] back-patched and after a 24-hour re-test, the fio results clearly
> > > > > demonstrate that this patch effectively reduces front IO latency during GC due
> > > > > to the smaller incremental GC cycles, while the GC duration increase is still
> > > > > well within bounds.
> > > > >
> > > >
> > > > From the performance result in [2], it seems the max latency are reduced,
> > > > but higher latency period are longer. I am not sure whether this is a happy
> > > > result.
> > > >
> > > > Can I have a download link for the whole log? Then I can look at the
> > > > performance numbers more close.
> > > >
> > > > > Here's a summary of the improved latency:
> > > > >
> > > > > Before:
> > > > >
> > > > > Median latency (P50): 210 ms
> > > > > Max latency (P100): 3.5 sec
> > > > >
> > > > > btree_gc_average_duration_ms:381138
> > > > > btree_gc_average_frequency_sec:3834
> > > > > btree_gc_last_sec:60668
> > > > > btree_gc_max_duration_ms:825228
> > > > > bset_tree_stats:
> > > > > btree nodes: 144330
> > > > > written sets: 283733
> > > > > unwritten sets: 144329
> > > > > written key bytes: 24993783392
> > > > > unwritten key bytes: 11777400
> > > > > floats: 30936844345385
> > > > > failed: 5776
> > > > >
> > > > > After:
> > > > >
> > > > > Median latency (P50): 25 ms
> > > > > Max latency (P100): 0.8 sec
> > > > >
> > > > > btree_gc_average_duration_ms:622274
> > > > > btree_gc_average_frequency_sec:3518
> > > > > btree_gc_last_sec:8931
> > > > > btree_gc_max_duration_ms:953146
> > > > > bset_tree_stats:
> > > > > btree nodes: 175491
> > > > > written sets: 339078
> > > > > unwritten sets: 175488
> > > > > written key bytes: 29821314856
> > > > > unwritten key bytes: 14076504
> > > > > floats: 90520963280544
> > > > > failed: 6462
> > > > >
> > > > > The complete latency data is available at [2].
> > > > >
> > > > > I will be glad to run further tests to solidify these findings for the inclusion
> > > > > of this patch in the coming merge window. Let me know if you'd like me to
> > > > > conduct any specific tests.
> > > >
> > > > Yes, more testing are necessary, from 512 Bytes block size to 1 MiB or
> > > > 8MiB block size. We need to make sure it won't introduce performance
> > > > regression in other workload or circumstances.
> > > >
> > > > I don't have plan to submit this patch in this merge window, and please don't
> > > > push me. For performance improvement change, I prefer the defalt
> > > > configuration will cover most of work loads, so more testing and perforamce
> > > > data are desired. E.g. the patch you mentioned (commit a14a68b76954 "bcache:
> > > > allow allocator to invalidate bucket in gc"), it had been deployed in Easy
> > > > Stack product environment for 20+ months before it got merged.
> > > >
> > > > Thanks.
> > > >
> > > > >
> > > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a14a68b76954e73031ca6399abace17dcb77c17a
> > > > > [2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f9180f
> > > >
> > > > [snipped]
> > > >
> > > > --
> > > > Coly Li

