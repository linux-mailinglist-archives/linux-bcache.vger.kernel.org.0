Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C30322D72B
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGYMCi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:02:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:52018 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCi (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A8E66AB55;
        Sat, 25 Jul 2020 12:02:44 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/25] bcache patches for Linux v5.9 
Date:   Sat, 25 Jul 2020 20:00:14 +0800
Message-Id: <20200725120039.91071-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the first wave bcache series for Linux v5.9.

The most part of change is to add large_bucket size support to bcache,
which permits user to extend the bucket size from 16bit to 32bit width.
This is the initial state of large bucket feature, more improvement will
happen in future versions.

Most of the patches from me are for the large_bucket feature, except for,
- The fix for stripe size overflow
   bcache: avoid nr_stripes overflow in bcache_device_init()
   bcache: fix overflow in offset_to_stripe()
- The fix to I/O account on wrong device
   bcache: fix bio_{start,end}_io_acct with proper device

Also we have Gustavo A. R. Silva to contribute 2 patches to cleanup
kzalloc() code by using struct_size(), Jean Delvare to contribute a
typo fix in bcache Kconfig file, and Xu Wang to contribute two code
cleanup patches.

Please take them for your Linux v5.9 block drivers branch.

Thank you in advance.

Coly Li
---

Coly Li (20):
  bcache: allocate meta data pages as compound pages
  bcache: avoid nr_stripes overflow in bcache_device_init()
  bcache: fix overflow in offset_to_stripe()
  bcache: add read_super_common() to read major part of super block
  bcache: add more accurate error information in read_super_common()
  bcache: disassemble the big if() checks in bch_cache_set_alloc()
  bcache: fix super block seq numbers comparision in
    register_cache_set()
  bcache: increase super block version for cache device and backing
    device
  bcache: move bucket related code into read_super_common()
  bcache: struct cache_sb is only for in-memory super block now
  bcache: introduce meta_bucket_pages() related helper routines
  bcache: handle c->uuids properly for bucket size > 8MB
  bcache: handle cache prio_buckets and disk_buckets properly for bucket
    size > 8MB
  bcache: handle cache set verify_ondisk properly for bucket size > 8MB
  bcache: handle btree node memory allocation properly for bucket size >
    8MB
  bcache: add bucket_size_hi into struct cache_sb_disk for large bucket
  bcache: add sysfs file to display feature sets information of cache
    set
  bcache: avoid extra memory allocation from mempool c->fill_iter
  bcache: avoid extra memory consumption in struct bbio for large bucket
    size
  bcache: fix bio_{start,end}_io_acct with proper device

Gustavo A. R. Silva (2):
  bcache: movinggc: Use struct_size() helper in kzalloc()
  bcache: Use struct_size() in kzalloc()

Jean Delvare (1):
  bcache: Fix typo in Kconfig name

Xu Wang (2):
  bcache: journel: use for_each_clear_bit() to simplify the code
  bcache: writeback: Remove unneeded variable i

 drivers/md/bcache/Kconfig     |   2 +-
 drivers/md/bcache/Makefile    |   2 +-
 drivers/md/bcache/alloc.c     |   2 +-
 drivers/md/bcache/bcache.h    |  31 +++-
 drivers/md/bcache/bset.c      |   2 +-
 drivers/md/bcache/btree.c     |  12 +-
 drivers/md/bcache/features.c  |  75 +++++++++
 drivers/md/bcache/features.h  |  86 +++++++++++
 drivers/md/bcache/io.c        |   2 +-
 drivers/md/bcache/journal.c   |   9 +-
 drivers/md/bcache/movinggc.c  |   8 +-
 drivers/md/bcache/request.c   |  31 +++-
 drivers/md/bcache/super.c     | 277 +++++++++++++++++++++++-----------
 drivers/md/bcache/sysfs.c     |  14 ++
 drivers/md/bcache/writeback.c |  22 +--
 drivers/md/bcache/writeback.h |  19 ++-
 include/uapi/linux/bcache.h   |  38 +++--
 17 files changed, 493 insertions(+), 139 deletions(-)
 create mode 100644 drivers/md/bcache/features.c
 create mode 100644 drivers/md/bcache/features.h

-- 
2.26.2

