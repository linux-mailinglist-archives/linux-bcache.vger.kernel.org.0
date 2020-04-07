Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524C819EF4A
	for <lists+linux-bcache@lfdr.de>; Mon,  6 Apr 2020 04:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgDFCZS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 5 Apr 2020 22:25:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12614 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726408AbgDFCZS (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 5 Apr 2020 22:25:18 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 92FEE7A9492A172FF0F7;
        Mon,  6 Apr 2020 10:25:08 +0800 (CST)
Received: from huawei.com (10.175.112.70) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 6 Apr 2020
 10:25:02 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <colyli@suse.de>, <kent.overstreet@gmail.com>
CC:     <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wanghai38@huawei.com>
Subject: [PATCH] bcache: remove set but not used variable 'i'
Date:   Tue, 7 Apr 2020 07:36:47 -0400
Message-ID: <1586259407-23673-1-git-send-email-wanghai38@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/md/bcache/btree.c: In function bch_btree_check_thread:
drivers/md/bcache/btree.c:1910:6: warning:
 variable ‘i’ set but not used [-Wunused-but-set-variable]

It's not used since commit 8e7102273f59 ("bcache: make bch_btree_check()
to be multithreaded"), so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/md/bcache/btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 72856e5..b962313 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1907,10 +1907,10 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i, n;
+	int n;
 
 	k = p = NULL;
-	i = n = 0;
+	n = 0;
 	cur_idx = prev_idx = 0;
 	ret = 0;
 
-- 
1.8.3.1

