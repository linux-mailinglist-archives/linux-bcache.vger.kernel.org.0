Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E336F4D3F60
	for <lists+linux-bcache@lfdr.de>; Thu, 10 Mar 2022 03:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiCJCwA (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 9 Mar 2022 21:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiCJCv7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 9 Mar 2022 21:51:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCEC122F51
        for <linux-bcache@vger.kernel.org>; Wed,  9 Mar 2022 18:50:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bx5so4010167pjb.3
        for <linux-bcache@vger.kernel.org>; Wed, 09 Mar 2022 18:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:references
         :content-language:to:cc:from:in-reply-to:content-transfer-encoding;
        bh=SqsDt0sVoYA5DXH7vhRiMnhS3GHZI4/liYIeB2pan5I=;
        b=ZXK7IZi/O6/UNeymMXB5TAYz9m4l0maghF7h0onIqlu3WHYltXWMUzNgsngwLY6x5F
         8hjeUase/lmmrns40SMbETPHUIdmHvHD1Vx4vKymFtEDgUmt0FQm1vUJLmh3l23aRwwa
         TCFBo2CadwZg555J1ElN/ymQnrzWhTQo5N8dfWV8nRfN3dHTuIyI2Rhvqw1ldNAXcnux
         EicwoZtS0uzq2Zf/5VHMZ1izE0Hl0gzp3ttdwMbZMatHlnnTgHushe2RXLHbO3IdBfvz
         O5ky2393sWK3qEMonELKalOh33hm5FNg055a78KsKpD5r5n5Gt/J3QeOonrt/sQgelpg
         fJlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :references:content-language:to:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=SqsDt0sVoYA5DXH7vhRiMnhS3GHZI4/liYIeB2pan5I=;
        b=2vK8RzumzJn5AEzuyrpMbO8HR/IX3wy4h85BA3bnojMHZ31CeKejSQJOOESg84LiCo
         5To6jJhtDSqpz9mhCkMhCvRpRuS+IfNHc7Ty09JNvwBhm5PFA5naLsubvmuCI9QWsNQH
         jiwjtt+SoPggiyn1XcKmZ6hdrF300+qcvUBXWWHJVwcs/xLu7qhlaYe2m1O5FFP88hi4
         R5Caj/EkBDekFqA3RYYNyntQGmDjB3n4HeW4+nuW31dRAxA9G9rIJ0uFxqd5uRS4F4j9
         vagBY1N4XwOahdjMx7vKtzr32EpelRuY5bwwcYTGjn1ouzg5pgkKOsxnYwUziVmr+xTx
         Hs6Q==
X-Gm-Message-State: AOAM530KweytN+R777Y0ctw0ysxzzAwqgTLwVhAGojEALbse4TM0zqOV
        duvwQzHwWiwit4pu/mbfXbqts4vO9wRqP/KW
X-Google-Smtp-Source: ABdhPJwtLF1VLsnrB6dKaNJCcMMnRvhHvgMBSdYYVYXNxkhzMGH6RRdkKgI8K/Sda7xDk1c1i8bw0A==
X-Received: by 2002:a17:902:8ec9:b0:14f:11f7:db77 with SMTP id x9-20020a1709028ec900b0014f11f7db77mr2828658plo.136.1646880658872;
        Wed, 09 Mar 2022 18:50:58 -0800 (PST)
Received: from [172.20.104.115] ([162.219.34.248])
        by smtp.gmail.com with ESMTPSA id w2-20020a17090a380200b001bf46846c09sm3926439pjb.36.2022.03.09.18.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 18:50:58 -0800 (PST)
Message-ID: <7e4035fa-a7cb-6be5-a143-011e035d8f33@gmail.com>
Date:   Thu, 10 Mar 2022 10:50:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: [PATCH] Bcache: don't return BLK_STS_IOERR during cache detach
References: <20220307091409.3273-1-zhangzhen.email@gmail.com>
Content-Language: en-US
To:     linux-bcache@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <20220307091409.3273-1-zhangzhen.email@gmail.com>
X-Forwarded-Message-Id: <20220307091409.3273-1-zhangzhen.email@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Before this patch, if cache device missing, cached_dev_submit_bio return 
io err
to fs during cache detach, randomly lead to xfs do force shutdown.

This patch delay the cache io submit in cached_dev_submit_bio
and wait for cache set detach finish.
So if the cache device become missing, bcache detach cache set 
automatically,
and the io will sumbit normally.

Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p57: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_count_io_errors() nvme0n1p56: IO 
error on writing btree.
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
"xfs_buf_iodone_callback_error" at daddr 0x80034658 len 32 error 12
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() bcache: error on 
004f8aa7-561a-4ba7-bf7b-292e461d3f18:
Feb  2 20:59:23  kernel: journal io error
Feb  2 20:59:23  kernel: bcache: bch_cache_set_error() , disabling caching
Feb  2 20:59:23  kernel: bcache: bch_btree_insert() error -5
Feb  2 20:59:23  kernel: bcache: conditional_stop_bcache_device() 
stop_when_cache_set_failed of bcache43 is "auto" and cache is clean, 
keep it alive.
Feb  2 20:59:23  kernel: XFS (bcache43): metadata I/O error in 
"xlog_iodone" at daddr 0x400123e60 len 64 error 12
Feb  2 20:59:23  kernel: XFS (bcache43): xfs_do_force_shutdown(0x2) 
called from line 1298 of file fs/xfs/xfs_log.c. Return address = 
00000000c1c8077f
Feb  2 20:59:23  kernel: XFS (bcache43): Log I/O Error Detected. 
Shutting down filesystem
Feb  2 20:59:23  kernel: XFS (bcache43): Please unmount the filesystem 
and rectify the problem(s)

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
@@ -928,11 +928,6 @@ static inline void closure_bio_submit(struct 
cache_set *c,
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

