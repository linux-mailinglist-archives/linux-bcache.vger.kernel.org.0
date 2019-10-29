Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DBEE7F65
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Oct 2019 05:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJ2E6z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Oct 2019 00:58:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:46838 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726708AbfJ2E6z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Oct 2019 00:58:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9FCEAE00;
        Tue, 29 Oct 2019 04:58:52 +0000 (UTC)
Subject: Re: [PATCH] block: optimize for small BS IO
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
References: <20191029041904.16461-1-ming.lei@redhat.com>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <ef82eac6-ebb1-3842-04f0-84671f5e9762@suse.de>
Date:   Tue, 29 Oct 2019 12:58:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029041904.16461-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/29 12:19 下午, Ming Lei wrote:
> __blk_queue_split() may be a bit heavy for small BS(such as 512B, or
> 4KB) IO, so introduce one flag to decide if this bio includes multiple
> page. And only consider to try splitting this bio in case that
> the multiple page flag is set.
> 
> ~3% - 5% IOPS improvement can be observed on io_uring test over
> null_blk(MQ), and the io_uring test code is from fio/t/io_uring.c
> 
> bch_bio_map() should be the only one which doesn't use bio_add_page(),
> so force to mark bio built via bch_bio_map() as MULTI_PAGE.
> 
> RAID5 has similar usage too, however the bio is really single-page bio,
> so not necessary to handle it.
> 
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Hi Ming,

For the bcache part, it is OK for me.

Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li


> ---
>  block/bio.c               | 8 ++++++++
>  block/blk-merge.c         | 4 ++++
>  block/bounce.c            | 3 +++
>  drivers/md/bcache/util.c  | 2 ++
>  include/linux/blk_types.h | 1 +
>  5 files changed, 18 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 8f0ed6228fc5..c288364b7cf3 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -583,6 +583,8 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	bio_set_flag(bio, BIO_CLONED);
>  	if (bio_flagged(bio_src, BIO_THROTTLED))
>  		bio_set_flag(bio, BIO_THROTTLED);
> +	if (bio_flagged(bio_src, BIO_MULTI_PAGE))
> +		bio_set_flag(bio, BIO_MULTI_PAGE);
>  	bio->bi_opf = bio_src->bi_opf;
>  	bio->bi_ioprio = bio_src->bi_ioprio;
>  	bio->bi_write_hint = bio_src->bi_write_hint;
> @@ -757,6 +759,9 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
>  		if (page_is_mergeable(bv, page, len, off, same_page)) {
>  			bv->bv_len += len;
>  			bio->bi_iter.bi_size += len;
> +
> +			if (!*same_page)
> +				bio_set_flag(bio, BIO_MULTI_PAGE);
>  			return true;
>  		}
>  	}
> @@ -789,6 +794,9 @@ void __bio_add_page(struct bio *bio, struct page *page,
>  	bio->bi_iter.bi_size += len;
>  	bio->bi_vcnt++;
>  
> +	if (bio->bi_vcnt >= 2 && !bio_flagged(bio, BIO_MULTI_PAGE))
> +		bio_set_flag(bio, BIO_MULTI_PAGE);
> +
>  	if (!bio_flagged(bio, BIO_WORKINGSET) && unlikely(PageWorkingset(page)))
>  		bio_set_flag(bio, BIO_WORKINGSET);
>  }
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 48e6725b32ee..737bbec9e153 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -309,6 +309,10 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
>  				nr_segs);
>  		break;
>  	default:
> +		if (!bio_flagged(*bio, BIO_MULTI_PAGE)) {
> +			*nr_segs = 1;
> +			return;
> +		}
>  		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
>  		break;
>  	}
> diff --git a/block/bounce.c b/block/bounce.c
> index f8ed677a1bf7..4b18a2accccc 100644
> --- a/block/bounce.c
> +++ b/block/bounce.c
> @@ -253,6 +253,9 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
>  	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
>  	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
>  
> +	if (bio_flagged(bio_src, BIO_MULTI_PAGE))
> +		bio_set_flag(bio, BIO_MULTI_PAGE);
> +
>  	switch (bio_op(bio)) {
>  	case REQ_OP_DISCARD:
>  	case REQ_OP_SECURE_ERASE:
> diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
> index 62fb917f7a4f..71f5cbb6fdd6 100644
> --- a/drivers/md/bcache/util.c
> +++ b/drivers/md/bcache/util.c
> @@ -253,6 +253,8 @@ start:		bv->bv_len	= min_t(size_t, PAGE_SIZE - bv->bv_offset,
>  
>  		size -= bv->bv_len;
>  	}
> +
> +	bio_set_flag(bio, BIO_MULTI_PAGE);
>  }
>  
>  /**
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index d688b96d1d63..b942399c97a0 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -222,6 +222,7 @@ enum {
>  				 * of this bio. */
>  	BIO_QUEUE_ENTERED,	/* can use blk_queue_enter_live() */
>  	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
> +	BIO_MULTI_PAGE,		/* used for optimize small BS IO */
>  	BIO_FLAG_LAST
>  };
>  
