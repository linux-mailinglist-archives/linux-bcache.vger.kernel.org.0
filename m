Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0CF289130
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Oct 2020 20:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731836AbgJISgN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Oct 2020 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388163AbgJISfO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Oct 2020 14:35:14 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1F5C0613D2;
        Fri,  9 Oct 2020 11:35:14 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h7so11314454wre.4;
        Fri, 09 Oct 2020 11:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fp0OZT9MTT7xwcxYblmNa84m9LyRf8G+kscPBy9vgjY=;
        b=JhdO6Gz1s0VP4ld80HJjKvR5JCmbKHqnpU3QiID9cm5p2CfzIpUj+GUTx13C2x/piP
         cDtLXlyrft/acE+o2BirtRgXt3SVUyIcN/TEdLesEYW2WyxLTgpnMJvLP5N2k68KEKUY
         t/3b0ZMlEOM0Fl3d63C+FbwWG3vlQX7tamwWdvji6G0IH4DOoxyeLtRZ1jZ83JU0aglB
         WIJytBLBh4vct3vu/lBa7oR+rfV/gzLn1EtBbPRJnRTCEBcPYbhLWFq7Ox+hPhPhQvau
         OXJhTg8pD5ZknOxq7SlQkOb1VremcnLYOlYzUzKXQzaw3mATprQ7lbrq3JV++N5TjL6p
         w+Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fp0OZT9MTT7xwcxYblmNa84m9LyRf8G+kscPBy9vgjY=;
        b=Mqm0JG6lV6dfltoDwXbYo/uTFxr+1nupmYfUSGlF6+Hw3QSFyRTKJSAFjYv2QNsbpB
         m+hAAqqXUn/UVABqgo/yg8jZbMH6DzQATPhtuzXrS4oJmUzlMjYMaYvvZ91qwJqi6arP
         xOgkypmPvnupUDt3I1Lv2gQX/Ota+qlav0Y9IcV4E23+Ekii/43ksU5xfwXwxO94/NB2
         Cq7x21ajeWH3mvhzW5BmgjYOK52aEEhp4xHLY554j91NP1B+ZDtfM00Kpq955UsTZzVL
         k7u6MRSBFGDRKR7kqZuu8D1N/KvMhPQoOzvfFgJk5hD6cu6g5PEZS091IWtgt3hBNNkZ
         tFeA==
X-Gm-Message-State: AOAM532Nrkmes/6QFu+v8iwM7PhFardOGI7P90Ejh8V5sIyXWjxomfdJ
        /NKGZumnvq45AcUA/EFUwZw=
X-Google-Smtp-Source: ABdhPJymJtXYmPup0xoycV9ek3j2L3bmJ4HvMvUH7lFkmJV3xot97Gqd4S6b1hfh9Ps+gPPGmZcw+A==
X-Received: by 2002:adf:ec06:: with SMTP id x6mr16231295wrn.404.1602268513078;
        Fri, 09 Oct 2020 11:35:13 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id i15sm13305918wrb.91.2020.10.09.11.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:35:12 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>, Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bcache: Use #ifdef instead of boolean variable
Date:   Fri,  9 Oct 2020 19:34:47 +0100
Message-Id: <20201009183447.1611204-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The variable async_registration is used to indicate whether or not
CONFIG_BCACHE_ASYNC_REGISTRATION is enabled, triggering a (false)
warning in Coverity about unreachable code. However, it seems clearer in
this case just to use an #ifdef, so let's do that instead.

Addresses-Coverity-ID: 1497746: Control flow issues (DEADCODE)
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/md/bcache/super.c | 40 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 46a00134a36a..6d4127881c6a 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2504,11 +2504,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb_disk *sb_disk;
 	struct block_device *bdev;
 	ssize_t ret;
-	bool async_registration = false;
-
-#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
-	async_registration = true;
-#endif
 
 	ret = -EBUSY;
 	err = "failed to reference bcache module";
@@ -2563,26 +2558,25 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 
 	err = "failed to register device";
 
-	if (async_registration) {
-		/* register in asynchronous way */
-		struct async_reg_args *args =
-			kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
-
-		if (!args) {
-			ret = -ENOMEM;
-			err = "cannot allocate memory";
-			goto out_put_sb_page;
-		}
+#ifdef CONFIG_BCACHE_ASYNC_REGISTRATION
+	/* register in asynchronous way */
+	struct async_reg_args *args =
+		kzalloc(sizeof(struct async_reg_args), GFP_KERNEL);
 
-		args->path	= path;
-		args->sb	= sb;
-		args->sb_disk	= sb_disk;
-		args->bdev	= bdev;
-		register_device_aync(args);
-		/* No wait and returns to user space */
-		goto async_done;
+	if (!args) {
+		ret = -ENOMEM;
+		err = "cannot allocate memory";
+		goto out_put_sb_page;
 	}
 
+	args->path	= path;
+	args->sb	= sb;
+	args->sb_disk	= sb_disk;
+	args->bdev	= bdev;
+	register_device_aync(args);
+	/* No wait and returns to user space */
+	return size;
+#else
 	if (SB_IS_BDEV(sb)) {
 		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 
@@ -2605,12 +2599,12 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		if (register_cache(sb, sb_disk, bdev, ca) != 0)
 			goto out_free_sb;
 	}
+#endif
 
 done:
 	kfree(sb);
 	kfree(path);
 	module_put(THIS_MODULE);
-async_done:
 	return size;
 
 out_put_sb_page:
-- 
2.28.0

