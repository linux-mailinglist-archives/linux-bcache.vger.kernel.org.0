Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E9743F6F1
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Oct 2021 08:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhJ2GLe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Oct 2021 02:11:34 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58958 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJ2GLd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Oct 2021 02:11:33 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6AC8E1FD5C;
        Fri, 29 Oct 2021 06:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635487744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGExXchp2MEDt+/pa1UeZFdjleACyEfGd34XUnyKO4M=;
        b=e1iUxZF9/ct402iLbfJYA/tOcmjVifrR2WIeOAYoKRzB/bQC86DCXw8SQgUxy5M1SwiXqj
        Zefl35Uf/cXPQKHBn7okUGjSi4wy9PI75yCjM1C7/wtxJNRBgHoLMJMrQAkGXz8gX5+mrd
        fNHhyLQm6SrhlJGRLrjTICG+6cE04zg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635487744;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AGExXchp2MEDt+/pa1UeZFdjleACyEfGd34XUnyKO4M=;
        b=9SQp+BdkhhbUglnVW7KmmLCXh5NXZT2k2mkDNoVJrhGu5mtCBAqvuBb8ig1Uxqpt7dCRVh
        4COrqZg5lUyi49CQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 8B583A3B81;
        Fri, 29 Oct 2021 06:09:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axbeo@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] bcache: move uapi header bcache.h to bcache code directory
Date:   Fri, 29 Oct 2021 14:08:50 +0800
Message-Id: <20211029060851.119872-2-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029060851.119872-1-colyli@suse.de>
References: <20211029060851.119872-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The header file include/uapi/linux/bcache.h is not really a user space
API heaer. This file defines the ondisk format of bcache internal meta
data but no one includes it from user space, bcache-tools has its own
copy of this header with minor modification.

Therefore, this patch moves include/uapi/linux/bcache.h to bcache code
directory as drivers/md/bcache/bcache_ondisk.h.

Suggested-by: Arnd Bergmann <arnd@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bcache.h                                     | 2 +-
 .../uapi/linux/bcache.h => drivers/md/bcache/bcache_ondisk.h   | 0
 drivers/md/bcache/bset.h                                       | 2 +-
 drivers/md/bcache/features.c                                   | 2 +-
 drivers/md/bcache/features.h                                   | 3 ++-
 5 files changed, 5 insertions(+), 4 deletions(-)
 rename include/uapi/linux/bcache.h => drivers/md/bcache/bcache_ondisk.h (100%)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 941685409c68..9ed9c955add7 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -178,7 +178,6 @@
 
 #define pr_fmt(fmt) "bcache: %s() " fmt, __func__
 
-#include <linux/bcache.h>
 #include <linux/bio.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
@@ -190,6 +189,7 @@
 #include <linux/workqueue.h>
 #include <linux/kthread.h>
 
+#include "bcache_ondisk.h"
 #include "bset.h"
 #include "util.h"
 #include "closure.h"
diff --git a/include/uapi/linux/bcache.h b/drivers/md/bcache/bcache_ondisk.h
similarity index 100%
rename from include/uapi/linux/bcache.h
rename to drivers/md/bcache/bcache_ondisk.h
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index a50dcfda656f..d795c84246b0 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -2,10 +2,10 @@
 #ifndef _BCACHE_BSET_H
 #define _BCACHE_BSET_H
 
-#include <linux/bcache.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#include "bcache_ondisk.h"
 #include "util.h" /* for time_stats */
 
 /*
diff --git a/drivers/md/bcache/features.c b/drivers/md/bcache/features.c
index 6d2b7b84a7b7..634922c5601d 100644
--- a/drivers/md/bcache/features.c
+++ b/drivers/md/bcache/features.c
@@ -6,7 +6,7 @@
  * Copyright 2020 Coly Li <colyli@suse.de>
  *
  */
-#include <linux/bcache.h>
+#include "bcache_ondisk.h"
 #include "bcache.h"
 #include "features.h"
 
diff --git a/drivers/md/bcache/features.h b/drivers/md/bcache/features.h
index d1c8fd3977fc..09161b89c63e 100644
--- a/drivers/md/bcache/features.h
+++ b/drivers/md/bcache/features.h
@@ -2,10 +2,11 @@
 #ifndef _BCACHE_FEATURES_H
 #define _BCACHE_FEATURES_H
 
-#include <linux/bcache.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#include "bcache_ondisk.h"
+
 #define BCH_FEATURE_COMPAT		0
 #define BCH_FEATURE_RO_COMPAT		1
 #define BCH_FEATURE_INCOMPAT		2
-- 
2.31.1

