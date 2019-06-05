Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88653357A7
	for <lists+linux-bcache@lfdr.de>; Wed,  5 Jun 2019 09:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFEH1Z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 5 Jun 2019 03:27:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:41126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726477AbfFEH1Z (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 5 Jun 2019 03:27:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C826CAE08;
        Wed,  5 Jun 2019 07:27:23 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] fix for a race in btree_flush_write()
Date:   Wed,  5 Jun 2019 15:27:12 +0800
Message-Id: <20190605072718.121379-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

There is a race happens in btree_flush_write() which may cause
system hang or panic. This patch set is an effor to fix such race,
and it is also necessary for the jouranl-no-space deadlock fixes. 

Any review or comments is welcome.

Thanks in advance.

Coly Li
---

Coly Li (6):
  bcache: Revert "bcache: fix high CPU occupancy during journal"
  bcache: Revert "bcache: free heap cache_set->flush_btree in
    bch_journal_free"
  bcache: set largest seq to ja->seq[bucket_index] in
    journal_read_bucket()
  bcache: remove retry_flush_write from struct cache_set
  bcache: fix race in btree_flush_write()
  bcache: add reclaimed_journal_buckets to struct cache_set

 drivers/md/bcache/bcache.h  |   4 +-
 drivers/md/bcache/btree.c   |  15 +++++-
 drivers/md/bcache/btree.h   |   2 +
 drivers/md/bcache/journal.c | 111 ++++++++++++++++++++++++++++----------------
 drivers/md/bcache/journal.h |   4 ++
 drivers/md/bcache/sysfs.c   |  10 ++--
 drivers/md/bcache/util.h    |   2 -
 7 files changed, 97 insertions(+), 51 deletions(-)

-- 
2.16.4

