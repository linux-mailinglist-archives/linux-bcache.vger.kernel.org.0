Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6EA69C4
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Sep 2019 15:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbfICNZx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Sep 2019 09:25:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:34372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729117AbfICNZx (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Sep 2019 09:25:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 39BE5AF38;
        Tue,  3 Sep 2019 13:25:52 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache patches for Linux v5.4
Date:   Tue,  3 Sep 2019 21:25:42 +0800
Message-Id: <20190903132545.30059-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Most of bcache development is still in progress now, for Linux v5.3
we only have 3 patches to merge. Please take them.

Thanks in advance.

Coly Li
---

Dan Carpenter (1):
  bcache: Fix an error code in bch_dump_read()

Kent Overstreet (1):
  closures: fix a race on wakeup from closure_sync

Shile Zhang (1):
  bcache: add cond_resched() in __bch_cache_cmp()

 drivers/md/bcache/closure.c | 10 ++++++++--
 drivers/md/bcache/debug.c   |  5 ++---
 drivers/md/bcache/sysfs.c   |  1 +
 3 files changed, 11 insertions(+), 5 deletions(-)

-- 
2.16.4

