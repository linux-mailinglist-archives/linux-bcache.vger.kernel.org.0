Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821BC2204BB
	for <lists+linux-bcache@lfdr.de>; Wed, 15 Jul 2020 08:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgGOGED (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 15 Jul 2020 02:04:03 -0400
Received: from [195.135.220.15] ([195.135.220.15]:43004 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727908AbgGOGED (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 15 Jul 2020 02:04:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CE29EAB7A;
        Wed, 15 Jul 2020 06:04:03 +0000 (UTC)
Subject: Re: [PATCH v2 02/17] bcache: add read_super_basic() to read major
 part of super block
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20200715054612.6349-1-colyli@suse.de>
 <20200715054612.6349-3-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <07a49e09-5938-fed6-818e-0393acd1cbfe@suse.de>
Date:   Wed, 15 Jul 2020 08:03:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715054612.6349-3-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/15/20 7:45 AM, Coly Li wrote:
> Later patches will introduce feature set bits to on-disk super block and
> increase super block version. Current code in read_super() which reads
> basic part of super block for version BCACHE_SB_VERSION_CDEV and version
> BCACHE_SB_VERSION_CDEV_WITH_UUID will be shared with the new version.
> 
> Therefore this patch moves the reusable part into read_super_basic(),
> this preparation patch will make later patches more simplier and only
> focus on new feature set bits.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/super.c | 111 +++++++++++++++++++++-----------------
>   1 file changed, 63 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 7aa1d6737f66..74681fb92158 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -59,6 +59,67 @@ struct workqueue_struct *bch_journal_wq;
>   
>   /* Superblock */
>   
> +static const char *read_super_basic(struct cache_sb *sb,  struct block_device *bdev,
> +				     struct cache_sb_disk *s)
> +{
> +	const char *err;
> +	unsigned int i;
> +
> +	sb->nbuckets	= le64_to_cpu(s->nbuckets);
> +	sb->bucket_size	= le16_to_cpu(s->bucket_size);
> +
> +	sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
> +	sb->nr_this_dev	= le16_to_cpu(s->nr_this_dev);
> +
> +	err = "Too many buckets";
> +	if (sb->nbuckets > LONG_MAX)
> +		goto err;
> +
> +	err = "Not enough buckets";
> +	if (sb->nbuckets < 1 << 7)
> +		goto err;
> +
> +	err = "Bad block/bucket size";
> +	if (!is_power_of_2(sb->block_size) ||
> +	    sb->block_size > PAGE_SECTORS ||
> +	    !is_power_of_2(sb->bucket_size) ||
> +	    sb->bucket_size < PAGE_SECTORS)
> +		goto err;
> +
> +	err = "Invalid superblock: device too small";
> +	if (get_capacity(bdev->bd_disk) <
> +	    sb->bucket_size * sb->nbuckets)
> +		goto err;
> +
> +	err = "Bad UUID";
> +	if (bch_is_zero(sb->set_uuid, 16))
> +		goto err;
> +
> +	err = "Bad cache device number in set";
> +	if (!sb->nr_in_set ||
> +	    sb->nr_in_set <= sb->nr_this_dev ||
> +	    sb->nr_in_set > MAX_CACHES_PER_SET)
> +		goto err;
> +
> +	err = "Journal buckets not sequential";
> +	for (i = 0; i < sb->keys; i++)
> +		if (sb->d[i] != sb->first_bucket + i)
> +			goto err;
> +
> +	err = "Too many journal buckets";
> +	if (sb->first_bucket + sb->keys > sb->nbuckets)
> +		goto err;
> +
> +	err = "Invalid superblock: first bucket comes before end of super";
> +	if (sb->first_bucket * sb->bucket_size < 16)
> +		goto err;
> +
> +	err = NULL;
> +err:
> +	return err;
> +}
> +
> +
>   static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>   			      struct cache_sb_disk **res)
>   {
> @@ -133,55 +194,9 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>   		break;
>   	case BCACHE_SB_VERSION_CDEV:
>   	case BCACHE_SB_VERSION_CDEV_WITH_UUID:
> -		sb->nbuckets	= le64_to_cpu(s->nbuckets);
> -		sb->bucket_size	= le16_to_cpu(s->bucket_size);
> -
> -		sb->nr_in_set	= le16_to_cpu(s->nr_in_set);
> -		sb->nr_this_dev	= le16_to_cpu(s->nr_this_dev);
> -
> -		err = "Too many buckets";
> -		if (sb->nbuckets > LONG_MAX)
> -			goto err;
> -
> -		err = "Not enough buckets";
> -		if (sb->nbuckets < 1 << 7)
> -			goto err;
> -
> -		err = "Bad block/bucket size";
> -		if (!is_power_of_2(sb->block_size) ||
> -		    sb->block_size > PAGE_SECTORS ||
> -		    !is_power_of_2(sb->bucket_size) ||
> -		    sb->bucket_size < PAGE_SECTORS)
> -			goto err;
> -
> -		err = "Invalid superblock: device too small";
> -		if (get_capacity(bdev->bd_disk) <
> -		    sb->bucket_size * sb->nbuckets)
> -			goto err;
> -
> -		err = "Bad UUID";
> -		if (bch_is_zero(sb->set_uuid, 16))
> -			goto err;
> -
> -		err = "Bad cache device number in set";
> -		if (!sb->nr_in_set ||
> -		    sb->nr_in_set <= sb->nr_this_dev ||
> -		    sb->nr_in_set > MAX_CACHES_PER_SET)
> -			goto err;
> -
> -		err = "Journal buckets not sequential";
> -		for (i = 0; i < sb->keys; i++)
> -			if (sb->d[i] != sb->first_bucket + i)
> -				goto err;
> -
> -		err = "Too many journal buckets";
> -		if (sb->first_bucket + sb->keys > sb->nbuckets)
> -			goto err;
> -
> -		err = "Invalid superblock: first bucket comes before end of super";
> -		if (sb->first_bucket * sb->bucket_size < 16)
> +		err = read_super_basic(sb, bdev, s);
> +		if (err)
>   			goto err;
> -
>   		break;
>   	default:
>   		err = "Unsupported superblock version";
> 
read_super_common(), maybe?
'basic' sounds more like a degraded functionality...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
