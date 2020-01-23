Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FFF146EE6
	for <lists+linux-bcache@lfdr.de>; Thu, 23 Jan 2020 18:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgAWRBC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 23 Jan 2020 12:01:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:50674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729936AbgAWRBC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 23 Jan 2020 12:01:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C9E42AF59;
        Thu, 23 Jan 2020 17:01:00 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/17] bcache patches for Linux v5.16
Date:   Fri, 24 Jan 2020 01:00:02 +0800
Message-Id: <20200123170019.98872-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

Hi Jens,

Here are the bcache patches for Linux v5.16.
In this series, we have 5 contributors including me,
- Ben Dooks and Guoju Fang contributes minor changes,
- Liang Chen contributes a patch to fix a bcache super block page leak
  issue.
- Christoph Hellwig contributes a set of changes to improve the on-disk
  format for super block I/O, and his patches pluses Liang Chen's patch
  will make bcache supports kernel page size larger than 4KB. Now bcache
  can work on machines (e.g. ARM64) which have 8KB or larger kernel page
  size.
- I fixes some minor issue from Christoph's patches. And there are
  effort to make bcache shrink btree node cache more aggressive when
  system memory usage is in pressure. There are two importent fixes for
  performance regression (Cc to Linux-stable),
  - Fix extra I/O when aggressively flushing dirty btree node pages in
    bcache journal code. 
  - Back to cache all readahead I/Os for small random I/Os.

There are still some patches under testing. Once they passes my testing,
I will submit them in following v5.6-rc versions.

Please take these patches, and thank you in advance.

Coly Li
---

Ben Dooks (Codethink) (1):
  lib: crc64: include <linux/crc64.h> for 'crc64_be'

Christoph Hellwig (6):
  bcache: use a separate data structure for the on-disk super block
  bcache: rework error unwinding in register_bcache
  bcache: transfer the sb_page reference to register_{bdev,cache}
  bcache: return a pointer to the on-disk sb from read_super
  bcache: store a pointer to the on-disk sb in the cache and cached_dev
    structures
  bcache: use read_cache_page_gfp to read the superblock

Coly Li (8):
  bcache: properly initialize 'path' and 'err' in register_bcache()
  bcache: fix use-after-free in register_bcache()
  bcache: add code comments for state->pool in __btree_sort()
  bcache: avoid unnecessary btree nodes flushing in btree_flush_write()
  bcache: back to cache all readahead I/Os
  bcache: remove member accessed from struct btree
  bcache: reap c->btree_cache_freeable from the tail in bch_mca_scan()
  bcache: reap from tail of c->btree_cache in bch_mca_scan()

Guoju Fang (1):
  bcache: print written and keys in trace_bcache_btree_write

Liang Chen (1):
  bcache: cached_dev_free needs to put the sb page

 drivers/md/bcache/bcache.h    |   2 +
 drivers/md/bcache/bset.c      |   5 ++
 drivers/md/bcache/btree.c     |  24 ++++----
 drivers/md/bcache/btree.h     |   2 -
 drivers/md/bcache/journal.c   |  80 +++++++++++++++++++++++--
 drivers/md/bcache/request.c   |   9 ---
 drivers/md/bcache/super.c     | 136 ++++++++++++++++++++++--------------------
 include/trace/events/bcache.h |   3 +-
 include/uapi/linux/bcache.h   |  52 ++++++++++++++++
 lib/crc64.c                   |   1 +
 10 files changed, 218 insertions(+), 96 deletions(-)

-- 
2.16.4

