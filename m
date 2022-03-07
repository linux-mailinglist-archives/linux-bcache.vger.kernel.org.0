Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86804CF46B
	for <lists+linux-bcache@lfdr.de>; Mon,  7 Mar 2022 10:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiCGJRS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 7 Mar 2022 04:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236296AbiCGJRS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 7 Mar 2022 04:17:18 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DEA6515F
        for <linux-bcache@vger.kernel.org>; Mon,  7 Mar 2022 01:16:24 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id t14so13053414pgr.3
        for <linux-bcache@vger.kernel.org>; Mon, 07 Mar 2022 01:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NslC4UVWa9E1BgIugTrzYOtMXelMoIw4vldVpREAiCM=;
        b=Bq96/1RkI/JzVdsw//ITzJufioRrw/lNdcUYwiXRT/Bp183S/4h8IFVohcEpDLFlzu
         adHoI973aXy+VMo9iM79+/F/EiZPOu7zmDKy+96DpQCQn4O6ob6YYsG6qffhttInypxx
         QgwDBhBj3y6sf2RVGHMYaCAzkB87IgfAK2MPpZWjZEln5+Phzk4Ir4Ylt2jIeB9H9wak
         6U1sgz1idzZWRfdGo5J2ieY2/k54imSVbpU/ffO9T+HbySLw1TJvqraEpMvAzfVOpJWX
         Lsi6aYIxFOCHU3T/NCJAXlfZDJtEQz4P0AFKjwfFhdaIcSKE9sCVPAkji7teqKzVycwa
         J6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NslC4UVWa9E1BgIugTrzYOtMXelMoIw4vldVpREAiCM=;
        b=cz+1KzHgDuVeXG/dXf2PtCHjSpc0dd+NTBDKLzURrEzR3Ef/BuIaI9FiPtSKTbugl7
         resGIYxK59Ge/rciBgd6A5UBDTBWhljU6Ng8gYe6nzn5g+akJpeM7vtDEQslaJ9PKGAn
         Weg805picEdaxouD/WqHIjW4auvkIi3KK0zEuBRc7glxabStS92D5NbY32KGEfzGuid3
         +z4qgTEI9Ev2meVhyiKhgW2uQxSNb7hZENOwE2ku/LDPxNeQLprxMBCEujgkbwAnRgoq
         E/HWyQFtilzwN1lZmQRmZFa5ikwrzvOfLEMdywd9a3iZwgn6ZLn5J56/yTFEj70nlnYg
         9T9A==
X-Gm-Message-State: AOAM533q559i6Q5LGONZE2S6GNCmKYh9VRFPRNEy7xRziMbUfBfHfW2C
        j/eSlYVdvIi/yYinhDPoQ6SJ2ZPTQ1Y+zIi2
X-Google-Smtp-Source: ABdhPJwN/JxiA8KoCWYUzYa/glLdqDQ8OsHBNerTPv2AXhF+jcw62E4RWG2TNSM0BNjDxCN3p0Vgzw==
X-Received: by 2002:a63:384e:0:b0:374:ae28:71fc with SMTP id h14-20020a63384e000000b00374ae2871fcmr9020809pgn.159.1646644583697;
        Mon, 07 Mar 2022 01:16:23 -0800 (PST)
Received: from localhost.localdomain ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id ge19-20020a17090b0e1300b001bcade154d6sm18346703pjb.48.2022.03.07.01.16.22
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 01:16:23 -0800 (PST)
From:   Zhen Zhang <zhangzhen.email@gmail.com>
To:     linux-bcache@vger.kernel.org
Subject: [PATCH] Bcache: don't return BLK_STS_IOERR during cache detach
Date:   Mon,  7 Mar 2022 01:16:15 -0800
Message-Id: <20220307091615.3329-1-zhangzhen.email@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2c6244b9-249a-3379-31b5-f16b3d0cb162@suse.de>
References: <2c6244b9-249a-3379-31b5-f16b3d0cb162@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Before this patch, if cache device missing, cached_dev_submit_bio return io err
to fs during cache detach, randomly lead to xfs do force shutdown.

This patch delay the cache io submit in cached_dev_submit_bio
and wait for cache set detach finish.
So if the cache device become missing, bcache detach cache set automatically,
and the io will sumbit normally.

Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in "xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error on 004f8aa7-561a-4ba7-bf7b-292e461d3f18:
Feb  2 20:59:23  kernel: journal io error
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling caching
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, keep it alive.
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in "xlog_iodone" at daddr 0x400123e60 len 64 error 12
Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) called from line 1298 of file fs/xfs/xfs_log.c. Return address = 00000000c1c8077f
Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. Shutting down filesystem
Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem and rectify the problem(s)

Signed-off-by: Zhen Zhang <zhangzhen.email@gmail.com>
---
 drivers/md/bcache/bcache.h  | 5 -----
 drivers/md/bcache/request.c | 8 ++++----
 drivers/md/bcache/super.c   | 3 ++-
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 9ed9c955add7..e5227dd08e3a 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -928,11 +928,6 @@ static inline void closure_bio_submit(struct cache_set *c,
 				      struct closure *cl)
 {
 	closure_get(cl);
-	if (unlikely(test_bit(CACHE_SET_IO_DISABLE, &c->flags))) {
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
-		return;
-	}
 	submit_bio_noacct(bio);
 }
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index d15aae6c51c1..36f0ee95b51f 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -13,6 +13,7 @@
 #include "request.h"
 #include "writeback.h"
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/hash.h>
 #include <linux/random.h>
@@ -1172,11 +1173,10 @@ void cached_dev_submit_bio(struct bio *bio)
 	unsigned long start_time;
 	int rw = bio_data_dir(bio);
 
-	if (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
+	while (unlikely((d->c && test_bit(CACHE_SET_IO_DISABLE, &d->c->flags)) ||
 		     dc->io_disable)) {
-		bio->bi_status = BLK_STS_IOERR;
-		bio_endio(bio);
-		return;
+		/* wait for detach finish and d->c == NULL. */
+		msleep(2);
 	}
 
 	if (likely(d->c)) {
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 140f35dc0c45..8d9a5e937bc8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -661,7 +661,8 @@ int bch_prio_write(struct cache *ca, bool wait)
 		p->csum		= bch_crc64(&p->magic, meta_bucket_bytes(&ca->sb) - 8);
 
 		bucket = bch_bucket_alloc(ca, RESERVE_PRIO, wait);
-		BUG_ON(bucket == -1);
+		if (bucket == -1)
+			return -1;
 
 		mutex_unlock(&ca->set->bucket_lock);
 		prio_io(ca, bucket, REQ_OP_WRITE, 0);
-- 
2.25.1

