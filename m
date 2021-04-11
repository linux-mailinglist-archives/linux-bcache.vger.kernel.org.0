Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C0935B4FE
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 15:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235983AbhDKNog (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 09:44:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:47568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235822AbhDKNoM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:44:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F22A5AD2D;
        Sun, 11 Apr 2021 13:43:54 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Coly Li <colyli@suse.de>
Subject: [PATCH 6/7] bcache: Use 64-bit arithmetic instead of 32-bit
Date:   Sun, 11 Apr 2021 21:43:15 +0800
Message-Id: <20210411134316.80274-7-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
References: <20210411134316.80274-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Cast multiple variables to (int64_t) in order to give the compiler
complete information about the proper arithmetic to use. Notice that
these variables are being used in contexts that expect expressions of
type int64_t  (64 bit, signed). And currently, such expressions are
being evaluated using 32-bit arithmetic.

Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
Addresses-Coverity-ID: 1501724 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1501725 ("Unintentional integer overflow")
Addresses-Coverity-ID: 1501726 ("Unintentional integer overflow")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index bcd550a2b0da..8120da278161 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -110,13 +110,13 @@ static void __update_writeback_rate(struct cached_dev *dc)
 		int64_t fps;
 
 		if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID) {
-			fp_term = dc->writeback_rate_fp_term_low *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_low *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_LOW);
 		} else if (c->gc_stats.in_use <= BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH) {
-			fp_term = dc->writeback_rate_fp_term_mid *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_mid *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_MID);
 		} else {
-			fp_term = dc->writeback_rate_fp_term_high *
+			fp_term = (int64_t)dc->writeback_rate_fp_term_high *
 			(c->gc_stats.in_use - BCH_WRITEBACK_FRAGMENT_THRESHOLD_HIGH);
 		}
 		fps = div_s64(dirty, dirty_buckets) * fp_term;
-- 
2.26.2

