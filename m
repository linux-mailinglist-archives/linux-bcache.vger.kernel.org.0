Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A04B6701F8
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jul 2019 16:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729099AbfGVOMy (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 22 Jul 2019 10:12:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:55710 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729068AbfGVOMy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Jul 2019 10:12:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 617E8AEFD;
        Mon, 22 Jul 2019 14:12:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Wei Yongjun <weiyongjun1@huawei.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: fix possible memory leak in bch_cached_dev_run()
Date:   Mon, 22 Jul 2019 22:12:36 +0800
Message-Id: <20190722141236.103967-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190722141236.103967-1-colyli@suse.de>
References: <20190722141236.103967-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

memory malloced in bch_cached_dev_run() and should be freed before
leaving from the error handling cases, otherwise it will cause
memory leak.

Fixes: 0b13efecf5f2 ("bcache: add return value check to bch_cached_dev_run()")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Coly Li <colyli@suse.de>
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
 
-- 
2.16.4

