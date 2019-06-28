Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F3C599C4
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfF1MBI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:01:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:54428 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726957AbfF1MBI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:01:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EEA91B62B;
        Fri, 28 Jun 2019 12:01:06 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 14/37] bcache: more detailed error message to bcache_device_link()
Date:   Fri, 28 Jun 2019 19:59:37 +0800
Message-Id: <20190628120000.40753-15-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch adds more accurate error message for specific
ssyfs_create_link() call, to help debugging failure during
bcache device start tup.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0abee44092bf..d4d8d1300faf 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -693,6 +693,7 @@ static void bcache_device_link(struct bcache_device *d, struct cache_set *c,
 {
 	unsigned int i;
 	struct cache *ca;
+	int ret;
 
 	for_each_cache(ca, d->c, i)
 		bd_link_disk_holder(ca->bdev, d->disk);
@@ -700,9 +701,13 @@ static void bcache_device_link(struct bcache_device *d, struct cache_set *c,
 	snprintf(d->name, BCACHEDEVNAME_SIZE,
 		 "%s%u", name, d->id);
 
-	WARN(sysfs_create_link(&d->kobj, &c->kobj, "cache") ||
-	     sysfs_create_link(&c->kobj, &d->kobj, d->name),
-	     "Couldn't create device <-> cache set symlinks");
+	ret = sysfs_create_link(&d->kobj, &c->kobj, "cache");
+	if (ret < 0)
+		pr_err("Couldn't create device -> cache set symlink");
+
+	ret = sysfs_create_link(&c->kobj, &d->kobj, d->name);
+	if (ret < 0)
+		pr_err("Couldn't create cache set -> device symlink");
 
 	clear_bit(BCACHE_DEV_UNLINK_DONE, &d->flags);
 }
-- 
2.16.4

