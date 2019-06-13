Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42064378B
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Jun 2019 17:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732786AbfFMO77 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Jun 2019 10:59:59 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:13672 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732597AbfFMO76 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Jun 2019 10:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560437998; x=1591973998;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iNsQ5NpWou+/peRiS/VT81Ho4zjqhpsJT/Fx5Il06nY=;
  b=T0cmd1/I7Vx2Bi1XjF1BXIv8HX5NSQPzZKA5Kv8J1W3UYZMoy5Yvf9dy
   +WwcWT3Ip2J4RCenwvkQyKOETP6fQveOi/HovvJbHwoVNfxpCLZeLz/Gz
   q84DCjep+Yh8CRzlT7aOFgw0Y20hF1Zs/4gdd6DCwzUY7tBpKjF/eDZNc
   cLNhtFKSonNfLTm7PkzMZUb8lUNKxCeKDjqaXGqnDoy+4ZHkB6rD2NBeG
   nQF4HPFVYbtrWhaenebGiWC7psJWqSAiolpQwKX8vcfbvnlTjg9ISvpWq
   qA2m7eg/upUBSg5K69i0IfP8XgkMyHmWYsuP3Keb8S3iUdR9I33glVaHQ
   A==;
X-IronPort-AV: E=Sophos;i="5.63,369,1557158400"; 
   d="scan'208";a="216832815"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2019 22:59:58 +0800
IronPort-SDR: 01FgScfzI0axFxrM5hHabP3Tk4cDkEq6aXszeGjY5vGyLdK2Nyrk849q2R9DqzPMDOIUm7d3nz
 G+DoUV3vtCmrgyEIRzllEOyflFD7J8Jv06aEth7g7eS+4BD+uQTg+L77lpE+mpIaVSHgGltSEb
 DkuBfXIYwniyN3evFA2KdBc7DripX37u0BgHQghWAlR2wwsbYGf64EMkuVvtYe1X+d9fEKvpZ+
 2pc60Eb9TbyWYozUclotqcuUKyCeF/h3hWmbWHiChEXOdFCcfANjRCHQuvXbvq2sGFui1p4jFp
 D/E+Oe849lSejPMVDq0e4MxS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 13 Jun 2019 07:59:41 -0700
IronPort-SDR: Hg/Q0JZLQxvyJ1ynw7GVVz6a2ZLmDTwy9CXYGG0iAc7/MfuIt/4GJDyQWZihOne+qI2H2HbHro
 uSQcmxrPYLZgchhnR6BVkp3AOH/g5wH+lNKLAgFLzaJmhrlL+uRZDI8wCu22AJMbqIlB6HUXgh
 1MT5QSEw8fsSHXJFX+GBjhdbkE2a5sI4LGNASB7ZYDJv27Y8LyTz64pb9CaAwcZGBYAKn1gbNg
 fFgSascOHyaSxa+DrSdsHvq2LVKt5BycYVP3Ht/if2zZ5Vyak7nuPETcKjqUxLd8eYvoqKWI/8
 8Wo=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2019 07:59:57 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-btrace@vger.kernel.org,
        kent.overstreet@gmail.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 0/8] block: use right accessor to read nr_sects
Date:   Thu, 13 Jun 2019 07:59:47 -0700
Message-Id: <20190613145955.4813-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

In the current block layer implementation including drivers and fs
there are some places in the code where block device->hd_part->number
of sectors is accessed directly without any locking. There is an
existing accessor function present in the include/linux/genhd.h
which should be used to read the bdev->hd_part->nr_sects
with the help of appropriate locking.

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
part_nr_sects_read() with expected rcu locking and removes the direct
accesses to the bdev->hd_part->nr_sects.

This is based on :-
1. Repo :- git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git.
2. Branch :- for-next.

Regards,
Chaitanya

Chaitanya Kulkarni (8):
  block: add a helper function to read nr_setcs
  blk-zoned: update blkdev_nr_zones() with helper
  blk-zoned: update blkdev_report_zone() with helper
  blk-zoned: update blkdev_reset_zones() with helper
  bcache: update cached_dev_init() with helper
  target/pscsi: use helper in pscsi_get_blocks()
  f2fs: use helper in init_blkz_info()
  blktrace: use helper in blk_trace_setup_lba()

 block/blk-zoned.c                  | 12 ++++++------
 drivers/md/bcache/super.c          |  2 +-
 drivers/target/target_core_pscsi.c |  2 +-
 fs/f2fs/super.c                    |  2 +-
 include/linux/blkdev.h             | 12 ++++++++++++
 kernel/trace/blktrace.c            |  2 +-
 6 files changed, 22 insertions(+), 10 deletions(-)

-- 
2.19.1

