Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A51586279
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Aug 2022 04:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbiHACSu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 31 Jul 2022 22:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238175AbiHACSt (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 31 Jul 2022 22:18:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A08EBC8D;
        Sun, 31 Jul 2022 19:18:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t22so1471450pjy.1;
        Sun, 31 Jul 2022 19:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=8v6YfTftY6eeqzbADFfuOraJzoQUoD8FiPtSyDu2jTA=;
        b=D7CgGjhio/WU48k9hJ8tGz9WTIqWJYrYB0zFUJfKNzh/5m4rgrKGH7SXN0P0vnj8Nz
         fU7TmSEN9awSX5P32FH11CYtiLyDeWrljwRNGT5ovQQJBh1l8ndTMyibTblZBP6zXjR8
         hrWDkuNiZswEIBH8QQNedvch96HPrH1rKkFTmrPb7eaoE2PfDNEUXpjtnIXDkr2X/RDs
         VtTNnBdjQFISE6Rs49qw3gV6erb24B3ujqzGqSIaNgXA9vww2m7T2C9cX6f27AOv4l5X
         a+NR5bMuQ0+E3F8JheryFwZCaj1jf0g87BPLZUmjjuofG7cFUE322mrNBUYcL8hAW2p4
         sJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=8v6YfTftY6eeqzbADFfuOraJzoQUoD8FiPtSyDu2jTA=;
        b=7d23QyBqPzzW8GRhxazmoBnMIRelR4iyJ9TL41EE45emLLAhFWOk3j++Hp8PKBiBSY
         pbUwB7MHpmos7t8Te4mbTPypLDlCDU79rvDpIR2lIKZwZLjuyOmtLl14GZu0gjlzbshC
         8r8ESJAQR3xsXmJylvk8g62oQN1WdcjXq8q6531/ZQpwg7NUdgr2qVqBfb+HYSSns0La
         kOfv43myAO8l+7x6WwIcy60WBARxwxh35t652wzz0mujSlCX3uFQYplQ8z+zEV+w+AGN
         8IkvUMt4FJWLdsgxD+AASvn6Tm8CXhNUtruLgQb9IyIK8L81EWQcxNrVffs1TtNbJmBH
         R24g==
X-Gm-Message-State: ACgBeo3FGdTXy0iyHN8fQRFWqRhJ5qP1z5mWAP7WuC40uddLwozp/w+q
        OXQrdoC3KO/AlCrEa3KMvPBlRRi0jGI=
X-Google-Smtp-Source: AA6agR7omm3rpnYGqkbj9mfcJPF0MmbCZn55+ClEU+7r7ZXC4ag50isksCRbT0xu9+zTfbujQ3HE+w==
X-Received: by 2002:a17:90b:4a86:b0:1f3:b701:87d6 with SMTP id lp6-20020a17090b4a8600b001f3b70187d6mr13257841pjb.213.1659320327430;
        Sun, 31 Jul 2022 19:18:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m13-20020a6545cd000000b0041c1965dd96sm828884pgr.27.2022.07.31.19.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 19:18:47 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: ye.xingchen@zte.com.cn
To:     linux-kernel@vger.kernel.org
Cc:     linux-bcache@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] bcache: writeback:Remove the redundant 'flush_workqueue()' calls
Date:   Mon,  1 Aug 2022 02:18:42 +0000
Message-Id: <20220801021842.1594130-1-ye.xingchen@zte.com.cn>
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

From: ye xingchen <ye.xingchen@zte.com.cn>

calls 'destroy_workqueue()' already drains the queue before destroying it,
so there is no need to flush it explicitly.So,remove the redundant
'flush_workqueue()' calls.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 drivers/md/bcache/writeback.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 3f0ff3aab6f2..fd48a09e6096 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -802,7 +802,6 @@ static int bch_writeback_thread(void *arg)
 	}
 
 	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
 		destroy_workqueue(dc->writeback_write_wq);
 	}
 	cached_dev_put(dc);
-- 
2.25.1

