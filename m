Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB0D1E36C9
	for <lists+linux-bcache@lfdr.de>; Wed, 27 May 2020 06:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgE0ECr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 27 May 2020 00:02:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:57340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgE0ECq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 27 May 2020 00:02:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 604D3AEEF;
        Wed, 27 May 2020 04:02:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Colin Ian King <colin.king@canonical.com>,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2 1/5] bcache: remove redundant variables i and n
Date:   Wed, 27 May 2020 12:01:51 +0800
Message-Id: <20200527040155.43690-2-colyli@suse.de>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200527040155.43690-1-colyli@suse.de>
References: <20200527040155.43690-1-colyli@suse.de>
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

