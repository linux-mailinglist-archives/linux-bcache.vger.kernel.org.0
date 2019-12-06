Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94722114E4D
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 10:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbfLFJox (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 04:44:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:49250 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726070AbfLFJox (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 04:44:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 13DF5AC3F;
        Fri,  6 Dec 2019 09:44:51 +0000 (UTC)
Subject: Re: [PATCH 2/2] [PATCH] bcache: __write_super to handle page sizes
 other than 4k
To:     Liang Chen <liangchen.linux@gmail.com>
Cc:     kent.overstreet@gmail.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
References: <1575622543-22470-1-git-send-email-liangchen.linux@gmail.com>
 <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <e44b8bd9-470d-08af-be7f-a0808504772e@suse.de>
Date:   Fri, 6 Dec 2019 17:44:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1575622543-22470-2-git-send-email-liangchen.linux@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/12/6 4:55 下午, Liang Chen wrote:
> __write_super assumes super block data starts at offset 0 of the page
> read in with __bread from read_super, which is not true when page size
> is not 4k. We encountered the issue on system with 64K page size - commonly
>  seen on aarch64 architecture.
> 
> Instead of making any assumption on the offset of the data within the page,
> this patch calls __bread again to locate the data. That should not introduce
> an extra io since the page has been held when it's read in from read_super,
> and __write_super is not on performance critical code path.
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>

In general the patch is good for me. Just two minor requests I add them
in line the email.

Thanks.

> ---
>  drivers/md/bcache/super.c | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index a573ce1d85aa..a39450c9bc34 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -207,15 +207,27 @@ static void write_bdev_super_endio(struct bio *bio)
>  	closure_put(&dc->sb_write);
>  }
>  
> -static void __write_super(struct cache_sb *sb, struct bio *bio)
> +static int __write_super(struct cache_sb *sb, struct bio *bio,
> +			 struct block_device *bdev)
>  {
> -	struct cache_sb *out = page_address(bio_first_page_all(bio));
> +	struct cache_sb *out;
>  	unsigned int i;
> +	struct buffer_head *bh;
> +
> +	/*
> +	 * The page is held since read_super, this __bread * should not
> +	 * cause an extra io read.
> +	 */
> +	bh = __bread(bdev, 1, SB_SIZE);
> +	if (!bh)
> +		goto out_bh;
> +
> +	out = (struct cache_sb *) bh->b_data;

This is quite tricky here. Could you please to move this code piece into
an inline function and add code comments to explain why a read is
necessary for a write.


>  
>  	bio->bi_iter.bi_sector	= SB_SECTOR;
>  	bio->bi_iter.bi_size	= SB_SIZE;
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC|REQ_META);
> -	bch_bio_map(bio, NULL);
> +	bch_bio_map(bio, bh->b_data);
>  
>  	out->offset		= cpu_to_le64(sb->offset);
>  	out->version		= cpu_to_le64(sb->version);
> @@ -239,7 +251,14 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
>  	pr_debug("ver %llu, flags %llu, seq %llu",
>  		 sb->version, sb->flags, sb->seq);
>  
> +	/* The page will still be held without this bh.*/
> +	put_bh(bh);
>  	submit_bio(bio);
> +	return 0;
> +
> +out_bh:
> +	pr_err("Couldn't read super block, __write_super failed");
> +	return -1;
>  }
>  
>  static void bch_write_bdev_super_unlock(struct closure *cl)
> @@ -264,7 +283,8 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
>  
>  	closure_get(cl);
>  	/* I/O request sent to backing device */
> -	__write_super(&dc->sb, bio);
> +	if(__write_super(&dc->sb, bio, dc->bdev))
> +		closure_put(cl);
>  
>  	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
>  }
> @@ -312,7 +332,9 @@ void bcache_write_super(struct cache_set *c)
>  		bio->bi_private = ca;
>  
>  		closure_get(cl);
> -		__write_super(&ca->sb, bio);
> +		if(__write_super(&ca->sb, bio, ca->bdev))

And here, please add code comments for why closure_put() is necessary here.

> +			closure_put(cl);
> +
>  	}
>  
>  	closure_return_with_destructor(cl, bcache_write_super_unlock);
> 


-- 

Coly Li
