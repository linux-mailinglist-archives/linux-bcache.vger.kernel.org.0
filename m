Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2A73AB22
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Jun 2019 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfFIS25 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Jun 2019 14:28:57 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42107 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728000AbfFIS24 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Jun 2019 14:28:56 -0400
Received: by mail-ed1-f66.google.com with SMTP id z25so10850978edq.9
        for <linux-bcache@vger.kernel.org>; Sun, 09 Jun 2019 11:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BfxZ/W9wA61LmHIYptqVXbJSQzNqLbuv6ef1kZZTso0=;
        b=Zl5tjX+QBiorlyMaaEHEL7yZMUrqJM9Dc9o25nNCnUDP3UxTqduiIHnWrKeCxLSALz
         6RSktl9i89ww45JSISnqxnCkchVJiHwadmjfunJIgou7guDgAocw/LnzWXNq30eiUxew
         m53rVcgie8K4W77gTwQlh5xhpDjXabhnHI9Ae66FO1cs1M/uNz9O4+F+BNVK3Rs4O8+g
         ORCRGqUat8vXBoN9Jh/asSGg/Qpo1wtTZkFOAKgHCUXK4n7BNwusPv09VK5xYife3UgS
         obvhQWa56ih57TXrcWALOsajgWaCriqAmKVjABj2+tPZqW5egFlxw4v208zYwW5EbpH1
         /3PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BfxZ/W9wA61LmHIYptqVXbJSQzNqLbuv6ef1kZZTso0=;
        b=rroX7ZikOFf43CZQKAss3OLFIz6ERHgBJSprcJyGLlTo9LPnDnAD0NDvS+CBTO7Hvv
         2cfuhI1GJQR03z+ut2rSLjW7/LiPd6PBjRrh7W3G6VxMGeZqIK1CetMBkJkeSjiDJ0K4
         oBPTZAiMGaQLqNzDITxN2xy0Cmc0WNa01jhvFLl72tUCKDcHYAwzRq3hB+FGBxLbBex7
         sX53R0w1lQjjC64NiOUTMwPduKRvTyQzOqVWn99zIqrqqRPAcDDa5owla5pbj6pI1jH0
         Pm0w0w/Ej37eqE+1Ee/0XywSL3gP4/4Zjxe01F7fCzZxWLqA9r22SzF0pz5Z+IDAWOAT
         Cpng==
X-Gm-Message-State: APjAAAXQWlLMBFaICtUaELNaMVuzrKlZ5O2qc83gDuy8rj2hZk8LQFFx
        Fn/qFXc3bs4rSgNAMnsyzj6E3A==
X-Google-Smtp-Source: APXvYqx6vAXOwT7DrI7ilhoZoWkb43LFoICAaS8cKtSvE0roPULfotyrjO3wXAkhg8Aa0yoghFcABA==
X-Received: by 2002:aa7:c391:: with SMTP id k17mr70298253edq.166.1560104934363;
        Sun, 09 Jun 2019 11:28:54 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id r14sm2304457edd.0.2019.06.09.11.28.53
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 11:28:53 -0700 (PDT)
Subject: Re: [PATCH V2] bcache: fix stack corruption by PRECEDING_KEY()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>
References: <20190609152400.18887-1-colyli@suse.de>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <a6150834-d7a6-986e-7a99-b9fb17d84a8d@rolffokkens.nl>
Date:   Sun, 9 Jun 2019 20:28:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190609152400.18887-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

I haven't tested the fix (yet), but just looking at the code I'm 
perfectly fine with the proposed replacement of the macro PRECEDING_KEY 
by the preceding_key function.

I have some minor concerns about the efficiency of the amount of 
indirections, but the gcc optimizer may take care of this. This is for 
later concern anyway.

On 6/9/19 5:24 PM, Coly Li wrote:
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
> points to an invalid stack address and this address is overwritten in
> the following called bch_btree_iter_init(). Then argument 'search' of
> bch_btree_iter_init() points to some address inside stackframe of
> bch_btree_iter_init(), exact address depends on how the compiler
> allocates stack space. Now the stack is corrupted.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Rolf Fokkens <rolf@rolffokkens.nl>
> Reviewed-by: Pierre JUHEN <pierre.juhen@orange.fr>
> Tested-by: Shenghui Wang <shhuiw@foxmail.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Nix <nix@esperi.org.uk>
> ---
> Changlog:
> V2: Fix a pointer assignment problem in preceding_key(), which is
>      pointed by Rolf Fokkens and Pierre JUHEN.
> V1: Initial RFC patch for review and comment.
>
>   drivers/md/bcache/bset.c | 16 +++++++++++++---
>   drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
>   2 files changed, 33 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 8f07fa6e1739..268f1b685084 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -887,12 +887,22 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
>   	struct bset *i = bset_tree_last(b)->data;
>   	struct bkey *m, *prev = NULL;
>   	struct btree_iter iter;
> +	struct bkey preceding_key_on_stack = ZERO_KEY;
> +	struct bkey *preceding_key_p = &preceding_key_on_stack;
>   
>   	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
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
> +		preceding_key(&START_KEY(k), &preceding_key_p);
> +	else
> +		preceding_key(k, &preceding_key_p);
> +
> +	m = bch_btree_iter_init(b, &iter, preceding_key_p);
>   
>   	if (b->ops->insert_fixup(b, k, &iter, replace_key))
>   		return status;
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index bac76aabca6d..c71365e7c1fa 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -434,20 +434,26 @@ static inline bool bch_cut_back(const struct bkey *where, struct bkey *k)
>   	return __bch_cut_back(where, k);
>   }
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
> + * Pointer '*preceding_key_p' points to a memory object to store preceding
> + * key of k. If the preceding key does not exist, set '*preceding_key_p' to
> + * NULL. So the caller of preceding_key() needs to take care of memory
> + * which '*preceding_key_p' pointed to before calling preceding_key().
> + * Currently the only caller of preceding_key() is bch_btree_insert_key(),
> + * and it points to an on-stack variable, so the memory release is handled
> + * by stackframe itself.
> + */
> +static inline void preceding_key(struct bkey *k, struct bkey **preceding_key_p)
> +{
> +	if (KEY_INODE(k) || KEY_OFFSET(k)) {
> +		(**preceding_key_p) = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
> +		if (!(*preceding_key_p)->low)
> +			(*preceding_key_p)->high--;
> +		(*preceding_key_p)->low--;
> +	} else {
> +		(*preceding_key_p) = NULL;
> +	}
> +}
>   
>   static inline bool bch_ptr_invalid(struct btree_keys *b, const struct bkey *k)
>   {


