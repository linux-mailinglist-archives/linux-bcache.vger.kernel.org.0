Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02D3319F2C
	for <lists+linux-bcache@lfdr.de>; Fri, 12 Feb 2021 13:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhBLMw0 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 12 Feb 2021 07:52:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:58112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231700AbhBLMvO (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 12 Feb 2021 07:51:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6AE164E16;
        Fri, 12 Feb 2021 12:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613134231;
        bh=rnXOqI0luJangx2CzFBf1733EK1II/gZ616cSb9TWZg=;
        h=Date:From:To:Cc:Subject:From;
        b=iy2YldALxmZoGeDz+0/8X9gfYRbsSO4ppZjp/fE2Z6KCNV62mebw5FbgKQ/D+DYQP
         BEvaKe9e+zTafwHYKaO4Ucb3ComLISehaYBVMfySG+/+9Wst2P5Zqkdt3uM4cbMfhf
         fuM9V50621iZBBWCL22mxZ1L2MXoA9anF/bfV6/zbwTn7W7nTPaoDWcnby1YWQcY7m
         a2qo4wUKS3DCsguETDISfpmC3aItGXMizuOGMKHE/5vETZrsfhtG2npuLD/8d1tpvZ
         69X4z0Uq3oTGZFEsQ3o5OFqnUan/h7DQLumQpv15orV5nDaFwNmLBkO4G+twLnYqov
         isi/8FntPKnHQ==
Date:   Fri, 12 Feb 2021 06:50:28 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christina Jacob <cjacob@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] bcache: Use 64-bit arithmetic instead of 32-bit
Message-ID: <20210212125028.GA264620@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

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
---
 drivers/md/bcache/writeback.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 82d4e0880a99..4fb635c0baa0 100644
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
2.27.0

