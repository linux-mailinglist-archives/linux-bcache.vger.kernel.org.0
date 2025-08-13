Return-Path: <linux-bcache+bounces-1186-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C13B23E17
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 04:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 85EE81745AA
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Aug 2025 02:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2F41DB12E;
	Wed, 13 Aug 2025 02:14:04 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2578613AD05;
	Wed, 13 Aug 2025 02:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755051244; cv=none; b=s1uLKySXsCwtKU8j11ijopEeJ7h6YawNWc1TCw+ATIhfDKWytve1biU11pTEoScpbbwnHXZRpZ9zU60LJP/3bhPzJk8dfUWMrqpBlg/aoqK7iR4jhAVugAmSX/IU9urHyu7r0nuRTyzmt/+Q6579C1p0aib2PUygpGSi3uttfJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755051244; c=relaxed/simple;
	bh=rrUNULnXrDBPb1AyZJGGjhGUFDRKVTnb1tmjHIwx4E4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nu9n5XDpKuwVsfAu5p1dyq6HyMndErgQJuR6NN8BMEZJJ97B5WcuO28CZqN9nvgSIf09RPlF3HodnaIy7Hy3zKfvaP9QgR+ZgBeoVaC5ACgcebCrhMPQ7fh51h9dac0LUf6C8TvM9K3Ea4WW54Mb5tu2+PXs717/vn1Jo41+YZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: zesmtpsz4t1755051193t63a7bf5a
X-QQ-Originating-IP: EtjxhCwsV83aZopZYtj66FII1bcoCsjUiH4NllH0PcE=
Received: from localhost.localdomain ( [175.9.39.161])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 13 Aug 2025 10:12:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16065540055535800862
EX-QQ-RecipientCnt: 5
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: zhoujifeng@kylinos.com.cn,
	colyli@kernel.org
Cc: kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcache: enhancing the security of dirty data writeback
Date: Wed, 13 Aug 2025 10:12:36 +0800
Message-Id: <20250813021236.30133-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <tencent_27E675CD6ADE39EA7923AD17@qq.com>
References: <tencent_27E675CD6ADE39EA7923AD17@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: MjlOSqg8Riw0iu3s7UKqbwel+FLH02/4G5pjP3ZbtOQPHuC4sccoxMMW
	WBllKvOoAzgyu0k98EUpJDud9qaJlJxAdp8+/9PM5/g5hjKBvxOWKK8yxjlxBrnU62RL8Xa
	R80JQg5tKDZFdHhrVB7tbnbpUHUwLuHU6gLf9qNM6jvvc+vEjr4+yzjLLE3AtHVU4ZsEa7M
	/KQMTPoHFPj44zoUF+UdvmxwGB8bhQD7u8rqjhikGG5LVMlz8W/JrLXNlz0/eOPxtI99for
	p5R2ADkSnBnjhdRqd9S7ed77nG/5I6Tt5UkhIUVD+MHUcZBW9ZZiualP8Gh9vzoIkuyzRO1
	On9dyrVwRCARoo1QoQgaA49LbPWXmXzbHrE8DH0xlLBG9ywuLNJiBAc9PfdP4i0NNeXauDo
	9cWOa3GBm0ib5NPXBmfSxLVWAR6FWDo2UTBFKv3jHZya3PZNwqaSm7SMJIGxVJkG1Oz0pM7
	87fGCdy+HIE8UBtrI6/rroM5296hmix9DCwzabO3HH/9yc4wwQulogitLpY3MO6Y3A/J3L2
	8l/Tx6ucp7HhiCKc+uLs9zFs7SdhY02lRECK1qPYEiVoQkb5So3w0vPQQ438u7z1TmxOMAo
	/CSzQ/Trvp6dDltP7ZZPNLL+1SVxX1DZSVJW3zU3/E7CTW7uMQl9+4Y9hs+psYUvAsHX+iL
	Ae2e6ei7q283W1WI8DHNlhbFqN8z2UCDy8awUg/gs8PWpShHlE3HX3ryDBkC5Yb8kcANCah
	K/xrOf2H9o9yOYoXABvczyDMQ0DLU9kKjD8Dh5czDbngzmnnzEM8rE+MLMA5hCfnAsyGST9
	TsykSyvq2QuCvI6SbFAOkq6NEzBujI1Wy27fldcTG3xVvzCLhFWndbXmOTvB5Ho4OiLgy5M
	MgcSdHQPgV+VzLygUx1XG/O3VzajKMOqKvRfo4uj0rrE6C4knXaMuYmWjUCre6BavdK2V30
	D70BeIcEGVutLNiQ3HDX4qRgUhuY4iAcyRFFFD9X37ohukS4/icH6gas8B46B1vUtfniyaa
	MTXY/0QQ==
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
only after the dirty data is written to the disk. Double triggering
conditions for PREFLUSH:
1、When the cumulative number of dirty bkeys written back reaches the
threshold(Dynamic control parameters:/sys/block/bcache0/bcache/
flush_interval, the default value is 20000. by increasing the value of this
parameter, the impact of flush on performance can be reduced.)
2、When the interval since the last refresh exceeds 30 seconds
If any of the conditions are met, the system will send a PREFLUSH command
to the backend HDD, and clear the corresponding dirty bkey mark only after
confirming that the PREFLUSH is executed successfully.

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
v1 -> v2: Make revisions according to the review comments.

 drivers/md/bcache/bcache.h        |  29 +++++++
 drivers/md/bcache/bcache_ondisk.h |   4 +
 drivers/md/bcache/btree.c         | 136 ++++++++++++++++++++++++++++++
 drivers/md/bcache/btree.h         |   4 +
 drivers/md/bcache/sysfs.c         |  11 +++
 drivers/md/bcache/writeback.c     | 115 +++++++++++++++++++++----
 6 files changed, 283 insertions(+), 16 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..09012202658a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -247,6 +247,23 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
+struct preflush_bkey {
+	BKEY_PADDED(key);
+	struct list_head list;
+};
+
+#define WRITEBACK_FLUSH_INTERVAL_DEFAULT	20000 /* the number of bkey */
+#define WRITEBACK_FLUSH_INTERVAL_MIN	        500
+#define WRITEBACK_FLUSH_INTERVAL_MAX	        50000
+
+struct preflush_buf {
+	spinlock_t	lock;
+	u32 count;
+	struct list_head allocated_head;
+
+	DECLARE_ARRAY_ALLOCATOR(struct preflush_bkey, freelist, WRITEBACK_FLUSH_INTERVAL_MAX);
+};
+
 struct bcache_device {
 	struct closure		cl;
 
@@ -346,6 +363,18 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	/*
+	 * Before performing preflush to the backing device, temporarily
+	 * store the bkey waiting to clean up the dirty mark
+	 */
+	struct preflush_buf  preflush_keys;
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
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index ed40d8600656..3b47ef20f1f8 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1830,6 +1830,126 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	mutex_unlock(&c->bucket_lock);
 }
 
+void bcache_add_preflush_buf(struct cached_dev *dc, struct bkey *key)
+{
+	struct preflush_bkey *p;
+
+	spin_lock(&dc->preflush_keys.lock);
+
+	p = array_alloc(&dc->preflush_keys.freelist);
+
+	if (!p) {
+		spin_unlock(&dc->preflush_keys.lock);
+		return;
+	}
+
+	bkey_copy(&p->key, key);
+	INIT_LIST_HEAD(&p->list);
+
+	list_add_tail(&p->list, &dc->preflush_keys.allocated_head);
+	dc->preflush_keys.count++;
+
+	spin_unlock(&dc->preflush_keys.lock);
+}
+
+void bcache_mark_preflush_keys_clean(struct cached_dev *dc)
+{
+	struct preflush_bkey *p;
+
+	spin_lock(&dc->preflush_keys.lock);
+
+	/*
+	 * Release the reference added to the bucket during the
+	 * "write_dirty_finish" period.
+	 */
+	list_for_each_entry(p, &dc->preflush_keys.allocated_head, list) {
+		bkey_put(dc->disk.c, &p->key);
+	}
+
+	dc->preflush_keys.count = 0;
+	array_allocator_init(&dc->preflush_keys.freelist);
+	INIT_LIST_HEAD(&dc->preflush_keys.allocated_head);
+
+	spin_unlock(&dc->preflush_keys.lock);
+}
+
+static void gc_preflush_keys_writeback(struct cache_set *c)
+{
+	unsigned int i, j;
+	struct preflush_bkey *p, *tmp;
+	struct keylist keys;
+	struct bio flush;
+	struct bkey_padded {
+		BKEY_PADDED(key);
+	} *copy;
+	unsigned int copied = 0;
+	int ret = 0;
+
+	for (i = 0; i < c->devices_max_used; i++) {
+		struct bcache_device *d = c->devices[i];
+		struct cached_dev *dc;
+
+		copied = 0;
+
+		if (!d || UUID_FLASH_ONLY(&c->uuids[i]))
+			continue;
+		dc = container_of(d, struct cached_dev, disk);
+
+		copy = kmalloc_array(WRITEBACK_FLUSH_INTERVAL_MAX,
+				sizeof(*copy), GFP_KERNEL);
+		if (!copy)
+			return;
+
+		spin_lock(&dc->preflush_keys.lock);
+
+		list_for_each_entry_safe(p, tmp, &dc->preflush_keys.allocated_head, list) {
+			bkey_copy(&copy[copied].key, &p->key);
+			copied++;
+
+			list_del(&p->list);
+			dc->preflush_keys.count--;
+			bch_preflush_buf_del(&dc->preflush_keys, p);
+		}
+
+		spin_unlock(&dc->preflush_keys.lock);
+
+		bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+		ret = submit_bio_wait(&flush);
+		if (ret) {
+			pr_err("flush backing device error %d.\n", ret);
+
+			/*
+			 * In the case of flush failure, do not update the status of bkey
+			 * in the btree, and wait until the next time to re-write the dirty
+			 * data.
+			 */
+			bcache_mark_preflush_keys_clean(dc);
+			kfree(copy);
+			return;
+		}
+
+		for (j = 0; j < copied; j++) {
+			memset(keys.inline_keys, 0, sizeof(keys.inline_keys));
+			bch_keylist_init(&keys);
+
+			bkey_copy(keys.top, &copy[j].key);
+			SET_KEY_DIRTY(keys.top, false);
+			bch_keylist_push(&keys);
+
+			ret = bch_btree_insert(dc->disk.c, &keys, NULL, &copy[j].key);
+
+			if (ret)
+				trace_bcache_writeback_collision(&copy[j].key);
+
+			atomic_long_inc(ret
+					? &dc->disk.c->writeback_keys_failed
+					: &dc->disk.c->writeback_keys_done);
+		}
+
+		kfree(copy);
+	}
+}
+
 static void bch_btree_gc(struct cache_set *c)
 {
 	int ret;
@@ -1844,6 +1964,8 @@ static void bch_btree_gc(struct cache_set *c)
 	closure_init_stack(&writes);
 	bch_btree_op_init(&op, SHRT_MAX);
 
+	gc_preflush_keys_writeback(c);
+
 	btree_gc_start(c);
 
 	/* if CACHE_SET_IO_DISABLE set, gc thread should stop too */
@@ -2749,6 +2871,11 @@ void bch_keybuf_del(struct keybuf *buf, struct keybuf_key *w)
 	spin_unlock(&buf->lock);
 }
 
+void bch_preflush_buf_del(struct preflush_buf *buf, struct preflush_bkey *p)
+{
+	array_free(&buf->freelist, p);
+}
+
 bool bch_keybuf_check_overlapping(struct keybuf *buf, struct bkey *start,
 				  struct bkey *end)
 {
@@ -2828,6 +2955,15 @@ void bch_keybuf_init(struct keybuf *buf)
 	array_allocator_init(&buf->freelist);
 }
 
+void bch_preflush_buf_init(struct preflush_buf *buf)
+{
+	buf->count = 0;
+
+	spin_lock_init(&buf->lock);
+	array_allocator_init(&buf->freelist);
+	INIT_LIST_HEAD(&buf->allocated_head);
+}
+
 void bch_btree_exit(void)
 {
 	if (btree_io_wq)
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 45d64b54115a..59a2ee7c81f7 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -414,4 +414,8 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 					  struct bkey *end,
 					  keybuf_pred_fn *pred);
 void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats);
+void bch_preflush_buf_init(struct preflush_buf *buf);
+void bch_preflush_buf_del(struct preflush_buf *buf, struct preflush_bkey *p);
+void bcache_add_preflush_buf(struct cached_dev *dc, struct bkey *key);
+void bcache_mark_preflush_keys_clean(struct cached_dev *dc);
 #endif
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e8f696cb58c0..69332aa39b4e 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -151,6 +151,12 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+/*
+ * "flush_interval" is used to specify that a PROFLUSH operation will
+ * be issued once a certain number of dirty bkeys have been written
+ * each time.
+ */
+rw_attribute(flush_interval);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -213,6 +219,7 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_rate_fp_term_mid);
 	var_print(writeback_rate_fp_term_high);
 	var_print(writeback_rate_minimum);
+	var_print(flush_interval);
 
 	if (attr == &sysfs_writeback_rate_debug) {
 		char rate[20];
@@ -354,6 +361,9 @@ STORE(__cached_dev)
 
 	sysfs_strtoul_clamp(io_error_limit, dc->error_limit, 0, INT_MAX);
 
+	sysfs_strtoul_clamp(flush_interval, dc->flush_interval,
+			    WRITEBACK_FLUSH_INTERVAL_MIN, WRITEBACK_FLUSH_INTERVAL_MAX);
+
 	if (attr == &sysfs_io_disable) {
 		int v = strtoul_or_return(buf);
 
@@ -541,6 +551,7 @@ static struct attribute *bch_cached_dev_attrs[] = {
 #endif
 	&sysfs_backing_dev_name,
 	&sysfs_backing_dev_uuid,
+	&sysfs_flush_interval,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cached_dev);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 453efbbdc8ee..69e2d37ddbef 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -348,37 +348,100 @@ static CLOSURE_CALLBACK(dirty_io_destructor)
 	kfree(io);
 }
 
-static CLOSURE_CALLBACK(write_dirty_finish)
+static void flush_backing_device(struct cached_dev *dc)
 {
-	closure_type(io, struct dirty_io, cl);
-	struct keybuf_key *w = io->bio.bi_private;
-	struct cached_dev *dc = io->dc;
+	int ret;
+	struct keylist keys;
+	struct bio flush;
+	struct preflush_bkey *p;
 
-	bio_free_pages(&io->bio);
+	BKEY_PADDED(key) replace_key;
 
-	/* This is kind of a dumb way of signalling errors. */
-	if (KEY_DIRTY(&w->key)) {
-		int ret;
-		unsigned int i;
-		struct keylist keys;
+	spin_lock(&dc->preflush_keys.lock);
+	if (dc->preflush_keys.count == 0) {
+		spin_unlock(&dc->preflush_keys.lock);
+		return;
+	}
+	spin_unlock(&dc->preflush_keys.lock);
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
 
+	/*
+	 * The dirty data was successfully written back and confirmed to be written
+	 * to the disk. The status of the bkey in the btree was updated.
+	 */
+	while (1) {
+		memset(keys.inline_keys, 0, sizeof(keys.inline_keys));
 		bch_keylist_init(&keys);
 
-		bkey_copy(keys.top, &w->key);
+		spin_lock(&dc->preflush_keys.lock);
+		if (!list_empty(&dc->preflush_keys.allocated_head)) {
+			p = list_first_entry(&dc->preflush_keys.allocated_head,
+					struct preflush_bkey,
+					list);
+
+			bkey_copy(keys.top, &(p->key));
+			bkey_copy(&replace_key.key, &(p->key));
+			list_del(&p->list);
+			dc->preflush_keys.count--;
+			bch_preflush_buf_del(&dc->preflush_keys, p);
+		} else {
+			spin_unlock(&dc->preflush_keys.lock);
+			break;
+		}
+		spin_unlock(&dc->preflush_keys.lock);
+
 		SET_KEY_DIRTY(keys.top, false);
 		bch_keylist_push(&keys);
 
-		for (i = 0; i < KEY_PTRS(&w->key); i++)
-			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
-
-		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &w->key);
+		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &replace_key.key);
 
 		if (ret)
-			trace_bcache_writeback_collision(&w->key);
+			trace_bcache_writeback_collision(&replace_key.key);
 
 		atomic_long_inc(ret
 				? &dc->disk.c->writeback_keys_failed
 				: &dc->disk.c->writeback_keys_done);
+
+		/* For those bkeys that failed to be inserted, you can
+		 * ignore them and they will be processed again in the
+		 * next write-back scan.
+		 */
+	}
+}
+
+static CLOSURE_CALLBACK(write_dirty_finish)
+{
+	closure_type(io, struct dirty_io, cl);
+	struct keybuf_key *w = io->bio.bi_private;
+	struct cached_dev *dc = io->dc;
+
+	bio_free_pages(&io->bio);
+
+	/* This is kind of a dumb way of signalling errors. */
+	if (KEY_DIRTY(&w->key)) {
+		unsigned int i;
+
+		/*
+		 * Add the bucket reference before inserting the bkey into
+		 * the btree.
+		 */
+		for (i = 0; i < KEY_PTRS(&w->key); i++)
+			atomic_inc(&PTR_BUCKET(dc->disk.c, &w->key, i)->pin);
+
+		bcache_add_preflush_buf(dc, &w->key);
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
@@ -435,6 +498,7 @@ static CLOSURE_CALLBACK(write_dirty)
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
 		io->bio.bi_opf = REQ_OP_WRITE;
+
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
@@ -741,6 +805,7 @@ static int bch_writeback_thread(void *arg)
 	struct cached_dev *dc = arg;
 	struct cache_set *c = dc->disk.c;
 	bool searched_full_index;
+	unsigned long last_flush_jiffies = jiffies;
 
 	bch_ratelimit_reset(&dc->writeback_rate);
 
@@ -819,9 +884,23 @@ static int bch_writeback_thread(void *arg)
 
 		read_dirty(dc);
 
+		/*
+		 * If the accumulated preflush_keys exceed a certain quantity or
+		 * the interval time exceeds 30 seconds, issue the PREFLUSH command
+		 * once.
+		 */
+		if (dc->preflush_keys.count >= (dc->flush_interval - KEYBUF_NR) ||
+			time_after(jiffies, last_flush_jiffies + 30 * HZ)) {
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
@@ -832,6 +911,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
+	flush_backing_device(dc);
+
 	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
 
@@ -1053,6 +1134,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	sema_init(&dc->in_flight, 64);
 	init_rwsem(&dc->writeback_lock);
 	bch_keybuf_init(&dc->writeback_keys);
+	bch_preflush_buf_init(&dc->preflush_keys);
 
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
@@ -1068,6 +1150,7 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	dc->writeback_rate_fp_term_mid = 10;
 	dc->writeback_rate_fp_term_high = 1000;
 	dc->writeback_rate_i_term_inverse = 10000;
+	dc->flush_interval = WRITEBACK_FLUSH_INTERVAL_DEFAULT;
 
 	/* For dc->writeback_lock contention in update_writeback_rate() */
 	dc->rate_update_retry = 0;
-- 
2.18.1


