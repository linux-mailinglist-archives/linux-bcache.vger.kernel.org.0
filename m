Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09871F89BC
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jun 2020 18:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgFNQxv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 14 Jun 2020 12:53:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47086 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgFNQxu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 12:53:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EDFEAEB2;
        Sun, 14 Jun 2020 16:53:53 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 4/4] bcache: pr_info() format clean up in bcache_device_init()
Date:   Mon, 15 Jun 2020 00:53:33 +0800
Message-Id: <20200614165333.124999-5-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200614165333.124999-1-colyli@suse.de>
References: <20200614165333.124999-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

scripts/checkpatch.pl reports following warning for patch
("bcache: check and adjust logical block size for backing devices"),
    WARNING: quoted string split across lines
    #146: FILE: drivers/md/bcache/super.c:896:
    +  pr_info("%s: sb/logical block size (%u) greater than page size "
    +	       "(%lu) falling back to device logical block size (%u)",

There are two things to fix up,
- The kernel message print should be in a single line.
- pr_info() won't automatically add new line since v5.8, a '\n' should
  be added.

This patch just does the above cleanup in bcache_device_init().

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index a6e79083010a..2014016f9a60 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -893,8 +893,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 		 * This should only happen with BCACHE_SB_VERSION_BDEV.
 		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
 		 */
-		pr_info("%s: sb/logical block size (%u) greater than page size "
-			"(%lu) falling back to device logical block size (%u)",
+		pr_info("%s: sb/logical block size (%u) greater than page size (%lu) falling back to device logical block size (%u)\n",
 			d->disk->disk_name, q->limits.logical_block_size,
 			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
 
-- 
2.25.0

