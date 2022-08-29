Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748015A524A
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Aug 2022 18:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiH2Qym (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Aug 2022 12:54:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiH2Qyl (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2022 12:54:41 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7FA8049A;
        Mon, 29 Aug 2022 09:54:39 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661792078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67vapAY7w9YlX1W79UJiRT6iD5XaVfGQC61VKlOBZDA=;
        b=ptn9xrRpVzBMm9KH/MujXf7I1j3yxk+BjPYZKwQa7788wrqBjyh/iS3rjD1woiA5sDstr4
        pMlQPsmGjn3tP1R3wi3sd2s8tzIT4f+Rthva+ZYgxKXbzy0MDKT5bZ/eL9cFUIwnxJyPhv
        eUW8UgLWo1X6z/5UkHfckpPw0v4Q0Y4=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        colyli@suse.de
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] lib/time_stats: New library for statistics on events
Date:   Mon, 29 Aug 2022 12:53:42 -0400
Message-Id: <20220829165344.2958640-2-kent.overstreet@linux.dev>
In-Reply-To: <20220829165344.2958640-1-kent.overstreet@linux.dev>
References: <20220829165344.2958640-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This adds a small new library for tracking statistics on events that
have a duration, i.e. a start and end time.

 - number of events
 - rate/frequency
 - average duration
 - max duration
 - duration quantiles

This code comes from bcachefs, and originally bcache: the next patch
will be converting bcache to use this version, and a subsequent patch
will be using code_tagging to instrument all wait_event() calls in the
kernel.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/time_stats.h |  44 +++++++
 lib/Kconfig.debug          |   3 +
 lib/Makefile               |   1 +
 lib/time_stats.c           | 236 +++++++++++++++++++++++++++++++++++++
 4 files changed, 284 insertions(+)
 create mode 100644 include/linux/time_stats.h
 create mode 100644 lib/time_stats.c

diff --git a/include/linux/time_stats.h b/include/linux/time_stats.h
new file mode 100644
index 0000000000..7ae929e6f8
--- /dev/null
+++ b/include/linux/time_stats.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _LINUX_TIMESTATS_H
+#define _LINUX_TIMESTATS_H
+
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+
+#define NR_QUANTILES	15
+
+struct quantiles {
+	struct quantile_entry {
+		u64	m;
+		u64	step;
+	}		entries[NR_QUANTILES];
+};
+
+struct time_stat_buffer {
+	unsigned int	nr;
+	struct time_stat_buffer_entry {
+		u64	start;
+		u64	end;
+	}		entries[32];
+};
+
+struct time_stats {
+	spinlock_t	lock;
+	u64		count;
+	/* all fields are in nanoseconds */
+	u64		average_duration;
+	u64		average_frequency;
+	u64		max_duration;
+	u64		last_event;
+	struct quantiles quantiles;
+
+	struct time_stat_buffer __percpu *buffer;
+};
+
+struct seq_buf;
+void time_stats_update(struct time_stats *stats, u64 start);
+void time_stats_to_text(struct seq_buf *out, struct time_stats *stats);
+void time_stats_exit(struct time_stats *stats);
+
+#endif /* _LINUX_TIMESTATS_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bbe3ef939c..bfb49505c9 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1728,6 +1728,9 @@ config LATENCYTOP
 	  Enable this option if you want to use the LatencyTOP tool
 	  to find out which userspace is blocking on what kernel operations.
 
+config TIME_STATS
+	bool
+
 source "kernel/trace/Kconfig"
 
 config PROVIDE_OHCI1394_DMA_INIT
diff --git a/lib/Makefile b/lib/Makefile
index c69430213e..e09255c881 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -232,6 +232,7 @@ obj-$(CONFIG_ALLOC_TAGGING) += alloc_tag.o
 obj-$(CONFIG_PAGE_ALLOC_TAGGING) += pgalloc_tag.o
 
 obj-$(CONFIG_CODETAG_FAULT_INJECTION) += dynamic_fault.o
+obj-$(CONFIG_TIME_STATS) += time_stats.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/time_stats.c b/lib/time_stats.c
new file mode 100644
index 0000000000..30362364fd
--- /dev/null
+++ b/lib/time_stats.c
@@ -0,0 +1,236 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/ktime.h>
+#include <linux/percpu.h>
+#include <linux/seq_buf.h>
+#include <linux/spinlock.h>
+#include <linux/time_stats.h>
+#include <linux/timekeeping.h>
+
+static inline unsigned int eytzinger1_child(unsigned int i, unsigned int child)
+{
+	return (i << 1) + child;
+}
+
+static inline unsigned int eytzinger1_right_child(unsigned int i)
+{
+	return eytzinger1_child(i, 1);
+}
+
+static inline unsigned int eytzinger1_next(unsigned int i, unsigned int size)
+{
+	if (eytzinger1_right_child(i) <= size) {
+		i = eytzinger1_right_child(i);
+
+		i <<= __fls(size + 1) - __fls(i);
+		i >>= i > size;
+	} else {
+		i >>= ffz(i) + 1;
+	}
+
+	return i;
+}
+
+static inline unsigned int eytzinger0_child(unsigned int i, unsigned int child)
+{
+	return (i << 1) + 1 + child;
+}
+
+static inline unsigned int eytzinger0_first(unsigned int size)
+{
+	return rounddown_pow_of_two(size) - 1;
+}
+
+static inline unsigned int eytzinger0_next(unsigned int i, unsigned int size)
+{
+	return eytzinger1_next(i + 1, size) - 1;
+}
+
+#define eytzinger0_for_each(_i, _size)			\
+	for ((_i) = eytzinger0_first((_size));		\
+	     (_i) != -1;				\
+	     (_i) = eytzinger0_next((_i), (_size)))
+
+#define ewma_add(ewma, val, weight)					\
+({									\
+	typeof(ewma) _ewma = (ewma);					\
+	typeof(weight) _weight = (weight);				\
+									\
+	(((_ewma << _weight) - _ewma) + (val)) >> _weight;		\
+})
+
+static void quantiles_update(struct quantiles *q, u64 v)
+{
+	unsigned int i = 0;
+
+	while (i < ARRAY_SIZE(q->entries)) {
+		struct quantile_entry *e = q->entries + i;
+
+		if (unlikely(!e->step)) {
+			e->m = v;
+			e->step = max_t(unsigned int, v / 2, 1024);
+		} else if (e->m > v) {
+			e->m = e->m >= e->step
+				? e->m - e->step
+				: 0;
+		} else if (e->m < v) {
+			e->m = e->m + e->step > e->m
+				? e->m + e->step
+				: U32_MAX;
+		}
+
+		if ((e->m > v ? e->m - v : v - e->m) < e->step)
+			e->step = max_t(unsigned int, e->step / 2, 1);
+
+		if (v >= e->m)
+			break;
+
+		i = eytzinger0_child(i, v > e->m);
+	}
+}
+
+static void time_stats_update_one(struct time_stats *stats,
+				  u64 start, u64 end)
+{
+	u64 duration, freq;
+
+	duration	= time_after64(end, start)
+		? end - start : 0;
+	freq		= time_after64(end, stats->last_event)
+		? end - stats->last_event : 0;
+
+	stats->count++;
+
+	stats->average_duration = stats->average_duration
+		? ewma_add(stats->average_duration, duration, 6)
+		: duration;
+
+	stats->average_frequency = stats->average_frequency
+		? ewma_add(stats->average_frequency, freq, 6)
+		: freq;
+
+	stats->max_duration = max(stats->max_duration, duration);
+
+	stats->last_event = end;
+
+	quantiles_update(&stats->quantiles, duration);
+}
+
+void time_stats_update(struct time_stats *stats, u64 start)
+{
+	u64 end = ktime_get_ns();
+	unsigned long flags;
+
+	if (!stats->buffer) {
+		spin_lock_irqsave(&stats->lock, flags);
+		time_stats_update_one(stats, start, end);
+
+		if (stats->average_frequency < 32 &&
+		    stats->count > 1024)
+			stats->buffer =
+				alloc_percpu_gfp(struct time_stat_buffer,
+						 GFP_ATOMIC);
+		spin_unlock_irqrestore(&stats->lock, flags);
+	} else {
+		struct time_stat_buffer_entry *i;
+		struct time_stat_buffer *b;
+
+		preempt_disable();
+		b = this_cpu_ptr(stats->buffer);
+
+		BUG_ON(b->nr >= ARRAY_SIZE(b->entries));
+		b->entries[b->nr++] = (struct time_stat_buffer_entry) {
+			.start = start,
+			.end = end
+		};
+
+		if (b->nr == ARRAY_SIZE(b->entries)) {
+			spin_lock_irqsave(&stats->lock, flags);
+			for (i = b->entries;
+			     i < b->entries + ARRAY_SIZE(b->entries);
+			     i++)
+				time_stats_update_one(stats, i->start, i->end);
+			spin_unlock_irqrestore(&stats->lock, flags);
+
+			b->nr = 0;
+		}
+
+		preempt_enable();
+	}
+}
+EXPORT_SYMBOL(time_stats_update);
+
+static const struct time_unit {
+	const char	*name;
+	u32		nsecs;
+} time_units[] = {
+	{ "ns",		1		},
+	{ "us",		NSEC_PER_USEC	},
+	{ "ms",		NSEC_PER_MSEC	},
+	{ "sec",	NSEC_PER_SEC	},
+};
+
+static const struct time_unit *pick_time_units(u64 ns)
+{
+	const struct time_unit *u;
+
+	for (u = time_units;
+	     u + 1 < time_units + ARRAY_SIZE(time_units) &&
+	     ns >= u[1].nsecs << 1;
+	     u++)
+		;
+
+	return u;
+}
+
+static void pr_time_units(struct seq_buf *out, u64 ns)
+{
+	const struct time_unit *u = pick_time_units(ns);
+
+	seq_buf_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+}
+
+void time_stats_to_text(struct seq_buf *out, struct time_stats *stats)
+{
+	const struct time_unit *u;
+	u64 freq = READ_ONCE(stats->average_frequency);
+	u64 q, last_q = 0;
+	int i;
+
+	seq_buf_printf(out, "count:          %llu\n", stats->count);
+	seq_buf_printf(out, "rate:           %llu/sec\n",
+		       freq ? div64_u64(NSEC_PER_SEC, freq) : 0);
+	seq_buf_printf(out, "frequency:      ");
+	pr_time_units(out, freq);
+	seq_buf_putc(out, '\n');
+
+	seq_buf_printf(out, "avg duration:   ");
+	pr_time_units(out, stats->average_duration);
+	seq_buf_putc(out, '\n');
+
+	seq_buf_printf(out, "max duration:   ");
+	pr_time_units(out, stats->max_duration);
+	seq_buf_putc(out, '\n');
+
+	i = eytzinger0_first(NR_QUANTILES);
+	u = pick_time_units(stats->quantiles.entries[i].m);
+	seq_buf_printf(out, "quantiles (%s): ", u->name);
+	eytzinger0_for_each(i, NR_QUANTILES) {
+		q = max(stats->quantiles.entries[i].m, last_q);
+		seq_buf_printf(out, "%llu ", div_u64(q, u->nsecs));
+		last_q = q;
+	}
+
+	seq_buf_putc(out, '\n');
+}
+EXPORT_SYMBOL_GPL(time_stats_to_text);
+
+void time_stats_exit(struct time_stats *stats)
+{
+	free_percpu(stats->buffer);
+	stats->buffer = NULL;
+}
+EXPORT_SYMBOL_GPL(time_stats_exit);
-- 
2.36.1

