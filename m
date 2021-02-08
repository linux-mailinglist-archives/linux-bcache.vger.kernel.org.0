Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39622312ADD
	for <lists+linux-bcache@lfdr.de>; Mon,  8 Feb 2021 07:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBHGp7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 8 Feb 2021 01:45:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:44129 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229822AbhBHGp7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 8 Feb 2021 01:45:59 -0500
IronPort-SDR: t/nkE9zhQh0tPgcP1QzsD4JvI+SDkousqYP9y8tUMRIAe9NliLVV8eqCobW0QshbTN3F7g9zi3
 73g04ZWqYBRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="245738701"
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="245738701"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2021 22:45:17 -0800
IronPort-SDR: 6JPJCZJdCnsGQGfmM/uec8JnGwoQNDqThd7spSJg55bc5/INpm501wmaxmAoTMME0srdrz8tiL
 2CkKRnLtF6Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208";a="418127505"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Feb 2021 22:45:16 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [RFC PATCH v6 0/7]  nvm page allocator for bcache 
Date:   Mon,  8 Feb 2021 09:26:14 -0500
Message-Id: <20210208142621.76815-1-qiaowei.ren@intel.com>
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

Qiaowei Ren (7):
  bcache: add initial data structures for nvm pages
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner
  bcache: persist owner info when alloc/free pages.

 drivers/md/bcache/Kconfig       |   6 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/nvm-pages.c   | 853 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 112 +++++
 drivers/md/bcache/super.c       |   3 +
 include/uapi/linux/bcache-nvm.h | 188 +++++++
 6 files changed, 1163 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.17.1

