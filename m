Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18BF628A2
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388868AbfGHSr6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:58 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:40616 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSr6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611678; x=1594147678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=z034C0lu3K9Pmhpbgqrk0VEPLsTVbThXKUwaZzmZN9k=;
  b=ntZqPbqf5yQyYKuT73EMffoJ728XDecBRWkzz9lH8qLcWf2xMVh4DtWh
   whr9DA6gEbTQV/dBqXFqCY5BUpyBe7LiLgEW3Fg5VJP8kmp8IEM791VQK
   wufXTu5q2XUXF+euptvV6xBLshopGeXvaZ4kKUvSfut/fzomsDPpgLjm7
   ILLwxv+UitONEBWfH7y544h+pQLxi2ONAi1SYfdGOF3n+aim4dFKtUeiw
   tyLzPDrVgpMJY4xveqC9Q0rxGaCt5TYMBFnjIkadnou7QjztcmJeM5q/A
   kxWg1oNchHpbTrnV7+ROUz28LbpWnfrrBW7pr/mYB9Ux4iNmMgFxQfnzm
   g==;
IronPort-SDR: +ALQZPoeY8xIUY+RLY3ASBYwsrFoNqQcNK1R16gk9A/WmSBnKIjfFpFTJoEjPAcZ+q0qyX0d79
 g3dm5NFnfu5k1QTn3heDEHDViuOtUs5sQAM4jORb0K6hhzlRPDG1p1D18E2oA62/D9q4aC2WXq
 SYBilEJQn3eI4tovXxG3V7hy+ChA16a+sl52XNBaD+QTR8oARWliQdljoNpIktCkMeR52efmbh
 o7jbHa8r0Y6FBKBlW/v1dwT1nxp7qA8J1D74QvpKsnYB8dGQI3gDjT4puBNOB3HLvluIibR//E
 UTo=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="112477280"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:58 +0800
IronPort-SDR: ErhjjZcU7NsyPlyoD3BHWkIK0fXot5dfwfXmX1bY7QiBDHDTVByfL/mVLrvo3lYeabscn8Q3k/
 PliIZCFKLgiPyNyn58CWcuEtuMWGCf+5dAaG4Y4RQ7OpcWUIF23Wmurd9q0A4mv1u3VjEh9gBZ
 sdISTV8G1VjHGC4DWhRcd6Mov6ftuxMdyQHxIJSusAs43wePFeJpUQ3tdsZ4nTvm4BXa3+BmWv
 Hu64G7jiZUULYYYpapJkfoy6HYvDnxQFU3FJNiHBJGjaXHeWcss37+LmIsQsP8f5Q+qNAJQG6+
 d9cRL9np+otH5S33tDbeudea
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:46 -0700
IronPort-SDR: /lvUb5Q0myDa5zcgSkRV5mq0xWp1dDUOhPS4Wf9cFbmpG/IvRSSGEJ9lGM8k7Pjd6GkWTfDTv+
 avvWzfyzdR+eOgrKUapLjgHI2vMsorvgoJy9+HYsgkE8YYl214niu7w2HnG8nciCH6ySy43zmH
 ohwVHaTLIjzccyfIkUQ95mnACdoPRdlSU5MIKSY0Z7xcK7GgXG7jb4ypPBfDeBz7hFQfKTcB1z
 axureZOqr+I/9iazjQ5dwfRkKdkMZP03pkSPzM+08pOLf2ElGq3Di+24xjBJ7cTOHtOLO4EHwy
 eec=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:57 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 7/9] blktrace: use helper in blk_trace_setup_lba()
Date:   Mon,  8 Jul 2019 11:47:09 -0700
Message-Id: <20190708184711.2984-8-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
References: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blk_trace_setup_lba() with newly introduced
helper function to read the nr_sects from block device's hd_parts with
the help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 kernel/trace/blktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index e1c6d79fb4cc..35ff49503b85 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -461,7 +461,7 @@ static void blk_trace_setup_lba(struct blk_trace *bt,
 
 	if (part) {
 		bt->start_lba = part->start_sect;
-		bt->end_lba = part->start_sect + part->nr_sects;
+		bt->end_lba = part->start_sect + bdev_nr_sects(bdev);
 	} else {
 		bt->start_lba = 0;
 		bt->end_lba = -1ULL;
-- 
2.17.0

