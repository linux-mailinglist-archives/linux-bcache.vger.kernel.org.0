Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF60388F13
	for <lists+linux-bcache@lfdr.de>; Wed, 19 May 2021 15:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344386AbhESNaC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 19 May 2021 09:30:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239739AbhESNaC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 19 May 2021 09:30:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D0A360FF2;
        Wed, 19 May 2021 13:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621430922;
        bh=ONdKLuddvYBQCu8qUCIv/OHdtVAvPsIV/PNuhxIh0eo=;
        h=From:To:Cc:Subject:Date:From;
        b=cYhrtPhdTEbgDAxSiB3tsOTpAtQ2fAfpk1W5aCinPvDyLYVb+bsSMQjHoS7Zo7+rC
         u1TMfm3tJsROioc8855grOEfzhCfToIiWUBZpEMl3GyUTtBmOy68yw13C6523jT9Z4
         Ji+5//hCuBSJySNbxDDHcwRD10oG4p+/2sXw/WL2H0uac6hf2NjdiA1O0tHba4aFHq
         dNDF5wqPcssbVgZyGngCSq7rjbJTCjHKL4VBj/KeA5anUYpGCeQGbvoWt9fsmDZNo+
         aA4hmRWxHXMHZxwNthwd5/Sw8mO3/pRrLbGCSGTXT+vHW3EN0axKDWCgwO8QsPTE+t
         OWfmMComJckUg==
From:   Chao Yu <chao@kernel.org>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>
Subject: [PATCH] bcache: fix error info in register_bcache()
Date:   Wed, 19 May 2021 21:28:23 +0800
Message-Id: <20210519132823.14920-1-chao@kernel.org>
X-Mailer: git-send-email 2.22.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

In register_bcache(), there are several cases we didn't set
correct error info (return value and/or error message):
- if kzalloc() fails, it needs to return ENOMEM and print
"cannot allocate memory";
- if register_cache() fails, it's better to propagate its
return value rather than using default EINVAL.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
---
 drivers/md/bcache/super.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bea8c4429ae8..0a20ccf5a1db 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2620,8 +2620,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (SB_IS_BDEV(sb)) {
 		struct cached_dev *dc = kzalloc(sizeof(*dc), GFP_KERNEL);
 
-		if (!dc)
+		if (!dc) {
+			ret = -ENOMEM;
+			err = "cannot allocate memory";
 			goto out_put_sb_page;
+		}
 
 		mutex_lock(&bch_register_lock);
 		ret = register_bdev(sb, sb_disk, bdev, dc);
@@ -2632,11 +2635,15 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 
-		if (!ca)
+		if (!ca) {
+			ret = -ENOMEM;
+			err = "cannot allocate memory";
 			goto out_put_sb_page;
+		}
 
 		/* blkdev_put() will be called in bch_cache_release() */
-		if (register_cache(sb, sb_disk, bdev, ca) != 0)
+		ret = register_cache(sb, sb_disk, bdev, ca);
+		if (ret)
 			goto out_free_sb;
 	}
 
-- 
2.22.1

