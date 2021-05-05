Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0581F3738DD
	for <lists+linux-bcache@lfdr.de>; Wed,  5 May 2021 12:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhEEKyH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 May 2021 06:54:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:18355 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhEEKyH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 May 2021 06:54:07 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FZtmR0KVWzlbdw;
        Wed,  5 May 2021 18:51:03 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Wed, 5 May 2021 18:53:01 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>,
        <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next v4] bcache: Use DEFINE_MUTEX() for mutex lock
Date:   Wed, 5 May 2021 19:06:55 +0800
Message-ID: <20210505110655.1461896-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Mutex lock can be initialized automatically with DEFINE_MUTEX() rather
than explicitly calling mutex_init().

This patch will reduce the size of bcache.ko about 16 bytes, the
reason as follows:

Though this patch will increase the size of .data segment about 32
bytes, it will also reduce the size of .init.text and
.rodata.str1.1(at x86_64), .rodata_str1.8(at arm64) total about 48
bytes which reduce the size more than .data segment;

Here is the statistics:
Sections: (arm64 platform)
Idx name                size
-.init.text             00000240
+.init.text             00000228

-.rodata.str1.8	000012cd
+.rodata.str1.8	000012b5

-.data                  00000c60
+.data                  00000c80

Sections: (x86 platform)
Idx name                size
-.init.text             000001d9
+.init.text             000001bf

-.rodata.str1.1	00000c80
+.rodata.str1.1	00000c6d

-.data                  00000cc0
+.data                  00000ce0

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---

v4:
- change commit log, delete bss information at commit description.
v3:
- change commit log, delete statistic about .bss segment.
v2:
- add commit log about the reason why bcache.ko size reduced.
---
 drivers/md/bcache/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 03e1fe4de53d..3635f454309e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -40,7 +40,7 @@ static const char invalid_uuid[] = {
 };
 
 static struct kobject *bcache_kobj;
-struct mutex bch_register_lock;
+DEFINE_MUTEX(bch_register_lock);
 bool bcache_is_reboot;
 LIST_HEAD(bch_cache_sets);
 static LIST_HEAD(uncached_devices);
@@ -2869,7 +2869,6 @@ static int __init bcache_init(void)
 
 	check_module_parameters();
 
-	mutex_init(&bch_register_lock);
 	init_waitqueue_head(&unregister_wait);
 	register_reboot_notifier(&reboot);
 
-- 
2.25.1

