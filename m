Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120BE2DCD5A
	for <lists+linux-bcache@lfdr.de>; Thu, 17 Dec 2020 09:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLQIG4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 17 Dec 2020 03:06:56 -0500
Received: from regular1.263xmail.com ([211.150.70.206]:57986 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgLQIG4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 17 Dec 2020 03:06:56 -0500
Received: from localhost (unknown [192.168.167.16])
        by regular1.263xmail.com (Postfix) with ESMTP id E85301B45;
        Thu, 17 Dec 2020 16:00:40 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P20583T140370614691584S1608192035441421_;
        Thu, 17 Dec 2020 16:00:41 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <5d8c97d87a7ceca7d76a7914649cd65e>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: colyli@suse.de
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     colyli@suse.de
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Li <yili@winhong.com>, Li bing <libing@winhong.com>
Subject: [PATCH] bcache: fix UUID room exhausted fake issue.
Date:   Thu, 17 Dec 2020 16:00:30 +0800
Message-Id: <20201217080030.1226023-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The UUID room will be exhausted fake when loop attach/dettach backing dev.

Using zero_uuid to the UUID room after dettach normaly.
And attach dev can request UUID room successfully.

Signed-off-by: Yi Li <yili@winhong.com>
Signed-off-by: Li bing <libing@winhong.com>
---
 drivers/md/bcache/super.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0e06d721cd8e..f7ad1e26b013 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -34,10 +34,7 @@ static const char bcache_magic[] = {
 	0x82, 0x65, 0xf5, 0x7f, 0x48, 0xba, 0x6d, 0x81
 };
 
-static const char invalid_uuid[] = {
-	0xa0, 0x3e, 0xf8, 0xed, 0x3e, 0xe1, 0xb8, 0x78,
-	0xc8, 0x50, 0xfc, 0x5e, 0xcb, 0x16, 0xcd, 0x99
-};
+static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
 
 static struct kobject *bcache_kobj;
 struct mutex bch_register_lock;
@@ -515,13 +512,6 @@ static struct uuid_entry *uuid_find(struct cache_set *c, const char *uuid)
 	return NULL;
 }
 
-static struct uuid_entry *uuid_find_empty(struct cache_set *c)
-{
-	static const char zero_uuid[16] = "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
-
-	return uuid_find(c, zero_uuid);
-}
-
 /*
  * Bucket priorities/gens:
  *
@@ -803,7 +793,7 @@ static void bcache_device_detach(struct bcache_device *d)
 		struct uuid_entry *u = d->c->uuids + d->id;
 
 		SET_UUID_FLASH_ONLY(u, 0);
-		memcpy(u->uuid, invalid_uuid, 16);
+		memcpy(u->uuid, zero_uuid, 16);
 		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
 		bch_uuid_write(d->c);
 	}
@@ -1211,7 +1201,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 	if (u &&
 	    (BDEV_STATE(&dc->sb) == BDEV_STATE_STALE ||
 	     BDEV_STATE(&dc->sb) == BDEV_STATE_NONE)) {
-		memcpy(u->uuid, invalid_uuid, 16);
+		memcpy(u->uuid, zero_uuid, 16);
 		u->invalidated = cpu_to_le32((u32)ktime_get_real_seconds());
 		u = NULL;
 	}
@@ -1223,7 +1213,7 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c,
 			return -ENOENT;
 		}
 
-		u = uuid_find_empty(c);
+		u = uuid_find(c, zero_uuid);
 		if (!u) {
 			pr_err("Not caching %s, no room for UUID\n",
 			       dc->backing_dev_name);
@@ -1554,7 +1544,7 @@ int bch_flash_dev_create(struct cache_set *c, uint64_t size)
 	if (!test_bit(CACHE_SET_RUNNING, &c->flags))
 		return -EPERM;
 
-	u = uuid_find_empty(c);
+	u = uuid_find(c, zero_uuid);
 	if (!u) {
 		pr_err("Can't create volume, no room for UUID\n");
 		return -EINVAL;
-- 
2.25.3



