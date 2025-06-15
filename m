Return-Path: <linux-bcache+bounces-1139-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9901ADA11B
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Jun 2025 07:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0083189306B
	for <lists+linux-bcache@lfdr.de>; Sun, 15 Jun 2025 05:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F3F13C695;
	Sun, 15 Jun 2025 05:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnnqJR8Q"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5626B7E1;
	Sun, 15 Jun 2025 05:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749966669; cv=none; b=ndOr9NOCJrQDFyt+c+TAznEJkyAegOhxBe2LBhT4+trna+C2m6gp/g8iBlnk+myw+qVoXdH1723nXYYhgL2OMBKDv4CU8aFvMrHudbUhMTJBu09XGqR7FfNZ0cdd8790X8APw3C6227pNda2ofnm5pMLPXIX9cM9qys12IeIuBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749966669; c=relaxed/simple;
	bh=6N+nJohxUYmU9dyQImiIi5I7duGmVAsXiiFmutRJHZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QWg+tu5ncM7XzdIeF/LmM9NmW1qouEX77DZiNBESLpH/qHQ7siXTUM41DlPpShJLgje+afhDYdnwwW61giBChHViFiAfNG2UfbP0+MrU5fP7qzHXgomVBIS0QCGKvdR/w4KCSOIWb/djuHoABiN1VIKijKJegS8OEHrzvm5fwC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnnqJR8Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D41AC4CEE3;
	Sun, 15 Jun 2025 05:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749966669;
	bh=6N+nJohxUYmU9dyQImiIi5I7duGmVAsXiiFmutRJHZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YnnqJR8Qzbgpv2FS3/rDvyQqU9HryewynZZ6sYqOxr1KxIXXlUwg7u18tUS2GScn9
	 yW2HJePtVXLqSaXhZOYPTaBee/w0VRORnUEqnjBIyvWSCXZGWAOjp91wlnqmQbbAXE
	 ZeBQi+ze3/IPJmMeetd0nAdXUjisPVRi9JlZBhvtIn63ka1dbPXJHIJyGXo/yDlUBq
	 QM36OT9i5W51eNh7FxheIFJSlgT4PsC27cXpVBcNrPbdAqGTtn/bbM9GMNL9OCHIfE
	 aLhSpnV2dJwcePhKWVSIGF+Wa0gnxz/DnAV/QfEzuknShcHk9kMmyt+Cmn89sdEqvG
	 MrsBrpphLSS+w==
Date: Sun, 15 Jun 2025 13:51:03 +0800
From: Coly Li <colyli@kernel.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	robertpang@google.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, 
	jserv@ccns.ncku.edu.tw, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] Revert "bcache: update min_heap_callbacks to use
 default builtin swap"
Message-ID: <sciqwitrhiosfwo3mrqy5ybf3u65m7vghcet7mnefxyh7uwl2m@viciqkpuoozn>
References: <20250614202353.1632957-1-visitorckw@gmail.com>
 <20250614202353.1632957-2-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250614202353.1632957-2-visitorckw@gmail.com>

On Sun, Jun 15, 2025 at 04:23:51AM +0800, Kuan-Wei Chiu wrote:
> This reverts commit 3d8a9a1c35227c3f1b0bd132c9f0a80dbda07b65.
> 
> Although removing the custom swap function simplified the code, this
> change is part of a broader migration to the generic min_heap API that
> introduced significant performance regressions in bcache.
> 
> As reported by Robert, bcache now suffers from latency spikes, with
> P100 (max) latency increasing from 600 ms to 2.4 seconds every 5
> minutes. These regressions degrade bcache's effectiveness as a
> low-latency cache layer and lead to frequent timeouts and application
> stalls in production environments.
> 
> This revert is part of a series of changes to restore previous
> performance by undoing the min_heap transition.
> 
> Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
> Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
> Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
> Reported-by: Robert Pang <robertpang@google.com>
> Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Acked-by: Coly Li <colyli@kernel.org>

Thanks.


> ---
>  drivers/md/bcache/alloc.c    | 11 +++++++++--
>  drivers/md/bcache/bset.c     | 14 +++++++++++---
>  drivers/md/bcache/extents.c  | 10 +++++++++-
>  drivers/md/bcache/movinggc.c | 10 +++++++++-
>  4 files changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
> index 8998e61efa40..da50f6661bae 100644
> --- a/drivers/md/bcache/alloc.c
> +++ b/drivers/md/bcache/alloc.c
> @@ -189,16 +189,23 @@ static inline bool new_bucket_min_cmp(const void *l, const void *r, void *args)
>  	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
>  }
>  
> +static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
> +{
> +	struct bucket **lhs = l, **rhs = r;
> +
> +	swap(*lhs, *rhs);
> +}
> +
>  static void invalidate_buckets_lru(struct cache *ca)
>  {
>  	struct bucket *b;
>  	const struct min_heap_callbacks bucket_max_cmp_callback = {
>  		.less = new_bucket_max_cmp,
> -		.swp = NULL,
> +		.swp = new_bucket_swap,
>  	};
>  	const struct min_heap_callbacks bucket_min_cmp_callback = {
>  		.less = new_bucket_min_cmp,
> -		.swp = NULL,
> +		.swp = new_bucket_swap,
>  	};
>  
>  	ca->heap.nr = 0;
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 68258a16e125..bd97d8626887 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -1093,6 +1093,14 @@ static inline bool new_btree_iter_cmp(const void *l, const void *r, void __alway
>  	return bkey_cmp(_l->k, _r->k) <= 0;
>  }
>  
> +static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
> +{
> +	struct btree_iter_set *_iter1 = iter1;
> +	struct btree_iter_set *_iter2 = iter2;
> +
> +	swap(*_iter1, *_iter2);
> +}
> +
>  static inline bool btree_iter_end(struct btree_iter *iter)
>  {
>  	return !iter->heap.nr;
> @@ -1103,7 +1111,7 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
>  {
>  	const struct min_heap_callbacks callbacks = {
>  		.less = new_btree_iter_cmp,
> -		.swp = NULL,
> +		.swp = new_btree_iter_swap,
>  	};
>  
>  	if (k != end)
> @@ -1149,7 +1157,7 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
>  	struct bkey *ret = NULL;
>  	const struct min_heap_callbacks callbacks = {
>  		.less = cmp,
> -		.swp = NULL,
> +		.swp = new_btree_iter_swap,
>  	};
>  
>  	if (!btree_iter_end(iter)) {
> @@ -1223,7 +1231,7 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
>  		: bch_ptr_invalid;
>  	const struct min_heap_callbacks callbacks = {
>  		.less = b->ops->sort_cmp,
> -		.swp = NULL,
> +		.swp = new_btree_iter_swap,
>  	};
>  
>  	/* Heapify the iterator, using our comparison function */
> diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
> index 4b84fda1530a..a7221e5dbe81 100644
> --- a/drivers/md/bcache/extents.c
> +++ b/drivers/md/bcache/extents.c
> @@ -266,12 +266,20 @@ static bool new_bch_extent_sort_cmp(const void *l, const void *r, void __always_
>  	return !(c ? c > 0 : _l->k < _r->k);
>  }
>  
> +static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
> +{
> +	struct btree_iter_set *_iter1 = iter1;
> +	struct btree_iter_set *_iter2 = iter2;
> +
> +	swap(*_iter1, *_iter2);
> +}
> +
>  static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
>  					  struct bkey *tmp)
>  {
>  	const struct min_heap_callbacks callbacks = {
>  		.less = new_bch_extent_sort_cmp,
> -		.swp = NULL,
> +		.swp = new_btree_iter_swap,
>  	};
>  	while (iter->heap.nr > 1) {
>  		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
> diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
> index 45ca134cbf02..d6c73dd8eb2b 100644
> --- a/drivers/md/bcache/movinggc.c
> +++ b/drivers/md/bcache/movinggc.c
> @@ -190,6 +190,14 @@ static bool new_bucket_cmp(const void *l, const void *r, void __always_unused *a
>  	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
>  }
>  
> +static void new_bucket_swap(void *l, void *r, void __always_unused *args)
> +{
> +	struct bucket **_l = l;
> +	struct bucket **_r = r;
> +
> +	swap(*_l, *_r);
> +}
> +
>  static unsigned int bucket_heap_top(struct cache *ca)
>  {
>  	struct bucket *b;
> @@ -204,7 +212,7 @@ void bch_moving_gc(struct cache_set *c)
>  	unsigned long sectors_to_move, reserve_sectors;
>  	const struct min_heap_callbacks callbacks = {
>  		.less = new_bucket_cmp,
> -		.swp = NULL,
> +		.swp = new_bucket_swap,
>  	};
>  
>  	if (!c->copy_gc_enabled)
> -- 
> 2.34.1
> 

-- 
Coly Li

