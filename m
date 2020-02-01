Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AE314F816
	for <lists+linux-bcache@lfdr.de>; Sat,  1 Feb 2020 15:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBAOmr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 Feb 2020 09:42:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:59020 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgBAOmr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Feb 2020 09:42:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CCD47AAFD;
        Sat,  1 Feb 2020 14:42:45 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/5] bcache patches for Linux v5.6-rc1
Date:   Sat,  1 Feb 2020 22:42:30 +0800
Message-Id: <20200201144235.94110-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are the bcache patches for Linux v5.6-rc1. All the patches are
tested and survived my I/O pressure tests for 24+ hours intotal.

Please take them. Thank you in advance.

Coly Li
---

Coly Li (5):
  bcache: fix memory corruption in bch_cache_accounting_clear()
  bcache: explicity type cast in bset_bkey_last()
  bcache: add readahead cache policy options via sysfs interface
  bcache: fix incorrect data type usage in btree_flush_write()
  bcache: check return value of prio_read()

 drivers/md/bcache/bcache.h  |  3 +++
 drivers/md/bcache/bset.h    |  3 ++-
 drivers/md/bcache/journal.c |  3 ++-
 drivers/md/bcache/request.c | 17 ++++++++++++-----
 drivers/md/bcache/stats.c   | 10 +++++++---
 drivers/md/bcache/super.c   | 21 ++++++++++++++++-----
 drivers/md/bcache/sysfs.c   | 22 ++++++++++++++++++++++
 7 files changed, 64 insertions(+), 15 deletions(-)

-- 
2.16.4

