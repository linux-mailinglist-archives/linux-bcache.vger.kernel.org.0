Return-Path: <linux-bcache+bounces-1066-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CFBAB950C
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 05:59:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C763F7A3ACA
	for <lists+linux-bcache@lfdr.de>; Fri, 16 May 2025 03:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8894122A4E2;
	Fri, 16 May 2025 03:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SkEkF8v9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334241DFE8
	for <linux-bcache@vger.kernel.org>; Fri, 16 May 2025 03:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747367940; cv=none; b=QUfHJCTldYfNrg6qY33PpYfOS789MbIESVrLMZdd1wk0W28B4+nfntwGDye3dRZo1XPyWVjAQT9SlLSRGswiKiKKvDKG8SljFN4DXwJlWJ4cBVeEmDv7DetcBHrmkDHhUiuMVawhJLlePAbszz7urmWgEoHGrbPvb6jV1NVyB1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747367940; c=relaxed/simple;
	bh=zkG5yz50bJFVf2XGM76FgNvWxPy5GQ8H7H6ZxKE+8ww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J26grUP9nc4qPSRvu+AsMN2LB074DgEeUvJB22lN+8xpdlu2sErY+AezLsI2XbA5SKDOeWlVfQiSgwEta1iGhbQXIEw7UYfSJ+Bv8LodpiHukYsDgIeirjXC5McCbDR3jGnzrBmPdKnd3FyVJMPIH3KJMoKyAV1GP7HCM7uGHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SkEkF8v9; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso4375a12.1
        for <linux-bcache@vger.kernel.org>; Thu, 15 May 2025 20:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747367936; x=1747972736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TDPyFM5oBZlQlPbL5b3uOTpHMVgh3EC4I6jliL0Zq8=;
        b=SkEkF8v9nTeVc75SFg5QAUTL+BiRFTDqtVM9IPSt8LFA3PhALDH3ejmO/jnpF0LvGE
         OUQIwnhSokAIPEPTKYw+xdm8PamDcX9NvNxk5Gpk62FFSSyXs0HTpSKZpVRLwSC0EeIF
         BCYUvDTpbxXY5wd1W6UM9vJzs2G1JiQ0xJg+fnezhd47i7QBVbYu/evr9csX4If66dVT
         8/NNAcYPdSdRGt7YuUoLc34QQLqWkrVCljeV0sXPrnxUQCr7ysJPRh2+YPwyyjjrXa7e
         1N4IVVOYsI0DnoOB9XnO/2ikSgXqC1golRJCs0CwSZ0t1EDNn6H3z0ZIK1OW1HGILvND
         xd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747367936; x=1747972736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6TDPyFM5oBZlQlPbL5b3uOTpHMVgh3EC4I6jliL0Zq8=;
        b=cHPCIm6fUDn3Afa+3xShrJPghdKGqevvuViEWiQHh4VNtPm30XLpWSGJ3pkur+87WO
         1IszIF0VM1G9duDMze80GFGe0CEztvnT5Oo0wk8Pu35m+odyVSSmWZ4N2CvBhWQEdJBs
         4Oe9bsej4mzjyttNwL2CizLevBekK+CD6127H767x/OPva5B7yysteEtlGTW81Nw7JzN
         VUlU1pTG0DdCejfsaDNTFG7srNPmNK9UYKxobVENocntfWGYAgJlZJrJh9VGCdU/5mLD
         N4QSJ7BrwWVnCUlDXqzDZaVpTCcOI3Mnc6VrJ4gtGQOPKjJP9yA51cM75GCbOvBfRzS+
         6w7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrqIldUxmOpFaBv5a5kB88SwxfeKkHU9rJCFNHuJITDHxJ4S3IKnTsl2Qgf/vRN8X0cNzPILm6w4HvUAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YylyewKt39z1wBAna4YStvcuYzq1K0Ekb6J3yqiW49EPr3J1TvY
	CEC4rpURLTvZtylGB4F8CFttfTt+DubHEodrgPysMk2USlXd4Km3Y5fzExZNQtx9If2YVQuNe8b
	NoG8F+/HyEn5PFsO41SGYLvaPC8zmH3IBSM0XSVUh
X-Gm-Gg: ASbGnctVbr2DZWu4B3XjhPzYvayL5hGD6ozd2yRgXxpCqtEnKAdHlgYVEzPz7eDs3wc
	FB1lFok4ngxk/QR6B1vKAS61xcu706uEnygnUUY/XpbAcjeTxMudFsthsbl8xiqt8Q/ZqJVOb+b
	i2CYq6tug9lHSf2jE3qN+ZlHDNVl3w7HwQiJhSrKr3/A==
X-Google-Smtp-Source: AGHT+IHUWlE/hBzQyRWuvQBlVACkvtG5hKI3+N7pS+v+4nIHSbAmFWKknmLW6I6/oZXoRRDIJOWFClnVxojq19Eid8A=
X-Received: by 2002:a50:fa8e:0:b0:600:77b:5a5a with SMTP id
 4fb4d7f45d1cf-600077b6b0dmr120162a12.1.1747367936152; Thu, 15 May 2025
 20:58:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414224415.77926-1-robertpang@google.com> <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com> <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
In-Reply-To: <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
From: Robert Pang <robertpang@google.com>
Date: Thu, 15 May 2025 20:58:44 -0700
X-Gm-Features: AX0GCFs0u1fHfPcOvAz-3ZWqwIJrd2AaJYAZMTzIKBONGhjpH_G9niBfd3Fkf2A
Message-ID: <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Coly Li <colyli@kernel.org>, Coly Li <i@coly.li>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-bcache@vger.kernel.org, 
	Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuan-Wei,

Thank you for your prompt response. I tested your suggested patch to
inline the min heap operations for 8 hours and it is still ongoing.
Unfortunately, basing on the results so far, it didn't resolve the
regression, suggesting inlining isn't the issue.

After reviewing the commits in lib/min_heap.h, I noticed commit
c641722 ("lib min_heap: optimize number of comparisons in
min_heapify()") and it looked like a potential candidate. I reverted
this commit (below) and ran the tests. While the test is still
ongoing, the results for the past 3 hours show that the latency spikes
during invalidate_buckets_lru() disappeared after this change,
indicating that this commit is likely the root cause of the
regression.

My hypothesis is that while commit c641722 was designed to reduce
comparisons with randomized input [1], it might inadvertently increase
comparisons when the input isn't as random. A scenario where this
could happen is within invalidate_buckets_lru() before the cache is
fully populated. In such cases, many buckets are unfilled, causing
new_bucket_prio() to return zero, leading to more frequent
compare-equal operations with other unfilled buckets. In the case when
the cache is populated, the bucket priorities fall in a range with
many duplicates. How will heap_sift() behave in such cases?

[1] https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorck=
w@gmail.com/

Best regards,
Robert

---
 include/linux/min_heap.h | 46 +++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
index 1160bed6579e..2d16e6747e36 100644
--- a/include/linux/min_heap.h
+++ b/include/linux/min_heap.h
@@ -257,34 +257,32 @@ static __always_inline
 void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t
elem_size,
  const struct min_heap_callbacks *func, void *args)
 {
- const unsigned long lsbit =3D elem_size & -elem_size;
+ void *left, *right, *parent, *smallest;
  void *data =3D heap->data;
  void (*swp)(void *lhs, void *rhs, void *args) =3D func->swp;
- /* pre-scale counters for performance */
- size_t a =3D pos * elem_size;
- size_t b, c, d;
- size_t n =3D heap->nr * elem_size;
-
- if (!swp)
- swp =3D select_swap_func(data, elem_size);

- /* Find the sift-down path all the way to the leaves. */
- for (b =3D a; c =3D 2 * b + elem_size, (d =3D c + elem_size) < n;)
- b =3D func->less(data + c, data + d, args) ? c : d;
-
- /* Special case for the last leaf with no sibling. */
- if (d =3D=3D n)
- b =3D c;
-
- /* Backtrack to the correct location. */
- while (b !=3D a && func->less(data + a, data + b, args))
- b =3D parent(b, lsbit, elem_size);
+ for (;;) {
+ if (pos * 2 + 1 >=3D heap->nr)
+ break;

- /* Shift the element into its correct place. */
- c =3D b;
- while (b !=3D a) {
- b =3D parent(b, lsbit, elem_size);
- do_swap(data + b, data + c, elem_size, swp, args);
+ left =3D data + ((pos * 2 + 1) * elem_size);
+ parent =3D data + (pos * elem_size);
+ smallest =3D parent;
+ if (func->less(left, smallest, args))
+ smallest =3D left;
+
+ if (pos * 2 + 2 < heap->nr) {
+ right =3D data + ((pos * 2 + 2) * elem_size);
+ if (func->less(right, smallest, args))
+ smallest =3D right;
+ }
+ if (smallest =3D=3D parent)
+ break;
+ do_swap(smallest, parent, elem_size, swp, args);
+ if (smallest =3D=3D left)
+ pos =3D (pos * 2) + 1;
+ else
+ pos =3D (pos * 2) + 2;
  }
 }

--=20

On Thu, May 15, 2025 at 12:12=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.co=
m> wrote:
>
> Hi Robert,
>
> On Wed, May 14, 2025 at 05:58:01PM -0700, Robert Pang wrote:
> > Hi Coly,
> >
> > My apologies for the delay in providing this update; comprehensive test=
ing
> > takes some time to complete.
> >
> > As you suggested, I conducted extensive tests for 24 hours against the
> > latest 6.14.5 Linux kernel, exploring more configurations to get a comp=
lete
> > picture:
> >
> > 1. 4KB block size with writethrough mode
> > 2. 4KB block size with writeback mode (70% dirty)
> > 3. 1MB block size with writethrough mode
> >
> > The detailed results, available at [1], consistently demonstrate that o=
ur patch
> > is effective in significantly reducing latency during garbage collectio=
n. This
> > holds true for both the default writethrough mode and the 70% writeback=
 mode.
> > As anticipated, with 1MB block sizes, we observed no difference in late=
ncy
> > because the number of btree nodes is much smaller.
> >
> > [1] https://gist.github.com/robert-pang/817fa7c11ece99d25aabc0467a9427d=
8
> >
> > However, during these tests, we've uncovered a new and distinct latency=
 problem
> > that appears to be introduced in the recent Linux kernel. This issue ma=
nifests
> > as frequent and periodic latency spikes that occur outside of garbage
> > collection.
> > Below is a snippet of the latency data illustrating this:
> >
> > time (s)  median (ms)  max (ms)
> > 60810   2.28     679.37
> > 60840   2.32   2,434.24 *
> > 60870   2.46   2,434.24 *
> > 60900   2.52   2,434.24 *
> > 60930   2.63     566.15
> > 60960   2.82     566.15
> > 60990   2.82     566.15
> > 61020   2.78     471.79
> > 61050   2.93   2,028.54 *
> > 61080   3.11   2,028.54 *
> > 61110   3.29   2,028.54 *
> > 61140   3.42     679.37
> > 61170   3.42     679.37
> > 61200   3.41     679.37
> > 61230   3.30     566.15
> > 61260   2.93   1,690.45 *
> > 61290   2.75   1,690.45 *
> > 61320   2.72   1,690.45 *
> > 61350   2.88   1,408.71 *
> > 61380   5.07   1,408.71 *
> > 61410 107.94   1,408.71 **
> > 61440  65.28   1,408.71 **
> > 61470  45.41   2,028.54 **
> > 61500  72.45   2,028.54 **
> > 61530  55.37   2,028.54 **
> > 61560  40.73   1,408.71 **
> > 61590  11.48   1,690.45 **
> > 61620   2.92   1,690.45 *
> > 61650   2.54   1,690.45 *
> > 61680   2.58     679.37
> > 61710   2.78     679.37
> >
> > ** garbage collection
> > * cache replacement
> >
> > Based on the consistent periodicity of these spikes, we deduce that the=
y are
> > linked to the invalidate_buckets_lru() function during cache replacemen=
t. This
> > function was recently modified to use min heap operations [2]. To confi=
rm our
> > hypothesis, we reverted the relevant commits and re-ran the tests. Resu=
lts show
> > that the latency spikes completely disappeared, positively confirming t=
hat the
> > min heap changes introduce this regression. Furthermore, these changes =
also
> > reduce the effectiveness of our GC patch. It appears that the min heap =
changes
> > reduce heap sort speed somehow in invalidate_buckets_lr() and in GC.
>
> Thank you for reporting this regression and for taking the time to
> perform such thorough testing.
>
> My current hypothesis is that the root cause may be related to the
> earlier change where the min heap API was converted from inline to
> non-inline [1]. As a result, the comparison function used by the min
> heap is now invoked via an indirect function call instead of a direct
> one, which introduces significant overhead - especially when
> CONFIG_MITIGATION_RETPOLINE is enabled, as the cost of indirect calls
> can be quite substantial in that case.
>
> I understand that running these tests takes considerable time, but
> could you try the attached diff to see if it addresses the regression?
>
> Regards,
> Kuan-Wei
>
> [1]: https://lore.kernel.org/lkml/20241020040200.939973-2-visitorckw@gmai=
l.com/
>
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 8998e61efa40..862e7118f81d 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct cache *ca=
)
>                 if (!bch_can_invalidate_bucket(ca, b))
>                         continue;
>
> -               if (!min_heap_full(&ca->heap))
> -                       min_heap_push(&ca->heap, &b, &bucket_max_cmp_call=
back, ca);
> +               if (!min_heap_full_inline(&ca->heap))
> +                       min_heap_push_inline(&ca->heap, &b, &bucket_max_c=
mp_callback, ca);
>                 else if (!new_bucket_max_cmp(&b, min_heap_peek(&ca->heap)=
, ca)) {
>                         ca->heap.data[0] =3D b;
> -                       min_heap_sift_down(&ca->heap, 0, &bucket_max_cmp_=
callback, ca);
> +                       min_heap_sift_down_inline(&ca->heap, 0, &bucket_m=
ax_cmp_callback, ca);
>                 }
>         }
>
> -       min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
> +       min_heapify_all_inline(&ca->heap, &bucket_min_cmp_callback, ca);
>
>         while (!fifo_full(&ca->free_inc)) {
>                 if (!ca->heap.nr) {
> @@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache *ca)
>                         wake_up_gc(ca->set);
>                         return;
>                 }
> -               b =3D min_heap_peek(&ca->heap)[0];
> -               min_heap_pop(&ca->heap, &bucket_min_cmp_callback, ca);
> +               b =3D min_heap_peek_inline(&ca->heap)[0];
> +               min_heap_pop_inline(&ca->heap, &bucket_min_cmp_callback, =
ca);
>
>                 bch_invalidate_one_bucket(ca, b);
>         }
>
> >
> > [2] https://lore.kernel.org/linux-bcache/ZxzkLJmhn3a%2F1ALQ@visitorckw-=
System-Product-Name/T/#m0dd24ba0c63615de465d3fec72dc73febb0f7a94
> >
> > You may download the full test result data from these links.
> >
> > https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#fi=
le-bcache-latency-4kb-no-patch-csv
> > https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#fi=
le-bcache-latency-4kb-with-patch-csv
> > https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#fi=
le-bcache-latency-4kb-wb-no-patch-csv
> > https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#fi=
le-bcache-latency-4kb-wb-with-patch-csv
> > https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#fi=
le-bcache-latency-1mb-no-patch-csv
> > https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#fi=
le-bcache-latency-1mb-with-patch-csv
> > https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#fi=
le-bcache-latency-4kb-no-patch-min-heap-reverted-csv
> > https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#fi=
le-bcache-latency-4kb-with-patch-min-heap-reverted-csv
> >
> > Best regards
> > Robert Pang
> >
> > On Sat, May 3, 2025 at 10:33=E2=80=AFAM Coly Li <colyli@kernel.org> wro=
te:
> > >
> > > On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
> > > > Hi Coly,
> > > >
> > > > Please disregard the test results I shared over a week ago. After d=
igging
> > > > deeper into the recent latency spikes with various workloads and by
> > > > instrumenting the garbage collector, I realized that the earlier GC=
 latency
> > > > patch, "bcache: allow allocator to invalidate bucket in gc" [1], wa=
sn't
> > > > backported to the Linux 6.6 branch I tested my patch against. This =
omission
> > > > explains the much higher latency observed during the extended test =
because the
> > > > allocator was blocked for the entire GC. My sincere apologies for t=
he
> > > > inconsistent results and any confusion this has caused.
> > > >
> > >
> > > Did you also backport commit 05356938a4be ("bcache: call force_wake_u=
p_gc()
> > > if necessary in check_should_bypass()") ? Last time when you pushed m=
e to
> > > add commit a14a68b76954 into mainline kernel, I tested a regression f=
rom this
> > > patch and fixed it. Please add this fix if you didn't, otherwise the =
testing
> > > might not be completed.
> > >
> > >
> > > > With patch [1] back-patched and after a 24-hour re-test, the fio re=
sults clearly
> > > > demonstrate that this patch effectively reduces front IO latency du=
ring GC due
> > > > to the smaller incremental GC cycles, while the GC duration increas=
e is still
> > > > well within bounds.
> > > >
> > >
> > > From the performance result in [2], it seems the max latency are redu=
ced,
> > > but higher latency period are longer. I am not sure whether this is a=
 happy
> > > result.
> > >
> > > Can I have a download link for the whole log? Then I can look at the
> > > performance numbers more close.
> > >
> > > > Here's a summary of the improved latency:
> > > >
> > > > Before:
> > > >
> > > > Median latency (P50): 210 ms
> > > > Max latency (P100): 3.5 sec
> > > >
> > > > btree_gc_average_duration_ms:381138
> > > > btree_gc_average_frequency_sec:3834
> > > > btree_gc_last_sec:60668
> > > > btree_gc_max_duration_ms:825228
> > > > bset_tree_stats:
> > > > btree nodes: 144330
> > > > written sets: 283733
> > > > unwritten sets: 144329
> > > > written key bytes: 24993783392
> > > > unwritten key bytes: 11777400
> > > > floats: 30936844345385
> > > > failed: 5776
> > > >
> > > > After:
> > > >
> > > > Median latency (P50): 25 ms
> > > > Max latency (P100): 0.8 sec
> > > >
> > > > btree_gc_average_duration_ms:622274
> > > > btree_gc_average_frequency_sec:3518
> > > > btree_gc_last_sec:8931
> > > > btree_gc_max_duration_ms:953146
> > > > bset_tree_stats:
> > > > btree nodes: 175491
> > > > written sets: 339078
> > > > unwritten sets: 175488
> > > > written key bytes: 29821314856
> > > > unwritten key bytes: 14076504
> > > > floats: 90520963280544
> > > > failed: 6462
> > > >
> > > > The complete latency data is available at [2].
> > > >
> > > > I will be glad to run further tests to solidify these findings for =
the inclusion
> > > > of this patch in the coming merge window. Let me know if you'd like=
 me to
> > > > conduct any specific tests.
> > >
> > > Yes, more testing are necessary, from 512 Bytes block size to 1 MiB o=
r
> > > 8MiB block size. We need to make sure it won't introduce performance
> > > regression in other workload or circumstances.
> > >
> > > I don't have plan to submit this patch in this merge window, and plea=
se don't
> > > push me. For performance improvement change, I prefer the defalt
> > > configuration will cover most of work loads, so more testing and perf=
oramce
> > > data are desired. E.g. the patch you mentioned (commit a14a68b76954 "=
bcache:
> > > allow allocator to invalidate bucket in gc"), it had been deployed in=
 Easy
> > > Stack product environment for 20+ months before it got merged.
> > >
> > > Thanks.
> > >
> > > >
> > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.=
git/commit/?id=3Da14a68b76954e73031ca6399abace17dcb77c17a
> > > > [2[ https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f=
9180f
> > >
> > > [snipped]
> > >
> > > --
> > > Coly Li

