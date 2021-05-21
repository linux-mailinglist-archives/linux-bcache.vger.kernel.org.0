Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8002E38C095
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 09:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbhEUHVT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 03:21:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:16559 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEUHVT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 03:21:19 -0400
IronPort-SDR: sCl5sk3C/G9i2gSEuwPRcWeK3geF0zfFsbDFpz5KTpdBXzr1B/t3IzUCf88G5B/e0k+oxabbrf
 uRdWWOIugmvQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9990"; a="199484315"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="199484315"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2021 00:19:57 -0700
IronPort-SDR: Il70rbWmoc86LxiXWnjuJfrwvWx7o1LgvMkbiBgOzIuMHwmyOXl48vKtdLNjyXqXTb/xo5ivFT
 HQKdvCrGWxig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440817108"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga008.jf.intel.com with ESMTP; 21 May 2021 00:19:55 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     linux-bcache@vger.kernel.org
Cc:     qiaowei.ren@intel.com, jianpeng.ma@intel.com, colyli@suse.de,
        rdunlap@infradead.oom
Subject: [bch-nvm-pages v10 0/6] nvm page allocator for bcache 
Date:   Fri, 21 May 2021 10:57:20 -0400
Message-Id: <20210521145726.154276-1-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Jianpeng Ma <jianpeng.ma@intel.com>

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

Coly Li (1):
  bcache: add initial data structures for nvm pages

Jianpeng Ma (5):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  cache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner

 drivers/md/bcache/Kconfig       |   9 +
 drivers/md/bcache/Makefile      |   1 +
 drivers/md/bcache/nvm-pages.c   | 769 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  92 ++++
 drivers/md/bcache/super.c       |   3 +
 include/uapi/linux/bcache-nvm.h | 206 +++++++++
 6 files changed, 1080 insertions(+)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.25.1

