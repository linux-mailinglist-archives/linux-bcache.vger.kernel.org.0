Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0854D10584
	for <lists+linux-bcache@lfdr.de>; Wed,  1 May 2019 08:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfEAGmc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 May 2019 02:42:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:53184 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725776AbfEAGmc (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 May 2019 02:42:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CF5BCAE47;
        Wed,  1 May 2019 06:42:30 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        juha.aatrokoski@aalto.fi, shhuiw@foxmail.com,
        Coly Li <colyli@suse.de>
Subject: [PATCH v2] bcache: remove redundant LIST_HEAD(journal) from run_cache_set()
Date:   Wed,  1 May 2019 14:42:22 +0800
Message-Id: <20190501064222.34585-1-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Commit 95f18c9d1310 ("bcache: avoid potential memleak of list of
journal_replay(s) in the CACHE_SYNC branch of run_cache_set") forgets
to remove the original define of LIST_HEAD(journal), which makes
the change no take effect. This patch removes redundant variable
LIST_HEAD(journal) from run_cache_set(), to make Shenghui's fix
working.

Fixes: 95f18c9d1310 ("bcache: avoid potential memleak of list of journal_replay(s) in the CACHE_SYNC branch of run_cache_set")
Reported-by: Juha Aatrokoski <juha.aatrokoski@aalto.fi>
Cc: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 0ffe9acee9d8..1b63ac876169 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1800,7 +1800,6 @@ static int run_cache_set(struct cache_set *c)
 	set_gc_sectors(c);
 
 	if (CACHE_SYNC(&c->sb)) {
-		LIST_HEAD(journal);
 		struct bkey *k;
 		struct jset *j;
 
-- 
2.16.4

