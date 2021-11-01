Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB82844133D
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Nov 2021 06:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhKAFbu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Nov 2021 01:31:50 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37374 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbhKAFbt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Nov 2021 01:31:49 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DD6E62192D;
        Mon,  1 Nov 2021 05:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635744555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2f9OAzzfJHvRfINaxNeskzvutF1GbL7BKDUPsw3Xn2Y=;
        b=o7kFO+o8eHSOSi9a//Yb4bLikBrGF0kWOfCJCtQbCGOq6mAMyBbwwP4UjlsEBuHX8BLd+m
        pusXpho4Y/Zr+jLpjDBMvhpsdNf6EBSFmn+mZhD7qIZtIlgIiv8yr3FZ4dkLWPCN7/wEiO
        U0L+q+i7rv2GkwZ9Nu1j+TeMW06pgII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635744555;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2f9OAzzfJHvRfINaxNeskzvutF1GbL7BKDUPsw3Xn2Y=;
        b=8phHEmcuCpPQjjmAmmGWk3bwwN2oMirunEJpjSzlV7lo840AYI8qmO+QuEeP7Zlqysrkk6
        j+N3rq/QYyzFPmDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9A6C1323E;
        Mon,  1 Nov 2021 05:29:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id odijJCp7f2G1cgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 01 Nov 2021 05:29:14 +0000
Message-ID: <2c190f49-ffde-c6eb-e632-3f53832a3d83@suse.de>
Date:   Mon, 1 Nov 2021 13:29:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH] bcache: make checkings for sb.nr_in_set and
 sb.nr_this_dev to be more precise
Content-Language: en-US
To:     Lin Feng <linf@wangsu.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        kent.overstreet@gmail.com
References: <20211101030751.8645-1-linf@wangsu.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20211101030751.8645-1-linf@wangsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/1/21 11:07 AM, Lin Feng wrote:
> Commit 697e23495c94f0380c1ed8b11f830b92b64c99ea
> ("bcache: explicitly make cache_set only have single cache")
> explicitly makes a cache_set only have single cache and based on the
> fact that historily only one cache is ever used in the cache set, so
> valid number fo sb.nr_in_set should be 1 and sb.nr_this_dev should
> always be 0.
>
> Based on above truth, codes validations for sb.nr_in_set and sb.nr_this_dev
> can make to be more accurate, that means tolerance for error checking
> are reduced comparing before.
>
> Signed-off-by: Lin Feng <linf@wangsu.com>

Hi Lin,

Thanks for the patch up. I add this change to my for-test directory.

Coly Li


> ---
>   drivers/md/bcache/bcache.h | 2 +-
>   drivers/md/bcache/super.c  | 4 +---
>   2 files changed, 2 insertions(+), 4 deletions(-)
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

