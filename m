Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D2C24E72F
	for <lists+linux-bcache@lfdr.de>; Sat, 22 Aug 2020 13:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgHVLqC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 22 Aug 2020 07:46:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:56750 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgHVLp7 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 22 Aug 2020 07:45:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BA135AD2C;
        Sat, 22 Aug 2020 11:46:26 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 06/12] bcache: remove useless alloc_bucket_pages()
Date:   Sat, 22 Aug 2020 19:45:30 +0800
Message-Id: <20200822114536.23491-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200822114536.23491-1-colyli@suse.de>
References: <20200822114536.23491-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Now no one uses alloc_bucket_pages() anymore, remove it from bcache.h.

Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/bcache/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 36a538c2e960..28257f11d835 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1832,9 +1832,6 @@ void bch_cache_set_unregister(struct cache_set *c)
 	bch_cache_set_stop(c);
 }
 
-#define alloc_bucket_pages(gfp, c)			\
-	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(bucket_pages(c))))
-
 #define alloc_meta_bucket_pages(gfp, sb)		\
 	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(meta_bucket_pages(sb))))
 
-- 
2.26.2

