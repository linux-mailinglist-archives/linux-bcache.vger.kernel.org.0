Return-Path: <linux-bcache+bounces-970-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F782A9E971
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Apr 2025 09:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB2EE3A84AC
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Apr 2025 07:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB18B1DD88F;
	Mon, 28 Apr 2025 07:35:56 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A3C1DDC23;
	Mon, 28 Apr 2025 07:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745825756; cv=none; b=DRGRJd5bm202MEassQ6jZ2c8Ykl6gCI2SP/80A/gi9f1ctOXB42VBerdkEoDEhIsqJWD9Z/IqPuRzUekOucqM7LjLbgB8dRKCnjNhbBTBpqR0H7Yh62rJzxWZ9uHXCi7c788/BGJyJGC+A/Hb/gX8j4Diro0QoJKJsgBF9nAwMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745825756; c=relaxed/simple;
	bh=HAsryES54PFcY/U1O0g8ErbgA+2ogb8MNJwwWHAfMvM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pIqDqLHS3YpVF1891ZeevIghkHSae0pAji5DHV4ykKY84ItK5pcE9cxsS0QDTPWuBF35BAXPuypXe0rl1TXJXkMibuOcnXKVG8YbZi1ShGi7IUFRJYBsUPQpWXEmvawZx+oZexF+e4g2bEO/x3dXs1Uz//1319C4ljWNuurWRbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: zesmtpgz5t1745825692tb481673b
X-QQ-Originating-IP: gH81Jss4fJ/DAXsSKsYC0CE3SDwQXFcCR/RO8OZlsJE=
Received: from localhost.localdomain ( [175.9.43.233])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 28 Apr 2025 15:34:47 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4280529366886370106
EX-QQ-RecipientCnt: 7
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@kernel.org
Cc: dengwangbo@kylinos.com.cn,
	kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xiahua@kylinos.com.cn,
	zhoujifeng@kylinos.com.cn
Subject: [PATCH v2] bcache: add the deferred_flush IO processing path in the writeback mode
Date: Mon, 28 Apr 2025 15:34:45 +0800
Message-Id: <20250428073445.24108-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
References: <ug3sqyn42af4bjsp3l5d5ymiabtc767oaoud3ddzv6jnw2eh27@4gcxqaq5tatf>
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NOIkHYnr7VzdKe+fVC8kZeqs1zn1NjNRHAQO6FU9zHws3I1fJgqoItyj
	UnDOubdIMX8rWUMysAMzp6l6N508f++h6mbSDWfoSYOnBRdYEd9WTtmk9q9O1nmcufDHADI
	LtUnpTQQAbfhJGtKLE44cSLjloWKZnVEDx6wAjORsqqIDWote5lw2NyQHXfePsLe9gJ+B8o
	Jeih1D5iFTOM6iitpwKUoaN6czgVGWp+8ORgWJU32MMLef4kcNpx7kCi4RWttEFdFwzW/eu
	tlVwMpCiE8wrLQUtetpK5rpxFaYrn/LdmVDFMKaF9Mc5DHTPHfSzA9bVdPGdhivXWlHrXFm
	I3qGHFJpqncu8MRlEbX7Yk6uJI0b74hZNHNUEL++PxRwrmPnVjFLRywBYAOIF1WCvJiKmDy
	nTp243DZf2jeqANv+iNP4r4dUiEHjPAAeZHDo7cV2zrj10llzYCI3/SVFwBCfatqg5k4+H7
	cbj/xf2gBfvreWS8WosZq6NaPnHi4FsF5Imk/u8wTBNgQZn8VXUigKK1PioaXGpx0RWeem3
	ErJYaRusAhE14eQOwRQBm0o/+5lMReyyMag/cYaHI774Zxh5cfpZBeqoSP2HiOBnENAYvHG
	ARmM8M1FhtDwbGZFdKsfbigadsv5MbGJgMygdb/KlAUfMaxdsrBu0hKApdQlLlPEOMGuwxK
	FF6tdJnk9KkdAuomEhhtFxhp/xhwmPzw6ZmGq4Aed14MRG7aCFM8h9SIhxBhU5yYY1JkBQq
	P8d0SzwJvYfv4uWzH+DD/NS5mZJvxfm/EvQAGMXzaDduMzcmrg26OgjlnKYvtRr5skxVEyu
	OOCbVCFctsQIDyToVju7b7GqZ/mFHf7zI2itkEZlaKRlQ8i2Yh7hEzZnm5YU7wtlS951WEi
	alDY6cNpx05yv33KCeL/Ip0ilwkzCL+uKkKggapcVL55/ovXfKFVhS8RiRplTVf+p5y89Jv
	bsPr7god4dD2KiLMeetMX1M2hNVBEasJu5p7TQ/1OIqUPqQC5xGu+2/HiEK3vwmlvlKel/V
	WJAZqatBul5UxRojoC+R1duCc9SDg=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>

In some scenarios with high requirements for both data reliability and
write performance, the various cache modes of the current bcache cannot
fully match the requirements. deferred_flush aims to increase the
reliability of writeback write-back. And reduce the sending of PREFLUSH
requests to the backing device to enhance data security and dsync write
performance in wrieback mode.

When cache_mode is switched to the non-writeback mode, defered_flush
will be automatically turned off. When other modes are switched to
writeback+defered_flush, a PREFLUSH request will be sent to the backing
device. Make sure that the previously submitted data is not lost.

deferred_flush supports three selectable modes:
none: do nothing (default )
normal: sequential I/O bypasses the cache disk
force: sequential I/O cannot bypass the cache disk

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---

v1->v2: Version v2 mainly addresses the issue of low efficiency in 
writing back dirty data in version v1. When writing back dirty data, 
it no longer uses the FUA method but instead writes back no more than 
500 dirty bkeys and then uniformly sends a PREFLUSH instruction once.
I will supplement more test data later.

 drivers/md/bcache/bcache.h        | 20 +++++++
 drivers/md/bcache/bcache_ondisk.h |  5 ++
 drivers/md/bcache/request.c       | 32 +++++++++-
 drivers/md/bcache/sysfs.c         | 54 +++++++++++++++++
 drivers/md/bcache/writeback.c     | 98 +++++++++++++++++++++++++++----
 drivers/md/bcache/writeback.h     |  4 ++
 6 files changed, 199 insertions(+), 14 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..75110fbe6656 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -247,6 +247,14 @@ struct keybuf {
 	DECLARE_ARRAY_ALLOCATOR(struct keybuf_key, freelist, KEYBUF_NR);
 };
 
+struct keybuf_preflush {
+	spinlock_t	lock;
+#define KEYBUF_NR		500
+	struct keybuf_key data[KEYBUF_NR];
+	unsigned int nr_keys;
+};
+
+
 struct bcache_device {
 	struct closure		cl;
 
@@ -346,6 +354,12 @@ struct cached_dev {
 
 	struct keybuf		writeback_keys;
 
+	/*
+	 * Before performing preflush to the backing device, temporarily
+	 * store the bkey waiting to clean up the dirty mark
+	 */
+	struct keybuf_preflush  preflush_keys;
+
 	struct task_struct	*status_update_thread;
 	/*
 	 * Order the write-half of writeback operations strongly in dispatch
@@ -405,6 +419,12 @@ struct cached_dev {
 	 */
 #define BCH_WBRATE_UPDATE_MAX_SKIPS	15
 	unsigned int		rate_update_retry;
+
+	/*
+	 * In the deferred flush mode, 0 indicates that there is no
+	 * need to send flush to the backing device.
+	 */
+	atomic_t		need_flush;
 };
 
 enum alloc_reserve {
diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 6620a7f8fffc..822dcdc0caaf 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -294,6 +294,11 @@ BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
 #define CACHE_MODE_WRITEBACK		1U
 #define CACHE_MODE_WRITEAROUND		2U
 #define CACHE_MODE_NONE			3U
+BITMASK(BDEV_DEFERRED_FLUSH,		struct cache_sb, flags, 4, 3);
+#define DEFERRED_FLUSH_NONE		0U
+#define DEFERRED_FLUSH_NORMAL		1U
+#define DEFERRED_FLUSH_FORCE		2U
+
 BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
 #define BDEV_STATE_NONE			0U
 #define BDEV_STATE_CLEAN		1U
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..8dc17d9c5f75 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1026,16 +1026,28 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		bio->bi_end_io = backing_request_endio;
 		closure_bio_submit(s->iop.c, bio, cl);
 
+		if (BDEV_DEFERRED_FLUSH(&dc->sb))
+			atomic_set(&dc->need_flush, 1);
+
 	} else if (s->iop.writeback) {
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
 
 		if (bio->bi_opf & REQ_PREFLUSH) {
+			struct bio *flush;
+
+			/*
+			 * When DEFERRED_FLUSH is enabled, if need_flush is 0,
+			 * there is no need to send a flush to the backing device.
+			 */
+			if (BDEV_DEFERRED_FLUSH(&dc->sb) &&
+				 (!atomic_cmpxchg(&dc->need_flush, 1, 0)))
+				goto insert_data;
+
 			/*
 			 * Also need to send a flush to the backing
 			 * device.
 			 */
-			struct bio *flush;
 
 			flush = bio_alloc_bioset(bio->bi_bdev, 0,
 						 REQ_OP_WRITE | REQ_PREFLUSH,
@@ -1050,6 +1062,9 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 			closure_bio_submit(s->iop.c, flush, cl);
 		}
 	} else {
+		if (BDEV_DEFERRED_FLUSH(&dc->sb))
+			atomic_set(&dc->need_flush, 1);
+
 		s->iop.bio = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
 					     &dc->disk.bio_split);
 		/* I/O request sent to backing device */
@@ -1066,14 +1081,27 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
 {
 	closure_type(s, struct search, cl);
 	struct bio *bio = &s->bio.bio;
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
-	if (s->iop.flush_journal)
+	if (s->iop.flush_journal) {
 		bch_journal_meta(s->iop.c, cl);
 
+		/*
+		 * When deferred flush is enabled, it is necessary to determine
+		 * whether the flush request can be sent to the backing device.
+		 */
+		if (BDEV_DEFERRED_FLUSH(&dc->sb) &&
+				 (!atomic_cmpxchg(&dc->need_flush, 1, 0))) {
+			s->iop.status = BLK_STS_OK;
+			goto end;
+		}
+	}
+
 	/* If it's a flush, we send the flush to the backing device too */
 	bio->bi_end_io = backing_request_endio;
 	closure_bio_submit(s->iop.c, bio, cl);
 
+end:
 	continue_at(cl, cached_dev_bio_complete, NULL);
 }
 
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index e8f696cb58c0..3f343fba2f96 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -28,6 +28,25 @@ static const char * const bch_cache_modes[] = {
 	NULL
 };
 
+/*
+ * Deferred flush: In writeback mode, reduce unnecessary PREFLUSH
+ * passed to the backend disk to speed up the performance of dsync
+ * requests.Enhance data writeback security through FUA when dirty
+ * data is written back
+ *
+ * Default is 0 ("none")
+ * none: Do nothing
+ * normal: Sequential I/O bypasses the cache disk
+ * force: Sequential I/O cannot bypass the cache disk
+ */
+static const char * const bch_deferred_flush[] = {
+	"none",
+	"normal",
+	"force",
+	NULL
+};
+
+
 static const char * const bch_reada_cache_policies[] = {
 	"all",
 	"meta-only",
@@ -151,6 +170,7 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+rw_attribute(deferred_flush);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -283,6 +303,11 @@ SHOW(__bch_cached_dev)
 		return strlen(buf);
 	}
 
+	if (attr == &sysfs_deferred_flush)
+		return bch_snprint_string_list(buf, PAGE_SIZE,
+					       bch_deferred_flush,
+					       BDEV_DEFERRED_FLUSH(&dc->sb));
+
 #undef var
 	return 0;
 }
@@ -295,6 +320,7 @@ STORE(__cached_dev)
 	ssize_t v;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
+	struct bio flush;
 
 	/* no user space access if system is rebooting */
 	if (bcache_is_reboot)
@@ -383,6 +409,12 @@ STORE(__cached_dev)
 			SET_BDEV_CACHE_MODE(&dc->sb, v);
 			bch_write_bdev_super(dc, NULL);
 		}
+
+		/* It's not the writeback mode that can't enable deferred_flush */
+		if (BDEV_DEFERRED_FLUSH(&dc->sb) && ((unsigned int) v != CACHE_MODE_WRITEBACK)) {
+			SET_BDEV_DEFERRED_FLUSH(&dc->sb, 0);
+			bch_write_bdev_super(dc, NULL);
+		}
 	}
 
 	if (attr == &sysfs_readahead_cache_policy) {
@@ -451,6 +483,27 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
+	if (attr == &sysfs_deferred_flush) {
+		v = __sysfs_match_string(bch_deferred_flush, -1, buf);
+		if (v < 0)
+			return v;
+
+		if ((unsigned int) v != BDEV_DEFERRED_FLUSH(&dc->sb)) {
+			if (v && (BDEV_CACHE_MODE(&dc->sb) != CACHE_MODE_WRITEBACK)) {
+				pr_err("It's not the writeback mode that can't enable deferred_flush.\n");
+				return -EINVAL;
+			}
+
+			SET_BDEV_DEFERRED_FLUSH(&dc->sb, v);
+			bch_write_bdev_super(dc, NULL);
+			if (v) {
+				bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+				/* I/O request sent to backing device */
+				submit_bio_wait(&flush);
+			}
+		}
+	}
+
 	return size;
 }
 
@@ -541,6 +594,7 @@ static struct attribute *bch_cached_dev_attrs[] = {
 #endif
 	&sysfs_backing_dev_name,
 	&sysfs_backing_dev_uuid,
+	&sysfs_deferred_flush,
 	NULL
 };
 ATTRIBUTE_GROUPS(bch_cached_dev);
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 453efbbdc8ee..ce31d1535d90 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -362,23 +362,31 @@ static CLOSURE_CALLBACK(write_dirty_finish)
 		unsigned int i;
 		struct keylist keys;
 
-		bch_keylist_init(&keys);
+		if (!BDEV_DEFERRED_FLUSH(&dc->sb)) {
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
+			spin_lock(&dc->preflush_keys.lock);
+			dc->preflush_keys.data[dc->preflush_keys.nr_keys] = *w;
+			dc->preflush_keys.nr_keys++;
+			spin_unlock(&dc->preflush_keys.lock);
+		}
 	}
 
 	bch_keybuf_del(&dc->writeback_keys, w);
@@ -435,6 +443,7 @@ static CLOSURE_CALLBACK(write_dirty)
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
 		io->bio.bi_opf = REQ_OP_WRITE;
+
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
@@ -471,6 +480,66 @@ static CLOSURE_CALLBACK(read_dirty_submit)
 	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
 }
 
+static void flush_backing_device(struct cached_dev *dc)
+{
+	int ret;
+	unsigned int i;
+	struct bio flush;
+	struct keybuf_key *p;
+
+	if (dc->preflush_keys.nr_keys == 0)
+		return;
+
+	bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+	ret = submit_bio_wait(&flush);
+	if (ret) {
+		pr_warn("flush backing device error, ret=%d!\n", ret);
+		dc->preflush_keys.nr_keys = 0;
+		/*
+		 * Due to the flush failure, the dirty marked bkey will wait for
+		 * the next rescheduling to be written back
+		 */
+		return;
+	}
+
+	/*
+	 * The dirty data was successfully written back and confirmed to be written
+	 * to the disk. The status of the bkey in the btree was updated.
+	 */
+	for (i = 0; i < dc->preflush_keys.nr_keys; i++) {
+		int ret;
+		unsigned int j;
+		struct keylist keys;
+
+		bch_keylist_init(&keys);
+
+		p = &dc->preflush_keys.data[i];
+		bkey_copy(keys.top, &p->key);
+		SET_KEY_DIRTY(keys.top, false);
+		bch_keylist_push(&keys);
+
+		for (j = 0; j < KEY_PTRS(&p->key); j++)
+			atomic_inc(&PTR_BUCKET(dc->disk.c, &p->key, j)->pin);
+
+		ret = bch_btree_insert(dc->disk.c, &keys, NULL, &p->key);
+
+		if (ret)
+			trace_bcache_writeback_collision(&p->key);
+
+		atomic_long_inc(ret
+				? &dc->disk.c->writeback_keys_failed
+				: &dc->disk.c->writeback_keys_done);
+
+		/* For those bkeys that failed to be inserted, you can
+		 * ignore them and they will be processed again in the
+		 * next write-back scan.
+		 */
+	}
+
+	dc->preflush_keys.nr_keys = 0;
+
+}
+
 static void read_dirty(struct cached_dev *dc)
 {
 	unsigned int delay = 0;
@@ -819,6 +888,8 @@ static int bch_writeback_thread(void *arg)
 
 		read_dirty(dc);
 
+		flush_backing_device(dc);
+
 		if (searched_full_index) {
 			unsigned int delay = dc->writeback_delay * HZ;
 
@@ -1072,6 +1143,9 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	/* For dc->writeback_lock contention in update_writeback_rate() */
 	dc->rate_update_retry = 0;
 
+	spin_lock_init(&dc->preflush_keys.lock);
+	dc->preflush_keys.nr_keys = 0;
+
 	WARN_ON(test_and_clear_bit(BCACHE_DEV_WB_RUNNING, &dc->disk.flags));
 	INIT_DELAYED_WORK(&dc->writeback_rate_update, update_writeback_rate);
 }
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..0c92a607a875 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -117,6 +117,10 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 				    bio_sectors(bio)))
 		return true;
 
+	/* Prevent IO from bypassing the cache disk */
+	if (BDEV_DEFERRED_FLUSH(&dc->sb) == DEFERRED_FLUSH_FORCE)
+		return true;
+
 	if (would_skip)
 		return false;
 
-- 
2.18.1


