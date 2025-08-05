Return-Path: <linux-bcache+bounces-1176-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E731FB1AD50
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 06:57:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12C5116EAB2
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Aug 2025 04:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2A721771A;
	Tue,  5 Aug 2025 04:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZ8F29UM"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63247288DB;
	Tue,  5 Aug 2025 04:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754369870; cv=none; b=LNWD/Lbsbpz5iUoY41HGjbBWqH6Fv2p/wjqUpAySwxujbI4JaxRvdfcChobc0PfhIoy0X3ajMFJxkEnDQMvqBhG6Eww3DcPD1s3LHQd44nMP0I0Ce2a0Ecx1Ho6jm7P2+XoT5Ls0jYUwBOduUki7eGh+DgggCHnhjCi/tHTvak0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754369870; c=relaxed/simple;
	bh=cJbs+cvM0NNKFQ/wSvXQE3ntNS2aAzkKyaYaG/X9Ims=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGMGTOvwmReYIQTVIa8VF7mYtbCOu1S6U4iDGgy89gElVKVdkU9/Cl1LPo7vm/widtLpq0MU71ls+T4YIraei0Q6IqeK9+3fHDyQVGiu9fd5Uxqo94XWKy2eOeNk9OWAW2z/uglBVoTvD1GpKq9EnhCuxHMYF7TgIHJL7EsGGbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZ8F29UM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D75C4CEF4;
	Tue,  5 Aug 2025 04:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754369870;
	bh=cJbs+cvM0NNKFQ/wSvXQE3ntNS2aAzkKyaYaG/X9Ims=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MZ8F29UMNxJFqIPIR9eWCaU7bMAQiENt9S3PavpThJD5WynI01Yku1E4HnH9zc5M1
	 5/c4znzGwR/4bmJMwRQIWd8C3bTpNUTp1HTs9fFOut+ravSzoXuZ/JP3Y3QN5uY7HD
	 lctF0AEdSgFgabKbIkYuxRG0eGaKsO0DAcYf5HLHEZkLYhKJUUDUcEYDIMuiCx/Bgc
	 ih3A784zNixG9njs9hrMv5CMFvCX/5DL25qB7vDeC7xs1QQbA2dXNdQ1/8TVeGwfyW
	 c6+iNeG7Ypqj2bQMw6HtlQWmyMNx0Cgl4l9kg6lJM0kGgCas15GGptZZpspgAJ17/l
	 JrT0AwGGhWWBA==
Date: Tue, 5 Aug 2025 12:57:45 +0800
From: Coly Li <colyli@kernel.org>
To: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Cc: kent.overstreet@linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcache: enhancing the security of dirty data writeback
Message-ID: <20250805045745.iu4ukc6tfdm3j7xn@P16.>
References: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>

On Thu, Jul 31, 2025 at 02:21:40PM +0800, Zhou Jifeng wrote:
> There is a potential data consistency risk in bcache's writeback mode:when
> the application calls fsync, bcache returns success after completing the
> log write, persisting the cache disk data, and persisting the HDD internal
> cache. However, at this point, the actual application data may still be in
> a dirty state and remain stuck in the cache disk. when these data are
> subsequently written back to the HDD asynchronously through REQ_OP_WRITE,
> there is no forced refresh mechanism to ensure physical placement on the
> disk, and there may be no power-off protection measures, which poses a risk
> of data loss. This mechanism may cause the application to misjudge that the
> data has been persisted, which is different from the actual storage state,
> and also violates the semantic agreement that fsync should ensure data
> persistence.
> 

[snipped]


> Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
> ---
>  drivers/md/bcache/bcache.h        |  23 ++++
>  drivers/md/bcache/bcache_ondisk.h |   4 +
>  drivers/md/bcache/sysfs.c         |  47 ++++++++
>  drivers/md/bcache/writeback.c     | 174 +++++++++++++++++++++++++++---
>  drivers/md/bcache/writeback.h     |   4 +
>  5 files changed, 239 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 785b0d9008fa..09424938437b 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -247,6 +247,17 @@ struct keybuf {
>  	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
>  };
>  
> +struct keybuf_preflush {
> +	spinlock_t	lock;
> +	struct list_head list;
> +	u32 count;
> +};
> +
> +struct flush_key_entry {
> +	struct keybuf_key key;
> +	struct list_head list;
> +};
> +
>  struct bcache_device {
>  	struct closure		cl;
>  
> @@ -346,6 +357,18 @@ struct cached_dev {
>  
>  	struct keybuf		writeback_keys;
>  
> +	/*
> +	 * Before performing preflush to the backing device, temporarily
> +	 * store the bkey waiting to clean up the dirty mark
> +	 */
> +	struct keybuf_preflush  preflush_keys;
> +	/*
> +	 * flush_interval is used to specify that a PROFLUSH operation will
> +	 * be issued once a certain number of dirty bkeys have been written
> +	 * each time.
> +	 */
> +	unsigned int flush_interval;
> +
>  	struct task_struct	*status_update_thread;
>  	/*
>  	 * Order the write-half of writeback operations strongly in dispatch
> diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
> index 6620a7f8fffc..df5800838e40 100644
> --- a/drivers/md/bcache/bcache_ondisk.h
> +++ b/drivers/md/bcache/bcache_ondisk.h
> @@ -294,6 +294,10 @@ BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
>  #define CACHE_MODE_WRITEBACK		1U
>  #define CACHE_MODE_WRITEAROUND		2U
>  #define CACHE_MODE_NONE			3U
> +BITMASK(BDEV_WRITEBACK_FLUSH,		struct cache_sb, flags, 4, 1);
> +#define WRITEBACK_FLUSH_OFF		0U
> +#define WRITEBACK_FLUSH_ON		1U
> +


We should avoid to change the on disk format. Can you use another method
to check whether the cached device has to be flushed? e.g. checking
dc->preflush_keys.


>  BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
>  #define BDEV_STATE_NONE			0U
>  #define BDEV_STATE_CLEAN		1U
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index e8f696cb58c0..cc228e592ab6 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -28,6 +28,18 @@ static const char * const bch_cache_modes[] = {
>  	NULL
>  };
>  
> +/*
> + * Default is 0 ("off")
> + * off: Do nothing
> + * on: Use FLUSH when writing back dirty data.
> + */
> +static const char * const bch_writeback_flush[] = {
> +	"off",
> +	"on",
> +	NULL
> +};
> +
> +
>  static const char * const bch_reada_cache_policies[] = {
>  	"all",
>  	"meta-only",
> @@ -151,6 +163,19 @@ rw_attribute(copy_gc_enabled);
>  rw_attribute(idle_max_writeback_rate);
>  rw_attribute(gc_after_writeback);
>  rw_attribute(size);
> +/*
> + * The "writeback_flush" has two options: "off" and "on". "off" is
> + * the default value.
> + * off: Do nothing
> + * on: Use FLUSH when writing back dirty data.
> + */
> +rw_attribute(writeback_flush);
> +/*
> + * "flush_interval" is used to specify that a PROFLUSH operation will
> + * be issued once a certain number of dirty bkeys have been written
> + * each time.
> + */
> +rw_attribute(flush_interval);
>  
>  static ssize_t bch_snprint_string_list(char *buf,
>  				       size_t size,
> @@ -213,6 +238,7 @@ SHOW(__bch_cached_dev)
>  	var_print(writeback_rate_fp_term_mid);
>  	var_print(writeback_rate_fp_term_high);
>  	var_print(writeback_rate_minimum);
> +	var_print(flush_interval);
>  
>  	if (attr == &sysfs_writeback_rate_debug) {
>  		char rate[20];
> @@ -283,6 +309,11 @@ SHOW(__bch_cached_dev)
>  		return strlen(buf);
>  	}
>  
> +	if (attr == &sysfs_writeback_flush)
> +		return bch_snprint_string_list(buf, PAGE_SIZE,
> +					       bch_writeback_flush,
> +					       BDEV_WRITEBACK_FLUSH(&dc->sb));
> +
>  #undef var
>  	return 0;
>  }
> @@ -354,6 +385,9 @@ STORE(__cached_dev)
>  
>  	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
>  
> +	sysfs_strtoul_clamp(flush_interval, dc->flush_interval,
> +			    WRITEBACK_FLUSH_INTERVAL_MIN, WRITEBACK_FLUSH_INTERVAL_MAX);
> +
>  	if (attr == &sysfs_io_disable) {
>  		int v = strtoul_or_return(buf);
>  
> @@ -451,6 +485,17 @@ STORE(__cached_dev)
>  	if (attr == &sysfs_stop)
>  		bcache_device_stop(&dc->disk);
>  
> +	if (attr == &sysfs_writeback_flush) {
> +		v = __sysfs_match_string(bch_writeback_flush, -1, buf);
> +		if (v < 0)
> +			return v;
> +
> +		if ((unsigned int) v != BDEV_WRITEBACK_FLUSH(&dc->sb)) {
> +			SET_BDEV_WRITEBACK_FLUSH(&dc->sb, v);
> +			bch_write_bdev_super(dc, NULL);
> +		}
> +	}
> +
>  	return size;
>  }
>  
> @@ -541,6 +586,8 @@ static struct attribute *bch_cached_dev_attrs[] = {
>  #endif
>  	&sysfs_backing_dev_name,
>  	&sysfs_backing_dev_uuid,
> +	&sysfs_writeback_flush,
> +	&sysfs_flush_interval,
>  	NULL
>  };
>  ATTRIBUTE_GROUPS(bch_cached_dev);

We don't need this sysfs item. Once the issue is fixed, this is
mandatory for data security, even performance hurts.



> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index 453efbbdc8ee..530eea2b953a 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -348,8 +348,121 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
>  	kfree(io);
>  }
>  
> +static int bcache_add_preflush_key(struct cached_dev *dc, struct keybuf_key *key)
> +{
> +	struct flush_key_entry *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
> +
> +	if (!entry) {
> +		pr_info("the preflush bkey memory allocation failed.\n");

The debug pr_info() can be removed.



> +		return -ENOMEM;
> +	}
> +
> +	memcpy(&entry->key, key, sizeof(*key));

You may want to look at bkey_copy().

> +	INIT_LIST_HEAD(&entry->list);
> +
> +	spin_lock(&dc->preflush_keys.lock);
> +	list_add_tail(&entry->list, &dc->preflush_keys.list);
> +	dc->preflush_keys.count++;
> +	spin_unlock(&dc->preflush_keys.lock);
> +
> +	return 0;
> +}
> +
> +static void bcache_mark_preflush_keys_clean(struct cached_dev *dc)
> +{
> +	struct flush_key_entry *e, *tmp;
> +
> +	list_for_each_entry_safe(e, tmp, &dc->preflush_keys.list, list) {
> +		list_del(&e->list);
> +		kfree(e);
> +	}
> +	dc->preflush_keys.count = 0;
> +}
> +

For dc->preflush_keys, I would prefer to use a static allocated buffer
then dynamic list. You may check the head routines in uti.h, this is
the thing I'd suggest to use.

You may initialize the heap buffer quite large, and store to preflush
keys in order. It will be useful when you insert the keys back to btree.


> +static void launch_async_preflush_endio(struct bio *bio)
> +{
> +	if (bio->bi_status)
> +		pr_err("flush backing device error %d.\n", bio->bi_status);
> +}
> +
> +
> +static inline void launch_async_preflush_request(struct cached_dev *dc)
> +{
> +	struct bio flush;
> +
> +	bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
> +
> +	flush.bi_private = dc;
> +	flush.bi_end_io = launch_async_preflush_endio;
> +
> +	submit_bio(&flush);
> +}
> +
> +
> +static void flush_backing_device(struct cached_dev *dc)
> +{
> +	int ret;
> +	unsigned int i;
> +	struct keylist keys;
> +	struct flush_key_entry *e, *tmp;
> +	struct bio flush;
> +
> +	if (dc->preflush_keys.count == 0)
> +		return;
> +
> +	bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
> +	ret = submit_bio_wait(&flush);
> +	if (ret) {
> +		pr_err("flush backing device error %d.\n", ret);
> +
> +		/*
> +		 * In the case of flush failure, do not update the status of bkey
> +		 * in the btree, and wait until the next time to re-write the dirty
> +		 * data.
> +		 */
> +		bcache_mark_preflush_keys_clean(dc);
> +		return;
> +	}
> +
> +	/*
> +	 * The dirty data was successfully written back and confirmed to be written
> +	 * to the disk. The status of the bkey in the btree was updated.
> +	 */
> +	list_for_each_entry_safe(e, tmp, &dc->preflush_keys.list, list) {
> +		memset(keys.inline_keys, 0, sizeof(keys.inline_keys));
> +		bch_keylist_init(&keys);
> +
> +		bkey_copy(keys.top, &(e->key.key));
> +		SET_KEY_DIRTY(keys.top, false);
> +		bch_keylist_push(&keys);
> +

If all the preflush keys are stored in a min heap, as I suggested
previously. Now you can assemble a keylist with multiple keys and
send them into bch_btree_insert(). The keys can beinserted in a
batch, which will be a bit faster.


> +		for (i = 0; i < KEY_PTRS(&(e->key.key)); i++)
> +			atomic_inc(&PTR_BUCKET(dc->disk.c, &(e->key.key), i)->pin);
> +
> +		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &(e->key.key));
> +
> +		if (ret)
> +			trace_bcache_writeback_collision(&(e->key.key));
> +
> +		atomic_long_inc(ret
> +				? &dc->disk.c->writeback_keys_failed
> +				: &dc->disk.c->writeback_keys_done);
> +
> +		list_del(&e->list);
> +		kfree(e);
> +
> +		/* For those bkeys that failed to be inserted, you can
> +		 * ignore them and they will be processed again in the
> +		 * next write-back scan.
> +		 */
> +	}
> +

Then the above code might be something like,

while (heap is not empty) {
	while (heap is not full && heap is not empty) {
		key = heap_pop()
		bch_keylist_add(keylist, key)
	}

	bch_btree_insert(keylist);
}

You need to check bch_btree_insert() to decide hte heap is max heap or
min heap.


> +	dc->preflush_keys.count = 0;
> +}
> +
>  static CLOSURE_CALLBACK(write_dirty_finish)
>  {
> +	int ret;
>  	closure_type(io, struct dirty_io, cl);
>  	struct keybuf_key *w = io->bio.bi_private;
>  	struct cached_dev *dc = io->dc;
> @@ -358,27 +471,41 @@ static CLOSURE_CALLBACK(write_dirty_finish)
>  
>  	/* This is kind of a dumb way of signalling errors. */
>  	if (KEY_DIRTY(&w->key)) {
> -		int ret;
>  		unsigned int i;
>  		struct keylist keys;
>  
> -		bch_keylist_init(&keys);
> +		if (!BDEV_WRITEBACK_FLUSH(&dc->sb)) {
> +update_bkey:
> +			bch_keylist_init(&keys);
>  
> -		bkey_copy(keys.top, &w->key);
> -		SET_KEY_DIRTY(keys.top, false);
> -		bch_keylist_push(&keys);
> +			bkey_copy(keys.top, &w->key);
> +			SET_KEY_DIRTY(keys.top, false);
> +			bch_keylist_push(&keys);
>  
> -		for (i = 0; i < KEY_PTRS(&w->key); i++)
> -			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
> +			for (i = 0; i < KEY_PTRS(&w->key); i++)
> +				atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
>  
> -		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
> +			ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
>  
> -		if (ret)
> -			trace_bcache_writeback_collision(&w->key);
> +			if (ret)
> +				trace_bcache_writeback_collision(&w->key);
>  
> -		atomic_long_inc(ret
> -				? &dc->disk.c->writeback_keys_failed
> -				: &dc->disk.c->writeback_keys_done);
> +			atomic_long_inc(ret
> +					? &dc->disk.c->writeback_keys_failed
> +					: &dc->disk.c->writeback_keys_done);
> +		} else {
> +			/* After flushing the backing device, update the btree */
> +			ret = bcache_add_preflush_key(dc, w);
> +
> +			/*
> +			 * When memory allocation fails, immediately send PREFLUSH
> +			 * and then update the btree.
> +			 */
> +			if (ret) {
> +				launch_async_preflush_request(dc);
> +				goto update_bkey;
> +			}
> +		}
>  	}
> 

If before the cleared key inserted into the btree, there are new write
into overlapped LBA range of the cleared key and a dirty key inserted.
Then the cleared key is inserted and overwrites the dirty key, but the
dirty data on cache is not written back to backing device yet. How to
handle such situation?
 
>  	bch_keybuf_del(&dc->writeback_keys, w);
> @@ -435,6 +562,7 @@ static CLOSURE_CALLBACK(write_dirty)
>  	if (KEY_DIRTY(&w->key)) {
>  		dirty_init(w);
>  		io->bio.bi_opf = REQ_OP_WRITE;
> +
>  		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
>  		bio_set_dev(&io->bio, io->dc->bdev);
>  		io->bio.bi_end_io	= dirty_endio;
> @@ -741,6 +869,7 @@ static int bch_writeback_thread(void *arg)
>  	struct cached_dev *dc = arg;
>  	struct cache_set *c = dc->disk.c;
>  	bool searched_full_index;
> +	unsigned long last_flush_jiffies = jiffies;
>  
>  	bch_ratelimit_reset(&dc->writeback_rate);
>  
> @@ -819,9 +948,23 @@ static int bch_writeback_thread(void *arg)
>  

Thanks.

Coly Li
>  		read_dirty(dc);
>  
> +		/*
> +		 * If the accumulated preflush_keys exceed a certain quantity or
> +		 * the interval time exceeds 30 seconds, issue the PREFLUSH command
> +		 * once.
> +		 */
> +		if (dc->preflush_keys.count >= dc->flush_interval ||
> +		    time_after(jiffies, last_flush_jiffies + 30 * HZ)) {
> +			flush_backing_device(dc);
> +			last_flush_jiffies = jiffies;
> +		}
> +
>  		if (searched_full_index) {
>  			unsigned int delay = dc->writeback_delay * HZ;
>  
> +			/* Clean up the remaining preflush_keys. */
> +			flush_backing_device(dc);
> +
>  			while (delay &&
>  			       !kthread_should_stop() &&
>  			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
> @@ -1068,10 +1211,15 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
>  	dc->writeback_rate_fp_term_mid = 10;
>  	dc->writeback_rate_fp_term_high = 1000;
>  	dc->writeback_rate_i_term_inverse = 10000;
> +	dc->flush_interval = WRITEBACK_FLUSH_INTERVAL_DEFAULT;
>  
>  	/* For dc->writeback_lock contention in update_writeback_rate() */
>  	dc->rate_update_retry = 0;
>  
> +	INIT_LIST_HEAD(&dc->preflush_keys.list);
> +	spin_lock_init(&dc->preflush_keys.lock);
> +	dc->preflush_keys.count = 0;
> +
>  	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
>  	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
>  }
> diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
> index 31df716951f6..1cd3e4addba2 100644
> --- a/drivers/md/bcache/writeback.h
> +++ b/drivers/md/bcache/writeback.h
> @@ -14,6 +14,10 @@
>  #define WRITEBACK_RATE_UPDATE_SECS_MAX		60
>  #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
>  
> +#define WRITEBACK_FLUSH_INTERVAL_MIN		500
> +#define WRITEBACK_FLUSH_INTERVAL_MAX		50000
> +#define WRITEBACK_FLUSH_INTERVAL_DEFAULT	20000 /* the number of bkey */
> +
>  #define BCH_AUTO_GC_DIRTY_THRESHOLD	50
>  
>  #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW 50
> -- 
> 2.18.1
> 

