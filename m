Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755BF250AC
	for <lists+linux-bcache@lfdr.de>; Tue, 21 May 2019 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfEUNju (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 21 May 2019 09:39:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:50340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728341AbfEUNju (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 21 May 2019 09:39:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6F484AEC6;
        Tue, 21 May 2019 13:39:49 +0000 (UTC)
Subject: Re: [PATCH] bcache: use sysfs_match_string() instead of
 __sysfs_match_string()
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com
References: <20190507094312.18633-1-alexandru.ardelean@analog.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <9883a9cb-815b-882e-91ee-d5d119c2f8b7@suse.de>
Date:   Tue, 21 May 2019 21:39:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507094312.18633-1-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/5/7 5:43 下午, Alexandru Ardelean wrote:
> The arrays (of strings) that are passed to __sysfs_match_string() are
> static, so use sysfs_match_string() which does an implicit ARRAY_SIZE()
> over these arrays.
> 
> Functionally, this doesn't change anything.
> The change is more cosmetic.
> 
> It only shrinks the static arrays by 1 byte each.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

This patch is in my testing queue. Thanks.

Coly Li


> ---
>  drivers/md/bcache/sysfs.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 17bae9c14ca0..0dfd9d4fb1c8 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -21,28 +21,24 @@ static const char * const bch_cache_modes[] = {
>  	"writethrough",
>  	"writeback",
>  	"writearound",
> -	"none",
> -	NULL
> +	"none"
>  };
>  
>  /* Default is 0 ("auto") */
>  static const char * const bch_stop_on_failure_modes[] = {
>  	"auto",
> -	"always",
> -	NULL
> +	"always"
>  };
>  
>  static const char * const cache_replacement_policies[] = {
>  	"lru",
>  	"fifo",
> -	"random",
> -	NULL
> +	"random"
>  };
>  
>  static const char * const error_actions[] = {
>  	"unregister",
> -	"panic",
> -	NULL
> +	"panic"
>  };
>  
>  write_attribute(attach);
> @@ -333,7 +329,7 @@ STORE(__cached_dev)
>  		bch_cached_dev_run(dc);
>  
>  	if (attr == &sysfs_cache_mode) {
> -		v = __sysfs_match_string(bch_cache_modes, -1, buf);
> +		v = sysfs_match_string(bch_cache_modes, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -344,7 +340,7 @@ STORE(__cached_dev)
>  	}
>  
>  	if (attr == &sysfs_stop_when_cache_set_failed) {
> -		v = __sysfs_match_string(bch_stop_on_failure_modes, -1, buf);
> +		v = sysfs_match_string(bch_stop_on_failure_modes, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -794,7 +790,7 @@ STORE(__bch_cache_set)
>  			    0, UINT_MAX);
>  
>  	if (attr == &sysfs_errors) {
> -		v = __sysfs_match_string(error_actions, -1, buf);
> +		v = sysfs_match_string(error_actions, buf);
>  		if (v < 0)
>  			return v;
>  
> @@ -1060,7 +1056,7 @@ STORE(__bch_cache)
>  	}
>  
>  	if (attr == &sysfs_cache_replacement_policy) {
> -		v = __sysfs_match_string(cache_replacement_policies, -1, buf);
> +		v = sysfs_match_string(cache_replacement_policies, buf);
>  		if (v < 0)
>  			return v;
>  
> 


-- 

Coly Li
