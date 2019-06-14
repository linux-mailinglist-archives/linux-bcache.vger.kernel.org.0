Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71BF245DBE
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Jun 2019 15:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfFNNO4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Jun 2019 09:14:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:45858 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727766AbfFNNOz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Jun 2019 09:14:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5AE11AE07;
        Fri, 14 Jun 2019 13:14:54 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [PATCH 13/29] bcache: remove "XXX:" comment line from run_cache_set()
Date:   Fri, 14 Jun 2019 21:13:42 +0800
Message-Id: <20190614131358.2771-14-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
References: <20190614131358.2771-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In previous bcache patches for Linux v5.2, the failure code path of
run_cache_set() is tested and fixed. So now the following comment
line can be removed from run_cache_set(),
	/* XXX: test this, it's broken */

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 877113b62b0f..3364b20567eb 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1946,7 +1946,7 @@ static int run_cache_set(struct cache_set *c)
 	}
 
 	closure_sync(&cl);
-	/* XXX: test this, it's broken */
+
 	bch_cache_set_error(c, "%s", err);
 
 	return -EIO;
-- 
2.16.4

