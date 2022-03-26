Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81184E7FF0
	for <lists+linux-bcache@lfdr.de>; Sat, 26 Mar 2022 09:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbiCZIKd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 26 Mar 2022 04:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiCZIKc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 26 Mar 2022 04:10:32 -0400
Received: from m12-12.163.com (m12-12.163.com [220.181.12.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2681393F0;
        Sat, 26 Mar 2022 01:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=j21A406LuZH2VcNGPx
        2U8V/L22keGEarWkTFzGFG/vQ=; b=TPR7DKpRgj5qfu24gIBM26o3VUe/d09F85
        rCagLSLHYDeiwWpMDtI7w7txymO6bpBeh6Yu4MZ7SoxEnFXRt+1Y20ZYH7uyhPQF
        fZyySVza6YHNeBgfhDZUVS1w0Uo/pehW6H4z5rgnaUVn5Kb2jvtNfwPXZQafD3NP
        /JHUDV1PU=
Received: from localhost.localdomain.localdomain (unknown [36.111.64.85])
        by smtp8 (Coremail) with SMTP id DMCowACHE2wvxj5iXbnXBw--.5014S2;
        Sat, 26 Mar 2022 15:52:23 +0800 (CST)
From:   daihuaigang129@163.com
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        daihuaigang <daihuaigang129@163.com>
Subject: [PATCH v1] mmc: core: fix AB-BA deadlock between cache register and cache_set_free
Date:   Sat, 26 Mar 2022 15:52:07 +0800
Message-Id: <1648281127-9389-1-git-send-email-daihuaigang129@163.com>
X-Mailer: git-send-email 1.8.3.1
X-CM-TRANSID: DMCowACHE2wvxj5iXbnXBw--.5014S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7GFy5JFyxZw45tw4rWF45KFg_yoWfKFX_uF
        WxXFyIg3yrKr1Ygr13CayfZ3yqvF1q9an3XFWIyrnxAa45WFnFkryfZr18Z34rZa1SkFnx
        Gr1vkF1F93W8KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUUD7aUUUUUU==
X-Originating-IP: [36.111.64.85]
X-CM-SenderInfo: xgdlx3pdljt0jjrsmqqrwthudrp/1tbiNBfPMlaD-NpCoAAAsP
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

