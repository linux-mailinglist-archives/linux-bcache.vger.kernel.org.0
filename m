Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C59D3F9FBD
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 21:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhH0TTO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 15:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhH0TTN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:19:13 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 957C3C061757;
        Fri, 27 Aug 2021 12:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=r8MzoKDcb67F6VDD0mCfQtUXlNELBrr58OK/skvQejQ=; b=Q6aWwEC/JZVopdDk8X1QjnwL8l
        nn5puUdf+O7B1dgHvEgE4VR7dMiWkZu0xOHZ4JH821w52Q/zP3BGX87mxABarojvRRQN8u29TM7AL
        lR/nfcx0+N9/YXnOsFsLU4IceBFw2kFHhg0uy+/V1bVbKVTnYCfERNaqNWBnrCzFJCGtTrehA4gIX
        NsZ8WaFJYPNs/OBiDn26XCThBH4Eo/cEv0x9yrpI29bkfk1n34eDIt9vthtYt6S08SmmCC1MRMHhh
        KQw+8lZybK5CYUFuLfszXurf4AJk7ow675xAoVzGdkre1+NsJyA++7qavXURTiW5DAp++SVxfGZac
        b0ct+yrg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhMh-00D5BG-Gk; Fri, 27 Aug 2021 19:18:11 +0000
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
Subject: [PATCH 10/10] zram: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:18:09 -0700
Message-Id: <20210827191809.3118103-11-mcgrof@kernel.org>
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

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/zram/zram_drv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index fcaf2750f68f..d5b343c2bc96 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1953,7 +1953,9 @@ static int zram_add(void)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
-	device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+	ret = device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+	if (ret)
+		goto out_cleanup_disk;
 
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 
@@ -1961,6 +1963,8 @@ static int zram_add(void)
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
 
+out_cleanup_disk:
+	blk_cleanup_disk(zram->disk);
 out_free_idr:
 	idr_remove(&zram_index_idr, device_id);
 out_free_dev:
-- 
2.30.2

