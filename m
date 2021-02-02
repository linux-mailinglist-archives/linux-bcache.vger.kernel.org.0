Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E715B30B568
	for <lists+linux-bcache@lfdr.de>; Tue,  2 Feb 2021 03:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhBBCnv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 1 Feb 2021 21:43:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhBBCnk (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 1 Feb 2021 21:43:40 -0500
IronPort-SDR: 7QpTZoJHaZc+ved1jNp7YMpLT5s+ZyIGjDeGkjBLaMMVHvT8gR40GIhsAmr5whyDSumzxvtu7c
 Ph27m/PuqBiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="167893391"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="167893391"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 18:42:57 -0800
IronPort-SDR: A3ByID1C0igb+p5LmW/00tETO7+LXfTCx0rfcUDSnbm26JbyFZee8G9BeGMNt/uVWnG9Jvdusl
 g8ltHotGK2aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="370226367"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 01 Feb 2021 18:42:56 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v5 0/8] nvm page allocator for bcache 
Date:   Tue,  2 Feb 2021 05:23:44 -0500
Message-Id: <20210202102352.4833-1-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This series implements nvm pages allocator for bcache. This idea is from
one discussion about nvdimm use case in kernel together with Coly. Coly
sent the following email about this idea to give some introduction on what
we will do before:

https://lore.kernel.org/linux-bcache/bc7e71ec-97eb-b226-d4fc-d8b64c1ef41a@suse.de/

Here this series focus on the first step in above email, that is to say,
this patch set implements a generic framework in bcache to allocate/release
NV-memory pages, and provide allocated pages for each requestor after reboot.
In order to do this, one simple buddy system is implemented to manage NV-memory
pages.

This set includes one testing module which can be used for simple test cases.
Next need to stroe bcache log or internal btree nodes into nvdimm based on
these buddy apis to do more testing.

Qiaowei Ren (8):
  bcache: add initial data structures for nvm pages
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner
  bcache: persist owner info when alloc/free pages.
  bcache: testing module for nvm pages allocator

 drivers/md/bcache/Kconfig       |  12 +
 drivers/md/bcache/Makefile      |   4 +-
 drivers/md/bcache/nvm-pages.c   | 914 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 111 ++++
 drivers/md/bcache/super.c       |   3 +
 drivers/md/bcache/test-nvm.c    | 202 +++++++
 include/uapi/linux/bcache-nvm.h | 188 +++++++
 7 files changed, 1433 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 drivers/md/bcache/test-nvm.c
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.17.1

