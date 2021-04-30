Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCC336FCB2
	for <lists+linux-bcache@lfdr.de>; Fri, 30 Apr 2021 16:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbhD3Op3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 30 Apr 2021 10:45:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhD3OpV (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 30 Apr 2021 10:45:21 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA9FC06174A
        for <linux-bcache@vger.kernel.org>; Fri, 30 Apr 2021 07:44:29 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id z7so6271349uav.4
        for <linux-bcache@vger.kernel.org>; Fri, 30 Apr 2021 07:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=jtgJAeh/keAUczLNnC/nwzBVtyHgNLDtDOVVcuFrdd4=;
        b=dBKi/EuCNHCKPDJj98/W9XSYQE26oSRtWGS9l9CNDE0Dvukigok+ioZE7cX9TSeEn6
         rzMR5h0U2SlEPGGFltmhfIphMTyLzu44lRv41EGn0Jsz2ICoGU7w7f2+NTuCQVDG01dV
         kK4sCOejeYEqa4ihI6aOMzyseJ8O2whB5sJvvJLaXUvLD76sUXm5D6tvQbckSuJwtLzd
         aRZW8cTQV7lzxu+DuCuxGfwT2zg3zGyL+vDxR5lsARS8mEXO8MYwWAdXOnXajrtjzKzA
         pX2CbPqvATAJ9o/76rERV5ebLPWAgIwQD4+1VKR67M+448UcfsEIZwk9AwJLXeyb9RaN
         fVEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=jtgJAeh/keAUczLNnC/nwzBVtyHgNLDtDOVVcuFrdd4=;
        b=Bszr5sfXX5l1ZJIc1wxyNy4llToUO20rcNRLojuswkNeAS7lED8lXzHBbU1djIwM2X
         Q3sHVexnsSgmVUYrm2tcgntCLA+Kr9dioaqmk8u7DY5At5VQCiPdr5/r66Y0LBvD3GIv
         rovKmdzKiqcOIMjcor5Oo8bg+4h1tbvb4mXLF6ar9xnSHYjPGEXvgKdW4MdGlCAbdJG8
         cPiO9eYvrnstEFjFzj6xWIY8esE4v3uVPLNDMjpUXT0Fnvu2jKoy8VR1VRrUHSgz5KbM
         ifQ5TZmDDw+rESQz53+ZDOqDUgWT58TQt/rAgB2amrVTCoRt3eyAUthK1nPLxzp6WKLo
         7ugA==
X-Gm-Message-State: AOAM531NLQNkroBJXpSXdvRBCaEd0zt8+MHuBuixmMckyInAZyOs0+xk
        98oKdwV7Mz9Yxuvn71dfNOFfES3L0phovgIpDgIlPQmx
X-Google-Smtp-Source: ABdhPJyhlPfpMPp0fMRz+nB+1uE1Kd6/7Gd00vPkr1/Yqdb1VAoWk9V2dAUQIG/pRuJineCXhNc08N7U95f6wMH6KGM=
X-Received: by 2002:ab0:7c76:: with SMTP id h22mr5282777uax.34.1619793868163;
 Fri, 30 Apr 2021 07:44:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a67:ca8a:0:0:0:0:0 with HTTP; Fri, 30 Apr 2021 07:44:27
 -0700 (PDT)
From:   Marc Smith <msmith626@gmail.com>
Date:   Fri, 30 Apr 2021 10:44:27 -0400
Message-ID: <CAH6h+hc2quJhhBindQwQdK5pfsJRZWk5tX95RT3U_shuN1D=eQ@mail.gmail.com>
Subject: [PATCH v2] RFC - Write Bypass Race Bug
To:     linux-bcache <linux-bcache@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The problem:
If an inflight backing WRITE operation for a block is performed that
meets the criteria for bypassing the cache and that takes a long time
to complete, a READ operation for the same block may be fully
processed in the interim that populates the cache with the device
content from before the inflight WRITE. When the inflight WRITE
finally completes, since it was marked for bypass, the cache is not
subsequently updated, and the stale data populated by the READ request
remains in cache. While there is code in bcache for invalidating the
cache when a bypassed WRITE is performed, this is done prior to
issuing the backing I/O so it does not help.

The proposed fix:
Add two new lists to the cached_dev structure to track inflight
"bypass" write requests and inflight read requests that have have
missed cache. These are called "inflight_bypass_write_list" and
"inflight_read_list", respectively, and are protected by a spinlock
called the "inflight_lock"

When a WRITE is bypassing the cache, check whether there is an
overlapping inflight read. If so, set bypass = false to essentially
convert the bypass write into a writethrough write. Otherwise, if
there is no overlapping inflight read, then add the "search" structure
to the inflight bypass write list.

When a READ misses cache, check whether there is an overlapping
inflight write. If so, set a new flag in the search structure called
"do_not_cache" which causes cache population to be skipped after the
backing I/O completes. Otherwise, if there is no overlapping inflight
write, then add the "search" structure to the inflight read list.

The rest of the changes are to add a new stat called
"bypass_cache_insert_races" to track how many times the race was
encountered. Example:
cat /sys/fs/bcache/0c9b7a62-b431-4328-9dcb-a81e322238af/bdev0/stats_total/cache_bypass_races
16577

Assuming this is the correct approach, areas to look at:
1) Searching linked lists doesn't scale. Can something like an
interval tree be used here instead?
2) Can this be restructured so that the inflight_lock doesn't have to
be accessed with interrupts disabled? Note that search_free() can be
called in interrupt context.
3) Can do_not_cache just be another (1-bit) flag in the search
structure instead of occupying its own "int" ?

v1 -> v2 changes:
- Use interval trees instead of linked lists to track inflight requests.
- Change code order to avoid acquiring lock in search_free().
---
 drivers/md/bcache/bcache.h  |  4 ++
 drivers/md/bcache/request.c | 88 ++++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/stats.c   | 14 ++++++
 drivers/md/bcache/stats.h   |  4 ++
 drivers/md/bcache/super.c   |  4 ++
 5 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 848dd4db1659..1a6afafaaa9a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -397,6 +397,10 @@ struct cached_dev {
 	unsigned int		error_limit;
 	unsigned int		offline_seconds;

+	struct rb_root_cached	inflight_bypass_write_root;
+	struct rb_root_cached	inflight_read_root;
+	spinlock_t		inflight_lock;
+
 	char			backing_dev_name[BDEVNAME_SIZE];
 };

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..d6587cdbf4db 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -17,12 +17,34 @@
 #include <linux/hash.h>
 #include <linux/random.h>
 #include <linux/backing-dev.h>
+#include <linux/interval_tree_generic.h>

 #include <trace/events/bcache.h>

 #define CUTOFF_CACHE_ADD	95
 #define CUTOFF_CACHE_READA	90

+struct bch_itree_node {
+	struct rb_node	rb;
+	uint64_t	start;
+	uint64_t	last;
+	uint64_t	__subtree_last;
+};
+
+static uint64_t bch_itree_node_start(struct bch_itree_node *node)
+{
+	return node->start;
+}
+
+static uint64_t bch_itree_node_last(struct bch_itree_node *node)
+{
+	return node->last;
+}
+
+INTERVAL_TREE_DEFINE(struct bch_itree_node, rb,
+	uint64_t, __subtree_last,
+	bch_itree_node_start, bch_itree_node_last,, bch_itree)
+
 struct kmem_cache *bch_search_cache;

 static void bch_data_insert_start(struct closure *cl);
@@ -480,8 +502,40 @@ struct search {

 	struct btree_op		op;
 	struct data_insert_op	iop;
+	struct bch_itree_node   itree_node;
+	int			do_not_cache;
 };

+static bool check_inflight_overlapping(struct search *s)
+{
+	struct bch_itree_node *node;
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
+	struct rb_root_cached *search_root, *insert_root;
+	unsigned long flags;
+
+	if (s->write) {
+		search_root = &dc->inflight_read_root;
+		insert_root = &dc->inflight_bypass_write_root;
+	} else {
+		search_root = &dc->inflight_bypass_write_root;
+		insert_root = &dc->inflight_read_root;
+	}
+
+	spin_lock_irqsave(&dc->inflight_lock, flags);
+	node = bch_itree_iter_first(search_root,
+			s->itree_node.start, s->itree_node.last);
+	if (node == NULL) {
+		bch_itree_insert(&s->itree_node, insert_root);
+	}
+	spin_unlock_irqrestore(&dc->inflight_lock, flags);
+
+	if (node) {
+		bch_mark_cache_bypass_race(s->d->c, s->d);
+		return(true);
+	}
+	return(false);
+}
+
 static void bch_cache_read_endio(struct bio *bio)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
@@ -702,6 +756,21 @@ static void do_bio_hook(struct search *s,
 static void search_free(struct closure *cl)
 {
 	struct search *s = container_of(cl, struct search, cl);
+	struct cached_dev *dc = container_of(s->d,
+					struct cached_dev, disk);
+	unsigned long flags;
+
+	if (!RB_EMPTY_NODE(&s->itree_node.rb)) {
+		spin_lock_irqsave(&dc->inflight_lock, flags);
+		if (s->write) {
+			bch_itree_remove(&s->itree_node,
+				&dc->inflight_bypass_write_root);
+		} else {
+			bch_itree_remove(&s->itree_node,
+				&dc->inflight_read_root);
+		}
+		spin_unlock_irqrestore(&dc->inflight_lock, flags);
+	}

 	atomic_dec(&s->iop.c->search_inflight);

@@ -735,6 +804,10 @@ static inline struct search *search_alloc(struct bio *bio,
 	/* Count on the bcache device */
 	s->orig_bdev		= orig_bdev;
 	s->start_time		= start_time;
+	RB_CLEAR_NODE(&s->itree_node.rb);
+	s->itree_node.start	= bio->bi_iter.bi_sector;
+	s->itree_node.last	= s->itree_node.start + bio_sectors(bio) - 1;
+	s->do_not_cache		= 0;
 	s->iop.c		= d->c;
 	s->iop.bio		= NULL;
 	s->iop.inode		= d->id;
@@ -850,7 +923,7 @@ static void cached_dev_read_done(struct closure *cl)
 	closure_get(&dc->disk.cl);
 	bio_complete(s);

-	if (s->iop.bio &&
+	if (s->iop.bio && s->do_not_cache == 0 &&
 	    !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags)) {
 		BUG_ON(!s->iop.replace);
 		closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
@@ -886,6 +959,12 @@ static int cached_dev_cache_miss(struct btree *b,
struct search *s,

 	s->cache_missed = 1;

+	if (s->do_not_cache == 0 && RB_EMPTY_NODE(&s->itree_node.rb)) {
+		if (check_inflight_overlapping(s)) {
+			s->do_not_cache = 1;
+		}
+	}
+
 	if (s->cache_miss || s->iop.bypass) {
 		miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
 		ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
@@ -981,6 +1060,13 @@ static void cached_dev_write(struct cached_dev
*dc, struct search *s)

 	bch_keybuf_check_overlapping(&s->iop.c->moving_gc_keys, &start, &end);

+	if (s->iop.bypass == true) {
+		if (check_inflight_overlapping(s)) {
+			/* convert bypass write into writethrough write */
+			s->iop.bypass = false;
+		}
+	}
+
 	down_read_non_owner(&dc->writeback_lock);
 	if (bch_keybuf_check_overlapping(&dc->writeback_keys, &start, &end)) {
 		/*
diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index 503aafe188dc..31dbf69c80d6 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -49,6 +49,7 @@ read_attribute(cache_hit_ratio);
 read_attribute(cache_readaheads);
 read_attribute(cache_miss_collisions);
 read_attribute(bypassed);
+read_attribute(cache_bypass_races);

 SHOW(bch_stats)
 {
@@ -66,6 +67,7 @@ SHOW(bch_stats)

 	var_print(cache_readaheads);
 	var_print(cache_miss_collisions);
+	var_print(cache_bypass_races);
 	sysfs_hprint(bypassed,	var(sectors_bypassed) << 9);
 #undef var
 	return 0;
@@ -89,6 +91,7 @@ static struct attribute *bch_stats_files[] = {
 	&sysfs_cache_readaheads,
 	&sysfs_cache_miss_collisions,
 	&sysfs_bypassed,
+	&sysfs_cache_bypass_races,
 	NULL
 };
 static KTYPE(bch_stats);
@@ -116,6 +119,7 @@ void bch_cache_accounting_clear(struct
cache_accounting *acc)
 	acc->total.cache_readaheads = 0;
 	acc->total.cache_miss_collisions = 0;
 	acc->total.sectors_bypassed = 0;
+	acc->total.cache_bypass_races = 0;
 }

 void bch_cache_accounting_destroy(struct cache_accounting *acc)
@@ -148,6 +152,7 @@ static void scale_stats(struct cache_stats *stats,
unsigned long rescale_at)
 		scale_stat(&stats->cache_readaheads);
 		scale_stat(&stats->cache_miss_collisions);
 		scale_stat(&stats->sectors_bypassed);
+		scale_stat(&stats->cache_bypass_races);
 	}
 }

@@ -171,6 +176,7 @@ static void scale_accounting(struct timer_list *t)
 	move_stat(cache_readaheads);
 	move_stat(cache_miss_collisions);
 	move_stat(sectors_bypassed);
+	move_stat(cache_bypass_races);

 	scale_stats(&acc->total, 0);
 	scale_stats(&acc->day, DAY_RESCALE);
@@ -232,6 +238,14 @@ void bch_mark_sectors_bypassed(struct cache_set
*c, struct cached_dev *dc,
 	atomic_add(sectors, &c->accounting.collector.sectors_bypassed);
 }

+void bch_mark_cache_bypass_race(struct cache_set *c, struct bcache_device *d)
+{
+	struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+
+	atomic_inc(&dc->accounting.collector.cache_bypass_races);
+	atomic_inc(&c->accounting.collector.cache_bypass_races);
+}
+
 void bch_cache_accounting_init(struct cache_accounting *acc,
 			       struct closure *parent)
 {
diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index abfaabf7e7fc..4cd2dcea068b 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -10,6 +10,7 @@ struct cache_stat_collector {
 	atomic_t cache_readaheads;
 	atomic_t cache_miss_collisions;
 	atomic_t sectors_bypassed;
+	atomic_t cache_bypass_races;
 };

 struct cache_stats {
@@ -22,6 +23,7 @@ struct cache_stats {
 	unsigned long cache_readaheads;
 	unsigned long cache_miss_collisions;
 	unsigned long sectors_bypassed;
+	unsigned long cache_bypass_races;

 	unsigned int		rescale;
 };
@@ -61,5 +63,7 @@ void bch_mark_cache_miss_collision(struct cache_set *c,
 void bch_mark_sectors_bypassed(struct cache_set *c,
 			       struct cached_dev *dc,
 			       int sectors);
+void bch_mark_cache_bypass_race(struct cache_set *c,
+			       struct bcache_device *d);

 #endif /* _BCACHE_STATS_H_ */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 03e1fe4de53d..3bcc615f1216 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1495,6 +1495,10 @@ static int register_bdev(struct cache_sb *sb,
struct cache_sb_disk *sb_disk,
 			goto err;
 	}

+	spin_lock_init(&dc->inflight_lock);
+	dc->inflight_read_root = RB_ROOT_CACHED;
+	dc->inflight_bypass_write_root = RB_ROOT_CACHED;
+
 	return 0;
 err:
 	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
-- 
2.20.1
