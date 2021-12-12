Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B59471BC3
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhLLRGh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:37 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54946 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbhLLRGh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:37 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DE3CD21123;
        Sun, 12 Dec 2021 17:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328795; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrzqbynhXscEnu2bz8YjUgXHjF/YAe2JPfnUtAfU32k=;
        b=McOodolrAmu1d1q3+pxcEywis2HWM1zEbB+YYR/W51KKq8bV5fZul/t0mdnKvfoCgrpPbL
        SH/hUnRH6XJG+YNyNUwHy0YdPX17hJ+F3vVgYa9/Kgx/iQY2SFoFDz2vACgg50Hb3ampXx
        FszMkNqhYX92KbEYyhcag8ZncQQWZ2c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328795;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TrzqbynhXscEnu2bz8YjUgXHjF/YAe2JPfnUtAfU32k=;
        b=ylsLkaWacjPdexZngSj67CSW343cu7aVMuygS6pHjKAvwxe8z1agIJyOvD2bpp7pLBYXFH
        YVVU87jzNUhYcFDA==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 1B653A3B87;
        Sun, 12 Dec 2021 17:06:31 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v13 07/12] bcache: use bucket index to set GC_MARK_METADATA for journal buckets in bch_btree_gc_finish()
Date:   Mon, 13 Dec 2021 01:05:47 +0800
Message-Id: <20211212170552.2812-8-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211212170552.2812-1-colyli@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/btree.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 88c573eeb598..1a0ff117373f 100644
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
2.31.1

