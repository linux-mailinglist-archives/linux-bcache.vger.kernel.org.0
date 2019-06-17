Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7A4779D
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 03:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFQB2l (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 16 Jun 2019 21:28:41 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:7477 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbfFQB2k (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 16 Jun 2019 21:28:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1560734920; x=1592270920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WOSfb54lqjmAhpxKks8qtBjKEWXJ2gQPrUDSicl9Hnk=;
  b=odLxXAgJaYjAEXRRwyMQ/I9BY2nl6W+bpx2qrf9IwAAceXodZI9Q9iWe
   mtf8EH8EIF2grSduEBSAhxRTvkjJTKmJ1ntySMBI5LBrhMkKru0bgPMLH
   KIstJkq4/2y2gGD87bicHQsXhla/Cz6jRYNs4Rq8f/ZszggS2l3n7kodD
   RjYoJ0MKxY6A2YJdkzLB68F84HZd1HTqdRRqZiCnYPz6PVQw/MArRRXal
   4r8NHvdeVyawkZMBQ7hmjL2Mbq5ay6IsxNCx1+6THLnCR/C5hJbkIO6Y8
   aLfA58rL4yWVnzrwYlaXm54wQ2sxE3bbiZhNqNu4MFkwxwg/8Ci7lEIVR
   A==;
X-IronPort-AV: E=Sophos;i="5.63,383,1557158400"; 
   d="scan'208";a="112362939"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jun 2019 09:28:38 +0800
IronPort-SDR: QIywSG0ORQ99aTQlVbeJUpsL8JRmU2xUkFm+m/4NI2C89tEtal45HKHxerz7SB9MmlyF4TUAnD
 1leOTQtO44x2D40aqQ+H8iijv/s3Ue76ksmZdYiclaObbQBdyo7nGLCV3vgzfzDgifJjpnc9vC
 QhKEl/SEIrKg0jynJljpsFGq076ZJhpB4XEghl/j/kvt4l7hC4cQvcgrJ2DBg9CpPhrsNRy0/Y
 dNWaBd4kfia6JgrRQykJAteH0nc8yqw4YXCeq/5O71hWWxuKAZpXqjDQZsUrkle+fvaljwkINd
 0OKnSAR8dOU5QXBIUXt90vKd
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP; 16 Jun 2019 18:28:16 -0700
IronPort-SDR: e9yLg0KsgSb036ZBFYJzKWGhn1ix8M/H5PzEIyUOFfS07QOrE0pWNDucJOXjf30T3hcelF022T
 1OmpPhsces+x38eqUg8RuxI8MLfRDgOpCPMUpqMEuBWcx8xhjeerh91ux6CH/8zYyPKOFa3waU
 kGr+ufS/GjwT23+Oi5RLlLnapCMksd3jpRcRXerdrcl3ZLb8zLsaktaO7Utipgi7qqFtMxUjkk
 ZfMa5DuHWJDXTcbMkj5uaoSZdsTWocm+sWwp/usRMzZ7Y83ikPZzPtFcS5utABB2c3gDWjZ+Cd
 /KM=
Received: from cmercuryqemu.hgst.com ([10.202.65.32])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2019 18:28:39 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V2 0/7] block: use right accessor to read nr_setcs
Date:   Sun, 16 Jun 2019 18:28:25 -0700
Message-Id: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi,

In the blk-zoned, bcache, f2fs and blktrace implementation
block device->hd_part->number of sectors field is accessed directly
without any appropriate locking or accessor function. There is
an existing accessor function present in the in include/linux/genhd.h
which should be used to read the bdev->hd_part->nr_sects.

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
bdev->hd_part->nr_sects for blk-zoned.c.

This series is based on :-

1. Repo :-
   git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git.
2. Branch :- for-next.

Regards,
Chaitanya

Changes from V1:-

1. Drop the target_pscsi patch. (Bart)
2. Remove rcu locking which is not needed. (Bart)

Chaitanya Kulkarni (7):
  block: add a helper function to read nr_setcs
  blk-zoned: update blkdev_nr_zones() with helper
  blk-zoned: update blkdev_report_zone() with helper
  blk-zoned: update blkdev_reset_zones() with helper
  bcache: update cached_dev_init() with helper
  f2fs: use helper in init_blkz_info()
  blktrace: use helper in blk_trace_setup_lba()

 block/blk-zoned.c         | 12 ++++++------
 drivers/md/bcache/super.c |  2 +-
 fs/f2fs/super.c           |  2 +-
 include/linux/blkdev.h    | 10 ++++++++++
 kernel/trace/blktrace.c   |  2 +-
 5 files changed, 19 insertions(+), 9 deletions(-)

-- 
2.19.1

