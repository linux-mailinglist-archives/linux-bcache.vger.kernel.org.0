Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36FB21E38B
	for <lists+linux-bcache@lfdr.de>; Tue, 14 Jul 2020 01:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGMXUf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 13 Jul 2020 19:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGMXUe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 13 Jul 2020 19:20:34 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FBCC061755;
        Mon, 13 Jul 2020 16:20:34 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gc9so657469pjb.2;
        Mon, 13 Jul 2020 16:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PVOeKA7FQdsMN5+dL3UUGYoEKACdqOFsPOc2jU/VX+U=;
        b=mdztuzcPA7svk6lr96fo7c507zRber1EcEqnRJoslIjGlRExjSBJ6mlmlcqbmL4lY+
         pSVXRyyn2t3zgN/SeRyUZV9CAvWmxBVO/uy5HJsXw0XPRPyI1D7eeWJHAM8rCrPgsf6W
         1fnjYsVs6o1GHOzrFl2d9hu25YkPe7HK19r4WWi/qm6B/W6vtKS+stafE8wAXJqxg6tb
         a4CxZ+B3kL2rZDAofO9P4RjV2TqwERSgos7+pQcwvU7CCoPAaztPg6WdWJQF9mXOConn
         IoMtV1BhcoyPjbs9yC0UB7dFWw+RUI/mVZ+f7dnXI/YujgstfAO9bOFW0pIYdBVHAbBc
         pRww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PVOeKA7FQdsMN5+dL3UUGYoEKACdqOFsPOc2jU/VX+U=;
        b=arD0hQjI81fxYnJrgoGfqTPy6wjMIcbumb15xvLlYsOrtVWu1dNmfa8JHcUUev/W/N
         KFxqnCm1VOID61BWsj1je7frTUYr1oMTTWn30j8QUZYwFi158JmNtV1SZKpU8skfcFYj
         w8ixY45BCsl/K8bA4xwSH0crbxfmoXcsQudSCEBfn4hAH8O1ZPlA5RbxotbOXstzF3+X
         xXO+K+FrDYB99uUW2mkQNP46WyGJZAgznIiMzIdlStp8vorwNQOJEf2X+XedL+UQ0Wy/
         LBHrn2Co+dqFjqZ6w1vcbkGh50dh9h2Gfrd0dqxHyI9PgeUZe3UbHz8mISk0xy9W22aw
         P9hQ==
X-Gm-Message-State: AOAM531xXiGTVANQVCQG6HAxty9UCH/iP59tvTECMji5hFju5TDu9/CV
        IXi5suoLQIsXxq7tkCqDSW8=
X-Google-Smtp-Source: ABdhPJw3Aja9GK2JP2rd5tT1yYhfzEY2eSvD1xkhCSppaQHXlVqjBVdwGwNY3fH6LyY0M2BoNQSO3A==
X-Received: by 2002:a17:90b:b15:: with SMTP id bf21mr1751243pjb.53.1594682434027;
        Mon, 13 Jul 2020 16:20:34 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([27.38.40.9])
        by smtp.gmail.com with ESMTPSA id z11sm7137302pfj.104.2020.07.13.16.20.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Jul 2020 16:20:33 -0700 (PDT)
From:   Guoju Fang <fangguoju@gmail.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Guoju Fang <fangguoju@gmail.com>
Subject: [PATCH] bcache: add a new sysfs interface to disable refill when read miss
Date:   Mon, 13 Jul 2020 11:28:22 +0800
Message-Id: <1594610902-4428-1-git-send-email-fangguoju@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When read cache miss, backing device will be read first, and then refill
the cache device. But under some scenarios there are large number of new
reads and rarely hit, so it's necessary to disable the refill when read
miss to save space for writes.

This patch add a new config called refill_on_miss_disabled which is not set
by default. Bcache user can set it by sysfs interface and then the bcache
device will not refill when read cache miss.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
---
 drivers/md/bcache/bcache.h  | 1 +
 drivers/md/bcache/request.c | 2 ++
 drivers/md/bcache/super.c   | 1 +
 drivers/md/bcache/sysfs.c   | 5 +++++
 4 files changed, 9 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 221e0191b687..3a19ee6de3a7 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -730,6 +730,7 @@ struct cache_set {
 	unsigned int		shrinker_disabled:1;
 	unsigned int		copy_gc_enabled:1;
 	unsigned int		idle_max_writeback_rate_enabled:1;
+	unsigned int		refill_on_miss_disabled:1;
 
 #define BUCKET_HASH_BITS	12
 	struct hlist_head	bucket_hash[1 << BUCKET_HASH_BITS];
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 7acf024e99f3..4bfa0e0b4b3f 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -378,6 +378,8 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 	     op_is_write(bio_op(bio))))
 		goto skip;
 
+	if (c->refill_on_miss_disabled && !op_is_write(bio_op(bio)))
+		goto skip;
 	/*
 	 * If the bio is for read-ahead or background IO, bypass it or
 	 * not depends on the following situations,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2014016f9a60..c1e9bfec1267 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1862,6 +1862,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	c->congested_write_threshold_us	= 20000;
 	c->error_limit	= DEFAULT_IO_ERROR_LIMIT;
 	c->idle_max_writeback_rate_enabled = 1;
+	c->refill_on_miss_disabled = 0;
 	WARN_ON(test_and_clear_bit(CACHE_SET_IO_DISABLE, &c->flags));
 
 	return c;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 0dadec5a78f6..178300f401bb 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -144,6 +144,7 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+rw_attribute(refill_on_miss_disabled);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -779,6 +780,8 @@ SHOW(__bch_cache_set)
 	if (attr == &sysfs_bset_tree_stats)
 		return bch_bset_print_stats(c, buf);
 
+	sysfs_printf(refill_on_miss_disabled, "%i", c->refill_on_miss_disabled);
+
 	return 0;
 }
 SHOW_LOCKED(bch_cache_set)
@@ -898,6 +901,7 @@ STORE(__bch_cache_set)
 	 * set in next chance.
 	 */
 	sysfs_strtoul_clamp(gc_after_writeback, c->gc_after_writeback, 0, 1);
+	sysfs_strtoul(refill_on_miss_disabled, c->refill_on_miss_disabled);
 
 	return size;
 }
@@ -948,6 +952,7 @@ static struct attribute *bch_cache_set_files[] = {
 	&sysfs_congested_read_threshold_us,
 	&sysfs_congested_write_threshold_us,
 	&sysfs_clear_stats,
+	&sysfs_refill_on_miss_disabled,
 	NULL
 };
 KTYPE(bch_cache_set);
-- 
2.18.2

