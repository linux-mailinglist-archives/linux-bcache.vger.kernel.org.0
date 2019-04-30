Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA140FB48
	for <lists+linux-bcache@lfdr.de>; Tue, 30 Apr 2019 16:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbfD3OUr (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 30 Apr 2019 10:20:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38999 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbfD3OUq (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 30 Apr 2019 10:20:46 -0400
Received: by mail-io1-f66.google.com with SMTP id c3so12354031iok.6
        for <linux-bcache@vger.kernel.org>; Tue, 30 Apr 2019 07:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pGJDbTifmKOXHUXSOgXNr5O3AzGnlOGhobGhD+Vxa/s=;
        b=fc0E0NNjHm1VrOynn1PfvncvadlC9M6jrHsEN01IjXc7jFd4EakRWg1w2dhTQTxfW0
         SfQtQBvtgKdOexiXCjui1zSVXAeT3zgb/hxGkrSHbjLPTMfxspotypyIswEgDqa4DUAw
         KhcZWhDMfop4qNu8bh/7XElmF8PuC9zVqQQkh8K4uWikmz7gaOJ6RsWIF7HpV81+eSbV
         XsKfi7647gi0t8HZToVlZdN0BU0VaVSTwc1zfARsh4wAA6JicMlBjMdvsienld0xFPyw
         qSjfXVmg8YTyyscSlkTK3crriTIA0ToGwMUyiAfx5n/2wQFaOUDeOWVxooUvweRcDyVk
         LgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pGJDbTifmKOXHUXSOgXNr5O3AzGnlOGhobGhD+Vxa/s=;
        b=hsXJkJ9zbXfsfg3ukPChvaSxXMT7oRz0DHrftStRCFErA53tTB2fMJSJQXnP5ABJxQ
         +9yeKRWhsxiEwZA2gn4HzmrGpoOLMPAB0aUYEEYA9xpbsI26R4OsG1BueWgZD4OxcyLZ
         52LuemuxOipG/JY+ZUc+Xr6Yf1iq8Tiij/i3vPKjP35C35yWG8zlMxT91h2WaDGsl1AR
         Ar8Vvd1iJinxOx9U6pRfoRcZ41GCrwQSx3S/H3gAloV+53jtiui2iexCItUX6pgrbcMw
         0BQKvfwbrPB1zUmkr2MR3eUGTFGEX5xWd0UTHSfBNkFSZthfhAxWW63Ng/HCPk2YiEl7
         E3PA==
X-Gm-Message-State: APjAAAXrXHDeDypUTobCgnLU6y2NB+KY0R/gK8HhwaNKlhB9yRGTIO4H
        a7T4nPSs4EjbkdO2eJ1dd+/vpg==
X-Google-Smtp-Source: APXvYqx8h2B08Z9UhHjfFHDvdvn4FbUMsLsrFFz1DYs4slmy+QXvci+IiMviVShW+rAQ+8J+4bnaEQ==
X-Received: by 2002:a5d:9d0a:: with SMTP id j10mr10029789ioj.196.1556634045871;
        Tue, 30 Apr 2019 07:20:45 -0700 (PDT)
Received: from [192.168.1.158] ([216.160.245.98])
        by smtp.gmail.com with ESMTPSA id 3sm1735564itk.1.2019.04.30.07.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 07:20:44 -0700 (PDT)
Subject: Re: [PATCH] bcache: remove redundant LIST_HEAD(journal) from
 run_cache_set()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        juha.aatrokoski@aalto.fi, shhuiw@foxmail.com
References: <20190430140225.21642-1-colyli@suse.de>
 <0ded62e9-6135-6da1-312d-1ceb6160c93b@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <54478019-5427-266e-42c2-0d606c6e5ec3@kernel.dk>
Date:   Tue, 30 Apr 2019 08:20:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <0ded62e9-6135-6da1-312d-1ceb6160c93b@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/30/19 8:05 AM, Coly Li wrote:
> On 2019/4/30 10:02 下午, Coly Li wrote:
>> Commit 95f18c9d1310 ("bcache: avoid potential memleak of list of
>> journal_replay(s) in the CACHE_SYNC branch of run_cache_set") forgets
>> to remove the original define of LIST_HEAD(journal), which makes
>> the change no take effect. This patch removes redundant variable
>> LIST_HEAD(journal) from run_cache_set(), to make Shenghui's fix
>> working.
>>
>> Reported-by: Juha Aatrokoski <juha.aatrokoski@aalto.fi>
>> Cc: Shenghui Wang <shhuiw@foxmail.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/super.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 0ffe9acee9d8..1b63ac876169 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1800,7 +1800,6 @@ static int run_cache_set(struct cache_set *c)
>>  	set_gc_sectors(c);
>>  
>>  	if (CACHE_SYNC(&c->sb)) {
>> -		LIST_HEAD(journal);
>>  		struct bkey *k;
>>  		struct jset *j;
>>  
>>
> 
> Hi Jens,
> 
> Please take this fix for the Linux v5.2 bcache series. It fixes a
> problem from
> [PATCH 18/18] bcache: avoid potential memleak of list of
> journal_replay(s) in the CACHE_SYNC branch of run_cache_set
> which is already in your for-next branch.
> 
> Thanks to Juha for cache this bug, and thank you in advance for taking
> care of this.

Applied, but please add Fixes: lines patches like that, it's not enough
to simply mention it in the commit message.

-- 
Jens Axboe

