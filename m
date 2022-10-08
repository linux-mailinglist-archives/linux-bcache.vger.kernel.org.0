Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BA75F8473
	for <lists+linux-bcache@lfdr.de>; Sat,  8 Oct 2022 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiJHI4g (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 8 Oct 2022 04:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJHI4f (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 8 Oct 2022 04:56:35 -0400
Received: from mail-m3164.qiye.163.com (mail-m3164.qiye.163.com [103.74.31.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5504857E29
        for <linux-bcache@vger.kernel.org>; Sat,  8 Oct 2022 01:56:33 -0700 (PDT)
Received: from localhost.localdomain (unknown [218.94.118.90])
        by mail-m3164.qiye.163.com (Hmail) with ESMTPA id DDC0A6202BE;
        Sat,  8 Oct 2022 16:56:30 +0800 (CST)
From:   mingzhe.zou@easystack.cn
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     zoumingzhe@qq.com
Subject: [PATCH] bcache: improve bch_hprint() output
Date:   Sat,  8 Oct 2022 16:56:30 +0800
Message-Id: <20221008085630.8321-1-mingzhe.zou@easystack.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHUgaVk8aGBkfQ0NDQklIGVUZERMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VCT1VKSkNVQktZV1kWGg8SFR0UWUFZT0tIVUpKS0hKQ1VKS0tVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MSo6GSo5MTIPPxc6LwsKS0sq
        HTwwChpVSlVKTU1OSUpCSEJKSE1LVTMWGhIXVRYSFRwBEx5VARQOOx4aCAIIDxoYEFUYFUVZV1kS
        C1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSk1LSDcG
X-HM-Tid: 0a83b6cf6e4a00a4kurmddc0a6202be
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: mingzhe <mingzhe.zou@easystack.cn>

The current suffix of bch_hprint() uses the SI (The International System of Units)
standard. In the SI brochure, the symbol for the kilo prefix is k instead of K.
Because K is the symbol for the thermodynamic temperature unit kelvin.

In fact, SI is based on decimal not binary. However, bch_hprint() is binary based,
so it should conform to the IEC 60027-2 (Letter symbols to be used in electrical
technology - Part 2: Telecommunications and electronics) standard.

Signed-off-by: mingzhe <mingzhe.zou@easystack.cn>
---
 drivers/md/bcache/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/util.c b/drivers/md/bcache/util.c
index ae380bc3992e..91ab36ec2deb 100644
--- a/drivers/md/bcache/util.c
+++ b/drivers/md/bcache/util.c
@@ -91,7 +91,7 @@ STRTO_H(strtoull, unsigned long long)
  */
 ssize_t bch_hprint(char *buf, int64_t v)
 {
-	static const char units[] = "?kMGTPEZY";
+	static const char units[] = "?KMGTPEZY";
 	int u = 0, t;
 
 	uint64_t q;
-- 
2.17.1

