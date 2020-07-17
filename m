Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC90223139
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Jul 2020 04:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgGQCmt (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 16 Jul 2020 22:42:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:42802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgGQCmt (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 16 Jul 2020 22:42:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC51DB70A;
        Fri, 17 Jul 2020 02:42:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH v3 0/2] two generic block layer fixes for 5.9
Date:   Fri, 17 Jul 2020 10:42:28 +0800
Message-Id: <20200717024230.33116-1-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

These two patches are posted for a while, and have reviewed by several
other developers.

Comparing to previous version, now the discard bio alignment patch can
correctly handles partition offset as Martin suggested. I verify it
with 5.8-rc5 kernel on VMware ESXi 6.5. 

Could you please to take them for Linux v5.9 ?

Thanks in advance.

Coly Li 
---

Coly Li (2):
  block: change REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL to be odd
    numbers
  block: improve discard bio alignment in __blkdev_issue_discard()

 block/blk-lib.c           | 31 ++++++++++++++++++++++++++++---
 block/blk.h               | 14 ++++++++++++++
 include/linux/blk_types.h |  8 ++++----
 3 files changed, 46 insertions(+), 7 deletions(-)

-- 
2.26.2

