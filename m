Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4691C3A769E
	for <lists+linux-bcache@lfdr.de>; Tue, 15 Jun 2021 07:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhFOFvk (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 15 Jun 2021 01:51:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57260 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFOFvf (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 15 Jun 2021 01:51:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4ED7C2199E;
        Tue, 15 Jun 2021 05:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623736170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BXCyu2euPTfpv7PpxCFAmxZIxIC3RUGtfRe2pjjCvc8=;
        b=uJiEIjxOyXDJJH4JWU08tn8pGkPOaIOPJCEO58ETX+P+bYJQbqlca9v/18DsZMcIFS4E7u
        3QB/PTyXni8c66uRK6GxxGtaFuifNdlA5Sh5TFhROyhLn+JWPozNL7vAi1+ib6AGQmm95S
        JwKcqUkoOXa9L9s+5JCZ5Rk8lX1vDi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623736170;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=BXCyu2euPTfpv7PpxCFAmxZIxIC3RUGtfRe2pjjCvc8=;
        b=037nPfkE5lwLlrhdO+lZ4altLBshEPtByHkNIk+L4Eh8KM1CwFTxwjvPEpaDR2mywBtQfb
        FWT7fsCUOwl9wbAQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id EBFD7A3B98;
        Tue, 15 Jun 2021 05:49:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 00/14] bcache patches for Linux v5.14
Date:   Tue, 15 Jun 2021 13:49:07 +0800
Message-Id: <20210615054921.101421-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Here are the bcache patches for Linux v5.14.

The patches from Chao Yu and Ding Senjie are useful code cleanup. The
rested patches for the NVDIMM support to bcache journaling.

For the series to support NVDIMM to bache journaling, all reported
issue since last merge window are all fixed. And no more issue detected
during our testing or by the kernel test robot. If there is any issue
reported during they stay in linux-next, I, Jianpang and Qiaowei will
response and fix immediately.

Please take them for Linux v5.14.

Thank you in advance.

Coly Li
---

Chao Yu (1):
  bcache: fix error info in register_bcache()

Coly Li (7):
  bcache: add initial data structures for nvm pages
  bcache: use bucket index to set GC_MARK_METADATA for journal buckets
    in bch_btree_gc_finish()
  bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
  bcache: initialize bcache journal for NVDIMM meta device
  bcache: support storing bcache journal into NVDIMM meta device
  bcache: read jset from NVDIMM pages for journal replay
  bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
    meta device

Ding Senjie (1):
  md: bcache: Fix spelling of 'acquire'

Jianpeng Ma (5):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner

 drivers/md/bcache/Kconfig       |  10 +
 drivers/md/bcache/Makefile      |   1 +
 drivers/md/bcache/btree.c       |   6 +-
 drivers/md/bcache/features.h    |   9 +
 drivers/md/bcache/journal.c     | 317 ++++++++++---
 drivers/md/bcache/journal.h     |   2 +-
 drivers/md/bcache/nvm-pages.c   | 773 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  93 ++++
 drivers/md/bcache/super.c       |  91 +++-
 include/uapi/linux/bcache-nvm.h | 206 +++++++++
 10 files changed, 1432 insertions(+), 76 deletions(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.26.2

