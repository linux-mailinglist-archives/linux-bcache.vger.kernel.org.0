Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE6F2EA3A7
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 04:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbhAEDHZ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Jan 2021 22:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhAEDHZ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Jan 2021 22:07:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5925BC061793;
        Mon,  4 Jan 2021 19:06:45 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id v3so15592081plz.13;
        Mon, 04 Jan 2021 19:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xENrclEGDl6glJgcYVqz5LneIt8S9uuGcpfcMMVUZXc=;
        b=WhEMPw+F53bNQyHNcXtn3N6pnC7UQBkRmYrLfhuaPf/3gu9tGhmL+uBfaPRXb4j9pd
         n1fXgpp5OOVeNezybylTNeLbIhGHROHEUB9bfXM90S/3gOdU577kodf4O6YabvybJZHn
         z74wX1plfPhf0iPHgkNATG9cqblBH33UifIJ2J9nxznWQRPPoBTzZWeO5taKAR1eL3cT
         3/1o9yEx9yq44TPGY68MIPCvZmIu+NaDk8pklE4twc5y9KDCgRdkBn1Zt+3UarirGOfn
         M1gX9tZ3dupXBrK2n9pCv67e3S4My9Hpy4zFNjQjRFfwKuRz0gBlsULSFBstPaSH3Hw8
         4l5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xENrclEGDl6glJgcYVqz5LneIt8S9uuGcpfcMMVUZXc=;
        b=BYJcar8dd6O0ljk52JlCtUMHrmCFnLgDfipH15AQyIr/U2YngrzImjKr886Ctm26eK
         k1gs1M/HrKl1YtmKuxaaz4j5/RYGKRWb2oXTZYTyaBU3d+1I2C+3Coiqp/QhFU009Q5w
         KziHB/JiO66CojPYSSmsxWiEj7pVA+9xi/ZLqzAnm3e/NIfNTFiLdK5ge+MYtS0goa8F
         LUVQfnGYULxn0Fn8EHfqwYTN5sGQWNiekwVfSIxnMC3Pjei4iwrVQqBKZW9PG1vPh9vR
         E7XNL87H4hBxjSzCrQ1Z/DihFnrf+luWtgQZXdsgua8g5G9tJS/RUdBkLtP/V4Ie6+Ms
         gYLA==
X-Gm-Message-State: AOAM533rYa/OfhnAFpZsK/ZSZQInw1JBE8ZfiTW2Zam7gFP7rf+i/QPC
        uP9mjOvipu9Jj14QNq46/dQ=
X-Google-Smtp-Source: ABdhPJwaYRV7aIoVxsscjZc0D5HBU6kwPYWpOgZ5sQGsJWmK9OOKJwcaOf2U8wNcItNEv9vsR3fX0Q==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr1939322pjb.57.1609816004848;
        Mon, 04 Jan 2021 19:06:44 -0800 (PST)
Received: from localhost.localdomain ([45.77.27.82])
        by smtp.gmail.com with ESMTPSA id nm6sm676304pjb.25.2021.01.04.19.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 19:06:44 -0800 (PST)
From:   Dongdong Tao <tdd21151186@gmail.com>
To:     colyli@suse.de
Cc:     dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: consider the fragmentation when update the writeback rate
Date:   Tue,  5 Jan 2021 11:06:02 +0800
Message-Id: <20210105030602.14427-1-tdd21151186@gmail.com>
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

We accelerate the rate in 3 stages with different aggressiveness,
the first stage starts when dirty buckets percent reach above
BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW (50), the second is
BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID (57), the third is
BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH (64). By default
the first stage tries to writeback the amount of dirty data
in one bucket (on average) in (1 / (dirty_buckets_percent - 50)) second,
the second stage tries to writeback the amount of dirty data in one bucket
in (1 / (dirty_buckets_percent - 57)) * 200 millisecond, the third
stage tries to writeback the amount of dirty data in one bucket in
(1 / (dirty_buckets_percent - 64)) * 20 millisecond.

Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
---
 drivers/md/bcache/bcache.h    |  3 +++
 drivers/md/bcache/sysfs.c     | 18 ++++++++++++++++
 drivers/md/bcache/writeback.c | 39 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.h |  4 ++++
 4 files changed, 64 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e6..f8e892208bae 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -385,6 +385,9 @@ struct cached_dev {
 	unsigned int		writeback_rate_update_seconds;
 	unsigned int		writeback_rate_i_term_inverse;
 	unsigned int		writeback_rate_p_term_inverse;
+	unsigned int		writeback_rate_fp_term_low;
+	unsigned int		writeback_rate_fp_term_mid;
+	unsigned int		writeback_rate_fp_term_high;
 	unsigned int		writeback_rate_minimum;
 
 	enum stop_on_failure	stop_when_cache_set_failed;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..130df9406171 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -121,6 +121,9 @@ rw_attribute(writeback_rate);
 rw_attribute(writeback_rate_update_seconds);
 rw_attribute(writeback_rate_i_term_inverse);
 rw_attribute(writeback_rate_p_term_inverse);
+rw_attribute(writeback_rate_fp_term_low);
+rw_attribute(writeback_rate_fp_term_mid);
+rw_attribute(writeback_rate_fp_term_high);
 rw_attribute(writeback_rate_minimum);
 read_attribute(writeback_rate_debug);
 
@@ -205,6 +208,9 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_rate_update_seconds);
 	var_print(writeback_rate_i_term_inverse);
 	var_print(writeback_rate_p_term_inverse);
+	var_print(writeback_rate_fp_term_low);
+	var_print(writeback_rate_fp_term_mid);
+	var_print(writeback_rate_fp_term_high);
 	var_print(writeback_rate_minimum);
 
 	if (attr == &sysfs_writeback_rate_debug) {
@@ -331,6 +337,15 @@ STORE(__cached_dev)
 	sysfs_strtoul_clamp(writeback_rate_p_term_inverse,
 			    dc->writeback_rate_p_term_inverse,
 			    1, UINT_MAX);
+	sysfs_strtoul_clamp(writeback_rate_fp_term_low,
+			    dc->writeback_rate_fp_term_low,
+			    1, UINT_MAX);
+	sysfs_strtoul_clamp(writeback_rate_fp_term_mid,
+			    dc->writeback_rate_fp_term_mid,
+			    1, UINT_MAX);
+	sysfs_strtoul_clamp(writeback_rate_fp_term_high,
+			    dc->writeback_rate_fp_term_high,
+			    1, UINT_MAX);
 	sysfs_strtoul_clamp(writeback_rate_minimum,
 			    dc->writeback_rate_minimum,
 			    1, UINT_MAX);
@@ -502,6 +517,9 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_rate_update_seconds,
 	&sysfs_writeback_rate_i_term_inverse,
 	&sysfs_writeback_rate_p_term_inverse,
+	&sysfs_writeback_rate_fp_term_low,
+	&sysfs_writeback_rate_fp_term_mid,
+	&sysfs_writeback_rate_fp_term_high,
 	&sysfs_writeback_rate_minimum,
 	&sysfs_writeback_rate_debug,
 	&sysfs_io_errors,
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index a129e4d2707c..a21485448e8e 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -88,6 +88,42 @@ static void __update_writeback_rate(struct cached_dev *dc)
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
+	int64_t dirty_buckets = c->nbuckets - c->avail_nbuckets;
+
+	if (c->gc_stats.in_use > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW && dirty > 0) {
+		int64_t fragment = (dirty_buckets *  c->cache->sb.bucket_size) / dirty;
+		int64_t fp_term;
+		int64_t fps;
+
+		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
+			fp_term = dc->writeback_rate_fp_term_low *
+			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
+		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
+			fp_term = dc->writeback_rate_fp_term_mid *
+			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
+		} else {
+			fp_term = dc->writeback_rate_fp_term_high *
+			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
+		}
+		fps = (dirty / dirty_buckets) * fp_term;
+		if (fragment > 3 && fps > proportional_scaled) {
+			//Only overrite the p when fragment > 3
+			proportional_scaled = fps;
+		}
+	}
+
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    (error > 0 && time_before64(local_clock(),
 			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
@@ -984,6 +1020,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 
 	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
 	dc->writeback_rate_p_term_inverse = 40;
+	dc->writeback_rate_fp_term_low = 1;
+	dc->writeback_rate_fp_term_mid = 5;
+	dc->writeback_rate_fp_term_high = 50;
 	dc->writeback_rate_i_term_inverse = 10000;
 
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 3f1230e22de0..02b2f9df73f6 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -16,6 +16,10 @@
 
 #define BCH_AUTO_GC_DIRTY_THRESHOLD	50
 
+#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW 50
+#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID 57
+#define BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH 64
+
 #define BCH_DIRTY_INIT_THRD_MAX	64
 /*
  * 14 (16384ths) is chosen here as something that each backing device
-- 
2.17.1

