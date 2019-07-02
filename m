Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F225D57E
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfGBRni (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:56073 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRnh (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089417; x=1593625417;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=tQuAUG3c3Ex2NAFDohSdAhtf7sqssbECTSWT+Y11AmQ=;
  b=fnAPKZmK15ujaWgXfz78j9NridzP/QtnoOpQ3KuZi5q9mH8AvNio+q06
   cq4GyKzeQcQXpDQW3w3RUu9XdOgrPSrcFXtXM/qLjVmLAiiur/Q580I1/
   WB0zCRMhllpwwSdAhwDXDGUV8dtAg6B4r9R2Ft/DpWxbTLbErp9y4+G0u
   Z3rwKkOv7MCz5O39Mn3ieL2DOYJbgR5uCZQUx1gf5EUrIcBHMhhRAFwtS
   mUhYPo4WoecMeLjbqnaqGU3yyaOwWlFM7dsoTHwNyBoRoYk6D8ePv2A8R
   glt6KoC+NxESm9O0YQBwlOBUnbkqVA1bM2Gmb370AK+D0mmPp3pYdOe60
   A==;
IronPort-SDR: QTGtTbMp91ymbKNVANqGkm7mVCiI/dfTr7ptCYWvmgsnE1AiDf4w38A3C/ovqWhxyLU3/Yp4fT
 tpXPyLwEPJTq9fx5wYKHKHPv6lZHGCHjQcYvLXLJYhunSTVSRRwWCHRtQzsgMrye46gi4egEQZ
 VP6c/1PNSlkiCH0KQsTyhqzubp4wEKtvT9mLhhEU28yudQzOpducAWOGiVuY8Fozr4AZPUU8zP
 N0ZPmVBzbDja3K3jCOSyhuIYnPdoPclXqX0ggjLoeoFSYjrGY6W0GMbhc1whDloMUJx12/7dfL
 ETE=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="116916598"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:43:37 +0800
IronPort-SDR: ws0seQawCJnZ6+nabMELFkU5ys0VvnwDSsQXuDJLa/7MOwWm36/NRRI0MyEJfb3KvDwvKYadVt
 N2ylpuuOIv/VGiojo30TEccSVIWtzo1yF325nAo3OSvBbFm9mZk+AH2yXATzbrmgf1bIVk1eP4
 Q5r8NnyVMJDZMIbloVsb3qVWPjsmmq8CODv0rQZ60mi4okp4NKboE0pfS9ceOMFKaCUL5mmYxt
 esHXmntKCM8bvpa91QJZx/bQGtdtcdaEeeBDu0xMd28CRk38cmweieRXlRKCGJeCldLskFZ6gC
 pXqoDfuxDlopZBkugoBjyQre
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 02 Jul 2019 10:42:35 -0700
IronPort-SDR: 3pY21X4H4oFet0YyacV+YlVBI/O5kjvwVM4K9RGH+lSxN8T2EcXrvGPqEb2YvDqKJFkrfhunvd
 wPT3NX+wyNa0Yzhxb/uYEWOC4wde2+iswg6SvGEkFsZEG7xl9F9e8Oeh0HWaPS7CCQMwKIe6a2
 GRLymXkPc2sWwjDgBgV2nTvewLvTRednJE1LimHwb7D160IlrHhdJ5+6fX+M/NoUYRwOZ7jWJK
 xH+13m0ZRYpDhSMhKeTSxyUsymuQr84jPMXHTt+eleYamt6aHvlAIY3bJMXzg/m6m51iKwKuyF
 K5M=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:36 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 7/9] blktrace: use helper in blk_trace_setup_lba()
Date:   Tue,  2 Jul 2019 10:42:33 -0700
Message-Id: <20190702174236.3332-8-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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
2.19.1

