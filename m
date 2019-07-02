Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30C25D56B
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbfGBRmr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:42:47 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61910 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRmr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:42:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089367; x=1593625367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nzpq2q6z+7BZy2jXxkdotmkGvF20O6oeceGehTa8YQ8=;
  b=aZMZtH1m5/y+e/PLk/YP39cvhrVB6sYhlC1sBM8KllwtnFeulHnkQgm7
   x6Bc9EL37GeL+WzLi42DojhAHbxAk1/ju4HDovdutdOsh4XNEfJ+VFW4D
   lGOuCeiwT/kwNE6r6124LygxEGL7///QaXv5SJRCm/M3YeeqilZB7t1Yu
   Pt/wO1RnpSXR2VqyANWkA9idYpoMVsbpWx/MZ2K0XcDHLcDLzDjBu8etn
   rt7qICFdZl4LIVbsGyJO2jnb/uN40Tmr2j0BK9RBaa2CZEgh0CC8mBJlA
   zgps7nQ02EtXZT73A9/lMOaZCsOtj45VotVxpqvMDC/iAey9eNgg6+smY
   g==;
IronPort-SDR: Oy4Zl8QMOfc/k/Cx6aM0x2pnKsYS2V1vubdE0Qp/8w5ZGIGLd9gWBXF0VUsAMaZs04wlGm8AM/
 J58rcXW2pNqFJ94OrNgilXlPlexRH2LzxW8RiVvuCQ0BI3ckvL6Vq0gC/4GF5Busu510C0bQLv
 F24sNqrnX7TZCV/rYrf6QONmoHQCZ33UokRSZrsxL1mwJEiHX/gzuy9NcgLJs08UkxU20PrXEK
 XqLOW8DzrIr4iZMstWSmDIMN+Sw1tMucdm924ols3UE5I7HTEmH2diRglgg1Flocv1ZTyd5r9/
 6Sw=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="218459985"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:42:46 +0800
IronPort-SDR: Q/SWneQRO+khQugUQFMfLWZg/bBhGqi9xi/zEplVramdjZPfPn3602ZfEUZYN2H6D7GOgwhhM7
 CMIUjd7LVhunUl9b6bfHauqHZ4PpvRAHcZ0btgyL5s1mKYCILaAkA+LScYV1yFr+qCY3FUZDcY
 uZvfmTemxc5rGqt8jg0HIfrJp0/H6y4PYcdxtGbd4zQ5q94rBEDjyLGfc9moLaf8DnB1IPrWmx
 PZXxp14dRpWuGHjbbJgd0EWGrjjCzo+fziSFJ6/Pfa64L9/IgrEUFXe+94WKazzgkAmQol0UW3
 7J+fFOIjBUJhMQ19CMaqXbOF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:41:48 -0700
IronPort-SDR: PULQy2lnpUjzZmGu5JhOPM0yZ067ec9EuCSAYxpuoeel4NTIXUCfgyS4rhbF25Q7yRUqnKjJjO
 CP1MdvtMJIn2BUXo8nmrX5ayVwfG45PvBnj1Se1hmqO/H2IJqLy+IP8Kg2K+s2Xj+EgkZWW02g
 anJeJj1nyY5U/2ClaYOMcnAe03Lwy49+x9vakB7tPIjcZZdty/SvzK2wSsXbiK+BxED3VRniEP
 eYYWAlSc535zS92ZL8AaU3F97Xew5XRNC2UFo/huZ0jIVGZ/OGA+nQC4AFOvTDhTQ795+4uCYY
 dd0=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:42:45 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 1/9] block: add a helper function to read nr_setcs
Date:   Tue,  2 Jul 2019 10:42:27 -0700
Message-Id: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This patch introduces helper function to read the number of sectors
from struct block_device->bd_part member. For more details Please refer
to the comment in the include/linux/genhd.h for part_nr_sects_read().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 include/linux/blkdev.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 592669bcc536..be7ee5a0b0dd 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1475,6 +1475,12 @@ static inline void put_dev_sector(Sector p)
 	put_page(p.v);
 }
 
+/* Helper function to read the bdev->bd_part->nr_sects */
+static inline sector_t bdev_nr_sects(struct block_device *bdev)
+{
+	return part_nr_sects_read(bdev->bd_part);
+}
+
 int kblockd_schedule_work(struct work_struct *work);
 int kblockd_schedule_work_on(int cpu, struct work_struct *work);
 int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
-- 
2.19.1

