Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DCD431030
	for <lists+linux-bcache@lfdr.de>; Mon, 18 Oct 2021 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhJRGLx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 Oct 2021 02:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhJRGLw (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 Oct 2021 02:11:52 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BE5C06161C
        for <linux-bcache@vger.kernel.org>; Sun, 17 Oct 2021 23:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ig6nlGOY0rCPmDkNqU4JZ/45Q4KaUzCZ/xK/GFBWIbw=; b=UBgjfYsWJQN8qZwWvpNofimFLJ
        9321PSq2YEHHdfXaNhGBG4PMyghrewVMGYdngNzaZg0+UloH7+DbUZLBOlz95aRdnzEriOIhC8mBL
        oQKzrKu2wxpZGxx7oUH6d/CQRmiBnOrmECJ3nNlE5Lkky4tDeZwLl6nx58qF7bb+eVIUJRAeUcOsN
        W478i6P0bnuyczjgK3HhdasZ4/nU+wCpM8QC6COqwv1alsybPsHqRMp+xBpd/Q8aVqnRhM7Z4sul0
        +RISuFyJO47+VkWEH/FR0a/+APUs28zGxPqQ1ftlcM8xZEs4HYk4Twm0BOrDwLwK94d/XUyWU4FRj
        c5DbGCKg==;
Received: from 089144211028.atnat0020.highway.a1.net ([89.144.211.28] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcLq9-00EHjE-BB; Mon, 18 Oct 2021 06:09:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org
Subject: [PATCH 1/4] bcache: remove the cache_dev_name field from struct cache
Date:   Mon, 18 Oct 2021 08:09:31 +0200
Message-Id: <20211018060934.1816088-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018060934.1816088-1-hch@lst.de>
References: <20211018060934.1816088-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Just use the %pg format specifier to print the name directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/bcache.h | 2 --
 drivers/md/bcache/io.c     | 8 ++++----
 drivers/md/bcache/super.c  | 7 +++----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 5fc989a6d4528..47ff9ecea2e29 100644
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
index e4388fe3ab7ef..564357de76404 100644
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
index f2874c77ff797..d0d0257252adc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2338,7 +2338,7 @@ static int cache_alloc(struct cache *ca)
 err_free:
 	module_put(THIS_MODULE);
 	if (err)
-		pr_notice("error %s: %s\n", ca->cache_dev_name, err);
+		pr_notice("error %pg: %s\n", ca->bdev, err);
 	return ret;
 }
 
@@ -2348,7 +2348,6 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
 	const char *err = NULL; /* must be set for any error case */
 	int ret = 0;
 
-	bdevname(bdev, ca->cache_dev_name);
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
 	ca->bdev = bdev;
 	ca->bdev->bd_holder = ca;
@@ -2390,14 +2389,14 @@ static int register_cache(struct cache_sb *sb, struct cache_sb_disk *sb_disk,
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
2.30.2

