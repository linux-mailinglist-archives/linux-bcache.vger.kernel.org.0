Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805C31D5E4A
	for <lists+linux-bcache@lfdr.de>; Sat, 16 May 2020 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgEPDyz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 15 May 2020 23:54:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:40668 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgEPDyz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 15 May 2020 23:54:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3032CAC91;
        Sat, 16 May 2020 03:54:56 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, damien.lemoal@wdc.com, hare@suse.com,
        hch@lst.de, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, kbusch@kernel.org,
        Coly Li <colyli@suse.de>
Subject: [RFC PATCH v2 0/4] block layer change necessary for bcache zoned device support
Date:   Sat, 16 May 2020 11:54:30 +0800
Message-Id: <20200516035434.82809-1-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi folks,

Recently I am working on supprt bcache to be created on zoned devices
e.g. host managed SMR hard drives, then frequent random READ I/Os on
these SMR drives can be accelerated.

To make the bcache code work correctly, there are some small but maybe
important changes of block layer code are necessary.

Thanks for the review comments from Keith Busch, I fix the typo and post
the v2 series for your review and comments.

Thank you all in advance.

Coly Li 
---

Coly Li (4):
  block: change REQ_OP_ZONE_RESET from 6 to 13
  block: block: change REQ_OP_ZONE_RESET_ALL from 8 to 15
  block: remove queue_is_mq restriction from blk_revalidate_disk_zones()
  block: set bi_size to REQ_OP_ZONE_RESET bio

 block/blk-zoned.c         | 6 ++++--
 include/linux/blk_types.h | 8 ++++----
 2 files changed, 8 insertions(+), 6 deletions(-)

-- 
2.25.0

