Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C42431F7A
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 16:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhJRO2f (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 10:28:35 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:41292 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhJRO2e (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 10:28:34 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BB82D1FDA2;
        Mon, 18 Oct 2021 14:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634567182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoKPkPCnADE9JuZGiYSzaCXP6TkruPVNeNQ6+zEG45U=;
        b=MS1kRcuNiS+fLkjSnAGNL6044lxWbfUZb7HTwiupSOzxwx/fBsNSZvhGF3dWz3iZ7Fpp8Q
        1bV/2xHngLbfnNOek2U5bDGyay8L/NFDvjlsyGZHqKRNXGa7ai2jGZVAKm17BCw5PGTnK0
        UsFJMjEEkY662nuWU0E1nhSkjFLsEv0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634567182;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PoKPkPCnADE9JuZGiYSzaCXP6TkruPVNeNQ6+zEG45U=;
        b=oRFci9l0uE+SdehgR7sB8fvyBhtXk9chiIqcESUkJcpjDHspUw9CZ9vkXKyPnHRqeqU2xH
        z3F9z+Dtr5rkE5Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CAAF613AFB;
        Mon, 18 Oct 2021 14:26:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id sQovIg2EbWE1fQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 18 Oct 2021 14:26:21 +0000
Subject: Re: [PATCH 1/4] bcache: remove the cache_dev_name field from struct
 cache
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org
References: <20211018060934.1816088-1-hch@lst.de>
 <20211018060934.1816088-2-hch@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <dc8601a6-21a5-3680-7489-1430d14788db@suse.de>
Date:   Mon, 18 Oct 2021 22:26:18 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211018060934.1816088-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/18/21 2:09 PM, Christoph Hellwig wrote:
> Just use the %pg format specifier to print the name directly.

Hi  Christoph,

NACK for this patch.  The buffer cache_dev_name is added on purpose, in 
case ca->bdev cannot be referenced correctly for some special condition 
when underlying device fails.

Thanks.

Coly Li
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/md/bcache/bcache.h | 2 --
>   drivers/md/bcache/io.c     | 8 ++++----
>   drivers/md/bcache/super.c  | 7 +++----
>   3 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 5fc989a6d4528..47ff9ecea2e29 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -470,8 +470,6 @@ struct cache {
>   	atomic_long_t		meta_sectors_written;
>   	atomic_long_t		btree_sectors_written;
>   	atomic_long_t		sectors_written;
> -
> -	char			cache_dev_name[BDEVNAME_SIZE];
>   };
>   
>   struct gc_stat {
> diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> index e4388fe3ab7ef..564357de76404 100644
> --- a/drivers/md/bcache/io.c
> +++ b/drivers/md/bcache/io.c
> @@ -123,13 +123,13 @@ void bch_count_io_errors(struct cache *ca,
>   		errors >>= IO_ERROR_SHIFT;
>   
>   		if (errors < ca->set->error_limit)
> -			pr_err("%s: IO error on %s%s\n",
> -			       ca->cache_dev_name, m,
> +			pr_err("%pg: IO error on %s%s\n",
> +			       ca->bdev, m,
>   			       is_read ? ", recovering." : ".");
>   		else
>   			bch_cache_set_error(ca->set,
> -					    "%s: too many IO errors %s\n",
> -					    ca->cache_dev_name, m);
> +					    "%pg: too many IO errors %s\n",
> +					    ca->bdev, m);
>   	}
>   }
>   
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index f2874c77ff797..d0d0257252adc 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2338,7 +2338,7 @@ static int cache_alloc(struct cache *ca)
>   err_free:
>   	module_put(THIS_MODULE);
>   	if (err)
> -		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> +		pr_notice("error %pg: %s\n", ca->bdev, err);
>   	return ret;
>   }
>   
> @@ -2348,7 +2348,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   	const char *err = NULL; /* must be set for any error case */
>   	int ret = 0;
>   
> -	bdevname(bdev, ca->cache_dev_name);
>   	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
>   	ca->bdev = bdev;
>   	ca->bdev->bd_holder = ca;
> @@ -2390,14 +2389,14 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   		goto out;
>   	}
>   
> -	pr_info("registered cache device %s\n", ca->cache_dev_name);
> +	pr_info("registered cache device %pg\n", ca->bdev);
>   
>   out:
>   	kobject_put(&ca->kobj);
>   
>   err:
>   	if (err)
> -		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
> +		pr_notice("error %pg: %s\n", ca->bdev, err);
>   
>   	return ret;
>   }

