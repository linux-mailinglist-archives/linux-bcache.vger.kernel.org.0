Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C590A35D7FD
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Apr 2021 08:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhDMG1Z (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 13 Apr 2021 02:27:25 -0400
Received: from mga18.intel.com ([134.134.136.126]:18128 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229493AbhDMG1X (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 13 Apr 2021 02:27:23 -0400
IronPort-SDR: Zzv64rQfsnGN6+NpafplzLzSHZNq72oUtal3c7XXHDw7RNDHU8m2+YwesHN/TejIDd4it8KtOx
 O0nUq++SOXBA==
X-IronPort-AV: E=McAfee;i="6200,9189,9952"; a="181869327"
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="181869327"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2021 23:27:02 -0700
IronPort-SDR: kLjiydfTR8WMnLAhhlj3sR/TbhlfC94YkxaB/XADGr+swvq06T0xincFfq529IjKvSQ+yS88jE
 frvADY7aRxIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,218,1613462400"; 
   d="scan'208";a="460470355"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2021 23:27:01 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [bch-nvm-pages v8 0/6] nvm page allocator for bcache 
Date:   Tue, 13 Apr 2021 10:05:43 -0400
Message-Id: <20210413140549.224482-1-qiaowei.ren@intel.com>
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
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner

 drivers/md/bcache/Kconfig       |   9 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/nvm-pages.c   | 747 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  93 ++++
 drivers/md/bcache/super.c       |   3 +
 include/uapi/linux/bcache-nvm.h | 208 +++++++++
 6 files changed, 1061 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.25.1

