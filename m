Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B000A5791F6
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Jul 2022 06:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiGSE1c (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Jul 2022 00:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiGSE1c (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Jul 2022 00:27:32 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7BE3ED62;
        Mon, 18 Jul 2022 21:27:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 08E2620384;
        Tue, 19 Jul 2022 04:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658204850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vipvmvKGVNibBTP3C5KD/SMOOPbUpUd0+GzNsIi8J2Q=;
        b=pZXpH8rkIv7LhYPJHjRyF+clWOdG6ercxP3R9ozN7iQWy4CqhV2eAU5N47cQ40+ggQjZCJ
        rMsa4Ly0UEL/0+gutEhQYKFMrEg968EGPIPTsrQjz2s7RQ5g7r6mORSEqqFWxphgPT0hcl
        Aj62hE2Y9MR17voi58LWzlHocs8MfuQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658204850;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=vipvmvKGVNibBTP3C5KD/SMOOPbUpUd0+GzNsIi8J2Q=;
        b=tnepodpblXZv8Uo+88ywhMYipEZ8YJWgow2cgLycjs+KKjUFF2cgbCGJYpzRxjWNcBAogm
        fMRNZ8yFsSHDgeAg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 7F82B2C141;
        Tue, 19 Jul 2022 04:27:27 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 0/1] bcache patche for Linux v5.20
Date:   Tue, 19 Jul 2022 12:27:23 +0800
Message-Id: <20220719042724.8498-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

There is 1 patch from bcache submission, which removes 'EXPERIMENTAL'
from the bcache Kconfig item, now 'Asynchronous device registration'
option is not experimental anymore.

Please take it for v5.20. Thank you in advance to taking care of this.

Coly Li
---

Coly Li (1):
  bcache: remove EXPERIMENTAL for Kconfig option 'Asynchronous device
    registration'

 drivers/md/bcache/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.35.3

