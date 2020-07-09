Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9369621981B
	for <lists+linux-bcache@lfdr.de>; Thu,  9 Jul 2020 07:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGIFyJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 9 Jul 2020 01:54:09 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:53472 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726129AbgGIFyJ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 9 Jul 2020 01:54:09 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowAC3v_P4sAZfGxivAw--.26608S2;
        Thu, 09 Jul 2020 13:54:00 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     colyli@suse.de, kent.overstreet@gmail.com,
        linux-bcache@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] bcache: writeback: Remove unneeded variable i
Date:   Thu,  9 Jul 2020 05:53:58 +0000
Message-Id: <20200709055358.30237-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowAC3v_P4sAZfGxivAw--.26608S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtF15Cw43uw48Wr43uryUZFb_yoWxArg_uF
        1Yqan2kFWFk3WkWw12v3WfZrWj934DZF1vq3WSkrZI9F1Sy3s7XrWxZr4kJr1I9Fy8uFWD
        G342qr4UAr1v9jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb4xFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJV
        W0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8
        WwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
        1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
        64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
        0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUDfHUUUU
        UU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBQIMA16HQrOxfQADsv
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Remove unneeded variable i in bch_dirty_init_thread().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/md/bcache/writeback.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1cf1e5016cb9..71801c086b82 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -825,10 +825,8 @@ static int bch_dirty_init_thread(void *arg)
 	struct btree_iter iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
-	int i;
 
 	k = p = NULL;
-	i = 0;
 	cur_idx = prev_idx = 0;
 
 	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-- 
2.17.1

