Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C551632DFBB
	for <lists+linux-bcache@lfdr.de>; Fri,  5 Mar 2021 03:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhCECqR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 4 Mar 2021 21:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhCECqR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 4 Mar 2021 21:46:17 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512AEC061574;
        Thu,  4 Mar 2021 18:46:17 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id jx13so962527pjb.1;
        Thu, 04 Mar 2021 18:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=v9avNw3KeEhPb5xp/DWoJDPbUk/CHs7jfxZFL5Gh7U0=;
        b=KlIFBw63q5TBbBPaBTgiJg+7JV13Gs+ARdQbdR5HzolTyqUXo98SWWBV7vth9s4tMp
         kJWYPBdGB+s5Ey571uy79mFOFvwbuZKCh3HYx9cuZhjM6SmvDCDFwRVq8E+RwfyrOnql
         bQVHTEgGWF9ElunKS9kM+HhD2jWpof46d/iFFZSScrOxyE4MDwG62GBXJf0HijV1wrPs
         RaeRBtEgWiLRamhlZVdIK0QCrtJoZ5r6hwVRfvq0FR4D68QKHk5StQWO3PmjbP8C44U6
         d6z9AeH0d1WtRUFGgDXbd3iHJmpR2Sd/9ByKVmPc3Qd/H+WApC9NtKp7mQ2tKZld4n3C
         ZOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v9avNw3KeEhPb5xp/DWoJDPbUk/CHs7jfxZFL5Gh7U0=;
        b=RCNRZEIgIBQg/2HaVeA8UDGuREqWT/pWBjDJ5mE17tyQwJDXmXbisV4EDvctMWih8r
         VncLZe5dOAppIjh46w6H3pSaqGeCmpYEOJuCzD8NKQIV+v1h0bm/O/p/oDaX9xtFzXB7
         tINMPN/kWsMWrW1wP6hO1m8Yxz8aMiDgSIMfbSwpvJehbZTV9D/Z8jNHAJmb/NQIKmBa
         G9/+1y1xegtZr5EZwyKNx8pyp0IdxFDQ4/4l15JHjfOmWFsc/LI15SEDZUQJGg6oAJsv
         wsOpaYFXoxeav5qEvwyqWOAN0pIT595IsLPbkUdWZHlOBuE6J+oNegKdx5kO3CL640+5
         eLuQ==
X-Gm-Message-State: AOAM5302awIqSjGMHzYp3Gj807O9MFmSj/bbswwbsbl3rtEItuoPcX0I
        qD0dvMSFya7jOP0Ln6/LYbgBLrZ74wlwvA==
X-Google-Smtp-Source: ABdhPJwB/20yU5YGDtf0TeDTbWkO4gioSehcrwpQl/MAQH8aQSPlqYrKgORb7nLYnLUyR4j3B3nyRA==
X-Received: by 2002:a17:90a:ce0c:: with SMTP id f12mr7823847pju.11.1614912376972;
        Thu, 04 Mar 2021 18:46:16 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.129])
        by smtp.gmail.com with ESMTPSA id n5sm656926pfq.44.2021.03.04.18.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 18:46:16 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] md: bcache: fix error return code of cached_dev_cache_miss()
Date:   Thu,  4 Mar 2021 18:46:09 -0800
Message-Id: <20210305024609.4880-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When bch_bio_alloc_pages() fails, no error return code of 
cached_dev_cache_miss() is assigned.
To fix this bug, ret is assigned with -ENOMEN as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/md/bcache/request.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 29c231758293..9ecaf26c8d60 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -930,8 +930,10 @@ static int cached_dev_cache_miss(struct btree *b, struct search *s,
 	cache_bio->bi_private	= &s->cl;
 
 	bch_bio_map(cache_bio, NULL);
-	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO))
+	if (bch_bio_alloc_pages(cache_bio, __GFP_NOWARN|GFP_NOIO)) {
+		ret = -ENOMEM;
 		goto out_put;
+	}
 
 	if (reada)
 		bch_mark_cache_readahead(s->iop.c, s->d);
-- 
2.17.1

