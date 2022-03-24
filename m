Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3B4E6191
	for <lists+linux-bcache@lfdr.de>; Thu, 24 Mar 2022 11:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbiCXKQG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Mar 2022 06:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242598AbiCXKQF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Mar 2022 06:16:05 -0400
X-Greylist: delayed 2793 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Mar 2022 03:14:33 PDT
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6178F931A2
        for <linux-bcache@vger.kernel.org>; Thu, 24 Mar 2022 03:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=XWiAQ+Z5d0xuLBcjww
        QPEKbQplidblsEpe/wGww446k=; b=BWCufjrBPVlhGS5mk3IwvgOK1Td0q6hxUi
        jnLEM+Z+ZiaJ+1Ku36v+rlg9aicj+DvTUYXRScdDkakNnGdoWuLu3PI9Y5/Wo6DH
        haRBevkUFsHnYfaIQgiigB8sDXrdsCpwSDrKurXijJQNJhwiRST9/JXk8CPeBl82
        QfhgxNrUM=
Received: from localhost (unknown [159.226.95.33])
        by smtp9 (Coremail) with SMTP id DcCowACHeGSbOTxiqb57CQ--.3994S2;
        Thu, 24 Mar 2022 17:27:55 +0800 (CST)
From:   QintaoShen <unSimple1993@163.com>
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org, kent.overstreet@gmail.com,
        linux-kernel@vger.kernel.org, QintaoShen <unSimple1993@163.com>
Subject: [PATCH v1] bcache: Check for NULL return of kzalloc()
Date:   Thu, 24 Mar 2022 17:27:54 +0800
Message-Id: <1648114074-10045-1-git-send-email-unSimple1993@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DcCowACHeGSbOTxiqb57CQ--.3994S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw4rury5Zw4fGr4DCw17Wrg_yoWfJrb_W3
        WfZrn2grZ0kr1IgF42vr13XrWUta1DZF9YvFsxtr1Sqasxu3Z3Wr10vr45JayfGFWrZay7
        Z34UJw1fuw1SkjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUUPrc5UUUUU==
X-Originating-IP: [159.226.95.33]
X-CM-SenderInfo: 5xqvxz5sohimizt6il2tof0z/xtbBdRvNH1aEB0SbYgAAsU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

kzalloc() is a memory allocation function which may return a NULL pointer.
Therefore, it is better to check the return value of kzalloc() to avoid potential
NULL-pointer dereference.

Signed-off-by: QintaoShen <unSimple1993@163.com>
---
 drivers/md/bcache/request.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index fdd0194..232ffe3 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1105,6 +1105,9 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
+	if (!ddpp)
+		return ;
+
 	ddip->d = d;
 	/* Count on the bcache device */
 	ddip->orig_bdev = orig_bdev;
-- 
2.7.4

