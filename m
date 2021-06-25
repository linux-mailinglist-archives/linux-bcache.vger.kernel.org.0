Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08863B3A75
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Jun 2021 03:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhFYBdv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Jun 2021 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFYBdv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Jun 2021 21:33:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 088D2C061756
        for <linux-bcache@vger.kernel.org>; Thu, 24 Jun 2021 18:31:30 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id v7so6278571pgl.2
        for <linux-bcache@vger.kernel.org>; Thu, 24 Jun 2021 18:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZmdlkLb9qygG+BsoJAXXq0E8pwt0TZLM8iArnZO4P3g=;
        b=ZDfFvhxYhcrtchEoJxGdhPdPx20bow2ypX7HqruDhOtN8lnPoa1sx1jAnfktArHajZ
         1/6dznIg2FnDo4HOjXugOwG7vhWu0SVPTacsevlVWFIa92Do38NPZSDfw3EQwwEKoJ6t
         aq5oGDL9CIjajGBzX20p4QH52XKP5aR5e6loAChvRW6ls+X79MZRCzF94pwVp6KuuqWi
         2W3hmWFnTksxNpiurgk1t8kcFAVHyAdUyLp6Cad30lYlgO/pKJR1ocUOoIuJR0k6YjVF
         ITbdas1dHVQ8jzREZ2U9agGzbcGaAvPw1GpbB7LKKSjZI9EuvWCP+kMDEmCH6iV57v/H
         gayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZmdlkLb9qygG+BsoJAXXq0E8pwt0TZLM8iArnZO4P3g=;
        b=kLSm3ABDNsaEwiXqf0zIGHwfWXapGeIs9J023Q9oeaIR0dzEZz1fNSeCb8huul9nWu
         jj9Cjk+Qz82gOAE8xL/nJoiaYkbM+KZRI+kUhWz9MNleKriIMoYP6bANh6c1jUr+Sghp
         gr/FgMDW5nw8XDjbD4R/r/Az45cUHX9lITFwfPHeCf0SNZWUVoM3SJjqehi2VY6OvGaT
         aXmsxzJ+YdmGhJ9SuLq3gauO4/Fc9hyCRUqbHo90711BgWUdeuLB5fOr1fvZ1LeIb5lP
         0eXSAg8AltZJRjyhSSrYoXFpBJA4cNgGwghwWq99kGsd+Lh6cvqQcoPJqRmeD98h0dvQ
         OwAQ==
X-Gm-Message-State: AOAM530Wg2LkXrgnsf3o1cAG4J1/gHVeVQBHRVduWGtMp4hPn+eZFhHP
        LjtHwGvw2rWrzOzHzvuyMKGnr95JH2Jy++8g
X-Google-Smtp-Source: ABdhPJytInSY7LZQ+139PXicGZ8tdcUdf60lr46/Hj4K/6oxOFIK6UnOcAuva5qQXiDtysOL5ev+3A==
X-Received: by 2002:a05:6a00:852:b029:2f9:e608:e10d with SMTP id q18-20020a056a000852b02902f9e608e10dmr7876031pfk.71.1624584689320;
        Thu, 24 Jun 2021 18:31:29 -0700 (PDT)
Received: from instance-1.asia-east2-b.c.zippy-catwalk-317715.internal (2.31.92.34.bc.googleusercontent.com. [34.92.31.2])
        by smtp.gmail.com with ESMTPSA id y8sm4168612pfe.162.2021.06.24.18.31.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jun 2021 18:31:28 -0700 (PDT)
From:   yanhuan916@gmail.com
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, dahefanteng@gmail.com,
        Huan Yan <yanhuan916@gmail.com>
Subject: [PATCH 2/2] bcache-tools: Correct super block version check codes
Date:   Fri, 25 Jun 2021 09:30:30 +0800
Message-Id: <1624584630-9283-2-git-send-email-yanhuan916@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
References: <1624584630-9283-1-git-send-email-yanhuan916@gmail.com>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Huan Yan <yanhuan916@gmail.com>

This patch add missing super block version below:
BCACHE_SB_VERSION_CDEV_WITH_UUID
BCACHE_SB_VERSION_BDEV_WITH_OFFSET
BCACHE_SB_VERSION_CDEV_WITH_FEATURES
BCACHE_SB_VERSION_BDEV_WITH_FEATURES
---
 bcache.c | 22 +++++++++++++++-------
 bcache.h |  3 ++-
 lib.c    | 15 ++++++++++-----
 make.c   |  8 ++++++--
 show.c   |  6 ++++--
 5 files changed, 37 insertions(+), 17 deletions(-)

diff --git a/bcache.c b/bcache.c
index 1c4cef9..62ed08d 100644
--- a/bcache.c
+++ b/bcache.c
@@ -199,7 +199,8 @@ int tree(void)
 	sprintf(out, "%s", begin);
 	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		if ((devs->version == BCACHE_SB_VERSION_CDEV
-		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
+		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
+		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
 		    && strcmp(devs->state, BCACHE_BASIC_STATE_ACTIVE) == 0) {
 			sprintf(out + strlen(out), "%s\n", devs->name);
 			list_for_each_entry_safe(tmp, m, &head, dev_list) {
@@ -231,7 +232,8 @@ int attach_both(char *cdev, char *backdev)
 	if (ret != 0)
 		return ret;
 	if (type != BCACHE_SB_VERSION_BDEV
-	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
+	    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+	    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 		fprintf(stderr, "%s is not an backend device\n", backdev);
 		return 1;
 	}
@@ -244,7 +246,8 @@ int attach_both(char *cdev, char *backdev)
 	if (strlen(cdev) != 36) {
 		ret = detail_dev(cdev, &bd, &cd, NULL, &type);
 		if (type != BCACHE_SB_VERSION_CDEV
-		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+		    && type != BCACHE_SB_VERSION_CDEV_WITH_UUID
+		    && type != BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 			fprintf(stderr, "%s is not an cache device\n", cdev);
 			return 1;
 		}
@@ -359,10 +362,13 @@ int main(int argc, char **argv)
 		ret = detail_dev(devname, &bd, &cd, NULL, &type);
 		if (ret != 0)
 			return ret;
-		if (type == BCACHE_SB_VERSION_BDEV) {
+		if (type == BCACHE_SB_VERSION_BDEV
+		    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 			return stop_backdev(devname);
 		} else if (type == BCACHE_SB_VERSION_CDEV
-			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+			   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
+			   || type == BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 			return unregister_cset(cd.base.cset);
 		}
 		return 1;
@@ -408,7 +414,8 @@ int main(int argc, char **argv)
 			return ret;
 		}
 		if (type != BCACHE_SB_VERSION_BDEV
-		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
+		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 			fprintf(stderr,
 				"Only backend device is suppported\n");
 			return 1;
@@ -434,7 +441,8 @@ int main(int argc, char **argv)
 			return ret;
 		}
 		if (type != BCACHE_SB_VERSION_BDEV
-		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET) {
+		    && type != BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		    && type != BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 			fprintf(stderr,
 				"Only backend device is suppported\n");
 			return 1;
diff --git a/bcache.h b/bcache.h
index 2ae25ee..b10d4c0 100644
--- a/bcache.h
+++ b/bcache.h
@@ -164,7 +164,8 @@ struct cache_sb {
 static inline bool SB_IS_BDEV(const struct cache_sb *sb)
 {
 	return sb->version == BCACHE_SB_VERSION_BDEV
-		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET;
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		|| sb->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES;
 }
 
 BITMASK(CACHE_SYNC,		struct cache_sb, flags, 0, 1);
diff --git a/lib.c b/lib.c
index 745dab6..ea1f18d 100644
--- a/lib.c
+++ b/lib.c
@@ -281,10 +281,12 @@ int get_dev_bname(char *devname, char *bname)
 int get_bname(struct dev *dev, char *bname)
 {
 	if (dev->version == BCACHE_SB_VERSION_CDEV
-	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
+	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
+	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
 		strcpy(bname, BCACHE_NO_SUPPORT);
 	else if (dev->version == BCACHE_SB_VERSION_BDEV
-		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
 		return get_dev_bname(dev->name, bname);
 	return 0;
 }
@@ -317,10 +319,12 @@ int get_backdev_attachpoint(char *devname, char *point)
 int get_point(struct dev *dev, char *point)
 {
 	if (dev->version == BCACHE_SB_VERSION_CDEV
-	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
+	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
+	    || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
 		strcpy(point, BCACHE_NO_SUPPORT);
 	else if (dev->version == BCACHE_SB_VERSION_BDEV
-		   || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET)
+		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+		 || dev->version == BCACHE_SB_VERSION_BDEV_WITH_FEATURES)
 		return get_backdev_attachpoint(dev->name, point);
 	return 0;
 }
@@ -331,7 +335,8 @@ int cset_to_devname(struct list_head *head, char *cset, char *devname)
 
 	list_for_each_entry(dev, head, dev_list) {
 		if ((dev->version == BCACHE_SB_VERSION_CDEV
-		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
+		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
+		     || dev->version == BCACHE_SB_VERSION_CDEV_WITH_FEATURES)
 		    && strcmp(dev->cset, cset) == 0)
 			strcpy(devname, dev->name);
 	}
diff --git a/make.c b/make.c
index 39b381a..d3b4baa 100644
--- a/make.c
+++ b/make.c
@@ -272,10 +272,14 @@ static void write_sb(char *dev, struct sb_context *sbc, bool bdev, bool force)
 			ret = detail_dev(dev, &bd, &cd, NULL, &type);
 			if (ret != 0)
 				exit(EXIT_FAILURE);
-			if (type == BCACHE_SB_VERSION_BDEV) {
+			if (type == BCACHE_SB_VERSION_BDEV
+			    || type == BCACHE_SB_VERSION_BDEV_WITH_OFFSET
+			    || type == BCACHE_SB_VERSION_BDEV_WITH_FEATURES) {
 				ret = stop_backdev(dev);
 			} else if (type == BCACHE_SB_VERSION_CDEV
-				|| type == BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+				   || type == BCACHE_SB_VERSION_CDEV_WITH_UUID
+				   || type ==
+				   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 				ret = unregister_cset(cd.base.cset);
 			} else {
 				fprintf(stderr,
diff --git a/show.c b/show.c
index 6175f3f..15cdb95 100644
--- a/show.c
+++ b/show.c
@@ -75,8 +75,9 @@ int show_bdevs_detail(void)
 		if (strlen(devs->attachuuid) == 36) {
 			cset_to_devname(&head, devs->cset, attachdev);
 		} else if (devs->version == BCACHE_SB_VERSION_CDEV
+			   || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
 			   || devs->version ==
-			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+			   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 			strcpy(attachdev, BCACHE_NO_SUPPORT);
 		} else {
 			strcpy(attachdev, BCACHE_ATTACH_ALONE);
@@ -135,8 +136,9 @@ int show_bdevs(void)
 		if (strlen(devs->attachuuid) == 36) {
 			cset_to_devname(&head, devs->cset, attachdev);
 		} else if (devs->version == BCACHE_SB_VERSION_CDEV
+			   || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
 			   || devs->version ==
-			   BCACHE_SB_VERSION_CDEV_WITH_UUID) {
+			   BCACHE_SB_VERSION_CDEV_WITH_FEATURES) {
 			strcpy(attachdev, BCACHE_NO_SUPPORT);
 		} else {
 			strcpy(attachdev, BCACHE_ATTACH_ALONE);
-- 
1.8.3.1

