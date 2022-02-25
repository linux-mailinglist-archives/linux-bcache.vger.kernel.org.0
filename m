Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9104C3FF4
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Feb 2022 09:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbiBYIVf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 25 Feb 2022 03:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbiBYIVe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 25 Feb 2022 03:21:34 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C67198EC0;
        Fri, 25 Feb 2022 00:21:02 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id d14-20020a05600c34ce00b0037bf4d14dc7so1192162wmq.3;
        Fri, 25 Feb 2022 00:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=HO8XR/q/XXFglD4ptxAjKzojMwexSnxCmnFzN0IXmkQ=;
        b=IAhc8gto9pONZF0zXNdlgCXEqxQ2YUD4KFCQyb//gTXY8jnAQ7xRHzVtq9ionJlat3
         yYBvKCljC8e8o9S/J9ydWquo5E3fi0aGrZUppqNjTYyqwm+61By7luBP+F3biFAuoBWh
         ul2IVdVIeYSzkSvPmP4varv2Rwho5asT0S9Fqk97eXk+76ZoULC+c96Longzy9xE9V3S
         MJo4TK1kmB4vQ98Rkmt2ipBU0nDv9xsi2Qv7CxKRodmiTkP/fvWatuWbX7yz5QjWR4pK
         muh9axBN0imgeDjvKBXo3HUGKSntMoSIkJtWA88PjltnKA83rzkfarxhg1QaeetuSbbf
         iOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HO8XR/q/XXFglD4ptxAjKzojMwexSnxCmnFzN0IXmkQ=;
        b=m134cZRbmH5EVvjXL/oGsdH7sZETYxSFW12gjQ2dwzXfil7NiPhyFkNpE7CBW78QB9
         bn6IgjMsZDwA2kV8Z94Hw1OYWJxJMYcL2L6RQQq7BpYPuYueawI2d/z+1gM4nclQogEF
         Yam2kDZVJXksJc2lYZtvpmHy5Iy5RfpiDdJkIZBMIW0xsXh2Z45RnzqHqzSyseD+FEuE
         UWEMsey7nGA0tB1O83v1O0YmHvvznc+OB5pLZFuqIO8w5jHUeUQ03t8RtV63ABWFXLpW
         4hQmWEkV7kvhZK37HcQW9wp56M46pK8G8HSsQ3xB+aV0pd+HA4fB/QiXZ40/ogE4Q24T
         diCQ==
X-Gm-Message-State: AOAM532ZF0iOe5ZX+QvbjdGDWScHID3VGQ4XF02KzIvKYYVwkQFOQXKJ
        3a4vCjVjBLC7drKZLukiYuI=
X-Google-Smtp-Source: ABdhPJwSalLg54fzpBXysxdhvtJwugUlUqw+7bcoyoH5D8D/rIx5UaVNOOOv2q4M/aJ25QGBJZW/FA==
X-Received: by 2002:a7b:c04e:0:b0:380:ead9:254a with SMTP id u14-20020a7bc04e000000b00380ead9254amr1639915wmc.58.1645777260674;
        Fri, 25 Feb 2022 00:21:00 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.40])
        by smtp.gmail.com with ESMTPSA id z5-20020adfdf85000000b001e713f774d3sm1552725wrl.61.2022.02.25.00.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 00:21:00 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] md: bcache: check the return value of kzalloc() in detached_dev_do_request()
Date:   Fri, 25 Feb 2022 00:20:48 -0800
Message-Id: <20220225082048.19524-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The function kzalloc() in detached_dev_do_request() can fail, so its
return value should be checked.

Fixes: bc082a55d25c (bcache: fix inaccurate io state for detached bcache devices)
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/md/bcache/request.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c1..1b5ccfa93b8c 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,8 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip)
+		return;
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->orig_bdev = orig_bdev;
-- 
2.17.1

