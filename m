Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621B8311BE1
	for <lists+linux-bcache@lfdr.de>; Sat,  6 Feb 2021 08:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbhBFHUv (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 6 Feb 2021 02:20:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:47896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhBFHUv (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 6 Feb 2021 02:20:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F1D29ACB0;
        Sat,  6 Feb 2021 07:20:08 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] bcache-tools: store meta data on NVDIMM 
Date:   Sat,  6 Feb 2021 15:19:59 +0800
Message-Id: <20210206072005.24811-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

This series is the first effort to support NVDIMM for bcache: store
journal meta data on nvdimm namespace.

With this series, a NVDIMM namespace can be formatted as a bcache
meta device with '-M' option. This meta device can be shared among
multiple cache sets.

Except for adding BCH_FEATURE_INCOMPAT_NVDIMM_META to incompatible
feature set, there is no on-disk layout change for supporting NVDIMM.

A new super block format struct bch_nvm_pages_sb is introduced for
the NVDIMM meta-data device, it might be changed time-to-time before
the EXPERIMENTAL removed from Linux kernel code.

This series is just enough to make things work, more changes will
follow up to make more improvement later.

Coly Li
---

Coly Li (6):
  bcache-tools: add initial data structures for nvm_pages
  bcache-tools: reduce parameters of write_sb()
  bcache-tools: add BCH_FEATURE_INCOMPAT_NVDIMM_META to incompatible
    feature set
  bcache-tools: move super block info display routines into show.c
  bcache-tools: write nvm namespace super block on nvdimm
  bcache-tools: support "bcache show -d" for nvdimm-meta device

 Makefile            |   2 +-
 bcache-super-show.c |  24 ----
 bcache.c            | 289 +--------------------------------------
 bcache.h            |   7 +-
 features.c          |   2 +
 lib.c               | 158 +++++++++++++++++++---
 lib.h               |  28 +++-
 make.c              | 244 +++++++++++++++++++++++++++++----
 nvm_pages.h         | 187 ++++++++++++++++++++++++++
 show.c              | 321 ++++++++++++++++++++++++++++++++++++++++++++
 show.h              |  10 ++
 11 files changed, 917 insertions(+), 355 deletions(-)
 create mode 100644 nvm_pages.h
 create mode 100644 show.c
 create mode 100644 show.h

-- 
2.26.2

