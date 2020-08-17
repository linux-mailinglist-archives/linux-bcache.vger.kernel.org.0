Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C54245C69
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Aug 2020 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgHQGYX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Aug 2020 02:24:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:46380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgHQGYW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Aug 2020 02:24:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1EF8FAD5F;
        Mon, 17 Aug 2020 06:24:46 +0000 (UTC)
Subject: Re: [PATCH 11/14] bcache: remove can_attach_cache()
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200815041043.45116-1-colyli@suse.de>
 <20200815041043.45116-12-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c0267bbb-b06e-a399-05de-a175cd6be04f@suse.de>
Date:   Mon, 17 Aug 2020 08:24:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200815041043.45116-12-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/15/20 6:10 AM, Coly Li wrote:
> After removing the embedded struct cache_sb from struct cache_set, cache
> set will directly reference the in-memory super block of struct cache.
> It is unnecessary to compare block_size, bucket_size and nr_in_set from
> the identical in-memory super block in can_attach_cache().
> 
> This is a preparation patch for latter removing cache_set->sb from
> struct cache_set.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 10 ----------
>   1 file changed, 10 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 4ba713d0d9b0..a2bba78d78e6 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -2112,13 +2112,6 @@ static int run_cache_set(struct cache_set *c)
>   	return -EIO;
>   }
>   
> -static bool can_attach_cache(struct cache *ca, struct cache_set *c)
> -{
> -	return ca->sb.block_size	== c->sb.block_size &&
> -		ca->sb.bucket_size	== c->sb.bucket_size &&
> -		ca->sb.nr_in_set	== c->sb.nr_in_set;
> -}
> -
>   static const char *register_cache_set(struct cache *ca)
>   {
>   	char buf[12];
> @@ -2130,9 +2123,6 @@ static const char *register_cache_set(struct cache *ca)
>   			if (c->cache)
>   				return "duplicate cache set member";
>   
> -			if (!can_attach_cache(ca, c))
> -				return "cache sb does not match set";
> -
>   			if (!CACHE_SYNC(&ca->sb))
>   				SET_CACHE_SYNC(&c->sb, false);
>   
> 
Reviewed=by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
