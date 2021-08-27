Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCBA3F9FC6
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbhH0TTR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 15:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbhH0TTO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:19:14 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90561C0613D9;
        Fri, 27 Aug 2021 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=GDvHqyDUto9s8kCaWrxjdJXCPD/eZADtXbZwEghTKUI=; b=S4MU5GCIV4+ftrMG4UOyAR+oD8
        s6X/ggsp+r3jrjgCJwZH9MmjalcMMVmkGAcukRynTXANDqDc15o8k5EE2KGFpHylTt+j06KAnH4Sk
        dMmhl8bM6iF6wtGGlcDTYtc68thxiP8k/mcSFCtvgZ/UuAHoyrGuNHC6mtfj5Jt7zpJ4vEIItRDN8
        SeAcSeNlfz1yb9+hiXapNbS5nU+7XsMlZdTbTZTD+6L4ehekkEpODwTQjCj6LjJqP6Tr2i2qZntt8
        loStFfJSEG7tz2Vot86bYUATs6Qr2LMowWD3tSb5Ip+ugS5qbBzTQqLb/jdhbzlqQp8bDGzCSXS8/
        SHg3xDUA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhMh-00D5Aw-4U; Fri, 27 Aug 2021 19:18:11 +0000
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
Subject: [PATCH 03/10] nvme-multipath: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:18:02 -0700
Message-Id: <20210827191809.3118103-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827191809.3118103-1-mcgrof@kernel.org>
References: <20210827191809.3118103-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Since we now can tell for sure when a disk was added, move
setting the bit NVME_NSHEAD_DISK_LIVE only when we did
add the disk successfully.

Nothing to do here as the cleanup is done elsewhere.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvme/host/multipath.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 37ce3e8b1db2..f95643629fdb 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -479,13 +479,17 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
 static void nvme_mpath_set_live(struct nvme_ns *ns)
 {
 	struct nvme_ns_head *head = ns->head;
+	int rc;
 
 	if (!head->disk)
 		return;
 
-	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
-		device_add_disk(&head->subsys->dev, head->disk,
-				nvme_ns_id_attr_groups);
+	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
+		rc = device_add_disk(&head->subsys->dev, head->disk,
+				     nvme_ns_id_attr_groups);
+		if (rc)
+			return;
+		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
 		nvme_add_ns_head_cdev(head);
 	}
 
-- 
2.30.2

