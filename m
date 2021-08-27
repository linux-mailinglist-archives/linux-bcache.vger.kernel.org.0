Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB613F9FD5
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Aug 2021 21:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhH0TTU (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Aug 2021 15:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhH0TTO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Aug 2021 15:19:14 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE772C061757;
        Fri, 27 Aug 2021 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MlI7d0NX6/gbusr57eEjs+4gHr0mIPfbnhczoHLdvTU=; b=FiVuZjEeF4M9ZPaADvhCFh2tVN
        DYzuVOnQmxkB6JoMep8Nf6n0GlJbr2Q8vO49ziGqNHa6U7Oit5uXjxVqrkzljKd5V4BEzEEAUkUD6
        YkPOGbzZDCekCv+riLl+K1iJzN5XsHP27b3OELPN4/xukR2OO/D0M/BfnulrdBkq6hBZbx5yvaWR8
        jYpGUufJSWYUf92kagUPDE7vDOe+VuqHuiQQ+vWtf/BMkP8rZiEbfsWLqq+zspf5RTu1JOPpd0SDd
        pZexEgoIjJykLfRqUEO6XEGLamStM3CeBh+3o8KVyzA5W26cCP7v0d2MiCEfgKaU9kuR6jvDKuurb
        gNssezdw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJhMh-00D5B4-BH; Fri, 27 Aug 2021 19:18:11 +0000
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
Subject: [PATCH 06/10] nvdimm/btt: add error handling support for add_disk()
Date:   Fri, 27 Aug 2021 12:18:05 -0700
Message-Id: <20210827191809.3118103-7-mcgrof@kernel.org>
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
 drivers/nvdimm/btt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 275704d80109..abdac4b7769f 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1542,7 +1542,9 @@ static int btt_blk_init(struct btt *btt)
 	}
 
 	set_capacity(btt->btt_disk, btt->nlba * btt->sector_size >> 9);
-	device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	rc = device_add_disk(&btt->nd_btt->dev, btt->btt_disk, NULL);
+	if (rc)
+		goto out_cleanup_disk;
 
 	btt->nd_btt->size = btt->nlba * (u64)btt->sector_size;
 	nvdimm_check_and_set_ro(btt->btt_disk);
-- 
2.30.2

