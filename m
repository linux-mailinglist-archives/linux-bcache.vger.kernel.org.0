Return-Path: <linux-bcache+bounces-1159-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF0EB16C05
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Jul 2025 08:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C3737A6F8A
	for <lists+linux-bcache@lfdr.de>; Thu, 31 Jul 2025 06:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418D5242D63;
	Thu, 31 Jul 2025 06:24:54 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583F813D52F;
	Thu, 31 Jul 2025 06:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753943094; cv=none; b=WbnKe4R/AKnNF3tyzS1+Kx0G/CeGg31nk26uEMOEnGbXI6qhD5leaGe8RcrFb9ej6EVIAQ5p0I3sovaIMZzInAXjRh6eOPvlTMF2jATj2CDi0WmxGApK3PCS9B7+2+F0LA1kHE/bU0MrfFA2Ng4G5Lfgge7gRLx4e+ibGgYIc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753943094; c=relaxed/simple;
	bh=UHIE2hV4H1yOWsFA+BEhBXO6pedOCRomTj6ja66zFqY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Txfwbr0E5nxfneqa5ynSDB0rFNprV2JpQbOfh2h6AzthfLwrgEG+hF06ly7HThARCM8oQRrZeSpNDQCCkVkx10Pi7Pfn0LhJvMPWyIhHic+/tjn8WzTmCANKXthbPB8HUZaTdFN2DfQilnVa0AYdQ8ZoG/fpxG2zoiCTPOc7LsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: esmtpgz12t1753943034t3c3a2e00
X-QQ-Originating-IP: UcPVV1a86dYb5cYfYYjIA5WM8jeFfSBnkoRINRNt6TA=
Received: from localhost.localdomain ( [175.0.77.94])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 31 Jul 2025 14:21:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15998577648878152325
EX-QQ-RecipientCnt: 5
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@kernel.org,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: [PATCH] bcache: enhancing the security of dirty data writeback
Date: Thu, 31 Jul 2025 14:21:40 +0800
Message-Id: <20250731062140.25734-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MDGUoPnBmw7sNeuEzkSWDcZrpD9BEcuEGuAYip8r8h4c9awj1jeJG8SC
	h49YPFm4QBazi2fqX8mAYOext7Le/ZSKMhnphVl5NMNk6F5iOPrLBHEpucHV70zm8j4dPZM
	h4mlPf8KOOonlZ9wc4CUYfBamjTa3cyXOr5N/CloBpRUNnm0cfqTgeTTWq1F1J1YPKcozrV
	SdRmTZmrojhkcPd4r+QdSW06E8UI5Yx5KanuGToTmTkBA55WhYTe/kDISVgtRVLligVotD5
	izokcaHBXgpiOxgOhp1tjRTPXx6QElqjUxkajue1PLzEcqPyfRMDmsSVT52Hr7AqpMgM+mG
	rEPp8oj/oVLIXVbBSQBGu9Qu1pZvXH0GRtmYXalBx3pHrO9fxlmguCWC8uIlA7uVgEPQSyL
	kmgwkOe5z+XoxxQWoyJy7mQJUuWvjwVC9k4ReCcsxJHBuHngYimaRARIi1qXTG/4U9k7Ij8
	J+YSBHvwKnk0c4jyLLsckbV6dz3h2u8rsG+xaC0Y/sS1B5qPAEgp0ALxCKzLY4ZZf7QNNQb
	OpI7sp0QPvN1zQjYwdoxIGesoqix3KbjpQB8UCp6KfOlTcQ9pm0FrCJqy/qyPC6Z5IK2axr
	UlQx8uaV5Dqj2ygawB1k91LlFqUuzxfIfBeoAi1ExfNsavN/e0z58Ru0In1yBXyqiybMrVw
	Riq7KkjUQSUHrxhRWV9WwNklJmndKMCyue8wb8yKD7XQpkKLj06vcWwhs3Tu1SvMhDG/sUb
	88uk7iuQSeF7rperc9eTm3MjQysGovhfCRXJKq24NPEwvMbmqtZLc9JeNXFc/lL93hqfyIy
	ojnNxGw2lg1yWKUHvC7PnpZWp6E36V6P3fR5CSJgY3BtQ80iS9p6aNQ7Cn9N2ZRto7nGmv8
	rtOUZu83dEnE2oPN1o62PBwd7J14uH2s33LhBZY81T02Ulksd8hRnLFA1S1pIbNpRseZF8n
	GHakygxSfye4Dcq13bnYHce12LTLTOMBTg08xM3LGVsG8h0sPrFtSxZMwi8v4fIe/queIHu
	ENJRW1wQ4+BnnxL5z0
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

There is a potential data consistency risk in bcache's writeback mode:when
the application calls fsync, bcache returns success after completing the
log write, persisting the cache disk data, and persisting the HDD internal
cache. However, at this point, the actual application data may still be in
a dirty state and remain stuck in the cache disk. when these data are
subsequently written back to the HDD asynchronously through REQ_OP_WRITE,
there is no forced refresh mechanism to ensure physical placement on the
disk, and there may be no power-off protection measures, which poses a risk
of data loss. This mechanism may cause the application to misjudge that the
data has been persisted, which is different from the actual storage state,
and also violates the semantic agreement that fsync should ensure data
persistence.

This patch aims to enhance the reliability of dirty data writeback through
PREFLUSH, ensuring that the dirty data mark in the cache device is cleared
only after the dirty data is written to the disk. the main features
include:
1. Dynamic function switch: Control the function on/off through the
/sys/block/bcache0/bcache/writeback_flush parameter, the default value is
off
2. Double triggering conditions for PREFLUSH:
When the cumulative number of dirty bkeys written back reaches the
threshold(Dynamic control parameters:
/sys/block/bcache0/bcache/flush_interval, the default value is 20000. by
increasing the value of this parameter, the impact of flush on performance
can be reduced.)
Or when the interval since the last refresh exceeds 30 seconds
If any of the conditions are met, the system will send a PREFLUSH command
to the backend HDD, and clear the corresponding dirty bkey mark only after
confirming that the PREFLUSH is executed successfully.

Two tests were conducted:

1. Comparison test of writeback efficiency:
Group A: Use native Linux kernel source code driver, and use default values
for other system parameters.
Group B: Use this patch based on native Linux kernel source code, and
configure system /sys/block/bcache0/bcache/writeback_flush to "on", and use
default values for other parameters.
Test script:
https://github.com/jifengzhou/file/blob/main/writebackflush-test.sh
The execution process of this test script is as follows:
Preparation phase: Continue 4KB random write operation for 10 minutes
Initial record: At the end of the data preparation phase, immediately
record the current time and the dirty_data value of bcache
Monitoring phase: Continuously poll and detect the dirty_data value, and
record the completion time when the value drops to 0
Calculation index: According to the initial/end time difference and the
initial dirty_data value, calculate the average writeback speed (formula:
initial dirty_data value/time consumption)
Test results:
Group A test data
Initial record: Started writing dirty data at 2025-07-23 09:05:47, the
dirty_data value was 133.8GB
Monitoring stage: Completed writing dirty data at 2025-07-23 17:31:45,
the dirty_data value was 0
Total duration: 8 hours 25 minutes 58 seconds
Average write rate: 4.51MB/s
Group B test data
Initial record: Started writing dirty data at 2025-07-22 20:00:09, the
dirty_data value was 131.2GB
Monitoring stage: Completed writing dirty data at 2025-07-23 04:32:33, the
dirty_data value was 0
Initial dirty_data value: 131.2GB
Total duration: 8 hours 32 minutes 24 seconds
Average write rate: 4.37MB/s
Monitoring data comparison
HDD iostat monitoring data curve comparison chart:
https://github.com/jifengzhou/file/blob/main/HDD%20iostat%20data%20for%20
test%20scenario%201.xlsx (covers the full cycle data from the initial
record stage to the end of the monitoring stage)
This test summary: In the average 8.5-hour dirty data write speed test,
after using this patch, the dirty data write speed was approximately 96.9%
of that before the patch.

2. Performance comparison test
Group C: Use the native Linux kernel source code driver, and use the
default values for other system parameters.
Group D: Use this patch based on the native Linux kernel source code, and
configure the system /sys/block/bcache0/bcache/writeback_flush to "on", and
use the default values for other parameters.
Test plan:
Test tool: Use vdbench storage performance test tool
Load type: Use 4KB random write mode
Duration: Continuously perform 48 hours of stress test
Configuration file path:
https://github.com/jifengzhou/file/blob/main/block.conf
Execute command: vdbench -f block.conf
Test results:
Comparison curve graph of vdbench test output data for groups C and D:
https://github.com/jifengzhou/file/blob/main/48-hour%204K%20Random%20Write
.xlsx
This test summary：
During the 48-hour long test, the average IOPS of Group C was 942.5, while
the average speed of Group D was 937.1. The difference between the two was
very small.Group C completed its first GC around 14 hours, while Group D
completed it at 14.5 hours,and the difference between the two was also
relatively small.

From the above two results, it can be seen that this patch significantly
enhances data reliability while having a relatively minor impact on
performance. Moreover, the impact on performance and write efficiency can
be further reduced by dynamically adjusting the value of "/sys/block/
bcache0/bcache/flush_interval".

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
 drivers/md/bcache/bcache.h        |  23 ++++
 drivers/md/bcache/bcache_ondisk.h |   4 +
 drivers/md/bcache/sysfs.c         |  47 ++++++++
 drivers/md/bcache/writeback.c     | 174 +++++++++++++++++++++++++++---
 drivers/md/bcache/writeback.h     |   4 +
 5 files changed, 239 insertions(+), 13 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..09424938437b 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -247,6 +247,17 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
+struct keybuf_preflush {
+	spinlock_t	lock;
+	struct list_head list;
+	u32 count;
+};
+
+struct flush_key_entry {
+	struct keybuf_key key;
+	struct list_head list;
+};
+
 struct bcache_device {
 	struct closure		cl;
 
@@ -346,6 +357,18 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	/*
+	 * Before performing preflush to the backing device, temporarily
+	 * store the bkey waiting to clean up the dirty mark
+	 */
+	struct keybuf_preflush  preflush_keys;
+	/*
+	 * flush_interval is used to specify that a PROFLUSH operation will
+	 * be issued once a certain number of dirty bkeys have been written
+	 * each time.
+	 */
+	unsigned int flush_interval;
+
 	struct task_struct	*status_update_thread;
 	/*
 	 * Order the write-half of writeback operations strongly in dispatch
diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 6620a7f8fffc..df5800838e40 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -294,6 +294,10 @@ BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
 #define CACHE_MODE_WRITEBACK		1U
 #define CACHE_MODE_WRITEAROUND		2U
 #define CACHE_MODE_NONE			3U
+BITMASK(BDEV_WRITEBACK_FLUSH,		struct cache_sb, flags, 4, 1);
+#define WRITEBACK_FLUSH_OFF		0U
+#define WRITEBACK_FLUSH_ON		1U
+
 BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
 #define BDEV_STATE_NONE			0U
 #define BDEV_STATE_CLEAN		1U
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e8f696cb58c0..cc228e592ab6 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -28,6 +28,18 @@ static const char * const bch_cache_modes[] = {
 	NULL
 };
 
+/*
+ * Default is 0 ("off")
+ * off: Do nothing
+ * on: Use FLUSH when writing back dirty data.
+ */
+static const char * const bch_writeback_flush[] = {
+	"off",
+	"on",
+	NULL
+};
+
+
 static const char * const bch_reada_cache_policies[] = {
 	"all",
 	"meta-only",
@@ -151,6 +163,19 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+/*
+ * The "writeback_flush" has two options: "off" and "on". "off" is
+ * the default value.
+ * off: Do nothing
+ * on: Use FLUSH when writing back dirty data.
+ */
+rw_attribute(writeback_flush);
+/*
+ * "flush_interval" is used to specify that a PROFLUSH operation will
+ * be issued once a certain number of dirty bkeys have been written
+ * each time.
+ */
+rw_attribute(flush_interval);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -213,6 +238,7 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_rate_fp_term_mid);
 	var_print(writeback_rate_fp_term_high);
 	var_print(writeback_rate_minimum);
+	var_print(flush_interval);
 
 	if (attr == &sysfs_writeback_rate_debug) {
 		char rate[20];
@@ -283,6 +309,11 @@ SHOW(__bch_cached_dev)
 		return strlen(buf);
 	}
 
+	if (attr == &sysfs_writeback_flush)
+		return bch_snprint_string_list(buf, PAGE_SIZE,
+					       bch_writeback_flush,
+					       BDEV_WRITEBACK_FLUSH(&dc->sb));
+
 #undef var
 	return 0;
 }
@@ -354,6 +385,9 @@ STORE(__cached_dev)
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
 
+	sysfs_strtoul_clamp(flush_interval, dc->flush_interval,
+			    WRITEBACK_FLUSH_INTERVAL_MIN, WRITEBACK_FLUSH_INTERVAL_MAX);
+
 	if (attr == &sysfs_io_disable) {
 		int v = strtoul_or_return(buf);
 
@@ -451,6 +485,17 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
+	if (attr == &sysfs_writeback_flush) {
+		v = __sysfs_match_string(bch_writeback_flush, -1, buf);
+		if (v < 0)
+			return v;
+
+		if ((unsigned int) v != BDEV_WRITEBACK_FLUSH(&dc->sb)) {
+			SET_BDEV_WRITEBACK_FLUSH(&dc->sb, v);
+			bch_write_bdev_super(dc, NULL);
+		}
+	}
+
 	return size;
 }
 
@@ -541,6 +586,8 @@ static struct attribute *bch_cached_dev_attrs[] = {
 #endif
 	&sysfs_backing_dev_name,
 	&sysfs_backing_dev_uuid,
+	&sysfs_writeback_flush,
+	&sysfs_flush_interval,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cached_dev);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 453efbbdc8ee..530eea2b953a 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -348,8 +348,121 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
 	kfree(io);
 }
 
+static int bcache_add_preflush_key(struct cached_dev *dc, struct keybuf_key *key)
+{
+	struct flush_key_entry *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+
+	if (!entry) {
+		pr_info("the preflush bkey memory allocation failed.\n");
+		return -ENOMEM;
+	}
+
+	memcpy(&entry->key, key, sizeof(*key));
+	INIT_LIST_HEAD(&entry->list);
+
+	spin_lock(&dc->preflush_keys.lock);
+	list_add_tail(&entry->list, &dc->preflush_keys.list);
+	dc->preflush_keys.count++;
+	spin_unlock(&dc->preflush_keys.lock);
+
+	return 0;
+}
+
+static void bcache_mark_preflush_keys_clean(struct cached_dev *dc)
+{
+	struct flush_key_entry *e, *tmp;
+
+	list_for_each_entry_safe(e, tmp, &dc->preflush_keys.list, list) {
+		list_del(&e->list);
+		kfree(e);
+	}
+	dc->preflush_keys.count = 0;
+}
+
+static void launch_async_preflush_endio(struct bio *bio)
+{
+	if (bio->bi_status)
+		pr_err("flush backing device error %d.\n", bio->bi_status);
+}
+
+
+static inline void launch_async_preflush_request(struct cached_dev *dc)
+{
+	struct bio flush;
+
+	bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+
+	flush.bi_private = dc;
+	flush.bi_end_io = launch_async_preflush_endio;
+
+	submit_bio(&flush);
+}
+
+
+static void flush_backing_device(struct cached_dev *dc)
+{
+	int ret;
+	unsigned int i;
+	struct keylist keys;
+	struct flush_key_entry *e, *tmp;
+	struct bio flush;
+
+	if (dc->preflush_keys.count == 0)
+		return;
+
+	bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+	ret = submit_bio_wait(&flush);
+	if (ret) {
+		pr_err("flush backing device error %d.\n", ret);
+
+		/*
+		 * In the case of flush failure, do not update the status of bkey
+		 * in the btree, and wait until the next time to re-write the dirty
+		 * data.
+		 */
+		bcache_mark_preflush_keys_clean(dc);
+		return;
+	}
+
+	/*
+	 * The dirty data was successfully written back and confirmed to be written
+	 * to the disk. The status of the bkey in the btree was updated.
+	 */
+	list_for_each_entry_safe(e, tmp, &dc->preflush_keys.list, list) {
+		memset(keys.inline_keys, 0, sizeof(keys.inline_keys));
+		bch_keylist_init(&keys);
+
+		bkey_copy(keys.top, &(e->key.key));
+		SET_KEY_DIRTY(keys.top, false);
+		bch_keylist_push(&keys);
+
+		for (i = 0; i < KEY_PTRS(&(e->key.key)); i++)
+			atomic_inc(&PTR_BUCKET(dc->disk.c, &(e->key.key), i)->pin);
+
+		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &(e->key.key));
+
+		if (ret)
+			trace_bcache_writeback_collision(&(e->key.key));
+
+		atomic_long_inc(ret
+				? &dc->disk.c->writeback_keys_failed
+				: &dc->disk.c->writeback_keys_done);
+
+		list_del(&e->list);
+		kfree(e);
+
+		/* For those bkeys that failed to be inserted, you can
+		 * ignore them and they will be processed again in the
+		 * next write-back scan.
+		 */
+	}
+
+	dc->preflush_keys.count = 0;
+}
+
 static CLOSURE_CALLBACK(write_dirty_finish)
 {
+	int ret;
 	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
@@ -358,27 +471,41 @@ static CLOSURE_CALLBACK(write_dirty_finish)
 
 	/* This is kind of a dumb way of signalling errors. */
 	if (KEY_DIRTY(&w->key)) {
-		int ret;
 		unsigned int i;
 		struct keylist keys;
 
-		bch_keylist_init(&keys);
+		if (!BDEV_WRITEBACK_FLUSH(&dc->sb)) {
+update_bkey:
+			bch_keylist_init(&keys);
 
-		bkey_copy(keys.top, &w->key);
-		SET_KEY_DIRTY(keys.top, false);
-		bch_keylist_push(&keys);
+			bkey_copy(keys.top, &w->key);
+			SET_KEY_DIRTY(keys.top, false);
+			bch_keylist_push(&keys);
 
-		for (i = 0; i < KEY_PTRS(&w->key); i++)
-			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
+			for (i = 0; i < KEY_PTRS(&w->key); i++)
+				atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
 
-		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
+			ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
 
-		if (ret)
-			trace_bcache_writeback_collision(&w->key);
+			if (ret)
+				trace_bcache_writeback_collision(&w->key);
 
-		atomic_long_inc(ret
-				? &dc->disk.c->writeback_keys_failed
-				: &dc->disk.c->writeback_keys_done);
+			atomic_long_inc(ret
+					? &dc->disk.c->writeback_keys_failed
+					: &dc->disk.c->writeback_keys_done);
+		} else {
+			/* After flushing the backing device, update the btree */
+			ret = bcache_add_preflush_key(dc, w);
+
+			/*
+			 * When memory allocation fails, immediately send PREFLUSH
+			 * and then update the btree.
+			 */
+			if (ret) {
+				launch_async_preflush_request(dc);
+				goto update_bkey;
+			}
+		}
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
@@ -435,6 +562,7 @@ static CLOSURE_CALLBACK(write_dirty)
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
 		io->bio.bi_opf = REQ_OP_WRITE;
+
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
@@ -741,6 +869,7 @@ static int bch_writeback_thread(void *arg)
 	struct cached_dev *dc = arg;
 	struct cache_set *c = dc->disk.c;
 	bool searched_full_index;
+	unsigned long last_flush_jiffies = jiffies;
 
 	bch_ratelimit_reset(&dc->writeback_rate);
 
@@ -819,9 +948,23 @@ static int bch_writeback_thread(void *arg)
 
 		read_dirty(dc);
 
+		/*
+		 * If the accumulated preflush_keys exceed a certain quantity or
+		 * the interval time exceeds 30 seconds, issue the PREFLUSH command
+		 * once.
+		 */
+		if (dc->preflush_keys.count >= dc->flush_interval ||
+		    time_after(jiffies, last_flush_jiffies + 30 * HZ)) {
+			flush_backing_device(dc);
+			last_flush_jiffies = jiffies;
+		}
+
 		if (searched_full_index) {
 			unsigned int delay = dc->writeback_delay * HZ;
 
+			/* Clean up the remaining preflush_keys. */
+			flush_backing_device(dc);
+
 			while (delay &&
 			       !kthread_should_stop() &&
 			       !test_bit(CACHE_SET_IO_DISABLE, &c->flags) &&
@@ -1068,10 +1211,15 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_mid = 10;
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
+	dc->flush_interval = WRITEBACK_FLUSH_INTERVAL_DEFAULT;
 
 	/* For dc->writeback_lock contention in update_writeback_rate() */
 	dc->rate_update_retry = 0;
 
+	INIT_LIST_HEAD(&dc->preflush_keys.list);
+	spin_lock_init(&dc->preflush_keys.lock);
+	dc->preflush_keys.count = 0;
+
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..1cd3e4addba2 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -14,6 +14,10 @@
 #define WRITEBACK_RATE_UPDATE_SECS_MAX		60
 #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
 
+#define WRITEBACK_FLUSH_INTERVAL_MIN		500
+#define WRITEBACK_FLUSH_INTERVAL_MAX		50000
+#define WRITEBACK_FLUSH_INTERVAL_DEFAULT	20000 /* the number of bkey */
+
 #define BCH_AUTO_GC_DIRTY_THRESHOLD	50
 
 #define BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW 50
-- 
2.18.1


