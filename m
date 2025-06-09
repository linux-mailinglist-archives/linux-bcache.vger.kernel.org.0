Return-Path: <linux-bcache+bounces-1108-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 720ACAD1F2E
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Jun 2025 15:44:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 283CC167689
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Jun 2025 13:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA48F259C93;
	Mon,  9 Jun 2025 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JStucMNN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903ED13B788;
	Mon,  9 Jun 2025 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476660; cv=none; b=QTeWNH+KDm8sYdBGuBMXXcsqWZcV2DPYyhmeGdWkEDTqFfE42wEl6icESBOwzRgUCBOv7yAUC8Zjpp8axODidmNVPAXF3A0VqTOOtQFLnhxD5hqi+OymsKKQ7EJCWSUlgMY6o1PN5PoLDjbBbInLh6j2o8QnjVzKhlTDwU0c1qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476660; c=relaxed/simple;
	bh=/Ed/KSJA6saTheHpV2DhX4X/PAduwfwsCfonQEPgMCo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H9s+Mm2m2brQ0fdJm9YVF9ESIn+uApZmdwayiSW1q6O/MjgAIYEbzh9WwxLQ9ZzA/ut6GaRM0T+DboOVsvipukkn0ry1Wt6UD0mCnfuUlkO9+hxmWnWHwMaLfOJXQTTWU7HvYs+mvYYYl8zcNp2Qo4lv/pHw2mhceqXtz4rmjq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JStucMNN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1BBC4CEF0;
	Mon,  9 Jun 2025 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476659;
	bh=/Ed/KSJA6saTheHpV2DhX4X/PAduwfwsCfonQEPgMCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JStucMNN2syumRGZqncNPmyxeQqsZ0xtTF2ylcGGIohwojt2M1rrv5h0+RMgwcVP1
	 S3sOh3XKJ3eelTqE4rUICpLkM022k9MksgpjMHbb54rBeVupPwp8pA0OteZOsKI1Q1
	 JW4Q89KHZf2Xggdb+/nGxQJn5yyZOlC/7hoFbPz5gGmctWjxm+Iu+r89ToGpLmuclJ
	 J3GLmGJ5WrhrhvKJeI1/TGgP4YJjraE6j8vitmEzyo5Gn8fO6InitQOuznDTyPD2eB
	 I00YrMXFpTLxde1FnWJvjMrXv2JdpdaWkdkk9N7Z4odL7li0sX4Z7FgxGX2h9C00yX
	 FRjy69Ki+564w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Linggang Zeng <linggang.zeng@easystack.cn>,
	Mingzhe Zou <mingzhe.zou@easystack.cn>,
	Coly Li <colyli@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	kent.overstreet@linux.dev,
	linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 10/35] bcache: fix NULL pointer in cache_set_flush()
Date: Mon,  9 Jun 2025 09:43:26 -0400
Message-Id: <20250609134355.1341953-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Linggang Zeng <linggang.zeng@easystack.cn>

[ Upstream commit 1e46ed947ec658f89f1a910d880cd05e42d3763e ]

1. LINE#1794 - LINE#1887 is some codes about function of
   bch_cache_set_alloc().
2. LINE#2078 - LINE#2142 is some codes about function of
   register_cache_set().
3. register_cache_set() will call bch_cache_set_alloc() in LINE#2098.

 1794 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 1795 {
 ...
 1860         if (!(c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL)) ||
 1861             mempool_init_slab_pool(&c->search, 32, bch_search_cache) ||
 1862             mempool_init_kmalloc_pool(&c->bio_meta, 2,
 1863                                 sizeof(struct bbio) + sizeof(struct bio_vec) *
 1864                                 bucket_pages(c)) ||
 1865             mempool_init_kmalloc_pool(&c->fill_iter, 1, iter_size) ||
 1866             bioset_init(&c->bio_split, 4, offsetof(struct bbio, bio),
 1867                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER) ||
 1868             !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
 1869             !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
 1870                                                 WQ_MEM_RECLAIM, 0)) ||
 1871             bch_journal_alloc(c) ||
 1872             bch_btree_cache_alloc(c) ||
 1873             bch_open_buckets_alloc(c) ||
 1874             bch_bset_sort_state_init(&c->sort, ilog2(c->btree_pages)))
 1875                 goto err;
                      ^^^^^^^^
 1876
 ...
 1883         return c;
 1884 err:
 1885         bch_cache_set_unregister(c);
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 1886         return NULL;
 1887 }
 ...
 2078 static const char *register_cache_set(struct cache *ca)
 2079 {
 ...
 2098         c = bch_cache_set_alloc(&ca->sb);
 2099         if (!c)
 2100                 return err;
                      ^^^^^^^^^^
 ...
 2128         ca->set = c;
 2129         ca->set->cache[ca->sb.nr_this_dev] = ca;
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 ...
 2138         return NULL;
 2139 err:
 2140         bch_cache_set_unregister(c);
 2141         return err;
 2142 }

(1) If LINE#1860 - LINE#1874 is true, then do 'goto err'(LINE#1875) and
    call bch_cache_set_unregister()(LINE#1885).
(2) As (1) return NULL(LINE#1886), LINE#2098 - LINE#2100 would return.
(3) As (2) has returned, LINE#2128 - LINE#2129 would do *not* give the
    value to c->cache[], it means that c->cache[] is NULL.

LINE#1624 - LINE#1665 is some codes about function of cache_set_flush().
As (1), in LINE#1885 call
bch_cache_set_unregister()
---> bch_cache_set_stop()
     ---> closure_queue()
          -.-> cache_set_flush() (as below LINE#1624)

 1624 static void cache_set_flush(struct closure *cl)
 1625 {
 ...
 1654         for_each_cache(ca, c, i)
 1655                 if (ca->alloc_thread)
                          ^^
 1656                         kthread_stop(ca->alloc_thread);
 ...
 1665 }

(4) In LINE#1655 ca is NULL(see (3)) in cache_set_flush() then the
    kernel crash occurred as below:
[  846.712887] bcache: register_cache() error drbd6: cannot allocate memory
[  846.713242] bcache: register_bcache() error : failed to register device
[  846.713336] bcache: cache_set_free() Cache set 2f84bdc1-498a-4f2f-98a7-01946bf54287 unregistered
[  846.713768] BUG: unable to handle kernel NULL pointer dereference at 00000000000009f8
[  846.714790] PGD 0 P4D 0
[  846.715129] Oops: 0000 [#1] SMP PTI
[  846.715472] CPU: 19 PID: 5057 Comm: kworker/19:16 Kdump: loaded Tainted: G           OE    --------- -  - 4.18.0-147.5.1.el8_1.5es.3.x86_64 #1
[  846.716082] Hardware name: ESPAN GI-25212/X11DPL-i, BIOS 2.1 06/15/2018
[  846.716451] Workqueue: events cache_set_flush [bcache]
[  846.716808] RIP: 0010:cache_set_flush+0xc9/0x1b0 [bcache]
[  846.717155] Code: 00 4c 89 a5 b0 03 00 00 48 8b 85 68 f6 ff ff a8 08 0f 84 88 00 00 00 31 db 66 83 bd 3c f7 ff ff 00 48 8b 85 48 ff ff ff 74 28 <48> 8b b8 f8 09 00 00 48 85 ff 74 05 e8 b6 58 a2 e1 0f b7 95 3c f7
[  846.718026] RSP: 0018:ffffb56dcf85fe70 EFLAGS: 00010202
[  846.718372] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[  846.718725] RDX: 0000000000000001 RSI: 0000000040000001 RDI: 0000000000000000
[  846.719076] RBP: ffffa0ccc0f20df8 R08: ffffa0ce1fedb118 R09: 000073746e657665
[  846.719428] R10: 8080808080808080 R11: 0000000000000000 R12: ffffa0ce1fee8700
[  846.719779] R13: ffffa0ccc0f211a8 R14: ffffa0cd1b902840 R15: ffffa0ccc0f20e00
[  846.720132] FS:  0000000000000000(0000) GS:ffffa0ce1fec0000(0000) knlGS:0000000000000000
[  846.720726] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  846.721073] CR2: 00000000000009f8 CR3: 00000008ba00a005 CR4: 00000000007606e0
[  846.721426] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  846.721778] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  846.722131] PKRU: 55555554
[  846.722467] Call Trace:
[  846.722814]  process_one_work+0x1a7/0x3b0
[  846.723157]  worker_thread+0x30/0x390
[  846.723501]  ? create_worker+0x1a0/0x1a0
[  846.723844]  kthread+0x112/0x130
[  846.724184]  ? kthread_flush_work_fn+0x10/0x10
[  846.724535]  ret_from_fork+0x35/0x40

Now, check whether that ca is NULL in LINE#1655 to fix the issue.

Signed-off-by: Linggang Zeng <linggang.zeng@easystack.cn>
Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
Signed-off-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/r/20250527051601.74407-2-colyli@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Severity and Impact

This commit fixes a **NULL pointer dereference** in the bcache subsystem
that causes a kernel crash. The crash trace shows:

```
BUG: unable to handle kernel NULL pointer dereference at
00000000000009f8
```

The crash occurs during cache set registration failure in an out-of-
memory (OOM) condition, which is a real-world scenario that can happen
in production systems under memory pressure.

## Root Cause Analysis

The commit message provides excellent debugging information showing the
precise execution flow:

1. In `bch_cache_set_alloc()`, if memory allocation fails (lines
   1860-1874), it goes to the error path which calls
   `bch_cache_set_unregister()` and returns NULL
2. In `register_cache_set()`, when `bch_cache_set_alloc()` returns NULL,
   the function returns early (line 2100)
3. Because of the early return, `ca->set` is never assigned (lines
   2128-2129), leaving `c->cache[]` as NULL
4. When `cache_set_flush()` is called via the closure mechanism, it
   tries to access `ca->alloc_thread` where `ca` is NULL, causing the
   crash

## Code Change Analysis

The fix is minimal and surgical:

```diff
- if (ca->alloc_thread)
+       /*
+        * If the register_cache_set() call to bch_cache_set_alloc()
failed,
+        * ca has not been assigned a value and return error.
+        * So we need check ca is not NULL during
bch_cache_set_unregister().
+        */
+       if (ca && ca->alloc_thread)
                kthread_stop(ca->alloc_thread);
```

This adds a NULL check before dereferencing `ca`, which is a defensive
programming practice that prevents the crash.

## Comparison with Similar Commits

Looking at the similar commits with "Backport Status: YES":

1. **Similar commits #1, #2, #3**: All fix NULL pointer dereferences in
   bcache during OOM conditions
2. **Similar commits #4, #5**: Fix potential NULL pointer issues in
   btree node allocation
3. All these commits share characteristics:
   - Fix real crashes with clear reproducers
   - Minimal code changes (often just adding NULL checks)
   - No architectural changes
   - No new features
   - Clear bug fixes in error paths

## Stable Tree Criteria Assessment

This commit meets all the stable tree criteria:

1. **Fixes a real bug**: Yes - NULL pointer dereference causing kernel
   crash
2. **Already in Linus' tree**: Yes - has been merged by Jens Axboe
3. **Small and contained**: Yes - single line change adding NULL check
4. **No new features**: Correct - purely a bug fix
5. **Minimal risk**: Very low risk - adds defensive NULL check
6. **Clear issue**: The crash trace and detailed analysis make the issue
   crystal clear

## Additional Considerations

- The bug occurs in an error path during OOM conditions, which might be
  considered rare but is definitely possible in production
- The fix prevents a kernel crash, which is always high priority for
  stable backports
- The bcache subsystem is used in production systems for caching, making
  stability critical
- The fix pattern (adding NULL checks in error paths) is well-
  established and safe

## Conclusion

This commit is an excellent candidate for stable backporting. It fixes a
real kernel crash with a minimal, safe change that adds proper NULL
checking in an error path. The detailed commit message with line-by-line
analysis demonstrates thorough understanding of the issue, and the fix
follows established patterns seen in other successful bcache stable
backports.

 drivers/md/bcache/super.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 813b38aec3e4e..37f5e31618c0a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1733,7 +1733,12 @@ static CLOSURE_CALLBACK(cache_set_flush)
 			mutex_unlock(&b->write_lock);
 		}
 
-	if (ca->alloc_thread)
+	/*
+	 * If the register_cache_set() call to bch_cache_set_alloc() failed,
+	 * ca has not been assigned a value and return error.
+	 * So we need check ca is not NULL during bch_cache_set_unregister().
+	 */
+	if (ca && ca->alloc_thread)
 		kthread_stop(ca->alloc_thread);
 
 	if (c->journal.cur) {
-- 
2.39.5


