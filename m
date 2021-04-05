Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46258354107
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Apr 2021 12:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbhDEKA7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 5 Apr 2021 06:00:59 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhDEKA7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Apr 2021 06:00:59 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDR1F0rd1znYks;
        Mon,  5 Apr 2021 17:58:09 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Mon, 5 Apr 2021 18:00:43 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <zhengyongjun3@huawei.com>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Hulk Robot" <hulkci@huawei.com>
Subject: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
Date:   Mon, 5 Apr 2021 18:14:53 +0800
Message-ID: <20210405101453.15096-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

mutex lock can be initialized automatically with DEFINE_MUTEX()
rather than explicitly calling mutex_init().

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 drivers/md/bcache/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 78c08a8aece8..c124da6e646d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -41,7 +41,7 @@ static const char invalid_uuid[] = {
 };
 
 static struct kobject *bcache_kobj;
-struct mutex bch_register_lock;
+DEFINE_MUTEX(bch_register_lock);
 bool bcache_is_reboot;
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
@@ -2870,7 +2870,6 @@ static int __init bcache_init(void)
 
 	check_module_parameters();
 
-	mutex_init(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 

