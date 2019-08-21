Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF1971FD
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 08:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfHUGO2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 02:14:28 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46971 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfHUGO1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 02:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566368067; x=1597904067;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tDUu6OfCZAgiE5vxUUEYM/lctnZ4+mN4P7Ofucvf8cQ=;
  b=U3TeQ/kNaQEo/PP7G+aywy008U42TqagGyaR4u0t4WYD5mE5cutelY2C
   UuZaw9uTdr9YO05YlNeWDauTg3mOUMg7fTb3HXVFUbzKSfRrLAPedB0ug
   x4+anxeYg9bSjhN6/46HhwIM8nAHs84A/yQ6wsc+aqwdlZWzQCWzSfTNU
   KiWwJNz/MCGNip3sn8vMHkuQBCyF9Ev54WkNXLhz+A3Zj/Ccv+ShkxRyn
   FguTniEu31IkK6u5zCuPbQ1iTKDoH/wU74fIpLELRyfLquMW6CKHVjoGc
   b/x50SjddGGEC4ILVqbrxVzizaQYIMIIuOjPk4Vt2DCLPAUin2RjDTSTG
   g==;
IronPort-SDR: LJ0R37Oh/N4BMTk3QCJLeOipE5+YAVfqop3RjJ/7N14C1rrm5wf1yx3yU2fczm5MzpjZUFGLND
 jp1MN+8NP195UREN36Vb0/RzHdQiHrUJq32AbaZuPuBEfwFUe1t0eXHpCCyy5MaUnvVSZgPx++
 l6L4IpyZeRQ/9vP64drs3KrLLW0m7zEI8JTiS32ydH12/JwV6Jxk3vO/P+Z3k2nT0dxdW9kdz8
 0QDdrwSQLE0mxk+UGV53KehVJ0YzSlUPSONv8SfsYeM904T+FYKDu4rkpR5NtUCo9jdUMcF9jH
 d6A=
X-IronPort-AV: E=Sophos;i="5.64,411,1559491200"; 
   d="scan'208";a="222880761"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2019 14:14:26 +0800
IronPort-SDR: /O7wFZQldCUIL+T8y8WVggEkv65ATU1bGJShtCI8CGyzmcODwY22mTfZsq1PmAlq095Ubqav5+
 2w/sjO5AUPZ5c4DiNFevk5QEZF9RVaSSmd++C0s5IjDqIwoiTYw58aKIj1xQort+WLDVxg+vwr
 Y2w7nib7UP+cUWYFHATV1SIeU357dbpjxDwLXTHsr3Rq1aFZqHuSlPlC2S1V7h+VDNM7uYAz79
 j8MFySR3/9JkZQBFkLld8q0QJYTy2kpXTFP+JwbBbrNH97Riuw4K9SF6qW6P5hqouzIFGIoLHY
 x+4XICGaJizl7/S2rBhUZY6f
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 23:11:49 -0700
IronPort-SDR: ZGZ6fU+fR5RzuuKyQ2BV7Qtj88cD9Ywgd0u1B2kvbxKN/qhuT5iNaowYnD43Mmvlu5PKoVZxFu
 EwuFv5WC4mXRvu1Ot2FMKpU7WEJTvW8+WuLi+qEjPsNYZ7a1WaPn3nzKPMvQTxa+AP6VJ7jrhh
 yDltPRtYNqQZHfK0/qhkoQE7+cYR6iw0FLrIjEhPi7rl5kCUe1BDydqeNMnl4XwqCi6Ihev3Rh
 5960wvlRjEiKwa7McvK8/Zoh2N34Yk0PQUrrYQBNjhsSvbtu2ZY5ExsJRLBEA81+ZpGG/t3gaq
 ce4=
WDCIronportException: Internal
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 23:14:26 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V5 0/9] block: use right accessor to read nr_sects
Date:   Tue, 20 Aug 2019 23:14:14 -0700
Message-Id: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

In the blk-zoned, bcache, f2fs, target-pscsi, xen and blktrace
implementation block device->hd_part->number of sectors field is
accessed directly without any appropriate locking or accessor function. 
There is an existing accessor function present in the in 
include/linux/genhd.h which should be used to read the
bdev->hd_part->nr_sects.

From ${KERN_DIR}/include/linux/genhd.h:-
<snip>
714 /*
715  * Any access of part->nr_sects which is not protected by partition
716  * bd_mutex or gendisk bdev bd_mutex, should be done using this
717  * accessor function.
718  *
719  * Code written along the lines of i_size_read() and i_size_write().
720  * CONFIG_PREEMPT case optimizes the case of UP kernel with preemption
721  * on.
722  */
723 static inline sector_t part_nr_sects_read(struct hd_struct *part)
724 {
<snip>

This patch series introduces a helper function on the top of the
part_nr_sects_read() and removes the all direct accesses to the
bdev->hd_part->nr_sects.

This series is based on :-

1. Repo :-
   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git.
2. Branch :- for-next.

Changes from V4:-

1. Adjust code for latest branch.

Chaitanya Kulkarni (9):
  block: add a helper function to read nr_setcs
  blk-zoned: update blkdev_nr_zones() with helper
  blk-zoned: update blkdev_report_zone() with helper
  blk-zoned: update blkdev_reset_zones() with helper
  bcache: update cached_dev_init() with helper
  f2fs: use helper in init_blkz_info()
  blktrace: use helper in blk_trace_setup_lba()
  target/pscsi: use helper in pscsi_get_blocks()
  xen/blkback: use helper in vbd_sz()

 block/blk-zoned.c                  | 12 ++++++------
 drivers/block/xen-blkback/common.h |  2 +-
 drivers/md/bcache/super.c          |  2 +-
 drivers/target/target_core_pscsi.c |  2 +-
 fs/f2fs/super.c                    |  2 +-
 include/linux/blkdev.h             |  5 +++++
 kernel/trace/blktrace.c            |  2 +-
 7 files changed, 16 insertions(+), 11 deletions(-)

-- 
2.17.0

