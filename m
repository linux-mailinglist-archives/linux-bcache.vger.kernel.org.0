Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023F32E1DBB
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 16:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727712AbgLWPGW (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 10:06:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:58186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgLWPGW (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 10:06:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4B332AEBB;
        Wed, 23 Dec 2020 15:05:40 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Coly Li <colyli@sue.de>
Subject: [PATCH 2/2] md/bcache: convert comma to semicolon
Date:   Wed, 23 Dec 2020 23:04:22 +0800
Message-Id: <20201223150422.3966-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201223150422.3966-1-colyli@suse.de>
References: <20201223150422.3966-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Coly Li <colyli@sue.de>
---
 drivers/md/bcache/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index 554e3afc9b68..00a520c03f41 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -404,7 +404,7 @@ STORE(__cached_dev)
 		if (!env)
 			return -ENOMEM;
 		add_uevent_var(env, "DRIVER=bcache");
-		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid),
+		add_uevent_var(env, "CACHED_UUID=%pU", dc->sb.uuid);
 		add_uevent_var(env, "CACHED_LABEL=%s", buf);
 		kobject_uevent_env(&disk_to_dev(dc->disk.disk)->kobj,
 				   KOBJ_CHANGE,
-- 
2.26.2

