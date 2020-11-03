Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984542A4141
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Nov 2020 11:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgKCKKJ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 3 Nov 2020 05:10:09 -0500
Received: from m97179.mail.qiye.163.com ([220.181.97.179]:12418 "EHLO
        m97179.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCKKJ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 3 Nov 2020 05:10:09 -0500
Received: from atest-guest.localdomain (unknown [218.94.118.90])
        by m97179.mail.qiye.163.com (Hmail) with ESMTPA id 2B746E02AA2;
        Tue,  3 Nov 2020 18:10:07 +0800 (CST)
From:   Dongsheng Yang <dongsheng.yang@easystack.cn>
To:     colyli@suse.de, linux-bcache@vger.kernel.org
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH] bcache: dont set the ret_task again if we already found a bucket with expected write_point
Date:   Tue,  3 Nov 2020 10:09:54 +0000
Message-Id: <1604398194-28502-1-git-send-email-dongsheng.yang@easystack.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSUI3V1ktWUFJV1kPCR
        oVCBIfWUFZHx5KSkxNTUgdTR0ZVkpNS09IQkNJS0xIT09VGRETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS09ISFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OCo6Gjo6Lz5CDUMwDhApGjQv
        OhYaCjRVSlVKTUtPSEJDSUtMT0JOVTMWGhIXVR8UFRwIEx4VHFUCGhUcOx4aCAIIDxoYEFUYFUVZ
        V1kSC1lBWUlKQ1VCT1VKSkNVQktZV1kIAVlBSU1LTTcG
X-HM-Tid: 0a758d95d11b20bdkuqy2b746e02aa2
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

In pick_data_bucket() bcache search the c->data_buckets from the tail to head, if there
are buckets (e.g b1, b2) with the same write_point, we want to write in b2 until
it's full and then write into b1. But currently, bcache will pick b1 and b2 one by one.

E.g, data_buckets shown as below:

	c->data_buckets
		|->b1->b2

(1) first write will pick b1 from the list.
(2) and after write, b1 will be moved to the tail.
(3) then list will be shown as below:
	c->data_buckets
		|->b2->b1
(4) the next write will pick b2 from the list and then move b2 to the tail.

This commit can make sure we put the writes into b2 until b2 is full and then
pick b1 to continue write.

The remain question is: Why are there buckets with same write point?
Below is one possible scenario:
(1) Process-A write [16K - 20K], there is a Bucket-A with write_point(A) and key_off (20K)
(2) Process-B write [4K - 8K], a new Bucket-B will be added, write_point(B) and key_off (8K)
(3) Process-A write [8K - 12K], pick_data_bucket() will pick Bucket-B to write, as it's key_off is 8K.

After (3), we got Bucket-A and Bucket-B with the same write_point(A).

Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
---
 drivers/md/bcache/alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8f5ef27..45c19b0 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -576,7 +576,8 @@ static struct open_bucket *pick_data_bucket(struct cache_set *c,
 		else if (!bkey_cmp(&ret->key, search))
 			goto found;
 		else if (ret->last_write_point == write_point)
-			ret_task = ret;
+			if (!ret_task)
+				ret_task = ret;
 
 	ret = ret_task ?: list_first_entry(&c->data_buckets,
 					   struct open_bucket, list);
-- 
1.8.3.1

