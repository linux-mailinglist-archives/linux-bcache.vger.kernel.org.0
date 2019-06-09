Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BAF3AC4E
	for <lists+linux-bcache@lfdr.de>; Mon, 10 Jun 2019 00:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbfFIWO5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 9 Jun 2019 18:14:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:36546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbfFIWO5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 9 Jun 2019 18:14:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6758BAD4A;
        Sun,  9 Jun 2019 22:14:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        rolf@rolffokkens.nl, pierre.juhen@orange.fr,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache: two emergent fixes for Linux v5.2-rc5 
Date:   Mon, 10 Jun 2019 06:13:33 +0800
Message-Id: <20190609221335.24616-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are two emergent fixes that we should have in Linux v5.2-rc5.

- bcache: fix stack corruption by PRECEDING_KEY()
  This patch fixes a GCC9 compiled bcache panic problem, which is
  reported by Fedora Core, Arch Linux and SUSE Leap Linux users whose
  kernels are combiled with GCC9. This bug hides for long time since
  v4.13 and triggered by the new GCC9.
  When people upgrade their kernel to a GCC9 compiled kernel, this
  bug may cause the metadata corruption. So we should have this fix
  in upstream ASAP.

- bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached
  There are 2 users report bcache panic after changing writeback
  percentage of an non-attached bcache device. Therefore I suggest
  to have this fix upstream in this run.

Thank you in advance for taking care of these two fixes.

Coly Li
---
Coly Li (2):
  bcache: fix stack corruption by PRECEDING_KEY()
  bcache: only set BCACHE_DEV_WB_RUNNING when cached device attached

 drivers/md/bcache/bset.c  | 16 +++++++++++++---
 drivers/md/bcache/bset.h  | 34 ++++++++++++++++++++--------------
 drivers/md/bcache/sysfs.c |  7 ++++++-
 3 files changed, 39 insertions(+), 18 deletions(-)

-- 
2.16.4

