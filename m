Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CA579810B
	for <lists+linux-bcache@lfdr.de>; Fri,  8 Sep 2023 05:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbjIHDuC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Sep 2023 23:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjIHDuC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Sep 2023 23:50:02 -0400
X-Greylist: delayed 504 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Sep 2023 20:49:57 PDT
Received: from mail-m49204.qiye.163.com (mail-m49204.qiye.163.com [45.254.49.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1BC1BDA;
        Thu,  7 Sep 2023 20:49:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3174.qiye.163.com (Hmail) with ESMTPA id A17034023A;
        Fri,  8 Sep 2023 11:41:22 +0800 (CST)
From:   Mingzhe Zou <mingzhe.zou@easystack.cn>
To:     colyli@suse.de, bcache@lists.ewheeler.net
Cc:     linux-bcache@vger.kernel.org, zoumingzhe@qq.com,
        Mingzhe Zou <mingzhe.zou@easystack.cn>, stable@vger.kernel.org
Subject: [PATCH v2] bcache: fixup lock c->root error
Date:   Fri,  8 Sep 2023 11:41:08 +0800
Message-Id: <20230908034108.405-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaTRpDVklPT0oYTklLSE8fTlUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Tid: 0a8a72e14e8b00aekurma17034023a
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PE06ERw6EDE2NVYdDggLCh82
        SjpPClZVSlVKTUJPSk9PT0NIT0JPVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTU5DTTcG
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We had a problem with io hung because it was waiting for c->root to
release the lock.

crash> cache_set.root -l cache_set.list ffffa03fde4c0050
  root = 0xffff802ef454c800
crash> btree -o 0xffff802ef454c800 | grep rw_semaphore
  [ffff802ef454c858] struct rw_semaphore lock;
crash> struct rw_semaphore ffff802ef454c858
struct rw_semaphore {
  count = {
    counter = -4294967297
  },
  wait_list = {
    next = 0xffff00006786fc28,
    prev = 0xffff00005d0efac8
  },
  wait_lock = {
    raw_lock = {
      {
        val = {
          counter = 0
        },
        {
          locked = 0 '\000',
          pending = 0 '\000'
        },
        {
          locked_pending = 0,
          tail = 0
        }
      }
    }
  },
  osq = {
    tail = {
      counter = 0
    }
  },
  owner = 0xffffa03fdc586603
}

The "counter = -4294967297" means that lock count is -1 and a write lock
is being attempted. Then, we found that there is a btree with a counter
of 1 in btree_cache_freeable.

crash> cache_set -l cache_set.list ffffa03fde4c0050 -o|grep btree_cache
  [ffffa03fde4c1140] struct list_head btree_cache;
  [ffffa03fde4c1150] struct list_head btree_cache_freeable;
  [ffffa03fde4c1160] struct list_head btree_cache_freed;
  [ffffa03fde4c1170] unsigned int btree_cache_used;
  [ffffa03fde4c1178] wait_queue_head_t btree_cache_wait;
  [ffffa03fde4c1190] struct task_struct *btree_cache_alloc_lock;
crash> list -H ffffa03fde4c1140|wc -l
973
crash> list -H ffffa03fde4c1150|wc -l
1123
crash> cache_set.btree_cache_used -l cache_set.list ffffa03fde4c0050
  btree_cache_used = 2097
crash> list -s btree -l btree.list -H ffffa03fde4c1140|grep -E -A2 "^  lock = {" > btree_cache.txt
crash> list -s btree -l btree.list -H ffffa03fde4c1150|grep -E -A2 "^  lock = {" > btree_cache_freeable.txt
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# pwd
/var/crash/127.0.0.1-2023-08-04-16:40:28
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# cat btree_cache.txt|grep counter|grep -v "counter = 0"
[root@node-3 127.0.0.1-2023-08-04-16:40:28]# cat btree_cache_freeable.txt|grep counter|grep -v "counter = 0"
      counter = 1

We found that this is a bug in bch_sectors_dirty_init() when locking c->root:
    (1). Thread X has locked c->root(A) write.
    (2). Thread Y failed to lock c->root(A), waiting for the lock(c->root A).
    (3). Thread X bch_btree_set_root() changes c->root from A to B.
    (4). Thread X releases the lock(c->root A).
    (5). Thread Y successfully locks c->root(A).
    (6). Thread Y releases the lock(c->root B).

        down_write locked ---(1)----------------------┐
                |                                     |
                |   down_read waiting ---(2)----┐     |
                |           |               ┌-------------┐ ┌-------------┐
        bch_btree_set_root ===(3)========>> | c->root   A | | c->root   B |
                |           |               └-------------┘ └-------------┘
            up_write ---(4)---------------------┘     |            |
                            |                         |            |
                    down_read locked ---(5)-----------┘            |
                            |                                      |
                        up_read ---(6)-----------------------------┘

Since c->root may change, the correct steps to lock c->root should be
the same as bch_root_usage(), compare after locking.

static unsigned int bch_root_usage(struct cache_set *c)
{
        unsigned int bytes = 0;
        struct bkey *k;
        struct btree *b;
        struct btree_iter iter;

        goto lock_root;

        do {
                rw_unlock(false, b);
lock_root:
                b = c->root;
                rw_lock(false, b, b->level);
        } while (b != c->root);

        for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
                bytes += bkey_bytes(k);

        rw_unlock(false, b);

        return (bytes * 100) / btree_bytes(c);
}

Fixes: b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Cc: stable@vger.kernel.org
---
 drivers/md/bcache/writeback.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..bac916ba08c8 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -977,14 +977,22 @@ static int bch_btre_dirty_init_thread_nr(void)
 void bch_sectors_dirty_init(struct bcache_device *d)
 {
 	int i;
+	struct btree *b = NULL;
 	struct bkey *k = NULL;
 	struct btree_iter iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
 
+retry_lock:
+	b = c->root;
+	rw_lock(0, b, b->level);
+	if (b != c->root) {
+		rw_unlock(0, b);
+		goto retry_lock;
+	}
+
 	/* Just count root keys if no leaf node */
-	rw_lock(0, c->root, c->root->level);
 	if (c->root->level == 0) {
 		bch_btree_op_init(&op.op, -1);
 		op.inode = d->id;
@@ -994,7 +1002,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 				    k, &iter, bch_ptr_invalid)
 			sectors_dirty_init_fn(&op.op, c->root, k);
 
-		rw_unlock(0, c->root);
+		rw_unlock(0, b);
 		return;
 	}
 
@@ -1030,7 +1038,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 out:
 	/* Must wait for all threads to stop. */
 	wait_event(state.wait, atomic_read(&state.started) == 0);
-	rw_unlock(0, c->root);
+	rw_unlock(0, b);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
-- 
2.17.1.windows.2

