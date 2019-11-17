Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E1FF77B
	for <lists+linux-bcache@lfdr.de>; Sun, 17 Nov 2019 04:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbfKQDfO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 Nov 2019 22:35:14 -0500
Received: from mx.ewheeler.net ([173.205.220.69]:59662 "EHLO mx.ewheeler.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfKQDfO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 Nov 2019 22:35:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id E5A0CA0693;
        Sun, 17 Nov 2019 03:35:09 +0000 (UTC)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id G3-pJBML2QD3; Sun, 17 Nov 2019 03:34:43 +0000 (UTC)
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 8D93AA0633;
        Sun, 17 Nov 2019 03:34:43 +0000 (UTC)
Date:   Sun, 17 Nov 2019 03:34:42 +0000 (UTC)
From:   Eric Wheeler <bcache@lists.ewheeler.net>
X-X-Sender: lists@mx.ewheeler.net
To:     Coly Li <colyli@suse.de>
cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 09/12] bcache: add idle_max_writeback_rate sysfs
 interface
In-Reply-To: <20191113080326.69989-10-colyli@suse.de>
Message-ID: <alpine.LRH.2.11.1911170334140.23583@mx.ewheeler.net>
References: <20191113080326.69989-1-colyli@suse.de> <20191113080326.69989-10-colyli@suse.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, 13 Nov 2019, Coly Li wrote:

> For writeback mode, if there is no regular I/O request for a while,
> the writeback rate will be set to the maximum value (1TB/s for now).
> This is good for most of the storage workload, but there are still
> people don't what the maximum writeback rate in I/O idle time.
> 
> This patch adds a sysfs interface file idle_max_writeback_rate to
> permit people to disable maximum writeback rate. Then the minimum
> writeback rate can be advised by writeback_rate_minimum in the
> bcache device's sysfs interface.
> 
> Reported-by: Christian Balzer <chibi@gol.com>
> Signed-off-by: Coly Li <colyli@suse.de>

This fixes a bug for Christian, add cc stable?

-Eric


--
Eric Wheeler



> ---
>  drivers/md/bcache/bcache.h    | 1 +
>  drivers/md/bcache/super.c     | 1 +
>  drivers/md/bcache/sysfs.c     | 7 +++++++
>  drivers/md/bcache/writeback.c | 4 ++++
>  4 files changed, 13 insertions(+)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 50241e045c70..9198c1b480d9 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -724,6 +724,7 @@ struct cache_set {
>  	unsigned int		gc_always_rewrite:1;
>  	unsigned int		shrinker_disabled:1;
>  	unsigned int		copy_gc_enabled:1;
> +	unsigned int		idle_max_writeback_rate_enabled:1;
>  
>  #define BUCKET_HASH_BITS	12
>  	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index d1352fcc6ff2..77e9869345e7 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -1834,6 +1834,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
>  	c->congested_read_threshold_us	= 2000;
>  	c->congested_write_threshold_us	= 20000;
>  	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
> +	c->idle_max_writeback_rate_enabled = 1;
>  	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
>  
>  	return c;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 627dcea0f5b6..733e2ddf3c78 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -134,6 +134,7 @@ rw_attribute(expensive_debug_checks);
>  rw_attribute(cache_replacement_policy);
>  rw_attribute(btree_shrinker_disabled);
>  rw_attribute(copy_gc_enabled);
> +rw_attribute(idle_max_writeback_rate);
>  rw_attribute(gc_after_writeback);
>  rw_attribute(size);
>  
> @@ -747,6 +748,8 @@ SHOW(__bch_cache_set)
>  	sysfs_printf(gc_always_rewrite,		"%i", c->gc_always_rewrite);
>  	sysfs_printf(btree_shrinker_disabled,	"%i", c->shrinker_disabled);
>  	sysfs_printf(copy_gc_enabled,		"%i", c->copy_gc_enabled);
> +	sysfs_printf(idle_max_writeback_rate,	"%i",
> +		     c->idle_max_writeback_rate_enabled);
>  	sysfs_printf(gc_after_writeback,	"%i", c->gc_after_writeback);
>  	sysfs_printf(io_disable,		"%i",
>  		     test_bit(CACHE_SET_IO_DISABLE, &c->flags));
> @@ -864,6 +867,9 @@ STORE(__bch_cache_set)
>  	sysfs_strtoul_bool(gc_always_rewrite,	c->gc_always_rewrite);
>  	sysfs_strtoul_bool(btree_shrinker_disabled, c->shrinker_disabled);
>  	sysfs_strtoul_bool(copy_gc_enabled,	c->copy_gc_enabled);
> +	sysfs_strtoul_bool(idle_max_writeback_rate,
> +			   c->idle_max_writeback_rate_enabled);
> +
>  	/*
>  	 * write gc_after_writeback here may overwrite an already set
>  	 * BCH_DO_AUTO_GC, it doesn't matter because this flag will be
> @@ -954,6 +960,7 @@ static struct attribute *bch_cache_set_internal_files[] = {
>  	&sysfs_gc_always_rewrite,
>  	&sysfs_btree_shrinker_disabled,
>  	&sysfs_copy_gc_enabled,
> +	&sysfs_idle_max_writeback_rate,
>  	&sysfs_gc_after_writeback,
>  	&sysfs_io_disable,
>  	&sysfs_cutoff_writeback,
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index d60268fe49e1..4a40f9eadeaf 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -122,6 +122,10 @@ static void __update_writeback_rate(struct cached_dev *dc)
>  static bool set_at_max_writeback_rate(struct cache_set *c,
>  				       struct cached_dev *dc)
>  {
> +	/* Don't sst max writeback rate if it is disabled */
> +	if (!c->idle_max_writeback_rate_enabled)
> +		return false;
> +
>  	/* Don't set max writeback rate if gc is running */
>  	if (!c->gc_mark_valid)
>  		return false;
> -- 
> 2.16.4
> 
> 
