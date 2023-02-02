Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC80768884D
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 21:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBBUhJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 2 Feb 2023 15:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjBBUhI (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 2 Feb 2023 15:37:08 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2716D046
        for <linux-bcache@vger.kernel.org>; Thu,  2 Feb 2023 12:37:07 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 8516187;
        Thu,  2 Feb 2023 12:37:06 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id AYTOm0xiXj9l; Thu,  2 Feb 2023 12:37:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 9831446;
        Thu,  2 Feb 2023 12:37:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 9831446
Date:   Thu, 2 Feb 2023 12:37:05 -0800 (PST)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Zheng Wang <zyytlz.wz@163.com>
cc:     colyli@suse.de, hackerzheng666@gmail.com,
        kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex000young@gmail.com
Subject: Re: [PATCH] bcache: Fix __bch_btree_node_alloc to make the failure
 behavior consistent
In-Reply-To: <20230202151504.542958-1-zyytlz.wz@163.com>
Message-ID: <85540cd-91fd-9aa7-23c4-2fb529d43fc2@ewheeler.net>
References: <20230202151504.542958-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, 2 Feb 2023, Zheng Wang wrote:

> In some specific situation, the return value of __bch_btree_node_alloc may
> be NULL. This may lead to poential NULL pointer dereference in caller
>  function like a calling chaion :
>  btree_split->bch_btree_node_alloc->__bch_btree_node_alloc.
> 
> Fix it by initialize return value in __bch_btree_node_alloc before return.
> 
> Fixes: cafe56359144 ("bcache: A block layer cache")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>

Be sure to add `Cc: stable@vger.kernel.org`

-Eric

> ---
>  drivers/md/bcache/btree.c | 10 ++++++----
>  drivers/md/bcache/super.c |  2 +-
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index 147c493a989a..35346c1d7c3c 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -1090,10 +1090,12 @@ struct btree *__bch_btree_node_alloc(struct cache_set *c, struct btree_op *op,
>  				     struct btree *parent)
>  {
>  	BKEY_PADDED(key) k;
> -	struct btree *b = ERR_PTR(-EAGAIN);
> +	struct btree *b;
>  
>  	mutex_lock(&c->bucket_lock);
>  retry:
> +	/* return ERR_PTR(-EAGAIN) when it fails */
> +	b = ERR_PTR(-EAGAIN);
>  	if (__bch_bucket_alloc_set(c, RESERVE_BTREE, &k.key, wait))
>  		goto err;
>  
> @@ -1138,7 +1140,7 @@ static struct btree *btree_node_alloc_replacement(struct btree *b,
>  {
>  	struct btree *n = bch_btree_node_alloc(b->c, op, b->level, b->parent);
>  
> -	if (!IS_ERR_OR_NULL(n)) {
> +	if (!IS_ERR(n)) {
>  		mutex_lock(&n->write_lock);
>  		bch_btree_sort_into(&b->keys, &n->keys, &b->c->sort);
>  		bkey_copy_key(&n->key, &b->key);
> @@ -1352,7 +1354,7 @@ static int btree_gc_coalesce(struct btree *b, struct btree_op *op,
>  
>  	for (i = 0; i < nodes; i++) {
>  		new_nodes[i] = btree_node_alloc_replacement(r[i].b, NULL);
> -		if (IS_ERR_OR_NULL(new_nodes[i]))
> +		if (IS_ERR(new_nodes[i]))
>  			goto out_nocoalesce;
>  	}
>  
> @@ -1669,7 +1671,7 @@ static int bch_btree_gc_root(struct btree *b, struct btree_op *op,
>  	if (should_rewrite) {
>  		n = btree_node_alloc_replacement(b, NULL);
>  
> -		if (!IS_ERR_OR_NULL(n)) {
> +		if (!IS_ERR(n)) {
>  			bch_btree_node_write_sync(n);
>  
>  			bch_btree_set_root(n);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index ba3909bb6bea..92de714fe75e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2088,7 +2088,7 @@ static int run_cache_set(struct cache_set *c)
>  
>  		err = "cannot allocate new btree root";
>  		c->root = __bch_btree_node_alloc(c, NULL, 0, true, NULL);
> -		if (IS_ERR_OR_NULL(c->root))
> +		if (IS_ERR(c->root))
>  			goto err;
>  
>  		mutex_lock(&c->root->write_lock);
> -- 
> 2.25.1
> 
> 
