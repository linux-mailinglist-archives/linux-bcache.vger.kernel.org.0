Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306C93E4063
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhHIGpD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233256AbhHIGpC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:45:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D45C0613CF;
        Sun,  8 Aug 2021 23:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vkH3Wo8mATZ+eF4v04e/DPUXnCptiGaA42oXGO3dXG4=; b=lQL7R3cDRdHIWW/4jrP7/XPcVF
        MsRAMnS+rjdYC9Pnr9rrOrKf4sWHakOggtvQKxsRZ1PBLDt3SbL6zANOskpg2ZwckYvD+KDe8G+l4
        LxhitBBgDYwWR1nkgaACBw5ranm597FjP0AOAR2TWMmOyvEsSb/sro/++z8vrpjF2izNQpJ34mbH4
        jos4TdjL82tl5c94tMaTVkq+F4FWY57w6Qik/TQSSCs8jO/iTppjQcd+njyAUiwgVfbavHewo2S3E
        KfBRM1NQfcIKBbEzlIsXAyapZbdEjs06fJD71FiOSVAeHezm0poN0JGoeIwNUyl0ORPBmWC2SuVn+
        E2kZIj7g==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCz0V-00Aihs-Dt; Mon, 09 Aug 2021 06:43:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 3/8] nvme: remove the GENHD_FL_UP check in nvme_ns_remove
Date:   Mon,  9 Aug 2021 08:40:23 +0200
Message-Id: <20210809064028.1198327-4-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Early probe failure never reaches nvme_ns_remove, so GENHD_FL_UP must
be set at this point.  Remove the check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index dfd9dec0c1f6..e24a0143fd87 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3826,14 +3826,12 @@ static void nvme_ns_remove(struct nvme_ns *ns)
 	nvme_mpath_clear_current_path(ns);
 	synchronize_srcu(&ns->head->srcu); /* wait for concurrent submissions */
 
-	if (ns->disk->flags & GENHD_FL_UP) {
-		if (!nvme_ns_head_multipath(ns->head))
-			nvme_cdev_del(&ns->cdev, &ns->cdev_device);
-		del_gendisk(ns->disk);
-		blk_cleanup_queue(ns->queue);
-		if (blk_get_integrity(ns->disk))
-			blk_integrity_unregister(ns->disk);
-	}
+	if (!nvme_ns_head_multipath(ns->head))
+		nvme_cdev_del(&ns->cdev, &ns->cdev_device);
+	del_gendisk(ns->disk);
+	blk_cleanup_queue(ns->queue);
+	if (blk_get_integrity(ns->disk))
+		blk_integrity_unregister(ns->disk);
 
 	down_write(&ns->ctrl->namespaces_rwsem);
 	list_del_init(&ns->list);
-- 
2.30.2

