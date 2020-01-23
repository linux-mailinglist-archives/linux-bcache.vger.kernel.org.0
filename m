Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAED146EF9
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgAWRCO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:02:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:51432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbgAWRCO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:02:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB5D2AC50;
        Thu, 23 Jan 2020 17:02:12 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/17] bcache: fix use-after-free in register_bcache()
Date:   Fri, 24 Jan 2020 01:01:30 +0800
Message-Id: <20200123170142.98974-6-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200123170142.98974-1-colyli@suse.de>
References: <20200123170142.98974-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

The patch "bcache: rework error unwinding in register_bcache" introduces
a use-after-free regression in register_bcache(). Here are current code,
	2510 out_free_path:
	2511         kfree(path);
	2512 out_module_put:
	2513         module_put(THIS_MODULE);
	2514 out:
	2515         pr_info("error %s: %s", path, err);
	2516         return ret;
If some error happens and the above code path is executed, at line 2511
path is released, but referenced at line 2515. Then KASAN reports a use-
after-free error message.

This patch changes line 2515 in the following way to fix the problem,
	2515         pr_info("error %s: %s", path?path:"", err);

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/md/bcache/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ee7c87f38d0d..fad9c6cbee5e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2477,10 +2477,11 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	kfree(sb);
 out_free_path:
 	kfree(path);
+	path = NULL;
 out_module_put:
 	module_put(THIS_MODULE);
 out:
-	pr_info("error %s: %s", path, err);
+	pr_info("error %s: %s", path?path:"", err);
 	return ret;
 }
 
-- 
2.16.4

