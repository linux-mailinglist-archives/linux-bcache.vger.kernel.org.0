Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8BC5F5ED
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jul 2019 11:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbfGDJqk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Jul 2019 05:46:40 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727257AbfGDJqk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Jul 2019 05:46:40 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DBB611A0038B136A584F;
        Thu,  4 Jul 2019 17:46:37 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Thu, 4 Jul 2019 17:46:29 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-bcache@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] bcache: fix possible memory leak in bch_cached_dev_run()
Date:   Thu, 4 Jul 2019 09:52:57 +0000
Message-ID: <20190704095257.143492-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

memory malloced in bch_cached_dev_run() and should be freed before
leaving from the error handling cases, otherwise it will cause
memory leak.

Fixes: 0b13efecf5f2 ("bcache: add return value check to bch_cached_dev_run()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 26e374fbf57c..20ed838e9413 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -931,6 +931,9 @@ int bch_cached_dev_run(struct cached_dev *dc)
 	if (dc->io_disable) {
 		pr_err("I/O disabled on cached dev %s",
 		       dc->backing_dev_name);
+		kfree(env[1]);
+		kfree(env[2]);
+		kfree(buf);
 		return -EIO;
 	}



