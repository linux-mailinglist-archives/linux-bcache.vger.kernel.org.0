Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298AB3052BC
	for <lists+linux-bcache@lfdr.de>; Wed, 27 Jan 2021 07:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbhA0GC7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 Jan 2021 01:02:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:43904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237332AbhA0Dvq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 22:51:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E9AECAB92;
        Wed, 27 Jan 2021 03:51:00 +0000 (UTC)
Subject: Re: [PATCH V3] bcache: dont reset bio opf in bch_data_insert_start
To:     20210127031111.3493-1-dongsheng.yang@easystack.cn
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        mchristi@redhat.com
References: <20210127031550.3605-1-dongsheng.yang@easystack.cn>
From:   Coly Li <colyli@suse.de>
Message-ID: <dbcc0aa3-a29c-5a4b-a9f4-5f4f797ac490@suse.de>
Date:   Wed, 27 Jan 2021 11:50:58 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127031550.3605-1-dongsheng.yang@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/27/21 11:15 AM, Dongsheng Yang wrote:
> commit ad0d9e76(bcache: use bio op accessors) makes the bi_opf
> modified by bio_set_op_attrs(). But there is a logical
> problem in this commit:
> 
>                 trace_bcache_cache_insert(k);
>                 bch_keylist_push(&op->insert_keys);
> 
> -               n->bi_rw |= REQ_WRITE;
> +               bio_set_op_attrs(n, REQ_OP_WRITE, 0);
>                 bch_submit_bbio(n, op->c, k, 0);
>         } while (n != bio);
> 
> The old code add REQ_WRITE into bio n and keep other flags; the
> new code set REQ_OP_WRITE to bi_opf, but reset all other flags.
> 
> This problem is discoverd in our performance testing:
> (1) start a fio with 1M x 128depth for read in /dev/nvme0n1p1
> (2) start a fio with 1M x 128depth for write in /dev/escache0 (cache
> device is /dev/nvme0n1p2)
> 
> We found the BW of reading is 2000+M/s, but the BW of writing is
> 0-100M/s. After some debugging, we found the problem is io submit in
> writting is very slow.
> 
> bch_data_insert_start() insert a bio to /dev/nvme0n1p1, but as
> cached_dev submit stack bio will be added into current->bio_list, and
> return.Then __submit_bio_noacct() will submit the new bio in bio_list
> into /dev/nvme0n1p1. This operation would be slow in
> blk_mq_submit_bio() -> rq_qos_throttle(q, bio);
> 
> The rq_qos_throttle() will call wbt_should_throttle(),
> static inline bool wbt_should_throttle(struct rq_wb *rwb, struct bio *bio)
> {
>         switch (bio_op(bio)) {
>         case REQ_OP_WRITE:
>                 /*
>                  * Don't throttle WRITE_ODIRECT
>                  */
>                 if ((bio->bi_opf & (REQ_SYNC | REQ_IDLE)) ==
>                     (REQ_SYNC | REQ_IDLE))
>                         return false;
> ... ...
> }
> 
> As the bio_set_op_attrs() reset the (REQ_SYNC | REQ_IDLE), so this write
> bio will be considered as non-direct write.
> 
> After this fix, bio to nvme will flaged as (REQ_SYNC | REQ_IDLE),
> then fio for writing will get about 1000M/s bandwidth.
> 
> Fixes: ad0d9e76a412 ("bcache: use bio op accessors")
> CC: Mike Christie <mchristi@redhat.com>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>

The V3 patch is added to my for-next queue. Thanks for the fix up.

Coly Li


> ---
> V3-V2:
> 	remove an unused close-line in commit message.
> 
>  drivers/md/bcache/request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index c7cadaafa947..eb734f7ddaac 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -244,7 +244,7 @@ static void bch_data_insert_start(struct closure *cl)
>  		trace_bcache_cache_insert(k);
>  		bch_keylist_push(&op->insert_keys);
>  
> -		bio_set_op_attrs(n, REQ_OP_WRITE, 0);
> +		n->bi_opf |= REQ_OP_WRITE;
>  		bch_submit_bbio(n, op->c, k, 0);
>  	} while (n != bio);
>  
> 

