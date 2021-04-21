Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3974366D2E
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Apr 2021 15:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242847AbhDUNvC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Apr 2021 09:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234768AbhDUNvB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Apr 2021 09:51:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99D0360C3E;
        Wed, 21 Apr 2021 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619013028;
        bh=FxcX021BKYIxYSRHLjSkX3lW5GniH7rGGGHlSXt9iaI=;
        h=From:To:Cc:Subject:Date:From;
        b=QFwmMOmIgndM28hziBnbXRv1n/6s8mckAf4SA0gncX1/AsvSUwFX8g3+cOqzvDdIl
         UFziatvWmeoMMtytGOAfZpC5xYiT1uTgoSrA9nT4OwxAYw1u8K56PNu5N1ANAyA5SS
         FSiMuYHG3PAKX/IH7JPcHX3wK7+Z8LXgnecCfP8MXsTo5T4Ee0eiBEm9498iFH07pq
         4gDvWCGfJ+MHrNKdkDo0M/EHzY/CCbH25QEgPonC4N4R2VOIrAkatvv87jsvSjbSw5
         dWe+bpLWPuyPg63JueWB+IVL6y6p5nmuxSjoxxMacntGFsetBWF3QXZ5lODjJqveqU
         ThVYiFuHnccKQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jean Delvare <jdelvare@suse.de>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: add BLK_DEV dependency for BCACHE_NVM_PAGES
Date:   Wed, 21 Apr 2021 15:50:16 +0200
Message-Id: <20210421135021.3360382-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Selecting this without CONFIG_BLK_DEV causes a Kconfig warning:

WARNING: unmet direct dependencies detected for LIBNVDIMM
  Depends on [n]: PHYS_ADDR_T_64BIT [=y] && HAS_IOMEM [=y] && BLK_DEV [=n]
  Selected by [y]:
  - BCACHE_NVM_PAGES [=y] && MD [=y] && BCACHE [=y] && PHYS_ADDR_T_64BIT [=y]

Add it as another dependency.

Fixes: 688330711e9a ("bcache: initialize the nvm pages allocator")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/md/bcache/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 0996e366ad0b..9cb3d8c39fc1 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -40,6 +40,7 @@ config BCACHE_NVM_PAGES
 	bool "NVDIMM support for bcache (EXPERIMENTAL)"
 	depends on BCACHE
 	depends on PHYS_ADDR_T_64BIT
+	depends on BLKDEV
 	select LIBNVDIMM
 	select DAX
 	help
-- 
2.29.2

