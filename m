Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5831599A2
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Jun 2019 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfF1MAX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Jun 2019 08:00:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:54120 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfF1MAX (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Jun 2019 08:00:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2FEFDB632;
        Fri, 28 Jun 2019 12:00:22 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 03/37] bcache: fix return value error in bch_journal_read()
Date:   Fri, 28 Jun 2019 19:59:26 +0800
Message-Id: <20190628120000.40753-4-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190628120000.40753-1-colyli@suse.de>
References: <20190628120000.40753-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

When everything is OK in bch_journal_read(), finally the return value
is returned by,
	return ret;
which assumes ret will be 0 here. This assumption is wrong when all
journal buckets as are full and filled with valid journal entries. In
such cache the last location referencess read_bucket() sets 'ret' to
1, which means new jset added into jset list. The jset list is list
'journal' in caller run_cache_set().

Return 1 to run_cache_set() means something wrong and the cache set
won't start, but indeed everything is OK.

This patch changes the line at end of bch_journal_read() to directly
return 0 since everything if verything is good. Then a bogus error
is fixed.

Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/journal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 12dae9348147..4e5fc05720fc 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -268,7 +268,7 @@ int bch_journal_read(struct cache_set *c, struct list_head *list)
 					    struct journal_replay,
 					    list)->j.seq;
 
-	return ret;
+	return 0;
 #undef read_bucket
 }
 
-- 
2.16.4

