Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A2B47A39
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 08:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbfFQGyB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 02:54:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:50554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725778AbfFQGyB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 02:54:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6C4F9AC5A;
        Mon, 17 Jun 2019 06:53:59 +0000 (UTC)
Subject: Re: [PATCH V2 5/7] bcache: update cached_dev_init() with helper
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
 <20190617012832.4311-6-chaitanya.kulkarni@wdc.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <ae48b013-6e5f-1300-557e-1dbe0f4ad31c@suse.de>
Date:   Mon, 17 Jun 2019 14:53:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190617012832.4311-6-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/6/17 9:28 上午, Chaitanya Kulkarni wrote:
> In the bcache when initializing the device we don't actually use any
> sort of locking when reading the number of sectors from the part. This
> patch updates the cached_dev_init() with newly introduced helper
> function to read the nr_sects from block device's hd_parts with the help
> of part_nr_sects_read().
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
>  drivers/md/bcache/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 1b63ac876169..6a29ba89dae1 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1263,7 +1263,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  			q->limits.raid_partial_stripes_expensive;
>  
>  	ret = bcache_device_init(&dc->disk, block_size,
> -			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset);
> +			 bdev_nr_sects(dc->bdev) - dc->sb.data_offset);
>  	if (ret)
>  		return ret;
>  
> 
