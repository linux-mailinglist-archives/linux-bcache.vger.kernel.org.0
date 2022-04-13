Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4464A4FF704
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Apr 2022 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235601AbiDMMpZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Apr 2022 08:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiDMMpW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Apr 2022 08:45:22 -0400
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756A11EAF9
        for <linux-bcache@vger.kernel.org>; Wed, 13 Apr 2022 05:43:01 -0700 (PDT)
Received: from [192.168.0.234] (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id F11C5C05D7;
        Wed, 13 Apr 2022 20:42:58 +0800 (CST)
Message-ID: <40068948-a978-512c-6338-4d37c0b4e5d4@easystack.cn>
Date:   Wed, 13 Apr 2022 20:42:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] bcache: check bch_cached_dev_attach() return value
Content-Language: en-US
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
 <20220411030417.7222-1-mingzhe.zou@easystack.cn>
 <20220411030417.7222-3-mingzhe.zou@easystack.cn>
From:   Zou Mingzhe <mingzhe.zou@easystack.cn>
In-Reply-To: <20220411030417.7222-3-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRkdTUxWGU1LGk0ZGk9LQk
        lDVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkxVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NjI6FSo5KTIsPS0MSR0hNC4N
        KSoaFE9VSlVKTU9CQ05ITExCSU1KVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBT0tITDcG
X-HM-Tid: 0a8022f2cc8d841ekuqwf11c5c05d7
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


在 2022/4/11 11:04, mingzhe.zou@easystack.cn 写道:
> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>
> handle error when call bch_cached_dev_attach() function
>
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>   drivers/md/bcache/super.c | 25 +++++++++++++++++++------
>   1 file changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e4a53c849fa6..940eea5f94de 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1460,7 +1460,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   {
>   	const char *err = "cannot allocate memory";
>   	struct cache_set *c;
> -	int ret = -ENOMEM;
> +	int ret = -ENOMEM, ret_tmp;
>   
>   	memcpy(&dc->sb, sb, sizeof(struct cache_sb));
>   	dc->bdev = bdev;
> @@ -1480,8 +1480,14 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
>   
>   	list_add(&dc->list, &uncached_devices);
>   	/* attach to a matched cache set if it exists */
> -	list_for_each_entry(c, &bch_cache_sets, list)
> -		bch_cached_dev_attach(dc, c, NULL);
> +	err = "failed to attach cached device";
> +	list_for_each_entry(c, &bch_cache_sets, list) {
> +		ret_tmp = bch_cached_dev_attach(dc, c, NULL);
> +		if (ret_tmp)
> +			ret = ret_tmp;
> +	}
> +	if (ret)
> +		goto err;

Hi, coly

Wrong here.

I have send v3.

mingzhe

>   
>   	if (BDEV_STATE(&dc->sb) == BDEV_STATE_NONE ||
>   	    BDEV_STATE(&dc->sb) == BDEV_STATE_STALE) {
> @@ -1981,6 +1987,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>   
>   static int run_cache_set(struct cache_set *c)
>   {
> +	int ret = -EIO, ret_tmp;
>   	const char *err = "cannot allocate memory";
>   	struct cached_dev *dc, *t;
>   	struct cache *ca = c->cache;
> @@ -2133,8 +2140,14 @@ static int run_cache_set(struct cache_set *c)
>   	if (bch_has_feature_obso_large_bucket(&c->cache->sb))
>   		pr_err("Detect obsoleted large bucket layout, all attached bcache device will be read-only\n");
>   
> -	list_for_each_entry_safe(dc, t, &uncached_devices, list)
> -		bch_cached_dev_attach(dc, c, NULL);
> +	err = "failed to attach cached device";
> +	list_for_each_entry_safe(dc, t, &uncached_devices, list) {
> +		ret_tmp = bch_cached_dev_attach(dc, c, NULL);
> +		if (ret_tmp)
> +			ret = ret_tmp;
> +	}
> +	if (ret)
> +		goto err;
>   
>   	flash_devs_run(c);
>   
> @@ -2151,7 +2164,7 @@ static int run_cache_set(struct cache_set *c)
>   
>   	bch_cache_set_error(c, "%s", err);
>   
> -	return -EIO;
> +	return ret;
>   }
>   
>   static const char *register_cache_set(struct cache *ca)
