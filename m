Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D11530A83
	for <lists+linux-bcache@lfdr.de>; Mon, 23 May 2022 10:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiEWHdE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 May 2022 03:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiEWHcg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 May 2022 03:32:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365EE2600;
        Mon, 23 May 2022 00:31:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C529A1F383;
        Mon, 23 May 2022 06:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653287191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWdRYkYeTd6L1kFlWAZqosjLUp2g2JWMcn4ZCfMoyaE=;
        b=MUunQvOlxIOLBymvojg7kwEf0Fbin7+nEyYmtSE5BudcRbOIWYiNhDdJb+bWEw7pSpiGr1
        Et6xkbpJf0C0y4taW5t6NaSM3qwsDho9FagM8xigLBP2jfxZbVV0yjVkDAqqcUGq30uPH6
        ED2zLwll9WBxw2twcPgAd6sMLkNp6ug=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653287191;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWdRYkYeTd6L1kFlWAZqosjLUp2g2JWMcn4ZCfMoyaE=;
        b=rzRIP95V4SHfqW8hnDoxWJ2P5s3+LZbohbqSa3MqDGMxDCIQ0rSYbzZYzdHMluYmG3uT8D
        EAosH2b+wB72c9CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C550113AA5;
        Mon, 23 May 2022 06:26:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RFjLIRYpi2IFfQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 23 May 2022 06:26:30 +0000
Message-ID: <9c3fddec-1741-872f-1cdb-b44316e2ff64@suse.de>
Date:   Mon, 23 May 2022 14:26:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH 0/4] bcache patches for Linux v5.19 (1st wave)
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20220522170736.6582-1-colyli@suse.de>
 <ece7e00e-5d03-41c0-4013-75809958e9d7@kernel.dk>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <ece7e00e-5d03-41c0-4013-75809958e9d7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/23/22 1:43 AM, Jens Axboe wrote:
> On 5/22/22 11:07 AM, Coly Li wrote:
>> Hi Jens,
>>
>> The bcache has 4 patches for Linux v5.19 merge window, all from me.
>> - The first 2 patches are code clean up and potential bug fixes for
>> multi- threaded btree nodes check (for cache device) and dirty sectors
>> counting (for backing device), although no report from mailing list for
>> them, it is good to have the fixes.
>> - The 3rd patch removes incremental dirty sectors counting because it
>> is conflicted with multithreaded dirty sectors counting and the latter
>> one is 10x times faster.
>> - The last patch fixes a journal no-space deadlock during cache device
>> registration, it always reserves one journal bucket and only uses it
>> in registration time, so the no-spance condition won't happen anymore.
>>
>> There are still 2 fixes are still under the long time I/O pressure
>> testing, once they are accomplished, I will submit to you in later
>> RC cycles.
>>
>> Please take them, and thanks in advance.
> It's late for sending in that stuff, now I have to do a round 2 or
> your patches would get zero time in linux-next. Please send patches
> a week in advance at least, not on the day of release...
>
Hi Jens,

This time the situation was awkward, indeed I didn't expect I can submit 
the fix in this merge window, but just around 1 week before I found the 
difficult was from influence by other depending issues. After fixed all 
of them and do I/O pressure testing for 24x2 hours, it comes to such 
close day to the merge window.

My confusion was, it was very close to the merge window so maybe I 
should submit them in next merge window (5.20), but this series were bug 
fixes which should go into mainline earlier. It seems neither option was 
proper, so I chose the first one...

Could you give me a hint, what is the proper way that I should do for 
such situation? Then I will try to follow that and avoid adding more 
workload to you.

Thanks in advance.


Coly Li

