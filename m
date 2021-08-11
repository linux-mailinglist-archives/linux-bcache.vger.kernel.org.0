Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30393E9679
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhHKRFH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:05:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58626 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbhHKRFG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:05:06 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8733A20185;
        Wed, 11 Aug 2021 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtwFnp4xZMjddc3KByFiXKLm0ST5Cfz+TLDQyLU1/5Q=;
        b=OoxG+Fdr5sgZySs1KR8cWyYjVrhjTS2nJnHprvqfRGcVMNrmhp6EavaOB2mx38OivNnB2/
        CFu8JGkBtOdhkTzIqwpuQ/HWo9I2iNul7/M05qxZ5TAH6G8RQDdAaVYy8GNOeR7gNEoye+
        wiL57XghNaw3e8uhLXmgcMQorbwsrEQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701481;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wtwFnp4xZMjddc3KByFiXKLm0ST5Cfz+TLDQyLU1/5Q=;
        b=fA2/MOmq+ILLxRzTje5wEhnlZtkuxCtLLAUPtHcsO42L8SYAaZxdXC7zfRF3OEicHbt920
        GHqgDXV2b0YcO3DQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id F21DFA3D65;
        Wed, 11 Aug 2021 17:04:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>, Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v12 07/12] bcache: use bucket index to set GC_MARK_METADATA for journal buckets in bch_btree_gc_finish()
Date:   Thu, 12 Aug 2021 01:02:19 +0800
Message-Id: <20210811170224.42837-8-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210811170224.42837-1-colyli@suse.de>
References: <20210811170224.42837-1-colyli@suse.de>
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

