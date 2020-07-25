Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262DE22D731
	for <lists+linux-bcache@lfdr.de>; Sat, 25 Jul 2020 14:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGYMCq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 25 Jul 2020 08:02:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:52110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726583AbgGYMCq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 25 Jul 2020 08:02:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 97C25AB55;
        Sat, 25 Jul 2020 12:02:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        Xu Wang <vulab@iscas.ac.cn>, Coly Li <colyli@suse.de>
Subject: [PATCH 03/25] bcache: journel: use for_each_clear_bit() to simplify the code
Date:   Sat, 25 Jul 2020 20:00:17 +0800
Message-Id: <20200725120039.91071-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200725120039.91071-1-colyli@suse.de>
References: <20200725120039.91071-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>

Using for_each_clear_bit() to simplify the code.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index d8586b6ccb76..77fbfd52edcf 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -217,10 +217,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 		 */
 		pr_debug("falling back to linear search\n");
 
-		for (l = find_first_zero_bit(bitmap, ca->sb.njournal_buckets);
-		     l < ca->sb.njournal_buckets;
-		     l = find_next_zero_bit(bitmap, ca->sb.njournal_buckets,
-					    l + 1))
+		for_each_clear_bit(l, bitmap, ca->sb.njournal_buckets)
 			if (read_bucket(l))
 				goto bsearch;
 
-- 
2.26.2

