Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A32849FC3F
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jan 2022 15:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344684AbiA1O5k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jan 2022 09:57:40 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:59858 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346071AbiA1O5k (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jan 2022 09:57:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 73C4B1F391;
        Fri, 28 Jan 2022 14:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643381859; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ba+l2SxUnl2PsZi9k+nup998w+/IcR4dNItcknGrFRY=;
        b=YSsYUJHg/s/sBlMSvYoIsSlH4jraU5sQkBWy20cAaAXCF3pCg3VY/ZvqP9PjFSy12eMguQ
        iWirYMBplYRpfZQEfNMvYunpub9w6xjKm+MunRcCud75mTf0TFtdtkcr/UqI+yeclVV8DZ
        6V1qgAuDFocrX3oH8ZEhXrpZfQtZCRk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643381859;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ba+l2SxUnl2PsZi9k+nup998w+/IcR4dNItcknGrFRY=;
        b=0kUU+b3pmA4jVQA7m6vsjcj0LxK0lJJ6W+UqyjpXY77z0xD02wRpK2AsLxA+Wkh4/ABkm1
        s640d3I6vNAPJ3BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 97A9113524;
        Fri, 28 Jan 2022 14:57:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lnW6KGAE9GEwNgAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Jan 2022 14:57:36 +0000
Message-ID: <b09d1ee1-419e-9bca-4343-65d9688ab86d@suse.de>
Date:   Fri, 28 Jan 2022 22:57:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] bcache: shrink the scope of bch_register_lock
Content-Language: en-US
To:     Rui Xu <rui.xu@easystack.cn>
Cc:     dongsheng.yang@easystack.cn, linux-bcache@vger.kernel.org
References: <20220125054922.1859923-1-rui.xu@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220125054922.1859923-1-rui.xu@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/25/22 1:49 PM, Rui Xu wrote:
> When we register a cache device, register_cache_set is called, but
> it would be locked with bch_register_lock which is a global lock.
>
> Consider a scenriao which multiple cache devices are registered
> concurrently, it will block in register_cache because of
> bch_register_lock, in fact, we don't need to lock run_cache_set
> in register_cache_set, but only the operation of bch_cache_sets
> list.

Hi Rui,

The overall idea is fine to me. But do you have performance number 
with/without your patch when registering multiple cache sets?

Current usage of bch_regster_lock is simple, if you refine it to smaller 
grain, all the objects are covered by scope of bch_register_lock should 
be identified and commented.
If you have significant performance gain with this patch, I am fine to 
add code comments of the data structures  (or their members) that they 
should again bch_regster_lock before accessing.
Otherwise I'd like to keep current simple code.

Thanks.

Coly Li

>
> The patch shrink the scope of bch_register_lock in register_cache_set
> so that run_cache_set of different cache devices can be performed
> concurrently, it also add a cache_set_lock to ensure that
> bch_cached_dev_attach and run_cache_set will not processed at the
> same time.
>
> Signed-off-by: Rui Xu <rui.xu@easystack.cn>
> ---
>   drivers/md/bcache/bcache.h |  2 ++
>   drivers/md/bcache/super.c  | 40 ++++++++++++++++++++++++++++----------
>   2 files changed, 32 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index ab3c552871df..4e37785eaa2a 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -551,6 +551,8 @@ struct cache_set {
>   	/* For the btree cache and anything allocation related */
>   	struct mutex		bucket_lock;
>   
> +	struct mutex		cache_set_lock;
> +
>   	/* log2(bucket_size), in sectors */
>   	unsigned short		bucket_bits;
>   
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 8e8297ef98e3..bf392638a969 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1390,8 +1390,11 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   
>   	list_add(&dc->list, &uncached_devices);
>   	/* attach to a matched cache set if it exists */
> -	list_for_each_entry(c, &bch_cache_sets, list)
> +	list_for_each_entry(c, &bch_cache_sets, list) {
> +		mutex_lock(&c->cache_set_lock);
>   		bch_cached_dev_attach(dc, c, NULL);
> +		mutex_unlock(&c->cache_set_lock);
> +    }
>   
>   	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
>   	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
> @@ -1828,6 +1831,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   
>   	sema_init(&c->sb_write_mutex, 1);
>   	mutex_init(&c->bucket_lock);
> +       mutex_init(&c->cache_set_lock);
>   	init_waitqueue_head(&c->btree_cache_wait);
>   	spin_lock_init(&c->btree_cannibalize_lock);
>   	init_waitqueue_head(&c->bucket_wait);
> @@ -2076,13 +2080,18 @@ static const char *register_cache_set(struct cache *ca)
>   	const char *err = "cannot allocate memory";
>   	struct cache_set *c;
>   
> +	mutex_lock(&bch_register_lock);
>   	list_for_each_entry(c, &bch_cache_sets, list)
>   		if (!memcmp(c->sb.set_uuid, ca->sb.set_uuid, 16)) {
> -			if (c->cache[ca->sb.nr_this_dev])
> +			if (c->cache[ca->sb.nr_this_dev]) {
> +			        mutex_unlock(&bch_register_lock);
>   				return "duplicate cache set member";
> +			}
>   
> -			if (!can_attach_cache(ca, c))
> +			if (!can_attach_cache(ca, c)) {
> +			        mutex_unlock(&bch_register_lock);
>   				return "cache sb does not match set";
> +			}
>   
>   			if (!CACHE_SYNC(&ca->sb))
>   				SET_CACHE_SYNC(&c->sb, false);
> @@ -2091,25 +2100,35 @@ static const char *register_cache_set(struct cache *ca)
>   		}
>   
>   	c = bch_cache_set_alloc(&ca->sb);
> -	if (!c)
> +	if (!c) {
> +	        mutex_unlock(&bch_register_lock);
>   		return err;
> +	}
>   
>   	err = "error creating kobject";
>   	if (kobject_add(&c->kobj, bcache_kobj, "%pU", c->sb.set_uuid) ||
> -	    kobject_add(&c->internal, &c->kobj, "internal"))
> +	    kobject_add(&c->internal, &c->kobj, "internal")) {
> +	        mutex_unlock(&bch_register_lock);
>   		goto err;
> +	}
>   
> -	if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj))
> +	if (bch_cache_accounting_add_kobjs(&c->accounting, &c->kobj)) {
> +	        mutex_unlock(&bch_register_lock);
>   		goto err;
> +	}
>   
>   	bch_debug_init_cache_set(c);
>   
>   	list_add(&c->list, &bch_cache_sets);
>   found:
> +	mutex_lock(&c->cache_set_lock);
> +	mutex_unlock(&bch_register_lock);
>   	sprintf(buf, "cache%i", ca->sb.nr_this_dev);
>   	if (sysfs_create_link(&ca->kobj, &c->kobj, "set") ||
> -	    sysfs_create_link(&c->kobj, &ca->kobj, buf))
> +	    sysfs_create_link(&c->kobj, &ca->kobj, buf)) {
> +		mutex_unlock(&c->cache_set_lock);
>   		goto err;
> +	}
>   
>   	if (ca->sb.seq > c->sb.seq) {
>   		c->sb.version		= ca->sb.version;
> @@ -2126,10 +2145,13 @@ static const char *register_cache_set(struct cache *ca)
>   
>   	if (c->caches_loaded == c->sb.nr_in_set) {
>   		err = "failed to run cache set";
> -		if (run_cache_set(c) < 0)
> +		if (run_cache_set(c) < 0) {
> +			mutex_unlock(&c->cache_set_lock);
>   			goto err;
> +		}
>   	}
>   
> +	mutex_unlock(&c->cache_set_lock);
>   	return NULL;
>   err:
>   	bch_cache_set_unregister(c);
> @@ -2338,9 +2360,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   		goto out;
>   	}
>   
> -	mutex_lock(&bch_register_lock);
>   	err = register_cache_set(ca);
> -	mutex_unlock(&bch_register_lock);
>   
>   	if (err) {
>   		ret = -ENODEV;

