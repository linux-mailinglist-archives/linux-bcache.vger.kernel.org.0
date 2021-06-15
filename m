Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D4A3A769F
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Jun 2021 07:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhFOFvk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Jun 2021 01:51:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57268 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhFOFvi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 53C43219C5;
        Tue, 15 Jun 2021 05:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736172; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TR9Qxjp87eDoqfnf8N5jLZ9ERrRCE+jLsCBNMtHhrSs=;
        b=X0eo75ALDLmLZlvnlqDLDAyX52MmwDQNCbSfmNRPQ9grLkko/2Zctp9ytylKvy8TDn0SCn
        22DklRIKVvrePvuBsp7kzMsKFzRUDboiX44V+F0JU2iqrO6Qlf6TTBfrtk0ewkfxwFyHZM
        pg4FKS1TfgkiTIwFvlTD5W01RqmOF+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736172;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TR9Qxjp87eDoqfnf8N5jLZ9ERrRCE+jLsCBNMtHhrSs=;
        b=lEsT8ytEudYIPyKvm1KmkGwAn9m7PB5RiYqmGJl18oaGtBTe9o0r2jEjwqttpac6GJVj96
        vc8uOigAdHq+JWCg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id B505DA3B98;
        Tue, 15 Jun 2021 05:49:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 01/14] bcache: fix error info in register_bcache()
Date:   Tue, 15 Jun 2021 13:49:08 +0800
Message-Id: <20210615054921.101421-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210615054921.101421-1-colyli@suse.de>
References: <20210615054921.101421-1-colyli@suse.de>
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
Signed-off-by: Coly Li <colyli@suse.de>
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
2.26.2

