Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B893214DE2
	for <lists+linux-bcache@lfdr.de>; Sun,  5 Jul 2020 18:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgGEQEr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Jul 2020 12:04:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:39480 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbgGEQEr (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Jul 2020 12:04:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 76ED5ACFE;
        Sun,  5 Jul 2020 16:04:46 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH 0/4] bcache-tools: changes for large bucket size 
Date:   Mon,  6 Jul 2020 00:04:36 +0800
Message-Id: <20200705160440.5801-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

These are user space tools changes necessary for bcache large bucket
size. When setting bucket size with '-u' larger than 16MB for cache
device, BCACHE_SB_VERSION_CDEV_WITH_FEATURES will be set automatically.
Otherwise, the new added members in super block won't be touched.

Coly Li
---
Coly Li (4):
  bcache-tools: comments offset for members of struct cache_sb
  struct_offset: print offset of each member of the on-disk data
    structure
  bcache-tools: The new super block version
    BCACHE_SB_VERSION_BDEV_WITH_FEATURES
  bcache-tools: add large_bucket incompat feature

 Makefile        |   6 +-
 bcache.h        | 153 ++++++++++++++++++++++++++++++++++++++----------
 features.c      |  24 ++++++++
 lib.c           |  24 ++++++++
 lib.h           |   2 +
 make.c          |  36 ++++++++----
 struct_offset.c |  63 ++++++++++++++++++++
 7 files changed, 265 insertions(+), 43 deletions(-)
 create mode 100644 features.c
 create mode 100644 struct_offset.c

-- 
2.26.2

