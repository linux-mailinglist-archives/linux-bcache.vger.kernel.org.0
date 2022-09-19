Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38CD5BC1BE
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 05:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiISD3u (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 18 Sep 2022 23:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISD3t (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 18 Sep 2022 23:29:49 -0400
Received: from mail-m31106.qiye.163.com (mail-m31106.qiye.163.com [103.74.31.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD36B6451
        for <linux-bcache@vger.kernel.org>; Sun, 18 Sep 2022 20:29:44 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m31106.qiye.163.com (Hmail) with ESMTPA id 59C37A0271;
        Mon, 19 Sep 2022 11:29:41 +0800 (CST)
Message-ID: <6d8a2888-b20a-c71c-733f-97c6a91f1244@easystack.cn>
Date:   Mon, 19 Sep 2022 11:29:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   mingzhe <mingzhe.zou@easystack.cn>
Subject: Re: [PATCH v2] bcache: fix set_at_max_writeback_rate() for multiple
 attached devices
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220918121647.103458-1-colyli@suse.de>
Content-Language: en-US
In-Reply-To: <20220918121647.103458-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHRgdVkpMTUlPHUwfSE9IH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hOT1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PCI6ETo*GTIUSioeLj0RHVE2
        EjdPFE9VSlVKTU1ITk5DSkNKQk1PVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTUJCQzcG
X-HM-Tid: 0a8353cb625800fekurm59c37a0271
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



在 2022/9/18 20:16, Coly Li 写道:
> Inside set_at_max_writeback_rate() the calculation in following if()
> check is wrong,
> 	if (atomic_inc_return(&c->idle_counter) <
> 	    atomic_read(&c->attached_dev_nr) * 6)
> 
> Because each attached backing device has its own writeback thread
> running and increasing c->idle_counter, the counter increates much
> faster than expected. The correct calculation should be,
> 	(counter / dev_nr) < dev_nr * 6
> which equals to,
> 	counter < dev_nr * dev_nr * 6
> 
> This patch fixes the above mistake with correct calculation, and helper
> routine idle_counter_exceeded() is added to make code be more clear.
> 
> Reported-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> Changelog:
> v2: Add the missing "!atomic_read(&c->at_max_writeback_rate)" part
>      back.
> v1: Original verison.
> 
>   drivers/md/bcache/writeback.c | 73 +++++++++++++++++++++++++----------
>   1 file changed, 52 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 647661005176..c186bf55fe61 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -157,6 +157,53 @@ static void __update_writeback_rate(struct cached_dev *dc)
>   	dc->writeback_rate_target = target;
>   }
>   
> +static bool idle_counter_exceeded(struct cache_set *c)
> +{
> +	int counter, dev_nr;
> +
> +	/*
> +	 * If c->idle_counter is overflow (idel for really long time),
> +	 * reset as 0 and not set maximum rate this time for code
> +	 * simplicity.
> +	 */
> +	counter = atomic_inc_return(&c->idle_counter);
> +	if (counter <= 0) {
> +		atomic_set(&c->idle_counter, 0);
> +		return false;
> +	}
> +
> +	dev_nr = atomic_read(&c->attached_dev_nr);
> +	if (dev_nr == 0)
> +		return false;
> +
> +	/*
> +	 * c->idle_counter is increased by writeback thread of all
> +	 * attached backing devices, in order to represent a rough
> +	 * time period, counter should be divided by dev_nr.
> +	 * Otherwise the idle time cannot be larger with more backing
> +	 * device attached.
> +	 * The following calculation equals to checking
> +	 *	(counter / dev_nr) < (dev_nr * 6)
> +	 */
> +	if (counter < (dev_nr * dev_nr * 6))
> +		return false;
Hi, Coly

Look good to me. However, do we need to specify a maximum value for 
idle_counter. If cache_set has 100 backing devices, there are dev_nr*6 
rounds of update_writeback_rate() on each backing device, which takes 
dc->writeback_rate_update_seconds(default is 5 seconds)*600 seconds.

In fact, any io request from the backing device will clear the 
idle_counter of cache_set, and at_max_writeback_rate will exit soon. 
Therefore, if cache_set waits for 5 minutes or 10 minutes without any io 
request to start at_max_writeback_rate, it will not have any effect on 
the possible front-end io.

In addition, cache_set only waits 6 rounds of update_writeback_rate() 
should not have much performance impact.

mingzhe
> +
> +	return true;
> +}
> +
> +/*
> + * Idle_counter is increased everytime when update_writeback_rate() is
> + * called. If all backing devices attached to the same cache set have
> + * identical dc->writeback_rate_update_seconds values, it is about 6
> + * rounds of update_writeback_rate() on each backing device before
> + * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
> + * to each dc->writeback_rate.rate.
> + * In order to avoid extra locking cost for counting exact dirty cached
> + * devices number, c->attached_dev_nr is used to calculate the idle
> + * throushold. It might be bigger if not all cached device are in write-
> + * back mode, but it still works well with limited extra rounds of
> + * update_writeback_rate().
> + */
>   static bool set_at_max_writeback_rate(struct cache_set *c,
>   				       struct cached_dev *dc)
>   {
> @@ -167,21 +214,8 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
>   	/* Don't set max writeback rate if gc is running */
>   	if (!c->gc_mark_valid)
>   		return false;
> -	/*
> -	 * Idle_counter is increased everytime when update_writeback_rate() is
> -	 * called. If all backing devices attached to the same cache set have
> -	 * identical dc->writeback_rate_update_seconds values, it is about 6
> -	 * rounds of update_writeback_rate() on each backing device before
> -	 * c->at_max_writeback_rate is set to 1, and then max wrteback rate set
> -	 * to each dc->writeback_rate.rate.
> -	 * In order to avoid extra locking cost for counting exact dirty cached
> -	 * devices number, c->attached_dev_nr is used to calculate the idle
> -	 * throushold. It might be bigger if not all cached device are in write-
> -	 * back mode, but it still works well with limited extra rounds of
> -	 * update_writeback_rate().
> -	 */
> -	if (atomic_inc_return(&c->idle_counter) <
> -	    atomic_read(&c->attached_dev_nr) * 6)
> +
> +	if (!idle_counter_exceeded(c))
>   		return false;
>   
>   	if (atomic_read(&c->at_max_writeback_rate) != 1)
> @@ -195,13 +229,10 @@ static bool set_at_max_writeback_rate(struct cache_set *c,
>   	dc->writeback_rate_change = 0;
>   
>   	/*
> -	 * Check c->idle_counter and c->at_max_writeback_rate agagain in case
> -	 * new I/O arrives during before set_at_max_writeback_rate() returns.
> -	 * Then the writeback rate is set to 1, and its new value should be
> -	 * decided via __update_writeback_rate().
> +	 * In case new I/O arrives during before
> +	 * set_at_max_writeback_rate() returns.
>   	 */
> -	if ((atomic_read(&c->idle_counter) <
> -	     atomic_read(&c->attached_dev_nr) * 6) ||
> +	if (!idle_counter_exceeded(c) ||
>   	    !atomic_read(&c->at_max_writeback_rate))
>   		return false;
>   
