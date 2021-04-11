Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62ECC35B4C7
	for <lists+linux-bcache@lfdr.de>; Sun, 11 Apr 2021 15:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhDKNoK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 11 Apr 2021 09:44:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:47526 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235680AbhDKNoE (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 11 Apr 2021 09:44:04 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35E42AFF4;
        Sun, 11 Apr 2021 13:43:47 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Coly Li <colyli@suse.de>
Subject: [PATCH 4/7] md: bcache: avoid -Wempty-body warnings
Date:   Sun, 11 Apr 2021 21:43:13 +0800
Message-Id: <20210411134316.80274-5-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210411134316.80274-1-colyli@suse.de>
References: <20210411134316.80274-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

building with 'make W=1' shows a harmless warning for each user of the
EBUG_ON() macro:

drivers/md/bcache/bset.c: In function 'bch_btree_sort_partial':
drivers/md/bcache/util.h:30:55: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
   30 | #define EBUG_ON(cond)                   do { if (cond); } while (0)
      |                                                       ^
drivers/md/bcache/bset.c:1312:9: note: in expansion of macro 'EBUG_ON'
 1312 |         EBUG_ON(oldsize >= 0 && bch_count_data(b) != oldsize);
      |         ^~~~~~~

Reword the macro slightly to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Coly Li <colyli@suse.de>
---
 drivers/md/bcache/util.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.h b/drivers/md/bcache/util.h
index c029f7443190..bca4a7c97da7 100644
--- a/drivers/md/bcache/util.h
+++ b/drivers/md/bcache/util.h
@@ -27,7 +27,7 @@ struct closure;
 
 #else /* DEBUG */
 
-#define EBUG_ON(cond)			do { if (cond); } while (0)
+#define EBUG_ON(cond)		do { if (cond) do {} while (0); } while (0)
 #define atomic_dec_bug(v)	atomic_dec(v)
 #define atomic_inc_bug(v, i)	atomic_inc(v)
 
-- 
2.26.2

