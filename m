Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6A7312545
	for <lists+linux-bcache@lfdr.de>; Sun,  7 Feb 2021 16:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBGP10 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 7 Feb 2021 10:27:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:35742 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhBGPZT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 7 Feb 2021 10:25:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C443AACB7;
        Sun,  7 Feb 2021 15:24:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, jianpeng.ma@intel.com,
        qiaowei.ren@intel.com, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] bcache: store bcache journal on NVDIMM pages
Date:   Sun,  7 Feb 2021 23:24:17 +0800
Message-Id: <20210207152423.70697-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

This is the first effort to store bcache meta data on NVDIMM, now the
bcache journal can be stored on NVDIMM pages. 

The bcache code does not directly support NVDIMM, the NVDIMM pages are
managed with a simple buddy-like pages alocator nvm-pages. The nvm-pages
allocator is developed by Jianpeng Ma and Qiaowei Ren from Intel. It
could be a separated kernel module to manage NVDIMM space in form of
pages and share them among multiple users (drivers). Now nvm-pages is
directly included in bcache kernel module as EXPERIMENTAL function.

This series is a just-enough code to work, we will continue to improve
both bcache and nvm-pages allocator before removing the EXPERIMENTAL tag
from Kconfig. In the very basic testing 30%+ IOPS increasing is observed
for 512Byte random writes when storing bcache journal jset on NVDIMM
namespace.

Thanks to Jianpeng Ma and Qiaowei Re fo their contribution to the mini
nvm-pages allocator, which helps a lot to allocate and release the pages
from NVDIMM nagespace much simpler for bcache journaling.

Coly Li
---

Coly Li (6):
  bcache: use bucket index for SET_GC_MARK() in bch_btree_gc_finish()
  bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
  bcache: initialize bcache journal for NVDIMM meta device
  bcache: support storing bcache journal into NVDIMM meta device
  bache: read jset from NVDIMM pages for journal replay
  bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
    meta device

 drivers/md/bcache/btree.c    |   6 +-
 drivers/md/bcache/features.h |   9 ++
 drivers/md/bcache/journal.c  | 288 +++++++++++++++++++++++++++--------
 drivers/md/bcache/journal.h  |   2 +-
 drivers/md/bcache/super.c    |  38 ++++-
 5 files changed, 274 insertions(+), 69 deletions(-)

-- 
2.26.2

