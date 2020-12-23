Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3902E1DB9
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Dec 2020 16:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgLWPGS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Dec 2020 10:06:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:58158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgLWPGS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Dec 2020 10:06:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C7B1AAE12;
        Wed, 23 Dec 2020 15:05:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Yi Li <yili@winhong.com>, Christoph Hellwig <hch@lst.de>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/2] bcache:remove a superfluous check in register_bcache
Date:   Wed, 23 Dec 2020 23:04:21 +0800
Message-Id: <20201223150422.3966-2-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201223150422.3966-1-colyli@suse.de>
References: <20201223150422.3966-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Yi Li <yili@winhong.com>

There have no reassign the bdev after check It is IS_ERR.
the double check !IS_ERR(bdev) is superfluous.

After commit 4e7b5671c6a8 ("block: remove i_bdev"),
"Switch the block device lookup interfaces to directly work with a dev_t
so that struct block_device references are only acquired by the
blkdev_get variants (and the blk-cgroup special case).  This means that
we now don't need an extra reference in the inode and can generally
simplify handling of struct block_device to keep the lookups contained
in the core block layer code."

so after lookup_bdev call, there no need to do bdput.

remove a superfluous check the bdev & don't call bdput after lookup_bdev.

Fixes: 4e7b5671c6a8("block: remove i_bdev")
Signed-off-by: Yi Li <yili@winhong.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0e06d721cd8e..a4752ac410dc 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2535,8 +2535,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			else
 				err = "device busy";
 			mutex_unlock(&bch_register_lock);
-			if (!IS_ERR(bdev))
-				bdput(bdev);
 			if (attr == &ksysfs_register_quiet)
 				goto done;
 		}
-- 
2.26.2

