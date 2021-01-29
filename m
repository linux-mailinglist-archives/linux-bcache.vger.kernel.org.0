Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AFF308A7E
	for <lists+linux-bcache@lfdr.de>; Fri, 29 Jan 2021 17:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhA2QnM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 29 Jan 2021 11:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbhA2Qmc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 29 Jan 2021 11:42:32 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A7EC061573
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:51 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id gx5so13918289ejb.7
        for <linux-bcache@vger.kernel.org>; Fri, 29 Jan 2021 08:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kaishome.de; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqRzbc4jSqVPxe24a+NdSB/v4f4p6uzKcOSkU+dz/zg=;
        b=V5kAlwWigtWIl+9Px+fhRjmF+WeWu2adnnTwrsApYDxYqWdAv7dSccS5TXMPhJzF/6
         fWyoTR6Yr5Mi7yCZQp5E4RvGflhKkYM/nqIYVjTuCdGLtDesNow/+VdxO8NVQILqyL4c
         YbpKj06yDd2GLeWfDHaSZX9dmxEy5/N69oTX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqRzbc4jSqVPxe24a+NdSB/v4f4p6uzKcOSkU+dz/zg=;
        b=GMyISFODFHHQhaEI4Wo5UJv+DTNmhhj4xgisEIr83fI+ZmcYFpU+wLbyWBXI3uxRjc
         OW8Liw/3ByNTOnVGav/lH5vW0xvdzyXGrMqX5SChsfBGiPJsfdFP4OFF/fF2slFfvdm7
         z8uM1F7fJwiNjxvfdtQuMhv7lxeyZvGdkjUlAzwoScL0yt1lU++ELcwaGCIPggTmTboX
         N9euddbAyISYCizkhC4tA+WUwk0lVVguhl5nLHEttbTuxTO/a8phyu2EVzAo0x9QAFU8
         m393i202M6h1md8KOVI3p2eMuoYCezKTRXAZh4GVNKK4XxCXhIA6T+fU69yCBj+6g+4x
         k2MQ==
X-Gm-Message-State: AOAM530dLlDTATGe/sx0l+v3pGUXSPEq/4Ui9SeAIWJEQjKC+Zqz7EpA
        GPBE0rBeRrwWfe3inAl7Q5EykQqyAL/VLw==
X-Google-Smtp-Source: ABdhPJwpazWEp+0XGiM7EmQoUs68ZwF+19Of2lLXe0cCwAEfADiaZQuaku0hySw0HmpWgCrQSKIsmQ==
X-Received: by 2002:a17:906:2315:: with SMTP id l21mr5576366eja.183.1611938450005;
        Fri, 29 Jan 2021 08:40:50 -0800 (PST)
Received: from jupiter.sol.kaishome.de ([2a02:8109:c40:9200::1a2])
        by smtp.gmail.com with ESMTPSA id w17sm4084187ejk.124.2021.01.29.08.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 08:40:49 -0800 (PST)
Received: (nullmailer pid 188538 invoked by uid 500);
        Fri, 29 Jan 2021 16:40:38 -0000
From:   Kai Krakow <kai@kaishome.de>
To:     linux-bcache@vger.kernel.org
Cc:     Kai Krakow <kai@kaishome.de>, Coly Li <colyli@suse.de>
Subject: [PATCH v4 2/3] bcache: Give btree_io_wq correct semantics again
Date:   Fri, 29 Jan 2021 17:40:06 +0100
Message-Id: <20210129164007.188468-2-kai@kaishome.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129164007.188468-1-kai@kaishome.de>
References: <20210127132350.557935-1-kai@kaishome.de>
 <20210129164007.188468-1-kai@kaishome.de>
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

