Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D354A1ED3E6
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jun 2020 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgFCQDT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Jun 2020 12:03:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57489 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgFCQDT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jun 2020 12:03:19 -0400
Received: from mail-qk1-f199.google.com ([209.85.222.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <mfo@canonical.com>)
        id 1jgVrI-0006ES-Oc
        for linux-bcache@vger.kernel.org; Wed, 03 Jun 2020 16:03:16 +0000
Received: by mail-qk1-f199.google.com with SMTP id j16so2018838qka.11
        for <linux-bcache@vger.kernel.org>; Wed, 03 Jun 2020 09:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v3vSEh6aAD3ycMpIgnArx/PYNHrqwVHLd45WZNkI4QM=;
        b=EfJDGnlCxJQN6AL7zxatULRwnLjvcBzU47tO0xZFo05+hBCccTjKOvToh7K/2Zv4E0
         xtV/64xNG09Y1Whzwtb0GkxpyNUqt9bzngm8Cw7GUbsqv784wnQuXnhqxfIvBTUVclYZ
         Vi/P9EBmB42o1i7xgAadQJeP+e42iKCrByicF66u0QYx28aQCxJX+o3l0Dunf8D8eziN
         voRrkQxCsRb/4tEtZaOLsfBW/tvsdaCumX2rWxBMKUYDlVbeGWeLbFFZ6gIJH7aEHFA6
         cRaT5tu9oP2vS3Ux85JXKcYR0sFVluoFPUkOE7iDogvbhRkKLSRcfyYc5RhJOxz94dl1
         /ffg==
X-Gm-Message-State: AOAM530xuqehvLAGN/AyGbrGCNmc39usFx+jh54ivSTveABU46TMIH2A
        N/afvXMJ6kyjMQAjPtBlmGGfFijelBIT/0LrnIEpQfGWWTvMaTYA6glze0zG8pubKdSYHfnZHDj
        ZE+V5VI/8Nd3Sh1nvJDp07Jmzzyke1cGm/QLY/l+3jw==
X-Received: by 2002:a37:b883:: with SMTP id i125mr344379qkf.392.1591200195682;
        Wed, 03 Jun 2020 09:03:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0cx0C2Qj4oahE3D2ru3pblssQ4KWcZkH/BDSzf0Jw+xtFvlbpkClB0RIVgpptld2UxLrMKA==
X-Received: by 2002:a37:b883:: with SMTP id i125mr344294qkf.392.1591200194879;
        Wed, 03 Jun 2020 09:03:14 -0700 (PDT)
Received: from localhost.localdomain ([179.159.56.229])
        by smtp.gmail.com with ESMTPSA id a191sm1966973qkc.66.2020.06.03.09.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 09:03:14 -0700 (PDT)
From:   Mauricio Faria de Oliveira <mfo@canonical.com>
To:     Coly Li <colyli@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: check and adjust logical block size for backing devices
Date:   Wed,  3 Jun 2020 13:03:10 -0300
Message-Id: <20200603160310.499252-1-mfo@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It's possible for a block driver to set logical block size to
a value greater than page size incorrectly; e.g. bcache takes
the value from the superblock, set by the user w/ make-bcache.

This causes a BUG/NULL pointer dereference in the path:

  __blkdev_get()
  -> set_init_blocksize() // set i_blkbits based on ...
     -> bdev_logical_block_size()
        -> queue_logical_block_size() // ... this value
  -> bdev_disk_changed()
     ...
     -> blkdev_readpage()
        -> block_read_full_page()
           -> create_page_buffers() // size = 1 << i_blkbits
              -> create_empty_buffers() // give size/take pointer
                 -> alloc_page_buffers() // return NULL
                 .. BUG!

Because alloc_page_buffers() is called with size > PAGE_SIZE,
thus it initializes head = NULL, skips the loop, return head;
then create_empty_buffers() gets (and uses) the NULL pointer.

This has been around longer than commit ad6bf88a6c19 ("block:
fix an integer overflow in logical block size"); however, it
increased the range of values that can trigger the issue.

Previously only 8k/16k/32k (on x86/4k page size) would do it,
as greater values overflow unsigned short to zero, and queue_
logical_block_size() would then use the default of 512.

Now the range with unsigned int is much larger, and users w/
the 512k value, which happened to be zero'ed previously and
work fine, started to hit this issue -- as the zero is gone,
and queue_logical_block_size() does return 512k (>PAGE_SIZE.)

Fix this by checking the bcache device's logical block size,
and if it's greater than page size, fallback to the backing/
cached device's logical page size.

This doesn't affect cache devices as those are still checked
for block/page size in read_super(); only the backing/cached
devices are not.

Apparently it's a regression from commit 2903381fce71 ("bcache:
Take data offset from the bdev superblock."), moving the check
into BCACHE_SB_VERSION_CDEV only. Now that we have superblocks
of backing devices out there with this larger value, we cannot
refuse to load them (i.e., have a similar check in _BDEV.)

Ideally perhaps bcache should use all values from the backing
device (physical/logical/io_min block size)? But for now just
fix the problematic case.

Test-case:

    # IMG=/root/disk.img
    # dd if=/dev/zero of=$IMG bs=1 count=0 seek=1G
    # DEV=$(losetup --find --show $IMG)
    # make-bcache --bdev $DEV --block 8k
      < see dmesg >

Before:

    # uname -r
    5.7.0-rc7

    [   55.944046] BUG: kernel NULL pointer dereference, address: 0000000000000000
    ...
    [   55.949742] CPU: 3 PID: 610 Comm: bcache-register Not tainted 5.7.0-rc7 #4
    ...
    [   55.952281] RIP: 0010:create_empty_buffers+0x1a/0x100
    ...
    [   55.966434] Call Trace:
    [   55.967021]  create_page_buffers+0x48/0x50
    [   55.967834]  block_read_full_page+0x49/0x380
    [   55.972181]  do_read_cache_page+0x494/0x610
    [   55.974780]  read_part_sector+0x2d/0xaa
    [   55.975558]  read_lba+0x10e/0x1e0
    [   55.977904]  efi_partition+0x120/0x5a6
    [   55.980227]  blk_add_partitions+0x161/0x390
    [   55.982177]  bdev_disk_changed+0x61/0xd0
    [   55.982961]  __blkdev_get+0x350/0x490
    [   55.983715]  __device_add_disk+0x318/0x480
    [   55.984539]  bch_cached_dev_run+0xc5/0x270
    [   55.986010]  register_bcache.cold+0x122/0x179
    [   55.987628]  kernfs_fop_write+0xbc/0x1a0
    [   55.988416]  vfs_write+0xb1/0x1a0
    [   55.989134]  ksys_write+0x5a/0xd0
    [   55.989825]  do_syscall_64+0x43/0x140
    [   55.990563]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [   55.991519] RIP: 0033:0x7f7d60ba3154
    ...

After:

    # uname -r
    5.7.0.bcachelbspgsz

    [   31.672460] bcache: bcache_device_init() bcache0: sb/logical block size (8192) greater than page size (4096) falling back to device logical block size (512)
    [   31.675133] bcache: register_bdev() registered backing device loop0

    # grep ^ /sys/block/bcache0/queue/*_block_size
    /sys/block/bcache0/queue/logical_block_size:512
    /sys/block/bcache0/queue/physical_block_size:8192

Reported-by: Ryan Finnie <ryan@finnie.org>
Reported-by: Sebastian Marsching <sebastian@marsching.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@canonical.com>
---
 drivers/md/bcache/super.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index d98354fa28e3..d0af298d39ba 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -816,7 +816,8 @@ static void bcache_device_free(struct bcache_device *d)
 }
 
 static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
-			      sector_t sectors, make_request_fn make_request_fn)
+			      sector_t sectors, make_request_fn make_request_fn,
+			      struct block_device *cached_bdev)
 {
 	struct request_queue *q;
 	const size_t max_stripes = min_t(size_t, INT_MAX,
@@ -882,6 +883,21 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
 	q->limits.io_min		= block_size;
 	q->limits.logical_block_size	= block_size;
 	q->limits.physical_block_size	= block_size;
+
+	if (q->limits.logical_block_size > PAGE_SIZE && cached_bdev) {
+		/*
+		 * This should only happen with BCACHE_SB_VERSION_BDEV.
+		 * Block/page size is checked for BCACHE_SB_VERSION_CDEV.
+		 */
+		pr_info("%s: sb/logical block size (%u) greater than page size "
+			"(%lu) falling back to device logical block size (%u)",
+			d->disk->disk_name, q->limits.logical_block_size,
+			PAGE_SIZE, bdev_logical_block_size(cached_bdev));
+
+		/* This also adjusts physical block size/min io size if needed */
+		blk_queue_logical_block_size(q, bdev_logical_block_size(cached_bdev));
+	}
+
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, d->disk->queue);
 	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, d->disk->queue);
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, d->disk->queue);
@@ -1339,7 +1355,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
 
 	ret = bcache_device_init(&dc->disk, block_size,
 			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
-			 cached_dev_make_request);
+			 cached_dev_make_request, dc->bdev);
 	if (ret)
 		return ret;
 
@@ -1452,7 +1468,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	kobject_init(&d->kobj, &bch_flash_dev_ktype);
 
 	if (bcache_device_init(d, block_bytes(c), u->sectors,
-			flash_dev_make_request))
+			flash_dev_make_request, NULL))
 		goto err;
 
 	bcache_device_attach(d, c, u - c->uuids);
-- 
2.25.1

