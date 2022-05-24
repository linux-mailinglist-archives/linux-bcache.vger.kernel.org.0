Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B9D2532773
	for <lists+linux-bcache@lfdr.de>; Tue, 24 May 2022 12:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbiEXKX4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 May 2022 06:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiEXKXz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 May 2022 06:23:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1095484A07;
        Tue, 24 May 2022 03:23:54 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B5FF021A33;
        Tue, 24 May 2022 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653387832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iplS/TeHF/CtFHpdgLxbValjglTQrNdayPcu3zU7Chs=;
        b=gZxl+ooFGUmwPMzPe4+/jc0OQvDjFo7r5H/ZWydrGVKpU+jWNkihI5S0YGQbWWc3a5QXJe
        OQLhCIzKZPkhj8bvhuaE6YX2ZfSdaIqXpqtx3iz84rWR0lmiHRqjWLZaN6MNUFdDOzbavW
        Pxpq88cnRdC67z5qkRBSLS7eoVkkEWY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653387832;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iplS/TeHF/CtFHpdgLxbValjglTQrNdayPcu3zU7Chs=;
        b=uusiBaP6zkyC6B89uxPWRPSXxBYo8RYvM6sX0dcYBieE20aLuYDx9Pcxtsc/1qCsFdezN/
        xs20f5TZkZ1D65Ag==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 48CF32C141;
        Tue, 24 May 2022 10:23:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [Resend PATCH v2 0/4] bcache fixes for Linux v5.19 (1st wave)
Date:   Tue, 24 May 2022 18:23:32 +0800
Message-Id: <20220524102336.10684-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Thank you for taking the late arrived series, they are all for bcache
fixes when I work on the bcache journal no-space deadlock issue. It
spent me quite long time to fix because other issues interfered my debug
and analysis. When all the depending issues were fixed and my fix for
the journal no-space deadlock is verified, this submission is late for
Linux v5.19 submission. But it is still worthy to take them into v5.19
because real issues are fixed by this series.

The bcache has 4 patches for Linux v5.19 merge window, all from me.
- The first 2 patches are code clean up and potential bug fixes for
multi- threaded btree nodes check (for cache device) and dirty sectors
counting (for backing device), although no report from mailing list for
them, it is good to have the fixes.
- The 3rd patch removes incremental dirty sectors counting because it
is conflicted with multithreaded dirty sectors counting and the latter
one is 10x times faster.
- The last patch fixes a journal no-space deadlock during cache device
registration, it always reserves one journal bucket and only uses it
in registration time, so the no-spance condition won't happen anymore.

There are still 2 fixes are still under the long time I/O pressure
testing, once they are accomplished, I will submit to you in later
RC cycles.

The v2 series fixed previously detectd oversize stack frame issue, in
my test I don't observed the stack frame oversize warning and normal
bcache operations work as expected.

Thank you in advance.

Coly Li
---

Coly Li (4):
  bcache: improve multithreaded bch_btree_check()
  bcache: improve multithreaded bch_sectors_dirty_init()
  bcache: remove incremental dirty sector counting for
    bch_sectors_dirty_init()
  bcache: avoid journal no-space deadlock by reserving 1 journal bucket

 drivers/md/bcache/btree.c     |  58 +++++++++----------
 drivers/md/bcache/btree.h     |   2 +-
 drivers/md/bcache/journal.c   |  31 +++++++++--
 drivers/md/bcache/journal.h   |   2 +
 drivers/md/bcache/super.c     |   1 +
 drivers/md/bcache/writeback.c | 101 +++++++++++++---------------------
 drivers/md/bcache/writeback.h |   2 +-
 7 files changed, 94 insertions(+), 103 deletions(-)

-- 
2.35.3

