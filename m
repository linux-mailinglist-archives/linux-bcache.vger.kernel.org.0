Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75F4FA9AE
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Nov 2019 06:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfKMFeQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Nov 2019 00:34:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:54068 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725976AbfKMFeP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Nov 2019 00:34:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3E168B150;
        Wed, 13 Nov 2019 05:34:14 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/10] bcache patches for Linux v5.5 
Date:   Wed, 13 Nov 2019 13:33:36 +0800
Message-Id: <20191113053346.63536-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the patches for Linux v5.5. The patches have been testing for
a while during my current development, they are ready to be merged.

There are still other patches under testing, I will submit to you in
later runs if I feel they are solid enough in my testing.

Thanks for taking care of this.

Coly Li
---

Andrea Righi (1):
  bcache: fix deadlock in bcache_allocator

Coly Li (8):
  bcache: fix fifo index swapping condition in journal_pin_cmp()
  bcache: fix static checker warning in bcache_device_free()
  bcache: add more accurate error messages in read_super()
  bcache: deleted code comments for dead code in bch_data_insert_keys()
  bcache: add code comment bch_keylist_pop() and bch_keylist_pop_front()
  bcache: add code comments in bch_btree_leaf_dirty()
  bcache: add idle_max_writeback_rate sysfs interface
  bcache: at least try to shrink 1 node in bch_mca_scan()

Guoju Fang (1):
  bcache: fix a lost wake-up problem caused by mca_cannibalize_lock

 drivers/md/bcache/alloc.c     |  5 +++-
 drivers/md/bcache/bcache.h    |  4 +++-
 drivers/md/bcache/bset.c      |  2 ++
 drivers/md/bcache/btree.c     | 45 ++++++++++++++++++++++++++++++----
 drivers/md/bcache/journal.h   |  4 ----
 drivers/md/bcache/request.c   | 12 ----------
 drivers/md/bcache/super.c     | 56 +++++++++++++++++++++++++++++++------------
 drivers/md/bcache/sysfs.c     |  7 ++++++
 drivers/md/bcache/writeback.c |  4 ++++
 9 files changed, 102 insertions(+), 37 deletions(-)

-- 
2.16.4

