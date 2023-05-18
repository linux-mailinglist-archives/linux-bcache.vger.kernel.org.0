Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7F7707719
	for <lists+linux-bcache@lfdr.de>; Thu, 18 May 2023 02:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjERA5w (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 17 May 2023 20:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjERA5v (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 17 May 2023 20:57:51 -0400
X-Greylist: delayed 54395 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 May 2023 17:57:48 PDT
Received: from zg8tmja2lje4os4yms4ymjma.icoremail.net (zg8tmja2lje4os4yms4ymjma.icoremail.net [206.189.21.223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4D22F9
        for <linux-bcache@vger.kernel.org>; Wed, 17 May 2023 17:57:48 -0700 (PDT)
Received: from [10.8.148.37] (unknown [59.61.78.234])
        by app2 (Coremail) with SMTP id SyJltABnaxEGeGVkbTYCAA--.1284S2;
        Thu, 18 May 2023 08:57:42 +0800 (CST)
Message-ID: <f87c6930-c9a1-cccc-47a8-942eb2b4dbe2@wangsu.com>
Date:   Thu, 18 May 2023 08:57:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] bcache: fix nbuckets lower limit checking in
 read_super_common
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Bcache Linux <linux-bcache@vger.kernel.org>
References: <84456adb-2933-49a4-cf40-b58b19ddd178@wangsu.com>
 <DE163AE2-BC0A-4DFC-9987-24E5FFFAFCB0@suse.de>
From:   Lin Feng <linf@wangsu.com>
In-Reply-To: <DE163AE2-BC0A-4DFC-9987-24E5FFFAFCB0@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: SyJltABnaxEGeGVkbTYCAA--.1284S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw4rWFWxWFyDGry5uw4UArb_yoW8WF4kpF
        ZxKFy0yrW8Xr1UAFyqqF1F9a4Fvw42va1fW34UA3WxZrnIqFyavrWrKry3Wr1xXr1UXFs3
        tFWUuayfWF1fCFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkSb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK
        6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4
        CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r48
        McIj6xkF7I0En7xvr7AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY02Avz4vE14v_twCF04k20xvY0x0EwIxGrwCF04k2
        0xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU6SdyUUUUU
X-CM-SenderInfo: holqwq5zdqw23xof0z/
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



On 5/17/23 21:56, Coly Li wrote:
> 
> 
>> 2023年5月17日 11:51，Lin Feng <linf@wangsu.com> 写道：
>>
>> In fact due to this check in cache_alloc:
>>    free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
> 
> This was introduced from commit 78365411b344d (“bcache: Rework allocator reserves”).
> -       free = roundup_pow_of_two(ca->sb.nbuckets) >> 9;
> -       free = max_t(size_t, free, (prio_buckets(ca) + 8) * 2);
> +       free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
> 
>>    if (!free) {
>>        ret = -EPERM;
>>        err = "ca->sb.nbuckets is too small";
>>        goto err_free;
>>    }
>> we can only create bcache device with nbuckets greater than 512,
>> so this patch is to make the codes logic consistent.
>>
>> Signed-off-by: Lin Feng <linf@wangsu.com>
>> ---
>> drivers/md/bcache/super.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index 7e9d19fd21dd..681a7ea442b9 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -110,7 +110,7 @@ static const char *read_super_common(struct cache_sb *sb,  struct block_device *
>> goto err;
>>
>> err = "Not enough buckets";
>> - if (sb->nbuckets < 1 << 7)
>> + if (sb->nbuckets <= 1 << 9)
> 
> if (roundup_pow_of_two(ca->sb.nbuckets) < 1<< 10)
> 
> Might be more clear?

Yes, I also prefer your change :)

> 
>> goto err;
>>
>> err = "Bad block size (not power of 2)";
> 
> 
> 
> 
> In bcache-tools the minimum nbuckets is (1<<7) too. It is fine to modify it to 1<<10, I will modify bcache-tools too.
> 

bcache-tools also has this flaw, both are aligned to 1<<10 is a good choice!

Thanks,
linfeng

