Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA045364B0
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 17:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352505AbiE0Pbl (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 11:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiE0Pbk (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:31:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924E715732;
        Fri, 27 May 2022 08:31:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4650C1F990;
        Fri, 27 May 2022 15:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653665498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iWM1xVXjq5IBCVIKldEBqVGnrRVG64RqmZAkdY45UTg=;
        b=KEf/qEdtiEGtQ8Tja9NNfj/mt0X2AqQS495XvbbHS1AUuzy+2DjOhpq900pIrWO8xxERjs
        8UBAfcScCqecXg6bQ55c7Ix5tE6wDeydr51pVyVqUsIcIMSXTD331ZV7IDkvR3/FJExMUc
        GjUyXGgxRHYOv1ioKKFwn0wuVOMmrAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653665498;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=iWM1xVXjq5IBCVIKldEBqVGnrRVG64RqmZAkdY45UTg=;
        b=6HBwfQDJ+j6KRNGgGIYD8pOSxYE3VvdVjzrBVCC6Gu6FAtbOm/6qSWTFCc7xc0oy7+UA7F
        0LcVhRVQnKZFT1Ag==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 52DDA2C141;
        Fri, 27 May 2022 15:31:24 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/3] bcache fixes for Linux v5.19 (2nd wave)
Date:   Fri, 27 May 2022 23:28:15 +0800
Message-Id: <20220527152818.27545-1-colyli@suse.de>
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

Here are the 2nd wave bcache fixes for Linux v5.19, they just survives
from my I/O pressure testing and look fine.

The patch from Jia-Ju Bai is in my testing queue for a while, it handles
a memory allocation failure in the I/O path on a backing device when it
is not attached to cache device.

My first patch adds memset() to zero clean the on-stack local variables
to keep the code logic consistent as they were previously allocated by
kzalloc() dynamically.

The second patch from me is an effort to avoid bogus soft lockup warning
in kernel message. Indeed the busy writeback thread starves writeback
I/O rate calculation kwork doesn't hurt anything, but the kernel message
with trace information scares users time to time, makes them to worry
about something wrong with bcache. This patch permit the writeback rate
update kworker to retry longer times before finally competing the write-
back lock with writeback thread, to avoid the unnecessary soft lockup
warning information.

There is no more patch in my plan for Linux v5.19. Please consider to
take them, and thank you in advance.

Coly Li (2):
  bcache: memset on stack variables in bch_btree_check() and
    bch_sectors_dirty_init()
  bcache: avoid unnecessary soft lockup in kworker
    update_writeback_rate()

Jia-Ju Bai (1):
  md: bcache: check the return value of kzalloc() in
    detached_dev_do_request()

 drivers/md/bcache/bcache.h    |  7 ++++++
 drivers/md/bcache/btree.c     |  1 +
 drivers/md/bcache/request.c   |  6 +++++
 drivers/md/bcache/writeback.c | 46 +++++++++++++++++++++++++++++++----
 4 files changed, 55 insertions(+), 5 deletions(-)

-- 
2.35.3

