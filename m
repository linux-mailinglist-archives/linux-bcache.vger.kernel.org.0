Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF5D633B3
	for <lists+linux-bcache@lfdr.de>; Tue,  9 Jul 2019 11:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfGIJxp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 9 Jul 2019 05:53:45 -0400
Received: from smtpbg507.qq.com ([203.205.250.51]:60442 "EHLO smtpbg.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726126AbfGIJxp (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 9 Jul 2019 05:53:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1562666020;
        bh=wFvQP6I4IYRiRn3obs1ZYJq0esRiTLIG0E9elYXCZ3A=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=feJtkgwbPD6NJ5ijAPBp7/8DosdjIA5B2JBxVqmUISQ8qbWrrWDbgovC7G11SpUGX
         EvMwaUY5tfWMGwiPgbe/WgsVYNbcX+sNs/Szvg/qCMVywYixU21FGYldi3AcLKcYUm
         Vs7OuPt3Bk9qsTOVLeJ3RUBA4KEwxH09g7MEIUiU=
X-QQ-mid: esmtp5t1562665584tla8gjhnn
Received: from localhost.localdomain (unknown [221.220.250.51])
        by esmtp4.qq.com (ESMTP) with 
        id ; Tue, 09 Jul 2019 17:46:23 +0800 (CST)
X-QQ-SSF: 01010000000000F0FH4000000000000
X-QQ-FEAT: 5GknEzJPEhs4Ux2yVnSJSBx62XLQcutflWPYl1G7OsWd+XqM1KI2js4IC21bs
        I+I4PCLg42gOaIulhxSiK77nvcrGvJ3lKkPK/cB/6+xiQu2zOyw72RREtIbM98rOKiF87DS
        Abxne5X7SGVudyf54iL0LX2q3FZT6z47wtTrVMMrY99NcJagqkup/2cuJLAYzYXnIFDbFd9
        lZCpVJ+tIz/i3WhZ6fiz7P7wY/T6mypmqCH8YxkGH1vFc0WxtSUCC6MvwWG5xuw1Ese0rsk
        SiDFKJfupGOfkQRGA/JPwlEHI=
X-QQ-GoodBg: 0
From:   Shenghui Wang <shhuiw@foxmail.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Subject: [PATCH 2/2] bcache: remove ptr_available check in btree_ptr_bad_expensive
Date:   Tue,  9 Jul 2019 17:46:06 +0800
Message-Id: <20190709094606.15746-3-shhuiw@foxmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190709094606.15746-1-shhuiw@foxmail.com>
References: <20190709094606.15746-1-shhuiw@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtp:foxmail.com:bgweb:bgweb2
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

btree_ptr_bad_expensive() is called by bch_btree_ptr_bad() only.
Before the invocation, ptr_available() check already done in
bch_btree_ptr_bad():
'''
	...
	for (i = 0; i < KEY_PTRS(k); i++)
		if (!ptr_available(b->c, k, i) ||
		    ptr_stale(b->c, k, i))
			return true;

	if (expensive_debug_checks(b->c) &&
	    btree_ptr_bad_expensive(b, k))
		return true;
	...
'''
Remove redundant ptr_available() check in btree_ptr_bad_expensive().

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
---
 drivers/md/bcache/extents.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 5a05407a8126..abcf783839c8 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -177,16 +177,15 @@ static bool btree_ptr_bad_expensive(struct btree *b, const struct bkey *k)
 	struct bucket *g;
 
 	if (mutex_trylock(&b->c->bucket_lock)) {
-		for (i = 0; i < KEY_PTRS(k); i++)
-			if (ptr_available(b->c, k, i)) {
-				g = PTR_BUCKET(b->c, k, i);
-
-				if (KEY_DIRTY(k) ||
-				    g->prio != BTREE_PRIO ||
-				    (b->c->gc_mark_valid &&
-				     GC_MARK(g) != GC_MARK_METADATA))
-					goto err;
-			}
+		for (i = 0; i < KEY_PTRS(k); i++) {
+			g = PTR_BUCKET(b->c, k, i);
+
+			if (KEY_DIRTY(k) ||
+			    g->prio != BTREE_PRIO ||
+			    (b->c->gc_mark_valid &&
+			     GC_MARK(g) != GC_MARK_METADATA))
+				goto err;
+		}
 
 		mutex_unlock(&b->c->bucket_lock);
 	}
-- 
2.20.1

