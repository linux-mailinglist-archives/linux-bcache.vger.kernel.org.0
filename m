Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2971D6187
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 16:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgEPOKT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 16 May 2020 10:10:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:47068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgEPOKT (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 16 May 2020 10:10:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9D1CAACB1;
        Sat, 16 May 2020 14:10:20 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache-tools: suport zoned device as making backing evice
Date:   Sat, 16 May 2020 22:09:37 +0800
Message-Id: <20200516140940.101190-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

This series is for bcache-tools to support making zoned device as
bcache backing device.

There are two major ideas to support zoned device as bcache backing
device,
- The super block data_offset should be aligned to zone size. By default
  the data_offset is set to 1 zone size for zoned backing device.
- Writeback mode is not supported yet. If the cache mode is explicitly
  set to writeback, print message to terminal to inform users that the
  cache mode is converted to wrightthough.

After the data_offset and cache mode is set properly, the rested stuffs
for zoned device support are from bcache driver in Linux kernel.

Thanks for your review in advance.

Coly Li
---

Coly Li (3):
  bcache-tools: set zoned size aligned data_offset on backing device for
    zoned devive
  bcache-tools: add is_zoned_device()
  bcache-tools: convert writeback to writethrough mode for zoned backing
    device

 Makefile |  4 +--
 make.c   | 20 +++++++++++-
 zoned.c  | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 zoned.h  | 14 +++++++++
 4 files changed, 129 insertions(+), 3 deletions(-)
 create mode 100644 zoned.c
 create mode 100644 zoned.h

-- 
2.25.0

