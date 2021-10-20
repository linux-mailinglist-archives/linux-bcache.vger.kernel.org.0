Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A3E434DFF
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbhJTOko (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:40:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:55080 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJTOko (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:40:44 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 69DCA1FD4B;
        Wed, 20 Oct 2021 14:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740709; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2PnW09hayFmlTk6ugT7GH3+0Zj6Z6jcF/OpOzMLIHM=;
        b=gEbOk2Oidf+HSZJxM8bSXy8RGXRkedRXcszUUDmTt1a6Bs/Jryedj0/cnmxmMyvsPk/HLs
        sEKsWnHt5eJibsS3K4BmVAyN0CDa8qBVv8pB28SqLN/YHb0pQntPoNYT/WEF+kKK8pSecn
        15g8DSrSSczY6eoxNRg9QwB9yLFerLc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740709;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b2PnW09hayFmlTk6ugT7GH3+0Zj6Z6jcF/OpOzMLIHM=;
        b=xrrkNtjjn/q9bKO7gmeXxu09Bj5Xea9CKQz+iKDRdYUNjMQoBzDOZGJgOU7ihSpXzv2zyQ
        lsIpRYITu0NiP4AA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 99E1EA3B93;
        Wed, 20 Oct 2021 14:38:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 3/8] bcache: fix error info in register_bcache()
Date:   Wed, 20 Oct 2021 22:38:07 +0800
Message-Id: <20211020143812.6403-4-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020143812.6403-1-colyli@suse.de>
References: <20211020143812.6403-1-colyli@suse.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ab64b7762b6e..6bc5ee42a059 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2613,8 +2613,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
@@ -2625,11 +2628,15 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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
2.31.1

