Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF49C35A3A8
	for <lists+linux-bcache@lfdr.de>; Fri,  9 Apr 2021 18:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbhDIQoH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 9 Apr 2021 12:44:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:34612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232395AbhDIQoH (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 9 Apr 2021 12:44:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E7F80B10B;
        Fri,  9 Apr 2021 16:43:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.01.org,
        axboe@kernel.dk, jianpeng.ma@intel.com, qiaowei.ren@intel.com,
        hare@suse.com, jack@suse.cz, dan.j.williams@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v7 00/16] bcache: support NVDIMM for journaling
Date:   Sat, 10 Apr 2021 00:43:27 +0800
Message-Id: <20210409164343.56828-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is the 7th effort for bcache to support NVDIMM for jouranling since
the first nvm-pages series was posted.

This series is combination of the v7 nvm-pages allocator developed by
Intel developers and related bcache changes from me.

The nvm-pages allocator is a buddy-like allocator, which allocates size
in power-of-2 pages from the NVDIMM namespace. User space tool 'bcache'
has a new added '-M' option to format a NVDIMM namespace and register it
via sysfs interface as a bcache meta device. The nvm-pages kernel code
does a DAX mapping to map the whole namespace into system's memory
address range, and allocating the pages to requestion like typical buddy
allocator does. The major difference is nvm-pages allocator maintains
the pages allocated to each requester by a owner list which stored on
NVDIMM too. Owner list of different requester is tracked by a pre-
defined UUID, all the pages tracked in all owner lists are treated as
allocated busy pages and won't be initialized into buddy system after
the system reboot.

The bcache journal code may request a block of power-of-2 size pages
from the nvm-pages allocator, normally it is a range of 256MB or 512MB
continuous pages range. During meta data journaling, the in-memory jsets
go into the calculated nvdimm pages location by kernel memcpy routine.
So the journaling I/Os won't go into block device (e.g. SSD) anymore, 
the write and read for journal jsets happen on NVDIMM.

The nvm-pages on-NVDIMM data structures are defined as legacy in-memory
objects, because they ARE in-memory objects directly referenced by
linear addresses, both in system DRAM and NVDIMM. They are defined in
the following patch,
- bcache: add initial data structures for nvm pages

Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
nvm-pages, the related patches are,
- bcache: initialize the nvm pages allocator
- bcache: initialization of the buddy
- bcache: bch_nvm_alloc_pages() of the buddy
- bcache: bch_nvm_free_pages() of the buddy
- bcache: get allocated pages from specific owner
All the code depends on Linux libnvdimm and dax drivers, the bcache nvm-
pages allocator can be treated as user of these two drivers.

I modify the bcache code to recognize the nvm meta device feature,
initialize journal on NVDIMM, and do journal I/Os on NVDIMM in the
following patches,
- bcache: add initial data structures for nvm pages
- bcache: use bucket index to set GC_MARK_METADATA for journal buckets
  in bch_btree_gc_finish()
- bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
- bcache: initialize bcache journal for NVDIMM meta device
- bcache: support storing bcache journal into NVDIMM meta device
- bcache: read jset from NVDIMM pages for journal replay
- bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
  meta device

Also during the code integration and testing, there are some issues are
fixed by the following patches,
- bcache: nvm-pages fixes for bcache integration testing
- bcache: use div_u64() in init_owner_info()
- bcache: fix BCACHE_NVM_PAGES' dependences in Kconfig
- bcache: more fix for compiling error when BCACHE_NVM_PAGES disabled
The above patches can be added or merged into nvm-pages code, so that
they can be dropped in next version of this series.

Current series works as expected, of course it is not perfect but the
state is fine as a code base for further improvement. For example the
power failure tolerance for nvm-pages owner list operations, more error
handling for journal code, and moving the B+ tree node I/Os into NVDIMM.

All the code is EXPERIMENTAL, they won't be enabled by default until we
feel the NVDIMM support is completed and stable.

Any comments and suggestion is warmly welcome :-)

Thank you in advance.

Coly Li

---
Changelog:
v7: Refine nvm-pages allocator code to operate owner list directly in
    dax mapped NVDIMM pages, and remove the meta data copy from DRAM.
v6: The series submitted but not merged in Linux 5.12 merge window.
v1-v5: RFC patches of bcache nvm-pages.


Coly Li (11):
  bcache: add initial data structures for nvm pages
  bcache: nvm-pages fixes for bcache integration testing
  bcache: use bucket index to set GC_MARK_METADATA for journal buckets
    in bch_btree_gc_finish()
  bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
  bcache: initialize bcache journal for NVDIMM meta device
  bcache: support storing bcache journal into NVDIMM meta device
  bcache: read jset from NVDIMM pages for journal replay
  bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
    meta device
  bcache: use div_u64() in init_owner_info()
  bcache: fix BCACHE_NVM_PAGES' dependences in Kconfig
  bcache: more fix for compiling error when BCACHE_NVM_PAGES disabled

Jianpeng Ma (5):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner

 drivers/md/bcache/Kconfig       |   9 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/btree.c       |   6 +-
 drivers/md/bcache/features.h    |   9 +
 drivers/md/bcache/journal.c     | 317 +++++++++++---
 drivers/md/bcache/journal.h     |   2 +-
 drivers/md/bcache/nvm-pages.c   | 744 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  95 ++++
 drivers/md/bcache/super.c       |  73 +++-
 include/uapi/linux/bcache-nvm.h | 208 +++++++++
 10 files changed, 1392 insertions(+), 73 deletions(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.26.2

