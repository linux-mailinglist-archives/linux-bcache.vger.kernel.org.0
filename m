Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93ACF15C020
	for <lists+linux-bcache@lfdr.de>; Thu, 13 Feb 2020 15:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730207AbgBMOMS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 13 Feb 2020 09:12:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:50248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgBMOMS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 13 Feb 2020 09:12:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38057AE34;
        Thu, 13 Feb 2020 14:12:17 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache patches for Linux v5.6-rc2 
Date:   Thu, 13 Feb 2020 22:12:04 +0800
Message-Id: <20200213141207.77219-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are 3 minor fixes Linux v5.6-rc2. The first 2 patches fix
kthread creating failure during bcache cache set starts up. The
last patch is a code clean up.

Please take them. Thanks in advance.

Coly Li
---
Coly Li (3):
  bcache: ignore pending signals when creating gc and allocator thread
  bcache: Revert "bcache: shrink btree node cache after
    bch_btree_check()"
  bcache: remove macro nr_to_fifo_front()

 drivers/md/bcache/alloc.c   | 18 ++++++++++++++++--
 drivers/md/bcache/btree.c   | 13 +++++++++++++
 drivers/md/bcache/journal.c |  7 ++-----
 drivers/md/bcache/super.c   | 17 -----------------
 4 files changed, 31 insertions(+), 24 deletions(-)

-- 
2.16.4

