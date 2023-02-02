Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D814687397
	for <lists+linux-bcache@lfdr.de>; Thu,  2 Feb 2023 04:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjBBDEE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 Feb 2023 22:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjBBDD5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 Feb 2023 22:03:57 -0500
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7027AE48
        for <linux-bcache@vger.kernel.org>; Wed,  1 Feb 2023 19:03:21 -0800 (PST)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id C35F16202B4;
        Thu,  2 Feb 2023 11:02:33 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, andrea.tomassetti-opensource@devo.com,
        bcache@lists.ewheeler.net
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        zoumingzhe@qq.com, Dongsheng Yang <dongsheng.yang@easystack.cn>,
        mingzhe <mingzhe.zou@easystack.cn>
Subject: [PATCH v2 2/3] bcache: submit writeback inflight dirty writes in batch
Date:   Thu,  2 Feb 2023 11:02:20 +0800
Message-Id: <20230202030221.14397-2-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202030221.14397-1-mingzhe.zou@easystack.cn>
References: <20230202030221.14397-1-mingzhe.zou@easystack.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTElJVh5CGhpJGUMaS0xNH1UZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpISkJIS1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M1E6MQw4IjJRDxASIkIBAx9N
        ORhPCwlVSlVKTUxOSEtNQk5PTk5IVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBQ0tNTjcG
X-HM-Tid: 0a8610136d4200a4kurmc35f16202b4
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dongsheng Yang <dongsheng.yang@easystack.cn>

If we have a backing device of log-structured block device (such as bcache flash dev),
there is a possibility to merge the writes in writeback, as the all writes into bcache flash_dev
are stored in bucket as log-structured.

That means, if we have a cached_dev as below:
        ----------------------------
        | bcache2 (cached_dev)     |
        | ------------------------ |
        | |   sdb (cache_dev)    | |
        | ------------------------ |
        | ------------------------ |
        | |   bcache1 (flash_dev)| |
        | ------------------------ |
        ----------------------------

we can merge the dirty writes in writeback, if we can submit the dirty writes in batch and around start_plug/finish_plug.

So this commit change the dirty_write to add the a dirty_io into a rb_tree, and queue a worker to submit all dirty_io,
This provide a timing to merge these writes, which can improve the writeback bandwidth.

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/bcache.h    |   4 ++
 drivers/md/bcache/writeback.c | 102 ++++++++++++++++++++++------------
 2 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 74434a7730bb..a82974aefc90 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -356,6 +356,10 @@ struct cached_dev {
 	struct closure_waitlist writeback_ordering_wait;
 	atomic_t		writeback_sequence_next;
 
+	struct rb_root		writeback_ios;
+	spinlock_t		writeback_ios_lock;
+	struct work_struct	write_dirty_work;
+
 	/* For tracking sequential IO */
 #define RECENT_IO_BITS	7
 #define RECENT_IO	(1 << RECENT_IO_BITS)
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 0c5f25816e2e..315fb91a8066 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -323,6 +323,7 @@ struct dirty_io {
 	struct closure		cl;
 	struct cached_dev	*dc;
 	uint16_t		sequence;
+	struct rb_node		node;
 	struct bio		bio;
 };
 
@@ -401,53 +402,81 @@ static void dirty_endio(struct bio *bio)
 	closure_put(&io->cl);
 }
 
-static void write_dirty(struct closure *cl)
+static inline int dirty_io_cmp(struct dirty_io *l, struct dirty_io *r)
+{
+	return (l->sequence < r->sequence) ? -1 : (l->sequence > r->sequence);
+}
+
+static void queue_dirty_write(struct closure *cl)
 {
 	struct dirty_io *io = container_of(cl, struct dirty_io, cl);
-	struct keybuf_key *w = io->bio.bi_private;
 	struct cached_dev *dc = io->dc;
 
-	uint16_t next_sequence;
+	spin_lock(&dc->writeback_ios_lock);
+	BUG_ON(RB_INSERT(&dc->writeback_ios, io, node, dirty_io_cmp));
+	spin_unlock(&dc->writeback_ios_lock);
 
-	if (atomic_read(&dc->writeback_sequence_next) != io->sequence) {
-		/* Not our turn to write; wait for a write to complete */
-		closure_wait(&dc->writeback_ordering_wait, cl);
+	queue_work(dc->writeback_write_wq, &dc->write_dirty_work);
+}
 
-		if (atomic_read(&dc->writeback_sequence_next) == io->sequence) {
-			/*
-			 * Edge case-- it happened in indeterminate order
-			 * relative to when we were added to wait list..
-			 */
-			closure_wake_up(&dc->writeback_ordering_wait);
-		}
+static void write_dirty(struct work_struct *work)
+{
+	struct cached_dev *dc = container_of(work, struct cached_dev,
+						write_dirty_work);
+	struct dirty_io *io;
+	struct keybuf_key *w;
+	uint16_t next_sequence;
+	struct blk_plug plug;
 
-		continue_at(cl, write_dirty, io->dc->writeback_write_wq);
+	spin_lock(&dc->writeback_ios_lock);
+	if (RB_EMPTY_ROOT(&dc->writeback_ios)) {
+		spin_unlock(&dc->writeback_ios_lock);
 		return;
 	}
 
-	next_sequence = io->sequence + 1;
+	io = RB_FIRST(&dc->writeback_ios, struct dirty_io, node);
+	if (io->sequence != atomic_read(&dc->writeback_sequence_next)) {
+		spin_unlock(&dc->writeback_ios_lock);
+		return;
+	}
 
-	/*
-	 * IO errors are signalled using the dirty bit on the key.
-	 * If we failed to read, we should not attempt to write to the
-	 * backing device.  Instead, immediately go to write_dirty_finish
-	 * to clean up.
-	 */
-	if (KEY_DIRTY(&w->key)) {
-		dirty_init(w);
-		io->bio.bi_opf = REQ_OP_WRITE;
-		io->bio.bi_iter.bi_sector = KEY_START(&w->key);
-		bio_set_dev(&io->bio, io->dc->bdev);
-		io->bio.bi_end_io	= dirty_endio;
-
-		/* I/O request sent to backing device */
-		closure_bio_submit(io->dc->disk.c, &io->bio, cl);
+	blk_start_plug(&plug);
+	next_sequence = io->sequence;
+
+	while(io) {
+		if (io->sequence != next_sequence)
+			break;
+
+		rb_erase(&io->node, &dc->writeback_ios);
+		spin_unlock(&dc->writeback_ios_lock);
+		w = io->bio.bi_private;
+		/*
+		 * IO errors are signalled using the dirty bit on the key.
+		 * If we failed to read, we should not attempt to write to the
+		 * backing device.  Instead, immediately go to write_dirty_finish
+		 * to clean up.
+		 */
+		if (KEY_DIRTY(&w->key)) {
+			dirty_init(w);
+			io->bio.bi_opf = REQ_OP_WRITE;
+			io->bio.bi_iter.bi_sector = KEY_START(&w->key);
+			bio_set_dev(&io->bio, io->dc->bdev);
+			io->bio.bi_end_io	= dirty_endio;
+
+			/* I/O request sent to backing device */
+			closure_bio_submit(io->dc->disk.c, &io->bio, &io->cl);
+		}
+
+		continue_at(&io->cl, write_dirty_finish, io->dc->writeback_write_wq);
+
+		spin_lock(&dc->writeback_ios_lock);
+		io = RB_FIRST(&dc->writeback_ios, struct dirty_io, node);
+		next_sequence++;
 	}
 
 	atomic_set(&dc->writeback_sequence_next, next_sequence);
-	closure_wake_up(&dc->writeback_ordering_wait);
-
-	continue_at(cl, write_dirty_finish, io->dc->writeback_write_wq);
+	spin_unlock(&dc->writeback_ios_lock);
+	blk_finish_plug(&plug);
 }
 
 static void read_dirty_endio(struct bio *bio)
@@ -469,7 +498,7 @@ static void read_dirty_submit(struct closure *cl)
 
 	closure_bio_submit(io->dc->disk.c, &io->bio, cl);
 
-	continue_at(cl, write_dirty, io->dc->writeback_write_wq);
+	continue_at(cl, queue_dirty_write, io->dc->writeback_write_wq);
 }
 
 static void start_wb_inflight(struct cached_dev *dc)
@@ -578,6 +607,7 @@ static void read_dirty(struct cached_dev *dc)
 			w->private	= io;
 			io->dc		= dc;
 			io->sequence    = sequence++;
+			RB_CLEAR_NODE(&io->node);
 
 			dirty_init(w);
 			io->bio.bi_opf = REQ_OP_READ;
@@ -1066,6 +1096,10 @@ void bch_cached_dev_writeback_init(struct cached_dev *dc)
 	init_rwsem(&dc->writeback_lock);
 	bch_keybuf_init(&dc->writeback_keys);
 
+	spin_lock_init(&dc->writeback_ios_lock);
+	dc->writeback_ios		= RB_ROOT;
+	INIT_WORK(&dc->write_dirty_work, write_dirty);
+
 	dc->writeback_metadata		= true;
 	dc->writeback_running		= false;
 	dc->writeback_consider_fragment = true;
-- 
2.17.1

