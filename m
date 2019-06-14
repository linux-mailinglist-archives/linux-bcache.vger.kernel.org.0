Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD63445D9C
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbfFNNOF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:14:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:45214 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfFNNOE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB8A2AE07;
        Fri, 14 Jun 2019 13:14:03 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 00/29] bcache candidate patches for Linux v5.3 
Date:   Fri, 14 Jun 2019 21:13:29 +0800
Message-Id: <20190614131358.2771-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

Now I am testing the bcache patches for Linux v5.3, here I collect
all previously posted patches for your information. Any code review
and comment is welcome.

Thanks in advance.

Coly Li
---

Alexandru Ardelean (1):
  bcache: use sysfs_match_string() instead of __sysfs_match_string()

Coly Li (28):
  bcache: Revert "bcache: fix high CPU occupancy during journal"
  bcache: Revert "bcache: free heap cache_set->flush_btree in
    bch_journal_free"
  bcache: add code comments for journal_read_bucket()
  bcache: set largest seq to ja->seq[bucket_index] in
    journal_read_bucket()
  bcache: remove retry_flush_write from struct cache_set
  bcache: fix race in btree_flush_write()
  bcache: add reclaimed_journal_buckets to struct cache_set
  bcache: fix return value error in bch_journal_read()
  Revert "bcache: set CACHE_SET_IO_DISABLE in bch_cached_dev_error()"
  bcache: avoid flushing btree node in cache_set_flush() if io disabled
  bcache: ignore read-ahead request failure on backing device
  bcache: add io error counting in write_bdev_super_endio()
  bcache: remove "XXX:" comment line from run_cache_set()
  bcache: remove unnecessary prefetch() in bset_search_tree()
  bcache: add return value check to bch_cached_dev_run()
  bcache: remove unncessary code in bch_btree_keys_init()
  bcache: check CACHE_SET_IO_DISABLE in allocator code
  bcache: check CACHE_SET_IO_DISABLE bit in bch_journal()
  bcache: more detailed error message to bcache_device_link()
  bcache: add more error message in bch_cached_dev_attach()
  bcache: shrink btree node cache after bch_btree_check()
  bcache: improve error message in bch_cached_dev_run()
  bcache: make bset_search_tree() be more understandable
  bcache: add pendings_cleanup to stop pending bcache device
  bcache: avoid a deadlock in bcache_reboot()
  bcache: acquire bch_register_lock later in cached_dev_detach_finish()
  bcache: acquire bch_register_lock later in cached_dev_free()
  bcache: fix potential deadlock in cached_def_free()

 drivers/md/bcache/alloc.c     |   9 ++
 drivers/md/bcache/bcache.h    |   6 +-
 drivers/md/bcache/bset.c      |  61 ++++--------
 drivers/md/bcache/btree.c     |  19 +++-
 drivers/md/bcache/btree.h     |   2 +
 drivers/md/bcache/io.c        |  12 +++
 drivers/md/bcache/journal.c   | 141 +++++++++++++++++++--------
 drivers/md/bcache/journal.h   |   4 +
 drivers/md/bcache/super.c     | 218 +++++++++++++++++++++++++++++++++---------
 drivers/md/bcache/sysfs.c     |  63 ++++++++----
 drivers/md/bcache/util.h      |   2 -
 drivers/md/bcache/writeback.c |   4 +
 12 files changed, 389 insertions(+), 152 deletions(-)

-- 
2.16.4

