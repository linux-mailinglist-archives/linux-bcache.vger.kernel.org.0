Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41789301B00
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Jan 2021 11:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbhAXKGE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Jan 2021 05:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbhAXKF4 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Jan 2021 05:05:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C035C061573;
        Sun, 24 Jan 2021 02:05:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=TvDyKhz7ulAHBtG2FFhYq5BP/15LHCtoLOOoolMNz4I=; b=HUFYKHB/XNVoXfOKSNWlp2Lk3P
        6hG277ofN9oRneNTdG82/P4N5jHzEIWZw7Y2yNc4U0YFmhPtxEOVss/hE6ZMuhO6iEOl1uoBQUvyC
        SfKUg/qgyzHD96TJxq1ozjRxYqeA6RHXmgARaWeOEUpIpYiqnOTer+DfUk5FwNEhqdakStkWj0Yj2
        nucorlBDow281qe8G+B36Gd7ZYjURUT4eCjnucXc0AJKnnnNYnmcyMT+IBldK1pkOZcZ4tAdg7Odz
        opTS3zlVtyn7N8CI3iMBx6Uhyx0o7LevaBBcA79j6jcvyA54K8Wpihxc2vBvRZ94HqKW7Zqw/R5X1
        kx9BpSKg==;
Received: from 089144206130.atnat0015.highway.bob.at ([89.144.206.130] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l3cGJ-002q3S-S7; Sun, 24 Jan 2021 10:04:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: store a pointer to the block_device in struct bio (again) v2
Date:   Sun, 24 Jan 2021 11:02:31 +0100
Message-Id: <20210124100241.1167849-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

this series switches back from storing the gendisk + partno to storing
a block_device pointer in struct bio.  The reason is two fold:  for one
the new struct block_device actually is always available, removing the
need to avoid originally.  Second the merge struct block_device is much
more useful than the old one, as storing it avoids the need for looking
up what used to be hd_struct during partition remapping and I/O
accounting.

Note that this series depends on the posted but not merged
"split hard read-only vs read-only policy" series.

A git tree is also available:

    git://git.infradead.org/users/hch/block.git bi_bdev

Gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bi_bdev

Changes since v1:
 - protect against double remapping I/O to partitions

Diffstat:
 arch/m68k/emu/nfblock.c             |    2 
 arch/xtensa/platforms/iss/simdisk.c |    2 
 block/bio-integrity.c               |   18 +-
 block/bio.c                         |   31 +---
 block/blk-cgroup.c                  |    7 
 block/blk-core.c                    |  100 ++++++-------
 block/blk-crypto-fallback.c         |    2 
 block/blk-crypto.c                  |    2 
 block/blk-merge.c                   |   17 +-
 block/blk-mq.c                      |    2 
 block/blk-settings.c                |    2 
 block/blk-throttle.c                |    2 
 block/blk.h                         |    5 
 block/bounce.c                      |    2 
 block/genhd.c                       |  271 ++++--------------------------------
 block/partitions/core.c             |   31 ----
 drivers/block/brd.c                 |    8 -
 drivers/block/drbd/drbd_int.h       |    4 
 drivers/block/drbd/drbd_req.c       |    2 
 drivers/block/null_blk/main.c       |    2 
 drivers/block/pktcdvd.c             |    4 
 drivers/block/ps3vram.c             |    2 
 drivers/block/rsxx/dev.c            |    2 
 drivers/block/umem.c                |    2 
 drivers/block/zram/zram_drv.c       |    2 
 drivers/lightnvm/pblk-init.c        |    2 
 drivers/md/bcache/debug.c           |    2 
 drivers/md/bcache/request.c         |   39 +++--
 drivers/md/dm-bio-record.h          |    9 -
 drivers/md/dm-raid1.c               |   10 -
 drivers/md/dm.c                     |   14 -
 drivers/md/md-linear.c              |    2 
 drivers/md/md.c                     |   10 -
 drivers/md/md.h                     |    6 
 drivers/md/raid1.c                  |    6 
 drivers/md/raid10.c                 |   12 -
 drivers/md/raid5.c                  |    2 
 drivers/nvdimm/blk.c                |    4 
 drivers/nvdimm/btt.c                |    4 
 drivers/nvdimm/pmem.c               |    4 
 drivers/nvme/host/core.c            |    6 
 drivers/nvme/host/lightnvm.c        |    3 
 drivers/nvme/host/multipath.c       |    6 
 drivers/nvme/host/rdma.c            |    2 
 drivers/s390/block/dasd.c           |   26 ---
 drivers/s390/block/dcssblk.c        |    6 
 drivers/s390/block/xpram.c          |    2 
 fs/btrfs/check-integrity.c          |   10 -
 fs/btrfs/raid56.c                   |    7 
 fs/btrfs/scrub.c                    |    2 
 fs/direct-io.c                      |    2 
 fs/f2fs/data.c                      |   12 -
 include/linux/bio.h                 |   20 +-
 include/linux/blk-mq.h              |    4 
 include/linux/blk_types.h           |    4 
 include/linux/blkdev.h              |   20 --
 include/linux/genhd.h               |   21 --
 kernel/trace/blktrace.c             |   16 +-
 mm/page_io.c                        |    2 
 59 files changed, 260 insertions(+), 561 deletions(-)
