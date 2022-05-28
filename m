Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5065F536B14
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 08:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiE1GUL (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 02:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiE1GUJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 02:20:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39822CE0A;
        Fri, 27 May 2022 23:20:07 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 60781219B3;
        Sat, 28 May 2022 06:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653718806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=j062KKtELiAGZmxCHrJyojyrZbGBWAY35j0LzQwoEY4=;
        b=TAENAO9dfELX4RZGJrbq1FtFnMA1ZiTAURAl9K+ThYgez5pGSi4GnuObdYkdPdH39If+Vm
        /BmI5gOz/7tEDiZvXCcKOnZYLw3e+rosxPrj7ObwmCUvgc1ctKK4t44HaIUzZEu5e+c2KU
        XKRbyktWconH4WypJjUyN67T8+y17TI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653718806;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=j062KKtELiAGZmxCHrJyojyrZbGBWAY35j0LzQwoEY4=;
        b=u+IoQwC0Q/tzhWdqg84JONncQtF6yFMGpnQQFmk2lSlacJF5M12WHCJkKDrOqye+S0bNNB
        2D9b+0utaAR9rzCQ==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id EA3742C141;
        Sat, 28 May 2022 06:20:04 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache fix for Linux v5.19 (3rd wave) 
Date:   Sat, 28 May 2022 14:19:48 +0800
Message-Id: <20220528061949.28519-1-colyli@suse.de>
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

This submission only has 1 patch, which is the effort to avoid bogus
soft lockup warning from the bcache writeback rate update kworker.

Based on your suggestion, this version is more clear and simple, it
works as expected in my testing. BCH_WBRATE_UPDATE_RETRY_MAX (15)
defines the maximum retry times for lock contention, in worst case it
is 1+ minutes before update_writeback_rate() call down_read() to acquire
dc->writeback_lock.

Please consider to take it, and thank you again for the suggestion.

Coly Li
---

Coly Li (1):
  bcache: avoid unnecessary soft lockup in kworker
    update_writeback_rate()

 drivers/md/bcache/bcache.h    |  7 +++++++
 drivers/md/bcache/writeback.c | 31 +++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 10 deletions(-)

-- 
2.35.3

