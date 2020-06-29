Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D79120DA6C
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Jun 2020 22:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgF2T5B (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Jun 2020 15:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387628AbgF2TkW (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:22 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84D9C03E97B;
        Mon, 29 Jun 2020 12:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=L49detOHIFMZBv2u/yvsEnOxSRyecAx0WO9o6Vj19Gg=; b=q7gNkxTFXcVg1yAszGSmCkxQn7
        lXicqScm59nuMxQ/ket+RyBDVPYFZwPUBL8QbJkzYRiKnTqCC6BuV1tUIU5COa5jmZiGdCUCWXpMp
        qsOeAUK20gnONWIkR6FbtECLvtbiacCGqWKlW84S5AP+AwyjFIMCGWsymdUi0+5ChWpPvdQiwJjIZ
        3oh0r0bodWKyzTs51cS64yOUl9zpt0qof+j90crbOMYxdemomtLNgY1GUbSTiVxcX/42cdOE83NWn
        qav4MIBz4IJSXFI5QrsdFWfKh+4UTQlX3RxOZNnXKcq0hLgWeKZauyWbFPRzhIZm8VTafcbr2+SfT
        wcM8i5Wg==;
Received: from [2001:4bb8:184:76e3:fcca:c8dc:a4bf:12fa] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpzdM-0004Ji-Pl; Mon, 29 Jun 2020 19:40:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org,
        drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: [PATCH 09/20] bcache: stop setting ->queuedata
Date:   Mon, 29 Jun 2020 21:39:36 +0200
Message-Id: <20200629193947.2705954-10-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629193947.2705954-1-hch@lst.de>
References: <20200629193947.2705954-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Nothing in bcache actually uses the ->queuedata field.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2014016f9a60d3..21aa168113d30b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -876,7 +876,6 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 		return -ENOMEM;
 
 	d->disk->queue			= q;
-	q->queuedata			= d;
 	q->backing_dev_info->congested_data = d;
 	q->limits.max_hw_sectors	= UINT_MAX;
 	q->limits.max_sectors		= UINT_MAX;
-- 
2.26.2

