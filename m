Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA54477AA
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfFQB3C (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:29:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727515AbfFQB3C (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:29:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734942; x=1592270942;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bpSg/6/49xNUBvpHkr4oWgwqbw2GWcRonP8ByaQaYRc=;
  b=B2oyxpz6gwOOQLBrlNZ1gojNHwqFNd2iHmY98znGJaWLu+4xlFcbcCDm
   RlUnbpKkfw+6XUomf9De/uyHEmfVfdiwZWsz+h32natljayxdNRPAJxlq
   7SDSCJqjAzcjChJVZklT160z4W0Awe0V/YZa82QkcN/679mVkzqznCRZJ
   EccUYRK3e4QBt6olyXwTlGaQdtR+9MU+4FT2eIF68yY5NmAo+FHtFSzkP
   c97H7RdzyZkBAaAhTE8El18LObWfKwdbRzEjTwpWdjnff0WKEVJeyYfou
   Ri7jyVl6RT3MiwNx8o/REDlRvFSgQiL3985OyNnQLwdTwcsq9zGTRDP8+
   g==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362953"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:29:02 +0800
IronPort-SDR: At7ItvQq1IPi6N0np3nZKmFV/i9wbGZg6GRwMolTmGUJYlpHpKQwz/XPHOYHrMlHxo37FA4aBc
 magsLinxSZ75Yxxw7jrjgMqMLhEJz+1NIkv2I8Ykr+UQHpq7lmG8nzKAnf+HHeQ1CU+0casNAk
 3D1Ygpt69cqpVjg9ePlxypwPVh//80l4lNRssbYGA18xnjABzPmmOKKA9mHbgZkuYQACQ1isEj
 qB4h6nHN03gCRMJWn8Y83DAsxYGNwdx7UtkvIR/qiLi+zHkXbHrVQx0Xr5WbafKvy8z/bE+FQ8
 U0uo5VwzruRfWkUiLHQQpKz4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:39 -0700
IronPort-SDR: uW6g7HlljLGkgBxVb/4abf8Z+A1KdrYyWzlLDdR8gSIYP2vTFx8PAE4GFYBOpJQ4Co45JacDDR
 0J8woBye2Y3vs/PlOBBplYJB/q0op4ANl+Bf4YABXQLNIY/wsp+EpgQ7WrRkKWgm6iiKte6YFy
 5wYjVRKmEDzvVMJMM4eE6EgtrRAIhOxrCZuQaZAeXRzwzTimWPvyH5mxJq8TNMqFBjpKbYF4Ll
 5C9E1Kzen6V77Ow/YU3nHFT1NOKoo6Pk7mXUa4d+3ggR/eLejDmSIWkT9mjv2MnMU2uNdBrjAy
 uEk=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:29:02 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 7/7] blktrace: use helper in blk_trace_setup_lba()
Date:   Sun, 16 Jun 2019 18:28:32 -0700
Message-Id: <20190617012832.4311-8-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the blk_trace_setup_lba() with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help if part_nr_sects_read().

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
2.19.1

