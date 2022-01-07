Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6970948740E
	for <lists+linux-bcache@lfdr.de>; Fri,  7 Jan 2022 09:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345739AbiAGIVV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 Jan 2022 03:21:21 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:38568 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345731AbiAGIVU (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 Jan 2022 03:21:20 -0500
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id E3E0CC01D2;
        Fri,  7 Jan 2022 16:21:15 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     axboe@kernel.dk, colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, bcache@lists.ewheeler.net
Subject: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
Date:   Fri,  7 Jan 2022 16:21:13 +0800
Message-Id: <20220107082113.18480-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRpOSxpWTh9CTB5NTR5KSh
        8eVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Oj46Agw*NTI2MzlPAxURDwIT
        MCoKCxZVSlVKTU9KTk9ITUxNTU1MVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSEpISTcG
X-HM-Tid: 0a7e33a0b218841ekuqwe3e0cc01d2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Zou Mingzhe <mingzhe.zou@easystack.cn>

When attaching a cached device (a.k.a backing device) to a cache
device, bch_sectors_dirty_init() is called to count dirty sectors
and stripes (see what bcache_dev_sectors_dirty_add() does) on the
cache device.

When bcache_dev_sectors_dirty_add() is called, set_bit(stripe,
d->full_dirty_stripes) or clear_bit(stripe, d->full_dirty_stripes)
operation will always be performed. In full_dirty_stripes, each 1bit
represents stripe_size (8192) sectors (512B), so 1bit=4MB (8192*512),
and each CPU cache line=64B=512bit=2048MB. When 20 threads process
a cached disk with 100G dirty data, a single thread processes about
23M at a time, and 20 threads total 460M. These full_dirty_stripes
bits corresponding to the 460M data is likely to fall in the same CPU
cache line. When one of these threads performs a set_bit or clear_bit
operation, the same CPU cache line of other threads will become invalid
and must read the full_dirty_stripes from the main memory again. Compared
with single thread, the time of a bcache_dev_sectors_dirty_add()
call is increased by about 50 times in our test (100G dirty data,
20 threads, bcache_dev_sectors_dirty_add() is called more than
20 million times).

This patch tries to test_bit before set_bit or clear_bit operation.
Therefore, a lot of force set and clear operations will be avoided,
and most of bcache_dev_sectors_dirty_add() calls will only read CPU
cache line.

Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/writeback.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 68e75c692dd4..4afe22875d4f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -596,10 +596,13 @@ void bcache_dev_sectors_dirty_add(struct cache_set *c, unsigned int inode,
 
 		sectors_dirty = atomic_add_return(s,
 					d->stripe_sectors_dirty + stripe);
-		if (sectors_dirty == d->stripe_size)
-			set_bit(stripe, d->full_dirty_stripes);
-		else
-			clear_bit(stripe, d->full_dirty_stripes);
+		if (sectors_dirty == d->stripe_size) {
+			if (!test_bit(stripe, d->full_dirty_stripes))
+				set_bit(stripe, d->full_dirty_stripes);
+		} else {
+			if (test_bit(stripe, d->full_dirty_stripes))
+				clear_bit(stripe, d->full_dirty_stripes);
+		}
 
 		nr_sectors -= s;
 		stripe_offset = 0;
-- 
2.17.1

