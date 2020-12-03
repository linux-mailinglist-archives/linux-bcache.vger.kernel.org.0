Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED342CCD0E
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 04:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLCDK5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 22:10:57 -0500
Received: from mga07.intel.com ([134.134.136.100]:1942 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgLCDK5 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 22:10:57 -0500
IronPort-SDR: U2quzabCimLUdqD2nmB5/JjQFQzocuRWS4qf5dwWgQ7E+/dSDJYWC2L5zo3Bb7KGW1wac1R+Qy
 MqlSN72XTZHw==
X-IronPort-AV: E=McAfee;i="6000,8403,9823"; a="237248528"
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="237248528"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2020 19:10:16 -0800
IronPort-SDR: 2WH1C3faGE3ZdbXNeepgEud/o7e7AyEJrSZF1DHTvXc1+BJEYO9pOV8RiK6hMc4DhsYR9k+9l/
 +ETZyYqSz+/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,388,1599548400"; 
   d="scan'208";a="481801482"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga004.jf.intel.com with ESMTP; 02 Dec 2020 19:10:15 -0800
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [RFC PATCH 0/8] nvm page allocator for bcache 
Date:   Thu,  3 Dec 2020 05:53:29 -0500
Message-Id: <20201203105337.4592-1-qiaowei.ren@intel.com>
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
  bcache: nvm_alloc_pages() of the buddy
  bcache: nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner
  bcache: persist owner info when alloc/free pages.
  bcache: testing module for nvm pages allocator

 drivers/md/bcache/Kconfig       |  12 +
 drivers/md/bcache/Makefile      |   4 +-
 drivers/md/bcache/nvm-pages.c   | 769 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   | 107 +++++
 drivers/md/bcache/super.c       |   3 +
 drivers/md/bcache/test-nvm.c    | 117 +++++
 include/uapi/linux/bcache-nvm.h | 184 ++++++++
 7 files changed, 1195 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 drivers/md/bcache/test-nvm.c
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.17.1

