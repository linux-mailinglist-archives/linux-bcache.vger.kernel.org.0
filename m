Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9E836BB21
	for <lists+linux-bcache@lfdr.de>; Mon, 26 Apr 2021 23:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbhDZVXG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 26 Apr 2021 17:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbhDZVXF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 26 Apr 2021 17:23:05 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E69EC061574
        for <linux-bcache@vger.kernel.org>; Mon, 26 Apr 2021 14:22:22 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id j27so810248vsm.13
        for <linux-bcache@vger.kernel.org>; Mon, 26 Apr 2021 14:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BOmh552sJ3i+7JGSMeGWa6lCjBGU4TzGQ5Tul8vXdI0=;
        b=koA6W1hLIUfjoDCFINgcFuM2U67/PixtplHuZCEmUowlAtvbzMRssCM5EpTOqCNK4e
         8jsHBJUJxvvGWKykbIGQaMIT7RpxsxarEcpXD8/cX4VJzR7NmI4lE7ZYmiYdhpG97tRa
         pdsVVKKiPHnFE6tSJtyf3jdwSTImIWdO41i+da9awNj9Fe5g32VJof4FQA+WT41kE+GW
         1f1INGenei4nHlYoMfdN+DWd51UuXCiJaegUoTF15hwRN3dKqQo77cEXCRO2DTUb8pLV
         J5D0txpbWHce1ABY6AH04LR/Q23uFhnPAAtCIfjtE1pJb7bi9DUjTXApW7UFUySiIuIz
         JLBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BOmh552sJ3i+7JGSMeGWa6lCjBGU4TzGQ5Tul8vXdI0=;
        b=J4X4Ywn42EuUmjFhtdpRHRVZPAp8GbLT2r3GMvEqnBSvHrkzPh4nu3W+k22GLZsMl+
         a4UFrRC8GJGmtydm+ryrwD+065vidRYeuK3JzjkZeJVjvD5AN+/L8WmQBH1XpZOwdarP
         Cg5cWHi9M39w5O/JCzLUuDnkp1QzBCTuNVO3KvBrUB9B7+9rGq85GleIjj4aZ70/+qVt
         Okz27PxTv53QS6XA9BJJrlwFwOhAyZgCuxXbN/M4NkO8C5XcOKFtQyNj1HnGJwx6fuM/
         5hHRKh0K2EKR3Eaj3eFHIuR9ATyR4nCvHyKwhR95vyMdOG/WvG6Di1CcraXRvqCeewVP
         JurA==
X-Gm-Message-State: AOAM531c/QplWxIUUxwDcPoLd5Knqh9YkBo4LQ87WbBJOvbg8XlGlf+6
        RRyPenbklNyXD8JGNDwfi42RZ6xHE5OzAKX34Fmvigg+6Ac=
X-Google-Smtp-Source: ABdhPJz6pPuRo7RteWhEf3hee09+KSkZhj8Wt/5+c9GoHZnhjgw+JpMKckeQIL/1nabkZnWDhzLlD7LGVBufLtQkjrY=
X-Received: by 2002:a67:cd84:: with SMTP id r4mr4475917vsl.40.1619472141002;
 Mon, 26 Apr 2021 14:22:21 -0700 (PDT)
MIME-Version: 1.0
From:   Marc Smith <msmith626@gmail.com>
Date:   Mon, 26 Apr 2021 14:22:09 -0700
Message-ID: <CAH6h+hdimTRasDUd-jGRUpZ-t6ps23KJhXcjnTa7iim0JG9Wyw@mail.gmail.com>
Subject: [PATCH] RFC - Write Bypass Race Bug
To:     linux-bcache@vger.kernel.org
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
---
 drivers/md/bcache/bcache.h  |  4 ++
 drivers/md/bcache/request.c | 79 ++++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/stats.c   | 14 +++++++
 drivers/md/bcache/stats.h   |  4 ++
 drivers/md/bcache/super.c   |  4 ++
 5 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 848dd4db1659..15e9f9f9a9bc 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -397,6 +397,10 @@ struct cached_dev {
  unsigned int error_limit;
  unsigned int offline_seconds;

+ struct list_head inflight_bypass_write_list;
+ struct list_head inflight_read_list;
+ spinlock_t inflight_lock;
+
  char backing_dev_name[BDEVNAME_SIZE];
 };

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..734f25358f78 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -480,8 +480,59 @@ struct search {

  struct btree_op op;
  struct data_insert_op iop;
+ struct list_head inflight_node;
+ uint64_t req_start;
+ uint64_t req_end;
+ int do_not_cache;
 };

+static bool reqs_overlap(struct search *s1, struct search *s2)
+{
+ if ((s1->req_start <= s2->req_start && s1->req_end > s2->req_start) ||
+     (s1->req_start > s2->req_end && s1->req_start < s2->req_end)) {
+
+ return(true);
+ }
+
+ return(false);
+}
+
+static bool check_inflight_overlapping(struct search *s)
+{
+ struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
+ struct list_head *lh, *search_list, *insert_list;
+ struct search *entry;
+ unsigned long flags;
+ bool found = false;
+
+ if (s->write) {
+ search_list = &dc->inflight_read_list;
+ insert_list = &dc->inflight_bypass_write_list;
+ } else {
+ search_list = &dc->inflight_bypass_write_list;
+ insert_list = &dc->inflight_read_list;
+ }
+
+ spin_lock_irqsave(&dc->inflight_lock, flags);
+ list_for_each(lh, search_list) {
+ entry = list_entry(lh, struct search, inflight_node);
+ if (reqs_overlap(s, entry)) {
+ found = true;
+ break;
+ }
+ }
+
+ if (found == false) {
+ list_add(insert_list, &s->inflight_node);
+ }
+ spin_unlock_irqrestore(&dc->inflight_lock, flags);
+
+ if (found) {
+ bch_mark_cache_bypass_race(s->d->c, s->d);
+ }
+ return(found);
+}
+
 static void bch_cache_read_endio(struct bio *bio)
 {
  struct bbio *b = container_of(bio, struct bbio, bio);
@@ -702,6 +753,15 @@ static void do_bio_hook(struct search *s,
 static void search_free(struct closure *cl)
 {
  struct search *s = container_of(cl, struct search, cl);
+ struct cached_dev *dc = container_of(s->d,
+ struct cached_dev, disk);
+ unsigned long flags;
+
+ if (!list_empty(&s->inflight_node)) {
+ spin_lock_irqsave(&dc->inflight_lock, flags);
+ list_del(&s->inflight_node);
+ spin_unlock_irqrestore(&dc->inflight_lock, flags);
+ }

  atomic_dec(&s->iop.c->search_inflight);

@@ -735,6 +795,10 @@ static inline struct search *search_alloc(struct bio *bio,
  /* Count on the bcache device */
  s->orig_bdev = orig_bdev;
  s->start_time = start_time;
+ INIT_LIST_HEAD(&s->inflight_node);
+ s->req_start = bio->bi_iter.bi_sector;
+ s->req_end = s->req_start + bio_sectors(bio);
+ s->do_not_cache = 0;
  s->iop.c = d->c;
  s->iop.bio = NULL;
  s->iop.inode = d->id;
@@ -850,7 +914,7 @@ static void cached_dev_read_done(struct closure *cl)
  closure_get(&dc->disk.cl);
  bio_complete(s);

- if (s->iop.bio &&
+ if (s->iop.bio && s->do_not_cache == 0 &&
      !test_bit(CACHE_SET_STOPPING, &s->iop.c->flags)) {
  BUG_ON(!s->iop.replace);
  closure_call(&s->iop.cl, bch_data_insert, NULL, cl);
@@ -886,6 +950,12 @@ static int cached_dev_cache_miss(struct btree *b,
struct search *s,

  s->cache_missed = 1;

+ if (s->do_not_cache == 0) {
+ if (check_inflight_overlapping(s)) {
+ s->do_not_cache = 1;
+ }
+ }
+
  if (s->cache_miss || s->iop.bypass) {
  miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
  ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
@@ -981,6 +1051,13 @@ static void cached_dev_write(struct cached_dev
*dc, struct search *s)

  bch_keybuf_check_overlapping(&s->iop.c->moving_gc_keys, &start, &end);

+ if (s->iop.bypass == true) {
+ if (check_inflight_overlapping(s)) {
+ /* convert bypass write into writethrough write */
+ s->iop.bypass = false;
+ }
+ }
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
+ var_print(cache_bypass_races);
  sysfs_hprint(bypassed, var(sectors_bypassed) << 9);
 #undef var
  return 0;
@@ -89,6 +91,7 @@ static struct attribute *bch_stats_files[] = {
  &sysfs_cache_readaheads,
  &sysfs_cache_miss_collisions,
  &sysfs_bypassed,
+ &sysfs_cache_bypass_races,
  NULL
 };
 static KTYPE(bch_stats);
@@ -116,6 +119,7 @@ void bch_cache_accounting_clear(struct
cache_accounting *acc)
  acc->total.cache_readaheads = 0;
  acc->total.cache_miss_collisions = 0;
  acc->total.sectors_bypassed = 0;
+ acc->total.cache_bypass_races = 0;
 }

 void bch_cache_accounting_destroy(struct cache_accounting *acc)
@@ -148,6 +152,7 @@ static void scale_stats(struct cache_stats *stats,
unsigned long rescale_at)
  scale_stat(&stats->cache_readaheads);
  scale_stat(&stats->cache_miss_collisions);
  scale_stat(&stats->sectors_bypassed);
+ scale_stat(&stats->cache_bypass_races);
  }
 }

@@ -171,6 +176,7 @@ static void scale_accounting(struct timer_list *t)
  move_stat(cache_readaheads);
  move_stat(cache_miss_collisions);
  move_stat(sectors_bypassed);
+ move_stat(cache_bypass_races);

  scale_stats(&acc->total, 0);
  scale_stats(&acc->day, DAY_RESCALE);
@@ -232,6 +238,14 @@ void bch_mark_sectors_bypassed(struct cache_set
*c, struct cached_dev *dc,
  atomic_add(sectors, &c->accounting.collector.sectors_bypassed);
 }

+void bch_mark_cache_bypass_race(struct cache_set *c, struct bcache_device *d)
+{
+ struct cached_dev *dc = container_of(d, struct cached_dev, disk);
+
+ atomic_inc(&dc->accounting.collector.cache_bypass_races);
+ atomic_inc(&c->accounting.collector.cache_bypass_races);
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
+ atomic_t cache_bypass_races;
 };

 struct cache_stats {
@@ -22,6 +23,7 @@ struct cache_stats {
  unsigned long cache_readaheads;
  unsigned long cache_miss_collisions;
  unsigned long sectors_bypassed;
+ unsigned long cache_bypass_races;

  unsigned int rescale;
 };
@@ -61,5 +63,7 @@ void bch_mark_cache_miss_collision(struct cache_set *c,
 void bch_mark_sectors_bypassed(struct cache_set *c,
         struct cached_dev *dc,
         int sectors);
+void bch_mark_cache_bypass_race(struct cache_set *c,
+        struct bcache_device *d);

 #endif /* _BCACHE_STATS_H_ */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 03e1fe4de53d..eb670aa26796 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1495,6 +1495,10 @@ static int register_bdev(struct cache_sb *sb,
struct cache_sb_disk *sb_disk,
  goto err;
  }

+ spin_lock_init(&dc->inflight_lock);
+ INIT_LIST_HEAD(&dc->inflight_read_list);
+ INIT_LIST_HEAD(&dc->inflight_bypass_write_list);
+
  return 0;
 err:
  pr_notice("error %s: %s\n", dc->backing_dev_name, err);
-- 
2.20.1
