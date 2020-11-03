Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E849A2A4560
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 13:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgKCMnl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 07:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgKCMnk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 07:43:40 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A51C0613D1;
        Tue,  3 Nov 2020 04:43:40 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id p4so1183381plr.1;
        Tue, 03 Nov 2020 04:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7QLqywFmU+KaV60QUG9EODca87X6CJuhGzY9qo8iUx8=;
        b=dE5XLc60bPPpOgAkikgyNnt4irBqLPJVHNswiVXxrJfDXpwKDeSA4gn5W+o+/zaqc9
         LH9BPrKLyZqf7DBI3bhDHA+6Q9V4VELrhD6rsA+2ad8jTRWDOS/BO9IEbcKQ6hIgcBtR
         gd7b9eMw7lY7uZ/B1tURBiW7xEdBn6yqUVGlsJFXCDBFp8aKi/6EYZPSjGvym7z1esi6
         d+WM4dQpd+3RaTaDfiSzQnShFJEmCYU66Pplvtz4RWgwC+DetqaNuYVFld+S72FT/TTL
         r1m3VVZ3INzMr5CgOh3KmG63HOKbwZJs0MREGjoCmqJa/tcavIhD47Ahx62OqBFfyNfo
         XOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7QLqywFmU+KaV60QUG9EODca87X6CJuhGzY9qo8iUx8=;
        b=gOzzv30B1+QsPFHL6KlLRRccAQuglTxRwS+BUPlxGE1/p3IJLhcnxg/CvcQNrFe0mi
         yPOtbeIYHnTIJl6hiWSf/uT3vebnJecBfPTQVKuj8eG2IDA0HjZ3JsixeJmFOB07r354
         7mzz1xrAQG60V4qp+kHdXATg7KeDiBb4PC6KHDW+DJ0/i7X9ewxYwT21M9Aa+dIZeAS5
         1KRZ+gDz1eDVzy0/WHwZjhMza7JyShbVpRtIbpzJaRN/moKKvxBEnCmo4XyIuajoNkaz
         VRBIWvSL+A84Lo/a8D2a/2+wj7FDnMDk8rl0Sfu7UyJeCErf1yh1hEJucIbtXD8qa5TS
         /AEw==
X-Gm-Message-State: AOAM532GTyxkXGVRmduoJhN9hwzJfnmuPdbYix+egxCjM5wf9HyFn9q9
        wXihAepKcMrFO2Tkn0a8XAY=
X-Google-Smtp-Source: ABdhPJz2GvCFIqY6W4UxW1xm8db2BdF1YNPaJTdDR+a+GeeFHJk0okS/34jHpWmAvDZ9s7qDCW257A==
X-Received: by 2002:a17:902:8eca:b029:d2:4276:1b2d with SMTP id x10-20020a1709028ecab02900d242761b2dmr25197624plo.17.1604407419759;
        Tue, 03 Nov 2020 04:43:39 -0800 (PST)
Received: from localhost.localdomain ([45.77.27.82])
        by smtp.gmail.com with ESMTPSA id a25sm3024461pfg.138.2020.11.03.04.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 04:43:39 -0800 (PST)
From:   Dongdong Tao <tdd21151186@gmail.com>
To:     colyli@suse.de
Cc:     gavin.guo@canonical.com, gerald.yang@canonical.com,
        trent.lloyd@canonical.com,
        dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org (open list:BCACHE (BLOCK LAYER CACHE)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] bcache: consider the fragmentation when update the writeback rate
Date:   Tue,  3 Nov 2020 20:42:35 +0800
Message-Id: <20201103124235.14440-1-tdd21151186@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: dongdong tao <dongdong.tao@canonical.com>

Current way to calculate the writeback rate only considered the
dirty sectors, this usually works fine when the fragmentation
is not high, but it will give us unreasonable small rate when
we are under a situation that very few dirty sectors consumed
a lot dirty buckets. In some case, the dirty bucekts can reached
to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) noteven
reached the writeback_percent, the writeback rate will still
be the minimum value (4k), thus it will cause all the writes to be
stucked in a non-writeback mode because of the slow writeback.

This patch will try to accelerate the writeback rate when the
fragmentation is high. It calculate the propotional_scaled value
based on below:
(dirty_sectors / writeback_rate_p_term_inverse) * fragment
As we can see, the higher fragmentation will result a larger
proportional_scaled value, thus cause a larger writeback rate.
The fragment value is calculated based on below:
(dirty_buckets *  bucket_size) / dirty_sectors
If you think about it, the value of fragment will be always
inside [1, bucket_size].

This patch only considers the fragmentation when the number of
dirty_buckets reached to a dirty threshold(configurable by
writeback_fragment_percent, default is 50), so bcache will
remain the original behaviour before the dirty buckets reached
the threshold.

Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
---
 drivers/md/bcache/bcache.h    |  1 +
 drivers/md/bcache/sysfs.c     |  6 ++++++
 drivers/md/bcache/writeback.c | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e6..87632f7032b6 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -374,6 +374,7 @@ struct cached_dev {
 	unsigned int		writeback_metadata:1;
 	unsigned int		writeback_running:1;
 	unsigned char		writeback_percent;
+	unsigned char		writeback_fragment_percent;
 	unsigned int		writeback_delay;
 
 	uint64_t		writeback_rate_target;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..69499113aef8 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -115,6 +115,7 @@ rw_attribute(stop_when_cache_set_failed);
 rw_attribute(writeback_metadata);
 rw_attribute(writeback_running);
 rw_attribute(writeback_percent);
+rw_attribute(writeback_fragment_percent);
 rw_attribute(writeback_delay);
 rw_attribute(writeback_rate);
 
@@ -197,6 +198,7 @@ SHOW(__bch_cached_dev)
 	var_printf(writeback_running,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
+	var_print(writeback_fragment_percent);
 	sysfs_hprint(writeback_rate,
 		     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
 	sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
@@ -308,6 +310,9 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent,
 			    0, bch_cutoff_writeback);
 
+	sysfs_strtoul_clamp(writeback_fragment_percent, dc->writeback_fragment_percent,
+			    0, bch_cutoff_writeback_sync);
+
 	if (attr == &sysfs_writeback_rate) {
 		ssize_t ret;
 		long int v = atomic_long_read(&dc->writeback_rate.rate);
@@ -498,6 +503,7 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_running,
 	&sysfs_writeback_delay,
 	&sysfs_writeback_percent,
+	&sysfs_writeback_fragment_percent,
 	&sysfs_writeback_rate,
 	&sysfs_writeback_rate_update_seconds,
 	&sysfs_writeback_rate_i_term_inverse,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3c74996978da..34babc89fdf3 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -88,6 +88,26 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	int64_t integral_scaled;
 	uint32_t new_rate;
 
+	/*
+	 * We need to consider the number of dirty buckets as well
+	 * when calculating the proportional_scaled, Otherwise we might
+	 * have an unreasonable small writeback rate at a highly fragmented situation
+	 * when very few dirty sectors consumed a lot dirty buckets, the
+	 * worst case is when dirty_data reached writeback_percent and
+	 * dirty buckets reached to cutoff_writeback_sync, but the rate
+	 * still will be at the minimum value, which will cause the write
+	 * stuck at a non-writeback mode.
+	 */
+	struct cache_set *c = dc->disk.c;
+
+	if (c->gc_stats.in_use > dc->writeback_fragment_percent && dirty > 0) {
+		int64_t dirty_buckets = (c->gc_stats.in_use * c->nbuckets) / 100;
+		int64_t fragment = (dirty_buckets *  c->cache->sb.bucket_size) / dirty;
+
+		proportional_scaled =
+		div_s64(dirty, dc->writeback_rate_p_term_inverse) * (fragment);
+	}
+
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    (error > 0 && time_before64(local_clock(),
 			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
@@ -969,6 +989,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
 	dc->writeback_percent		= 10;
+	dc->writeback_fragment_percent	= 50;
 	dc->writeback_delay		= 30;
 	atomic_long_set(&dc->writeback_rate.rate, 1024);
 	dc->writeback_rate_minimum	= 8;
-- 
2.17.1

