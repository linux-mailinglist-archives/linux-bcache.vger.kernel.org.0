Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E3F34BCC
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Jun 2019 17:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfFDPQb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Jun 2019 11:16:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:39056 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727737AbfFDPQb (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Jun 2019 11:16:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 71F45ADFE;
        Tue,  4 Jun 2019 15:16:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 00/15] bcache fixes before Linux v5.3 
Date:   Tue,  4 Jun 2019 23:16:09 +0800
Message-Id: <20190604151624.105150-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

Here are some bcache fixes on my hand before, I post them out
for your review and comments. I am also testing them at same time,
and manage to have them into the for-v5.3 series.

Thanks in advance.

Coly Li
---

Alexandru Ardelean (1):
  bcache: use sysfs_match_string() instead of __sysfs_match_string()

Coly Li (14):
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
  bcache: improve error message in bch_cached_dev_run()
  bcache: shrink btree node cache after bch_btree_check()

 drivers/md/bcache/alloc.c   |   9 ++++
 drivers/md/bcache/bcache.h  |   2 +-
 drivers/md/bcache/bset.c    |  31 ++++--------
 drivers/md/bcache/btree.c   |   4 ++
 drivers/md/bcache/io.c      |  12 +++++
 drivers/md/bcache/journal.c |   4 ++
 drivers/md/bcache/super.c   | 113 +++++++++++++++++++++++++++++---------------
 drivers/md/bcache/sysfs.c   |  27 +++++------
 8 files changed, 127 insertions(+), 75 deletions(-)

-- 
2.16.4

