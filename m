Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3F81F89B4
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Jun 2020 18:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgFNQxl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 14 Jun 2020 12:53:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:46904 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgFNQxl (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 14 Jun 2020 12:53:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D4B1FAD88;
        Sun, 14 Jun 2020 16:53:43 +0000 (UTC)
From:   colyli@suse.de
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/4] bcache: more fixes for v5.8-rc1
Date:   Mon, 15 Jun 2020 00:53:29 +0800
Message-Id: <20200614165333.124999-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

Hi Jens,

Here are more following up fixes for bcache v5.8-rc1.

The two patches from me are minor clean up. Rested two patches
are important.

- Mauricio Faria de Oliveira contributes a fix for a potential
  kernel panic when users configures improper block size value
  to bcache backing device. This problem should be fixed as soon
  as possible IMHO.
- Zhiqiang Liu contributes a fix for a potential deadlock (even quite
  hard to trigger), which I want to have it as soon as possible.

Please take these patches for v5.8-rc1, or -rc2 if it is late for -rc1.

Thanks you in advance.

Coly Li
---

Coly Li (2):
  bcache: use delayed kworker fo asynchronous devices registration
  bcache: pr_info() format clean up in bcache_device_init()

Mauricio Faria de Oliveira (1):
  bcache: check and adjust logical block size for backing devices

Zhiqiang Liu (1):
  bcache: fix potential deadlock problem in btree_gc_coalesce

 drivers/md/bcache/btree.c |  8 ++++++--
 drivers/md/bcache/super.c | 35 ++++++++++++++++++++++++++---------
 2 files changed, 32 insertions(+), 11 deletions(-)

-- 
2.25.0

