Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221223E406F
	for <lists+linux-bcache@lfdr.de>; Mon,  9 Aug 2021 08:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbhHIGrR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 9 Aug 2021 02:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhHIGrR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 9 Aug 2021 02:47:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8BAC0613D3;
        Sun,  8 Aug 2021 23:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2PUg8TD54X+a+8A8rMLEejxIQ+qkWq2AjkJmKrVeDxw=; b=b4tOoPmwQd+crYJCpCx1iG9g4l
        RlE6R1qccfuDeNqWl0NCLbSrEpI8/o22zI/ri0UPqsR/LvTzcdz+rDSB/AMzXpoYVgv4UcyfeZCKg
        ZtEq5VNw8F/j/hQfVA+AZ6LP4rXNKRBpeqcCuC3Mwr08Hzlv4HRaR+d8viAlVr4qNU36T9vv0sEpz
        IuCHhcPqquilvquiiSWmGF1DD7w5DEtzpjQi7uYEODw7XOGbguvZ2zk6TKZewHJ0DgYwuCZ6ILeV4
        m2ypujmPZIeZjyHNoc7Ig3yIxz2Utee3+rA5P+44Zey8BhvISjqFHnlYYrzpGgePzxecsjxo6xQWV
        +Q0Xdqow==;
Received: from [2a02:1205:5023:1f80:c068:bd3d:78b3:7d37] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCz1y-00Aip9-5f; Mon, 09 Aug 2021 06:45:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: [PATCH 5/8] sx8: use the internal state machine to check if del_gendisk needs to be called
Date:   Mon,  9 Aug 2021 08:40:25 +0200
Message-Id: <20210809064028.1198327-6-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210809064028.1198327-1-hch@lst.de>
References: <20210809064028.1198327-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove usage of the block layer internal GENHD_FL_UP by just looking
at the host state.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/sx8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 7b54353ee92b..420cd952ddc4 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -1373,7 +1373,7 @@ static void carm_free_disk(struct carm_host *host, unsigned int port_no)
 	if (!disk)
 		return;
 
-	if (disk->flags & GENHD_FL_UP)
+	if (host->state > HST_DEV_ACTIVATE)
 		del_gendisk(disk);
 	blk_cleanup_disk(disk);
 }
-- 
2.30.2

