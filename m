Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A586701A0C
	for <lists+linux-bcache@lfdr.de>; Sat, 13 May 2023 23:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjEMVaN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 13 May 2023 17:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjEMVaM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 13 May 2023 17:30:12 -0400
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E89170A
        for <linux-bcache@vger.kernel.org>; Sat, 13 May 2023 14:30:10 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 5187045;
        Sat, 13 May 2023 14:30:10 -0700 (PDT)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id u5fNxizfx0s0; Sat, 13 May 2023 14:30:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id CDEAE40;
        Sat, 13 May 2023 14:30:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net CDEAE40
Date:   Sat, 13 May 2023 14:30:05 -0700 (PDT)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
To:     Chaitanya Kulkarni <kch@nvidia.com>
cc:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/1] bcache: allow user to set QUEUE_FLAG_NOWAIT
In-Reply-To: <20230512095420.12578-2-kch@nvidia.com>
Message-ID: <31bfee17-47f0-b1ca-eb0-baf0762b41e8@ewheeler.net>
References: <20230512095420.12578-1-kch@nvidia.com> <20230512095420.12578-2-kch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Fri, 12 May 2023, Chaitanya Kulkarni wrote:

> Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
> parameter to retain the default behaviour. Also, update respective
> allocation flags in the write path. Following are the performance
> numbers with io_uring fio engine for random read, note that device has
> been populated fully with randwrite workload before taking these
> numbers :-
> 
> * linux-block (for-next) # grep IOPS  bc-*fio | column -t
> 
> nowait-off-1.fio:  read:  IOPS=482k,  BW=1885MiB/s
> nowait-off-2.fio:  read:  IOPS=484k,  BW=1889MiB/s
> nowait-off-3.fio:  read:  IOPS=483k,  BW=1886MiB/s
> 
> nowait-on-1.fio:   read:  IOPS=544k,  BW=2125MiB/s
> nowait-on-2.fio:   read:  IOPS=547k,  BW=2137MiB/s
> nowait-on-3.fio:   read:  IOPS=546k,  BW=2132MiB/s
> 
> * linux-block (for-next) # grep slat  bc-*fio | column -t
> 
> nowait-off-1.fio: slat (nsec):  min=430, max=5488.5k, avg=2797.52
> nowait-off-2.fio: slat (nsec):  min=431, max=8252.4k, avg=2805.33
> nowait-off-3.fio: slat (nsec):  min=431, max=6846.6k, avg=2814.57
> 
> nowait-on-1.fio:  slat (usec):  min=2,   max=39086,   avg=87.48
> nowait-on-2.fio:  slat (usec):  min=3,   max=39519,   avg=86.98
> nowait-on-3.fio:  slat (usec):  min=3,   max=38880,   avg=87.17
> 
> * linux-block (for-next) # grep cpu  bc-*fio | column -t
> 
> nowait-off-1.fio:  cpu  :  usr=2.77%,  sys=6.57%,   ctx=22015526
> nowait-off-2.fio:  cpu  :  usr=2.75%,  sys=6.59%,   ctx=22003700
> nowait-off-3.fio:  cpu  :  usr=2.81%,  sys=6.57%,   ctx=21938309
> 
> nowait-on-1.fio:   cpu  :  usr=1.08%,  sys=78.39%,  ctx=2744092
> nowait-on-2.fio:   cpu  :  usr=1.10%,  sys=79.76%,  ctx=2537466
> nowait-on-3.fio:   cpu  :  usr=1.10%,  sys=79.88%,  ctx=2528092


Wow, amazing for such a tiny patch.  Especially the latency numbers! Given 
this, maybe NOWAIT should be enabled by default.

Why would anyone want to use the old NOWAIT=off variant?

Are there benefits to going without NOWAIT that go unnoticed when testing 
against a ramdisk?

For example, (and this seems unlikely) can NOWAIT affect the IO scheduler 
in a way that would prevent sorted IOs headed toward a rotational disk?


It would be interesting to see two more test classes:

1. Ram disk cache with NVMe backing device.

2. NVMe cache with rotational HDD backing device.

-Eric

> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/md/bcache/request.c | 3 ++-
>  drivers/md/bcache/super.c   | 6 ++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 67a2e29e0b40..2055a23eb4b7 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -716,9 +716,10 @@ static inline struct search *search_alloc(struct bio *bio,
>  		struct bcache_device *d, struct block_device *orig_bdev,
>  		unsigned long start_time)
>  {
> +	gfp_t gfp = bio->bi_opf & REQ_NOWAIT ? GFP_NOWAIT : GFP_NOIO;
>  	struct search *s;
>  
> -	s = mempool_alloc(&d->c->search, GFP_NOIO);
> +	s = mempool_alloc(&d->c->search, gfp);
>  
>  	closure_init(&s->cl, NULL);
>  	do_bio_hook(s, bio, request_endio);
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 7e9d19fd21dd..f76822bece26 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -28,6 +28,7 @@
>  
>  unsigned int bch_cutoff_writeback;
>  unsigned int bch_cutoff_writeback_sync;
> +bool bch_nowait;
>  
>  static const char bcache_magic[] = {
>  	0xc6, 0x85, 0x73, 0xf6, 0x4e, 0x1a, 0x45, 0xca,
> @@ -971,6 +972,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  	}
>  
>  	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
> +	if (bch_nowait)
> +		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, d->disk->queue);
>  
>  	blk_queue_write_cache(q, true, true);
>  
> @@ -2933,6 +2936,9 @@ MODULE_PARM_DESC(bch_cutoff_writeback, "threshold to cutoff writeback");
>  module_param(bch_cutoff_writeback_sync, uint, 0);
>  MODULE_PARM_DESC(bch_cutoff_writeback_sync, "hard threshold to cutoff writeback");
>  
> +module_param(bch_nowait, bool, 0);
> +MODULE_PARM_DESC(bch_nowait, "set QUEUE_FLAG_NOWAIT");
> +
>  MODULE_DESCRIPTION("Bcache: a Linux block layer cache");
>  MODULE_AUTHOR("Kent Overstreet <kent.overstreet@gmail.com>");
>  MODULE_LICENSE("GPL");
> -- 
> 2.40.0
> 
> 
