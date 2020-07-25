Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D872E22D72C
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgGYMCk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:02:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:52026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3450DAB55;
        Sat, 25 Jul 2020 12:02:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 01/25] bcache: Fix typo in Kconfig name
Date:   Sat, 25 Jul 2020 20:00:15 +0800
Message-Id: <20200725120039.91071-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

registraion -> registration

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 0c8d3fceade2 ("bcache: configure the asynchronous registertion to be experimental")
Reviewed-by: Coly Li <colyli@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/Kconfig | 2 +-
 drivers/md/bcache/super.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index bf7dd96db9b3..d1ca4d059c20 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -27,7 +27,7 @@ config BCACHE_CLOSURES_DEBUG
 	interface to list them, which makes it possible to see asynchronous
 	operations that get stuck.
 
-config BCACHE_ASYNC_REGISTRAION
+config BCACHE_ASYNC_REGISTRATION
 	bool "Asynchronous device registration (EXPERIMENTAL)"
 	depends on BCACHE
 	help
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2014016f9a60..38d79f66fde5 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2782,7 +2782,7 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
-#ifdef CONFIG_BCACHE_ASYNC_REGISTRAION
+#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
 		&ksysfs_register_async.attr,
 #endif
 		&ksysfs_pendings_cleanup.attr,
-- 
2.26.2

