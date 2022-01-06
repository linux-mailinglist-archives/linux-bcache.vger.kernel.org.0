Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8953248643C
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 13:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiAFMRS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 07:17:18 -0500
Received: from mail-m2836.qiye.163.com ([103.74.28.36]:46046 "EHLO
        mail-m2836.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbiAFMRP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 07:17:15 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 07:17:14 EST
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m2836.qiye.163.com (Hmail) with ESMTPA id D9E03C075E;
        Thu,  6 Jan 2022 20:08:11 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     axboe@kernel.dk
Cc:     mingzhe.zou@easystack.cn, colyli@suse.de,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
Date:   Thu,  6 Jan 2022 20:08:11 +0800
Message-Id: <20220106120811.24044-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUlCN1dZLVlBSVdZDwkaFQgSH1lBWRoYTkxWTk5KGEseTU9IHk
        hJVRkRExYaEhckFA4PWVdZFhoPEhUdFFlBWVVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MTY6Ejo5EDI8IzoJLUo6Kj1R
        EhwaFBlVSlVKTU9KT0xLQ0JJSU5LVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSUxCQzcG
X-HM-Tid: 0a7e2f4a1807841ekuqwd9e03c075e
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Zou Mingzhe <mingzhe.zou@easystack.cn>

When attaching a cached device (a.k.a backing device) to a cache
device, bch_sectors_dirty_init() is called to count dirty sectors
and stripes (see what bcache_dev_sectors_dirty_add() does) on the
cache device.

When bch_sectors_dirty_init() is called, set_bit(stripe,
d->full_dirty_stripes) or clear_bit(stripe, d->full_dirty_stripes)
operation will always be performed. In full_dirty_stripes, each 1bit
represents stripe_size (8192) sectors (512B), so 1bit=4MB (8192*512),
and each CPU cache line=64B=512bit=2048MB. When 20 threads process
a cached disk with 100G dirty data, a single thread processes about
23M at a time, and 20 threads total 460M. The full_dirty_stripes bit
of these data is likely to fall in the same CPU cache line. This will
cause CPU false sharing problem and reduce performance.

This patch tries to test_bit before set_bit or clear_bit operation.
There are 8192 sectors per 1bit, and the number of sectors processed
by a single bch_sectors_dirty_init() call is only 8, 16, 32, etc.
So the set_bit or clear_bit operations will be greatly reduced.

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

