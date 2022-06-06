Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0353E1DB
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jun 2022 10:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiFFItq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jun 2022 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbiFFIst (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jun 2022 04:48:49 -0400
Received: from mail-m2836.qiye.163.com (mail-m2836.qiye.163.com [103.74.28.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4B816CF47
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jun 2022 01:46:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id 3CC9FC0403;
        Mon,  6 Jun 2022 16:45:23 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     dongsheng.yang@easystack.cn, zoumingzhe@qq.com
Subject: [PATCH] bcache: try to reuse the slot of invalid_uuid
Date:   Mon,  6 Jun 2022 16:45:22 +0800
Message-Id: <20220606084522.12680-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRkfGUxWTE1DSkxMTB9NQ0
        lIVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OT46Pio5ETIKPik2KSEQL0sD
        CzpPCzpVSlVKTU5PTktOSklITENOVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBTkNDSTcG
X-HM-Tid: 0a813830ae38841ekuqw3cc9fc0403
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

Since bcache code was merged into mainline kerrnel, bcache_device_detach()
use invalid_uuid to mark this uuid slot and never use it again.

```
static void bcache_device_detach(struct bcache_device *d)
{
	lockdep_assert_held(&bch_register_lock);

	atomic_dec(&d->c->attached_dev_nr);

	if (test_bit(BCACHE_DEV_DETACHING, &d->flags)) {
		struct uuid_entry *u = d->c->uuids + d->id;

		SET_UUID_FLASH_ONLY(u, 0);
		memcpy(u->uuid, invalid_uuid, 16);
		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
		bch_uuid_write(d->c);
	}

	bcache_device_unlink(d);

	d->c->devices[d->id] = NULL;
	closure_put(&d->c->caching);
	d->c = NULL;
}
```

When the new backing device to call bch_cached_dev_attach(), it will not be
able to find its own uuid from the uuids in cache_set.
Therefore, we have to allocate a new uuid slot via uuid_find_empty().
```
int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
			  uint8_t *set_uuid)
{
	......
	u = uuid_find(c, dc->sb.uuid);

	if (u &&
	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
		memcpy(u->uuid, invalid_uuid, 16);
		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
		u = NULL;
	}

	if (!u) {
		if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
			pr_err("Couldn't find uuid for %pg in set\n", dc->bdev);
			return -ENOENT;
		}

		u = uuid_find_empty(c);
		if (!u) {
			pr_err("Not caching %pg, no room for UUID\n", dc->bdev);
			return -EINVAL;
		}
	}
	......
}
```

However, uuid_find_empty() only scans these zero_uuid slots.
Those invalid_uuid slots will be discarded forever.
```
static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
{
	struct uuid_entry *u;

	for (u = c->uuids;
	     u < c->uuids + c->nr_uuids; u++)
		if (!memcmp(u->uuid, uuid, 16))
			return u;

	return NULL;
}

static struct uuid_entry *uuid_find_empty(struct cache_set *c)
{
	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";

	return uuid_find(c, zero_uuid);
}
```

In fact, the number of uuid slots is limited, and only one bucket can be used.
If we don't reuse these slots, we can only reformat the cache disk. This operation
is too expensive for an online system.
```
	c->nr_uuids		= meta_bucket_bytes(sb) / sizeof(struct uuid_entry);
```

We want to use those invalid_uuid slots carefully. Because, the bkey of the inode
may still exist in the btree. So, we need to check the btree before reuse it.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/btree.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/md/bcache/btree.h |  1 +
 drivers/md/bcache/super.c | 15 ++++++++++++++-
 3 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e136d6edc1ed..a5d54af73111 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2755,6 +2755,41 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 	return ret;
 }
 
+static bool check_pred(struct keybuf *buf, struct bkey *k)
+{
+	return true;
+}
+
+bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode)
+{
+	bool ret = true;
+	struct keybuf_key *k;
+	struct bkey end_key = KEY(inode, MAX_KEY_OFFSET, 0);
+	struct keybuf *keys = kzalloc(sizeof(struct keybuf), GFP_KERNEL);
+
+	if (!keys) {
+		ret = false;
+		goto out;
+	}
+
+	bch_keybuf_init(keys);
+	keys->last_scanned = KEY(inode, 0, 0);
+
+	while (ret) {
+		k = bch_keybuf_next_rescan(c, keys, &end_key, check_pred);
+		if (!k)
+			break;
+
+		if (KEY_INODE(&k->key) == inode)
+			ret = false;
+		bch_keybuf_del(keys, k);
+	}
+
+	kfree(keys);
+out:
+	return ret;
+}
+
 void bch_keybuf_init(struct keybuf *buf)
 {
 	buf->last_scanned	= MAX_KEY;
diff --git a/drivers/md/bcache/btree.h b/drivers/md/bcache/btree.h
index 1b5fdbc0d83e..c3e6094adb62 100644
--- a/drivers/md/bcache/btree.h
+++ b/drivers/md/bcache/btree.h
@@ -413,4 +413,5 @@ struct keybuf_key *bch_keybuf_next_rescan(struct cache_set *c,
 					  struct bkey *end,
 					  keybuf_pred_fn *pred);
 void bch_update_bucket_in_use(struct cache_set *c, struct gc_stat *stats);
+bool bch_btree_can_inode_reuse(struct cache_set *c, size_t inode);
 #endif
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 3563d15dbaf2..31f7aa347561 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -544,11 +544,24 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
 	return NULL;
 }
 
+static struct uuid_entry *uuid_find_reuse(struct cache_set *c)
+{
+	struct uuid_entry *u;
+
+	for (u = c->uuids; u < c->uuids + c->nr_uuids; u++)
+		if (!memcmp(u->uuid, invalid_uuid, 16) &&
+		    bch_btree_can_inode_reuse(c, u - c->uuids))
+			return u;
+
+	return NULL;
+}
+
 static struct uuid_entry *uuid_find_empty(struct cache_set *c)
 {
 	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
+	struct uuid_entry *u = uuid_find(c, zero_uuid);
 
-	return uuid_find(c, zero_uuid);
+	return u ? u : uuid_find_reuse(c);
 }
 
 /*
-- 
2.17.1

