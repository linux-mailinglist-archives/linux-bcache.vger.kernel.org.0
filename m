Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE551A1E78
	for <lists+linux-bcache@lfdr.de>; Wed,  8 Apr 2020 12:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHKDN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 8 Apr 2020 06:03:13 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725932AbgDHKDN (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 8 Apr 2020 06:03:13 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E17092C4527AAA40B6D0
        for <linux-bcache@vger.kernel.org>; Wed,  8 Apr 2020 18:03:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.221.252) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 8 Apr 2020
 18:02:53 +0800
From:   Wu Bo <wubo40@huawei.com>
Subject: [PATCH] bcache:cleanup resources when bcache device init failed
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>
Message-ID: <80a757d9-011b-6a58-f6ec-744f02153c74@huawei.com>
Date:   Wed, 8 Apr 2020 18:02:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.221.252]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Wu Bo <wubo40@huawei.com>

Cleanup resources when device init failed on bcache_device_init function

Signed-off-by: Wu Bo <wubo40@huawei.com>
---
  drivers/md/bcache/super.c | 27 +++++++++++++++++++--------
  1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d98354f..b4e3d0e 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -823,6 +823,7 @@ static int bcache_device_init(struct bcache_device 
*d, unsigned int block_size,
                                          SIZE_MAX / sizeof(atomic_t));
         size_t n;
         int idx;
+       int rtn = -ENOMEM;

         if (!d->stripe_size)
                 d->stripe_size = 1 << 31;
@@ -843,20 +844,22 @@ static int bcache_device_init(struct bcache_device 
*d, unsigned int block_size,
         n = BITS_TO_LONGS(d->nr_stripes) * sizeof(unsigned long);
         d->full_dirty_stripes = kvzalloc(n, GFP_KERNEL);
         if (!d->full_dirty_stripes)
-               return -ENOMEM;
+               goto out_free_sectors_dirty;

         idx = ida_simple_get(&bcache_device_idx, 0,
                                 BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
-       if (idx < 0)
-               return idx;
+       if (idx < 0) {
+               rtn = idx;
+               goto out_free_dirty_stripes;
+       }

         if (bioset_init(&d->bio_split, 4, offsetof(struct bbio, bio),
                         BIOSET_NEED_BVECS|BIOSET_NEED_RESCUER))
-               goto err;
+               goto out_free_idx;

         d->disk = alloc_disk(BCACHE_MINORS);
         if (!d->disk)
-               goto err;
+               goto out_bioset_exit;

         set_capacity(d->disk, sectors);
         snprintf(d->disk->disk_name, DISK_NAME_LEN, "bcache%i", idx);
@@ -868,7 +871,7 @@ static int bcache_device_init(struct bcache_device 
*d, unsigned int block_size,

         q = blk_alloc_queue(make_request_fn, NUMA_NO_NODE);
         if (!q)
-               return -ENOMEM;
+               goto out_free_disk;

         d->disk->queue                  = q;
         q->queuedata                    = d;
@@ -890,9 +893,17 @@ static int bcache_device_init(struct bcache_device 
*d, unsigned int block_size,

         return 0;

-err:
+out_free_disk:
+       put_disk(d->disk);
+out_bioset_exit:
+       bioset_exit(&d->bio_split);
+out_free_idx:
         ida_simple_remove(&bcache_device_idx, idx);
-       return -ENOMEM;
+out_free_dirty_stripes:
+       kvfree(d->full_dirty_stripes);
+out_free_sectors_dirty:
+       kvfree(d->stripe_sectors_dirty);
+       return rtn;

  }

--
1.8.3.1



