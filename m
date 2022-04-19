Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53F7507285
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Apr 2022 18:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiDSQHm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Apr 2022 12:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354352AbiDSQHa (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Apr 2022 12:07:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432E03819A;
        Tue, 19 Apr 2022 09:04:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id ECDE71F746;
        Tue, 19 Apr 2022 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1650384282; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mrLHfPXRQYvoe9Rv994gYxuFArtGyH8tzxqwCxwBQE4=;
        b=FkK+Kw5pqCXMdd5i5zzC1/oM2QBmV4A3aIcLRPzuZ2tMeBT480Gc1T4aZZV5ezZglYDxVw
        UJEujA/OmpqkV6qubedfq28M76k76t2u7o7nZRMfSfl1fddh+bLAvduemp34DcuzyUC/Lm
        gmEJBP8LjgRQUqDWHIKvL92IlS9Mjd8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1650384282;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mrLHfPXRQYvoe9Rv994gYxuFArtGyH8tzxqwCxwBQE4=;
        b=vLf9EjdEN8hCOOQtdNXZrm94abLN3G21WasbO1VnbEft6d4EJ2vSb9b2H36TTv9Bqhjjsm
        4BGRsyRVQtKWYdAw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 45C762C14B;
        Tue, 19 Apr 2022 16:04:36 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     hch@lst.de, kch@nvidia.com, snitzer@redhat.com,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/2] bcache fixes for Linux v5.18-rc3
Date:   Wed, 20 Apr 2022 00:04:23 +0800
Message-Id: <20220419160425.4148-1-colyli@suse.de>
X-Mailer: git-send-email 2.34.1
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

There are two regressions introduced in the generic block layer changes
from Linux v5.18-rc1. Both of them may panic the kernel, please take
them for -rc4.

Thanks in advance.

Coly Li
---
Coly Li (2):
  bcache: put bch_bio_map() back to correct location in
    journal_write_unlocked()
  bcache: fix wrong bdev parameter when calling bio_alloc_clone() in
    do_bio_hook()

 drivers/md/bcache/journal.c | 2 +-
 drivers/md/bcache/request.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1

