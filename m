Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76825A5250
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Aug 2022 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiH2Qyn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Aug 2022 12:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbiH2Qyn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Aug 2022 12:54:43 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B368049A;
        Mon, 29 Aug 2022 09:54:41 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661792080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CnXACMqwrsahPQtZF6Nw6SFaAkd+ZYpPCEtMJwhlhk=;
        b=rGDSNKLSLtC+VhQc5IBuRFNEBE6Ho+qlZht32TKUiI1eTixW0JJpMvcqQChS82ekDISCfh
        hJYmIYjVrNcdvblg2dfpruQybA7GS5yJpfEG/AwXujBddJ2MrgtzppBSFLataG2EyLz8i2
        8yoOFhJVf1Wu3dZvVYXL2HtlFGD5xkM=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        colyli@suse.de
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] Code tagging based latency tracking
Date:   Mon, 29 Aug 2022 12:53:44 -0400
Message-Id: <20220829165344.2958640-4-kent.overstreet@linux.dev>
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

This adds the ability to easily instrument code for measuring latency.
To use, add the following to calls to your code, at the start and end of
the event you wish to measure:

  code_tag_time_stats_start(start_time);
  code_tag_time_stats_finish(start_time);

Stastistics will then show up in debugfs under
/sys/kernel/debug/time_stats, listed by file and line number.

Stastics measured include weighted averages of frequency, duration, max
duration, as well as quantiles.

This patch also instruments all calls to init_wait and finish_wait,
which includes all calls to wait_event. Example debugfs output:

fs/xfs/xfs_trans_ail.c:746 module:xfs func:xfs_ail_push_all_sync
count:          17
rate:           0/sec
frequency:      2 sec
avg duration:   10 us
max duration:   232 us
quantiles (ns): 128 128 128 128 128 128 128 128 128 128 128 128 128 128 128

lib/sbitmap.c:813 module:sbitmap func:sbitmap_finish_wait
count:          3
rate:           0/sec
frequency:      4 sec
avg duration:   4 sec
max duration:   4 sec
quantiles (ns): 0 4288669120 4288669120 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048 5360836048

net/core/datagram.c:122 module:datagram func:__skb_wait_for_more_packets
count:          10
rate:           1/sec
frequency:      859 ms
avg duration:   472 ms
max duration:   30 sec
quantiles (ns): 0 12279 12279 15669 15669 15669 15669 17217 17217 17217 17217 17217 17217 17217 17217

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/asm-generic/codetag.lds.h  |   3 +-
 include/linux/codetag_time_stats.h |  54 +++++++++++
 include/linux/wait.h               |  22 ++++-
 kernel/sched/wait.c                |   6 +-
 lib/Kconfig.debug                  |   8 ++
 lib/Makefile                       |   1 +
 lib/codetag_time_stats.c           | 143 +++++++++++++++++++++++++++++
 7 files changed, 232 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/codetag_time_stats.h
 create mode 100644 lib/codetag_time_stats.c

diff --git a/include/asm-generic/codetag.lds.h b/include/asm-generic/codetag.lds.h
index 16fbf74edc..d799f4aced 100644
--- a/include/asm-generic/codetag.lds.h
+++ b/include/asm-generic/codetag.lds.h
@@ -10,6 +10,7 @@
 
 #define CODETAG_SECTIONS()		\
 	SECTION_WITH_BOUNDARIES(alloc_tags)		\
-	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)
+	SECTION_WITH_BOUNDARIES(dynamic_fault_tags)	\
+	SECTION_WITH_BOUNDARIES(time_stats_tags)
 
 #endif /* __ASM_GENERIC_CODETAG_LDS_H */
diff --git a/include/linux/codetag_time_stats.h b/include/linux/codetag_time_stats.h
new file mode 100644
index 0000000000..7e44c7ee9e
--- /dev/null
+++ b/include/linux/codetag_time_stats.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CODETAG_TIMESTATS_H
+#define _LINUX_CODETAG_TIMESTATS_H
+
+/*
+ * Code tagging based latency tracking:
+ * (C) 2022 Kent Overstreet
+ *
+ * This allows you to easily instrument code to track latency, and have the
+ * results show up in debugfs. To use, add the following two calls to your code
+ * at the beginning and end of the event you wish to instrument:
+ *
+ * code_tag_time_stats_start(start_time);
+ * code_tag_time_stats_finish(start_time);
+ *
+ * Statistics will then show up in debugfs under /sys/kernel/debug/time_stats,
+ * listed by file and line number.
+ */
+
+#ifdef CONFIG_CODETAG_TIME_STATS
+
+#include <linux/codetag.h>
+#include <linux/time_stats.h>
+#include <linux/timekeeping.h>
+
+struct codetag_time_stats {
+	struct codetag		tag;
+	struct time_stats	stats;
+};
+
+#define codetag_time_stats_start(_start_time)	u64 _start_time = ktime_get_ns()
+
+#define codetag_time_stats_finish(_start_time)			\
+do {								\
+	static struct codetag_time_stats			\
+	__used							\
+	__section("time_stats_tags")				\
+	__aligned(8) s = {					\
+		.tag	= CODE_TAG_INIT,			\
+		.stats.lock = __SPIN_LOCK_UNLOCKED(_lock)	\
+	};							\
+								\
+	WARN_ONCE(!(_start_time), "codetag_time_stats_start() not called");\
+	time_stats_update(&s.stats, _start_time);		\
+} while (0)
+
+#else
+
+#define codetag_time_stats_finish(_start_time)	do {} while (0)
+#define codetag_time_stats_start(_start_time)	do {} while (0)
+
+#endif /* CODETAG_CODETAG_TIME_STATS */
+
+#endif
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 91ced6a118..bab11b7ef1 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -4,6 +4,7 @@
 /*
  * Linux wait queue related types and methods
  */
+#include <linux/codetag_time_stats.h>
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
@@ -32,6 +33,9 @@ struct wait_queue_entry {
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	entry;
+#ifdef CONFIG_CODETAG_TIME_STATS
+	u64			start_time;
+#endif
 };
 
 struct wait_queue_head {
@@ -79,10 +83,17 @@ extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *n
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
 #endif
 
+#ifdef CONFIG_CODETAG_TIME_STATS
+#define WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER	.start_time = ktime_get_ns(),
+#else
+#define WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER
+#endif
+
 #define WAIT_FUNC_INITIALIZER(name, function) {					\
 	.private	= current,						\
 	.func		= function,						\
 	.entry		= LIST_HEAD_INIT((name).entry),				\
+	WAIT_QUEUE_ENTRY_START_TIME_INITIALIZER					\
 }
 
 #define DEFINE_WAIT_FUNC(name, function)					\
@@ -98,6 +109,9 @@ __init_waitqueue_entry(struct wait_queue_entry *wq_entry, unsigned int flags,
 	wq_entry->private	= private;
 	wq_entry->func		= func;
 	INIT_LIST_HEAD(&wq_entry->entry);
+#ifdef CONFIG_CODETAG_TIME_STATS
+	wq_entry->start_time	= ktime_get_ns();
+#endif
 }
 
 #define init_waitqueue_func_entry(_wq_entry, _func)			\
@@ -1180,11 +1194,17 @@ do {										\
 void prepare_to_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 bool prepare_to_wait_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
 long prepare_to_wait_event(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry, int state);
-void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
+void __finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry);
 long wait_woken(struct wait_queue_entry *wq_entry, unsigned mode, long timeout);
 int woken_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key);
 
+#define finish_wait(_wq_head, _wq_entry)					\
+do {										\
+	codetag_time_stats_finish((_wq_entry)->start_time);			\
+	__finish_wait(_wq_head, _wq_entry);					\
+} while (0)
+
 typedef int (*task_call_f)(struct task_struct *p, void *arg);
 extern int task_call_func(struct task_struct *p, task_call_f func, void *arg);
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index b992234607..e88de3f0c3 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -367,7 +367,7 @@ int do_wait_intr_irq(wait_queue_head_t *wq, wait_queue_entry_t *wait)
 EXPORT_SYMBOL(do_wait_intr_irq);
 
 /**
- * finish_wait - clean up after waiting in a queue
+ * __finish_wait - clean up after waiting in a queue
  * @wq_head: waitqueue waited on
  * @wq_entry: wait descriptor
  *
@@ -375,7 +375,7 @@ EXPORT_SYMBOL(do_wait_intr_irq);
  * the wait descriptor from the given waitqueue if still
  * queued.
  */
-void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+void __finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
 {
 	unsigned long flags;
 
@@ -399,7 +399,7 @@ void finish_wait(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_en
 		spin_unlock_irqrestore(&wq_head->lock, flags);
 	}
 }
-EXPORT_SYMBOL(finish_wait);
+EXPORT_SYMBOL(__finish_wait);
 
 int autoremove_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int sync, void *key)
 {
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index bfb49505c9..40584fe54a 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1731,6 +1731,14 @@ config LATENCYTOP
 config TIME_STATS
 	bool
 
+config CODETAG_TIME_STATS
+	bool "Code tagging based latency measuring"
+	depends on DEBUG_FS
+	select TIME_STATS
+	select CODE_TAGGING
+	help
+	  Enabling this option makes latency statistics available in debugfs
+
 source "kernel/trace/Kconfig"
 
 config PROVIDE_OHCI1394_DMA_INIT
diff --git a/lib/Makefile b/lib/Makefile
index e09255c881..7888bc8baa 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -233,6 +233,7 @@ obj-$(CONFIG_PAGE_ALLOC_TAGGING) += pgalloc_tag.o
 
 obj-$(CONFIG_CODETAG_FAULT_INJECTION) += dynamic_fault.o
 obj-$(CONFIG_TIME_STATS) += time_stats.o
+obj-$(CONFIG_CODETAG_TIME_STATS) += codetag_time_stats.o
 
 lib-$(CONFIG_GENERIC_BUG) += bug.o
 
diff --git a/lib/codetag_time_stats.c b/lib/codetag_time_stats.c
new file mode 100644
index 0000000000..67f248906d
--- /dev/null
+++ b/lib/codetag_time_stats.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/codetag_time_stats.h>
+#include <linux/ctype.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/seq_buf.h>
+
+static struct codetag_type *cttype;
+
+struct user_buf {
+	char __user		*buf;	/* destination user buffer */
+	size_t			size;	/* size of requested read */
+	ssize_t			ret;	/* bytes read so far */
+};
+
+static int flush_ubuf(struct user_buf *dst, struct seq_buf *src)
+{
+	if (src->len) {
+		size_t bytes = min_t(size_t, src->len, dst->size);
+		int err = copy_to_user(dst->buf, src->buffer, bytes);
+
+		if (err)
+			return err;
+
+		dst->ret	+= bytes;
+		dst->buf	+= bytes;
+		dst->size	-= bytes;
+		src->len	-= bytes;
+		memmove(src->buffer, src->buffer + bytes, src->len);
+	}
+
+	return 0;
+}
+
+struct time_stats_iter {
+	struct codetag_iterator ct_iter;
+	struct seq_buf		buf;
+	char			rawbuf[4096];
+	bool			first;
+};
+
+static int time_stats_open(struct inode *inode, struct file *file)
+{
+	struct time_stats_iter *iter;
+
+	pr_debug("called");
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	codetag_lock_module_list(cttype, true);
+	iter->ct_iter = codetag_get_ct_iter(cttype);
+	codetag_lock_module_list(cttype, false);
+
+	file->private_data = iter;
+	seq_buf_init(&iter->buf, iter->rawbuf, sizeof(iter->rawbuf));
+	iter->first = true;
+	return 0;
+}
+
+static int time_stats_release(struct inode *inode, struct file *file)
+{
+	struct time_stats_iter *i = file->private_data;
+
+	kfree(i);
+	return 0;
+}
+
+static ssize_t time_stats_read(struct file *file, char __user *ubuf,
+			       size_t size, loff_t *ppos)
+{
+	struct time_stats_iter *iter = file->private_data;
+	struct user_buf	buf = { .buf = ubuf, .size = size };
+	struct codetag_time_stats *s;
+	struct codetag *ct;
+	int err;
+
+	codetag_lock_module_list(iter->ct_iter.cttype, true);
+	while (1) {
+		err = flush_ubuf(&buf, &iter->buf);
+		if (err || !buf.size)
+			break;
+
+		ct = codetag_next_ct(&iter->ct_iter);
+		if (!ct)
+			break;
+
+		s = container_of(ct, struct codetag_time_stats, tag);
+		if (s->stats.count) {
+			if (!iter->first) {
+				seq_buf_putc(&iter->buf, '\n');
+				iter->first = true;
+			}
+
+			codetag_to_text(&iter->buf, &s->tag);
+			seq_buf_putc(&iter->buf, '\n');
+			time_stats_to_text(&iter->buf, &s->stats);
+		}
+	}
+	codetag_lock_module_list(iter->ct_iter.cttype, false);
+
+	return err ?: buf.ret;
+}
+
+static const struct file_operations time_stats_ops = {
+	.owner	= THIS_MODULE,
+	.open	= time_stats_open,
+	.release = time_stats_release,
+	.read	= time_stats_read,
+};
+
+static void time_stats_module_unload(struct codetag_type *cttype, struct codetag_module *mod)
+{
+	struct codetag_time_stats *i, *start = (void *) mod->range.start;
+	struct codetag_time_stats *end = (void *) mod->range.stop;
+
+	for (i = start; i != end; i++)
+		time_stats_exit(&i->stats);
+}
+
+static int __init codetag_time_stats_init(void)
+{
+	const struct codetag_type_desc desc = {
+		.section	= "time_stats_tags",
+		.tag_size	= sizeof(struct codetag_time_stats),
+		.module_unload	= time_stats_module_unload,
+	};
+	struct dentry *debugfs_file;
+
+	cttype = codetag_register_type(&desc);
+	if (IS_ERR_OR_NULL(cttype))
+		return PTR_ERR(cttype);
+
+	debugfs_file = debugfs_create_file("time_stats", 0666, NULL, NULL, &time_stats_ops);
+	if (IS_ERR(debugfs_file))
+		return PTR_ERR(debugfs_file);
+
+	return 0;
+}
+module_init(codetag_time_stats_init);
-- 
2.36.1

