Return-Path: <linux-bcache+bounces-16-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 771287F0BAD
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 06:45:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E69431F2153B
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Nov 2023 05:45:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F56E441D;
	Mon, 20 Nov 2023 05:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="w4eB7p7L";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MrQt+XlE"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C460C139;
	Sun, 19 Nov 2023 21:44:45 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out1.suse.de (Postfix) with ESMTP id E3D8C218E4;
	Mon, 20 Nov 2023 05:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700459083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vHhvNNmpAeUAYOJtecGB8LbIv/k926LdywWbsYsB5Y=;
	b=w4eB7p7Lx8BGDhwajzmyazVKrYfwNIoWHvBg7y22epO7xIJ7M26rpDqt3PRK/GsyrmaYSX
	4eh8sttk2oRUNFrVTowdGjwqZJqHRMBIlSyokxMqBUbJgUVb5xZGSZMRXEGTbO1RulN9Hm
	I5s6N35syM7qf4Ofj0lZ5xBGpi+T+pw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700459083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3vHhvNNmpAeUAYOJtecGB8LbIv/k926LdywWbsYsB5Y=;
	b=MrQt+XlELxNhXJ9QCKu+0hWwXKidlcQOxvU8yC91itNG6ncLFb3GfSJ7RNiLr6Oayf/D1N
	zcnF+k89ZhiH23AA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
	by relay2.suse.de (Postfix) with ESMTP id 5E6B42C6C8;
	Mon, 20 Nov 2023 05:26:20 +0000 (UTC)
From: Coly Li <colyli@suse.de>
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	stable@vger.kernel.org,
	Coly Li <colyli@suse.de>
Subject: [PATCH 06/10] bcache: fixup lock c->root error
Date: Mon, 20 Nov 2023 13:24:59 +0800
Message-Id: <20231120052503.6122-7-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231120052503.6122-1-colyli@suse.de>
References: <20231120052503.6122-1-colyli@suse.de>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++++++++++++++++++++
Authentication-Results: smtp-out1.suse.de;
	dkim=none;
	dmarc=none;
	spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of colyli@suse.de) smtp.mailfrom=colyli@suse.de
X-Rspamd-Server: rspamd1
X-Spamd-Result: default: False [23.09 / 50.00];
	 ARC_NA(0.00)[];
	 BAYES_SPAM(5.10)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 RWL_MAILSPIKE_GOOD(-1.00)[149.44.160.134:from];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.de];
	 R_SPF_SOFTFAIL(4.60)[~all:c];
	 RCPT_COUNT_FIVE(0.00)[6];
	 TO_MATCH_ENVRCPT_SOME(0.00)[];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 MX_GOOD(-0.01)[];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 VIOLATED_DIRECT_SPF(3.50)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_NO_TLS_LAST(0.10)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_COUNT_TWO(0.00)[2];
	 GREYLIST(0.00)[pass,body]
X-Spam-Score: 23.09
X-Rspamd-Queue-Id: E3D8C218E4
X-Spam: Yes

From: Mingzhe Zou <mingzhe.zou@easystack.cn>

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
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 77fb72ac6b81..a1d760916246 100644
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
@@ -997,7 +1005,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 			sectors_dirty_init_fn(&op.op, c->root, k);
 		}
 
-		rw_unlock(0, c->root);
+		rw_unlock(0, b);
 		return;
 	}
 
@@ -1033,7 +1041,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 out:
 	/* Must wait for all threads to stop. */
 	wait_event(state.wait, atomic_read(&state.started) == 0);
-	rw_unlock(0, c->root);
+	rw_unlock(0, b);
 }
 
 void bch_cached_dev_writeback_init(struct cached_dev *dc)
-- 
2.35.3


