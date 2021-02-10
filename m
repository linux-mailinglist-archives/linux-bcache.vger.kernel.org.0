Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCA6315E98
	for <lists+linux-bcache@lfdr.de>; Wed, 10 Feb 2021 06:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBJFIq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 00:08:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:40078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhBJFIn (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 00:08:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7C5C4AC97;
        Wed, 10 Feb 2021 05:08:00 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Kai Krakow <kai@kaishome.de>
Subject: [PATCH 00/20] bcache patches for Linux v5.12 
Date:   Wed, 10 Feb 2021 13:07:22 +0800
Message-Id: <20210210050742.31237-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the first wave bcache patches for Linux v5.12.

It is nice to see in this round we have 3 new patch contributors:
Jianpeng Ma, Qiaowei Ren and Kai Krakow.

In this series, the EXPERIMENTAL patches from Jianpeng Ma, Qiaowei Ren
and me are initial effort to store bcache meta-data on NVDIMM namespace.
The NVDIMM space is managed and mapped via DAX interface, and accessed
by linear address. In this submission we store bcache journal on NVDIMM,
in future bcache btree nodes and other meta data will be added in too,
before we remove the EXPERIMENTAL statues.

Dongdong Tao contributes a performance optimization when
bcache cache buckets are highly fregmented, Dongdong's patch makes the
dirty data writeback faster and from his benchmark reprots such changes
have recognized improvement for randome write I/O thoughput and latency
for highly fregmented buckets, and no regression for regular I/O
observed.

Kai Krakow contributes 4 patches to offload system_wq usage to separated
btree_io_wq and bch_flush_wq. In his environment the daily backup job
throughput increases from 60.2MB/s to 419MB/s and accomplished time
reduced from 14h29m to 2h13m.

Joe Perches also contributes a fine code stype fix which I pick for this
submission.

Please take them for Linux v5.12 merge window.

Thank you in advance.

Coly Li
---

Coly Li (8):
  bcache: add initial data structures for nvm pages
  bcache: use bucket index for SET_GC_MARK() in bch_btree_gc_finish()
  bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
  bcache: initialize bcache journal for NVDIMM meta device
  bcache: support storing bcache journal into NVDIMM meta device
  bcache: read jset from NVDIMM pages for journal replay
  bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
    meta device
  bcache: only initialize nvm-pages allocator when
    CONFIG_BCACHE_NVM_PAGES configured

Jianpeng Ma (6):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner
  bcache: persist owner info when alloc/free pages.

Joe Perches (1):
  bcache: Avoid comma separated statements

Kai Krakow (4):
  bcache: Fix register_device_aync typo
  Revert "bcache: Kill btree_io_wq"
  bcache: Give btree_io_wq correct semantics again
  bcache: Move journal work to new flush wq

dongdong tao (1):
  bcache: consider the fragmentation when update the writeback rate

 drivers/md/bcache/Kconfig       |   6 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/bcache.h      |   7 +
 drivers/md/bcache/bset.c        |  12 +-
 drivers/md/bcache/btree.c       |  27 +-
 drivers/md/bcache/features.h    |   9 +
 drivers/md/bcache/journal.c     | 293 ++++++++---
 drivers/md/bcache/journal.h     |   2 +-
 drivers/md/bcache/nvm-pages.c   | 853 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 112 +++++
 drivers/md/bcache/super.c       |  76 ++-
 drivers/md/bcache/sysfs.c       |  29 +-
 drivers/md/bcache/writeback.c   |  42 ++
 drivers/md/bcache/writeback.h   |   4 +
 include/uapi/linux/bcache-nvm.h | 188 +++++++
 15 files changed, 1579 insertions(+), 83 deletions(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.26.2

