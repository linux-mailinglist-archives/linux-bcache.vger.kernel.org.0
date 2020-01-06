Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A517B13159B
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Jan 2020 17:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgAFQFC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 6 Jan 2020 11:05:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:42572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgAFQFC (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 6 Jan 2020 11:05:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E520AD2C
        for <linux-bcache@vger.kernel.org>; Mon,  6 Jan 2020 16:05:01 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/7] bcache: limit btree node cache memory consumption
Date:   Tue,  7 Jan 2020 00:04:49 +0800
Message-Id: <20200106160456.45689-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

For now most of the obvious bcache deadlock/race/panic bugs are fixed,
bcache may survive under heavy I/O loads for 12+ hours on my testing
machine (Lenovo SR650 with 96G memory, 16T NVMe ssd and 24x2 CPU cores).

Now new problem shows up. After running for such long time, the bcache
in-memory btree node cache occupies too many system memory (more than
32GB anonymous memory) and finally makes the whole system hang or panic.

On small or slow machine, it won't happen. But on fast and powerful
machine, when new I/O requests coming too fast, the new allocated in-
memory btree node cache is allocating faster than it is shrinking. After
continously running for 12+ hours for such high I/O loads, finally the
btree in-memory btree node cache eats up all system memory.

When such prolbem does not show up before Linux v5.3?
Because the bcache code could not survive for more than 40 minutes
before Linux v5.3 on my testing machine.

We need a method to limit memory consumption by the bcache in-memory
btree node cache. This patch set is an effort to limit the total size
of btree node cache memory and avoid further system hang or panic by
out of memory condition.

Any comments are welcome, and I am still testing the patches in the mean
time.

Thanks in advance.

Coly Li
---

Coly Li (7):
  bcache: remove member accessed from struct btree
  bcache: reap c->btree_cache_freeable from the tail in bch_mca_scan()
  bcache: reap from tail of c->btree_cache in bch_mca_scan()
  bcache: add __bch_mca_scan() with parameter "bool reap_flush"
  bcache: limit bcache btree node cache memory consumption by I/O
    throttle
  bcache: remove unnecessary mca_cannibalize()
  bcache: add cond_resched() in bch_btree_node_get() if mca_alloc()
    fails

 drivers/md/bcache/bcache.h |   3 ++
 drivers/md/bcache/btree.c  | 127 +++++++++++++++++++++++++++++----------------
 drivers/md/bcache/btree.h  |   5 +-
 drivers/md/bcache/super.c  |   3 ++
 4 files changed, 91 insertions(+), 47 deletions(-)

-- 
2.16.4

