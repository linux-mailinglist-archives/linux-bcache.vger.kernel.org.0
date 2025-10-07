Return-Path: <linux-bcache+bounces-1213-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62925BC0DAE
	for <lists+linux-bcache@lfdr.de>; Tue, 07 Oct 2025 11:27:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3110B1896540
	for <lists+linux-bcache@lfdr.de>; Tue,  7 Oct 2025 09:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 739AA256C84;
	Tue,  7 Oct 2025 09:27:42 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8D8253F13
	for <linux-bcache@vger.kernel.org>; Tue,  7 Oct 2025 09:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759829262; cv=none; b=VvGdtpAkiEAdCI/LAmPO2TXUgI2An+nRhNLWmZ/6DsfMiu/GbntlqPGv7N2tLTnNeyOe5enIdy1woQ10YIFxkwaUzOxmGjhcLZSRc61vW2FmuP1tMQvA7e1srFRgaPrjX4YT8A2W9dI8yQ6e0MHiQHhsKhCy133z4XIoKtVXbhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759829262; c=relaxed/simple;
	bh=fmeSs+QEP+BD0poKfLDAcJ1JL/pa/5yBR6e8+n7nzBU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Xbrr5pbd0CTLnoz4H5Z7nLH9SGX5ZMp+XT6PCk66HMeKpArvSCtrQFtT4iKXIb8T6y/q4/4wzTi35EuwR4mqNskjvrkwkGUQi7dzGx3AY+gaJR3qlAj1n5ekJv9LSOtZWLWyvYGZ6wxsA8OBf1csBAYzrNCS1aM1K13tHXqKBnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EBFC4CEF1;
	Tue,  7 Oct 2025 09:27:40 +0000 (UTC)
From: colyli@fnnas.com
To: linux-bcache@vger.kernel.org
Cc: Coly Li <colyli@fnnas.com>
Subject: [PATCH] bcache: improve writeback throughput when frontend I/O is idle
Date: Tue,  7 Oct 2025 17:27:28 +0800
Message-ID: <20251007092728.30534-1-colyli@fnnas.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Coly Li <colyli@fnnas.com>

Currently in order to write dirty blocks to backend device in LBA order
for better performance, inside write_dirty() the I/O is issued only when
its sequence matches current expected sequence. Otherwise the kworker
will repeat check-wait-woken loop until the sequence number matches.

When frontend I/O is idle, the writeback rate is set to INT_MAX, but the
writeback thoughput doesn't increase much. There are two reasons,
- The check-wait-woken loop is inefficient.
- I/O depth on backing device is low.

To improve the writeback throughput, this patch does two things,
- Remove the check-wait-woken cycle from write_dirty()
  In read_dirty(), the read dirty bios are issued in LBA order and they
  are not completed in issue orders. The check-wait-woken loop makes
  sure these bios are ordered in LBA order again and issued to backing
  device, but indeed it is unncessary now. When all the bios are issued
  in a reasonable time windows, they can be properly merged or sorted by
  LBA address. mq-deadline does such stuff perfectly in benchmark, and
  bfq is just a bit less than mq-deadline, but all are much better than
  current check-wait-woken loops.

- Read more dirty keys when frontend I/O is idle
  Define WRITEBACKS_IN_PASS (5), MAX_WRITEBACKS_IN_PASS (30) for write-
  back dirty keys in each pass, and define WRITESIZE_IN_PASS (5000) and
  MAX_WRITESIZE_IN_PASS (30000) for total writeback data size in each
  pass. When frontend I/O is idle, new values MAX_WRITEBACKS_IN_PASS and
  MAX_WRITESIZE_IN_PASS are used to issue more read-dirty bios on cache
  device and in true issue more writeback bios on backing device.

On an 8 component disks md raid5 array, after applying this patch and
when there is no frontend I/O for a while, the writeback throughput on
backing device increases from 4MiB/s to 8MiB/s (because all cached dirty
blocks are 4KiB), queue depth on the md raid5 array roughly increases
from 21 to 55, and on each component disk the queue depth roughly
increases from 1.5 to 4.5.

Thanks to the developers of mq-deadline and bfq schedulers in these
years.

Signed-off-by: Coly Li <colyli@fnnas.com>
---
 drivers/md/bcache/writeback.c | 57 ++++++++---------------------------
 drivers/md/bcache/writeback.h |  6 ++--
 2 files changed, 17 insertions(+), 46 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e6c548e83ff1..20edde7152bf 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -322,7 +322,6 @@ static unsigned int writeback_delay(struct cached_dev *dc,
 struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
-	uint16_t		sequence;
 	struct bio		bio;
 };
 
@@ -405,27 +404,6 @@ static CLOSURE_CALLBACK(write_dirty)
 {
 	closure_type(io, struct dirty_io, cl);
 	struct keybuf_key *w = io->bio.bi_private;
-	struct cached_dev *dc = io->dc;
-
-	uint16_t next_sequence;
-
-	if (atomic_read(&dc->writeback_sequence_next) != io->sequence) {
-		/* Not our turn to write; wait for a write to complete */
-		closure_wait(&dc->writeback_ordering_wait, cl);
-
-		if (atomic_read(&dc->writeback_sequence_next) == io->sequence) {
-			/*
-			 * Edge case-- it happened in indeterminate order
-			 * relative to when we were added to wait list..
-			 */
-			closure_wake_up(&dc->writeback_ordering_wait);
-		}
-
-		continue_at(cl, write_dirty, io->dc->writeback_write_wq);
-		return;
-	}
-
-	next_sequence = io->sequence + 1;
 
 	/*
 	 * IO errors are signalled using the dirty bit on the key.
@@ -444,9 +422,6 @@ static CLOSURE_CALLBACK(write_dirty)
 		closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 	}
 
-	atomic_set(&dc->writeback_sequence_next, next_sequence);
-	closure_wake_up(&dc->writeback_ordering_wait);
-
 	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
 }
 
@@ -482,10 +457,7 @@ static void read_dirty(struct cached_dev *dc)
 	int nk, i;
 	struct dirty_io *io;
 	struct closure cl;
-	uint16_t sequence = 0;
 
-	BUG_ON(!llist_empty(&dc->writeback_ordering_wait.list));
-	atomic_set(&dc->writeback_sequence_next, sequence);
 	closure_init_stack(&cl);
 
 	/*
@@ -502,6 +474,9 @@ static void read_dirty(struct cached_dev *dc)
 	while (!kthread_should_stop() &&
 	       !test_bit(CACHE_SET_IO_DISABLE, &dc->disk.c->flags) &&
 	       (checked < dump_nr)) {
+		size_t max_size_in_pass;
+		int max_writebacks_in_pass;
+
 		size = 0;
 		nk = 0;
 
@@ -509,31 +484,26 @@ static void read_dirty(struct cached_dev *dc)
 			w = dump_keys[checked];
 			BUG_ON(ptr_stale(dc->disk.c, &w->key, 0));
 
+			if (!atomic_read(&dc->disk.c->at_max_writeback_rate)) {
+				max_writebacks_in_pass = WRITEBACKS_IN_PASS;
+				max_size_in_pass = WRITESIZE_IN_PASS;
+			} else {
+				max_writebacks_in_pass = MAX_WRITEBACKS_IN_PASS;
+				max_size_in_pass = MAX_WRITESIZE_IN_PASS;
+			}
+
 			/*
 			 * Don't combine too many operations, even if they
 			 * are all small.
 			 */
-			if (nk >= MAX_WRITEBACKS_IN_PASS)
+			if (nk >= max_writebacks_in_pass)
 				break;
 
 			/*
 			 * If the current operation is very large, don't
 			 * further combine operations.
 			 */
-			if (size >= MAX_WRITESIZE_IN_PASS)
-				break;
-
-			/*
-			 * Operations are only eligible to be combined
-			 * if they are contiguous.
-			 *
-			 * TODO: add a heuristic willing to fire a
-			 * certain amount of non-contiguous IO per pass,
-			 * so that we can benefit from backing device
-			 * command queueing.
-			 */
-			if ((nk != 0) && bkey_cmp(&keys[nk-1]->key,
-						&START_KEY(&w->key)))
+			if (size >= max_size_in_pass)
 				break;
 
 			size += KEY_SIZE(&w->key);
@@ -552,7 +522,6 @@ static void read_dirty(struct cached_dev *dc)
 
 			w->private	= io;
 			io->dc		= dc;
-			io->sequence    = sequence++;
 
 			dirty_init(w);
 			io->bio.bi_opf = REQ_OP_READ;
diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 31df716951f6..fa7582df1ac2 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -8,8 +8,10 @@
 #define CUTOFF_WRITEBACK_MAX		70
 #define CUTOFF_WRITEBACK_SYNC_MAX	90
 
-#define MAX_WRITEBACKS_IN_PASS  5
-#define MAX_WRITESIZE_IN_PASS   5000	/* *512b */
+#define WRITEBACKS_IN_PASS	5
+#define MAX_WRITEBACKS_IN_PASS	30
+#define WRITESIZE_IN_PASS	5000	/* *512b */
+#define MAX_WRITESIZE_IN_PASS	30000	/* *512b */
 
 #define WRITEBACK_RATE_UPDATE_SECS_MAX		60
 #define WRITEBACK_RATE_UPDATE_SECS_DEFAULT	5
-- 
2.39.5


