Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1366B2A14AA
	for <lists+linux-bcache@lfdr.de>; Sat, 31 Oct 2020 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgJaJUN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 31 Oct 2020 05:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgJaJUN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 31 Oct 2020 05:20:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2633AC0613D5;
        Sat, 31 Oct 2020 02:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=LHct6feTU7L0nCAl+LeQycCuOcwMhUL/YjRE2qUcCWU=; b=qv684+6ggZCUIA8CvQEvm3wqd4
        /nUe37TLCHgkyzuReGe4r0lN3xtMA+d2sCMm50mbjquqHDLUwugVvXas7kN++3CtVY4wRGU0TB2x6
        xJHUWIo9wf5CH06uC5io24V48CMBu07dLhIUB4lwWxDyMk5UAQUVBsPrCTiI+Ya2lkvwzSFn9f9+d
        rZKussDqoPPkRLz3Jbkxp8E0B+0DgDb0fCp3K8B1gcsmLCo4Ssk0ySks8TSwWEARq6tEYpV+lZD7J
        aWWe1EuHTE6GIjCw6udCywlzHC+FBW7f8IQXqJvLSZqDSu4Z42l/V2wUKbNueEaAOJano82pgtFY+
        rwSpDtfA==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kYn3N-0008A8-P0; Sat, 31 Oct 2020 09:20:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ilya Dryomov <idryomov@gmail.com>, Song Liu <song@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org
Subject: [PATCH 09/11] loop: use set_disk_ro
Date:   Sat, 31 Oct 2020 09:58:08 +0100
Message-Id: <20201031085810.450489-10-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201031085810.450489-1-hch@lst.de>
References: <20201031085810.450489-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Use set_disk_ro instead of set_device_ro to match all other block
drivers and to ensure all partitions mirror the read-only flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cb1191d6e945f2..3e1ea45bb315d8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1137,7 +1137,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 	if (error)
 		goto out_unlock;
 
-	set_device_ro(bdev, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
+	set_disk_ro(lo->lo_disk, (lo->lo_flags & LO_FLAGS_READ_ONLY) != 0);
 
 	lo->use_dio = lo->lo_flags & LO_FLAGS_DIRECT_IO;
 	lo->lo_device = bdev;
-- 
2.28.0

