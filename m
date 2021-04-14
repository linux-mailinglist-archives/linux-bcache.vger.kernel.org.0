Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24A035EC65
	for <lists+linux-bcache@lfdr.de>; Wed, 14 Apr 2021 07:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347480AbhDNFrp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 14 Apr 2021 01:47:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:43242 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347452AbhDNFro (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 14 Apr 2021 01:47:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1A24B038;
        Wed, 14 Apr 2021 05:47:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 07/13] bcache: use bucket index to set GC_MARK_METADATA for journal buckets in bch_btree_gc_finish()
Date:   Wed, 14 Apr 2021 13:46:42 +0800
Message-Id: <20210414054648.24098-8-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210414054648.24098-1-colyli@suse.de>
References: <20210414054648.24098-1-colyli@suse.de>
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
index 183a58c89377..e0d7135669ca 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1761,8 +1761,10 @@ static void bch_btree_gc_finish(struct cache_set *c)
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

