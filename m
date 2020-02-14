Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 812AF15E376
	for <lists+linux-bcache@lfdr.de>; Fri, 14 Feb 2020 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406139AbgBNQaO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 14 Feb 2020 11:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406418AbgBNQ00 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 14 Feb 2020 11:26:26 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EDFA246FE;
        Fri, 14 Feb 2020 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697586;
        bh=RQoQ8frxlbI1QjilHnH3/LmzPQ60HcJMzxc+C18UY60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0wc5Bq/sIs6GLxu61NU0WVHIT42o3oF5eAEsXNUvypnqzdacXv5sGHRrKAj4GG4sM
         qnFKAo3fciHoeuAqTP2XDTAWCDyqU02n8UPC22VY9IFAyCxj/U3KjI+lAvnmmBQyi5
         ax6OhZxvtpyhD6zGYpFK0WJpIgVQPSOEngPmaDvk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, kbuild test robot <lkp@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 097/100] bcache: explicity type cast in bset_bkey_last()
Date:   Fri, 14 Feb 2020 11:24:21 -0500
Message-Id: <20200214162425.21071-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162425.21071-1-sashal@kernel.org>
References: <20200214162425.21071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit 7c02b0055f774ed9afb6e1c7724f33bf148ffdc0 ]

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bset.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index b935839ab79c6..f483041eed986 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -380,7 +380,8 @@ void bch_btree_keys_stats(struct btree_keys *, struct bset_stats *);
 
 /* Bkey utility code */
 
-#define bset_bkey_last(i)	bkey_idx((struct bkey *) (i)->d, (i)->keys)
+#define bset_bkey_last(i)	bkey_idx((struct bkey *) (i)->d, \
+					 (unsigned int)(i)->keys)
 
 static inline struct bkey *bset_bkey_idx(struct bset *i, unsigned idx)
 {
-- 
2.20.1

