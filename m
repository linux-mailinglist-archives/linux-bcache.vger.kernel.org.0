Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17A13F9FC3
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 21:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhH0TTS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 15:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbhH0TTO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:19:14 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18048C061757;
        Fri, 27 Aug 2021 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=hsYRy5mW2eSZFEqOw8JTWcpX/S1jq2Dljgzx3k3VBB0=; b=ag2MWG9JRPRl7v1Wm4knifBuDH
        x/k7sA6IMtBfImriQpfdYn9OfQrmhh704BYOZ1efraWf6MvZLkuIu8ui3RaFGt2h0JGEnJbE/mzGG
        UMpYztDhF4uGbNZV/BKzqSXSAymUMxJHuUsN0AeDORBz3rq0NtTKCdwuHZFTV3ylWbjUQPELSZJnJ
        Uv8SvIfFCz+zqm8iSInPS4MX23d9OwRSOPydfEoraAzMapqy1iXSYJRU/ysyMRbUQvaeuY0q2kbAF
        WsvxN6a8SYo3ajPRyxlChb/HXfw9y48GMnLlBgH5jr3PXLLMmtQlkt0jpuLPPGCKR46h3vY8cdWgw
        KUC5BgwQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhMh-00D5B6-CX; Fri, 27 Aug 2021 19:18:11 +0000
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
Subject: [PATCH 07/10] nvdimm/blk: avoid calling del_gendisk() on early failures
Date:   Fri, 27 Aug 2021 12:18:06 -0700
Message-Id: <20210827191809.3118103-8-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

If nd_integrity_init() fails we'd get del_gendisk() called,
but that's not correct as we should only call that if we're
done with device_add_disk(). Fix this by providing unwinding
prior to the devm call being registered and moving the devm
registration to the very end.

This should fix calling del_gendisk() if nd_integrity_init()
fails. I only spotted this issue through code inspection. It
does not fix any real world bug.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/blk.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 088d3dd6f6fa..591fa1f86f1e 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -240,6 +240,7 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	resource_size_t available_disk_size;
 	struct gendisk *disk;
 	u64 internal_nlba;
+	int rc;
 
 	internal_nlba = div_u64(nsblk->size, nsblk_internal_lbasize(nsblk));
 	available_disk_size = internal_nlba * nsblk_sector_size(nsblk);
@@ -256,20 +257,26 @@ static int nsblk_attach_disk(struct nd_namespace_blk *nsblk)
 	blk_queue_logical_block_size(disk->queue, nsblk_sector_size(nsblk));
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, disk->queue);
 
-	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
-		return -ENOMEM;
-
 	if (nsblk_meta_size(nsblk)) {
-		int rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
+		rc = nd_integrity_init(disk, nsblk_meta_size(nsblk));
 
 		if (rc)
-			return rc;
+			goto out_before_devm_err;
 	}
 
 	set_capacity(disk, available_disk_size >> SECTOR_SHIFT);
 	device_add_disk(dev, disk, NULL);
+
+	/* nd_blk_release_disk() is called if this fails */
+	if (devm_add_action_or_reset(dev, nd_blk_release_disk, disk))
+		return -ENOMEM;
+
 	nvdimm_check_and_set_ro(disk);
 	return 0;
+
+out_before_devm_err:
+	blk_cleanup_disk(disk);
+	return rc;
 }
 
 static int nd_blk_probe(struct device *dev)
-- 
2.30.2

