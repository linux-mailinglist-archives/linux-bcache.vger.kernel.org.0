Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD023315EB0
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhBJFJv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:09:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:40750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhBJFJq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:09:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B2647B0D0;
        Wed, 10 Feb 2021 05:08:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH 20/20] bcache: only initialize nvm-pages allocator when CONFIG_BCACHE_NVM_PAGES configured
Date:   Wed, 10 Feb 2021 13:07:42 +0800
Message-Id: <20210210050742.31237-21-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210210050742.31237-1-colyli@suse.de>
References: <20210210050742.31237-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It is unnecessary to initialize the EXPERIMENTAL nvm-pages allocator
when CONFIG_BCACHE_NVM_PAGES is not configured. This patch uses
"#ifdef CONFIG_BCACHE_NVM_PAGES" to wrap bch_nvm_init() and
bch_nvm_exit(), and only calls them when bch_nvm_exit is configured.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
---
 drivers/md/bcache/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 61fd5802a627..c273eeef0d38 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2845,7 +2845,9 @@ static void bcache_exit(void)
 {
 	bch_debug_exit();
 	bch_request_exit();
+#ifdef CONFIG_BCACHE_NVM_PAGES
 	bch_nvm_exit();
+#endif
 	if (bcache_kobj)
 		kobject_put(bcache_kobj);
 	if (bcache_wq)
@@ -2947,7 +2949,9 @@ static int __init bcache_init(void)
 
 	bch_debug_init();
 	closure_debug_init();
+#ifdef CONFIG_BCACHE_NVM_PAGES
 	bch_nvm_init();
+#endif
 
 	bcache_is_reboot = false;
 
-- 
2.26.2

