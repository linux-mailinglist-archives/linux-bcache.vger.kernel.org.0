Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFE818E701
	for <lists+linux-bcache@lfdr.de>; Sun, 22 Mar 2020 07:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCVGEf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 Mar 2020 02:04:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:48956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbgCVGEf (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 02:04:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6DE0CAB64;
        Sun, 22 Mar 2020 06:04:33 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/7] bcache patches for Linux v5.7-rc1
Date:   Sun, 22 Mar 2020 14:02:58 +0800
Message-Id: <20200322060305.70637-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

These are bcache patches for Linux v5.7-rc1.

The major change is to make bcache btree check and dirty secrtors
counting being multithreaded, then the registration time can be
much less. My first four patches are for this purpose.

Davidlohr Bueso contributes a patch to optimize barrier usage for
atomic operations. By his inspiration I also compose a patch for
the rested locations to change.

Takashi Iwai contributes a helpful patch to avoid potential
buffer overflow in bcache sysfs code path.

Please take them, and thank you in advance.

Coly Li
---

Coly Li (5):
  bcache: move macro btree() and btree_root() into btree.h
  bcache: add bcache_ prefix to btree_root() and btree() macros
  bcache: make bch_btree_check() to be multithreaded
  bcache: make bch_sectors_dirty_init() to be multithreaded
  bcache: optimize barrier usage for atomic operations

Davidlohr Bueso (1):
  bcache: optimize barrier usage for Rmw atomic bitops

Takashi Iwai (1):
  bcache: Use scnprintf() for avoiding potential buffer overflow

 drivers/md/bcache/btree.c     | 242 ++++++++++++++++++++++++----------
 drivers/md/bcache/btree.h     |  88 +++++++++++++
 drivers/md/bcache/sysfs.c     |   2 +-
 drivers/md/bcache/writeback.c | 164 ++++++++++++++++++++++-
 drivers/md/bcache/writeback.h |  19 +++
 5 files changed, 440 insertions(+), 75 deletions(-)

-- 
2.25.0

