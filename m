Return-Path: <linux-bcache+bounces-1072-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EC22ABD825
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 14:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76CC23A86B7
	for <lists+linux-bcache@lfdr.de>; Tue, 20 May 2025 12:25:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153A8EED7;
	Tue, 20 May 2025 12:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyXfVcF2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35C7DDA9
	for <linux-bcache@vger.kernel.org>; Tue, 20 May 2025 12:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747743943; cv=none; b=dQjjnZvDWRnhIBVSad/SttU9+GUuKtJ/Da9e2H/YsextgjpZW+fJHCOrjuCJPglDDQ10n2hy8r8HABjU7woBwoennLcfieY2awpYNdxW2eEwU+6l7BRutDWZSmoJCVxe1WrkLHHnliYjWI/q0q0WCnrAOvxAFAZtjJZ7/UKIEnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747743943; c=relaxed/simple;
	bh=mHg3+xLewKpAJkTcDwdE9rXWkdFKbHoQIOyZNr5FH2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9B0g0q3nY252EKEfepzxNizJkXggrlNc2SqaDVMpU05GJIT/9020EMf0LFSnxsn4GoSe4lVM1Oc+dqdtohYMUdEJ5saVaP7g+XB+f7wRhmTKoNIuBZwOSdYj1rvDKUaNdKH7io6y7WddIQuopJakKaHCZWXiMCN/NxIjQ0FCIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyXfVcF2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3657C4CEE9;
	Tue, 20 May 2025 12:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747743941;
	bh=mHg3+xLewKpAJkTcDwdE9rXWkdFKbHoQIOyZNr5FH2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FyXfVcF2trWYovwg7ytvJB+rm+0R13/2cLkoEngSR6g6n7FxCOrvANQr+yAgK/xwz
	 4i2mWY2Y+6CKPSYtlx0NivsyLjSW0kshiEXioLLZZGEOO4tNhCsBo8VaA+8/qXAmUZ
	 eorAJmtTL+YGFWDj1y+ozpKWGwpquf/KcQu1ObD6XjfG8Bu6lwc5vtYN9cjcgGPa8b
	 Br2jUylYNjavWnGmlNa5VWe7t8LwkZJBjS0zowbr2Gui0KapS4W0NiPt2Th467hw28
	 ZPkTEH1M4vLdC9P8rI0/Cq0nmEpu+Sxl4GHmh1vCSRd+xQzvLWXvN8gE7qLvJB+3i0
	 BldFnnltQXCXQ==
Date: Tue, 20 May 2025 20:25:36 +0800
From: Coly Li <colyli@kernel.org>
To: mingzhe.zou@easystack.cn
Cc: linux-bcache@vger.kernel.org, zoumingzhe@qq.com, 
	zoumingzhe@outlook.com
Subject: Re: [PATCH] bcache: reserve more RESERVE_BTREE buckets to prevent
 allocator hang
Message-ID: <igxwchucjehrqweclhngop67qra2q5pegxd7rf6rqwoaajohfx@4v2zyledsobf>
References: <20250520114558.1020593-1-mingzhe.zou@easystack.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250520114558.1020593-1-mingzhe.zou@easystack.cn>

On Tue, May 20, 2025 at 07:45:58PM +0800, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <zoumingzhe@qq.com>
> 
> Reported an IO hang and unrecoverable error in our testing environment.
> 
> After careful research, we found that bch_allocator_thread is stuck,
> the call stack is as follows:
> [<0>] __switch_to+0xbc/0x108
> [<0>] __closure_sync+0x7c/0xbc [bcache]
> [<0>] bch_prio_write+0x430/0x448 [bcache]
> [<0>] bch_allocator_thread+0xb44/0xb70 [bcache]
> [<0>] kthread+0x124/0x130
> [<0>] ret_from_fork+0x10/0x18
> 
> Moreover, the RESERVE_BTREE type bucket slot are empty and journal_full
> occurs at the same time.
> 
> When the cache disk is first used, the sb.nJournal_buckets defaults to 0.
> So, only 8 RESERVE_BTREE type buckets are reserved. If RESERVE_BTREE type
> buckets used up or btree_check_reserve() failed when requst handle btree
> split, the request will be repeatedly retried and wait for alloc thread to
> fill in.
> 
> After the alloc thread fills the buckets, it will call bch_prio_write().
> If journal_full occurs simultaneously at this time, journal_reclaim() and
> btree_flush_write() will be called sequentially, journal_write cannot be
> completed.
> 
> This is a low probability event, we believe that reserve more RESERVE_BTREE
> buckets can avoid the worst situation.
> 
> Fixes: 682811b3ce1a ("bcache: fix for allocator and register thread race")
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>

It looks good to me. Added for my for-next. Thanks for the fixup.

BTW, a typo and a extra blank tail are fixed by me when I added it into
my for-next.

Coly Li


> ---
>  drivers/md/bcache/super.c | 48 ++++++++++++++++++++++++++++++++-------
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 813b38aec3e4..4248c6299f28 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2233,15 +2233,47 @@ static int cache_alloc(struct cache *ca)
>  	bio_init(&ca->journal.bio, NULL, ca->journal.bio.bi_inline_vecs, 8, 0);
>  
>  	/*
> -	 * when ca->sb.njournal_buckets is not zero, journal exists,
> -	 * and in bch_journal_replay(), tree node may split,
> -	 * so bucket of RESERVE_BTREE type is needed,
> -	 * the worst situation is all journal buckets are valid journal,
> -	 * and all the keys need to replay,
> -	 * so the number of  RESERVE_BTREE type buckets should be as much
> -	 * as journal buckets
> +	 * When the cache disk is first registered, ca->sb.njournal_buckets
> +	 * is zero, and it is assigned in run_cache_set().
> +	 *
> +	 * When ca->sb.njournal_buckets is not zero, journal exists,
> +	 * and in bch_journal_replay(), tree node may split.
> +	 * The worst situation is all journal buckets are valid journal,
> +	 * and all the keys need to replay, so the number of RESERVE_BTREE
> +	 * type buckets should be as much as journal buckets.
> +	 * 
> +	 * If the number of RESERVE_BTREE type buckets is too few, the
> +	 * bch_allocator_thread() may hang up and unable to allocate
> +	 * bucket. The situation is roughly as follows:
> +	 *
> +	 * 1. In bch_data_insert_keys(), if the operation is not op->replace,
> +	 *    it will call the bch_journal(), which increments the journal_ref
> +	 *    counter. This counter is only decremented after bch_btree_insert
> +	 *    completes.
> +	 *
> +	 * 2. When calling bch_btree_insert, if the btree needs to split,
> +	 *    it will call btree_split() and btree_check_reserve() to check
> +	 *    whether there are enough reserved buckets in the RESERVE_BTREE
> +	 *    slot. If not enough, bcache_btree_root() will repeatedly retry.
> +	 *
> +	 * 3. Normally, the bch_allocator_thread is responsible for filling
> +	 *    the reservation slots from the free_inc bucket list. When the
> +	 *    free_inc bucket list is exhausted, the bch_allocator_thread
> +	 *    will call invalidate_buckets() until free_inc is refilled.
> +	 *    Then bch_allocator_thread calls bch_prio_write() once. and
> +	 *    bch_prio_write() will call bch_journal_meta() and waits for
> +	 *    the journal write to complete.
> +	 *
> +	 * 4. During journal_write, journal_write_unlocked() is be called.
> +	 *    If journal full occurs, journal_reclaim() and btree_flush_write()
> +	 *    will be called sequentially, then retry journal_write.
> +	 *
> +	 * 5. When 2 and 4 occur together, IO will hung up and cannot recover.
> +	 *
> +	 * Therefore, reserve more RESERVE_BTREE type buckets.
>  	 */
> -	btree_buckets = ca->sb.njournal_buckets ?: 8;
> +	btree_buckets = clamp_t(size_t, ca->sb.nbuckets >> 7,
> +				32, SB_JOURNAL_BUCKETS);
>  	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
>  	if (!free) {
>  		ret = -EPERM;
> -- 
> 2.34.1
> 

