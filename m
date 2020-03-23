Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F123F18F01D
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Mar 2020 08:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgCWHIT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 Mar 2020 03:08:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:55676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWHIT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Mar 2020 03:08:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AECBEAD45;
        Mon, 23 Mar 2020 07:08:17 +0000 (UTC)
Subject: Re: [PATCH 6/7] bcache: optimize barrier usage for Rmw atomic bitops
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-7-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <990e3e35-bd4f-7347-9027-e7dfa5171085@suse.de>
Date:   Mon, 23 Mar 2020 08:08:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200322060305.70637-7-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> We can avoid the unnecessary barrier on non LL/SC architectures,
> such as x86. Instead, use the smp_mb__after_atomic().
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/writeback.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 6673a37c8bd2..72ba6d015786 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	 */
>   	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>   
>   	/*
>   	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
> @@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
>   		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -		smp_mb();
> +		smp_mb__after_atomic();
>   		return;
>   	}
>   
> @@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
>   	 */
>   	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>   	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>   }
>   
>   static unsigned int writeback_delay(struct cached_dev *dc,
> 
Personally, I'd typically tend to use 'test_and_set_bit', as this not 
only implies a barrier, but also captures any errors; if you just use
'set_bit' you'll never know if the bit had been set already.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
