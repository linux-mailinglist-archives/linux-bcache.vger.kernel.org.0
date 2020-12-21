Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42142DF8FC
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Dec 2020 06:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728166AbgLUFyj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 21 Dec 2020 00:54:39 -0500
Received: from regular1.263xmail.com ([211.150.70.204]:37246 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgLUFyj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 21 Dec 2020 00:54:39 -0500
Received: from localhost (unknown [192.168.167.13])
        by regular1.263xmail.com (Postfix) with ESMTP id 594FD635;
        Mon, 21 Dec 2020 13:48:33 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-SKE-CHECKED: 1
X-ABS-CHECKED: 1
Received: from localhost.localdomain (unknown [14.18.236.70])
        by smtp.263.net (postfix) whith ESMTP id P20470T140378894223104S1608529703729142_;
        Mon, 21 Dec 2020 13:48:33 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <d5b8a336a9fbf6c15bbfd9fe00e1c91f>
X-RL-SENDER: yili@winhong.com
X-SENDER: yili@winhong.com
X-LOGIN-NAME: yili@winhong.com
X-FST-TO: colyli@suse.de
X-SENDER-IP: 14.18.236.70
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Yi Li <yili@winhong.com>
To:     colyli@suse.de
Cc:     yilikernel@gmail.com, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yi Li <yili@winhong.com>
Subject: [PATCH v2] bcache: Trivial fix to register_bcache
Date:   Mon, 21 Dec 2020 13:48:20 +0800
Message-Id: <20201221054820.1005335-1-yili@winhong.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20201221031739.563404-1-yili@winhong.com>
References: <20201221031739.563404-1-yili@winhong.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Trivial fix to no need to check the bdev and do bdput.

Fixes: 4e7b5671c6a8("block: remove i_bdev")

Signed-off-by: Yi Li <yili@winhong.com>
---
 drivers/md/bcache/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f7ad1e26b013..4edf666860ad 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2525,8 +2525,6 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
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



