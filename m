Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54FC10F5F5
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Dec 2019 04:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLCDwp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Dec 2019 22:52:45 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38177 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLCDwp (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Dec 2019 22:52:45 -0500
Received: by mail-pl1-f195.google.com with SMTP id o8so1123913pls.5;
        Mon, 02 Dec 2019 19:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WFPxR8j8Ztw3QpWL9VkRXvZS+yt+ltqE6fy7Q8AVdEU=;
        b=oDGWBbGaEAdv/Tjq+aQgC6JgVI+zjjUkguaejS3WXRSvTAjQuNmVZEIw8at6VqbZ/C
         w22kRTOZ0dwKZRvBBRWpDodDadUcX71J61eSF8xaxQBAH3BgHC8YnA40iSo1QTjgDmEd
         L49Egm4Ea4oOKoKM/rUtS9clmCglpfMoAQn0ueTlQTrJwEPSBaoK3Qcvh/kOVH32ePFK
         Ta4x3WHPnKsBzzpIOATXki7MIxOJdIEfx3bmzOKLDkBU32syQVVCvIe787DzTRLh6hrr
         QZTE6a/J5Mq8B+fb3MI+AK0190JQRhrRi39SYC6YqMUPDcazLgy7TY30ce8bWxMEeQUj
         YtHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WFPxR8j8Ztw3QpWL9VkRXvZS+yt+ltqE6fy7Q8AVdEU=;
        b=a3kLN8vI6mCC891RUbodSMmyUHtX5GbGi21uMJ6/4FpYIkr9mnCyaGaofjdGt8TqTi
         jyAMpoTL5nySn+B6jthu+EtYN8t9upyxy5i0peDFaqSXYGHScs4gNyEttT2Hl8psFyzl
         2rZGDca/9eFZv92OCMcsy+4nDZ7SOo/iKaj+JYze/JjsXWU/BVhEonFLbz8kvJTY2598
         9PlFKLdctyZmxKq50GhQoXENSRP104/SlJXJsSQVXJgWZ4Y87b1ylWf8v8rajmz9e/6W
         v1xIKe5XgIVhbQFN6pwPdue+1qihuuLtl5iSUNYoPV4MxhHqZpZuYFKsszr1NvKVg7G9
         Zudg==
X-Gm-Message-State: APjAAAUkXFecCZ1riDNLGiohUfuiyCQzI6O14RK+uVg8aEJJjmjAWTy6
        CXjJmeZZ57g2yunZcmZROdI=
X-Google-Smtp-Source: APXvYqzieSs1UI75yXehyUjLI9b+KyuJgvG4DNnaak5PZ4QOKccR85gkkaDwsfT2lzNyUfk2PbNyGA==
X-Received: by 2002:a17:902:14f:: with SMTP id 73mr2953143plb.19.1575345165095;
        Mon, 02 Dec 2019 19:52:45 -0800 (PST)
Received: from localhost.localdomain (23.83.226.166.16clouds.com. [23.83.226.166])
        by smtp.gmail.com with ESMTPSA id l9sm1111206pgh.34.2019.12.02.19.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2019 19:52:44 -0800 (PST)
From:   Guoju Fang <fangguoju@gmail.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Guoju Fang <fangguoju@gmail.com>
Subject: [PATCH] bcache: print written and keys in trace_bcache_btree_write
Date:   Mon,  2 Dec 2019 22:48:41 -0500
Message-Id: <1575344921-20254-1-git-send-email-fangguoju@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

It's useful to dump written block and keys on btree write, this patch
add them into trace_bcache_btree_write.

Signed-off-by: Guoju Fang <fangguoju@gmail.com>
---
 include/trace/events/bcache.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/bcache.h b/include/trace/events/bcache.h
index e4526f8..0bddea6 100644
--- a/include/trace/events/bcache.h
+++ b/include/trace/events/bcache.h
@@ -275,7 +275,8 @@
 		__entry->keys	= b->keys.set[b->keys.nsets].data->keys;
 	),
 
-	TP_printk("bucket %zu", __entry->bucket)
+	TP_printk("bucket %zu written block %u + %u",
+		__entry->bucket, __entry->block, __entry->keys)
 );
 
 DEFINE_EVENT(btree_node, bcache_btree_node_alloc,
-- 
1.8.3.1

