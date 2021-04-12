Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13AC35C6BB
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Apr 2021 14:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbhDLMvS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 12 Apr 2021 08:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbhDLMvS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Apr 2021 08:51:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4074CC061574
        for <linux-bcache@vger.kernel.org>; Mon, 12 Apr 2021 05:51:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s14so1749092pjl.5
        for <linux-bcache@vger.kernel.org>; Mon, 12 Apr 2021 05:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WkGmlX5ftli+EWO0CazbhQyRHDGa3y5/GM0CgYRRd1M=;
        b=Lqtt/R+PG7FyygYH8QWNBcksgjCfvw3n0LsPgd2jafIpF+AOIesjGp4KpltidruzhF
         e7C3PfEzwzsyVIJOCtvB1k5IyFGbYrKYqD+DP6rn90TIIi9AM82N5QKr37++D2NSo4nD
         EzOSkI6e8jm+pwGSx93mnS2ZAukznrIrSWAECXS/icMcRUFBKrjOJ+2LbDVvSvYM3QJK
         PRtWyzZhjwmcxuVi0XrWna1T3MlUi8FuUskVPGpGEt7+56w/pj2YhbjEpFgt6HNFeLA2
         hKE0cWDKWjoWpBU8Ml7UdRRM32wo2s+6T8MTkzOp83dcoQTBhIeIS9gJ/hPGu3TiSQYT
         E95Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WkGmlX5ftli+EWO0CazbhQyRHDGa3y5/GM0CgYRRd1M=;
        b=q5RubFy12WuU/dsLgG/KokUaz727j1No3yBL2naOJKcLygXKLM8ltVqRz6oMeW3zRt
         bqObfdQ7968JJRj+B0XjB5hSLjHFoEKoHXa7nRUFMGG+kwsS4EhscwJKhp7+2KvkPuoW
         VRe/Z6CgwpbpbDHmMT21XLqJkQABFF4Jwiq+7Ni5zZL++nryLcMsc/+8JvcPZqEskJZ/
         QmvUX0VXz10gG113+Yw/hRjNsc+OBE20KEf+bAWIJp8HZeo1sIHB7DUyoB4LUI64zGIq
         wLxwjOvbHqB2Z2dnxAi9p9tBJ6rKN9gUDWOS9bx55cHakuwX/kd3ebQi05u+yZ2cTcCi
         YEjg==
X-Gm-Message-State: AOAM532T7XZutHkYCOCQRBhcrZIUHVpXF7uyJVoGpuU1OIXg4arnPHfH
        hT4ltspiplLzxTWh4aAK/cOwkg==
X-Google-Smtp-Source: ABdhPJyy1UDIsMLd9649fHgbN//VtPaMUUZoKH4yE05p/csBlFuaRkmxgj2LbJ+5WJw0hXX56TEAiA==
X-Received: by 2002:a17:90a:8914:: with SMTP id u20mr27931995pjn.90.1618231859779;
        Mon, 12 Apr 2021 05:50:59 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a25sm5454429pfo.27.2021.04.12.05.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Apr 2021 05:50:59 -0700 (PDT)
Subject: Re: [PATCH 7/7] bcache: fix a regression of code compiling failure in
 debug.c
To:     Coly Li <colyli@suse.de>, Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20210411134316.80274-1-colyli@suse.de>
 <20210411134316.80274-8-colyli@suse.de> <20210412090600.GA8026@lst.de>
 <902e1ba6-cd73-b0e8-6c17-75fccbaeb9b4@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <caf688de-19f6-925e-3059-966fe0d8ce42@kernel.dk>
Date:   Mon, 12 Apr 2021 06:50:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <902e1ba6-cd73-b0e8-6c17-75fccbaeb9b4@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/12/21 3:53 AM, Coly Li wrote:
> On 4/12/21 5:06 PM, Christoph Hellwig wrote:
>> On Sun, Apr 11, 2021 at 09:43:16PM +0800, Coly Li wrote:
>>> The patch "bcache: remove PTR_CACHE" introduces a compiling failure in
>>> debug.c with following error message,
>>>   In file included from drivers/md/bcache/bcache.h:182:0,
>>>                    from drivers/md/bcache/debug.c:9:
>>>   drivers/md/bcache/debug.c: In function 'bch_btree_verify':
>>>   drivers/md/bcache/debug.c:53:19: error: 'c' undeclared (first use in
>>>   this function)
>>>     bio_set_dev(bio, c->cache->bdev);
>>>                      ^
>>> This patch fixes the regression by replacing c->cache->bdev by b->c->
>>> cache->bdev.
>>
>> Why not fold this into the offending patch?
>>
> 
> I don't know whether I can do it without authorization or agreement from
> original author. And I see other maintainers handling similar situation
> by either re-write whole patch or appending an extra fix.
> 
> If you have a suggested process, I can try it out next time for similar
> situation.

What I generally do is just add a line between the SOB's for cases
like this, ala:

commit 70aacfe66136809d7f080f89c492c278298719f4
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Mar 1 13:02:15 2021 +0000

    io_uring: kill sqo_dead and sqo submission halting
    
    As SQPOLL task doesn't poke into ->sqo_task anymore, there is no need to
    kill the sqo when the master task exits. Before it was necessary to
    avoid races accessing sqo_task->files with removing them.
    
    Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
    [axboe: don't forget to enable SQPOLL before exit, if started disabled]
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

