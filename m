Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54559831E5
	for <lists+linux-bcache@lfdr.de>; Tue,  6 Aug 2019 14:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbfHFMxC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 6 Aug 2019 08:53:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52044 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728560AbfHFMxC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 6 Aug 2019 08:53:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B0BDB62E;
        Tue,  6 Aug 2019 12:53:01 +0000 (UTC)
Subject: Re: [PATCH] bcache: move verify logic from bch_btree_node_write to
 bch_btree_init_next
To:     Shenghui Wang <shhuiw@foxmail.com>
References: <20190806121328.1963-1-shhuiw@foxmail.com>
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <65d42d78-6111-0f84-598d-1f4a7342ed8c@suse.de>
Date:   Tue, 6 Aug 2019 20:52:54 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806121328.1963-1-shhuiw@foxmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/8/6 8:13 下午, Shenghui Wang wrote:
> commit 2a285686c1098 ("bcache: btree locking rework") introduced
> bch_btree_init_next(), and moved the sort logic into the function.
> Before the commit introduced, __bch_btree_node_write() will do sort
> first, then do possible verify. After the change, the verify will
> run before any sort/change sets of btree node, and no verify will
> run after sort done in bch_btree_init_next().
> 
> Move the verify code into bch_btree_init_next(), right after sort done.
> 

Hi Shenghui,

What is the benefit of this change ?

Thanks.

Coly Li

> Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
> ---
>  drivers/md/bcache/btree.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index ba434d9ac720..b15878334a29 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -167,16 +167,24 @@ static inline struct bset *write_block(struct btree *b)
>  
>  static void bch_btree_init_next(struct btree *b)
>  {
> +	unsigned int nsets = b->keys.nsets;
> +
>  	/* If not a leaf node, always sort */
>  	if (b->level && b->keys.nsets)
>  		bch_btree_sort(&b->keys, &b->c->sort);
>  	else
>  		bch_btree_sort_lazy(&b->keys, &b->c->sort);
>  
> +	/*
> +	 * do verify if there was more than one set initially (i.e. we did a
> +	 * sort) and we sorted down to a single set:
> +	 */
> +	if (nsets && !b->keys.nsets)
> +		bch_btree_verify(b);
> +
>  	if (b->written < btree_blocks(b))
>  		bch_bset_init_next(&b->keys, write_block(b),
>  				   bset_magic(&b->c->sb));
> -
>  }
>  
>  /* Btree key manipulation */
> @@ -489,19 +497,9 @@ void __bch_btree_node_write(struct btree *b, struct closure *parent)
>  
>  void bch_btree_node_write(struct btree *b, struct closure *parent)
>  {
> -	unsigned int nsets = b->keys.nsets;
> -
>  	lockdep_assert_held(&b->lock);
>  
>  	__bch_btree_node_write(b, parent);
> -
> -	/*
> -	 * do verify if there was more than one set initially (i.e. we did a
> -	 * sort) and we sorted down to a single set:
> -	 */
> -	if (nsets && !b->keys.nsets)
> -		bch_btree_verify(b);
> -
>  	bch_btree_init_next(b);
>  }
>  
> 


-- 

Coly Li
