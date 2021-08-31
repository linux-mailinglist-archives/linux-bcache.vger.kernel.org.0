Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD953FC081
	for <lists+linux-bcache@lfdr.de>; Tue, 31 Aug 2021 03:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbhHaBgI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Aug 2021 21:36:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43290 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbhHaBgH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Aug 2021 21:36:07 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 371982210E;
        Tue, 31 Aug 2021 01:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630373712; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UH8M/pg2BA9Ia7QWWGOMnNyT+jpZieQFNdDUlPPWRg=;
        b=oZB/zcjwAuccWfpsHincIY8Nz7MvOvWbdzF0BJXlVwGB/mgRKEhK4zscUI2iUab4uRqzZb
        Q0Fbx7B23UB88PLpBgHxopA3t3UvyQ9sAQNuwWLfyLiiSHDrmV0fgK9aqR3YA3FUOfMuBO
        JAax/fdZbBLe8T1q0h3b1FIb/fMPrHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630373712;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3UH8M/pg2BA9Ia7QWWGOMnNyT+jpZieQFNdDUlPPWRg=;
        b=qiFqiAYGptpOB4GkE3nrWVVWK+9g0Qs7rnXLfj3C6QigO6rHz4Kx8LE8OJG/pc0VbquZE7
        cSQyewfNhUG5qyCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3453F13A9B;
        Tue, 31 Aug 2021 01:35:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UP32AE+HLWFgWgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 Aug 2021 01:35:11 +0000
Subject: Re: [PATCH] bcache: remove the redundant judgment on bi_size
To:     Xifengfei <xi.fengfei@h3c.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>
References: <ed49f33da50e4f5c88f986c8ed239e78@h3c.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <51b8745f-a41e-a8cb-7921-847bcee4a157@suse.de>
Date:   Tue, 31 Aug 2021 09:35:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ed49f33da50e4f5c88f986c8ed239e78@h3c.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/30/21 2:29 PM, Xifengfei wrote:
> （Sorry, there was an obvious typo in the last email）
> Thanks a lot. I understand the purpose.
> So is the original judgment process too complicated?  Can we judge bi_size directly?  This will be more concise
>
> @@ -423,7 +423,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>          add_sequential(task);
>          i->sequential = 0;
>   found:
> -       if (i->sequential + bio->bi_iter.bi_size > i->sequential)
> +       if (bio->bi_iter.bi_size)
>                  i->sequential   += bio->bi_iter.bi_size;
>
>          i->last                  = bio_end_sector(bio);

The above change works, but the code readability decreased because 
how/why i->sequential is maintained is not that directly visible.

This is a difference of coding styles. IMHO for this particular case, 
the readability is more important than less CPU instructions.

Thanks.

Coly Li

> Thanks
> Fengfei
>
> -----邮件原件-----
> 发件人: Coly Li [mailto:colyli@suse.de]
> 发送时间: 2021年8月29日 15:50
> 收件人: xifengfei (RD) <xi.fengfei@h3c.com>
> 抄送: linux-bcache@vger.kernel.org; linux-kernel@vger.kernel.org; kent.overstreet@gmail.com
> 主题: Re: [PATCH] bcache: remove the redundant judgment on bi_size
>
> On 8/29/21 12:49 PM, Fengfei Xi wrote:
>> The bi_size is unsigned int type data not less than 0, so we can
>> directly add bi_size without extra judgment
>>
>> Signed-off-by: Fengfei Xi <xi.fengfei@h3c.com>
> NACK. The check is necessary to avoid redundant and unnecessary memory write.
>
> Coly Li
>
>> ---
>>    drivers/md/bcache/request.c | 4 +---
>>    1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
>> index 6d1de889b..2788eec3a 100644
>> --- a/drivers/md/bcache/request.c
>> +++ b/drivers/md/bcache/request.c
>> @@ -423,9 +423,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
>>    	add_sequential(task);
>>    	i->sequential = 0;
>>    found:
>> -	if (i->sequential + bio->bi_iter.bi_size > i->sequential)
>> -		i->sequential	+= bio->bi_iter.bi_size;
>> -
>> +	i->sequential		+= bio->bi_iter.bi_size;
>>    	i->last			 = bio_end_sector(bio);
>>    	i->jiffies		 = jiffies + msecs_to_jiffies(5000);
>>    	task->sequential_io	 = i->sequential;

