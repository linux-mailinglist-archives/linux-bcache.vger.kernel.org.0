Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEFF14EA63E
	for <lists+linux-bcache@lfdr.de>; Tue, 29 Mar 2022 06:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiC2EFp (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 29 Mar 2022 00:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiC2EFo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 29 Mar 2022 00:05:44 -0400
X-Greylist: delayed 2774 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Mar 2022 21:04:00 PDT
Received: from m12-14.163.com (m12-14.163.com [220.181.12.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC7959154E;
        Mon, 28 Mar 2022 21:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=8GnOw8aLVX+558mcqZ
        IJlHW9BLrvkKBh2upVAmYe9QI=; b=hCotd+P3QlR4WVu9VEYrdGpVlxvkacF+dd
        pVjxY7fbTEyk6VDSsyqBgELd5Q6Bjq41UFJoDmWEiOyPcf6GBQEAiK3+eMvv8Qn+
        aLifnmuvJrDF+qmP8tz1Xi3jcuQmkFjLrAftmLKgQ+p67sKT9baUC06NukuySOvk
        HGy0XgP6k=
Received: from localhost.localdomain.localdomain (unknown [36.111.64.85])
        by smtp10 (Coremail) with SMTP id DsCowABHIIhIekJiyaMcDA--.46763S2;
        Tue, 29 Mar 2022 11:17:32 +0800 (CST)
From:   daihuaigang129@163.com
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        daihuaigang <daihuaigang129@163.com>
Subject: [PATCH v1] bcache: fix AB-BA deadlock between cache register and cache_set_free
Date:   Tue, 29 Mar 2022 11:17:25 +0800
Message-Id: <1648523845-4681-1-git-send-email-daihuaigang129@163.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DsCowABHIIhIekJiyaMcDA--.46763S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFy5JFyxZw45Kr15tFWDurg_yoWkJrX_uF
        WfWFyIg3y5Kr1agr13CayfZ3yjvF1q9wnavFWIyrn3Aa43WF1qkryfZr18Aw15Xa1UGF9x
        Gr1kKr1F9w1xKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8yrW3UUUUU==
X-Originating-IP: [36.111.64.85]
X-CM-SenderInfo: xgdlx3pdljt0jjrsmqqrwthudrp/xtbBdRLQMlaEB4kVBgABsL
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: daihuaigang <daihuaigang129@163.com>

bcache register add kobject_mutex then bch_register_mutex,
cache_set_free add bch_register_mutex then kobject_mutex.
fix AB-BA deadlock between cache register and cache_set_free.

Signed-off-by: daihuaigang <daihuaigang129@163.com>
---
 drivers/md/bcache/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index bf3de14..f17953c 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1690,10 +1690,8 @@ static void cache_set_free(struct closure *cl)
 	if (ca) {
 		ca->set = NULL;
 		c->cache = NULL;
-		kobject_put(&ca->kobj);
 	}
 
-
 	if (c->moving_gc_wq)
 		destroy_workqueue(c->moving_gc_wq);
 	bioset_exit(&c->bio_split);
@@ -1704,6 +1702,8 @@ static void cache_set_free(struct closure *cl)
 
 	list_del(&c->list);
 	mutex_unlock(&bch_register_lock);
+	if (ca)
+		kobject_put(&ca->kobj);
 
 	pr_info("Cache set %pU unregistered\n", c->set_uuid);
 	wake_up(&unregister_wait);
-- 
1.8.3.1

