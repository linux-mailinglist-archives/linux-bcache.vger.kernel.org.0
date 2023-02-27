Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4976A41EB
	for <lists+linux-bcache@lfdr.de>; Mon, 27 Feb 2023 13:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjB0Mor (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Feb 2023 07:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjB0Mol (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Feb 2023 07:44:41 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A51E9F4
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 04:44:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id ky4so6567438plb.3
        for <linux-bcache@vger.kernel.org>; Mon, 27 Feb 2023 04:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677501877;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yuFQ53JP0XlvpJ3+5xT1KBfbOchMoNfa/Eb9+rqasHA=;
        b=S5UkeMaarAQkI6504x7HadXhgvAKD1S9DJhpfks+aypcj/HTG6nTNdmJJk9kK1SABI
         loUCDjTKngq/A/r7+s9J41gQyldeYiyoUQxtLNBetacF2E+vkXdTrR45fdgGeIwdX104
         AFfMTVTxNKMMvPtiztyxUDTUC9lXFgMN9aHavdWjjgbvM5qIQiyTFVI1EjhHZCYFmPg4
         J2wABgyiyhj1Xeh9yyi63/teHbr1ALfnGoqRCg5bB+YdASs+lLEXZYhIB6KH2roWtM/M
         MlxlPEeAuQfiKyjZeAB7676/BFHxULJDxFe8G/jAv5U8XNdAVOFvG+BdHd2NKuI1HpN1
         qpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677501877;
        h=content-transfer-encoding:in-reply-to:from:to:content-language
         :references:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yuFQ53JP0XlvpJ3+5xT1KBfbOchMoNfa/Eb9+rqasHA=;
        b=YeDvmsJDdLD24UhmRWEqDIrqvtkCv4vtuNn8B5VN5IaUHLRnKaS2pNDFsI/2fmY5H6
         7EFmZDzDAwYj0VWJmSQkDe/46Z8+tP7z2W7ldEhmXLOdqTR+y/vckmw7OQsnaDSk+daR
         mAW4CjNjZp5U5RJR4fU5SGspXQEoSjsBHmY2erBIEtOs3o8YrLNaxrbSvfroccMWgNLz
         yp0wlIB0fEYXzaNGc15y/4JmVEY/ajfvdegBcRB3g9EWYE20VnfhIY5O5SImyZvomFSJ
         iS6IlaYQNi/VCLnhH0FmnUZ9qHiM3gaq6pHcKSXHmFTpz5lSb5IrWvu/nYIzgTzQEWwr
         I1Nw==
X-Gm-Message-State: AO0yUKVxaBnvWTcwkASJeDxyrWHQXtoQkWHEGZhBmTHWoFSUO5MiVw/T
        +3g7Rue2/ACaqfRlCfg9djPvA4vYZLG5UQ==
X-Google-Smtp-Source: AK7set8z989dYWxyDFx5krp5wXhjbvP8dZwSvyUrHAJRniS1lqDnEM8NnOS6hSR8Zf6J5+XAF3BzBg==
X-Received: by 2002:a17:902:b610:b0:19c:94ad:cbdd with SMTP id b16-20020a170902b61000b0019c94adcbddmr17762237pls.16.1677501877568;
        Mon, 27 Feb 2023 04:44:37 -0800 (PST)
Received: from [172.20.106.12] ([61.16.102.74])
        by smtp.gmail.com with ESMTPSA id iy21-20020a170903131500b00198fb25d09bsm4548604plb.237.2023.02.27.04.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 04:44:37 -0800 (PST)
Message-ID: <ddeb178d-4889-4c41-9638-fa8b4aa5cb71@gmail.com>
Date:   Mon, 27 Feb 2023 20:44:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: [PATCH] bcache: remove return value from bch_cached_dev_error
References: <20230227124132.1925274-1-zhangzhen15@kuaishou.com>
Content-Language: en-US
To:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
From:   Zhang Zhen <zhangzhen.email@gmail.com>
In-Reply-To: <20230227124132.1925274-1-zhangzhen15@kuaishou.com>
X-Forwarded-Message-Id: <20230227124132.1925274-1-zhangzhen15@kuaishou.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

The only caller of bch_cached_dev_error does not check the return
value. We can make it a void function.

Signed-off-by: Zhen Zhang <zhangzhen15@kuaishou.com>
---
  drivers/md/bcache/bcache.h | 2 +-
  drivers/md/bcache/super.c  | 5 ++---
  2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index aebb7ef10e63..ff175a2fb2f0 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -990,7 +990,7 @@ int bch_bucket_alloc_set(struct cache_set *c, 
unsigned int reserve,
  bool bch_alloc_sectors(struct cache_set *c, struct bkey *k,
  		       unsigned int sectors, unsigned int write_point,
  		       unsigned int write_prio, bool wait);
-bool bch_cached_dev_error(struct cached_dev *dc);
+void bch_cached_dev_error(struct cached_dev *dc);
   __printf(2, 3)
  bool bch_cache_set_error(struct cache_set *c, const char *fmt, ...);
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index ba3909bb6bea..9923bb5c4fbe 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1607,10 +1607,10 @@ int bch_flash_dev_create(struct cache_set *c, 
uint64_t size)
  	return flash_dev_run(c, u);
  }
  -bool bch_cached_dev_error(struct cached_dev *dc)
+void bch_cached_dev_error(struct cached_dev *dc)
  {
  	if (!dc || test_bit(BCACHE_DEV_CLOSING, &dc->disk.flags))
-		return false;
+		return;
   	dc->io_disable = true;
  	/* make others know io_disable is true earlier */
@@ -1620,7 +1620,6 @@ bool bch_cached_dev_error(struct cached_dev *dc)
  	       dc->disk.disk->disk_name, dc->bdev);
   	bcache_device_stop(&dc->disk);
-	return true;
  }
   /* Cache set */
-- 
2.27.0

