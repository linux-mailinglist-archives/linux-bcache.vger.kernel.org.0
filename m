Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9554441240
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Nov 2021 04:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhKADFH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 31 Oct 2021 23:05:07 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:41957
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S230233AbhKADFG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 31 Oct 2021 23:05:06 -0400
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewCH3c3BWH9hznwAAA--.2824S2;
        Mon, 01 Nov 2021 11:02:30 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: make checkings for sb.nr_in_set and sb.nr_this_dev
Date:   Mon,  1 Nov 2021 11:02:24 +0800
Message-Id: <20211101030224.8152-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewCH3c3BWH9hznwAAA--.2824S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW5tr1xKFy3Ww4fuF47twb_yoW8AFyfpF
        ZrZrySy34kZa15AryDAr48uFyrG343KayUGas2yas5Za4ava4rAFW7KryUAr1rWrWfXFsr
        tws8tryDWFykGFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 697e23495c94f0380c1ed8b11f830b92b64c99ea
("bcache: explicitly make cache_set only have single cache")
explicitly makes a cache_set only have single cache and based on the
fact that historily only one cache is ever used in the cache set, so
valid number fo sb.nr_in_set should be 1 and sb.nr_this_dev should
always be 0.

Based on above truth, codes validations for sb.nr_in_set and sb.nr_this_dev
can make to be more accurate, that means tolerance for error checking
are reduced comparing before.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/bcache.h | 2 +-
 drivers/md/bcache/super.c  | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5fc989a6d452..a4a410a178c0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -833,7 +833,7 @@ static inline uint8_t ptr_stale(struct cache_set *c, const struct bkey *k,
 static inline bool ptr_available(struct cache_set *c, const struct bkey *k,
 				 unsigned int i)
 {
-	return (PTR_DEV(k, i) < MAX_CACHES_PER_SET) && c->cache;
+	return (PTR_DEV(k, i) == 0) && c->cache;
 }
 
 /* Btree key macros */
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff79..2253044c9289 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -140,9 +140,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
 		goto err;
 
 	err = "Bad cache device number in set";
-	if (!sb->nr_in_set ||
-	    sb->nr_in_set <= sb->nr_this_dev ||
-	    sb->nr_in_set > MAX_CACHES_PER_SET)
+	if (sb->nr_in_set != 1 || sb->nr_this_dev != 0)
 		goto err;
 
 	err = "Journal buckets not sequential";
-- 
2.31.1

