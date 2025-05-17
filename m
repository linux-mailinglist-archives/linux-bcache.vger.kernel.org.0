Return-Path: <linux-bcache+bounces-1069-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C604BABAA65
	for <lists+linux-bcache@lfdr.de>; Sat, 17 May 2025 15:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A184C189CF65
	for <lists+linux-bcache@lfdr.de>; Sat, 17 May 2025 13:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDE2B1E3787;
	Sat, 17 May 2025 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="u50jBWJz"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail85.out.titan.email (mail85.out.titan.email [3.216.99.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1301FCA6B
	for <linux-bcache@vger.kernel.org>; Sat, 17 May 2025 13:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.216.99.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747488589; cv=none; b=uTOLoBr//rGTQkP72xk1/qvsYLq0D+UsbnQMe05+tOWWpWLru0UqkQHrcCtj7keta9IZ7DAK8AFvQUEgMYwQtRM+LgoOYaUV+tebjtCrIXS6Z0Y5feB9ITsCfoIe4Xv5ho3fLtHwmUB9vZpzzfwHsp64TxuwUVZa2zp2hwqgskU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747488589; c=relaxed/simple;
	bh=AVx9ur0haYsQMU1HUAK6D/E4QlzeYKwvqRaGwJFsruE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=oft1yK5xWEUOnnlQswU0bROuFV3/BMHV9nsuLd4mc0TpepCjCVrq6aXJApj7Wgyd4SaECJR3bHWryNDvZINNfq2kAjowRmk3d4bsAiwiXKdOAZw/mWSCkGVMtQIerBTjvhp6gZSXXrPJ6DwfllpuYpmJEitacqfqpjn7rTK5uZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=u50jBWJz; arc=none smtp.client-ip=3.216.99.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Received: from localhost (localhost [127.0.0.1])
	by smtp-out.flockmail.com (Postfix) with ESMTP id 8C2BF10029D;
	Sat, 17 May 2025 11:02:21 +0000 (UTC)
DKIM-Signature: a=rsa-sha256; bh=pPGEFztb6r6w2TboT4egAlI7ZFfYC6Pu6ehTf+B81DA=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=in-reply-to:references:mime-version:from:date:message-id:to:subject:cc:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1747479741; v=1;
	b=u50jBWJz6v3XzSSPa5hJTMfECM/S6MRt+tD+WNsX4tA7TOuf+vzveSIPwt8uqc+V4pqf3usD
	tEzYkiumsTcNLpAKo+49bTQEtmrS5ZlNem4uF7e79X3yId4fGYGDw1N3td0oZu71HaI54EtUJId
	06QtbLQy/K98k0T8g91CKdIE=
Received: from smtpclient.apple (n218103205009.netvigator.com [218.103.205.9])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 44490100399;
	Sat, 17 May 2025 11:02:19 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [PATCH 0/1] bcache: reduce front IO latency during GC
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
Date: Sat, 17 May 2025 19:02:06 +0800
Cc: Robert Pang <robertpang@google.com>,
 Coly Li <colyli@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcache@vger.kernel.org,
 Mingzhe Zou <mingzhe.zou@easystack.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AD23C0A6-E754-4E43-AF54-BCFF82B19450@coly.li>
References: <20250414224415.77926-1-robertpang@google.com>
 <75D48114-A5BD-4AC6-9370-D61456FD4FD2@coly.li>
 <CAJhEC07JauBGfqmEaYbV9XuLUkCdbart-gnbuMWYE7JwzG4CsA@mail.gmail.com>
 <CAJhEC04Po-OtwDe2Uxo2w-0yhgcemo5sn816sT7jNhnEdRxY4Q@mail.gmail.com>
 <pxfu7dxykuj2qnw4m2hyjohmwdyq562zlwnvdphqdbwvttztki@dyx4sa553clx>
 <CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com>
 <aCWTxp7/t8nnBuzD@visitorckw-System-Product-Name>
 <CAJhEC04qo8CFcFi6tmn9Y28MpasVB93Duboj1gqR1nfOXO+Z2g@mail.gmail.com>
 <aCdkgzPGWzcjXCrf@visitorckw-System-Product-Name>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1747479741351170763.20113.3881625013598339502@prod-use1-smtp-out1002.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=U8BoDfru c=1 sm=1 tr=0 ts=68286cbd
	a=eJNHGpZBYRW47XJYT+WeIA==:117 a=eJNHGpZBYRW47XJYT+WeIA==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
	a=NEAV23lmAAAA:8 a=Zjz8y5g7h5Ep_I6t8r0A:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B45=E6=9C=8817=E6=97=A5 00:14=EF=BC=8CKuan-Wei Chiu =
<visitorckw@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, May 15, 2025 at 08:58:44PM -0700, Robert Pang wrote:
>> Hi Kuan-Wei,
>>=20
>> Thank you for your prompt response. I tested your suggested patch to
>> inline the min heap operations for 8 hours and it is still ongoing.
>> Unfortunately, basing on the results so far, it didn't resolve the
>> regression, suggesting inlining isn't the issue.
>>=20
>> After reviewing the commits in lib/min_heap.h, I noticed commit
>> c641722 ("lib min_heap: optimize number of comparisons in
>> min_heapify()") and it looked like a potential candidate. I reverted
>> this commit (below) and ran the tests. While the test is still
>> ongoing, the results for the past 3 hours show that the latency =
spikes
>> during invalidate_buckets_lru() disappeared after this change,
>> indicating that this commit is likely the root cause of the
>> regression.
>>=20
>> My hypothesis is that while commit c641722 was designed to reduce
>> comparisons with randomized input [1], it might inadvertently =
increase
>> comparisons when the input isn't as random. A scenario where this
>> could happen is within invalidate_buckets_lru() before the cache is
>> fully populated. In such cases, many buckets are unfilled, causing
>> new_bucket_prio() to return zero, leading to more frequent
>> compare-equal operations with other unfilled buckets. In the case =
when
>> the cache is populated, the bucket priorities fall in a range with
>> many duplicates. How will heap_sift() behave in such cases?
>>=20
>> [1] =
https://lore.kernel.org/linux-bcache/20240121153649.2733274-6-visitorckw@g=
mail.com/
>>=20
>=20
> You're very likely correct.
>=20
> In scenarios where the majority of elements in the heap are identical,
> the traditional top-down version of heapify finishes after just 2
> comparisons. However, with the bottom-up version introduced by that
> commit, it ends up performing roughly 2 * log=E2=82=82(n) comparisons =
in the
> same case.

For bcache scenario for ideal circumstances and best performance, the =
cached data
and following requests should have spatial or temporal locality.

I guess it means for the heap usage, the input might not be typical =
random.


>=20
> That said, reverting the commit would increase the number of
> comparisons by about 2x in cases where all elements in the heap are
> distinct, which was the original motivation for the change. I'm not
> entirely sure what the best way would be to fix this regression =
without
> negatively impacting the performance of the other use cases.

If the data read model are fully sequential or random, bcache cannot =
help too much.

So I guess maybe we still need to old heapify code? The new version is =
for full random input,
and previous version for not that much random input.

Thanks.

Coly Li


>=20
> Regards,
> Kuan-Wei
>=20
>> Best regards,
>> Robert
>>=20
>> ---
>> include/linux/min_heap.h | 46 =
+++++++++++++++++++---------------------
>> 1 file changed, 22 insertions(+), 24 deletions(-)
>>=20
>> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
>> index 1160bed6579e..2d16e6747e36 100644
>> --- a/include/linux/min_heap.h
>> +++ b/include/linux/min_heap.h
>> @@ -257,34 +257,32 @@ static __always_inline
>> void __min_heap_sift_down_inline(min_heap_char *heap, int pos, size_t
>> elem_size,
>>  const struct min_heap_callbacks *func, void *args)
>> {
>> - const unsigned long lsbit =3D elem_size & -elem_size;
>> + void *left, *right, *parent, *smallest;
>>  void *data =3D heap->data;
>>  void (*swp)(void *lhs, void *rhs, void *args) =3D func->swp;
>> - /* pre-scale counters for performance */
>> - size_t a =3D pos * elem_size;
>> - size_t b, c, d;
>> - size_t n =3D heap->nr * elem_size;
>> -
>> - if (!swp)
>> - swp =3D select_swap_func(data, elem_size);
>>=20
>> - /* Find the sift-down path all the way to the leaves. */
>> - for (b =3D a; c =3D 2 * b + elem_size, (d =3D c + elem_size) < n;)
>> - b =3D func->less(data + c, data + d, args) ? c : d;
>> -
>> - /* Special case for the last leaf with no sibling. */
>> - if (d =3D=3D n)
>> - b =3D c;
>> -
>> - /* Backtrack to the correct location. */
>> - while (b !=3D a && func->less(data + a, data + b, args))
>> - b =3D parent(b, lsbit, elem_size);
>> + for (;;) {
>> + if (pos * 2 + 1 >=3D heap->nr)
>> + break;
>>=20
>> - /* Shift the element into its correct place. */
>> - c =3D b;
>> - while (b !=3D a) {
>> - b =3D parent(b, lsbit, elem_size);
>> - do_swap(data + b, data + c, elem_size, swp, args);
>> + left =3D data + ((pos * 2 + 1) * elem_size);
>> + parent =3D data + (pos * elem_size);
>> + smallest =3D parent;
>> + if (func->less(left, smallest, args))
>> + smallest =3D left;
>> +
>> + if (pos * 2 + 2 < heap->nr) {
>> + right =3D data + ((pos * 2 + 2) * elem_size);
>> + if (func->less(right, smallest, args))
>> + smallest =3D right;
>> + }
>> + if (smallest =3D=3D parent)
>> + break;
>> + do_swap(smallest, parent, elem_size, swp, args);
>> + if (smallest =3D=3D left)
>> + pos =3D (pos * 2) + 1;
>> + else
>> + pos =3D (pos * 2) + 2;
>>  }
>> }
>>=20
>> --=20
>>=20
>> On Thu, May 15, 2025 at 12:12=E2=80=AFAM Kuan-Wei Chiu =
<visitorckw@gmail.com> wrote:
>>>=20
>>> Hi Robert,
>>>=20
>>> On Wed, May 14, 2025 at 05:58:01PM -0700, Robert Pang wrote:
>>>> Hi Coly,
>>>>=20
>>>> My apologies for the delay in providing this update; comprehensive =
testing
>>>> takes some time to complete.
>>>>=20
>>>> As you suggested, I conducted extensive tests for 24 hours against =
the
>>>> latest 6.14.5 Linux kernel, exploring more configurations to get a =
complete
>>>> picture:
>>>>=20
>>>> 1. 4KB block size with writethrough mode
>>>> 2. 4KB block size with writeback mode (70% dirty)
>>>> 3. 1MB block size with writethrough mode
>>>>=20
>>>> The detailed results, available at [1], consistently demonstrate =
that our patch
>>>> is effective in significantly reducing latency during garbage =
collection. This
>>>> holds true for both the default writethrough mode and the 70% =
writeback mode.
>>>> As anticipated, with 1MB block sizes, we observed no difference in =
latency
>>>> because the number of btree nodes is much smaller.
>>>>=20
>>>> [1] =
https://gist.github.com/robert-pang/817fa7c11ece99d25aabc0467a9427d8
>>>>=20
>>>> However, during these tests, we've uncovered a new and distinct =
latency problem
>>>> that appears to be introduced in the recent Linux kernel. This =
issue manifests
>>>> as frequent and periodic latency spikes that occur outside of =
garbage
>>>> collection.
>>>> Below is a snippet of the latency data illustrating this:
>>>>=20
>>>> time (s)  median (ms)  max (ms)
>>>> 60810   2.28     679.37
>>>> 60840   2.32   2,434.24 *
>>>> 60870   2.46   2,434.24 *
>>>> 60900   2.52   2,434.24 *
>>>> 60930   2.63     566.15
>>>> 60960   2.82     566.15
>>>> 60990   2.82     566.15
>>>> 61020   2.78     471.79
>>>> 61050   2.93   2,028.54 *
>>>> 61080   3.11   2,028.54 *
>>>> 61110   3.29   2,028.54 *
>>>> 61140   3.42     679.37
>>>> 61170   3.42     679.37
>>>> 61200   3.41     679.37
>>>> 61230   3.30     566.15
>>>> 61260   2.93   1,690.45 *
>>>> 61290   2.75   1,690.45 *
>>>> 61320   2.72   1,690.45 *
>>>> 61350   2.88   1,408.71 *
>>>> 61380   5.07   1,408.71 *
>>>> 61410 107.94   1,408.71 **
>>>> 61440  65.28   1,408.71 **
>>>> 61470  45.41   2,028.54 **
>>>> 61500  72.45   2,028.54 **
>>>> 61530  55.37   2,028.54 **
>>>> 61560  40.73   1,408.71 **
>>>> 61590  11.48   1,690.45 **
>>>> 61620   2.92   1,690.45 *
>>>> 61650   2.54   1,690.45 *
>>>> 61680   2.58     679.37
>>>> 61710   2.78     679.37
>>>>=20
>>>> ** garbage collection
>>>> * cache replacement
>>>>=20
>>>> Based on the consistent periodicity of these spikes, we deduce that =
they are
>>>> linked to the invalidate_buckets_lru() function during cache =
replacement. This
>>>> function was recently modified to use min heap operations [2]. To =
confirm our
>>>> hypothesis, we reverted the relevant commits and re-ran the tests. =
Results show
>>>> that the latency spikes completely disappeared, positively =
confirming that the
>>>> min heap changes introduce this regression. Furthermore, these =
changes also
>>>> reduce the effectiveness of our GC patch. It appears that the min =
heap changes
>>>> reduce heap sort speed somehow in invalidate_buckets_lr() and in =
GC.
>>>=20
>>> Thank you for reporting this regression and for taking the time to
>>> perform such thorough testing.
>>>=20
>>> My current hypothesis is that the root cause may be related to the
>>> earlier change where the min heap API was converted from inline to
>>> non-inline [1]. As a result, the comparison function used by the min
>>> heap is now invoked via an indirect function call instead of a =
direct
>>> one, which introduces significant overhead - especially when
>>> CONFIG_MITIGATION_RETPOLINE is enabled, as the cost of indirect =
calls
>>> can be quite substantial in that case.
>>>=20
>>> I understand that running these tests takes considerable time, but
>>> could you try the attached diff to see if it addresses the =
regression?
>>>=20
>>> Regards,
>>> Kuan-Wei
>>>=20
>>> [1]: =
https://lore.kernel.org/lkml/20241020040200.939973-2-visitorckw@gmail.com/=

>>>=20
>>> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
>>> index 8998e61efa40..862e7118f81d 100644
>>> --- a/drivers/md/bcache/alloc.c
>>> +++ b/drivers/md/bcache/alloc.c
>>> @@ -207,15 +207,15 @@ static void invalidate_buckets_lru(struct =
cache *ca)
>>>                if (!bch_can_invalidate_bucket(ca, b))
>>>                        continue;
>>>=20
>>> -               if (!min_heap_full(&ca->heap))
>>> -                       min_heap_push(&ca->heap, &b, =
&bucket_max_cmp_callback, ca);
>>> +               if (!min_heap_full_inline(&ca->heap))
>>> +                       min_heap_push_inline(&ca->heap, &b, =
&bucket_max_cmp_callback, ca);
>>>                else if (!new_bucket_max_cmp(&b, =
min_heap_peek(&ca->heap), ca)) {
>>>                        ca->heap.data[0] =3D b;
>>> -                       min_heap_sift_down(&ca->heap, 0, =
&bucket_max_cmp_callback, ca);
>>> +                       min_heap_sift_down_inline(&ca->heap, 0, =
&bucket_max_cmp_callback, ca);
>>>                }
>>>        }
>>>=20
>>> -       min_heapify_all(&ca->heap, &bucket_min_cmp_callback, ca);
>>> +       min_heapify_all_inline(&ca->heap, &bucket_min_cmp_callback, =
ca);
>>>=20
>>>        while (!fifo_full(&ca->free_inc)) {
>>>                if (!ca->heap.nr) {
>>> @@ -227,8 +227,8 @@ static void invalidate_buckets_lru(struct cache =
*ca)
>>>                        wake_up_gc(ca->set);
>>>                        return;
>>>                }
>>> -               b =3D min_heap_peek(&ca->heap)[0];
>>> -               min_heap_pop(&ca->heap, &bucket_min_cmp_callback, =
ca);
>>> +               b =3D min_heap_peek_inline(&ca->heap)[0];
>>> +               min_heap_pop_inline(&ca->heap, =
&bucket_min_cmp_callback, ca);
>>>=20
>>>                bch_invalidate_one_bucket(ca, b);
>>>        }
>>>=20
>>>>=20
>>>> [2] =
https://lore.kernel.org/linux-bcache/ZxzkLJmhn3a%2F1ALQ@visitorckw-System-=
Product-Name/T/#m0dd24ba0c63615de465d3fec72dc73febb0f7a94
>>>>=20
>>>> You may download the full test result data from these links.
>>>>=20
>>>> =
https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-=
bcache-latency-4kb-no-patch-csv
>>>> =
https://gist.github.com/robert-pang/5df1d595ee77756c0a01d6479bdf8e34#file-=
bcache-latency-4kb-with-patch-csv
>>>> =
https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-=
bcache-latency-4kb-wb-no-patch-csv
>>>> =
https://gist.github.com/robert-pang/bcc26a3aa90dc95a083799cf4fd48116#file-=
bcache-latency-4kb-wb-with-patch-csv
>>>> =
https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-=
bcache-latency-1mb-no-patch-csv
>>>> =
https://gist.github.com/robert-pang/7036b06b66c8de7e958cdbddcd92a3f5#file-=
bcache-latency-1mb-with-patch-csv
>>>> =
https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-=
bcache-latency-4kb-no-patch-min-heap-reverted-csv
>>>> =
https://gist.github.com/robert-pang/40f90afdea2d2a8c3f6e22ff959eff03#file-=
bcache-latency-4kb-with-patch-min-heap-reverted-csv
>>>>=20
>>>> Best regards
>>>> Robert Pang
>>>>=20
>>>> On Sat, May 3, 2025 at 10:33=E2=80=AFAM Coly Li <colyli@kernel.org> =
wrote:
>>>>>=20
>>>>> On Thu, May 01, 2025 at 06:01:09PM +0800, Robert Pang wrote:
>>>>>> Hi Coly,
>>>>>>=20
>>>>>> Please disregard the test results I shared over a week ago. After =
digging
>>>>>> deeper into the recent latency spikes with various workloads and =
by
>>>>>> instrumenting the garbage collector, I realized that the earlier =
GC latency
>>>>>> patch, "bcache: allow allocator to invalidate bucket in gc" [1], =
wasn't
>>>>>> backported to the Linux 6.6 branch I tested my patch against. =
This omission
>>>>>> explains the much higher latency observed during the extended =
test because the
>>>>>> allocator was blocked for the entire GC. My sincere apologies for =
the
>>>>>> inconsistent results and any confusion this has caused.
>>>>>>=20
>>>>>=20
>>>>> Did you also backport commit 05356938a4be ("bcache: call =
force_wake_up_gc()
>>>>> if necessary in check_should_bypass()") ? Last time when you =
pushed me to
>>>>> add commit a14a68b76954 into mainline kernel, I tested a =
regression from this
>>>>> patch and fixed it. Please add this fix if you didn't, otherwise =
the testing
>>>>> might not be completed.
>>>>>=20
>>>>>=20
>>>>>> With patch [1] back-patched and after a 24-hour re-test, the fio =
results clearly
>>>>>> demonstrate that this patch effectively reduces front IO latency =
during GC due
>>>>>> to the smaller incremental GC cycles, while the GC duration =
increase is still
>>>>>> well within bounds.
>>>>>>=20
>>>>>=20
>>>>> =46rom the performance result in [2], it seems the max latency are =
reduced,
>>>>> but higher latency period are longer. I am not sure whether this =
is a happy
>>>>> result.
>>>>>=20
>>>>> Can I have a download link for the whole log? Then I can look at =
the
>>>>> performance numbers more close.
>>>>>=20
>>>>>> Here's a summary of the improved latency:
>>>>>>=20
>>>>>> Before:
>>>>>>=20
>>>>>> Median latency (P50): 210 ms
>>>>>> Max latency (P100): 3.5 sec
>>>>>>=20
>>>>>> btree_gc_average_duration_ms:381138
>>>>>> btree_gc_average_frequency_sec:3834
>>>>>> btree_gc_last_sec:60668
>>>>>> btree_gc_max_duration_ms:825228
>>>>>> bset_tree_stats:
>>>>>> btree nodes: 144330
>>>>>> written sets: 283733
>>>>>> unwritten sets: 144329
>>>>>> written key bytes: 24993783392
>>>>>> unwritten key bytes: 11777400
>>>>>> floats: 30936844345385
>>>>>> failed: 5776
>>>>>>=20
>>>>>> After:
>>>>>>=20
>>>>>> Median latency (P50): 25 ms
>>>>>> Max latency (P100): 0.8 sec
>>>>>>=20
>>>>>> btree_gc_average_duration_ms:622274
>>>>>> btree_gc_average_frequency_sec:3518
>>>>>> btree_gc_last_sec:8931
>>>>>> btree_gc_max_duration_ms:953146
>>>>>> bset_tree_stats:
>>>>>> btree nodes: 175491
>>>>>> written sets: 339078
>>>>>> unwritten sets: 175488
>>>>>> written key bytes: 29821314856
>>>>>> unwritten key bytes: 14076504
>>>>>> floats: 90520963280544
>>>>>> failed: 6462
>>>>>>=20
>>>>>> The complete latency data is available at [2].
>>>>>>=20
>>>>>> I will be glad to run further tests to solidify these findings =
for the inclusion
>>>>>> of this patch in the coming merge window. Let me know if you'd =
like me to
>>>>>> conduct any specific tests.
>>>>>=20
>>>>> Yes, more testing are necessary, from 512 Bytes block size to 1 =
MiB or
>>>>> 8MiB block size. We need to make sure it won't introduce =
performance
>>>>> regression in other workload or circumstances.
>>>>>=20
>>>>> I don't have plan to submit this patch in this merge window, and =
please don't
>>>>> push me. For performance improvement change, I prefer the defalt
>>>>> configuration will cover most of work loads, so more testing and =
perforamce
>>>>> data are desired. E.g. the patch you mentioned (commit =
a14a68b76954 "bcache:
>>>>> allow allocator to invalidate bucket in gc"), it had been deployed =
in Easy
>>>>> Stack product environment for 20+ months before it got merged.
>>>>>=20
>>>>> Thanks.
>>>>>=20
>>>>>>=20
>>>>>> [1] =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3Da14a68b76954e73031ca6399abace17dcb77c17a
>>>>>> [2[ =
https://gist.github.com/robert-pang/cc7c88f356293ea6d43103e6e5f9180f
>>>>>=20
>>>>> [snipped]
>>>>>=20
>>>>> --
>>>>> Coly Li



