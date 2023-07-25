Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63018761753
	for <lists+linux-bcache@lfdr.de>; Tue, 25 Jul 2023 13:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjGYLrR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 25 Jul 2023 07:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbjGYLrK (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 25 Jul 2023 07:47:10 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6771FC1;
        Tue, 25 Jul 2023 04:47:05 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fbc59de009so44468895e9.3;
        Tue, 25 Jul 2023 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690285599; x=1690890399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tfoDAczWkqWWRUwBF5o54v6xQbgWHpFklc1bB+kH+ig=;
        b=M0Ve7MGyX24qswOj3GfyU9Htshcip2MOt4w4zOUXEohr21RuozFXHQ7gkv9ifGpE3s
         Kl+m28jykJ7WwKpr0pkNvrXrz9joS+B6KTta++wysbMd3B6Kte4bjKjXt9K5QaTyobDB
         DkMW9yrJjOiJu4pLe/GHemMnflRx6uQExH3QjFhFHJtXktHF2Xu3H9kjNOFqnASCg4wH
         ecH47TSLWyeV9TKkPXxp+i75LNnkiCthrEf8l+bzW47qLzPgpQbA9kUHaO5LhU0GhwBt
         cvGJx08E2KoKKeBkDZJ+ulO2XXtZZGc2i7F9Y9EPc6LjN02+6t0Kwm7oj08lHXCyB0Wu
         dPOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690285599; x=1690890399;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tfoDAczWkqWWRUwBF5o54v6xQbgWHpFklc1bB+kH+ig=;
        b=MKaTKyz/s/zgH8WqUg5xIBM3xyio7nGtCDFYp6fFflzOFI1qaqUx/0vyQMfdtK+hTs
         Q5SsxQH5nAKe9hXS9cfV/dant/et/EofYBrDXtrqhdmLM/Q3c6I5T6hd1g7zTiYpDK4/
         QxnC+yI/SOE/lhWrIBEjz5x3tZWNPdrrfoxqo2OFDPPrPHL+uY4ahaGxk97j4/viZ2rm
         qIRMiZ1GMZZo1XExqb+cdPZz5OgsyBV7KikYkbLL0yJ48fsTG3aNg4wuF5EZOWUXlBiy
         RHo445f7+HShdtKH3iK9jFYzPq2UUmMAye53HgeV2/ukrBCzmSxMUgeDyzCMPAeOuJgu
         zaZQ==
X-Gm-Message-State: ABy/qLa1/86uV3roocM7YJ/oSw8iLEc6YrsbbQfl77/HEjwmfbW0MeuM
        kAq7qQoLubg3qfi9D5dE2fU=
X-Google-Smtp-Source: APBJJlH7l55syqPc/q9I+CLF3O9P+Qe3fTUMB1ZRoQ6ggjwmtVAeLs5yjY7DNOYNoN0/a7K5z0uHMA==
X-Received: by 2002:a05:600c:364d:b0:3fb:e189:3532 with SMTP id y13-20020a05600c364d00b003fbe1893532mr8955649wmq.20.1690285598933;
        Tue, 25 Jul 2023 04:46:38 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003fbb5142c4bsm15861526wmm.18.2023.07.25.04.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 04:46:38 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bcache: remove redundant assignment to variable cur_idx
Date:   Tue, 25 Jul 2023 12:46:37 +0100
Message-Id: <20230725114637.37073-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

Variable cur_idx is being initialized with a value that is never read,
it is being re-assigned later in a while-loop. Remove the redundant
assignment. Cleans up clang scan build warning:

drivers/md/bcache/writeback.c:916:2: warning: Value stored to 'cur_idx'
is never read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/md/bcache/writeback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 24c049067f61..c3e872e0a6f2 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -913,7 +913,7 @@ static int bch_dirty_init_thread(void *arg)
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
-	cur_idx = prev_idx = 0;
+	prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
 	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
-- 
2.39.2

