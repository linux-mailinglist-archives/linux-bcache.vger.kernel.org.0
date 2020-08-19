Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18B9249B34
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Aug 2020 12:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgHSKwI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 Aug 2020 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgHSKvq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 Aug 2020 06:51:46 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD89C061347
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so927157pjx.5
        for <linux-bcache@vger.kernel.org>; Wed, 19 Aug 2020 03:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=k4uxEwLSaAld7RnITBJo223sJgdxA50WOAoWP3yWeBs=;
        b=OoyaFf944OlmBNKReBUTAvv0j+OHVYwyXkvZGggzmOz9LAaK6F6i2xtVxU0ZTD9Dqp
         UGVnmy/MNTP/y/CiJL8+HUeCI99tYu3Dmyh9kr4W2EGuEpvndXMR8UCUizrVNWfXaYmA
         k5oUrxcV4s69Y45bfC5neD2GIVH+pn7xYhDfbagviZs5KdITZM5jlXDoz6cIy141z1ZC
         jU7I9Tm3sYScxMBaEjMxRP+CCFSPKO5NtXCg4g9ziVZyLWqJV0X0N2g/oNvXAsbqpqU9
         WxmRrpovnPYx4yoC/b/meCFWAATqmWxCwtB8N9/2MgJQn1ngVszlkhRnh9kVMWaHAEwI
         /OLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=k4uxEwLSaAld7RnITBJo223sJgdxA50WOAoWP3yWeBs=;
        b=gM5nF7RS8nD36798Ge7I1y8/NrlCfbcP+BBhW6R4tniLCBgLU00Gm8BzpRg8LjGG1g
         PacnYLhwnFIere5Labh9vNfPNL7b8F5xL28DMqjbOORIBXVC4252MpheJ5zB8K25tSSQ
         QzDFwE+E0FjHmn/3/1LEirwRvVQHF4mhTC0cEGOb8I/ZF0YV88uZ8U9r9FYlHQhpwPxj
         JhyoBbcYUKTC+px0SVkfxcl4tklK/i2fq+MPLjjh7Vh4EX0PaeMCnacPM8bf6FWQoht5
         hOM47UcrpJY76jDMLQfSrYPCdDCIeHb3YeET9cSgev5+3B0msMp7AtVS3TS6EB/rSbKt
         zPKQ==
X-Gm-Message-State: AOAM533prRL1/mPotR/V3yCH7y1DcedeprgrJDpS22wMTaaWEEhHUKAo
        83JyVo75rzUqOwRMbwJm9k7IEO+1WGVblsbl
X-Google-Smtp-Source: ABdhPJyqbuIFCCPuz/YCXjHR2bMAo/DcGtbDDzlP5/Yfpp0EFBibYmNDOVq2PXQWOmuAgr1GqWsAIQ==
X-Received: by 2002:a17:90a:ce96:: with SMTP id g22mr1333977pju.146.1597834291662;
        Wed, 19 Aug 2020 03:51:31 -0700 (PDT)
Received: from gmail.com ([119.8.124.38])
        by smtp.gmail.com with ESMTPSA id k21sm24844830pgl.0.2020.08.19.03.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 03:51:31 -0700 (PDT)
From:   Shaoxiong Li <dahefanteng@gmail.com>
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de
Subject: [PATCH 1/3] bcache-tools: Fix potential coredump issues
Date:   Wed, 19 Aug 2020 18:51:26 +0800
Message-Id: <a6b9fc134e5dd73d1a6f3945fd649d7aa23cff9e.1597817961.git.dahefanteng@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In some distributions, such as opensuse 15.2, when the free_dev
function is called, it may refer to the memory that has been
released, causing a coredump. Changing 'list_for_each_entry'
to 'list_for_each_entry_safe' can avoid this problem.

Signed-off-by: Shaoxiong Li <dahefanteng@gmail.com>
---
 bcache.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/bcache.c b/bcache.c
index 50e3a88..3b963e4 100644
--- a/bcache.c
+++ b/bcache.c
@@ -175,9 +175,9 @@ int version_usagee(void)
 
 void free_dev(struct list_head *head)
 {
-	struct dev *dev;
+	struct dev *dev, *n;
 
-	list_for_each_entry(dev, head, dev_list) {
+	list_for_each_entry_safe(dev, n, head, dev_list) {
 		free(dev);
 	}
 }
@@ -185,7 +185,7 @@ void free_dev(struct list_head *head)
 int show_bdevs_detail(void)
 {
 	struct list_head head;
-	struct dev *devs;
+	struct dev *devs, *n;
 
 	INIT_LIST_HEAD(&head);
 	int ret;
@@ -197,7 +197,7 @@ int show_bdevs_detail(void)
 	}
 	printf("Name\t\tUuid\t\t\t\t\tCset_Uuid\t\t\t\tType\t\tState");
 	printf("\t\t\tBname\t\tAttachToDev\tAttachToCset\n");
-	list_for_each_entry(devs, &head, dev_list) {
+	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		printf("%s\t%s\t%s\t%lu", devs->name, devs->uuid,
 		       devs->cset, devs->version);
 		switch (devs->version) {
@@ -242,7 +242,7 @@ int show_bdevs_detail(void)
 int show_bdevs(void)
 {
 	struct list_head head;
-	struct dev *devs;
+	struct dev *devs, *n;
 
 	INIT_LIST_HEAD(&head);
 	int ret;
@@ -254,7 +254,7 @@ int show_bdevs(void)
 	}
 
 	printf("Name\t\tType\t\tState\t\t\tBname\t\tAttachToDev\n");
-	list_for_each_entry(devs, &head, dev_list) {
+	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		printf("%s\t%lu", devs->name, devs->version);
 		switch (devs->version) {
 			// These are handled the same by the kernel
@@ -428,7 +428,7 @@ int detail_single(char *devname)
 int tree(void)
 {
 	struct list_head head;
-	struct dev *devs, *tmp;
+	struct dev *devs, *tmp, *n, *m;
 
 	INIT_LIST_HEAD(&head);
 	int ret;
@@ -445,13 +445,13 @@ int tree(void)
 	tb = scols_new_table();
 	scols_table_new_column(tb, ".", 0.1, SCOLS_FL_TREE);
 	scols_table_new_column(tb, "", 2, SCOLS_FL_TRUNC);
-	list_for_each_entry(devs, &head, dev_list) {
+	list_for_each_entry_safe(devs, n, &head, dev_list) {
 		if ((devs->version == BCACHE_SB_VERSION_CDEV
 		     || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID)
 		    && strcmp(devs->state, BCACHE_BASIC_STATE_ACTIVE) == 0) {
 			dad = scols_table_new_line(tb, NULL);
 			scols_line_set_data(dad, COL_CSET, devs->name);
-			list_for_each_entry(tmp, &head, dev_list) {
+			list_for_each_entry_safe(tmp, m, &head, dev_list) {
 				if (strcmp(devs->cset, tmp->attachuuid) ==
 				    0) {
 					son =
-- 
2.17.1

