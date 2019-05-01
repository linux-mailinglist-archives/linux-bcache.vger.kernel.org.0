Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D9107EC
	for <lists+linux-bcache@lfdr.de>; Wed,  1 May 2019 14:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfEAMfg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 1 May 2019 08:35:36 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38373 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfEAMfg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 1 May 2019 08:35:36 -0400
Received: by mail-pg1-f196.google.com with SMTP id j26so8261566pgl.5
        for <linux-bcache@vger.kernel.org>; Wed, 01 May 2019 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kUaJWRb5jS6ZrUZXOphNsgHvkCpcxEGyaGwJKiM3a1k=;
        b=JgrmLDtko45TBfT/JhPCXxPdDbJYbcBNmhJE/GOo1C7M4mfjtYxZLResjbC+yGFv8s
         0cStFvBmKyNzy86Qx2j0L8lKdwevPzntBQvThyhuxJ7Eh1cyhl3/I/ZCa6sIGTLK1ZUW
         1qwoFwJUtqNHoyPBDqBbIGyULhEaUM6C5DFL3B07Ezs3gbeSb2JO9sad2xubj33jNXuO
         Bqj6afjsuUop/2a8nnT5/w/gftYBRJ09dlH9Ae8qKL3NqSUlMfSsJA/mIR2OsGTnsnPk
         ZvTPTAR7396EwP9xC6Jk0lcYO54Zl1iPQ51JHn/AuL7Pem0aaySVwEMgB3Frf2AaJxsT
         VL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kUaJWRb5jS6ZrUZXOphNsgHvkCpcxEGyaGwJKiM3a1k=;
        b=jTpTTREgVbRWDivk2Slwj4uiAeyAnxH5qZmv1vo1aV2pNUoQ3jw+6xexCj4Jz75hUb
         t4JGvsPYirZQM1kLH2K2/lmx+EUoBpDFUb2EvYx/dMTxLW7V0Ae8Y3vwdhZEAPumUd31
         8HVfBV7R29sFtfhTQpAOD6EY/XSYb4+r1JtLfI46ryHMHN5Vj08dRQmtR5xQCvmKFPmt
         zF4e2PTaxX8l/uDNMNOWd4MSMsaREnGUTiY24Plnm95hw49q505+pdeZiwc8bz3e0XmB
         64PnvnO8x53hRAx5WcONzl8dSVIWzyFVtSiiEXU9lFuhQUM8uds+9iU7nINdYBusgt54
         lzQA==
X-Gm-Message-State: APjAAAUcsdbGF0OQx1zlIR/IgoqZ0Tge0+AJfuPsRfPn3LAMWtmmksRR
        M/AOZycc6qujQiokRyk1mWqYvg==
X-Google-Smtp-Source: APXvYqzud9uzajCSxSbcc+YCDIjgeqJeSECGQzHPHFkvFG+Df5FzLmmxozpDTgDAZT5v860gCToZdQ==
X-Received: by 2002:a63:cf:: with SMTP id 198mr70726689pga.228.1556714134626;
        Wed, 01 May 2019 05:35:34 -0700 (PDT)
Received: from [192.168.1.121] (66.29.164.166.static.utbb.net. [66.29.164.166])
        by smtp.gmail.com with ESMTPSA id i129sm59619675pfc.163.2019.05.01.05.35.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 05:35:33 -0700 (PDT)
Subject: Re: [PATCH] bcache: remove redundant LIST_HEAD(journal) from
 run_cache_set()
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        juha.aatrokoski@aalto.fi, shhuiw@foxmail.com
References: <20190430140225.21642-1-colyli@suse.de>
 <0ded62e9-6135-6da1-312d-1ceb6160c93b@suse.de>
 <54478019-5427-266e-42c2-0d606c6e5ec3@kernel.dk>
 <b9036b88-9bd9-a96b-a7ed-96bd45708267@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87f49306-4b2e-111f-d6e3-e2929027f66d@kernel.dk>
Date:   Wed, 1 May 2019 06:35:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b9036b88-9bd9-a96b-a7ed-96bd45708267@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/1/19 12:43 AM, Coly Li wrote:
> On 2019/4/30 10:20 下午, Jens Axboe wrote:
>> On 4/30/19 8:05 AM, Coly Li wrote:
>>> On 2019/4/30 10:02 下午, Coly Li wrote:
>>>> Commit 95f18c9d1310 ("bcache: avoid potential memleak of list of
>>>> journal_replay(s) in the CACHE_SYNC branch of run_cache_set") forgets
>>>> to remove the original define of LIST_HEAD(journal), which makes
>>>> the change no take effect. This patch removes redundant variable
>>>> LIST_HEAD(journal) from run_cache_set(), to make Shenghui's fix
>>>> working.
>>>>
>>>> Reported-by: Juha Aatrokoski <juha.aatrokoski@aalto.fi>
>>>> Cc: Shenghui Wang <shhuiw@foxmail.com>
>>>> Signed-off-by: Coly Li <colyli@suse.de>
>>>> ---
>>>>  drivers/md/bcache/super.c | 1 -
>>>>  1 file changed, 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>>>> index 0ffe9acee9d8..1b63ac876169 100644
>>>> --- a/drivers/md/bcache/super.c
>>>> +++ b/drivers/md/bcache/super.c
>>>> @@ -1800,7 +1800,6 @@ static int run_cache_set(struct cache_set *c)
>>>>  	set_gc_sectors(c);
>>>>  
>>>>  	if (CACHE_SYNC(&c->sb)) {
>>>> -		LIST_HEAD(journal);
>>>>  		struct bkey *k;
>>>>  		struct jset *j;
>>>>  
>>>>
>>>
>>> Hi Jens,
>>>
>>> Please take this fix for the Linux v5.2 bcache series. It fixes a
>>> problem from
>>> [PATCH 18/18] bcache: avoid potential memleak of list of
>>> journal_replay(s) in the CACHE_SYNC branch of run_cache_set
>>> which is already in your for-next branch.
>>>
>>> Thanks to Juha for cache this bug, and thank you in advance for taking
>>> care of this.
>>
>> Applied, but please add Fixes: lines patches like that, it's not enough
>> to simply mention it in the commit message.
>>
> 
> I just re-send a V2 patch with adding the Fixes: line, thanks for taking
> care of this.

As I wrote, I already applied it and added the Fixes tag. Just a note
for future patches.

-- 
Jens Axboe

