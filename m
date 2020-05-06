Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3D1C69C7
	for <lists+linux-bcache@lfdr.de>; Wed,  6 May 2020 09:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgEFHHY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 6 May 2020 03:07:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:45294 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgEFHHY (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 6 May 2020 03:07:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 065A0AB99;
        Wed,  6 May 2020 07:07:23 +0000 (UTC)
Subject: Re: [PATCH RFC 1/2] tracing/block: cleanup rwbs filling in trace
 events
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Christoph Hellwig <hch@infradead.org>
References: <158860537783.30407.1084087380643625249.stgit@buzz>
From:   Coly Li <colyli@suse.de>
Autocrypt: addr=colyli@suse.de; keydata=
 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
Message-ID: <32f18d59-0717-702e-960f-e5b7a6dac756@suse.de>
Date:   Wed, 6 May 2020 15:07:15 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <158860537783.30407.1084087380643625249.stgit@buzz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/5/4 23:16, Konstantin Khlebnikov wrote:
> Define BLK_RWBS_LEN in blktrace_api.h
> Bcache events use shorter 6 char buffer which could overflow.
> 
> Also remove unsed "bytes" argument.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

The patch is good for me, it can be directly handled by block layer
maintainer and skip me.

Reviewed-by: Coly Li <colyli@suse.de>


Thank you.

Coly Li


> ---
>  include/linux/blktrace_api.h  |    4 +-
>  include/trace/events/bcache.h |   20 +++++-----
>  include/trace/events/block.h  |   84 ++++++++++++++++++++---------------------
>  kernel/trace/blktrace.c       |    2 -
>  4 files changed, 55 insertions(+), 55 deletions(-)
> 
> diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
> index 3b6ff5902edc..ea9da15d32d9 100644
> --- a/include/linux/blktrace_api.h
> +++ b/include/linux/blktrace_api.h
> @@ -120,7 +120,9 @@ struct compat_blk_user_trace_setup {
>  
>  #endif
>  
> -extern void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes);
> +#define BLK_RWBS_LEN	8
> +
> +extern void blk_fill_rwbs(char *rwbs, unsigned int op);
>  
>  static inline sector_t blk_rq_trace_sector(struct request *rq)
>  {
> diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
> index 0bddea663b3b..7440d704c200 100644
> --- a/include/trace/events/bcache.h
> +++ b/include/trace/events/bcache.h
> @@ -18,7 +18,7 @@ DECLARE_EVENT_CLASS(bcache_request,
>  		__field(sector_t,	sector			)
>  		__field(dev_t,		orig_sector		)
>  		__field(unsigned int,	nr_sector		)
> -		__array(char,		rwbs,	6		)
> +		__array(char,		rwbs,	BLK_RWBS_LEN	)
>  	),
>  
>  	TP_fast_assign(
> @@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(bcache_request,
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->orig_sector	= bio->bi_iter.bi_sector - 16;
>  		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  	),
>  
>  	TP_printk("%d,%d %s %llu + %u (from %d,%d @ %llu)",
> @@ -95,14 +95,14 @@ DECLARE_EVENT_CLASS(bcache_bio,
>  		__field(dev_t,		dev			)
>  		__field(sector_t,	sector			)
>  		__field(unsigned int,	nr_sector		)
> -		__array(char,		rwbs,	6		)
> +		__array(char,		rwbs,	BLK_RWBS_LEN	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  	),
>  
>  	TP_printk("%d,%d  %s %llu + %u",
> @@ -128,7 +128,7 @@ TRACE_EVENT(bcache_read,
>  		__field(dev_t,		dev			)
>  		__field(sector_t,	sector			)
>  		__field(unsigned int,	nr_sector		)
> -		__array(char,		rwbs,	6		)
> +		__array(char,		rwbs,	BLK_RWBS_LEN	)
>  		__field(bool,		cache_hit		)
>  		__field(bool,		bypass			)
>  	),
> @@ -137,7 +137,7 @@ TRACE_EVENT(bcache_read,
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		__entry->cache_hit = hit;
>  		__entry->bypass = bypass;
>  	),
> @@ -158,7 +158,7 @@ TRACE_EVENT(bcache_write,
>  		__field(u64,		inode			)
>  		__field(sector_t,	sector			)
>  		__field(unsigned int,	nr_sector		)
> -		__array(char,		rwbs,	6		)
> +		__array(char,		rwbs,	BLK_RWBS_LEN	)
>  		__field(bool,		writeback		)
>  		__field(bool,		bypass			)
>  	),
> @@ -168,7 +168,7 @@ TRACE_EVENT(bcache_write,
>  		__entry->inode		= inode;
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		__entry->writeback = writeback;
>  		__entry->bypass = bypass;
>  	),
> @@ -229,7 +229,7 @@ TRACE_EVENT(bcache_journal_write,
>  		__field(dev_t,		dev			)
>  		__field(sector_t,	sector			)
>  		__field(unsigned int,	nr_sector		)
> -		__array(char,		rwbs,	6		)
> +		__array(char,		rwbs,	BLK_RWBS_LEN	)
>  		__field(u32,		nr_keys			)
>  	),
>  
> @@ -238,7 +238,7 @@ TRACE_EVENT(bcache_journal_write,
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio->bi_iter.bi_size >> 9;
>  		__entry->nr_keys	= keys;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  	),
>  
>  	TP_printk("%d,%d  %s %llu + %u keys %u",
> diff --git a/include/trace/events/block.h b/include/trace/events/block.h
> index 81b43f5bdf23..aac9a5c0e2cc 100644
> --- a/include/trace/events/block.h
> +++ b/include/trace/events/block.h
> @@ -10,7 +10,6 @@
>  #include <linux/buffer_head.h>
>  #include <linux/tracepoint.h>
>  
> -#define RWBS_LEN	8
>  
>  DECLARE_EVENT_CLASS(block_buffer,
>  
> @@ -81,7 +80,7 @@ TRACE_EVENT(block_rq_requeue,
>  		__field(  dev_t,	dev			)
>  		__field(  sector_t,	sector			)
>  		__field(  unsigned int,	nr_sector		)
> -		__array(  char,		rwbs,	RWBS_LEN	)
> +		__array(  char,		rwbs,	BLK_RWBS_LEN	)
>  		__dynamic_array( char,	cmd,	1		)
>  	),
>  
> @@ -90,7 +89,7 @@ TRACE_EVENT(block_rq_requeue,
>  		__entry->sector    = blk_rq_trace_sector(rq);
>  		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
>  
> -		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
> +		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  		__get_str(cmd)[0] = '\0';
>  	),
>  
> @@ -124,7 +123,7 @@ TRACE_EVENT(block_rq_complete,
>  		__field(  sector_t,	sector			)
>  		__field(  unsigned int,	nr_sector		)
>  		__field(  int,		error			)
> -		__array(  char,		rwbs,	RWBS_LEN	)
> +		__array(  char,		rwbs,	BLK_RWBS_LEN	)
>  		__dynamic_array( char,	cmd,	1		)
>  	),
>  
> @@ -134,7 +133,7 @@ TRACE_EVENT(block_rq_complete,
>  		__entry->nr_sector = nr_bytes >> 9;
>  		__entry->error     = error;
>  
> -		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, nr_bytes);
> +		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  		__get_str(cmd)[0] = '\0';
>  	),
>  
> @@ -156,7 +155,7 @@ DECLARE_EVENT_CLASS(block_rq,
>  		__field(  sector_t,	sector			)
>  		__field(  unsigned int,	nr_sector		)
>  		__field(  unsigned int,	bytes			)
> -		__array(  char,		rwbs,	RWBS_LEN	)
> +		__array(  char,		rwbs,	BLK_RWBS_LEN	)
>  		__array(  char,         comm,   TASK_COMM_LEN   )
>  		__dynamic_array( char,	cmd,	1		)
>  	),
> @@ -167,7 +166,7 @@ DECLARE_EVENT_CLASS(block_rq,
>  		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
>  		__entry->bytes     = blk_rq_bytes(rq);
>  
> -		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
> +		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  		__get_str(cmd)[0] = '\0';
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>  	),
> @@ -232,7 +231,7 @@ TRACE_EVENT(block_bio_bounce,
>  		__field( dev_t,		dev			)
>  		__field( sector_t,	sector			)
>  		__field( unsigned int,	nr_sector		)
> -		__array( char,		rwbs,	RWBS_LEN	)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  		__array( char,		comm,	TASK_COMM_LEN	)
>  	),
>  
> @@ -240,7 +239,7 @@ TRACE_EVENT(block_bio_bounce,
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio_sectors(bio);
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>  	),
>  
> @@ -266,11 +265,11 @@ TRACE_EVENT(block_bio_complete,
>  	TP_ARGS(q, bio, error),
>  
>  	TP_STRUCT__entry(
> -		__field( dev_t,		dev		)
> -		__field( sector_t,	sector		)
> -		__field( unsigned,	nr_sector	)
> -		__field( int,		error		)
> -		__array( char,		rwbs,	RWBS_LEN)
> +		__field( dev_t,		dev			)
> +		__field( sector_t,	sector			)
> +		__field( unsigned,	nr_sector		)
> +		__field( int,		error			)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  	),
>  
>  	TP_fast_assign(
> @@ -278,7 +277,7 @@ TRACE_EVENT(block_bio_complete,
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio_sectors(bio);
>  		__entry->error		= error;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  	),
>  
>  	TP_printk("%d,%d %s %llu + %u [%d]",
> @@ -297,7 +296,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
>  		__field( dev_t,		dev			)
>  		__field( sector_t,	sector			)
>  		__field( unsigned int,	nr_sector		)
> -		__array( char,		rwbs,	RWBS_LEN	)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  		__array( char,		comm,	TASK_COMM_LEN	)
>  	),
>  
> @@ -305,7 +304,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio_sectors(bio);
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>  	),
>  
> @@ -364,7 +363,7 @@ TRACE_EVENT(block_bio_queue,
>  		__field( dev_t,		dev			)
>  		__field( sector_t,	sector			)
>  		__field( unsigned int,	nr_sector		)
> -		__array( char,		rwbs,	RWBS_LEN	)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  		__array( char,		comm,	TASK_COMM_LEN	)
>  	),
>  
> @@ -372,7 +371,7 @@ TRACE_EVENT(block_bio_queue,
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->nr_sector	= bio_sectors(bio);
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>  	),
>  
> @@ -392,7 +391,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
>  		__field( dev_t,		dev			)
>  		__field( sector_t,	sector			)
>  		__field( unsigned int,	nr_sector		)
> -		__array( char,		rwbs,	RWBS_LEN	)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  		__array( char,		comm,	TASK_COMM_LEN	)
>          ),
>  
> @@ -400,8 +399,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
>  		__entry->dev		= bio ? bio_dev(bio) : 0;
>  		__entry->sector		= bio ? bio->bi_iter.bi_sector : 0;
>  		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
> -		blk_fill_rwbs(__entry->rwbs,
> -			      bio ? bio->bi_opf : 0, __entry->nr_sector);
> +		blk_fill_rwbs(__entry->rwbs, bio ? bio->bi_opf : 0);
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>          ),
>  
> @@ -524,18 +522,18 @@ TRACE_EVENT(block_split,
>  	TP_ARGS(q, bio, new_sector),
>  
>  	TP_STRUCT__entry(
> -		__field( dev_t,		dev				)
> -		__field( sector_t,	sector				)
> -		__field( sector_t,	new_sector			)
> -		__array( char,		rwbs,		RWBS_LEN	)
> -		__array( char,		comm,		TASK_COMM_LEN	)
> +		__field( dev_t,		dev			)
> +		__field( sector_t,	sector			)
> +		__field( sector_t,	new_sector		)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
> +		__array( char,		comm,	TASK_COMM_LEN	)
>  	),
>  
>  	TP_fast_assign(
>  		__entry->dev		= bio_dev(bio);
>  		__entry->sector		= bio->bi_iter.bi_sector;
>  		__entry->new_sector	= new_sector;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
>  	),
>  
> @@ -564,12 +562,12 @@ TRACE_EVENT(block_bio_remap,
>  	TP_ARGS(q, bio, dev, from),
>  
>  	TP_STRUCT__entry(
> -		__field( dev_t,		dev		)
> -		__field( sector_t,	sector		)
> -		__field( unsigned int,	nr_sector	)
> -		__field( dev_t,		old_dev		)
> -		__field( sector_t,	old_sector	)
> -		__array( char,		rwbs,	RWBS_LEN)
> +		__field( dev_t,		dev			)
> +		__field( sector_t,	sector			)
> +		__field( unsigned int,	nr_sector		)
> +		__field( dev_t,		old_dev			)
> +		__field( sector_t,	old_sector		)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  	),
>  
>  	TP_fast_assign(
> @@ -578,7 +576,7 @@ TRACE_EVENT(block_bio_remap,
>  		__entry->nr_sector	= bio_sectors(bio);
>  		__entry->old_dev	= dev;
>  		__entry->old_sector	= from;
> -		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
> +		blk_fill_rwbs(__entry->rwbs, bio->bi_opf);
>  	),
>  
>  	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
> @@ -608,13 +606,13 @@ TRACE_EVENT(block_rq_remap,
>  	TP_ARGS(q, rq, dev, from),
>  
>  	TP_STRUCT__entry(
> -		__field( dev_t,		dev		)
> -		__field( sector_t,	sector		)
> -		__field( unsigned int,	nr_sector	)
> -		__field( dev_t,		old_dev		)
> -		__field( sector_t,	old_sector	)
> -		__field( unsigned int,	nr_bios		)
> -		__array( char,		rwbs,	RWBS_LEN)
> +		__field( dev_t,		dev			)
> +		__field( sector_t,	sector			)
> +		__field( unsigned int,	nr_sector		)
> +		__field( dev_t,		old_dev			)
> +		__field( sector_t,	old_sector		)
> +		__field( unsigned int,	nr_bios			)
> +		__array( char,		rwbs,	BLK_RWBS_LEN	)
>  	),
>  
>  	TP_fast_assign(
> @@ -624,7 +622,7 @@ TRACE_EVENT(block_rq_remap,
>  		__entry->old_dev	= dev;
>  		__entry->old_sector	= from;
>  		__entry->nr_bios	= blk_rq_count_bios(rq);
> -		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
> +		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags);
>  	),
>  
>  	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index ca39dc3230cb..dd10667d4164 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1935,7 +1935,7 @@ void blk_trace_remove_sysfs(struct device *dev)
>  
>  #ifdef CONFIG_EVENT_TRACING
>  
> -void blk_fill_rwbs(char *rwbs, unsigned int op, int bytes)
> +void blk_fill_rwbs(char *rwbs, unsigned int op)
>  {
>  	int i = 0;
>  
> 

