Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A7B6288E
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Jul 2019 20:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbfGHSrS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Jul 2019 14:47:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:31778 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbfGHSrS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Jul 2019 14:47:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562611638; x=1594147638;
  h=from:to:cc:subject:date:message-id;
  bh=uTqlKG2ILdegr5sU0HeNGcEucdW/yuMkATM/4UkxKXI=;
  b=g3eseQv0W4YXG0inP4P38HXzLLxU3zO4UM8SmhD8T2048If5/t9jeHp4
   1enApGqox0vMdD2NQIEOfOWYuf6JUPAHB2MrQ5xfaDnKO2fG3LlfAmRqK
   pzWILh7QZ1S+pS85L3yCwez1mmFhqM9tXbKi29rpGfH9hFPzlZLb38AUj
   On4RBWNLtY0+KE/nUeawHuIN2F84b+3L+1TtHQnI2dPWMRSitQEpq7m78
   5YjtmpyJPS8i4/wrahNNfn5rN7l4fVBdiJMxuzw1rzMyM+5aBA4TzSJKg
   PyAwmcQuTONeONels4KSkM9vOJaz0HatSctngSjcVI9eT0Xj/YtVOKPWA
   w==;
IronPort-SDR: iysNOEKNLkycsspqSXRbasfKRhkOP5oUrYLAhttJ4GgbWyj+7XvLKfPCMOT/DlPzn15vOzGUJw
 B6VVFgv75S1oz5UqNvVit2kOO1Y3HBq6O297mzZnL4lS/hXbbiMUJ9DZ23MyR7VMyd0akmHrbj
 yl0+1IwYXYbQbdrwAkp117jAnxI9sNVvigHz1sUruNTrRr8wfPPqrrkGfYK1MMV28gzuoCy3jm
 5v9tPXURt9ZLuRhkBCR8ndKKgDmeFHNAGRnSugAX6p6NJAPnIHrIIk9QS6XGzQhRJSAJNnlNjz
 AfY=
X-IronPort-AV: E=Sophos;i="5.63,466,1557158400"; 
   d="scan'208";a="117296098"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jul 2019 02:47:17 +0800
IronPort-SDR: HQxiRXPiluO+i1amhrFwbMts8nmX41sYgDekJoXvHkInAGxUg6LxdDkQkhDbPdFWvOOE+xen+C
 noMeYqT89T6g80q0Tms6mS4Wwi6/AEcyNXhgrZKIXGIDTX2sJc+gPUmFcjuN2CDNGXquigZQAl
 Cktc3ev+cQ5merTk1rsQCbDLuU62hmWXgrIGAQO6k8DawqH0GhLjzELjFVoOCwt6+4Pn/tZtfN
 tfyzudrROgFvhL7Ls7vjH5GqYJnx75gAQUc656sY1WpjOZZwkzaYNBjxqpvyAbUojCr78xhyRP
 0w1+U//6VVL/u7Uis519uR2+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP; 08 Jul 2019 11:46:05 -0700
IronPort-SDR: eW86af4OthOZtKlcukw8hg5FI8z3Pyrc2gRdLV4x4bpMNy4sygCYPSfYDcM2B4QXsj4ILsUxuF
 TQU3d19L1c5FTnZDXmSuL2XtMIjgw4+ea8vwSw8DmEbRevzLHYwgY1GdfVVK3SuKBCqem7cbn4
 XSceRHtmXS96JKNQcd4ThjYOnlatcCPqKA495dVcxKVT6l/6xIuUjOo10IT/VyGg6hXSPR4ROm
 3eC68pRisrEJDHQJIq9cvRlSgSS4pR/SeWPXZj+HOmUCZYEiKJ64+r/aVfvhqfvINTloVQsnsJ
 61U=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Jul 2019 11:47:16 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V4 0/9] block: use right accessor to read nr_sects
Date:   Mon,  8 Jul 2019 11:47:02 -0700
Message-Id: <20190708184711.2984-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.17.0
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

Please consider this for 5.3.

Changes from V3:-

1. Get rid of the comment in the 1st patch for helper. (Bart)

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

