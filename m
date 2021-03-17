Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5713B33EA91
	for <lists+linux-bcache@lfdr.de>; Wed, 17 Mar 2021 08:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhCQHbO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 Mar 2021 03:31:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:61940 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229508AbhCQHas (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 Mar 2021 03:30:48 -0400
IronPort-SDR: gKQHMT4e1+3UbGwzSn2Jx3YTqgHCHFcILbDkPc7BuK2rQ8aNd9eX/IXVAax4YnvKEW/xRrt84+
 0fOwuPttvWMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9925"; a="189500587"
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="189500587"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2021 00:30:43 -0700
IronPort-SDR: ga+YfKLhIVPIr5FhGDjJaDwsC+pJ9BGRgueapjYJfPbw65eS1CKReMfNVoAKAeDOV+qBEX3fTk
 uLxS6heno06A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,255,1610438400"; 
   d="scan'208";a="602130258"
Received: from ceph.sh.intel.com ([10.239.241.176])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2021 00:30:42 -0700
From:   Qiaowei Ren <qiaowei.ren@intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        linux-bcache@vger.kernel.org
Subject: [bch-nvm-pages v7 0/6] nvm page allocator for bcache 
Date:   Wed, 17 Mar 2021 11:10:23 -0400
Message-Id: <20210317151029.40735-1-qiaowei.ren@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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


Coly Li (1):
  bcache: add initial data structures for nvm pages

Jianpeng Ma (5):
  bcache: initialize the nvm pages allocator
  bcache: initialization of the buddy
  bcache: bch_nvm_alloc_pages() of the buddy
  bcache: bch_nvm_free_pages() of the buddy
  bcache: get allocated pages from specific owner

 drivers/md/bcache/Kconfig       |   6 +
 drivers/md/bcache/Makefile      |   2 +-
 drivers/md/bcache/nvm-pages.c   | 737 ++++++++++++++++++++++++++++++++
 drivers/md/bcache/nvm-pages.h   |  91 ++++
 drivers/md/bcache/super.c       |   3 +
 include/uapi/linux/bcache-nvm.h | 196 +++++++++
 6 files changed, 1034 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/bcache/nvm-pages.c
 create mode 100644 drivers/md/bcache/nvm-pages.h
 create mode 100644 include/uapi/linux/bcache-nvm.h

-- 
2.25.1

