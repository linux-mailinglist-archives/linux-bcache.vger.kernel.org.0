Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C845791F8
	for <lists+linux-bcache@lfdr.de>; Tue, 19 Jul 2022 06:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbiGSE1f (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 19 Jul 2022 00:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbiGSE1f (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 19 Jul 2022 00:27:35 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3CA3ED62;
        Mon, 18 Jul 2022 21:27:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4D5C233BD9;
        Tue, 19 Jul 2022 04:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658204853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myjn+PGnU00Lgzbm0ioLBtFeWrOn4WkY+nSuVVSw/hc=;
        b=OPK8oBPFYuKxpb+WLDUNUGJvxSqqKJlxLGkj/apSRNIrsh0/tNpn/cXsTsWzmz9RjZvjzI
        GyIGqiwJLW3577Os6rzgtW3n/wx7NgodJvxzc94O2c1OVhkk+4AahCdztWeOalYCd1Iefe
        iDVQteyxRunwBsTmXtbKTao2CoE3gow=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658204853;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=myjn+PGnU00Lgzbm0ioLBtFeWrOn4WkY+nSuVVSw/hc=;
        b=+djAidSJ5zNvyIcW+x/HXvLasX1l3iVpuz5P9m9P+dEnPPrF1dLil9Q5XCfJRAqeUW1fpW
        ucyqIQY/sHcEoGCg==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0EA9E2C141;
        Tue, 19 Jul 2022 04:27:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/1] bcache: remove EXPERIMENTAL for Kconfig option 'Asynchronous device registration'
Date:   Tue, 19 Jul 2022 12:27:24 +0800
Message-Id: <20220719042724.8498-2-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719042724.8498-1-colyli@suse.de>
References: <20220719042724.8498-1-colyli@suse.de>
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

The "Asynchronous device registration (EXPERIMENTAL)" Kconfig option is
for 2+ years, it is used when registration takes too much time for
massive amount of cached data, to avoid udev task timeout during boot
time.

Many users and products enable this Kconfig option for quite long time
(e.g. SUSE Linux) and it works as expected and no issue reported.

It is time to remove the "EXPERIMENTAL" tag from this Kconfig item.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/Kconfig b/drivers/md/bcache/Kconfig
index cf3e8096942a..529c9d04e9a4 100644
--- a/drivers/md/bcache/Kconfig
+++ b/drivers/md/bcache/Kconfig
@@ -29,7 +29,7 @@ config BCACHE_CLOSURES_DEBUG
 	operations that get stuck.
 
 config BCACHE_ASYNC_REGISTRATION
-	bool "Asynchronous device registration (EXPERIMENTAL)"
+	bool "Asynchronous device registration"
 	depends on BCACHE
 	help
 	Add a sysfs file /sys/fs/bcache/register_async. Writing registering
-- 
2.35.3

