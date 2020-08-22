Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DDB24E723
	for <lists+linux-bcache@lfdr.de>; Sat, 22 Aug 2020 13:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgHVLpq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 22 Aug 2020 07:45:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:56610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbgHVLpo (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 22 Aug 2020 07:45:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4DE45AD2C;
        Sat, 22 Aug 2020 11:46:11 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v2 00/12] bcache: remove multiple caches code framework
Date:   Sat, 22 Aug 2020 19:45:24 +0800
Message-Id: <20200822114536.23491-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The multiple caches code framework in bcache is to store multiple
copies of the cached data among multiple caches of the cache set.
Current code framework just does simple data write to each cache without
any extra condition handling (e.g. device failure, slow devices). This
code framework is not and will never be completed. Considering people
may use md raid1 for same similar data duplication purpose, the multiple
caches framework is useless dead code indeed.

Due to the multiple caches code framework, bcache has two data structure
struct cache and struct cache_set to manage the cache device. Indeed
since bcache was merged into mainline kernel in Linux v3.10, a cache set
only has one cache, the unnecessary two level abstraction makes extra
effort to maintain redundant information between struct cache and struct
cache set, for examaple the in-memmory super block struct cache_sb.

This is the first wave effort to remove multiple caches framework and
make the code and data structure relation to be more clear. This series
explicitly make each cache set only have single cache, and remove the
embedded partial super block in struct cache_set and directly reference
cache's in-memory super block.

The patch set now passes basic smoking testing, I post this series early
for your review and comments. More fixes after testing will follow up
soon.

Thanks in advance.

Coly Li 
---
Changelog:
v2: Add reviewed-by from Hannes Reinecke, update patches by suggestion
    from Hannes and Christoph.
v1: initial version.

Coly Li (12):
  bcache: remove 'int n' from parameter list of bch_bucket_alloc_set()
  bcache: explicitly make cache_set only have single cache
  bcache: remove for_each_cache()
  bcache: add set_uuid in struct cache_set
  bcache: only use block_bytes() on struct cache
  bcache: remove useless alloc_bucket_pages()
  bcache: remove useless bucket_pages()
  bcache: only use bucket_bytes() on struct cache
  bcache: don't check seq numbers in register_cache_set()
  bcache: remove can_attach_cache()
  bcache: check and set sync status on cache's in-memory super block
  bcache: remove embedded struct cache_sb from struct cache_set

 drivers/md/bcache/alloc.c     |  60 ++++-----
 drivers/md/bcache/bcache.h    |  29 ++--
 drivers/md/bcache/btree.c     | 144 ++++++++++----------
 drivers/md/bcache/btree.h     |   2 +-
 drivers/md/bcache/debug.c     |  10 +-
 drivers/md/bcache/extents.c   |   6 +-
 drivers/md/bcache/features.c  |   4 +-
 drivers/md/bcache/io.c        |   2 +-
 drivers/md/bcache/journal.c   | 246 ++++++++++++++++------------------
 drivers/md/bcache/movinggc.c  |  58 ++++----
 drivers/md/bcache/request.c   |   6 +-
 drivers/md/bcache/super.c     | 232 ++++++++++++--------------------
 drivers/md/bcache/sysfs.c     |  10 +-
 drivers/md/bcache/writeback.c |   2 +-
 include/trace/events/bcache.h |   4 +-
 15 files changed, 352 insertions(+), 463 deletions(-)

-- 
2.26.2

