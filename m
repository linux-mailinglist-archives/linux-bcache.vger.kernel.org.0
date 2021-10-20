Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390B3434E04
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhJTOku (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:50 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55106 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTOkt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:49 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 71B941FD4D;
        Wed, 20 Oct 2021 14:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740714; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEOJo33/YxLwsi8xF6fCFondKYGBVPI8X3QV3UiauWk=;
        b=afMpllY1SRWv0xhsYFCUEBxWns9Ioh0ducbsvkLdWsO/fPYh+oOlxNue+5grouKjXLJ78U
        Gx5G5Qk+Heh3aI5fRrFgYHL2B+MZXH/uuKO9YrEI97wjOPzA+R4u1WJZ6czLrizlgWFJvW
        7wZBJUvfGO/uH8B55xaLTscdwwmalts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740714;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BEOJo33/YxLwsi8xF6fCFondKYGBVPI8X3QV3UiauWk=;
        b=v940hShOKrWBNvonLdnpc8Ux19EMhQ7E449TLE4PL1AxQNd9zkuNEJfTAMyQIrsK7cM+PN
        /kuUIL81ttplkDCA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 70476A3B81;
        Wed, 20 Oct 2021 14:38:32 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 5/8] bcache: remove the cache_dev_name field from struct cache
Date:   Wed, 20 Oct 2021 22:38:09 +0800
Message-Id: <20211020143812.6403-6-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Just use the %pg format specifier to print the name directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h | 2 --
 drivers/md/bcache/io.c     | 8 ++++----
 drivers/md/bcache/super.c  | 7 +++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5fc989a6d452..47ff9ecea2e2 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -470,8 +470,6 @@ struct cache {
 	atomic_long_t		meta_sectors_written;
 	atomic_long_t		btree_sectors_written;
 	atomic_long_t		sectors_written;
-
-	char			cache_dev_name[BDEVNAME_SIZE];
 };
 
 struct gc_stat {
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index e4388fe3ab7e..564357de7640 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -123,13 +123,13 @@ void bch_count_io_errors(struct cache *ca,
 		errors >>= IO_ERROR_SHIFT;
 
 		if (errors < ca->set->error_limit)
-			pr_err("%s: IO error on %s%s\n",
-			       ca->cache_dev_name, m,
+			pr_err("%pg: IO error on %s%s\n",
+			       ca->bdev, m,
 			       is_read ? ", recovering." : ".");
 		else
 			bch_cache_set_error(ca->set,
-					    "%s: too many IO errors %s\n",
-					    ca->cache_dev_name, m);
+					    "%pg: too many IO errors %s\n",
+					    ca->bdev, m);
 	}
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 05877177b768..01e6b0bce9c0 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2334,7 +2334,7 @@ static int cache_alloc(struct cache *ca)
 err_free:
 	module_put(THIS_MODULE);
 	if (err)
-		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		pr_notice("error %pg: %s\n", ca->bdev, err);
 	return ret;
 }
 
@@ -2344,7 +2344,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	const char *err = NULL; /* must be set for any error case */
 	int ret = 0;
 
-	bdevname(bdev, ca->cache_dev_name);
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
 	ca->bdev = bdev;
 	ca->bdev->bd_holder = ca;
@@ -2386,14 +2385,14 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 		goto out;
 	}
 
-	pr_info("registered cache device %s\n", ca->cache_dev_name);
+	pr_info("registered cache device %pg\n", ca->bdev);
 
 out:
 	kobject_put(&ca->kobj);
 
 err:
 	if (err)
-		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		pr_notice("error %pg: %s\n", ca->bdev, err);
 
 	return ret;
 }
-- 
2.31.1

