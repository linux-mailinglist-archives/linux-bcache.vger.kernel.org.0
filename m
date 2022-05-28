Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92383536CCB
	for <lists+linux-bcache@lfdr.de>; Sat, 28 May 2022 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiE1MUM (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 28 May 2022 08:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351952AbiE1MUH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 28 May 2022 08:20:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA5F1DA60
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:20:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q4so6351681plr.11
        for <linux-bcache@vger.kernel.org>; Sat, 28 May 2022 05:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y77sSvpwInuFJDiNYp/3GCu0KvBwGdgfHS//h3DpWbM=;
        b=VxsGWE4ml7nFCgy1+eZ+wz6x/fGWVT/fa8zyF1euXXpTclJf4tuZl7Hsb+GtorsgJX
         1d4NcwJ/3OOKVqaI3e69Dla5Es+7rtJKDoGDSYUofbziAKAy2jhihAb8yc4UOmgR1Zj0
         wUqbIeTbNtx5WgA+kNnIpsOqGK09nq+eb4ggTmUrPJQhrrITeYR8/baK2yQR3fh9S93L
         4j68XsBEixxOsQq6oirLkA/dk9YnVswqGrCls5o8UaQ33s345BY3eR3QebZdJ5014Ilt
         yhB27pOvZJXMAEToqO4ETFAJROzt9eHtlA6iPI6ovoe2gCD9Lvl56IP1nCrmJ2ZBMJfj
         11xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y77sSvpwInuFJDiNYp/3GCu0KvBwGdgfHS//h3DpWbM=;
        b=aHBGh4oYbiwAgUgqyATnHSfRy+OlCf6/So1wNsZNrN92mPXOz/78Ngy9YYjgr0jQRc
         vOdmPLS+0z3HO7aXY9O87QtvGYHpzqyILZaj8d5bsqa8GAXgFQp2N1mDfLHC54TBSXK3
         A1phBcZpus8bM35Qqf69Ll5FPkivuaDj51wVwtwTWynLyWN+BM3cd2XYIxLQLWnqZ8b0
         mqXZnOMOOTUeobo1/GYnIK7365zTu6+zTSrGouVOgqkK8HxnbBXUp5O1Uxdm5YpRmnMk
         EatjVDKE++spFly4p0KHiw1HUM9Gp1OBAs1aTLw3tCaEkXjTM5Yz/G/fUoQtj4QnA+gv
         IJFQ==
X-Gm-Message-State: AOAM5316pudwdEIpT2iAwFB4K33pR67dI2cEPKV0JANY+5ZpFCeflcdd
        E1tQxoMa0oUMcspT9qmLZRx8fA==
X-Google-Smtp-Source: ABdhPJyAphsKmZO7ie8SGqewH6n/13vXkWFJfFnldWE/6AMkmHNKDXBGpU7vJN2nwsMr0h9rGGdcHA==
X-Received: by 2002:a17:903:213:b0:15f:4ea:cd63 with SMTP id r19-20020a170903021300b0015f04eacd63mr48068332plh.68.1653740404711;
        Sat, 28 May 2022 05:20:04 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902f65000b0015e8d4eb2ccsm5472254plg.278.2022.05.28.05.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 May 2022 05:20:03 -0700 (PDT)
Message-ID: <8a45c9fa-4cd8-e0e0-63f3-03adb761f9ca@kernel.dk>
Date:   Sat, 28 May 2022 06:20:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/1] bcache: avoid unnecessary soft lockup in kworker
 update_writeback_rate()
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
References: <20220528061949.28519-1-colyli@suse.de>
 <20220528061949.28519-2-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220528061949.28519-2-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/28/22 12:19 AM, Coly Li wrote:
> The kworker routine update_writeback_rate() is schedued to update the
> writeback rate in every 5 seconds by default. Before calling
> __update_writeback_rate() to do real job, semaphore dc->writeback_lock
> should be held by the kworker routine.
> 
> At the same time, bcache writeback thread routine bch_writeback_thread()
> also needs to hold dc->writeback_lock before flushing dirty data back
> into the backing device. If the dirty data set is large, it might be
> very long time for bch_writeback_thread() to scan all dirty buckets and
> releases dc->writeback_lock. In such case update_writeback_rate() can be
> starved for long enough time so that kernel reports a soft lockup warn-
> ing started like:
>   watchdog: BUG: soft lockup - CPU#246 stuck for 23s! [kworker/246:31:179713]
> 
> Such soft lockup condition is unnecessary, because after the writeback
> thread finishes its job and releases dc->writeback_lock, the kworker
> update_writeback_rate() may continue to work and everything is fine
> indeed.
> 
> This patch avoids the unnecessary soft lockup by the following method,
> - Add new member to struct cached_dev
>   - dc->rate_update_retry (0 by default)
> - In update_writeback_rate() call down_read_trylock(&dc->writeback_lock)
>   firstly, if it fails then lock contention happens.
> - If dc->rate_update_retry <= BCH_WBRATE_UPDATE_RETRY_MAX (15), doesn't
>   acquire the lock and reschedules the kworker for next try.
> - If dc->rate_update_retry > BCH_WBRATE_UPDATE_RETRY_MAX, no retry
>   anymore and call down_read(&dc->writeback_lock) to wait for the lock.
> 
> By the above method, at worst case update_writeback_rate() may retry for
> 1+ minutes before blocking on dc->writeback_lock by calling down_read().
> For a 4TB cache device with 1TB dirty data, 90%+ of the unnecessary soft
> lockup warning message can be avoided.
> 
> When retrying to acquire dc->writeback_lock in update_writeback_rate(),
> of course the writeback rate cannot be updated. It is fair, because when
> the kworker is blocked on the lock contention of dc->writeback_lock, the
> writeback rate cannot be updated neither.
> 
> This change follows Jens Axboe's suggestion to a more clear and simple
> version.

This looks fine, but it doesn't apply to my current for-5.19/drivers
branch which the previous ones did. Did you spin this one without the
other patches, perhaps?

One minor thing we might want to change if you're respinning it -
BCH_WBRATE_UPDATE_RETRY_MAX isn't really named for what it does, since
it doesn't retry anything, it simply allows updates to be skipped. Why
not call it BCH_WBRATE_UPDATE_MAX_SKIPS instead? I think that'd be
better convey what it does.

-- 
Jens Axboe

