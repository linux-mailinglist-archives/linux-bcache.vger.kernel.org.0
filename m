Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA973E966A
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Aug 2021 19:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhHKRDo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 11 Aug 2021 13:03:44 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:58234 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbhHKRDo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 11 Aug 2021 13:03:44 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 182531FEDE;
        Wed, 11 Aug 2021 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628701399; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hycqfTUT9Jkfjs8C5cEb7+1epzznRn7T6+5xI2Kz7Ds=;
        b=XPGA8KWJU0G5gGpDS0vsEHbZrm2gf4xrJgITnyVen93sZTLd2Blw0AAQXv21CiXqRN51hV
        g3QY4rLkuvYGv4e7BKOALrAsCacivBmZNSBzGqRvmETNHdnZsxrkpx8ABfzlpd1p1LUR8+
        z+OOgwSq8typDKOBa5aqFa4GYGml+A4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628701399;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=hycqfTUT9Jkfjs8C5cEb7+1epzznRn7T6+5xI2Kz7Ds=;
        b=8yA7Ev87xmjMIWjyEwLDTKpw4xyge1iEv4Xj+iZkSp2oYgTA7c5SFn6I8xtLtIr60kMQYX
        wQszU80oZ2SLnXAw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 022CBA3D58;
        Wed, 11 Aug 2021 17:02:54 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-nvdimm@lists.linux.dev,
        axboe@kernel.dk, hare@suse.com, jack@suse.cz,
        dan.j.williams@intel.com, hch@lst.de, ying.huang@intel.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v12 00/12] bcache: support NVDIMM for journaling 
Date:   Thu, 12 Aug 2021 01:02:12 +0800
Message-Id: <20210811170224.42837-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This is the v12 effort for supporting NVDIMM for bcache journal (some
versions may not posted with version numbers).

The major change of this version is the full pointer of on-media data
structure is replaced by per-namespace offset. Now a pointer address is
calculated by namespace base mapping address + per-namespace offset.
The code logic is same as previous version, all changes are only related
to the base+offset style pointer replacement.

The nvm-pages allocator is a buddy-like allocator, which allocates size
in power-of-2 pages from the NVDIMM namespace. User space tool 'bcache'
has a new added '-M' option to format a NVDIMM namespace and register it
via sysfs interface as a bcache meta device. The nvm-pages kernel code
does a DAX mapping to map the whole namespace into system's memory
address range, and allocating the pages to requestion like typical buddy
allocator does. The major difference is nvm-pages allocator maintains
the pages allocated to each requester by an allocation list which stored
on NVDIMM too. Allocation list of different requester is tracked by a
pre-defined UUID, all the pages tracked in all allocation lists are
treated as allocated busy pages and won't be initialized into buddy
system after the system reboot.

The bcache journal code may request a block of power-of-2 size pages
from the nvm-pages allocator, normally it is a range of 256MB or 512MB
continuous pages range. During meta data journaling, the in-memory jsets
go into the calculated nvdimm pages location by kernel memcpy routine.
So the journaling I/Os won't go into block device (e.g. SSD) anymore, 
the write and read for journal jsets happen on NVDIMM.

Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
nvm-pages, the related patches are,
- bcache: initialize the nvm pages allocator
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

In this series, all previously addressed issue via code reviews are all
fixed. And all known issue during testing are fixed. The code survives
from 24+ hours smoking and I/O pressure testing among many reboots, it
works well as expected.

All the code is EXPERIMENTAL, they won't be enabled by default until we
feel the NVDIMM support is completed and stable.

Although there are some experts helped to review the code logic, but we
do appreciate if more people may help to review the code. It is quite
common that bcache patches don't have enough code reviewer, but this
time I do need help for more review or comments on this series.

Thanks in advance.

Coly Li
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

 drivers/md/bcache/Kconfig       |  10 +
 drivers/md/bcache/Makefile      |   1 +
 drivers/md/bcache/btree.c       |   6 +-
 drivers/md/bcache/features.h    |   9 +
 drivers/md/bcache/journal.c     | 325 +++++++++--
 drivers/md/bcache/journal.h     |   2 +-
 drivers/md/bcache/nvm-pages.c   | 931 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 127 +++++
 drivers/md/bcache/super.c       |  53 +-
 include/uapi/linux/bcache-nvm.h | 253 +++++++++
 10 files changed, 1649 insertions(+), 68 deletions(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.26.2

