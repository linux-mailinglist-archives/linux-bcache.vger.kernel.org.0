Return-Path: <linux-bcache+bounces-963-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E2FEA9BD5D
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Apr 2025 05:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14EF87B50CB
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Apr 2025 03:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CCA81DD529;
	Fri, 25 Apr 2025 03:53:14 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbg154.qq.com (smtpbg154.qq.com [15.184.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CC41B424E;
	Fri, 25 Apr 2025 03:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=15.184.224.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745553194; cv=none; b=KWXrhxY24DiVmqbgYPrzRxt6UrtwaG2IKAHAcUdRCJywDcpPESXyGFMZ598azl8CqAsCi1pUXq8ceEy8zpw3L+arFUTz3mJnNbUAwYlyEQSIGuhqkaiTxFqUWGrrn1GSqMXA5cIKdHPf+8+/gLISM8DjhlNkHOkjV4LW3ipbLsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745553194; c=relaxed/simple;
	bh=mOrJbm2vgRrNlZG91GOk+o0J0tHArqPZZ6vMJ9MY40M=;
	h=From:To:Cc:Subject:Date:Message-Id; b=pLsa/nwwhzrYZOUDkttiA3giGI0ixwu7OPVQZ1YYEUnBcOSdqv+X2wwDFtfW5t1ctJVBEkHXoP6bPjZZv24AfkgIDzAXQ0a2sUFPqj3uWjqEKPexqC+RCkC98KsNxpCZ0BzweDgqCoBv2IGLL0AJWxIfu0PPlXIFSDUFuuiCADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=15.184.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: esmtpgz16t1745553140t3a03b901
X-QQ-Originating-IP: dioY4icXEildtwSsco9C30TQ+RFm7FKYxM5RZp15kmE=
Received: from localhost.localdomain ( [175.9.43.233])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 25 Apr 2025 11:50:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9689858348433697704
EX-QQ-RecipientCnt: 7
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@kernel.org,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xiahua@kylinos.com.cn,
	dengwangbo@kylinos.com.cn,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: [PATCH] bcache: add the deferred_flush IO processing path in the writeback mode
Date: Fri, 25 Apr 2025 11:50:21 +0800
Message-Id: <20250425035021.921-1-zhoujifeng@kylinos.com.cn>
X-Mailer: git-send-email 2.18.1
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: M75I2DDAzREF8dfP3paVPhLUffRRqGRNTxPH5MWnTIFbArRpzInfuKG8
	RHM0SYAhfm366Y1q8CL16pVz3jCWsvg/ZYHrMXspFqGJYdQDa61jD7ztEXGSWs74SUkKZqk
	zV4zRA5PgdS1IBSL0halv+tBY1pBekKp8l3C9GGBaT2bJgvI+f5cjZXHcx7Hc5QROugp3kD
	3nQgnHTGs0xrMMJyXUzK6m4aqg6GQuQd1ZfpI4nJXrpBP74TArq6Ff+DNaG79AaJpHkl3gq
	Fya/r42Pu/UHqExLaTbD3dAEA4zv6gAWh+yoIm5aTCXxe66IGUEugJEJfAuBB3RXMj7qY6v
	krACMbRwoyHgt97UXk5vEa9uql6tXHcJmeCBlFOK0dHIUiVaGFudqCpSzp3qqFW1y3oJgx2
	Lu1lPbonHx1nRmzXJNtYAa+2ormxfOAZZrO9FGL6b5m4cPF9/9vrINw468PLeuq3LicP1xO
	sonrBRfCey5HSJdUlmnmhrId9zpFyCo3thTtNVW3ZD0uaGj+GWBT2vlYuENMIDz/mT4YEm3
	qfaL18bUJbBT8TSAZcUIxokHEVUjPbUdLmi6kQ6oyteDm7fWJbV8v5vYx4dHj7VIKbQz1zI
	SpZFTpuNmgnkqw27/2RcCmrhCMd0k7dCd7+OeotFv8hhU3j/9fbD6TJkt6pZ2mU8FZdem6s
	wucgVtgwP302Z1DQXBYNOCfVC9j992Iq8Mf/Ui5X75c2ttbqaMf5jdobjmtR6BcDNoT/nL2
	ZhmHv16/mDiFn7VDxCl+IY+IJgMbInts5oterQ172s011iFQSEABNrlMpCc2CDQMAO3TPfT
	iTzXrVmOIwNQOsPYRV3qIS+hbALEg+7m9GezuiDMhXfsvNIu2aL4WwK/QJihAYvxNe/Tg/i
	RQNS2sVtG7y6MYGuM4dY0sqdx44gsr/frqT/vNYnkbBc1imD4+kf2Ura3+QkyAfZShho7AM
	APYdw8aBWcxkdAIAhfzyYv1WWnxBrpAtdI9wGjSQwLc/I2VJmgGXTiAaYj0AUqeqxC3gn13
	MV2+RlhssoER1rkgDifzYrPj4iSLM=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
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

deferred_flush supports three selectable modes:
none: do nothing (default )
normal: sequential I/O bypasses the cache disk
force: sequential I/O cannot bypass the cache disk

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
 drivers/md/bcache/bcache.h        |  6 ++++
 drivers/md/bcache/bcache_ondisk.h |  5 +++
 drivers/md/bcache/request.c       | 32 ++++++++++++++++--
 drivers/md/bcache/sysfs.c         | 54 +++++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c     |  7 ++++
 drivers/md/bcache/writeback.h     |  4 +++
 6 files changed, 106 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 785b0d9008fa..d2654c449d1c 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -405,6 +405,12 @@ struct cached_dev {
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
index 453efbbdc8ee..68bf655f3b96 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -435,6 +435,13 @@ static CLOSURE_CALLBACK(write_dirty)
 	if (KEY_DIRTY(&w->key)) {
 		dirty_init(w);
 		io->bio.bi_opf = REQ_OP_WRITE;
+
+		/* When DEFERRED_FLUSH is enabled, you need to ensure that
+		 * data is flushed to disk.
+		 */
+		if (BDEV_DEFERRED_FLUSH(&dc->sb))
+			io->bio.bi_opf |= REQ_FUA | REQ_SYNC | REQ_PREFLUSH;
+
 		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
 		bio_set_dev(&io->bio, io->dc->bdev);
 		io->bio.bi_end_io	= dirty_endio;
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


