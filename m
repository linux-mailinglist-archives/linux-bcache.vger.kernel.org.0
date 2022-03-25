Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6AD4E6CE0
	for <lists+linux-bcache@lfdr.de>; Fri, 25 Mar 2022 04:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344436AbiCYDpN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 24 Mar 2022 23:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbiCYDpM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 24 Mar 2022 23:45:12 -0400
X-Greylist: delayed 726 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Mar 2022 20:43:38 PDT
Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73BABA315
        for <linux-bcache@vger.kernel.org>; Thu, 24 Mar 2022 20:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1648179814;
        bh=qpf8RfttfYwh4u1t5tUZIPgLdFSz2GuJZ8d8Lfe+YNY=;
        h=From:To:Cc:Subject:Date;
        b=Y+0Og4aVvdnoGRgkVVD4gFo0H/HD4mplRHHkZ1pXOSv15zFLlhK6lclZQsFP1zX5X
         xZ2pBK0xETIutkm/DkY27zYfC5fGZftKXq931U9V2ZJ/RCujKgXNO0uVLIwp9oN8ky
         7RZq55poAfhG048iyxJvJce9cJpS2xGbVaZiHlH4=
Received: from localhost.localdomain ([218.197.153.188])
        by newxmesmtplogicsvrszc9.qq.com (NewEsmtp) with SMTP
        id 702A0625; Fri, 25 Mar 2022 11:28:02 +0800
X-QQ-mid: xmsmtpt1648178882tfv2y9h5u
Message-ID: <tencent_C028FEC2BF94C0FF5740D298F572B9396C09@qq.com>
X-QQ-XMAILINFO: NDgMZBR9sMmaCLb8eMJ94f9WWsBOYfM7ZcyG4o9zcfIuXx52HdCTWuIC99mx8T
         d0C0H1QgCusvlNmtsj0x5aM+Pm0bPHlXsiRhYs3ghpq7gshK2rcIkbNntSDPlE6wlLzrhukdF6G3
         tjZhJW0m6H17B4V27jAiwltaSh6y6y9ZORXnTa0mBp6MX7/E9ksiu2IOPfIl0KS2+OMVkCeuFV5i
         paa5vehYt4420Lt2zV5sdn3ZHqignEWJE/4ojTVd3nTwItXssqXF31U4WJNwyLJi9CBY36/LBIUK
         p1Q1mYyr6f4xx/y8ksF95JtxXN5gfje4H3z+Ebl3yIri+EE+WHp/CicREzKWWBw9K5aiFhYvkCma
         1U87MFryLRCGC/EbiOMLDqaS3mmLSVXxlB3qbjh3gZ+xI2KItZNFzNTogFBVscHKqspz3cmF71xh
         keLJVNlgdGf1/Vcy0aDs/l1XNlKWA9E4FqlK0+Wf8o9EVjDpewiM2D2EE4cRAWlJcIP0sFC+1e+r
         H/6LsEjkjrbX5A8c9KPH/J0NVurprKBo0zeC9gyMu9yx9LYVqczuAStuRsWX+fZvySdIUaIxxvgv
         umv8gyquYyvewiv07eXST/SidovzlvzjOri9NpHYWcXNNdhXsZzrJcp4wmmF7XW/DeQOJtZa8CcJ
         tb/+xmxGMoFyA4LSfa7bSVowix1Uj5WQRXACiBo6EYUyqf3RNOJxbNW6pph2tQnqf7l3fRR84s0Y
         MqgoS/K52Inz7kaV6gsVOi1UIx4NFpGqu7iWhVRrSm7aEPyReswrU7zy0YdhXbCbFjlg4O18AJlV
         TyMuLu8un/lG0szAqJGhAWHahnQQd9/I8Wt1NuO/GciGUhsfReLi3o0lhpWT1v4kAF4xHanzEOVX
         PK2O7j+1jxv/l86w48E5ClBcjU+tws72XymAulCUSqQXCol3oVwxhVcUa/lX8iKGedfWEQ4kxLJC
         WTHOWfzspSeGBRWFekAVFsjdZFzFS/Zdo+nIb51CKblrIGnst9Tw==
From:   xkernel.wang@foxmail.com
To:     colyli@suse.de, kent.overstreet@gmail.com
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoke Wang <xkernel.wang@foxmail.com>
Subject: [PATCH] bcache: add a check for the return of kzalloc()
Date:   Fri, 25 Mar 2022 11:27:36 +0800
X-OQ-MSGID: <20220325032736.3545-1-xkernel.wang@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

kzalloc() is a memory allocation function which can return NULL when
some internal memory errors happen. So it is better to check it to
prevent potential wrong memory access.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
---
Note: I just roughly handled the error and this seems to affect the
original functionality. If this cannot fail, maybe the tag
`__GFP_NOFAIL` should be considered.
 drivers/md/bcache/request.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 6d1de88..1dc9821 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1107,14 +1107,16 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	 * which would call closure_get(&dc->disk.cl)
 	 */
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
-	ddip->d = d;
-	/* Count on the bcache device */
-	ddip->orig_bdev = orig_bdev;
-	ddip->start_time = start_time;
-	ddip->bi_end_io = bio->bi_end_io;
-	ddip->bi_private = bio->bi_private;
-	bio->bi_end_io = detached_dev_end_io;
-	bio->bi_private = ddip;
+	if (ddip) {
+		ddip->d = d;
+		/* Count on the bcache device */
+		ddip->orig_bdev = orig_bdev;
+		ddip->start_time = start_time;
+		ddip->bi_end_io = bio->bi_end_io;
+		ddip->bi_private = bio->bi_private;
+		bio->bi_end_io = detached_dev_end_io;
+		bio->bi_private = ddip;
+	}
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !blk_queue_discard(bdev_get_queue(dc->bdev)))
-- 
