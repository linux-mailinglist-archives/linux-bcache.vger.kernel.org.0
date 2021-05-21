Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03AF38C1CB
	for <lists+linux-bcache@lfdr.de>; Fri, 21 May 2021 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhEUIaP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 21 May 2021 04:30:15 -0400
Received: from m12-14.163.com ([220.181.12.14]:48956 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhEUIaP (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 21 May 2021 04:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=m/4ob
        kjV8lIhm04fJfncJB1YfWCrR+GPtUWQsPNwOVU=; b=C5Bk4S752HQeVlomogWdr
        RQr+H67TtBMnBy9nl7CODAQguak/fI5oCqBZqRx8xqIuR+dJrUYXagA8grargGNL
        kDDmXU0rnUa/9Mnc961TZV211/Did8JupZhZno3x6yLT+SVOERElFJxkUqeKjlN2
        Dqvai5jub9wr5BMGeE2by4=
Received: from COOL-20201222LC.ccdomain.com (unknown [218.94.48.178])
        by smtp10 (Coremail) with SMTP id DsCowADX5089b6dgyf2LKA--.17856S2;
        Fri, 21 May 2021 16:28:46 +0800 (CST)
From:   dingsenjie@163.com
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ding Senjie <dingsenjie@yulong.com>
Subject: [PATCH] md: bcache: Fix spelling of 'acquire'
Date:   Fri, 21 May 2021 16:28:25 +0800
Message-Id: <20210521082825.21736-1-dingsenjie@163.com>
X-Mailer: git-send-email 2.21.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowADX5089b6dgyf2LKA--.17856S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF4fKFW3CF47KrWUKFWfXwb_yoWfGrc_ua
        1Sqay29w45Kr1xXr13Gw4fZrW0qw1kurn5Jan7JrW3uF15Zr47Wry3Wr1UXr15ua18C3Zr
        Ar1jgr45tw1xCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8UKsUUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 5glqw25hqmxvi6rwjhhfrp/1tbipR6ZyFUMeOko1gAAsc
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Ding Senjie <dingsenjie@yulong.com>

acqurie -> acquire

Signed-off-by: Ding Senjie <dingsenjie@yulong.com>
---
 drivers/md/bcache/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 2047a9c..c8d5942 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -2752,7 +2752,7 @@ static int bcache_reboot(struct notifier_block *n, unsigned long code, void *x)
 		 * The reason bch_register_lock is not held to call
 		 * bch_cache_set_stop() and bcache_device_stop() is to
 		 * avoid potential deadlock during reboot, because cache
-		 * set or bcache device stopping process will acqurie
+		 * set or bcache device stopping process will acquire
 		 * bch_register_lock too.
 		 *
 		 * We are safe here because bcache_is_reboot sets to
-- 
1.9.1

