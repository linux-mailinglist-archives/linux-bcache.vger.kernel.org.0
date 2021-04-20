Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE01365193
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Apr 2021 06:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhDTErc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Apr 2021 00:47:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:40794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhDTErV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Apr 2021 00:47:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE93DB15E;
        Tue, 20 Apr 2021 04:45:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 1/2] bcache: Kconfig dependence fix for NVDIMM support
Date:   Tue, 20 Apr 2021 12:44:51 +0800
Message-Id: <20210420044452.88267-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210420044452.88267-1-colyli@suse.de>
References: <20210420044452.88267-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In drivers/md/bcache/Kconfig, setting BCACHE_NVM_PAGES to "selected"
LIBNVDIMM and DAX is improper. This patch changes to Kconfig dependance
from "selected" to "depends on" for LIBNVDIMM and DAX.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 0996e366ad0b..59999f24d89e 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -40,7 +40,7 @@ config BCACHE_NVM_PAGES
 	bool "NVDIMM support for bcache (EXPERIMENTAL)"
 	depends on BCACHE
 	depends on PHYS_ADDR_T_64BIT
-	select LIBNVDIMM
-	select DAX
+	depends on LIBNVDIMM
+	depends on DAX
 	help
 	nvm pages allocator for bcache.
-- 
2.26.2

