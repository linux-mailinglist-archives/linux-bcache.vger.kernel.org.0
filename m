Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32ACC50D01B
	for <lists+linux-bcache@lfdr.de>; Sun, 24 Apr 2022 08:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiDXGuq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 24 Apr 2022 02:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238421AbiDXGup (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 24 Apr 2022 02:50:45 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960805F8FE;
        Sat, 23 Apr 2022 23:47:46 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id hh4so8384479qtb.10;
        Sat, 23 Apr 2022 23:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hhhQDPt+3onB8fGuNsPxKnWw81s4Lk61v9Zm3h8T3Jg=;
        b=dohdYThYTN60ilx11KueqqbWHOLBxkSudoW+sh5fgVpKPLn5tSrGLfuNRGpXrfuB8D
         Ao5l7VDsBLm8xpquSXAFXtRr4CAWL/EaZ3QVICNDMT7IiBdQbG5FUDu4FeoTWP/5dJpd
         GA/PfYkkqbCPPzakixPUzckAHMC8jqdJ8HhhxtFCyT6E/SCUXNIM6Sahaue1bR7ZivMh
         rjb3I6Hmggr16jvtRncM7aYEEbli/uGJF4+f0bTPH5VvoowOV4uoVrhhyYdjO0IuLGJr
         7OJmymDRym9jFusB/ffwjcEwFm10nu2dGcdWkmt9d9SofJ8GY8MyBH0/MEt4tk9+wlPr
         YN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hhhQDPt+3onB8fGuNsPxKnWw81s4Lk61v9Zm3h8T3Jg=;
        b=xKP4N9tydegwfvSsJnfU+8nEXOJLHo+SDKgvlWvT7FVy8U+6Tvmq409oWgtF05VT8v
         190mSpcT6/0I14eS8ZmVZFrMf+JnrgBrY4gqgEoqNjmopuDrC+LYDActxwAuQPiON/Yn
         E/psu6g2t57/sxBBM9HnztIitjj+PkQIsCxUYb6jNEMeblugrTbjEyoOanR2LMFVrAJX
         pd2B6JNcb9Ndw929o+HWzw+6LS2fk6XvbHkGhnLFrgbngssmRlpThX5bQ/YKz+vdzdx8
         3o+VJ1xwYwwjf53u2lNMvwaImAfi9mphcAUbz/UijOqPVZ/WUgeclDJAtl+4/+Zkb40J
         gHhw==
X-Gm-Message-State: AOAM531EazvSA9v2FzkU0GSJQ1aBBifUJ6vLK4Mkv/G95lBwzzr7FqzK
        DBBFlEsXl4KTqVBw2UJ2gXs=
X-Google-Smtp-Source: ABdhPJyJLxDVPY5Xpf8pMHxnTf/wdGwGvaNPIYIsn0xuGZuPkl9CPj3gmAFUFVkzlnncHuDe29/ZlQ==
X-Received: by 2002:a05:622a:14c6:b0:2e2:3f:f938 with SMTP id u6-20020a05622a14c600b002e2003ff938mr8446073qtx.358.1650782865856;
        Sat, 23 Apr 2022 23:47:45 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a4-20020ac85b84000000b002f340e3c703sm3966124qta.41.2022.04.23.23.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 23:47:45 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To:     colyli@suse.de
Cc:     kent.overstreet@gmail.com, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        ran jianping <ran.jianping@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] bcache: remove unneeded flush_workqueue
Date:   Sun, 24 Apr 2022 06:47:39 +0000
Message-Id: <20220424064739.3226800-1-ran.jianping@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: ran jianping <ran.jianping@zte.com.cn>

All work currently pending will be done first by calling destroy_workqueue,
so there is no need to flush it explicitly.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/md/bcache/writeback.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9ee0005874cd..9d0b4140ad8f 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -793,10 +793,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
+	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
-	}
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
-- 
2.25.1

