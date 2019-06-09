Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1F43A55C
	for <lists+linux-bcache@lfdr.de>; Sun,  9 Jun 2019 14:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfFIMQh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Jun 2019 08:16:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:52292 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728256AbfFIMQh (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Jun 2019 08:16:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D3EA2AF41;
        Sun,  9 Jun 2019 12:16:34 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: fix stack corruption by PRECEDING_KEY()
To:     Pierre JUHEN <pierre.juhen@orange.fr>, linux-bcache@vger.kernel.org
Cc:     Rolf Fokkens <rolf@rolffokkens.nl>, Nix <nix@esperi.org.uk>,
        linux-block@vger.kernel.org
References: <20190608102204.60126-1-colyli@suse.de>
 <3e18ec39-5357-9239-ac06-d81558bd0fd1@suse.de>
 <f031dac3-08d3-1632-8dbe-6495f501489b@orange.fr>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <0b9bd5dd-33ff-0b8f-ab30-a23216cd872f@suse.de>
Date:   Sun, 9 Jun 2019 20:16:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <f031dac3-08d3-1632-8dbe-6495f501489b@orange.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/9 6:46 下午, Pierre JUHEN wrote:
> Hi Coly,
> 
> As Rolf and I said, the value of preceding_key_p in the stack cannot be
> set to NULL by your code.
> 
> The modified patch hereafter does what you expect (I think).
> 

Oh, I understand now. Yes you are right, I made a mistake in previous
patch. I will post an update version which uses "struct bkey
**preceding_key_p" as parameter of preceding_key().

And I will add Reviewed-by: tag to you (Pierre and Rolf) in update
version. Thanks for your review!

Coly Li

>  
> 
> drivers/md/bcache/bset.c | 16 +++++++++++++---
> drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
> 2 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
> index 8f07fa6e1739..9422f3f1c682 100644
> --- a/drivers/md/bcache/bset.c
> +++ b/drivers/md/bcache/bset.c
> @@ -887,12 +887,22 @@ unsigned int bch_btree_insert_key(struct
> btree_keys *b, struct bkey *k,
>      struct bset *i = bset_tree_last(b)->data;
>      struct bkey *m, *prev = NULL;
>      struct btree_iter iter;
> +    struct bkey preceding_key_on_stack = ZERO_KEY;
> +    struct bkey *preceding_key_p = &preceding_key_on_stack;
>  
>      BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
>  
> -    m = bch_btree_iter_init(b, &iter, b->ops->is_extents
> -                ? PRECEDING_KEY(&START_KEY(k))
> -                : PRECEDING_KEY(k));
> +    /*
> +     * If k has preceding key, preceding_key_p will be set to address
> +     *  of k's preceding key; otherwise preceding_key_p will be set
> +     * to NULL inside preceding_key().
> +     */
> +    if (b->ops->is_extents)
> +        preceding_key_p = preceding_key(&START_KEY(k), preceding_key_p);
> +    else
> +        preceding_key_p = preceding_key(k, preceding_key_p);
> +
> +    m = bch_btree_iter_init(b, &iter, preceding_key_p);
>  
>      if (b->ops->insert_fixup(b, k, &iter, replace_key))
>          return status;
> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
> index bac76aabca6d..6ab165dcb717 100644
> --- a/drivers/md/bcache/bset.h
> +++ b/drivers/md/bcache/bset.h
> @@ -434,20 +434,26 @@ static inline bool bch_cut_back(const struct bkey
> *where, struct bkey *k)
>      return __bch_cut_back(where, k);
>  }
>  
> -#define PRECEDING_KEY(_k)                    \
> -({                                \
> -    struct bkey *_ret = NULL;                \
> -                                \
> -    if (KEY_INODE(_k) || KEY_OFFSET(_k)) {            \
> -        _ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);    \
> -                                \
> -        if (!_ret->low)                    \
> -            _ret->high--;                \
> -        _ret->low--;                    \
> -    }                            \
> -                                \
> -    _ret;                            \
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
> +static inline  struct bkey *preceding_key(struct bkey *k, struct bkey
> *preceding_key_p)
> +{
> +    if (KEY_INODE(k) || KEY_OFFSET(k)) {
> +        *preceding_key_p = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
> +        if (!preceding_key_p->low)
> +            preceding_key_p->high--;
> +        preceding_key_p->low--;
> +        return (preceding_key_p);
> +    } else {
> +        return(NULL);
> +    }
> +}
>  
>  static inline bool bch_ptr_invalid(struct btree_keys *b, const struct
> bkey *k)
>  {
> 
> 


-- 

Coly Li
