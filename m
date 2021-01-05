Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D7B2EA586
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Jan 2021 07:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbhAEGnI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 5 Jan 2021 01:43:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:20313 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbhAEGnI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 5 Jan 2021 01:43:08 -0500
IronPort-SDR: 3paDZJdrn3TLHLAmLjzdCOPb9YIDyJQTFxIPhEkjafyNti3gNCFAwJE8PpBmdJJYRJxnSEfmCZ
 P4my09LDapVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="177161875"
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="177161875"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 22:42:27 -0800
IronPort-SDR: epAXaci95le6RwW99XgBaoqH+7eFTyI0fcsv8AAavzZx7oYmj5PI+dZx8m+NZplhhqSOOziFb+
 prGlneCCDRwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,476,1599548400"; 
   d="scan'208";a="350250046"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga008.fm.intel.com with ESMTP; 04 Jan 2021 22:42:26 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Jianpeng Ma <jianpeng.ma@intel.com>, linux-bcache@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC V3 PATCH 0/8] nvm page allocator for bcache 
Date:   Tue,  5 Jan 2021 09:22:10 -0500
Message-Id: <20210105142218.56508-1-qiaowei.ren@intel.com>
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
 drivers/md/bcache/nvm-pages.c   | 818 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 109 +++++
 drivers/md/bcache/super.c       |   3 +
 drivers/md/bcache/test-nvm.c    | 117 +++++
 include/uapi/linux/bcache-nvm.h | 191 ++++++++
 7 files changed, 1253 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 drivers/md/bcache/test-nvm.c
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.17.1

