Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F95F312547
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Feb 2021 16:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhBGP1a (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 7 Feb 2021 10:27:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:35784 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhBGPZX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 7 Feb 2021 10:25:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7070EAF4C;
        Sun,  7 Feb 2021 15:24:41 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, jianpeng.ma@intel.com,
        qiaowei.ren@intel.com, Coly Li <colyli@suse.de>
Subject: [PATCH 1/6] bcache: use bucket index for SET_GC_MARK() in bch_btree_gc_finish()
Date:   Sun,  7 Feb 2021 23:24:18 +0800
Message-Id: <20210207152423.70697-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210207152423.70697-1-colyli@suse.de>
References: <20210207152423.70697-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Currently the meta data bucket locations on cache device are reserved
after the meta data stored on NVDIMM pages, for the meta data layout
consistentcy temporarily. So these buckets are still marked as meta data
by SET_GC_MARK() in bch_btree_gc_finish().

When BCH_FEATURE_INCOMPAT_NVDIMM_META is set, the sb.d[] stores linear
address of NVDIMM pages and not bucket index anymore. Therefore we
should avoid to find bucket index from sb.d[], and directly use bucket
index from ca->sb.first_bucket to (ca->sb.first_bucket +
ca->sb.njournal_bucketsi) for setting the gc mark of journal bucket.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/btree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 910df242c83d..9da91577b358 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1759,8 +1759,10 @@ static void bch_btree_gc_finish(struct cache_set *c)
 	ca = c->cache;
 	ca->invalidate_needs_gc = 0;
 
-	for (k = ca->sb.d; k < ca->sb.d + ca->sb.keys; k++)
-		SET_GC_MARK(ca->buckets + *k, GC_MARK_METADATA);
+	/* Range [first_bucket, first_bucket + keys) is for journal buckets */
+	for (i = ca->sb.first_bucket;
+	     i < ca->sb.first_bucket + ca->sb.njournal_buckets; i++)
+		SET_GC_MARK(ca->buckets + i, GC_MARK_METADATA);
 
 	for (k = ca->prio_buckets;
 	     k < ca->prio_buckets + prio_buckets(ca) * 2; k++)
-- 
2.26.2

