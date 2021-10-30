Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328C84409E7
	for <lists+linux-bcache@lfdr.de>; Sat, 30 Oct 2021 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhJ3PVg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 30 Oct 2021 11:21:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40178 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbhJ3PVf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 30 Oct 2021 11:21:35 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AE2CB1FD37;
        Sat, 30 Oct 2021 15:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635607144; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XzJOgmOjbK4XpU/7hYdBTgmh5NJ8hIeRuBcTcQsXsQ=;
        b=HU//TBqBbdYNJ4i+78/JdRm8MKPKhtS9mq8Q++8hrpR/Uw/xl9mxZshmKHdJ8BLhFTQtiG
        Cr8qfEMbPuO/QH9IXhi9btT+Cjjnr+fkdLGLNyDwCzlXQnKyp1DPyuzxp9t1u6IQbsXU3O
        61Vj6RF3QKnXOnB8+ovvr78XG0NsDwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635607144;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4XzJOgmOjbK4XpU/7hYdBTgmh5NJ8hIeRuBcTcQsXsQ=;
        b=DWB4y0oJzGI4xhMqOXIXtQ6CAXVXWdNCNx9Ae+fj8wG/X5p/jRQ/SB0sgyUzEVb6m1fLet
        yBODSEW9LMxgiQCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C277B139CF;
        Sat, 30 Oct 2021 15:19:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7ONdJGdifWGVVwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 30 Oct 2021 15:19:03 +0000
Message-ID: <9516418b-27d0-d84b-d9cb-be72d5e8f9ce@suse.de>
Date:   Sat, 30 Oct 2021 23:19:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: kill macro MAX_CACHES_PER_SET
Content-Language: en-US
To:     Lin Feng <linf@wangsu.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20211029125958.95298-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211029125958.95298-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/29/21 8:59 PM, Lin Feng wrote:
> Commit 697e23495c94f0380c1ed8b11f830b92b64c99ea
> ("bcache: explicitly make cache_set only have single cache")
> explicitly makes a cache_set only have single cache and based on the
> fact that historily only one cache is ever used in the cache set, so
> macro defination for MAX_CACHES_PER_SET as 8 is misleading now.
>
> In fact it should be redefined to 1 and valid number fo sb.nr_in_set
> should be 1 and sb.nr_this_dev should always be 0.
>
> But jset's disk layout replies on MAX_CACHES_PER_SET(8), so replace it
> with a hardcoded number 8.
>
> Signed-off-by: Lin Feng <linf@wangsu.com>
> ---
>   drivers/md/bcache/bcache.h  | 2 +-
>   drivers/md/bcache/super.c   | 4 +---
>   include/uapi/linux/bcache.h | 4 ++--
>   3 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5fc989a6d452..a4a410a178c0 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -833,7 +833,7 @@ static inline uint8_t ptr_stale(struct cache_set *c, const struct bkey *k,
>   static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
>   				 unsigned int i)
>   {
> -	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && c->cache;
> +	return (PTR_DEV(k, i) == 0) && c->cache;
>   }
>   
>   /* Btree key macros */
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f2874c77ff79..2253044c9289 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -140,9 +140,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
>   		goto err;
>   
>   	err = "Bad cache device number in set";
> -	if (!sb->nr_in_set ||
> -	    sb->nr_in_set <= sb->nr_this_dev ||
> -	    sb->nr_in_set > MAX_CACHES_PER_SET)
> +	if (sb->nr_in_set != 1 || sb->nr_this_dev != 0)
>   		goto err;
>   
>   	err = "Journal buckets not sequential";

Hi Feng,

The above changes are fine to me. But let's keep the below part as what 
it is at this moment.

Thanks.

Coly Li

> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
> index cf7399f03b71..4beb3e7826ca 100644
> --- a/include/uapi/linux/bcache.h
> +++ b/include/uapi/linux/bcache.h
> @@ -155,7 +155,6 @@ static inline struct bkey *bkey_idx(const struct bkey *k, unsigned int nr_keys)
>   #define SB_LABEL_SIZE			32
>   #define SB_JOURNAL_BUCKETS		256U
>   /* SB_JOURNAL_BUCKETS must be divisible by BITS_PER_LONG */
> -#define MAX_CACHES_PER_SET		8
>   
>   #define BDEV_DATA_START_DEFAULT		16	/* sectors */
>   
> @@ -356,7 +355,8 @@ struct jset {
>   	__u16			btree_level;
>   	__u16			pad[3];
>   
> -	__u64			prio_bucket[MAX_CACHES_PER_SET];
> +	/* only a single cache is available */
> +	__u64			prio_bucket[8];
>   
>   	union {
>   		struct bkey	start[0];

