Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A84943434B
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 04:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhJTCPl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Oct 2021 22:15:41 -0400
Received: from zg8tmtm5lju5ljm3lje2naaa.icoremail.net ([139.59.37.164]:53584
        "HELO zg8tmtm5lju5ljm3lje2naaa.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229555AbhJTCPk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Oct 2021 22:15:40 -0400
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewAHVOY6e29h9v4BAA--.4195S2;
        Wed, 20 Oct 2021 10:13:19 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linf@wangsu.com
Subject: [PATCH] bcache: use pr_err instead of pr_notice if we are really error
Date:   Wed, 20 Oct 2021 10:13:13 +0800
Message-Id: <20211020021313.140414-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewAHVOY6e29h9v4BAA--.4195S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kw43AF1ktF4UAF4kGF1Dtrb_yoW8WrWrpF
        WxC39xA393uw4UXayrZF4Dua4rX3y7tFZrZw1DGw42kF129r1j9rW7J34xAF1UZryfXa12
        qa4UJF4j93WxJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bcache we have:
./bset.c:			pr_notice("loop %u, %llu per us\n", size,
./super.c:	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
./super.c:		pr_notice("invalidating existing data\n");
./super.c:		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
./super.c:		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
./super.c:			pr_notice("Timeout waiting for devices to be closed\n");

and 3 sites with string 'error' are really error happening on device
register.

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 drivers/md/bcache/super.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff79..18a2e4bea9c2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1493,7 +1493,7 @@ static int register_bdev(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 	return 0;
 err:
-	pr_notice("error %s: %s\n", dc->backing_dev_name, err);
+	pr_err("%s: %s\n", dc->backing_dev_name, err);
 	bcache_device_stop(&dc->disk);
 	return ret;
 }
@@ -2338,7 +2338,7 @@ static int cache_alloc(struct cache *ca)
 err_free:
 	module_put(THIS_MODULE);
 	if (err)
-		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		pr_err("%s: %s\n", ca->cache_dev_name, err);
 	return ret;
 }
 
@@ -2397,7 +2397,7 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 
 err:
 	if (err)
-		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		pr_err("%s: %s\n", ca->cache_dev_name, err);
 
 	return ret;
 }
-- 
2.31.1

