Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A4B2DFA9B
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Dec 2020 10:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgLUJzl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Dec 2020 04:55:41 -0500
Received: from regular1.263xmail.com ([211.150.70.196]:55030 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgLUJzk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Dec 2020 04:55:40 -0500
Received: from localhost (unknown [192.168.167.13])
        by regular1.263xmail.com (Postfix) with ESMTP id 655B21F0E;
        Mon, 21 Dec 2020 17:49:54 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P20470T140379059910400S1608544185429896_;
        Mon, 21 Dec 2020 17:49:55 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <86eb62f6e5743ac4fd5988dd6125c28f>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: colyli@suse.de
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     colyli@suse.de
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com, hch@lst.de,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Li <yili@winhong.com>
Subject: [PATCH v4] bcache:remove a superfluous check in register_bcache
Date:   Mon, 21 Dec 2020 17:49:43 +0800
Message-Id: <20201221094943.1712589-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <4891349b-2136-eb8b-758d-f937b558b1c0@suse.de>
References: <4891349b-2136-eb8b-758d-f937b558b1c0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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
2.25.3



