Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 215A595C37
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Aug 2019 12:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfHTK0O (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Aug 2019 06:26:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:34488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729510AbfHTK0O (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Aug 2019 06:26:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0C479ABD9;
        Tue, 20 Aug 2019 10:26:12 +0000 (UTC)
Subject: Re: [PATCH] bcache: fix a lost wake-up problem caused by
 mca_cannibalize_lock
To:     Guoju Fang <fangguoju@gmail.com>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <1566296035-25080-1-git-send-email-fangguoju@gmail.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <118c76f1-155c-1906-5b0c-762b31cbdba6@suse.de>
Date:   Tue, 20 Aug 2019 18:26:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1566296035-25080-1-git-send-email-fangguoju@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/8/20 6:13 下午, Guoju Fang wrote:
> This patch fix a lost wake-up problem caused by the race between
> mca_cannibalize_lock and bch_cannibalize_unlock.
> 
> Consider two processes, A and B. Process A is executing
> mca_cannibalize_lock, while process B takes c->btree_cache_alloc_lock
> and is executing bch_cannibalize_unlock. The problem happens that after
> process A executes cmpxchg and will execute prepare_to_wait. In this
> timeslice process B executes wake_up, but after that process A executes
> prepare_to_wait and set the state to TASK_INTERRUPTIBLE. Then process A
> goes to sleep but no one will wake up it. This problem may cause bcache
> device to dead.
> 
> Signed-off-by: Guoju Fang <fangguoju@gmail.com>

Hi Guoju,

It looks good to me at the first glance, let me add it into my for-test
directory.

Thanks.

Coly Li

> ---
>  drivers/md/bcache/bcache.h |  1 +
>  drivers/md/bcache/btree.c  | 12 ++++++++----
>  drivers/md/bcache/super.c  |  1 +
>  3 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 013e35a..3653faf 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -582,6 +582,7 @@ struct cache_set {
>  	 */
>  	wait_queue_head_t	btree_cache_wait;
>  	struct task_struct	*btree_cache_alloc_lock;
> +	spinlock_t		btree_cannibalize_lock;
>  
>  	/*
>  	 * When we free a btree node, we increment the gen of the bucket the
> diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
> index ba434d9..7fcf079 100644
> --- a/drivers/md/bcache/btree.c
> +++ b/drivers/md/bcache/btree.c
> @@ -884,15 +884,17 @@ static struct btree *mca_find(struct cache_set *c, struct bkey *k)
>  
>  static int mca_cannibalize_lock(struct cache_set *c, struct btree_op *op)
>  {
> -	struct task_struct *old;
> -
> -	old = cmpxchg(&c->btree_cache_alloc_lock, NULL, current);
> -	if (old && old != current) {
> +	spin_lock(&c->btree_cannibalize_lock);
> +	if (likely(c->btree_cache_alloc_lock == NULL)) {
> +		c->btree_cache_alloc_lock = current;
> +	} else if (c->btree_cache_alloc_lock != current) {
>  		if (op)
>  			prepare_to_wait(&c->btree_cache_wait, &op->wait,
>  					TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&c->btree_cannibalize_lock);
>  		return -EINTR;
>  	}
> +	spin_unlock(&c->btree_cannibalize_lock);
>  
>  	return 0;
>  }
> @@ -927,10 +929,12 @@ static struct btree *mca_cannibalize(struct cache_set *c, struct btree_op *op,
>   */
>  static void bch_cannibalize_unlock(struct cache_set *c)
>  {
> +	spin_lock(&c->btree_cannibalize_lock);
>  	if (c->btree_cache_alloc_lock == current) {
>  		c->btree_cache_alloc_lock = NULL;
>  		wake_up(&c->btree_cache_wait);
>  	}
> +	spin_unlock(&c->btree_cannibalize_lock);
>  }
>  
>  static struct btree *mca_alloc(struct cache_set *c, struct btree_op *op,
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 20ed838..ebb854e 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1769,6 +1769,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	sema_init(&c->sb_write_mutex, 1);
>  	mutex_init(&c->bucket_lock);
>  	init_waitqueue_head(&c->btree_cache_wait);
> +	spin_lock_init(&c->btree_cannibalize_lock);
>  	init_waitqueue_head(&c->bucket_wait);
>  	init_waitqueue_head(&c->gc_wait);
>  	sema_init(&c->uuid_write_mutex, 1);
> 


-- 

Coly Li
