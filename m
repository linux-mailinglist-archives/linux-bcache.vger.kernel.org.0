Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B255999B
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfF1MAL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:00:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:54042 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfF1MAK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:00:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAED2B631;
        Fri, 28 Jun 2019 12:00:08 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/37] bcache patches for Linux v5.3
Date:   Fri, 28 Jun 2019 19:59:23 +0800
Message-Id: <20190628120000.40753-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are the bcache patches for Linux v5.3. All these patches are
tested for a while and survived from my smoking and pressure testings.

This run we have Alexandru Ardelean contributes a clean up patch. The
rested patches are from me, there is an important race fix has the
following patches involved in,
- bcache: Revert "bcache: free heap cache_set->flush_btree in
  bch_journal_free"
- bcache: Revert "bcache: fix high CPU occupancy during journal"
- bcache: remove retry_flush_write from struct cache_set
- bcache: fix race in btree_flush_write()
- bcache: performance improvement for btree_flush_write()
- bcache: add reclaimed_journal_buckets to struct cache_set
On a Lenovo SR650 server (48 cores, 200G dram, 1T NVMe SSD as cache
device and 12T NVMe SSD as backing device), without this fix, bcache
can only run 40 around minutes before deadlock or panic happens. Now
I don't observe any deadlock or panic for 5+ hours smoking test.

Please pick them for Linux v5.3, and thank you in advance.

Coly Li 
---

Alexandru Ardelean (1):
  bcache: use sysfs_match_string() instead of __sysfs_match_string()

Coly Li (36):
  bcache: don't set max writeback rate if gc is running
  bcache: check c->gc_thread by IS_ERR_OR_NULL in cache_set_flush()
  bcache: fix return value error in bch_journal_read()
  Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
  bcache: avoid flushing btree node in cache_set_flush() if io disabled
  bcache: ignore read-ahead request failure on backing device
  bcache: add io error counting in write_bdev_super_endio()
  bcache: remove unnecessary prefetch() in bset_search_tree()
  bcache: add return value check to bch_cached_dev_run()
  bcache: remove unncessary code in bch_btree_keys_init()
  bcache: check CACHE_SET_IO_DISABLE in allocator code
  bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
  bcache: more detailed error message to bcache_device_link()
  bcache: add more error message in bch_cached_dev_attach()
  bcache: improve error message in bch_cached_dev_run()
  bcache: remove "XXX:" comment line from run_cache_set()
  bcache: make bset_search_tree() be more understandable
  bcache: add pendings_cleanup to stop pending bcache device
  bcache: fix mistaken sysfs entry for io_error counter
  bcache: destroy dc->writeback_write_wq if failed to create
    dc->writeback_thread
  bcache: stop writeback kthread and kworker when bch_cached_dev_run()
    failed
  bcache: avoid a deadlock in bcache_reboot()
  bcache: acquire bch_register_lock later in cached_dev_detach_finish()
  bcache: acquire bch_register_lock later in cached_dev_free()
  bcache: fix potential deadlock in cached_def_free()
  bcache: add code comments for journal_read_bucket()
  bcache: set largest seq to ja->seq[bucket_index] in
    journal_read_bucket()
  bcache: shrink btree node cache after bch_btree_check()
  bcache: Revert "bcache: free heap cache_set->flush_btree in
    bch_journal_free"
  bcache: Revert "bcache: fix high CPU occupancy during journal"
  bcache: only clear BTREE_NODE_dirty bit when it is set
  bcache: add comments for mutex_lock(&b->write_lock)
  bcache: remove retry_flush_write from struct cache_set
  bcache: fix race in btree_flush_write()
  bcache: performance improvement for btree_flush_write()
  bcache: add reclaimed_journal_buckets to struct cache_set

 drivers/md/bcache/alloc.c     |   9 ++
 drivers/md/bcache/bcache.h    |   6 +-
 drivers/md/bcache/bset.c      |  61 ++++--------
 drivers/md/bcache/btree.c     |  53 ++++++++--
 drivers/md/bcache/btree.h     |   2 +
 drivers/md/bcache/io.c        |  12 +++
 drivers/md/bcache/journal.c   | 141 ++++++++++++++++++--------
 drivers/md/bcache/journal.h   |   4 +
 drivers/md/bcache/super.c     | 227 ++++++++++++++++++++++++++++++++++--------
 drivers/md/bcache/sysfs.c     |  67 +++++++++----
 drivers/md/bcache/util.h      |   2 -
 drivers/md/bcache/writeback.c |   8 ++
 12 files changed, 432 insertions(+), 160 deletions(-)

-- 
2.16.4

