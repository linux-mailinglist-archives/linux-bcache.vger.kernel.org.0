Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F957DABFE
	for <lists+linux-bcache@lfdr.de>; Sun, 29 Oct 2023 11:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjJ2Khr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 29 Oct 2023 06:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjJ2Khq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 29 Oct 2023 06:37:46 -0400
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 29 Oct 2023 03:37:44 PDT
Received: from smtp.smtpout.orange.fr (smtp-15.smtpout.orange.fr [80.12.242.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9612EBE
        for <linux-bcache@vger.kernel.org>; Sun, 29 Oct 2023 03:37:44 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id x33bqUCJFRr5vx33bqsdPz; Sun, 29 Oct 2023 11:30:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1698575412;
        bh=0csRcwC0zp8g1RspI9Q/JAaWFLGDVf/EQzQzOfWYg+A=;
        h=From:To:Cc:Subject:Date;
        b=l4AlWDncAlsOegFIom9cmvrcSzm61IG9iUnUK/WhCAuIU8SYLlBwbE6Bi8C5v6mLl
         aotEEC7COAl/0mAxBJiHOm9At/fyciMjWxe9nvB8MIO+aRxeL66M2XCY6pUza46weX
         5pw0L1yFqbT24nfpdS08DO1URE2pwg6PdF6f0nkYMg9luatsVfrHSsKtVxjkuhco0s
         o1J0opi6YXidPzGMQX5GTnJz4S1AOAJeXKjXHbPz9dZx5UNoasgTk8rOkCD8VkiiaH
         WCSffMQxUyvXrScCqhIwugWUXs9F/j0RsaFaTguyjQJnDrpG5cakgRFuL9hbiKySek
         9EsoPN930QBAA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 29 Oct 2023 11:30:12 +0100
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: Optimize sysfs_hprint()
Date:   Sun, 29 Oct 2023 11:30:06 +0100
Message-Id: <9b82413f1ca0b924cc139d945777e32dd22ffe41.1698575385.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The size of what is in 'buf' is already computed by bch_hprint(), so skip
these bytes when calling strcat().

This easily saves a few cycles. (should it matter)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/md/bcache/sysfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/sysfs.h b/drivers/md/bcache/sysfs.h
index 65b8bd975ab1..798bcbeab0bb 100644
--- a/drivers/md/bcache/sysfs.h
+++ b/drivers/md/bcache/sysfs.h
@@ -78,7 +78,7 @@ do {									\
 do {									\
 	if (attr == &sysfs_ ## file) {					\
 		ssize_t ret = bch_hprint(buf, val);			\
-		strcat(buf, "\n");					\
+		strcat(buf + ret, "\n");				\
 		return ret + 1;						\
 	}								\
 } while (0)
-- 
2.34.1

