Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F0435A3E3
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Apr 2021 18:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbhDIQqE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Apr 2021 12:46:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:36096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234211AbhDIQqE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:46:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E91D4B120;
        Fri,  9 Apr 2021 16:45:49 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v7 16/16] bcache: more fix for compiling error when BCACHE_NVM_PAGES disabled
Date:   Sat, 10 Apr 2021 00:43:43 +0800
Message-Id: <20210409164343.56828-17-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210409164343.56828-1-colyli@suse.de>
References: <20210409164343.56828-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch fixes the compiling error when BCACHE_NVM_PAGES is disabled.
The change could be added into previous nvm-pages patches, so that this
patch can be dropped in next nvm-pages series.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/nvm-pages.c | 4 ++--
 drivers/md/bcache/nvm-pages.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
index 19597ae7ef3e..b32f162bf728 100644
--- a/drivers/md/bcache/nvm-pages.c
+++ b/drivers/md/bcache/nvm-pages.c
@@ -7,6 +7,8 @@
  * Copyright (c) 2021, Jianpeng Ma <jianpeng.ma@intel.com>.
  */
 
+#ifdef CONFIG_BCACHE_NVM_PAGES
+
 #include "bcache.h"
 #include "nvm-pages.h"
 
@@ -23,8 +25,6 @@
 #include <linux/blkdev.h>
 #include <linux/bcache-nvm.h>
 
-#ifdef CONFIG_BCACHE_NVM_PAGES
-
 struct bch_nvm_set *only_set;
 
 static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
diff --git a/drivers/md/bcache/nvm-pages.h b/drivers/md/bcache/nvm-pages.h
index 1c4cbad0209f..f9e0cd7ca3dd 100644
--- a/drivers/md/bcache/nvm-pages.h
+++ b/drivers/md/bcache/nvm-pages.h
@@ -3,8 +3,10 @@
 #ifndef _BCACHE_NVM_PAGES_H
 #define _BCACHE_NVM_PAGES_H
 
+#ifdef CONFIG_BCACHE_NVM_PAGES
 #include <linux/bcache-nvm.h>
 #include <linux/libnvdimm.h>
+#endif /* CONFIG_BCACHE_NVM_PAGES */
 
 /*
  * Bcache NVDIMM in memory data structures
-- 
2.26.2

