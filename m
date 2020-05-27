Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD5D91E36D2
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 06:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgE0EDW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 00:03:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:57462 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbgE0EDV (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 00:03:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE08DAE2C;
        Wed, 27 May 2020 04:03:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 5/5] bcache: configure the asynchronous registertion to be experimental
Date:   Wed, 27 May 2020 12:01:55 +0800
Message-Id: <20200527040155.43690-6-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200527040155.43690-1-colyli@suse.de>
References: <20200527040155.43690-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In order to avoid the experimental async registration interface to
be treated as new kernel ABI for common users, this patch makes it
as an experimental kernel configure BCACHE_ASYNC_REGISTRAION.

This interface is for extreme large cached data situation, to make sure
the bcache device can always created without the udev timeout issue. For
normal users the async or sync registration does not make difference.

In future when we decide to use the asynchronous registration as default
behavior, this experimental interface may be removed.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/Kconfig | 9 +++++++++
 drivers/md/bcache/super.c | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index 6dfa653d30db..bf7dd96db9b3 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -26,3 +26,12 @@ config BCACHE_CLOSURES_DEBUG
 	Keeps all active closures in a linked list and provides a debugfs
 	interface to list them, which makes it possible to see asynchronous
 	operations that get stuck.
+
+config BCACHE_ASYNC_REGISTRAION
+	bool "Asynchronous device registration (EXPERIMENTAL)"
+	depends on BCACHE
+	help
+	Add a sysfs file /sys/fs/bcache/register_async. Writing registering
+	device path into this file will returns immediately and the real
+	registration work is handled in kernel work queue in asynchronous
+	way.
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index b971d8e916d5..f9975c22bf7e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2765,7 +2765,9 @@ static int __init bcache_init(void)
 	static const struct attribute *files[] = {
 		&ksysfs_register.attr,
 		&ksysfs_register_quiet.attr,
+#ifdef CONFIG_BCACHE_ASYNC_REGISTRAION
 		&ksysfs_register_async.attr,
+#endif
 		&ksysfs_pendings_cleanup.attr,
 		NULL
 	};
-- 
2.25.0

