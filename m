Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F64A69C6
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Sep 2019 15:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfICN0A (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Sep 2019 09:26:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:34460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729171AbfICNZ7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D203FB618;
        Tue,  3 Sep 2019 13:25:58 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/3] bcache: Fix an error code in bch_dump_read()
Date:   Tue,  3 Sep 2019 21:25:44 +0800
Message-Id: <20190903132545.30059-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903132545.30059-1-colyli@suse.de>
References: <20190903132545.30059-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The copy_to_user() function returns the number of bytes remaining to be
copied, but the intention here was to return -EFAULT if the copy fails.

Fixes: cafe56359144 ("bcache: A block layer cache")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/debug.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b123be05254..336f43910383 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -178,10 +178,9 @@ static ssize_t bch_dump_read(struct file *file, char __user *buf,
 	while (size) {
 		struct keybuf_key *w;
 		unsigned int bytes = min(i->bytes, size);
-		int err = copy_to_user(buf, i->buf, bytes);
 
-		if (err)
-			return err;
+		if (copy_to_user(buf, i->buf, bytes))
+			return -EFAULT;
 
 		ret	 += bytes;
 		buf	 += bytes;
-- 
2.16.4

