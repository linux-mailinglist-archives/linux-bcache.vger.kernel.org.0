Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4735197210
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfHUGPN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:15:13 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47078 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfHUGPN (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:15:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368113; x=1597904113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=D8YDUL5tZ05jSVemJWK/Wkcu4fkxmHw2a5twadHpA8s=;
  b=fvIMHJZmy7nxIAAoibjPzhsQguo6zFDc3jnb0nelgobqNC77sLaG5hGM
   FIa8j7xHknUPE7ux6Ptgv097FD6W7cS7l2vGTF8Jsjn3fLfgWDySo8rU7
   wxQZdG7vKNUdoaB5f2H3+RGyXkXkZgRAHZ3rxI2/tTkzQW91kcR30sunh
   PZjAtFhltBYAFuJ1tODRVQBTeOtzGrUwzgMCp6ZuFpKJ00XUwRn0uSE4s
   F41NhM7FdQ5z0uhzrcHQnj14HBVlqlh2DOl2gtEz+/ijvtKBpiwRdhrQa
   aLQ9ge05xmrAwKwLwes6+JJBW3rRtagP0uRrxrXCuN8RB7hIbjvzrpEVN
   w==;
IronPort-SDR: h4xAvQC3q6mfo/XYh0NIxyMbppFaBpVOSt3TXAnbVcrpNhYUIpStxev0QyvHwTjoVQ7J0qbYC/
 j5EKmfGyAuUYWsYJtDAoGZYMPIdKv5ijtG6UBqMXsDKLe8rc5UyrgOQ+jQ6anxmJEZAdVbaVeG
 StAwf0e1k68eUZVPsFSI2tn7Odry6ngxGW3kRAGdvALN8dKz6xfE90ZifSZ84zMrTLuEIpT8sa
 C80GVJCWP0xRE/dMO5le6JIxk2trN2rknWsUgFvb8vMbBNh+8qsNBFZB9D9b0J/QseanmShuXp
 w0Q=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="222880857"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:15:12 +0800
IronPort-SDR: Vi9f/McXNG7htf+Oiz487a2aFGqA5HqxQzYxDtCxAg9pcdi18lHp1G0xcRV5pgMkDm9XLKrQVv
 YqCRPHP/m9tsZbs0nTtfyEgrnlCpemQIjHkrxxOPdI29BnNQkMtJx2DY72vRIRCWaVVSu7kgYE
 96rAnyR88fVxy+LkriHGzZxr48kx4w0lh1v6rmZv5fbV0/ObwPgymKJP367m+qB884ht3Hcgv4
 eO8+k/zbSxtw+atpwL6svHcL1IOYLu5Vda1IFawyAtonAnx6kBNl5k3GxHtQoTrymTO/6BoXaq
 6BMsGNdad+h2mvKTsb+b6Jxq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:12:34 -0700
IronPort-SDR: BYJvRAQ6DwECniwHRLKaUr9x6qRGDsHdaIfg1ud9IVxV9yCvCNuNuKVUzzdBhpZt47I0lH4/y6
 r8D53/P4Z9aK688Qqew0ezt7T/dj/JP9UbtCLxA9CqauIB04CofRKbjlP7H/hR6qwV2wLWIY73
 tGseFCARD4wk5lDXH51RNjF4YV0l1IIhsgm3K/Cp29/2cpd8FPo2YMLKOYoeTxyJ07eENw5NDl
 SHreBRLB3prhQjINcF9sFUTYXHo04Vn7uy1MBlNW+yKasuLS/7NJkLGl8Z0zDzbZJCuoLufFp4
 AG8=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:15:12 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 7/9] blktrace: use helper in blk_trace_setup_lba()
Date:   Tue, 20 Aug 2019 23:14:21 -0700
Message-Id: <20190821061423.3408-8-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
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
index 2d6e93ab0478..801f8c465bff 100644
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

