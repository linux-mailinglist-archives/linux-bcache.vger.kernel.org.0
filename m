Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BDA343E58
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Mar 2021 11:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhCVKsx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 22 Mar 2021 06:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhCVKsS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 22 Mar 2021 06:48:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 806726191E;
        Mon, 22 Mar 2021 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616410098;
        bh=ABUH0zwdxI928odcJLs6iIYRehnrNAB/UTWqahfQtr4=;
        h=From:To:Cc:Subject:Date:From;
        b=Y5oLFOtDZqib2GkrGm61+Ad1JnLQSSmvBEfY9Pz0YHph4UGdqa2/2qYjqs9JopTsq
         1J3DKI5d1mWZQDK+JrwjPLp2Fhu9Lft2wUbc6xXQsL3MZRbxmRw/fZs25uYC6VLOPo
         A5Sb4AKarUnfsmkgKnJy736vzdepSTk1ccMKW8uC7GjIcrMp4V4VZcwsfPPLhPmUMU
         7M9yuAfAilVkI8A9NOMUVo8io/HSmVd7/caSMfH8H0mIYm/culDebFAsmzk8fKrTMT
         1uifjbw9RXjCziflGp506Qd2rm9uzIgebRXApndppnZ3+8U+udGDWWJVmjoFJcpOQt
         2sVH9uVb4KlYw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] md: bcache: avoid -Wempty-body warnings
Date:   Mon, 22 Mar 2021 11:48:10 +0100
Message-Id: <20210322104815.1085673-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
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
2.29.2

