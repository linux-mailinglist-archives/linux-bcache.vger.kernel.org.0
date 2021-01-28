Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7662230782E
	for <lists+linux-bcache@lfdr.de>; Thu, 28 Jan 2021 15:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhA1Oe1 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 09:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhA1OeH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 09:34:07 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC06C0613D6
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 06:33:26 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id rv9so8029136ejb.13
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 06:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8EW2sHyKxqIMJ0umo5x6Br3dulIu8rGmyPAiWkIOWVA=;
        b=XDXjPCRxa1ibL54NEocoVV6weEEkqq+6TA85lHyycgMOAyH+54/ue6CNdSOEhZ3OOR
         KcbiDdBiTI6C7mUoYW3bkr7udj6OW8XrIE4dIt6uG365Re4gvs5dR1odq5t/koK7s9BF
         4lbIZyCfFB2tLn2vDt6ZLGAblyC/dgV4OFWoc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8EW2sHyKxqIMJ0umo5x6Br3dulIu8rGmyPAiWkIOWVA=;
        b=onMvG7rPGpukY/iYIliyx2xPgcACwaxSu3iS/kPptVbbwyWmGZnpW6Tu0O7os9c1Pr
         fjXr2m0+YbLuiQ7Tq3ZiBDjVxtttBRQeplivP/kdMvRi2Xra+NOOYg1dCUrlIJhp8ngJ
         n8rbxsqKGr8Fen9MO4+LTGACWw/TFsgXdtBBCSdEp1ME4EgCRR2O6bnhs0VdpgbUXgYl
         iSKxEfIfnxFI2PRtgYg2JbDpTqs1Jn+HSLIeIvkq90bVzX7PbdfsuPPx2d7U6Qqw5YAo
         apvccUPK5N9eBQ3/wtcRtOdqXkVaGYWwQv+gO6/EnCZ5FdXazZfSQhXEUX7R2E9OzMrB
         YfwQ==
X-Gm-Message-State: AOAM532o6shXRiSTaejMiZ9WaMR5H86huw9JkPWOC5zIfpMaia779RMp
        AnCh/C5evUXK0RHv6A4s5OmYH+COEhENkg==
X-Google-Smtp-Source: ABdhPJzQ3o67Kh/RPDND/8Ia6orFgZ0SoMnQ9naFXxmDjJzyuFge/onm/0kPxBcmHZKopd0uZvhUDw==
X-Received: by 2002:a17:906:eb46:: with SMTP id mc6mr11511959ejb.184.1611844405189;
        Thu, 28 Jan 2021 06:33:25 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id e6sm2606168edv.46.2021.01.28.06.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 06:33:24 -0800 (PST)
Received: (nullmailer pid 202740 invoked by uid 500);
        Thu, 28 Jan 2021 14:33:22 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH] bcache: Fix register_device_aync typo
Date:   Thu, 28 Jan 2021 15:33:19 +0100
Message-Id: <20210128143319.202694-1-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Should be `register_device_async`.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2047a9cccdb5d..e7d1b52c5cc8b 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2517,7 +2517,7 @@ static void register_cache_worker(struct work_struct *work)
 	module_put(THIS_MODULE);
 }
 
-static void register_device_aync(struct async_reg_args *args)
+static void register_device_async(struct async_reg_args *args)
 {
 	if (SB_IS_BDEV(args->sb))
 		INIT_DELAYED_WORK(&args->reg_work, register_bdev_worker);
@@ -2611,7 +2611,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 		args->sb	= sb;
 		args->sb_disk	= sb_disk;
 		args->bdev	= bdev;
-		register_device_aync(args);
+		register_device_async(args);
 		/* No wait and returns to user space */
 		goto async_done;
 	}
-- 
2.26.2

