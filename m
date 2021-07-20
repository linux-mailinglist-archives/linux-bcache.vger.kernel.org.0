Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021913CF81C
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jul 2021 12:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhGTKBe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 20 Jul 2021 06:01:34 -0400
Received: from mail.wangsu.com ([123.103.51.227]:53411 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S237492AbhGTKAy (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 20 Jul 2021 06:00:54 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 06:00:47 EDT
Received: from fedora33.wangsu.com (unknown [59.61.78.138])
        by app2 (Coremail) with SMTP id 4zNnewC3vflPpvZgeSECAA--.2921S2;
        Tue, 20 Jul 2021 18:32:53 +0800 (CST)
From:   Lin Feng <linf@wangsu.com>
To:     colyli@suse.de
Cc:     axboe@kernel.dk, linf@wangsu.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Subject: [PATCH] bcache: fix wrong BITMASK offset value for BDEV_CACHE_MODE
Date:   Tue, 20 Jul 2021 18:32:46 +0800
Message-Id: <20210720103246.112027-1-linf@wangsu.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewC3vflPpvZgeSECAA--.2921S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF4xXw45GF48JF4rtr4ruFg_yoW8GrW3pF
        yDAr4rtFW0qa4Iyw4kAFy7Wws5Zry3GasayayUW3W5u34xtw1Fq34rua1jyr95C34vkrsI
        yF1DK3yUGa4UuF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Original codes:
BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
BITMASK(CACHE_DISCARD,			struct cache_sb, flags, 1, 1);
BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
...
BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);

Should BDEV_CACHE_MODE bits start from bit-nr 5(2+3) else it overlaps
with previous defined bit chunks, since we have 4 types of cache modes,
BDEV_CACHE_MODE will overwrite CACHE_SYNC and CACHE_DISCARD bits.

This bug stays there since first upstream version of bcache, don't know
why it lives so long, or am i missing something, please point me out
if I'm wrong, thanks!

Signed-off-by: Lin Feng <linf@wangsu.com>
---
 include/uapi/linux/bcache.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
index cf7399f03b71..dccd89756451 100644
--- a/include/uapi/linux/bcache.h
+++ b/include/uapi/linux/bcache.h
@@ -288,7 +288,7 @@ BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
 #define CACHE_REPLACEMENT_FIFO		1U
 #define CACHE_REPLACEMENT_RANDOM	2U
 
-BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
+BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 5, 4);
 #define CACHE_MODE_WRITETHROUGH		0U
 #define CACHE_MODE_WRITEBACK		1U
 #define CACHE_MODE_WRITEAROUND		2U
-- 
2.31.1

