Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549B21E2635
	for <lists+linux-bcache@lfdr.de>; Tue, 26 May 2020 17:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgEZP7m (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 May 2020 11:59:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:45944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbgEZP7m (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 May 2020 11:59:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id B4D49AD17;
        Tue, 26 May 2020 15:59:43 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 1/5] bcache: remove redundant variables i and n
Date:   Tue, 26 May 2020 23:59:24 +0800
Message-Id: <20200526155928.32036-2-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200526155928.32036-1-colyli@suse.de>
References: <20200526155928.32036-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variables i and n are being assigned but are never used. They are
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72856e5f23a3..114d0d73d909 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1907,10 +1907,8 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i, n;
 
 	k = p = NULL;
-	i = n = 0;
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
-- 
2.25.0

