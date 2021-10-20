Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60073434DCE
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Oct 2021 16:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhJTOcH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 20 Oct 2021 10:32:07 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50904 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbhJTObb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 20 Oct 2021 10:31:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0F6AC1F770;
        Wed, 20 Oct 2021 14:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634740156; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rhxVPNVrdj7DAABgqdH0vGZhcDeydZJ5yGLZ1FqxmPA=;
        b=N8LwlLh/QSWMn9dn/EN7OS4KYDn9IOc9Dpq4JOcHQJOrJUKQOXYjUzOwtIU2YlZVK2cEzi
        NhQhZNps/ANS+9qfnTKAwaAW6GMhSuWdDCgcHx1AkQIBUBuaOp8visYNnzTJct9f1G17kJ
        AiWBONJHcVtDrdX9A2I76NIDet3cIqk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634740156;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=rhxVPNVrdj7DAABgqdH0vGZhcDeydZJ5yGLZ1FqxmPA=;
        b=RWWyPgMaGMFAq3PCmQSUuBVvTKnQcWdEAO9rdkEusj0zKKk/B3u38jznCSue7i42CbD+Jl
        QQQ5MkL/OnS+HaAw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 741E4A3B84;
        Wed, 20 Oct 2021 14:29:13 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/8] bcache patches for Linux v5.16 (first wave)
Date:   Wed, 20 Oct 2021 22:28:49 +0800
Message-Id: <20211020142857.6320-1-colyli@suse.de>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the first wave bcache series for Linux v5.16. In this merge
window, there is no large change set submitted, most of the patches
are code clean up from Chao, Christoph and me. This time we have a
new contributor Feng who provides a useful bug fix for dirty data size
calculation during cache detaching. 

Please take them and thanks in advance.

Coly Li
---

Chao Yu (1):
  bcache: fix error info in register_bcache()

Christoph Hellwig (4):
  bcache: remove the cache_dev_name field from struct cache
  bcache: remove the backing_dev_name field from struct cached_dev
  bcache: use bvec_kmap_local in bch_data_verify
  bcache: remove bch_crc64_update

Coly Li (1):
  bcache: reserve never used bits from bkey.high

Ding Senjie (1):
  md: bcache: Fix spelling of 'acquire'

Lin Feng (1):
  bcache: move calc_cached_dev_sectors to proper place on backing device
    detach

 drivers/md/bcache/bcache.h  |  4 ---
 drivers/md/bcache/btree.c   |  2 +-
 drivers/md/bcache/debug.c   | 15 ++++----
 drivers/md/bcache/io.c      | 16 ++++-----
 drivers/md/bcache/request.c |  6 ++--
 drivers/md/bcache/super.c   | 72 ++++++++++++++++++-------------------
 drivers/md/bcache/sysfs.c   |  2 +-
 drivers/md/bcache/util.h    |  8 -----
 include/uapi/linux/bcache.h |  4 +--
 9 files changed, 57 insertions(+), 72 deletions(-)

-- 
2.31.1

