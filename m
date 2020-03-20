Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F7A18D2CE
	for <lists+linux-bcache@lfdr.de>; Fri, 20 Mar 2020 16:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCTPYw (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 20 Mar 2020 11:24:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:56370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgCTPYw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 20 Mar 2020 11:24:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AAFFAAD68;
        Fri, 20 Mar 2020 15:24:50 +0000 (UTC)
Subject: Re: [PATCH] bcache: optimize barrier usage for Rmw atomic bitops
To:     Davidlohr Bueso <dave@stgolabs.net>, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
References: <20200129180802.24626-1-dave@stgolabs.net>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <877a5349-3133-404a-86ea-02309080a520@suse.de>
Date:   Fri, 20 Mar 2020 23:24:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200129180802.24626-1-dave@stgolabs.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/1/30 2:08 上午, Davidlohr Bueso wrote:
> We can avoid the unnecessary barrier on non LL/SC architectures,
> such as x86. Instead, use the smp_mb__after_atomic().
> 

Hi Davidlohr,

> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>

Sorry for replying late. Indeed we don't need to worry about the extra
smp_mb() because the code patch gets called every 5 seconds by default,
which is very infrequent. But I like this more accurate patch, it is in
my testing already.

And by your inspiration, I also fix some other locations to use
smp_mb__before/after_atomic().

Thank you.

Coly Li

> ---
>  drivers/md/bcache/writeback.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 4a40f9eadeaf..284ff10f480f 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -183,7 +183,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	 */
>  	set_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>  
>  	/*
>  	 * CACHE_SET_IO_DISABLE might be set via sysfs interface,
> @@ -193,7 +193,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	    test_bit(CACHE_SET_IO_DISABLE, &c->flags)) {
>  		clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  		/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -		smp_mb();
> +		smp_mb__after_atomic();
>  		return;
>  	}
>  
> @@ -229,7 +229,7 @@ static void update_writeback_rate(struct work_struct *work)
>  	 */
>  	clear_bit(BCACHE_DEV_RATE_DW_RUNNING, &dc->disk.flags);
>  	/* paired with where BCACHE_DEV_RATE_DW_RUNNING is tested */
> -	smp_mb();
> +	smp_mb__after_atomic();
>  }
>  
>  static unsigned int writeback_delay(struct cached_dev *dc,
> 


-- 

Coly Li
