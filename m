Return-Path: <linux-bcache+bounces-904-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E58FCA934DA
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Apr 2025 10:46:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0602C467E3E
	for <lists+linux-bcache@lfdr.de>; Fri, 18 Apr 2025 08:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106BE256C8F;
	Fri, 18 Apr 2025 08:46:10 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739298C0E;
	Fri, 18 Apr 2025 08:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744965970; cv=none; b=vBM/twfmyvHYZIb+rj01XZ6lh8HCmbLNx/JLIhxl9B9FBof8Zr/61ZRfAnwxVStr7EEL6irFa3UJ55uSoaLklPUP4UYn4ZCg9h34EGgwGwY4iTEWKkKlZz3ILEFHf9kt9iRPpYk3wr9F7eg+Nj9LxEhaoH6Gwv0RxhkP/Pojbo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744965970; c=relaxed/simple;
	bh=aqxMG4/JA2Z+i6M+nP6bzeu5WIfc9MJoiZMXZvhcrYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=ZkJ1lbpCgl3AxWTksodccjctPi89fX71Q/J5i7ipkbzheCzHZz1QO9LIta/Yebn9iTzEboBDO4pyetBG/PtxSS0pylEOlzmJXRisMc0ilHrvcvt9hO5hR7TylJOtyfjOdPuQbVp322/is4rvsrsa67dVKKsPgEecCtq97N87mTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn; spf=pass smtp.mailfrom=kylinos.com.cn; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.com.cn
X-QQ-mid: izesmtp80t1744965890t9204e489
X-QQ-Originating-IP: 31CrV/i1OFzeGasVyv8kGAlXUtdwKt0NQc8Jyms2X3Y=
Received: from localhost.localdomain ( [175.9.43.233])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 18 Apr 2025 16:44:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12938606768469692406
EX-QQ-RecipientCnt: 5
From: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
To: colyli@kernel.org,
	kent.overstreet@linux.dev
Cc: linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhou Jifeng <zhoujifeng@kylinos.com.cn>
Subject: [PATCH] bcache: optimize dsync performance in writeback mode with deferred flush
Date: Fri, 18 Apr 2025 16:44:43 +0800
Message-Id: <20250418084443.7443-1-zhoujifeng@kylinos.com.cn>
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
Feedback-ID: izesmtp:kylinos.com.cn:qybglogicsvrsz:qybglogicsvrsz4a-0
X-QQ-XMAILINFO: NAeO0+xU6W76455AAktdBdDuC8ApTqwCySKe6PxucSLqBU8o+tfxNC7u
	Ok3KZZTn8hajQxsHTrJRRuw+gBU+jOwguUTCi0Ar/zXSYycSNHai3+ryyF52lX7CQLI4sBt
	ltJSaodAtX13IOE+9osX5fGhxT59s/ikPAa7rRbmy+38NkULq19pTZR8iltv8QZF8nlHANg
	tpJlCIWDoGBwTbKj11KO32Yib5/++NY1eLRe+5R0jRMXXheWWZJn90XT4h6GMpaKJR+WKaM
	VLNGopWYDUU9rInMIVaopLcMF5S9uKWVy8jvRydFbYH2bgYV7irfwh/exdtn9IVbnmAbAtb
	IJcpSEAc5bXzBULCn+Uvp3h6AwFz0nQae0J0MiMrn+sJtc1j8SR/OITZ9vWVfL3g2Umm1Pz
	J8CPIueG9Q2qn6kDNM2ZAWU92WWF0r90MAwrYcRvM8dju37qk2Zi4x7abMowb7dEhCtf+nj
	0F/lkF31jZKR9ce7Yu8ud8PFDJ7noOKenQ2wfqALU25VWrTcU9AHN/6v/HpUspo2Z4AWM+t
	deyxeQ2WND25BmakM5TlA2bTsrj1zuTT0Gd9HHerhzxwGh0tXELVEZqc02u8QFg0dwmMe9y
	7hqBoLBf2Ek6n5HjITPAZXphG5nLaI78X5oXRzSJa82hO4AqoboxeF/psnlk/AatSU0+Tcb
	WdqXnDugsgcGIzZPY0yUEDm+coOcgK0/tpZQPo3NqN3J7hBRecXG5pdMyMlgqurMQk8tLF0
	K2oC4Wtjp0olKL9YtmhZVtNiriegKHEpJFY2+Xvd/7pFyWM0fOZXWYYOYdh+8cHduiBUJRx
	u4z8x7gvc/9kbLiJ5e4cnIxQY8f+m6afqLj+z44xQIs2yT4EpioIQ+H1SOa4qee3p2VHMCA
	TgbIN3JkmdNwVYhioSCihUKlNjjwtszG4lqDgKz3+K0td0ucySlXHfZumJRskd3I/gqum10
	p/DxBABYmPOR6GHXwryvzFEagOs5nSkqPpzYWZXYKUSNFAGw9sIBg5n9zSPhRgJokGHv2dI
	Fy7TY9dg==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-QQ-RECHKSPAM: 0

Currently in writeback mode, bcache unconditionally propagates PREFLUSH
requests from upper layers to the backend storage devices. This causes
suboptimal performance for dsync operations due to excessive flush
operations on the backing device.

This patch introduces a deferred flush handling mechanism to improve
dsync efficiency while maintaining data integrity:
1. Delay passing the PREFLUSH request to the backend storage as much as
   possible
2. Keep data cached in the cache device
3. Utilize FUA writes during dirty data writeback to ensure persistence

Applicable scenarios:
- Workloads demanding low-latency dsync operations
- Systems with frequent small synchronous writes

Test case:
  dd if=/dev/zero of=/dev/bcache0 bs=32k count=200000 oflag=dsync

Hardware setup:
  Cache device: Intel Optane SSD 900P
  Backing device: ST4000NM000B HDD

Comparison:
  - deferred FLUSH enabled
  - deferred FLUSH disabled with sequential_cutoff=0

Result:
  Enabling deferred FLUSH achieved 5× the performance of the second
  scenario.

Signed-off-by: Zhou Jifeng <zhoujifeng@kylinos.com.cn>
---
 drivers/md/bcache/bcache_ondisk.h |  1 +
 drivers/md/bcache/request.c       | 19 +++++++++++++++++--
 drivers/md/bcache/sysfs.c         | 29 +++++++++++++++++++++++++++++
 drivers/md/bcache/writeback.c     |  7 +++++++
 drivers/md/bcache/writeback.h     |  3 +++
 5 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/bcache_ondisk.h b/drivers/md/bcache/bcache_ondisk.h
index 6620a7f8fffc..4895217a7fa6 100644
--- a/drivers/md/bcache/bcache_ondisk.h
+++ b/drivers/md/bcache/bcache_ondisk.h
@@ -294,6 +294,7 @@ BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
 #define CACHE_MODE_WRITEBACK		1U
 #define CACHE_MODE_WRITEAROUND		2U
 #define CACHE_MODE_NONE			3U
+BITMASK(BDEV_DEFERRED_FLUSH,		struct cache_sb, flags, 4, 1);
 BITMASK(BDEV_STATE,			struct cache_sb, flags, 61, 2);
 #define BDEV_STATE_NONE			0U
 #define BDEV_STATE_CLEAN		1U
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde1..7fd76bd49237 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1030,7 +1030,11 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
 
-		if (bio->bi_opf & REQ_PREFLUSH) {
+		/* When DEFERRED_FLUSH is enabled, REQ_PREFLUSH is not sent
+		 * to the backend disk. Data security is ensured during the
+		 * writeback phase.
+		 */
+		if ((bio->bi_opf & REQ_PREFLUSH) && !BDEV_DEFERRED_FLUSH(&dc->sb)) {
 			/*
 			 * Also need to send a flush to the backing
 			 * device.
@@ -1066,14 +1070,25 @@ static CLOSURE_CALLBACK(cached_dev_nodata)
 {
 	closure_type(s, struct search, cl);
 	struct bio *bio = &s->bio.bio;
+	struct cached_dev *dc = container_of(s->d, struct cached_dev, disk);
 
-	if (s->iop.flush_journal)
+	if (s->iop.flush_journal) {
 		bch_journal_meta(s->iop.c, cl);
 
+		/* When DEFERRED_FLUSH is turned on, the request is not sent
+		 * to the backend disk.
+		 */
+		if (BDEV_DEFERRED_FLUSH(&dc->sb)) {
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
index e8f696cb58c0..dff84f5bb184 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -151,6 +151,7 @@ rw_attribute(copy_gc_enabled);
 rw_attribute(idle_max_writeback_rate);
 rw_attribute(gc_after_writeback);
 rw_attribute(size);
+rw_attribute(deferred_flush);
 
 static ssize_t bch_snprint_string_list(char *buf,
 				       size_t size,
@@ -283,6 +284,8 @@ SHOW(__bch_cached_dev)
 		return strlen(buf);
 	}
 
+	sysfs_print(deferred_flush,	BDEV_DEFERRED_FLUSH(&dc->sb));
+
 #undef var
 	return 0;
 }
@@ -295,6 +298,7 @@ STORE(__cached_dev)
 	ssize_t v;
 	struct cache_set *c;
 	struct kobj_uevent_env *env;
+	struct bio flush;
 
 	/* no user space access if system is rebooting */
 	if (bcache_is_reboot)
@@ -383,6 +387,12 @@ STORE(__cached_dev)
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
@@ -451,6 +461,24 @@ STORE(__cached_dev)
 	if (attr == &sysfs_stop)
 		bcache_device_stop(&dc->disk);
 
+	if (attr == &sysfs_deferred_flush) {
+		bool deferred_flush = strtoul_or_return(buf);
+
+		if (deferred_flush != BDEV_DEFERRED_FLUSH(&dc->sb)) {
+			if (deferred_flush && (BDEV_CACHE_MODE(&dc->sb) != CACHE_MODE_WRITEBACK)) {
+				pr_err("It's not the writeback mode that can't enable deferred_flush.\n");
+				return size;
+			}
+			SET_BDEV_DEFERRED_FLUSH(&dc->sb, deferred_flush);
+			bch_write_bdev_super(dc, NULL);
+			if (deferred_flush) {
+				bio_init(&flush, dc->bdev, NULL, 0, REQ_OP_WRITE | REQ_PREFLUSH);
+				/* I/O request sent to backing device */
+				submit_bio_wait(&flush);
+			}
+		}
+	}
+
 	return size;
 }
 
@@ -541,6 +569,7 @@ static struct attribute *bch_cached_dev_attrs[] = {
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
index 31df716951f6..1dbecf89fdd3 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -117,6 +117,9 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 				    bio_sectors(bio)))
 		return true;
 
+	if (BDEV_DEFERRED_FLUSH(&dc->sb))
+		return true;
+
 	if (would_skip)
 		return false;
 
-- 
2.18.1


