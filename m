Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCBF3A476
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Jun 2019 11:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfFIJVb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Jun 2019 05:21:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:60504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727720AbfFIJVb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Jun 2019 05:21:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E2FA2AD72;
        Sun,  9 Jun 2019 09:21:28 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: fix stack corruption by PRECEDING_KEY()
To:     linux-bcache@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Rolf Fokkens <rolf@rolffokkens.nl>, Nix <nix@esperi.org.uk>,
        Pierre JUHEN <pierre.juhen@orange.fr>,
        linux-block@vger.kernel.org
References: <20190608102204.60126-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <3e18ec39-5357-9239-ac06-d81558bd0fd1@suse.de>
Date:   Sun, 9 Jun 2019 17:21:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190608102204.60126-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/8 6:22 下午, Coly Li wrote:
> Recently people report bcache code compiled with gcc9 is broken, one of
> the buggy behavior I observe is that two adjacent 4KB I/Os should merge
> into one but they don't. Finally it turns out to be a stack corruption
> caused by macro PRECEDING_KEY().
> 
> See how PRECEDING_KEY() is defined in bset.h,
> 437 #define PRECEDING_KEY(_k)                                       \
> 438 ({                                                              \
> 439         struct bkey *_ret = NULL;                               \
> 440                                                                 \
> 441         if (KEY_INODE(_k) || KEY_OFFSET(_k)) {                  \
> 442                 _ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);  \
> 443                                                                 \
> 444                 if (!_ret->low)                                 \
> 445                         _ret->high--;                           \
> 446                 _ret->low--;                                    \
> 447         }                                                       \
> 448                                                                 \
> 449         _ret;                                                   \
> 450 })
> 
> At line 442, _ret points to address of a on-stack variable combined by
> KEY(), the life range of this on-stack variable is in line 442-446,
> once _ret is returned to bch_btree_insert_key(), the returned address
> points to an invalid stack address and this adress is overwritten in
> the following called bch_btree_iter_init(). Then argument 'search' of
> bch_btree_iter_init() points to some address inside stackframe of
> bch_btree_iter_init(), exact address depends on how the compiler
> allocates stack space. Now the stack is corrupted.
> 
> The fix is to avoid to allocate and return an on-stack variable only
> in range of PRECEDING_KEY(). This patch changes macro PRECEDING_KEY()
> to an inline function, and allocate another on-stack variable from
> function bch_btree_insert_key(), then the allocated memory address
> will be always valid in life range of bch_btree_insert_key().
> 
> NOTE: This is only a RFC patch for more people to test. During my
> test I find bcache code does not complain out-of-order bkeys in btree
> node anymore, but the adjacent keys still don't totally merge as
> expected (e.g. they should be merged into one single key). So now I
> still continue to check what needs to be fixed more.
> 

Hi folks,

After more testing, I realize the cached bkeys are not always merged,
this is the bkey dump information from
/sys/kernel/debug/bcache/bcache-87adfbc4-0b11-45b9-9a11-a11cfe5df2eb,
0:16 len 120 -> [0:377856 gen 1] dirty
0:136 len 8 -> [0:377976 gen 1] dirty
0:144 len 896 -> [0:721000 gen 1]
0:4112 len 8 -> [0:393136 gen 1]

So the patched bcache code is behaving correctly, IMHO no more fix
necessary.

I see Shenghui tested and verified the fix, more testing or review
comments are welcome.

Thanks.

Coly Li

> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Rolf Fokkens <rolf@rolffokkens.nl>
> Cc: Nix <nix@esperi.org.uk>
> Cc: Pierre JUHEN <pierre.juhen@orange.fr>
> Cc: linux-bcache@vger.kernel.org
> Cc: linux-block@vger.kernel.org
> ---
>  drivers/md/bcache/bset.c | 16 +++++++++++++---
>  drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
>  2 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 8f07fa6e1739..9422f3f1c682 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -887,12 +887,22 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
>  	struct bset *i = bset_tree_last(b)->data;
>  	struct bkey *m, *prev = NULL;
>  	struct btree_iter iter;
> +	struct bkey preceding_key_on_stack = ZERO_KEY;
> +	struct bkey *preceding_key_p = &preceding_key_on_stack;
>  
>  	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
>  
> -	m = bch_btree_iter_init(b, &iter, b->ops->is_extents
> -				? PRECEDING_KEY(&START_KEY(k))
> -				: PRECEDING_KEY(k));
> +	/*
> +	 * If k has preceding key, preceding_key_p will be set to address
> +	 *  of k's preceding key; otherwise preceding_key_p will be set
> +	 * to NULL inside preceding_key().
> +	 */
> +	if (b->ops->is_extents)
> +		preceding_key(&START_KEY(k), preceding_key_p);
> +	else
> +		preceding_key(k, preceding_key_p);
> +
> +	m = bch_btree_iter_init(b, &iter, preceding_key_p);
>  
>  	if (b->ops->insert_fixup(b, k, &iter, replace_key))
>  		return status;
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index bac76aabca6d..6ab165dcb717 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -434,20 +434,26 @@ static inline bool bch_cut_back(const struct bkey *where, struct bkey *k)
>  	return __bch_cut_back(where, k);
>  }
>  
> -#define PRECEDING_KEY(_k)					\
> -({								\
> -	struct bkey *_ret = NULL;				\
> -								\
> -	if (KEY_INODE(_k) || KEY_OFFSET(_k)) {			\
> -		_ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);	\
> -								\
> -		if (!_ret->low)					\
> -			_ret->high--;				\
> -		_ret->low--;					\
> -	}							\
> -								\
> -	_ret;							\
> -})
> +/*
> + * Pointer preceding_key_p points to a memory object to store preceding
> + * key of k. If the preceding key does not exist, set preceding_key_p to
> + * NULL. So the caller of preceding_key() needs to take care of memory
> + * which preceding_key_p pointed to before calling preceding_key().
> + * Currently the only caller of preceding_key() is bch_btree_insert_key(),
> + * and preceding_key_p points to an on-stack variable, so the memory
> + * release is handled by stackframe itself.
> + */
> +static inline void preceding_key(struct bkey *k, struct bkey *preceding_key_p)
> +{
> +	if (KEY_INODE(k) || KEY_OFFSET(k)) {
> +		*preceding_key_p = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
> +		if (!preceding_key_p->low)
> +			preceding_key_p->high--;
> +		preceding_key_p->low--;
> +	} else {
> +		preceding_key_p = NULL;
> +	}
> +}
>  
>  static inline bool bch_ptr_invalid(struct btree_keys *b, const struct bkey *k)
>  {
> 
