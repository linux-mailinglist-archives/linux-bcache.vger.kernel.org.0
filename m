Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB392D7AC5
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Oct 2019 18:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbfJOQES (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Oct 2019 12:04:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37178 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387630AbfJOQER (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Oct 2019 12:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2aj0nmyXWXltpMjKV8FIrv6Gtm6dYd70L9dEmXNmV4k=; b=PPBshf/UMBx9Ry5a9PW+Nnf8v
        LvsGiaR5x2OSuA+T6kBm2kHjDpOjNFCDPXIjSn16y8kA/JMGxXNUYe/JMYU57gFEXa3hWvzxdJ9ur
        cbjwA/hVUh6IEVVLT/TAXL4ElfUI2BSbAo3t1jgegQ8EzP/9x3GqM4ZGK5Ykfzyo3Y/VpLD8GoDyD
        kkdjXiCXkHvoNArRkQm2DYM3JSH8rlKrRGdb83Lz3C/jaYpF6eTGUu5CYuhxCVmxDx36xcnL9bULW
        +qVj8lvWSMTmpC/7OEdsO7FuX/KMWnBi4lLD96Lsi57a8Emd3e/GfgFtTl2knJmMmwu/OEjqBjE+Q
        FtZF98+qQ==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKPJ3-0002bY-4F; Tue, 15 Oct 2019 16:04:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH 1/2] bcache: remove the extra cflags for request.o
Date:   Tue, 15 Oct 2019 18:04:08 +0200
Message-Id: <20191015160409.14250-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015160409.14250-1-hch@lst.de>
References: <20191015160409.14250-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is no block directory this file needs includes from.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/Makefile b/drivers/md/bcache/Makefile
index d26b35195825..fd714628da6a 100644
--- a/drivers/md/bcache/Makefile
+++ b/drivers/md/bcache/Makefile
@@ -5,5 +5,3 @@ obj-$(CONFIG_BCACHE)	+= bcache.o
 bcache-y		:= alloc.o bset.o btree.o closure.o debug.o extents.o\
 	io.o journal.o movinggc.o request.o stats.o super.o sysfs.o trace.o\
 	util.o writeback.o
-
-CFLAGS_request.o	+= -Iblock
-- 
2.20.1

