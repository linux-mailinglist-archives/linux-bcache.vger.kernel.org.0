Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A065BD201
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiISQR2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiISQRY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706183685B;
        Mon, 19 Sep 2022 09:17:22 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 7B55A1F896;
        Mon, 19 Sep 2022 16:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604240; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=PFjWvtVhPF+Le913aItnMXNGOJaN/t2Ag2/GHr9H9as=;
        b=h8P/DwIZIVV95u5HjexLlrXYhsKUkHk13lwxEH2y/kw46wxnwMfwn5jcHRAlsOmGAxlY0s
        t/cxiiqqiXnX5ArBVeBxTZa/NePBSteiPhnKyE6QcAexCEBc1Hc79J+a0LiL2XuP2xLY+1
        WRFduSeioK+0FYYCGagKCxeipe37XDE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604240;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=PFjWvtVhPF+Le913aItnMXNGOJaN/t2Ag2/GHr9H9as=;
        b=snhxAccpkMzj3rZ3fCnmSbyCmZ/MzcabZ2Ivcym8ZZ/Bc3v3wGLkicB0sHGn1W3zmdAN9y
        O5UOrzjjqaFOElBQ==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 2A1E12C141;
        Mon, 19 Sep 2022 16:17:17 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/5] bcache patches for Linux v6.1
Date:   Tue, 20 Sep 2022 00:16:42 +0800
Message-Id: <20220919161647.81238-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

This is the 1st wave bcache patches for Linux v6.1.

The patch from me fixes a calculation mistake reported by Mingzhe Zou,
now the idle time to wait before setting maximum writeback rate can be
increased when more backing devices attached.

And we also have other code cleanup patches from Jilin Yuan,
Jules Maselbas, Lei Li and Lin Feng.

Please take them and thanks in advance.

Coly Li
---
Coly Li (1):
  bcache: fix set_at_max_writeback_rate() for multiple attached devices

Jilin Yuan (1):
  bcache:: fix repeated words in comments

Jules Maselbas (1):
  bcache: bset: Fix comment typos

Li Lei (1):
  bcache: remove unnecessary flush_workqueue

Lin Feng (1):
  bcache: remove unused bch_mark_cache_readahead function def in stats.h

 drivers/md/bcache/bcache.h    |  2 +-
 drivers/md/bcache/bset.c      |  2 +-
 drivers/md/bcache/stats.h     |  1 -
 drivers/md/bcache/writeback.c | 78 ++++++++++++++++++++++++-----------
 4 files changed, 56 insertions(+), 27 deletions(-)

-- 
2.35.3

