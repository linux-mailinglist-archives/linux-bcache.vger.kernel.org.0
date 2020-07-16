Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC82221E67
	for <lists+linux-bcache@lfdr.de>; Thu, 16 Jul 2020 10:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgGPIbT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 04:31:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:40940 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbgGPIbP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 04:31:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D79BBAE25;
        Thu, 16 Jul 2020 08:31:17 +0000 (UTC)
Date:   Thu, 16 Jul 2020 10:31:13 +0200
From:   Jean Delvare <jdelvare@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH] bcache: Fix typo in Kconfig name
Message-ID: <20200716103113.08478111@endymion>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

registraion -> registration

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 0c8d3fceade2 ("bcache: configure the asynchronous registertion to be experimental")
Cc: Coly Li <colyli@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
---
 drivers/md/bcache/Kconfig |    2 +-
 drivers/md/bcache/super.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-5.8-rc5.orig/drivers/md/bcache/Kconfig	2020-07-06 01:20:22.000000000 +0200
+++ linux-5.8-rc5/drivers/md/bcache/Kconfig	2020-07-16 10:22:05.598266100 +0200
@@ -27,7 +27,7 @@ config BCACHE_CLOSURES_DEBUG
 	interface to list them, which makes it possible to see asynchronous
 	operations that get stuck.
 
-config BCACHE_ASYNC_REGISTRAION
+config BCACHE_ASYNC_REGISTRATION
 	bool "Asynchronous device registration (EXPERIMENTAL)"
 	depends on BCACHE
 	help
--- linux-5.8-rc5.orig/drivers/md/bcache/super.c	2020-07-06 01:20:22.000000000 +0200
+++ linux-5.8-rc5/drivers/md/bcache/super.c	2020-07-16 10:22:24.046484823 +0200
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
Jean Delvare
SUSE L3 Support
