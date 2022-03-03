Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06D34CB489
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Mar 2022 02:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiCCB4o (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Mar 2022 20:56:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiCCB4n (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Mar 2022 20:56:43 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0801CC3C1C;
        Wed,  2 Mar 2022 17:55:59 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so2353727wmp.5;
        Wed, 02 Mar 2022 17:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=GvqqsXp9JqRW+QoRebFXnXLKeWDJccxwpi7zx7aah6k=;
        b=enhTd8NLMcPGtMzrxXlO6sQ4IUzfhtLJdzJZRVTG1u19GurckZA1UnbtdorF3sVe3h
         9udPBxjZZ1yUiWNU2I6L48t5rEynB+rAERTsffdK4G3vObAtj4q5smzQ7SOu2EseZrr3
         22Bk/NpXVtZCsEpk36vgFNoLy/OYBa/NpzEZpsoPZtUpQF3J3lCKLIVRaPE4jFthNglf
         VItuwvFt3YLxRXl6b56FE68wq5CExiMLEOxM9HdOBS8M1r+v2bOAGS929cC9j4kNfXfj
         hJrMwwLCKHftrH+fDcUKYy0mpszEjex3wsEuU1O2G3svnRsycT+M8XAfoF4febdKee22
         PSyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GvqqsXp9JqRW+QoRebFXnXLKeWDJccxwpi7zx7aah6k=;
        b=NxsEpqreGOHduVzZeJMKqdyy23ffhYhUhLB8IahWpFAwAPgKp0j4RTB/bz2E00L6wK
         rQcygKlskCzInlrbvZwTj6BnMFM/JU+3txf7yrO9/q3ZXx/fCWOKSknNTCMMFeC/hQ+d
         9ru02iAODZg9ntVrHG151QZNy9u2b317HdUXgF5J00ViGSSRQqzO6N4D9w8WnbXiAvTF
         bzbFmslVcSaHS7TX7DZR0lx1xCOpXqIogMNRNI/JrjM7K8Gxf7li6GkmVHB4oyU4W9Na
         xpWkREGrC5y8+wX5P6g1WqfI7s/8hKKkhmjo1Sf5qq7cgwIlJONuGhFsLQRuB8xCtB+M
         myxA==
X-Gm-Message-State: AOAM532gLsRydTGzb5Eg2IEfRRAn4pGf6yXj0M9zGOovBrpSZoyUTvsY
        OHpZKASNLNzep4N5w2J0Lq5llmKIW91y1Q==
X-Google-Smtp-Source: ABdhPJyeYSFf/E4+nUJRgOAUTZovbk5817KycshSDPhgCy+Q2hQU6FKOamdYe3wA9rVDY1OGdFiimQ==
X-Received: by 2002:a05:600c:1c9c:b0:386:f4ed:3f59 with SMTP id k28-20020a05600c1c9c00b00386f4ed3f59mr1788258wms.27.1646272557491;
        Wed, 02 Mar 2022 17:55:57 -0800 (PST)
Received: from localhost.localdomain ([64.64.123.48])
        by smtp.gmail.com with ESMTPSA id l12-20020a05600012cc00b001f059bcbd7asm88093wrx.31.2022.03.02.17.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 17:55:57 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2] md: bcache: check the return value of kzalloc() in detached_dev_do_request()
Date:   Wed,  2 Mar 2022 17:55:44 -0800
Message-Id: <20220303015544.32186-1-baijiaju1990@gmail.com>
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

Fixes: bc082a55d25c ("bcache: fix inaccurate io state for detached bcache devices")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
v2:
* Fix the error handling code when ddip is NULL.
  Thank Coly for good advice.

---
 drivers/md/bcache/request.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c1..673a680240a9 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,6 +1107,12 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddip) {
+		bio->bi_status = BLK_STS_RESOURCE;
+		bio->bi_end_io(bio);
+		return;
+	}
+
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->orig_bdev = orig_bdev;
-- 
2.17.1

