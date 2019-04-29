Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E613E2B3
	for <lists+linux-bcache@lfdr.de>; Mon, 29 Apr 2019 14:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbfD2Mc1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 29 Apr 2019 08:32:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43803 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfD2Mc1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 29 Apr 2019 08:32:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id n8so4997702plp.10;
        Mon, 29 Apr 2019 05:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rPe/3xADwYrAoEjP8Q48sld2BYo1tLyw2GTQz4U4xbw=;
        b=EJgWPIuusv7Kl1N8bGa9VTgBciy+zPdeRNWHYig+fP8t/MKtm+UorsKjEH0cXNTl6U
         XcnI/EImMevT9eKGFFuoSWmRl8ZnWUyP0ae2v9wE8gtRj0zWXhcDTkc9gfyj/uIAL2dT
         4PxgvTWU/10hFQO6GPQ/AGgdFG455fAP/z1kZe7Y64zpADfwmO7a4RASi25X4cdeuG1z
         RjOUqkdUrefnalcXo2meAuCiSxwIEBCBDlglUOCMEmTqUIS5nciLE7gbD2XmpJuIAKa2
         RFlJbOlus5+qll9w7V7mDpzpiCDULLmR+ASLGXi6IAP5oQTZX0FtLGM+0gOH9sXH58DJ
         m3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rPe/3xADwYrAoEjP8Q48sld2BYo1tLyw2GTQz4U4xbw=;
        b=G5kyog4IhKpW8bSETRItMwxWPm/S8nWJnzw7GwwSBGX3GvOcuRGQ6FD9sbyS8pP1hr
         C42a/D8Itvgow4nrW9nXsfnxugx38pBZY9pomZuTYrfdHN7ne5pBNCG9b43lvgDwelX4
         RnuAvWnIe+hQyhgIe09nc2hN/ds3qKMCpiK7IIhk5Rrqd1VSOO/8o4qKmGEP6N2hzOTB
         UTdX79ZQ1Ex2F4/npsEieV2Xji8OpY7jju3ieglz/39uCJVkyO4s1LdVyn1t3S2mDrxS
         9ikvA0yQiHlHRuUmUbWK/y4HQKv9CPsk/yLxD71ma0mu/H2r3Cuc8xW0OZR9ZEDT6cfP
         cAVA==
X-Gm-Message-State: APjAAAXw3joYUSkBvZiKZ+IugPOeEyZt/ToAvlIc26OxbI4pTKalFQzO
        zO/4eHHITv2Jwrn2RH1pFpo=
X-Google-Smtp-Source: APXvYqzFPRgbsIlk2oXaEbCWGawn9uL3z2EQwx2hvHYY4VW3K/j/dof2AutLWuVvtGhfiU2TMkOGqw==
X-Received: by 2002:a17:902:6b0b:: with SMTP id o11mr25145727plk.266.1556541146818;
        Mon, 29 Apr 2019 05:32:26 -0700 (PDT)
Received: from localhost.localdomain (172.96.249.239.16clouds.com. [172.96.249.239])
        by smtp.gmail.com with ESMTPSA id c62sm76305823pfg.33.2019.04.29.05.32.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 05:32:25 -0700 (PDT)
From:   Guoju Fang <fangguoju@gmail.com>
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Guoju Fang <fangguoju@gmail.com>
Subject: [PATCH] bcache: fix memleak when error occurred before journal replay
Date:   Mon, 29 Apr 2019 08:30:59 -0400
Message-Id: <1556541059-21234-1-git-send-email-fangguoju@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

A list of struct journal_replay is allocated when register cache device
and will be freed when journal replay complete. It will cause memory
leaks if some error occurred before journal replay.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
---
 drivers/md/bcache/super.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a697a3a..e4289291 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1782,6 +1782,7 @@ static void run_cache_set(struct cache_set *c)
 	struct cache *ca;
 	struct closure cl;
 	unsigned int i;
+	LIST_HEAD(journal);
 
 	closure_init_stack(&cl);
 
@@ -1790,7 +1791,6 @@ static void run_cache_set(struct cache_set *c)
 	set_gc_sectors(c);
 
 	if (CACHE_SYNC(&c->sb)) {
-		LIST_HEAD(journal);
 		struct bkey *k;
 		struct jset *j;
 
@@ -1820,25 +1820,25 @@ static void run_cache_set(struct cache_set *c)
 
 		err = "bad btree root";
 		if (__bch_btree_ptr_invalid(c, k))
-			goto err;
+			goto free_journal;
 
 		err = "error reading btree root";
 		c->root = bch_btree_node_get(c, NULL, k,
 					     j->btree_level,
 					     true, NULL);
 		if (IS_ERR_OR_NULL(c->root))
-			goto err;
+			goto free_journal;
 
 		list_del_init(&c->root->list);
 		rw_unlock(true, c->root);
 
 		err = uuid_read(c, j, &cl);
 		if (err)
-			goto err;
+			goto free_journal;
 
 		err = "error in recovery";
 		if (bch_btree_check(c))
-			goto err;
+			goto free_journal;
 
 		bch_journal_mark(c, &journal);
 		bch_initial_gc_finish(c);
@@ -1854,7 +1854,7 @@ static void run_cache_set(struct cache_set *c)
 		err = "error starting allocator thread";
 		for_each_cache(ca, c, i)
 			if (bch_cache_allocator_start(ca))
-				goto err;
+				goto free_journal;
 
 		/*
 		 * First place it's safe to allocate: btree_check() and
@@ -1938,6 +1938,14 @@ static void run_cache_set(struct cache_set *c)
 
 	set_bit(CACHE_SET_RUNNING, &c->flags);
 	return;
+
+free_journal:
+	while (!list_empty(&journal)) {
+		struct journal_replay *jr = list_first_entry(&journal,
+			    struct journal_replay, list);
+		list_del(&jr->list);
+		kfree(jr);
+	}
 err:
 	closure_sync(&cl);
 	/* XXX: test this, it's broken */
-- 
1.8.3.1

