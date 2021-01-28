Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08E83081D4
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 00:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhA1X3S (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 28 Jan 2021 18:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhA1X3R (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 28 Jan 2021 18:29:17 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB75C061574
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:36 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s11so8582613edd.5
        for <linux-bcache@vger.kernel.org>; Thu, 28 Jan 2021 15:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqRzbc4jSqVPxe24a+NdSB/v4f4p6uzKcOSkU+dz/zg=;
        b=a00k4oPWSTTWeGcXVVXA+EcEXhnbvKiFl4GSF0yBSafOadrH/F7vORaM9rCqlH9Mg1
         Y4KUc5l4FDLNYjUqdxdO2BVnKehwzjv6NIDqRNtWCcTVs8Y4LeZud7DvEcgclDSkVl8c
         caBMr5s41S9ohxkfnUnEtJlYqE4C889d1f0dA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqRzbc4jSqVPxe24a+NdSB/v4f4p6uzKcOSkU+dz/zg=;
        b=f6jBDQZ83WbLroxi+2NvcUPRFpL/rysWqrQb1BS9ox13RN4UDeCE6rOAOUntpiUpI3
         BypTGaZWxEoBjRmywiOafBspz4Uv2jkeEEIyvFrwiD4fBSJ2K0yS8J/03fuR4kRNNdlT
         GfSOamJkQ4iT1mPTqiy3Y+Lk330+v5BCihOJWlFNDqbDJh/MSi4RP8YHAmKcRyILqIIG
         19yTkufWuj1Tgn7twi+8HUwjzFNZKNs/exQbF5IrO3byaD6vxgy+wD+dV9cX1enjPU34
         WVmvfxj7AngD4LHJoNWYguFJKfh7H+w2dGYVjG7wVb/h5eMkAFnRpWc9/UwhaECnmYTe
         Cx3w==
X-Gm-Message-State: AOAM532Vp69kqvHj+rjOIPtlhMUmsdtfPACf7VMCEkVjfIwEKPiF0BWT
        6u2xi34nKV5KXKpSGcu6n/VZ00voOB0ycQ==
X-Google-Smtp-Source: ABdhPJztYJ+Z/YVklPovw+KGhLNdBGO8oJMm7acLKdzKjccF9Wx43j3C2yZ4oB+u72nOiZ8srcWsUw==
X-Received: by 2002:aa7:de8f:: with SMTP id j15mr2286228edv.268.1611876515461;
        Thu, 28 Jan 2021 15:28:35 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id q26sm2937883ejr.97.2021.01.28.15.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 15:28:34 -0800 (PST)
Received: (nullmailer pid 21266 invoked by uid 500);
        Thu, 28 Jan 2021 23:28:33 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v3 2/3] bcache: Give btree_io_wq correct semantics again
Date:   Fri, 29 Jan 2021 00:28:24 +0100
Message-Id: <20210128232825.18719-2-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128232825.18719-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210128232825.18719-1-kai@kaishome.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Before killing `btree_io_wq`, the queue was allocated using
`create_singlethread_workqueue()` which has `WQ_MEM_RECLAIM`. After
killing it, it no longer had this property but `system_wq` is not
single threaded.

Let's combine both worlds and make it multi threaded but able to
reclaim memory.

Cc: Coly Li <colyli@suse.de>
Signed-off-by: Kai Krakow <kai@kaishome.de>
---
 drivers/md/bcache/btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 952f022db5a5f..fe6dce125aba2 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2775,7 +2775,7 @@ void bch_btree_exit(void)
 
 int __init bch_btree_init(void)
 {
-	btree_io_wq = create_singlethread_workqueue("bch_btree_io");
+	btree_io_wq = alloc_workqueue("bch_btree_io", WQ_MEM_RECLAIM, 0);
 	if (!btree_io_wq)
 		return -ENOMEM;
 
-- 
2.26.2

