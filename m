Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA3D43B5266
	for <lists+linux-bcache@lfdr.de>; Sun, 27 Jun 2021 09:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhF0HVE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Jun 2021 03:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbhF0HVD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Jun 2021 03:21:03 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE38FC061574;
        Sun, 27 Jun 2021 00:18:38 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id 21so11341799pfp.3;
        Sun, 27 Jun 2021 00:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o2RTwwA9HFMbyfvHGvytJ5gvIkJZ8nO4DDEa5RPOVbk=;
        b=jBwex78p2XOU43ABZgl9o+a+y2ZXCR4aCFcdHRb1o/z0hBSW3i/2oApsc9FVmVBuQk
         +fpRiEGMdtLY3gDks0LXeEssK9N2SoKtkj+Hvwf/b715XcpQk2LwpFyOTi24Ilf/9xb4
         9M15ARBeBi8VuhCDciqFIPcQWurM+xefCEvUHRWp2nF0uk/u1Y5U4bZkzHqNDh6mJED0
         Ekfhde9eLL/alPNNCLerp+OpieBXm9LQs3p/FyBluclkwHOvjRHpB45ntRLeKkZS6I2L
         87vh34qEKK+Bl/KA+P7Dw78mvh4WXY/T5RmGxKXrNi1OGpi7fEkNssojkIAtOsyeUJr/
         nK5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o2RTwwA9HFMbyfvHGvytJ5gvIkJZ8nO4DDEa5RPOVbk=;
        b=MlUyiSpckmlhr8GvRGsyV2tpYwvzOaZWB+/XR6uJTijTckUnBOyuCcpYlMDLn+1NWh
         JL2HfowzUi36fxzyI4nxsigBB6rPMljDjA67+fGl5e1GQ3J2rIbJpJwwbXVMaHBhPTl8
         w6s78WhmqXG8g2shZZgrXk/v+ziyb/E9+X58UsSAqvmlaJMqDV5b4g2r1kVeTvb0US4d
         92js7b8xyypAOvlCyKbc7BOuo7INEXYp6OurRZRIy8HYaY02uaLP36pNdnPFxPYitwgp
         HFVSgyIcukb18cZP21hJJ8cyJlhy3C02CswnKqTlGVDTVHZjfqULidYRAlpf82paoWL6
         IOAA==
X-Gm-Message-State: AOAM532Ds7lYnnxDLvQhH+VLpeRj3HHVKF9s+PL1AcOFF2rj+Hnau4vD
        cyus6qAure9dpmhvHqwfBgQ=
X-Google-Smtp-Source: ABdhPJw9jjePxfrxOpqZB+kjTkjZn3EsF9+SLT0CwQea533wwWaK1OXq2qvVXCXYR1mtBU1jOmHCDw==
X-Received: by 2002:a63:34a:: with SMTP id 71mr17310239pgd.305.1624778318143;
        Sun, 27 Jun 2021 00:18:38 -0700 (PDT)
Received: from localhost.localdomain (v133-18-170-192.vir.kagoya.net. [133.18.170.192])
        by smtp.gmail.com with ESMTPSA id u23sm11691103pgk.38.2021.06.27.00.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 00:18:37 -0700 (PDT)
From:   Qiang Bai <chiang.bai@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiang Bai <chiang.bai@gmail.com>
Subject: [PATCH] bcache: fix cache miss's issue
Date:   Sun, 27 Jun 2021 15:18:17 +0800
Message-Id: <20210627071817.24296-1-chiang.bai@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

when cache miss's IO was done, it needs to continue the left part of IO,
not return -EINTR. -EINTR will stop the whole btree recurse.

Signed-off-by: Qiang Bai <chiang.bai@gmail.com>
---
 drivers/md/bcache/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..b6ff101d2611 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -914,7 +914,7 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	miss = bio_next_split(bio, sectors, GFP_NOIO, &s->d->bio_split);
 
 	/* btree_search_recurse()'s btree iterator is no good anymore */
-	ret = miss == bio ? MAP_DONE : -EINTR;
+	ret = miss == bio ? MAP_DONE : MAP_CONTINUE;
 
 	cache_bio = bio_alloc_bioset(GFP_NOWAIT,
 			DIV_ROUND_UP(s->insert_bio_sectors, PAGE_SECTORS),
-- 
2.31.1

