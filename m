Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 124DC175731
	for <lists+linux-bcache@lfdr.de>; Mon,  2 Mar 2020 10:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgCBJe5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 04:34:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:35654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgCBJe5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 04:34:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C2B58AC7C;
        Mon,  2 Mar 2020 09:34:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        hare@suse.de, mhocko@suse.com, mkoutny@suse.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache patches for Linux v5.6-rc5 
Date:   Mon,  2 Mar 2020 17:34:48 +0800
Message-Id: <20200302093450.48016-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are two more simple fixes for Linux v5.6-rc5.
- The first one fixes the backing device registration failure if the
  regiserting process is timeout and killed by udevd.
- The second patch changes code comments for previous patch which
  ignores pending signal. The reason of receiving signal is not from
  OOM, it is from udevd for timeout.

Calling flush_signals() is a workaround before I find a method to
make kthread_run() and kthread_create() handling signal correctly.

Please take these patches and thank you in advance.

Coly Li
---
Coly Li (2):
  bcache: ignore pending signals in bcache_device_init()
  bcache: fix code comments for ignore pending signals

 drivers/md/bcache/alloc.c | 14 +++++++-------
 drivers/md/bcache/btree.c | 14 +++++++-------
 drivers/md/bcache/super.c | 12 ++++++++++++
 3 files changed, 26 insertions(+), 14 deletions(-)

-- 
2.16.4

