Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE22E8696
	for <lists+linux-bcache@lfdr.de>; Sat,  2 Jan 2021 08:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbhABHNK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 2 Jan 2021 02:13:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:47580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhABHNK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 2 Jan 2021 02:13:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5567DAD29;
        Sat,  2 Jan 2021 07:12:28 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/4] bcache: improve large bucket size on-disk layout 
Date:   Sat,  2 Jan 2021 15:12:19 +0800
Message-Id: <20210102071223.58303-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Current large bucket (size >16MB) layout is a preparation for the future
zoned cache device, by which the cache device bucket can be aligned to
zone size and boundary of the zoned SSD.

Commit ffa470327572 ("bcache: add bucket_size_hi into struct
cache_sb_disk for large bucket") extends bucket size from 16MB to 1TB,
but this change is problematic and can be improved,
- The bucket size is always power-of-2 value, it is unnecessary to add
  extra member in struct cache_sb_disk to store the real size value.
  Just using existing bucket_size to store the order of power-of-2 value
  is enough.
- The added bucket_size_hi is behind d[SB_JOURNAL_BUCKETS] in struct
  cache_sb_disk, which breaks a very implicit restriction from macro
  csum_set(). This restriction requires member d[] must be the last
  member in data structure to calculate the checksum.

This series is to improve the above issue from bcache kernel code. The
basic ideas of this series are,
- Add BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE incompat feature bit.
  When it is set, for bucket size >16MB, bucket_size stores the order
  of power-of-2 bucket size value. Then no extra space introduced and
  csum_set() has all data to calculate super block checksum.
- Rename struct cache_sb_disk's bucket_size_hi to obso_bucket_size_hi,
  and rename the incompat feature bit BCH_FEATURE_INCOMPAT_LARGE_BUCKET
  to BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET, to indicate they are not
  used anymore and obsoleted.
- If a cache device was created for bucket size >16MB with obsoleted
  layout, bcache driver will print error message for the obsoleted
  layout and all following attached bcache device will be read-only. If
  there is dirty data on cache device, after the writeback accomplished
  the cache device can be re-created with new bucket_size usage by the
  latest bcache-tools.

Because the btree node usage is not optimized, I doubt there is people
really uses bucket size >16MB at this moment, except me. But this is
something needs to be improved and better as soon as possible.

Coly Li
---
Coly Li (4):
  bcache: fix typo from SUUP to SUPP in features.h
  bcache: check unsupported feature sets for bcache register
  bcache: introduce BCH_FEATURE_INCOMPAT_LOG_LARGE_BUCKET_SIZE for large
    bucket
  bcache: set bcache device into read-only mode for
    BCH_FEATURE_INCOMPAT_OBSO_LARGE_BUCKET

 drivers/md/bcache/features.c |  2 +-
 drivers/md/bcache/features.h | 30 +++++++++++++++++----
 drivers/md/bcache/super.c    | 51 +++++++++++++++++++++++++++++++++---
 include/uapi/linux/bcache.h  |  2 +-
 4 files changed, 75 insertions(+), 10 deletions(-)

-- 
2.26.2

