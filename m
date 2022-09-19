Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF375BD205
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Sep 2022 18:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiISQRg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 19 Sep 2022 12:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiISQRe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 19 Sep 2022 12:17:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B553AB10;
        Mon, 19 Sep 2022 09:17:29 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0BD0621D30;
        Mon, 19 Sep 2022 16:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663604248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUgloJG6yvDvYlqAJRIqdPRh1vFVa1WNGQeqOuVBkKU=;
        b=NO2qojPNBcr5/Duj8vwkudVshPzzCGqz2RPTMA4EF51ec//lLgrofyZQqAns3KVBMCGnGC
        AtF/AAFmzY+aFSSpOtWZbIsnvib5TW4CusgZlYLQvBROhmPW+a5D83AyeypdMz80x1SSq9
        hnVcohx5z49t5nrRW6l4otuwV+UQSEo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663604248;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HUgloJG6yvDvYlqAJRIqdPRh1vFVa1WNGQeqOuVBkKU=;
        b=Nfi+gjF/YJmpKvbFd9jRMjuNR9+G7iaeLwGztG8+Ge542PKWZCpJ/h/f5TOHQGKcR3hs9z
        ImA/0yb1Aci+LgAA==
Received: from localhost.localdomain (colyli.tcp.ovpn1.nue.suse.de [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id 0AE992C141;
        Mon, 19 Sep 2022 16:17:24 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Lin Feng <linf@wangsu.com>, Coly Li <colyli@suse.de>
Subject: [PATCH 2/5] bcache: remove unused bch_mark_cache_readahead function def in stats.h
Date:   Tue, 20 Sep 2022 00:16:44 +0800
Message-Id: <20220919161647.81238-3-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220919161647.81238-1-colyli@suse.de>
References: <20220919161647.81238-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Lin Feng <linf@wangsu.com>

This is a cleanup for commit 1616a4c2ab1a ("bcache: remove bcache device
self-defined readahead")', currently no user for
bch_mark_cache_readahead() since that commit.

Signed-off-by: Lin Feng <linf@wangsu.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/stats.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/stats.h b/drivers/md/bcache/stats.h
index ca4f435f7216..bd3afc856d53 100644
--- a/drivers/md/bcache/stats.h
+++ b/drivers/md/bcache/stats.h
@@ -54,7 +54,6 @@ void bch_cache_accounting_destroy(struct cache_accounting *acc);
 
 void bch_mark_cache_accounting(struct cache_set *c, struct bcache_device *d,
 			       bool hit, bool bypass);
-void bch_mark_cache_readahead(struct cache_set *c, struct bcache_device *d);
 void bch_mark_cache_miss_collision(struct cache_set *c,
 				   struct bcache_device *d);
 void bch_mark_sectors_bypassed(struct cache_set *c,
-- 
2.35.3

