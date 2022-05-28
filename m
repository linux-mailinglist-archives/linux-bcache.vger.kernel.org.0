Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B2536CF0
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiE1Mp7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiE1Mp7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:45:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436A9F8;
        Sat, 28 May 2022 05:45:58 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D8D301F895;
        Sat, 28 May 2022 12:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653741956; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9xrVbFIVymZq1V70QCLlhSccycDdU6BeYBBfd+tOcck=;
        b=b/OeU6kXBe9l5thlLSge1AWzNrIKam+rvj9PxDTsbOKV/0nsRE1LR98RwBkBiaIgRAyZva
        ZKShkWCp8ew2C0vfwwaW69ev9tjLUuIxiTNu8htA0JhoVGjtKsB/n1XDBgEFzqbdFXdJTn
        XtU+YlMm3RohmHOKY7cIrLInb0UPtbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653741956;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=9xrVbFIVymZq1V70QCLlhSccycDdU6BeYBBfd+tOcck=;
        b=TDmw6a3nhl1q30EWo1QzPmAF1A/zRWGdrRE1HxwgBQqarO9Y13G+0sNyjjWffB1CAUxuiZ
        rA4zqHZocCs9BqCw==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 602292C141;
        Sat, 28 May 2022 12:45:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 0/1] bcache fix for Linux v5.19 (3rd wave)
Date:   Sat, 28 May 2022 20:45:49 +0800
Message-Id: <20220528124550.32834-1-colyli@suse.de>
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

This is the last bcache patch from me for Linux v5.19, which tries to
avoid bogus soft lockup warning from the bcache writeback rate update
kworker.

Comparing to previous version, the only change in this version is to
change BCH_WBRATE_UPDATE_RETRY_MAX to BCH_WBRATE_UPDATE_RETRY_MAX. This
is only about naming change, no other thing touched.

This patch is generated againt linux-block:for-5.19/drivers, the latest
patch in the branch I see is commit 1243172d5894 ("nbd: use pr_err to
output error message").

Thank you for the suggestion for a more clear and simple patch.

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

