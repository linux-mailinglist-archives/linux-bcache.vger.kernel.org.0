Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCD314F819
	for <lists+linux-bcache@lfdr.de>; Sat,  1 Feb 2020 15:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgBAOm5 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 Feb 2020 09:42:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:59082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgBAOm4 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Feb 2020 09:42:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 38DB8AAFD;
        Sat,  1 Feb 2020 14:42:55 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>
Subject: [PATCH 2/5] bcache: explicity type cast in bset_bkey_last()
Date:   Sat,  1 Feb 2020 22:42:32 +0800
Message-Id: <20200201144235.94110-3-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200201144235.94110-1-colyli@suse.de>
References: <20200201144235.94110-1-colyli@suse.de>
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In bset.h, macro bset_bkey_last() is defined as,
    bkey_idx((struct bkey *) (i)->d, (i)->keys)

Parameter i can be variable type of data structure, the macro always
works once the type of struct i has member 'd' and 'keys'.

bset_bkey_last() is also used in macro csum_set() to calculate the
checksum of a on-disk data structure. When csum_set() is used to
calculate checksum of on-disk bcache super block, the parameter 'i'
data type is struct cache_sb_disk. Inside struct cache_sb_disk (also in
struct cache_sb) the member keys is __u16 type. But bkey_idx() expects
unsigned int (a 32bit width), so there is problem when sending
parameters via stack to call bkey_idx().

Sparse tool from Intel 0day kbuild system reports this incompatible
problem. bkey_idx() is part of user space API, so the simplest fix is
to cast the (i)->keys to unsigned int type in macro bset_bkey_last().

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/bset.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index c71365e7c1fa..a50dcfda656f 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -397,7 +397,8 @@ void bch_btree_keys_stats(struct btree_keys *b, struct bset_stats *state);
 
 /* Bkey utility code */
 
-#define bset_bkey_last(i)	bkey_idx((struct bkey *) (i)->d, (i)->keys)
+#define bset_bkey_last(i)	bkey_idx((struct bkey *) (i)->d, \
+					 (unsigned int)(i)->keys)
 
 static inline struct bkey *bset_bkey_idx(struct bset *i, unsigned int idx)
 {
-- 
2.16.4

