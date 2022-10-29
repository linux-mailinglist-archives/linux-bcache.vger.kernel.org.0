Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25EF6123E9
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Oct 2022 16:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJ2Ogd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 29 Oct 2022 10:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJ2Ogc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 29 Oct 2022 10:36:32 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 07C0C6C75B
        for <linux-bcache@vger.kernel.org>; Sat, 29 Oct 2022 07:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=0dKCN
        4Cd11pe5YE04v4oSseyxy3LVXwdUzR6YmC/h7g=; b=qIRKHTzDWJ5cGZjIMsgrQ
        fuu2I0z2htzRZ2Sk9/f8P+3KvvZWTuoOtkhLphmcIlrDKgqtq8CR46VBTMufpnr0
        3jdjDRg4ZhwZ5VDRZ4HF8eY3CKkYQ22XqIXF+qZnG62/6+c06WOxErzdMTMweIAR
        VroVmBz/ptG3qoKD7Y+/I8=
Received: from localhost.localdomain (unknown [117.61.20.58])
        by smtp1 (Coremail) with SMTP id C8mowADHvYFoOl1j+2BbDg--.15339S2;
        Sat, 29 Oct 2022 22:36:25 +0800 (CST)
From:   Xiaole He <hexiaole1994@126.com>
To:     linux-bcache@vger.kernel.org
Cc:     Xiaole He <hexiaole1994@126.com>, Xiaole He <hexiaole@kylinos.cn>
Subject: [PATCH] bcache-tools: fix incorrect id to find cache dev
Date:   Sat, 29 Oct 2022 17:24:14 +0800
Message-Id: <20221029092414.38548-1-hexiaole1994@126.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowADHvYFoOl1j+2BbDg--.15339S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Aw48CF4xAFyxZrWxtr47Arb_yoW8CF4kpF
        sIgFyxArykuw1S9ay8Z398W34rZFy8Wr4UG3y5Cr1Fk345ur4vvrZ7tFyvvry8XrWkAw4r
        ZFsrCry3ZrsrCaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEs2-bUUUUU=
X-Originating-IP: [117.61.20.58]
X-CM-SenderInfo: 5kh0xt5rohimizu6ij2wof0z/1tbiegqpBlpEFnlbDwAAs6
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In function 'show_bdevs_detail' of 'show.c', the code traverse all
bcache dev collected, then call 'cset_to_devname' for backing dev to
get the name of the related cache dev into 'attachdev':

/* show.c begin */
...
INIT_LIST_HEAD(&head);
...
ret = list_bdevs(&head);
...
list_for_each_entry_safe(devs, n, &head, dev_list) {
    ...
    char attachdev[30];

    if (strlen(devs->attachuuid) == 36) {
        cset_to_devname(&head, devs->cset, attachdev);
...
/* show.c end */

/* lib.c begin */
int cset_to_devname(struct list_head *head, char *cset, char *devname)
...
/* lib.c end */

'cset_to_devname' scan all cache dev from the first argument 'head', and
 copy the name of the cache dev that matches against the second argument
 'cset' into the third argument 'devname'.

But in above code, the passed second argument is the 'cset' of the
backing dev itself, rather than the 'cset' of the cache dev.

This patch fix this error, call the 'cset_to_devname' with the second
argument of 'devs->attachuuid', rather than 'devs->cset'. Otherwise, if
the backing dev of the bcache is the first device in 'head', then the
'attachdev' can be a untouched status because the 'cset_to_devname' can
not match any the 'cset' of cache dev with a 'cset' from backing dev, so
 the 'printf' for 'attachdev' can be nonsense.

Signed-off-by: Xiaole He <hexiaole@kylinos.cn>
---
 show.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/show.c b/show.c
index abd068e..f69fd10 100644
--- a/show.c
+++ b/show.c
@@ -73,7 +73,7 @@ int show_bdevs_detail(void)
 		char attachdev[30];
 
 		if (strlen(devs->attachuuid) == 36) {
-			cset_to_devname(&head, devs->cset, attachdev);
+			cset_to_devname(&head, devs->attachuuid, attachdev);
 		} else if (devs->version == BCACHE_SB_VERSION_CDEV
 			   || devs->version == BCACHE_SB_VERSION_CDEV_WITH_UUID
 			   || devs->version ==
-- 
2.27.0

