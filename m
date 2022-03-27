Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA364E8678
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Mar 2022 09:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiC0HWV (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Mar 2022 03:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiC0HWT (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Mar 2022 03:22:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D721B55B8
        for <linux-bcache@vger.kernel.org>; Sun, 27 Mar 2022 00:20:41 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id t13so8609024pgn.8
        for <linux-bcache@vger.kernel.org>; Sun, 27 Mar 2022 00:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/mLjq33rf2qF3D/MUgnh1zNts4dhGjAqAryMWFucXk=;
        b=be8sDBKLU158xOi0uXwn3AeQi6hirVhnUv2hnJIqAvJZvR6Ii2kQh2mY6TRVyfgf3+
         RYZITGAR9cKkOoSKyorzuyVu25Ly2i+9wpQfIwqRX1yF30yNsbl33tHbnF3N81sK6Ih+
         FbnKzLL3LXWEdlxsTXhWLz6kXbqT24obzpL9Vf2LyGqjvV9oLxoL3U1ez0rkothjvvlF
         zpFnIRP81mRLkkxYfKJ7KBfHsQkzitDrZWFrgxPuG3Z8EapM6YliJQlQN69g1eIz7Y6W
         COalZGjoEU+Ngh1HdY+3Xq7FaYeS0VdKbInqjjtipfD82QTmFF6GaiuWdZ+3xCxOc5lM
         guxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/mLjq33rf2qF3D/MUgnh1zNts4dhGjAqAryMWFucXk=;
        b=3vydoLa5rMHVq1WgapXOnhrBJCL66W/HSlcBz5es8wNUChBbTJliZZYn7YiAW+pMdA
         Ojm4gRD4c0qYQvGcmJJIXG9oG7lxyPPeoDJSXVMzVDgaE3LJ/uZC8E1+NwFQdwzio/xU
         gawB+DQwHHnKLqNhm+ZXWIvhjCuNl57LDePwogW244fo8Sa9oP055XtPRJO4V5MLoXPJ
         MGIwFZcBuBl9oopcnU3UK9GlSAae3gIp/z6SsM3Pau95GO4qiFk7EWMAhO7PBQRLCEsp
         eyNC343eFK+SoSSbQkUNJgN7rBHLYHBv6/cyx92RBNIbsYspdrlXcq+Psg1gEsWq2qx9
         RdVw==
X-Gm-Message-State: AOAM533wAhBhSM5L0Yso3wuKuLOCQEPl4Nckz+uSo7IxyZHpPheVKWTD
        hDvK8VvluZBP7KrqIDHdM12+Rk24gHtwpDnKAsA=
X-Google-Smtp-Source: ABdhPJw3tdaKINdLCqe8WNFDv9UAnv8EB8c/zAWmFaHJSIvZ33Jt4+D+qI2P3U9DOuHU2yW5qVs5+Q==
X-Received: by 2002:a05:6a00:889:b0:4e0:dcc3:5e06 with SMTP id q9-20020a056a00088900b004e0dcc35e06mr17575423pfj.29.1648365641032;
        Sun, 27 Mar 2022 00:20:41 -0700 (PDT)
Received: from localhost ([120.229.35.222])
        by smtp.gmail.com with ESMTPSA id h2-20020a056a00170200b004fae65cf154sm11805344pfc.219.2022.03.27.00.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 00:20:40 -0700 (PDT)
From:   Li Lei <noctis.akm@gmail.com>
X-Google-Original-From: Li Lei <lilei@szsandstone.com>
To:     linux-bcache@vger.kernel.org
Cc:     colyli@suse.de, kent.overstreet@gmail.com, noctis.akm@gmail.com,
        Li Lei <lilei@szsandstone.com>
Subject: [PATCH] bcache: remove unnecessary flush_workqueue
Date:   Sun, 27 Mar 2022 15:20:38 +0800
Message-Id: <20220327072038.12385-1-lilei@szsandstone.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

All pending works will be drained by destroy_workqueue(), no need to call
flush_workqueue() explicitly.

Signed-off-by: Li Lei <lilei@szsandstone.com>
---
 drivers/md/bcache/writeback.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9ee0005874cd..2a6d9f39a9b1 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -793,10 +793,9 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
+	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
-	}
+
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
-- 
2.25.1

