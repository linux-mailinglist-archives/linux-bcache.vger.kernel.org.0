Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4839641A1CA
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Sep 2021 00:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237558AbhI0WCf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Sep 2021 18:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237684AbhI0WC3 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Sep 2021 18:02:29 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A266EC06176E;
        Mon, 27 Sep 2021 15:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vmoV/2yvLiwBFQQklXCjpC+/vAkb2GZd/kil2P+K9LY=; b=1N4JPqGLhLSNsS1Cgb2YIwsly7
        +aW4YwpCslJYpkXAks9L5PAknlJFJXGDyS2ZEpaD2M0hKp7uuxemDnq0kmn0PiKNEhZfT3xU5OE2B
        NEIidZ82kagd9xiTvY4QBVhmfjUldvqMwEvJy3GCCTADP8JJLfZaVXaqvSZjYvDbf4jwE6N+/UCCO
        nFCZarCbKs9WvILUUJzj8n4GKX9IADqiqMHNghfdRfc0+glrPy84n7AImXEvFcu5sIum2O+W4K3/v
        voAp9xetJTWmWSHjJcDRqvnSUKtPXEmI0SsH4et/rU0BJwVZAwXRe6CxRMvzIZNqW955VNmdGfG+F
        VLf4/Vkw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUyfw-004Sv0-HC; Mon, 27 Sep 2021 22:00:40 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        kbusch@kernel.org, sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 05/10] nvdimm/btt: use goto error labels on btt_blk_init()
Date:   Mon, 27 Sep 2021 15:00:34 -0700
Message-Id: <20210927220039.1064193-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This will make it easier to share common error paths.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/btt.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 29cc7325e890..23ee8c005db5 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1520,10 +1520,11 @@ static int btt_blk_init(struct btt *btt)
 {
 	struct nd_btt *nd_btt = btt->nd_btt;
 	struct nd_namespace_common *ndns = nd_btt->ndns;
+	int rc = -ENOMEM;
 
 	btt->btt_disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!btt->btt_disk)
-		return -ENOMEM;
+		goto out;
 
 	nvdimm_namespace_disk_name(ndns, btt->btt_disk->disk_name);
 	btt->btt_disk->first_minor = 0;
@@ -1535,19 +1536,23 @@ static int btt_blk_init(struct btt *btt)
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, btt->btt_disk->queue);
 
 	if (btt_meta_size(btt)) {
-		int rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
-
-		if (rc) {
-			blk_cleanup_disk(btt->btt_disk);
-			return rc;
-		}
+		rc = nd_integrity_init(btt->btt_disk, btt_meta_size(btt));
+		if (rc)
+			goto out_cleanup_disk;
 	}
+
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
 	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	nvdimm_check_and_set_ro(btt->btt_disk);
 
 	return 0;
+
+out_cleanup_disk:
+	blk_cleanup_disk(btt->btt_disk);
+out:
+	return rc;
 }
 
 static void btt_blk_cleanup(struct btt *btt)
-- 
2.30.2

