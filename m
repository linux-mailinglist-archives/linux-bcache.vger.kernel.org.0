Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA00B5364E3
	for <lists+linux-bcache@lfdr.de>; Fri, 27 May 2022 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352764AbiE0Pt2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 May 2022 11:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbiE0Pt1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 May 2022 11:49:27 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9430E12388A
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 08:49:25 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id a10so5018290ioe.9
        for <linux-bcache@vger.kernel.org>; Fri, 27 May 2022 08:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DfQBEt+DBhNdyw6RNSIOsmJe0RNwf7dOUcu/f23zdto=;
        b=21HUBJEgr2AP2FKoOb69yTfAXQzLblhnjppKtx21dSIoWLNHc+iqndjrIckA3FVdIr
         U0MnM2DYb7kXQT/dI62Xz6J4sNQDaSCFJh4F7n5LvBG7AACuszxE6VYfKpYoznXbPkc5
         OHyxpl/pWjuOkATS5K79VT3aR9/NaejcnasF7HEiz34IdH6LEsSL4k+2682Df8VXgiTI
         yqjv7yu5ikfpdzIBjSPHzVF8OS1qiHBSo7tTIRv8+L3/ScS9F0fnk+LKLAIdHK4Ka9Le
         0kDE5s5tD0pH1Tt1zW0xSsSfSO9zxAubyVBDFu+QxArJMfkbmMCeVYOf7H1is35NmA43
         vE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DfQBEt+DBhNdyw6RNSIOsmJe0RNwf7dOUcu/f23zdto=;
        b=dR8DDPpyeKnxiCEoPBeoEzSExUUjxADsiw709osjkjhVQKxCreLTXdhjpGNhMf1zMg
         HneAT1edxdbz3zGu8oy5gIUMN9e0OgdrdGO/70mk6Xs9Bnzc0vxh3zf1pU8edSJkSk51
         WZW3up5+OcYzX8RlFT/sWZI0hAURChnIF+f9vX94gsqEyY13ptSyG0BSLDripDZ2npnX
         pOLEFh54vaBnNMZjzIy3CZ4k4M7+YVdpeI+8KQ9bxy3mijNEw7jkNl9IEakFZSFoxZfE
         Lg3v2ZOYmYj8fI2vtfiV0hAFL64onS/nWMXmLWVfrdkwtJ4D0y/SV+R/Nk15rozz/RTX
         wpkQ==
X-Gm-Message-State: AOAM533ckIMaS9nJAEMlAG6+AqsaHEqwUIF6E0co78tch4lRTVc7hzrT
        CLfNyUTcp6a3UlewP/E6HE2SXQ==
X-Google-Smtp-Source: ABdhPJzzYG7T7RGV9RmrG+wYAKbicjL2wY9FibFOakIxaXEuXuKNTERKCKRB1O98pul7N1AZ9xcnWg==
X-Received: by 2002:a5e:8f49:0:b0:664:7e2e:ca76 with SMTP id x9-20020a5e8f49000000b006647e2eca76mr11610194iop.199.1653666564896;
        Fri, 27 May 2022 08:49:24 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k44-20020a056638372c00b0032e7b54eb01sm633089jav.157.2022.05.27.08.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 08:49:24 -0700 (PDT)
Message-ID: <ebf7c9e4-89cb-59e4-8304-d7f8a28966f3@kernel.dk>
Date:   Fri, 27 May 2022 09:49:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 2/3] bcache: avoid unnecessary soft lockup in kworker
 update_writeback_rate()
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20220527152818.27545-1-colyli@suse.de>
 <20220527152818.27545-3-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220527152818.27545-3-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/27/22 9:28 AM, Coly Li wrote:
> diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
> index d138a2d73240..c51671abe74e 100644
> --- a/drivers/md/bcache/writeback.c
> +++ b/drivers/md/bcache/writeback.c
> @@ -214,6 +214,7 @@ static void update_writeback_rate(struct work_struct *work)
>  					     struct cached_dev,
>  					     writeback_rate_update);
>  	struct cache_set *c = dc->disk.c;
> +	bool contention = false;
>  
>  	/*
>  	 * should check BCACHE_DEV_RATE_DW_RUNNING before calling
> @@ -243,13 +244,41 @@ static void update_writeback_rate(struct work_struct *work)
>  		 * in maximum writeback rate number(s).
>  		 */
>  		if (!set_at_max_writeback_rate(c, dc)) {
> -			down_read(&dc->writeback_lock);
> -			__update_writeback_rate(dc);
> -			update_gc_after_writeback(c);
> -			up_read(&dc->writeback_lock);
> +			/*
> +			 * When contention happens on dc->writeback_lock with
> +			 * the writeback thread, this kwork may be blocked for
> +			 * very long time if there are too many dirty data to
> +			 * writeback, and kerne message will complain a (bogus)
> +			 * software lockup kernel message. To avoid potential
> +			 * starving, if down_read_trylock() fails, writeback
> +			 * rate updating will be skipped for dc->retry_max times
> +			 * at most while delay this worker a bit longer time.
> +			 * If dc->retry_max times are tried and the trylock
> +			 * still fails, then call down_read() to wait for
> +			 * dc->writeback_lock.
> +			 */
> +			if (!down_read_trylock((&dc->writeback_lock))) {
> +				contention = true;
> +				dc->retry_nr++;
> +				if (dc->retry_nr > dc->retry_max)
> +					down_read(&dc->writeback_lock);
> +			}
> +
> +			if (!contention || dc->retry_nr > dc->retry_max) {
> +				__update_writeback_rate(dc);
> +				update_gc_after_writeback(c);
> +				up_read(&dc->writeback_lock);
> +				dc->retry_nr = 0;
> +			}
>  		}
>  	}

This is really not very pretty. First of all, why bother with storing a
max retry value in there? Doesn't seem like it'd ever be different per
'dc' anyway. Secondly, something like the below would be a lot more
readable. Totally untested.

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 9ee0005874cd..cbc01372c7a1 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -235,19 +235,27 @@ static void update_writeback_rate(struct work_struct *work)
 		return;
 	}
 
-	if (atomic_read(&dc->has_dirty) && dc->writeback_percent) {
+	if (atomic_read(&dc->has_dirty) && dc->writeback_percent &&
+	    !set_at_max_writeback_rate(c, dc)) {
 		/*
 		 * If the whole cache set is idle, set_at_max_writeback_rate()
 		 * will set writeback rate to a max number. Then it is
 		 * unncessary to update writeback rate for an idle cache set
 		 * in maximum writeback rate number(s).
 		 */
-		if (!set_at_max_writeback_rate(c, dc)) {
-			down_read(&dc->writeback_lock);
+		do {
+			if (!down_read_trylock(&dc->writeback_lock)) {
+				dc->rate_update_retry++;
+				if (dc->rate_update_retry < MY_MAX)
+					break;
+				down_read(&dc->writeback_lock);
+				dc->rate_update_retry = 0;
+			}
+
 			__update_writeback_rate(dc);
 			update_gc_after_writeback(c);
 			up_read(&dc->writeback_lock);
-		}
+		} while (0);
 	}
 
-- 
Jens Axboe

