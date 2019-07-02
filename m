Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5296F5D587
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfGBRnv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:43:51 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:44441 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRnv (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:43:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089451; x=1593625451;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mMR/hpYFy80l7odJC6OZkX7C/Iat9UiqQzK/zSp4tQc=;
  b=VP2l2NDJxQaVVtPbjuwxZaMx/HlgE8wnuqCk0OdqBu92Gem3fpoGK7gO
   6wfosra8u2TNrpQMdwee8kwbQZ5ncJDeOPUL3SRT1Zp21w1aV8fkP1AO8
   NqahwXOpr/Wxyfbl6xjds+7Ks+CLwZgidOtcvZNce+Gd7ogTHZn1wh2P1
   KuucLd9o5dzHrv4PSckmb/ywrQHIbccqyfUAkSMBIMDYKi8WySmlCtyA0
   HupDGm62+B4Kp++WqkCCl2SRoRlcGF3rg8E5geGNHygrSgIhiizsH1oAe
   oS6Al6HNExAlTVnljSreCMuPnxuWnqeFD7s+J5fg00dh0J06XZfecpjLn
   g==;
IronPort-SDR: Rxxu6cf6WwWdhuYIIirrUwZtP5uFnB3JN+/YJ6cGeF0ULosq4KG18HLuJEQNeVZCCUCx6vpvg0
 H45rXZvY5pogP4VUj71oNsJldmvVq6gIsudJ2T4M0ncw4KLUpNlCuQjKrqN10H5hkiaty33bdK
 aOv6WeB0zdLgxJAC0NNEx97GQwK2kXuOz4Ors2iOrX1lWGqirSQ6DQYY35fkYFDlTfo5KRPDde
 zuNuN37LoKUTv+dUd+cvibOp23jIBE74Ax0M5xIT8rzoyUYQKqY7qVD75r9eTcIRxxV+WjJKux
 Wlw=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="211924307"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:44:10 +0800
IronPort-SDR: kfwnae2bo8FnkKJRSnxuzQFZalLGD64K20P4lQ/FjMhmxAi1SM5CrTG4RitQQF6F3KRhWKaUzv
 ux8K99snYNUwh5yACl7GDrHJpLdYYF78kWSgOqru4Rsp4hrqU0a6lYAdygYEJQFfPk8AWbDyny
 jo9QXn8sv/JpXZmDqJxCXSd+UgPFBC6Ae4bWVGOMxP+AGa8/q3RK+Mb719BHScQQWJUeb+GSPO
 i/STsvUo3WPuDJWO9QhcwNv1Ig3Dt95yFzo1RhUEguGWjpvijHjU4rbHulnUPFVzEaW5z8J2sc
 kHfo41cOhYpRez39RtQs3Gan
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 02 Jul 2019 10:42:49 -0700
IronPort-SDR: ZZ3hK2bjvxPpoDYY3dGllgVu8h4y5aH5oKqXW08FxIs6lNu/zSn8Lq0Vc3CKh0UxLaxt9BwD0v
 3fTd0ZB6CA1nNk66QTwybNGG7hulaPt/5JjQ4RaSIjxNw/RiC1ddUlmt5cVduRWWvDMc6DPeRv
 QY23K1dCOsFVfF6zsp2JXeQ1ammNVuRE1dwh/CDI01AburqpZV0KpfKqu1xuzoJfo0j+AG3k47
 ScfjN3W9uVeTshYH+ctIEZjqQRzreo7anBy5gwBbh5bWBmg6n07aXYscmGEGj90oNrBHWiocWt
 PF0=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:43:50 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [COMPILE TEST ONLY PATCH V3 9/9] xen/blkback: use helper in vbd_sz()
Date:   Tue,  2 Jul 2019 10:42:35 -0700
Message-Id: <20190702174236.3332-10-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch updates the vbd_sz() macro with newly introduced helper
function to read the nr_sects from block device's hd_parts with the
help of part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 drivers/block/xen-blkback/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
index 1d3002d773f7..f96cb8d1cb99 100644
--- a/drivers/block/xen-blkback/common.h
+++ b/drivers/block/xen-blkback/common.h
@@ -359,7 +359,7 @@ struct pending_req {
 
 
 #define vbd_sz(_v)	((_v)->bdev->bd_part ? \
-			 (_v)->bdev->bd_part->nr_sects : \
+			  bdev_nr_sects((_v)->bdev) : \
 			  get_capacity((_v)->bdev->bd_disk))
 
 #define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
-- 
2.19.1

