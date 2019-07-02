Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CB55D569
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Jul 2019 19:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfGBRmq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 13:42:46 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:55980 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGBRmp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 13:42:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1562089366; x=1593625366;
  h=from:to:cc:subject:date:message-id;
  bh=ynTWt0LIGk94WvmkDMsXoNoeMmV+rcyKihqB3+wk4H4=;
  b=J1jzoIAxEvnBmFSy2xC1KJmlPpkhMr1hKHU6Q9bFFat6nIAqVoSUvdsd
   8R9EFOV0ZRnUG9dWlWvW2g+ViOaAZSgjllMZAGSOe6xBirQKuZ2aSKFKz
   TIcgoAcQcgbkL6WXRA8o+UWyUxE3fnEIo596LMYSrbJSB5tPPOqmdRZX5
   aaJZTzGBmmTo3GGI8jJ34XmsvSMLZnapSlvWLUFc328e4Di7cVAO5d8nM
   5OBArkkQgH3NpFUBHLYw7lrtU6mbjHRF2qoIgNit9f2P7GGYLKy8lHJDY
   pDRXdNxTAXVC1WWH81vK1L6ThXRnzIqxO0luWlEymR6ra750pafPkfKkL
   g==;
IronPort-SDR: WPznOFHsaFj7qXF6tmNmTUmvZUwtsva6E2bpE5LVlYjmSqbzh0M3O5VQZD2KeksR6lMwlDj6vb
 3HVUNp1WGtLVz3oGOs8YyeZ93GaS4iFHnar6WMVyMI8tmNy+SYK5SVd1k1TjPkxWR6ux5eWO1o
 pAxZTj28l1W1n8PXgF6h2w8BZ8uNwVERhv16LP7aAwvGbHF1bt/pGgXQ29X/6oRURvZru52k+5
 +xGQVwOihZRj1t8x8vl0Z0TiHWm444gtI1C6zC3R9peoe0U3CuRMgRi4ZiY7966CDVIlrZO1EA
 XrQ=
X-IronPort-AV: E=Sophos;i="5.63,444,1557158400"; 
   d="scan'208";a="116916521"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2019 01:42:40 +0800
IronPort-SDR: +olYvgKYJu9iCHn6as0dLGYwtE+MJmBLhiR4g2dgo1V5RwIb3G+fkxuAqcY0WzEXJdi1zaAx0N
 ro+OobUAKWLC+EkRdJ6sxd1Rwmnj1VLVE1GM5mo8fhJqoQBz63JJobdKmihgW/pwW8l4TJKv3C
 u1XToMYgKgjk1KryEuBb+GX7SM0wiuvYwbo4L7mcgAVaB/v6OYNi0Lharn8dPUQ8YLu5PVlHa5
 iJ1tgTM5NbWHoJODBnPimy6o/dPG/dQnfTUmTiVyl1Z9fcFSttq0R5jmPiFeGxNzIHYKjx313X
 LKaJ9FV5BHImAjJmzGl3ii8r
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP; 02 Jul 2019 10:41:42 -0700
IronPort-SDR: xFK+TzJBQTZp/heqygJSJnRPo0tQ9hijWGueFKQDOd4LSg6sKwbpFgF0VvZqkwgjK2yMgs4+Or
 icXs+wEaddgqpAV5uoeT3dSDE9avA4PYEYQ5oQOJjphWIpVSmShDFuVRNWCHRdtW1Yhb1pYnjl
 aAwv+rDoH2vPT1ui3sUjymvCZWJL7whXkR2tb9dx3GoZfwOevSFFE/paM5Yqd4R5A9cUZ/LnHQ
 6Kfo8rEQttUxmYSPyKgtw+OUaPzF/7x2osysgEy3nt5xgnr12RTiIDusa1T36wgh5pGspmUXoZ
 flA=
Received: from cvenusqemu.hgst.com ([10.202.66.73])
  by uls-op-cesaip02.wdc.com with ESMTP; 02 Jul 2019 10:42:39 -0700
From:   Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To:     linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH V3 0/9] block: use right accessor to read nr_sects
Date:   Tue,  2 Jul 2019 10:42:26 -0700
Message-Id: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
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

Changes from V2:-

1. Add target-pscsi patch.
2. Get rid of extra variable in the bdev_nr_setcs().
3. Add compile only patch for xen/blkback.

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
 include/linux/blkdev.h             |  6 ++++++
 kernel/trace/blktrace.c            |  2 +-
 7 files changed, 17 insertions(+), 11 deletions(-)

-- 
2.19.1

