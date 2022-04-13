Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D044FF9C5
	for <lists+linux-bcache@lfdr.de>; Wed, 13 Apr 2022 17:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiDMPM7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 13 Apr 2022 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbiDMPM6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 13 Apr 2022 11:12:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2408636310
        for <linux-bcache@vger.kernel.org>; Wed, 13 Apr 2022 08:10:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D3133210E3;
        Wed, 13 Apr 2022 15:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649862635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PC8sBZBNFZOu0FObr0v01fCfVxG3e9bmIEV5QuD7594=;
        b=wd+RzGXiOpY5bGtqgEtb8rJgx86AWHzJcI0D44W0Om8Vf2i31kqrg9RCSpra2J+r35nPvZ
        HrQTQB8c9mPAvzBBoD2c4EJ2EGw162EIlCGH/X/wOb8Cjb0iAoAPSzXj5RW2PwSY/ZrEnL
        5EIvtD6Pl/ltujyzsCpwGI8hZynAkAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649862635;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PC8sBZBNFZOu0FObr0v01fCfVxG3e9bmIEV5QuD7594=;
        b=G10IptBi9N5LPDofsBysaWxQ64T5owViDO3dQs5Jjdrb9seaVQY2q6XGM8mhNRtGcpPS0m
        kwl/sfaTH1O+reCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3DBE13AB8;
        Wed, 13 Apr 2022 15:10:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id guiiFurnVmIYKwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 13 Apr 2022 15:10:34 +0000
Message-ID: <a52ee12a-8b96-601a-7b09-c010d87744d0@suse.de>
Date:   Wed, 13 Apr 2022 23:10:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] bcache: check bch_cached_dev_attach() return value
Content-Language: en-US
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
Cc:     zoumingzhe@qq.com, linux-bcache@vger.kernel.org
References: <20220401122725.17725-1-mingzhe.zou@easystack.cn>
 <20220411030417.7222-1-mingzhe.zou@easystack.cn>
 <20220411030417.7222-3-mingzhe.zou@easystack.cn>
 <40068948-a978-512c-6338-4d37c0b4e5d4@easystack.cn>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <40068948-a978-512c-6338-4d37c0b4e5d4@easystack.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/13/22 8:42 PM, Zou Mingzhe wrote:
>
> 在 2022/4/11 11:04, mingzhe.zou@easystack.cn 写道:
>> From: ZouMingzhe <mingzhe.zou@easystack.cn>
>>
>> handle error when call bch_cached_dev_attach() function
>>
>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>> ---
>>   drivers/md/bcache/super.c | 25 +++++++++++++++++++------
>>   1 file changed, 19 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index e4a53c849fa6..940eea5f94de 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -1460,7 +1460,7 @@ static int register_bdev(struct cache_sb *sb, 
>> struct cache_sb_disk *sb_disk,
>>   {
>>       const char *err = "cannot allocate memory";
>>       struct cache_set *c;
>> -    int ret = -ENOMEM;
>> +    int ret = -ENOMEM, ret_tmp;
>>         memcpy(&dc->sb, sb, sizeof(struct cache_sb));
>>       dc->bdev = bdev;
>> @@ -1480,8 +1480,14 @@ static int register_bdev(struct cache_sb *sb, 
>> struct cache_sb_disk *sb_disk,
>>         list_add(&dc->list, &uncached_devices);
>>       /* attach to a matched cache set if it exists */
>> -    list_for_each_entry(c, &bch_cache_sets, list)
>> -        bch_cached_dev_attach(dc, c, NULL);
>> +    err = "failed to attach cached device";
>> +    list_for_each_entry(c, &bch_cache_sets, list) {
>> +        ret_tmp = bch_cached_dev_attach(dc, c, NULL);
>> +        if (ret_tmp)
>> +            ret = ret_tmp;
>> +    }
>> +    if (ret)
>> +        goto err;
>
> Hi, coly
>
> Wrong here.
>
> I have send v3.
>
> mingzhe


Sure. BTW, next time it would be more convenient for me if you post new 
version in another email thread. Otherwise there is a little chance that 
I am confused with previous patches.

Thanks.

Coly Li

