Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B545304D4
	for <lists+linux-bcache@lfdr.de>; Sun, 22 May 2022 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349525AbiEVRHs (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 May 2022 13:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiEVRHr (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 May 2022 13:07:47 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B6B3A73F;
        Sun, 22 May 2022 10:07:45 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 73D9B1F381;
        Sun, 22 May 2022 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653239264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LLwJie0sQStofLUGTrQvWu/Wt0gqhr7qS8+rcV8iY7g=;
        b=cTDzUnf7bOce6XPlpj/vMbFuIRNOde4WPFvUmuXVvCrbD1O9x33jUfNf9rKiu1hk92eQrf
        jWn3ALoSkTYyN/1aRxDsYtSpCAzBTTemu2aOiZN4akHTQkZDqgFYEjRBY0RxXRAi14BajB
        TxdMSMNLHcXIu2+P6sJTPexomfrt4gg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653239264;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LLwJie0sQStofLUGTrQvWu/Wt0gqhr7qS8+rcV8iY7g=;
        b=Wbu3kYaQGdLc90+e+N3f24CsNMVk1+eHgvzzGmZOqruxneOZ+doZfIiPGkf8Xw8OsVg+Fa
        GrDbFP2bmTgN9rDQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id B95222C141;
        Sun, 22 May 2022 17:07:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/4] bcache patches for Linux v5.19 (1st wave)
Date:   Mon, 23 May 2022 01:07:32 +0800
Message-Id: <20220522170736.6582-1-colyli@suse.de>
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

Please take them, and thanks in advance.

Coly Li
---

Coly Li (4):
  bcache: improve multithreaded bch_btree_check()
  bcache: improve multithreaded bch_sectors_dirty_init()
  bcache: remove incremental dirty sector counting for
    bch_sectors_dirty_init()
  bcache: avoid journal no-space deadlock by reserving 1 journal bucket

 drivers/md/bcache/btree.c     |  58 +++++++++----------
 drivers/md/bcache/journal.c   |  31 +++++++++--
 drivers/md/bcache/journal.h   |   2 +
 drivers/md/bcache/super.c     |   1 +
 drivers/md/bcache/writeback.c | 101 +++++++++++++---------------------
 5 files changed, 92 insertions(+), 101 deletions(-)

-- 
2.35.3

