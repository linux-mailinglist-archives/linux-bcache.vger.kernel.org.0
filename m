Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1A22FBE0D
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Jan 2021 18:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727996AbhASO7i (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Jan 2021 09:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393792AbhASNJn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Jan 2021 08:09:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18DC5C061799;
        Tue, 19 Jan 2021 04:57:23 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so12143952pjl.0;
        Tue, 19 Jan 2021 04:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mnq50GoVB3u8nWq9E3HRn9gF2KiBsdsalQ9kyhj5Vto=;
        b=dDYP7k0WalrxpyYGZgBxTjZrfj9fDX7DvpN+0lnkiQtVPyESY5P+je5RZt5I6mHP2t
         V5Xltf3xR812fec+YFd63QBlKDNTaaby9vvXrI6vEbjG18Nxwxlt2nBz/UhrT9pbPWNc
         ZesuYRVlng6C8Gc+dGsrl/yJONYECrir0fw4jreKC9GlEevztGIJJroxUdn20e1Te+xo
         fxybmGQs/KOxZocXCfYDEHyjZQkVnPFVD1Lb63Sf4dBBIdYFxiuqiYOQgEVAgur/mulz
         vOsgHEjWDKLn/xlakGmU88WiUNCUS9jxz5xpDg5sTmddFtXFW7Uw1hjqN7zV4p/MFc4f
         +9gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mnq50GoVB3u8nWq9E3HRn9gF2KiBsdsalQ9kyhj5Vto=;
        b=scZbi1Icnt2LRsCDNSQ19TZm70DsoWpXuJGlTIqKOIxsMxtEbDX49IGDn3Nkp/NjaE
         1YM0K8OORZCepiCMJrffgnDWNltn8PDQi+9Lgny0+D7/Fjin2aLE05rBGglZOMjsMFm+
         0eFTKT3BlS5/79lgsNrP2EB3coYR5Tov8rA7WXZq3szpw37dY5mvIoyJ/2T8jjyREDAB
         wHgvLbe7ikHM8Q+u+e2yGj4ew7EoJSGDyhlWAkYAfbm377u3RYZQ3RnuzcP54DhJ3dn/
         +ZqDRyVfGeIFPDARI52nKbqinyrlOkKq55eDs++TPZd+LUOpdN/7OvzcMN/XxH06WlZI
         gtHw==
X-Gm-Message-State: AOAM531jT615oIyhdB7y/gjUFqWJdUWt16YSnNNWCl/59DBHxWmAppQ/
        T/WHE/Ym/lVPYXWNIjhYi0c=
X-Google-Smtp-Source: ABdhPJzpX2OMBAs+kkzf4lR366lp+dmAyaykOLEN2JdvrOR3J9smLMlN/r/8TE2RtCor9ahk/UZwKQ==
X-Received: by 2002:a17:90a:4490:: with SMTP id t16mr5502322pjg.55.1611061042676;
        Tue, 19 Jan 2021 04:57:22 -0800 (PST)
Received: from localhost.localdomain ([45.77.27.82])
        by smtp.gmail.com with ESMTPSA id w11sm19092124pge.28.2021.01.19.04.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 04:57:20 -0800 (PST)
From:   Dongdong Tao <tdd21151186@gmail.com>
To:     colyli@suse.de
Cc:     dongdong tao <dongdong.tao@canonical.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: consider the fragmentation when update the writeback rate
Date:   Tue, 19 Jan 2021 20:56:38 +0800
Message-Id: <20210119125639.21013-1-tdd21151186@gmail.com>
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
to CUTOFF_WRITEBACK_SYNC while the dirty data(sectors) not even
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
in (1 / (dirty_buckets_percent - 57)) * 100 millisecond, the third
stage tries to writeback the amount of dirty data in one bucket in
(1 / (dirty_buckets_percent - 64)) millisecond. It is ok to be very
aggressive in the last stage, as it is our last chance to pull it back.

Option writeback_consider_fragment to control whether we want
this feature to be on or off, it's on by default.

Lastly, below is the performance data for all the testing result,
including the data from production env:
https://docs.google.com/document/d/
1AmbIEa_2MhB9bqhC3rfga9tp7n9YX9PLn0jSUxscVW0/edit?usp=sharing

Signed-off-by: dongdong tao <dongdong.tao@canonical.com>
---
 drivers/md/bcache/bcache.h    |  4 ++++
 drivers/md/bcache/sysfs.c     | 22 ++++++++++++++++++
 drivers/md/bcache/writeback.c | 42 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.h |  4 ++++
 4 files changed, 72 insertions(+)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1d57f48307e6..d7a84327b7f1 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -373,6 +373,7 @@ struct cached_dev {
 	unsigned int		partial_stripes_expensive:1;
 	unsigned int		writeback_metadata:1;
 	unsigned int		writeback_running:1;
+	unsigned int		writeback_consider_fragment:1;
 	unsigned char		writeback_percent;
 	unsigned int		writeback_delay;
 
@@ -385,6 +386,9 @@ struct cached_dev {
 	unsigned int		writeback_rate_update_seconds;
 	unsigned int		writeback_rate_i_term_inverse;
 	unsigned int		writeback_rate_p_term_inverse;
+	unsigned int		writeback_rate_fp_term_low;
+	unsigned int		writeback_rate_fp_term_mid;
+	unsigned int		writeback_rate_fp_term_high;
 	unsigned int		writeback_rate_minimum;
 
 	enum stop_on_failure	stop_when_cache_set_failed;
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 00a520c03f41..136899beadba 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -117,10 +117,14 @@ rw_attribute(writeback_running);
 rw_attribute(writeback_percent);
 rw_attribute(writeback_delay);
 rw_attribute(writeback_rate);
+rw_attribute(writeback_consider_fragment);
 
 rw_attribute(writeback_rate_update_seconds);
 rw_attribute(writeback_rate_i_term_inverse);
 rw_attribute(writeback_rate_p_term_inverse);
+rw_attribute(writeback_rate_fp_term_low);
+rw_attribute(writeback_rate_fp_term_mid);
+rw_attribute(writeback_rate_fp_term_high);
 rw_attribute(writeback_rate_minimum);
 read_attribute(writeback_rate_debug);
 
@@ -195,6 +199,7 @@ SHOW(__bch_cached_dev)
 	var_printf(bypass_torture_test,	"%i");
 	var_printf(writeback_metadata,	"%i");
 	var_printf(writeback_running,	"%i");
+	var_printf(writeback_consider_fragment,	"%i");
 	var_print(writeback_delay);
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,
@@ -205,6 +210,9 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_rate_update_seconds);
 	var_print(writeback_rate_i_term_inverse);
 	var_print(writeback_rate_p_term_inverse);
+	var_print(writeback_rate_fp_term_low);
+	var_print(writeback_rate_fp_term_mid);
+	var_print(writeback_rate_fp_term_high);
 	var_print(writeback_rate_minimum);
 
 	if (attr == &sysfs_writeback_rate_debug) {
@@ -303,6 +311,7 @@ STORE(__cached_dev)
 	sysfs_strtoul_bool(bypass_torture_test, dc->bypass_torture_test);
 	sysfs_strtoul_bool(writeback_metadata, dc->writeback_metadata);
 	sysfs_strtoul_bool(writeback_running, dc->writeback_running);
+	sysfs_strtoul_bool(writeback_consider_fragment, dc->writeback_consider_fragment);
 	sysfs_strtoul_clamp(writeback_delay, dc->writeback_delay, 0, UINT_MAX);
 
 	sysfs_strtoul_clamp(writeback_percent, dc->writeback_percent,
@@ -331,6 +340,15 @@ STORE(__cached_dev)
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
@@ -499,9 +517,13 @@ static struct attribute *bch_cached_dev_files[] = {
 	&sysfs_writeback_delay,
 	&sysfs_writeback_percent,
 	&sysfs_writeback_rate,
+	&sysfs_writeback_consider_fragment,
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
index a129e4d2707c..9d440166c6bf 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -88,6 +88,44 @@ static void __update_writeback_rate(struct cached_dev *dc)
 	int64_t integral_scaled;
 	uint32_t new_rate;
 
+	/*
+	 * We need to consider the number of dirty buckets as well
+	 * when calculating the proportional_scaled, Otherwise we might
+	 * have an unreasonable small writeback rate at a highly fragmented situation
+	 * when very few dirty sectors consumed a lot dirty buckets, the
+	 * worst case is when dirty buckets reached cutoff_writeback_sync and
+	 * dirty data is still not even reached to writeback percent, so the rate
+	 * still will be at the minimum value, which will cause the write
+	 * stuck at a non-writeback mode.
+	 */
+	struct cache_set *c = dc->disk.c;
+
+	int64_t dirty_buckets = c->nbuckets - c->avail_nbuckets;
+
+	if (dc->writeback_consider_fragment &&
+		c->gc_stats.in_use > BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW && dirty > 0) {
+		int64_t fragment =
+			div_s64((dirty_buckets *  c->cache->sb.bucket_size), dirty);
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
+		fps = div_s64(dirty, dirty_buckets) * fp_term;
+		if (fragment > 3 && fps > proportional_scaled) {
+			//Only overrite the p when fragment > 3
+			proportional_scaled = fps;
+		}
+	}
+
 	if ((error < 0 && dc->writeback_rate_integral > 0) ||
 	    (error > 0 && time_before64(local_clock(),
 			 dc->writeback_rate.next + NSEC_PER_MSEC))) {
@@ -977,6 +1015,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
+	dc->writeback_consider_fragment = true;
 	dc->writeback_percent		= 10;
 	dc->writeback_delay		= 30;
 	atomic_long_set(&dc->writeback_rate.rate, 1024);
@@ -984,6 +1023,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 
 	dc->writeback_rate_update_seconds = WRITEBACK_RATE_UPDATE_SECS_DEFAULT;
 	dc->writeback_rate_p_term_inverse = 40;
+	dc->writeback_rate_fp_term_low = 1;
+	dc->writeback_rate_fp_term_mid = 10;
+	dc->writeback_rate_fp_term_high = 1000;
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

