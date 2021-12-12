Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD8C471BB5
	for <lists+linux-bcache@lfdr.de>; Sun, 12 Dec 2021 18:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbhLLRGK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 12 Dec 2021 12:06:10 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39722 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhLLRGJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 12 Dec 2021 12:06:09 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5E0951F3B0;
        Sun, 12 Dec 2021 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639328768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NB+IVNIqaSUeJRB5/aK0UbHqVr2SlPfg+m65Jka1ij0=;
        b=2KsrTxcQ61lf6et8SS04+NL7fPXc3kNXjTZneMqVK8Q0aSAmay/54k+m5bPcDTWCbBuLiD
        sJeld9sQmTK+0qo6tWPaxyrQNB+fVDwU+gxqUdhvl23PBKqzNJHByZsc7QqP9yCxpPhIU2
        vvtrRHPuH9LuTtjCCA/m4XX6BdFqnGk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639328768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=NB+IVNIqaSUeJRB5/aK0UbHqVr2SlPfg+m65Jka1ij0=;
        b=l0czxJlHlOd9QB1j/bRG7gFbYsiilts5DzRxfvpbKQy19mpT/HXlV5t9YI2y1kWE67gUOF
        yhsfkiO0gYvl20AQ==
Received: from suse.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id A66D2A3B83;
        Sun, 12 Dec 2021 17:06:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Ying Huang <ying.huang@intel.com>
Subject: [PATCH v13 00/12] bcache for 5.17: enable NVDIMM for bcache journal
Date:   Mon, 13 Dec 2021 01:05:40 +0800
Message-Id: <20211212170552.2812-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the v12 effort the enabling NVDIMM for bcache journal, the code
is under testing for months and quite stable now. Please consider to
take them for Linux v5.17 merge window.

All current code logic and on-media format are consistent with previous
v12 series. The major difference from v12 series include,
- more typos in code comments and commit logs are fixed.
- add kernel message to indicate only first range is used currently if
  the NVDIMM namespace has multiple mapping ranges.
- not export nvm-pages allocator APIs, it is unnecessary since currently 
  only bcache uses them.

Now all previous bcache related UAPI headers are all moved into bcache
private code directory, there is no global headers exported to neither
kernel or user source code.

Bcache uses nvm-pages allocator to allocate pages from NVDIMM namespace
for its journaling space. The nvm-pages allocator is a buddy-like
allocator, which allocates size in power-of-2 pages from the NVDIMM
namespace. User space tool 'bcache' has a new added '-M' option to
format a NVDIMM namespace and register it via sysfs interface as a
bcache meta device. The nvm-pages allocator code does a DAX mapping to
map the whole namespace into system's memory address range, and allocate
the pages to requestion like typical buddy allocator does. The major
difference is nvm-pages allocator maintains the pages allocated to each
requester by an allocation list which stored on NVDIMM too. Allocation
list of different requester is tracked by a pre-defined UUID, all the
pages tracked in all allocation lists are treated as allocated busy
pages and won't be initialized into buddy system after the system
reboots.

The bcache journal code may request a block of power-of-2 size pages
from the nvm-pages allocator, normally it is a range of 256MB or 512MB
continuous pages range. During meta data journaling, the in-memory jsets
go into the calculated nvdimm pages location by kernel memcpy routine.
So the journaling I/Os won't go into block device (e.g. SSD) anymore,
the write and read for journal jsets happen on NVDIMM. 

Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
nvm-pages allocator, the related patches are,
- bcache: initialize the nvm-pages allocator
- bcache: initialization of the buddy
- bcache: bch_nvm_alloc_pages() of the buddy
- bcache: bch_nvm_free_pages() of the buddy
- bcache: get recs list head for allocated pages by specific uuid
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

All the code is EXPERIMENTAL, they won't be enabled by default until we
feel the NVDIMM support is completed and stable. The current code has
been tested internally for monthes, we don't observe any issue during
all tests with or without enabling the configuration.

Please consider to pick this series for Linux v5.17 merge window. If
there is any issue detected, we will response in time and fix them ASAP.

Thank you in advance.

Coly Li

Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jianpeng Ma <jianpeng.ma@intel.com>
Cc: Qiaowei Ren <qiaowei.ren@intel.com>
Cc: Ying Huang <ying.huang@intel.com>
---

Coly Li (7):
  bcache: add initial data structures for nvm pages
  bcache: use bucket index to set GC_MARK_METADATA for journal buckets
    in bch_btree_gc_finish()
  bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
  bcache: initialize bcache journal for NVDIMM meta device
  bcache: support storing bcache journal into NVDIMM meta device
  bcache: read jset from NVDIMM pages for journal replay
  bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
    meta device

Jianpeng Ma (5):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvmpg_alloc_pages() of the buddy
  bcache: bch_nvmpg_free_pages() of the buddy allocator
  bcache: get recs list head for allocated pages by specific uuid

 drivers/md/bcache/Kconfig        |  10 +
 drivers/md/bcache/Makefile       |   1 +
 drivers/md/bcache/btree.c        |   6 +-
 drivers/md/bcache/features.h     |   9 +
 drivers/md/bcache/journal.c      | 321 +++++++++--
 drivers/md/bcache/journal.h      |   2 +-
 drivers/md/bcache/nvmpg.c        | 931 +++++++++++++++++++++++++++++++
 drivers/md/bcache/nvmpg.h        | 128 +++++
 drivers/md/bcache/nvmpg_format.h | 253 +++++++++
 drivers/md/bcache/super.c        |  53 +-
 10 files changed, 1646 insertions(+), 68 deletions(-)
 create mode 100644 drivers/md/bcache/nvmpg.c
 create mode 100644 drivers/md/bcache/nvmpg.h
 create mode 100644 drivers/md/bcache/nvmpg_format.h

-- 
2.31.1

