Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA4B527B84
	for <lists+linux-bcache@lfdr.de>; Mon, 16 May 2022 03:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiEPBud (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 15 May 2022 21:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239155AbiEPBub (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 15 May 2022 21:50:31 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id DEDF238A1;
        Sun, 15 May 2022 18:50:25 -0700 (PDT)
Received: from [10.8.148.37] (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltACXhcTfrYFiH34AAA--.113S2;
        Mon, 16 May 2022 09:50:23 +0800 (CST)
Message-ID: <0010ee74-0aac-e998-c74b-84bf7de23335@wangsu.com>
Date:   Mon, 16 May 2022 09:50:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] bcache: fix wrong BITMASK offset value for
 BDEV_CACHE_MODE
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
References: <20210720103246.112027-1-linf@wangsu.com>
 <f80cefa2-e238-9939-5f48-9d84bcc248f3@suse.de>
From:   Lin Feng <linf@wangsu.com>
In-Reply-To: <f80cefa2-e238-9939-5f48-9d84bcc248f3@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: SyJltACXhcTfrYFiH34AAA--.113S2
X-Coremail-Antispam: 1UD129KBjvJXoW7urW8Ww13Zr15Cw4rtrWUArb_yoW8CFyfpa
        s5JF4rJF48Xa4I9w1xAF4agrsYv3yrJas3Z34UWF15ury3tw1Fqryruw4Yyr95C3yvkr4I
        yF1DK345GFW8uFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkSb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Yx0Ec7CjxVAajcxG14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_KwCF04k20xvY0x0EwIxGrwCF04k2
        0xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUTs2-UUUUU
X-CM-SenderInfo: holqwq5zdqw23xof0z/
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 5/13/22 23:20, Coly Li wrote:
> On 7/20/21 6:32 PM, Lin Feng wrote:
>> Original codes:
>> BITMASK(CACHE_SYNC,			struct cache_sb, flags, 0, 1);
>> BITMASK(CACHE_DISCARD,			struct cache_sb, flags, 1, 1);
>> BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
>> ...
>> BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
>>
>> Should BDEV_CACHE_MODE bits start from bit-nr 5(2+3) else it overlaps
>> with previous defined bit chunks, since we have 4 types of cache modes,
>> BDEV_CACHE_MODE will overwrite CACHE_SYNC and CACHE_DISCARD bits.
> 
> The overlap won't happen, previous lines are for cache device, and what
> you modified is for backing device.
> 
> And your patch changes the on-disk format, which is unacceptable anyway.
> 

Yes, you are right, this patch happened as I started reading bcache codes,
I did not get a whole picture of bcache at that time, I'm sorry for making
noise.

Thank you, Coly!

linfeng
> 
> Coly Li
> 
>>
>> This bug stays there since first upstream version of bcache, don't know
>> why it lives so long, or am i missing something, please point me out
>> if I'm wrong, thanks!
>>
>> Signed-off-by: Lin Feng <linf@wangsu.com>
>> ---
>>    include/uapi/linux/bcache.h | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/bcache.h b/include/uapi/linux/bcache.h
>> index cf7399f03b71..dccd89756451 100644
>> --- a/include/uapi/linux/bcache.h
>> +++ b/include/uapi/linux/bcache.h
>> @@ -288,7 +288,7 @@ BITMASK(CACHE_REPLACEMENT,		struct cache_sb, flags, 2, 3);
>>    #define CACHE_REPLACEMENT_FIFO		1U
>>    #define CACHE_REPLACEMENT_RANDOM	2U
>>    
>> -BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 0, 4);
>> +BITMASK(BDEV_CACHE_MODE,		struct cache_sb, flags, 5, 4);
>>    #define CACHE_MODE_WRITETHROUGH		0U
>>    #define CACHE_MODE_WRITEBACK		1U
>>    #define CACHE_MODE_WRITEAROUND		2U
> 

