Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A042E86A4
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbhABHNx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:47724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhABHNw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E1F6AAD6A;
        Sat,  2 Jan 2021 07:12:49 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/6] bcache-tools: improve large bucket on-disk layout
Date:   Sat,  2 Jan 2021 15:12:38 +0800
Message-Id: <20210102071244.58353-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Current large bucket layout is a preparation for the future zoned cache
device, by which the cache device bucket can be aligned to zone size and
boundary of the zoned SSD.

Original patch introduces bucket_size_hi in struct cache_sb_disk, this
is problematic and can be improved,
- The bucket size is always power-of-2 value, it is unnecessary to add
  extra space in struct cache_sb_disk to store the real size value. Just
  using existing bucket_size to store the order of power-of-2 value is
  enough.
- The added bucket_size_hi is behind d[SB_JOURNAL_BUCKETS] in struct
  cache_sb_disk, which breaks a very implicit restriction from macro
  csum_set(). This restriction requires member d[] must be the last
  member in data structure to calculate the checksum.

This series is to improve the above issue from user space tools. Basic
ideas of this series are,
- Add BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE incompat feature bit.
  When it is set, for bucket size >16MB, bucket_size stores the order
  of power-of-2 bucket size value. Then no extra space introduced and
  csum_set() has all data to calculate super block checksum.
- Rename struct cache_sb_disk's bucket_size_hi to obso_bucket_size_hi,
  and rename the incompat feature bit BCH_FEATURE_INCOMPAT_LARGE_BUCKET
  to BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET, to indicate they are not
  used anymore and obsoleted.
- If a cache device was created for bucket size >16MB with obsoleted
  layout, "bcache show" command still display the expected bucket size
  value for legacy compatibility purpose.

Although there almost no one else uses bucket size >16MB except me (the
btree node usage code is not optimized yet), it is still necessary to
fix and improve the layout usage as soon as possible.

Coly Li
---
Coly Li (6):
  bcache.h: fix typo from SUUP to SUPP
  bcache-tools: only call set_bucket_size() for cache device
  bcache.h: add BCH_FEATURE_INCOMPAT_LARGE_BUCKET to
    BCH_FEATURE_INCOMPAT_SUPP
  bcache-tools: check incompatible feature set
  bcache-tools: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for
    large bucket
  bcache-tools: display obsoleted bucket size configuration

 bcache.h   | 17 +++++++++++------
 features.c |  4 +++-
 lib.c      | 52 ++++++++++++++++++++++++++++++++++++++++++++++++----
 lib.h      |  2 +-
 make.c     |  3 ++-
 5 files changed, 65 insertions(+), 13 deletions(-)

-- 
2.26.2

