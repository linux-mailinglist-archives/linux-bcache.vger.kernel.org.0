Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BBC2745F6
	for <lists+linux-bcache@lfdr.de>; Tue, 22 Sep 2020 18:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgIVQCD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 22 Sep 2020 12:02:03 -0400
Received: from mail-m965.mail.126.com ([123.126.96.5]:48378 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgIVQCD (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 22 Sep 2020 12:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=iwLNfioL3ibzOJGkWO
        C4ttL5Ajnu56+SYdrHMbfMujY=; b=KC23QRliQfCikOkp54vRgNuyG7K/zRoOQL
        RG0mKHTYkZ+gUjtwE/sS8KvXUtegYYvPAo20X5/WdJZYtBC8O3/a7Us0IcCasNN1
        EjB1/n8tIeDeYbRh5tivP9YE1AIvvCXXVfWlgt2Mp0FF72Mm/KcAaXTfPhb8U1FK
        AXSXAVHR0=
Received: from localhost.localdomain (unknown [114.247.113.140])
        by smtp10 (Coremail) with SMTP id NuRpCgCXq7tCGGpf9GPKcQ--.6328S2;
        Tue, 22 Sep 2020 23:29:08 +0800 (CST)
From:   Liu Hua <liusdu@126.com>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Cc:     sdu.liu@huawei.com, Liu Hua <liusdu@126.com>
Subject: [PATCH] bcache: insert bkeys without overlap when placeholder missed
Date:   Tue, 22 Sep 2020 23:28:34 +0800
Message-Id: <20200922152834.7418-1-liusdu@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgCXq7tCGGpf9GPKcQ--.6328S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurykKF4xGr4xArWkWF47twb_yoWktrb_u3
        WFqFyftr4YyFZIgr1jyrWfZrWjya98ZF1Iqa4jqFySvrW7Ca93Wr18Aa4xJrs8CrW3CFy3
        G34DXrnYy3s29jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnJ5r7UUUUU==
X-Originating-IP: [114.247.113.140]
X-CM-SenderInfo: polx2vbx6rjloofrz/1tbiuxOnNFpEBnZOJgAAs9
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Btree spliting and garbage collection process will drop
placeholders, which may cause cache miss collision. We can
insert nonoverlapping bkeys with write lock. It is helpful
for performance.

Signed-off-by: Liu Hua <liusdu@126.com>
---
 drivers/md/bcache/extents.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index c809724e6571..cc8af08aee8d 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -329,6 +329,7 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 
 	uint64_t old_offset;
 	unsigned int old_size, sectors_found = 0;
+	bool overlay = false;
 
 	BUG_ON(!KEY_OFFSET(insert));
 	BUG_ON(!KEY_SIZE(insert));
@@ -340,15 +341,18 @@ static bool bch_extent_insert_fixup(struct btree_keys *b,
 			break;
 
 		if (bkey_cmp(&START_KEY(k), insert) >= 0) {
-			if (KEY_SIZE(k))
-				break;
-			else
+			if (!KEY_SIZE(k))
 				continue;
+			if (replace_key && overlay == false)
+				goto out;
+			break;
 		}
 
 		if (bkey_cmp(k, &START_KEY(insert)) <= 0)
 			continue;
 
+		overlay = true;
+
 		old_offset = KEY_START(k);
 		old_size = KEY_SIZE(k);
 
-- 
2.17.1

