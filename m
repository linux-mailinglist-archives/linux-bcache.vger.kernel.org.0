Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14B9445DBC
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfFNNOv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:14:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:45814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727766AbfFNNOv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 601FCAE07;
        Fri, 14 Jun 2019 13:14:50 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 12/29] bcache: add io error counting in write_bdev_super_endio()
Date:   Fri, 14 Jun 2019 21:13:41 +0800
Message-Id: <20190614131358.2771-13-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When backing device super block is written by bch_write_bdev_super(),
the bio complete callback write_bdev_super_endio() simply ignores I/O
status. Indeed such write request also contribute to backing device
health status if the request failed.

This patch checkes bio->bi_status in write_bdev_super_endio(), if there
is error, bch_count_backing_io_errors() will be called to count an I/O
error to dc->io_errors.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index da9d6a63b81a..877113b62b0f 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -197,7 +197,9 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 static void write_bdev_super_endio(struct bio *bio)
 {
 	struct cached_dev *dc = bio->bi_private;
-	/* XXX: error checking */
+
+	if (bio->bi_status)
+		bch_count_backing_io_errors(dc, bio);
 
 	closure_put(&dc->sb_write);
 }
-- 
2.16.4

