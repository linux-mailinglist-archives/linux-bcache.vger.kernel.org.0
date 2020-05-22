Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905671DE6A4
	for <lists+linux-bcache@lfdr.de>; Fri, 22 May 2020 14:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgEVMSt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 22 May 2020 08:18:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:52318 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgEVMSs (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 22 May 2020 08:18:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3B4CAF73;
        Fri, 22 May 2020 12:18:48 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [RFC PATCH v4 0/3] bcache: support zoned device as bcache backing device
Date:   Fri, 22 May 2020 20:18:34 +0800
Message-Id: <20200522121837.109651-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

This is series, now bcache can support zoned device (e.g. host managed
SMR hard drive) as the backing deice. Currently writeback mode is not
support yet, which is on the to-do list (requires on-disk super block
format change).

The first patch makes bcache to export the zoned information to upper
layer code, for example formatting zonefs on top of the bcache device.
By default, zone 0 of the zoned device is fully reserved for bcache
super block, therefore the reported zones number is 1 less than the
exact zones number of the physical SMR hard drive.

The second patch handles zone management command for bcache. Indeed
these zone management commands are wrappered as zone management bios.
For REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL zone management bios,
before forwarding the bio to backing device, all cached data covered
by the resetting zone(s) must be invalidated to keep data consistency.
For rested zone management bios just minus the bi_sector by data_offset
and simply forward to the zoned backing device.

The third patch is to make sure after bcache device starts, the cache
mode cannot be changed to writeback via sysfs interface. Bcache-tools
is modified to notice users and convert to writeback mode to the default
writethrough mode when making a bcache device.

There is one thing not addressed by this series, that is re-write the
bcache super block after REQ_OP_ZONE_RESET_ALL command. There will be
quite soon that all seq zones device may appear, but it is OK to make
bcache support such all seq-zones device a bit later.

Now a bcache device created with a zoned SMR drive can pass these test
cases,
- read /sys/block/bcache0/queue/zoned, content is 'host-managed'
- read /sys/block/bcache0/queue/nr_zones, content is number of zones
  excluding zone 0 of the backing device (reserved for bcache super
  block).
- read /sys/block/bcache0/queue/chunk_sectors, content is zone size
  in sectors.
- run 'blkzone report /dev/bcache0', all zones information displayed.
- run 'blkzone reset -o <zone LBA> -c <zones number> /dev/bcache0',
  conventional zones will reject the command, seqential zones covered
  by the command range will reset its write pointer to start LBA of
  their zones. If <zone LBA> is 0 and <zones number> covers all zones,
  REQ_OP_ZONE_RESET_ALL command will be received and handled by bcache
  device properly.
- zonefs can be created on top of the bcache device, with/without cache
  device attached. All sequential direct write and random read work well
  and zone reset by 'truncate -s 0 <zone file>' works too.
- Writeback cache mode does not support yet.

Now all prevous code review comments are addressed by this RFC version.
Please don't hesitate to offer your opinion on this version.

Thanks in advance for your help.

Coly Li
---
Changelog:
v4: another improved version without any other generic block change.
v3: an improved version depends on other generic block layer changes.
v2: the first RFC version for comments and review.
v1: the initial version posted just for information.


Coly Li (3):
  bcache: export bcache zone information for zoned backing device
  bcache: handle zone management bios for bcache device
  bcache: reject writeback cache mode for zoned backing device

 drivers/md/bcache/bcache.h  |  10 +++
 drivers/md/bcache/request.c | 168 +++++++++++++++++++++++++++++++++++-
 drivers/md/bcache/super.c   |  98 ++++++++++++++++++++-
 drivers/md/bcache/sysfs.c   |   5 ++
 4 files changed, 279 insertions(+), 2 deletions(-)

-- 
2.25.0

