Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F2A3B5A55
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Jun 2021 10:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhF1ISL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 28 Jun 2021 04:18:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8481 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbhF1ISK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 28 Jun 2021 04:18:10 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GD0hk2l42zZnGS
        for <linux-bcache@vger.kernel.org>; Mon, 28 Jun 2021 16:12:38 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 16:15:43 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 16:15:42 +0800
Subject: Re: [PATCH 2/2] bcache-tools: Correct super block version check codes
To:     <yanhuan916@gmail.com>, <linux-bcache@vger.kernel.org>
CC:     <colyli@suse.de>, <dahefanteng@gmail.com>
References: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
 <1624584630-9283-2-git-send-email-yanhuan916@gmail.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <bf361a67-9df5-c04f-67ad-a387bdf1664d@huawei.com>
Date:   Mon, 28 Jun 2021 16:15:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1624584630-9283-2-git-send-email-yanhuan916@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2021/6/25 9:30, yanhuan916@gmail.com wrote:
> From: Huan Yan <yanhuan916@gmail.com>
> 
> This patch add missing super block version below:
> BCACHE_SB_VERSION_CDEV_WITH_UUID
> BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> BCACHE_SB_VERSION_CDEV_WITH_FEATURES
> BCACHE_SB_VERSION_BDEV_WITH_FEATURES
> ---
>   bcache.c | 22 +++++++++++++++-------
>   bcache.h |  3 ++-
>   lib.c    | 15 ++++++++++-----
>   make.c   |  8 ++++++--
>   show.c   |  6 ++++--
>   5 files changed, 37 insertions(+), 17 deletions(-)
> 
> diff --git a/bcache.c b/bcache.c
> index 1c4cef9..62ed08d 100644
> --- a/bcache.c
> +++ b/bcache.c
> @@ -199,7 +199,8 @@ int tree(void)
>   	sprintf(out, "%s", begin);
>   	list_for_each_entry_safe(devs, n, &head, dev_list) {
>   		if ((devs->version == BCACHE_SB_VERSION_CDEV
> -		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		    && strcmp(devs->state, BCACHE_BASIC_STATE_ACTIVE) == 0) {
>   			sprintf(out + strlen(out), "%s\n", devs->name);
>   			list_for_each_entry_safe(tmp, m, &head, dev_list) {
> @@ -231,7 +232,8 @@ int attach_both(char *cdev, char *backdev)
>   	if (ret != 0)
>   		return ret;
>   	if (type != BCACHE_SB_VERSION_BDEV
> -	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +	    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   		fprintf(stderr, "%s is not an backend device\n", backdev);
>   		return 1;
>   	}
> @@ -244,7 +246,8 @@ int attach_both(char *cdev, char *backdev)
>   	if (strlen(cdev) != 36) {
>   		ret = detail_dev(cdev, &bd, &cd, NULL, &type);
>   		if (type != BCACHE_SB_VERSION_CDEV
> -		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		    && type != BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			fprintf(stderr, "%s is not an cache device\n", cdev);
>   			return 1;
>   		}
> @@ -359,10 +362,13 @@ int main(int argc, char **argv)
>   		ret = detail_dev(devname, &bd, &cd, NULL, &type);
>   		if (ret != 0)
>   			return ret;
> -		if (type == BCACHE_SB_VERSION_BDEV) {
> +		if (type == BCACHE_SB_VERSION_BDEV
> +		    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			return stop_backdev(devname);
>   		} else if (type == BCACHE_SB_VERSION_CDEV
> -			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +			   || type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
>   			return unregister_cset(cd.base.cset);
>   		}
>   		return 1;
> @@ -408,7 +414,8 @@ int main(int argc, char **argv)
>   			return ret;
>   		}
>   		if (type != BCACHE_SB_VERSION_BDEV
> -		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			fprintf(stderr,
>   				"Only backend device is suppported\n");
>   			return 1;
> @@ -434,7 +441,8 @@ int main(int argc, char **argv)
>   			return ret;
>   		}
>   		if (type != BCACHE_SB_VERSION_BDEV
> -		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   			fprintf(stderr,
>   				"Only backend device is suppported\n");
>   			return 1;
> diff --git a/bcache.h b/bcache.h
> index 2ae25ee..b10d4c0 100644
> --- a/bcache.h
> +++ b/bcache.h
> @@ -164,7 +164,8 @@ struct cache_sb {
>   static inline bool SB_IS_BDEV(const struct cache_sb *sb)
>   {
>   	return sb->version == BCACHE_SB_VERSION_BDEV
> -		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
> +		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
>   }
>   
>   BITMASK(CACHE_SYNC,		struct cache_sb, flags, 0, 1);
> diff --git a/lib.c b/lib.c
> index 745dab6..ea1f18d 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -281,10 +281,12 @@ int get_dev_bname(char *devname, char *bname)
>   int get_bname(struct dev *dev, char *bname)
>   {
>   	if (dev->version == BCACHE_SB_VERSION_CDEV
> -	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		strcpy(bname, BCACHE_NO_SUPPORT);
>   	else if (dev->version == BCACHE_SB_VERSION_BDEV
> -		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
>   		return get_dev_bname(dev->name, bname);
>   	return 0;
>   }
> @@ -317,10 +319,12 @@ int get_backdev_attachpoint(char *devname, char *point)
>   int get_point(struct dev *dev, char *point)
>   {
>   	if (dev->version == BCACHE_SB_VERSION_CDEV
> -	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		strcpy(point, BCACHE_NO_SUPPORT);
>   	else if (dev->version == BCACHE_SB_VERSION_BDEV
> -		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
>   		return get_backdev_attachpoint(dev->name, point);
>   	return 0;
>   }
> @@ -331,7 +335,8 @@ int cset_to_devname(struct list_head *head, char *cset, char *devname)
>   
>   	list_for_each_entry(dev, head, dev_list) {
>   		if ((dev->version == BCACHE_SB_VERSION_CDEV
> -		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
> +		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
>   		    && strcmp(dev->cset, cset) == 0)
>   			strcpy(devname, dev->name);
>   	}
> diff --git a/make.c b/make.c
> index 39b381a..d3b4baa 100644
> --- a/make.c
> +++ b/make.c
> @@ -272,10 +272,14 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
>   			ret = detail_dev(dev, &bd, &cd, NULL, &type);
>   			if (ret != 0)
>   				exit(EXIT_FAILURE);
> -			if (type == BCACHE_SB_VERSION_BDEV) {
> +			if (type == BCACHE_SB_VERSION_BDEV
> +			    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
> +			    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
>   				ret = stop_backdev(dev);
>   			} else if (type == BCACHE_SB_VERSION_CDEV
> -				|| type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
> +				   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
> +				   || type ==
> +				   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {

Should be encapsulated into a function to make the code simpler and 
easier to maintain.


Thanks.

