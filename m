Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA692ECA4B
	for <lists+linux-bcache@lfdr.de>; Thu,  7 Jan 2021 07:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbhAGGAI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 7 Jan 2021 01:00:08 -0500
Received: from mail.wangsu.com ([123.103.51.227]:36894 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725929AbhAGGAI (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 7 Jan 2021 01:00:08 -0500
Received: from [10.8.148.37] (unknown [59.61.78.237])
        by app2 (Coremail) with SMTP id 4zNnewAXHsYNo_ZfbTMEAA--.1839S2;
        Thu, 07 Jan 2021 13:58:37 +0800 (CST)
Subject: Re: Defects about bcache GC
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        linux-bcache@vger.kernel.org
References: <5768fb38-743a-42e7-a6b6-a12d7ea9f3f0@wangsu.com>
 <ec826f2c-d0de-157f-c4d2-fa9325c83014@easystack.cn>
From:   Lin Feng <linf@wangsu.com>
Message-ID: <747feeb9-d469-b75d-e4ca-c5f4d0081cdd@wangsu.com>
Date:   Thu, 7 Jan 2021 13:58:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <ec826f2c-d0de-157f-c4d2-fa9325c83014@easystack.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 4zNnewAXHsYNo_ZfbTMEAA--.1839S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr43ZF47GFWUXry8tr13Jwb_yoWrAry8pF
        s5JF13KrW8Wrn3JrW2yFyUJryUtryUJwn8Grn5JF17J34aq3Wqqw1DXw12g3ZIyF4xCF4D
        Jr1UJF43ur4avaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkvb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vE
        x4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
        vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1sIEY20_Gr4l
        Yx0Ec7CjxVAajcxG14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkIecxEwVAFwVW8WwCF04k20xvY0x0EwIxGrwCF04k2
        0xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07U2LvtUUUUU=
X-CM-SenderInfo: holqwq5zdqw23xof0z/
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Yang,

Thanks for your reply!
Happy to try the patch and I will give you feedback!

linfeng
On 1/5/21 16:29, Dongsheng Yang wrote:
> Hi Lin,
> 
>       There is a patch for this situation:
> https://www.spinics.net/lists/linux-bcache/msg08870.html
> 
>       That's not in mainline yet, and not tested widely. You can give it
> a try if you are interested in.
> 
> 
> Thanx
> 
> 在 2020/12/18 星期五 下午 6:35, Lin Feng 写道:
>> Hi all,
>>
>> I googled a lot but only finding this, my question is if this issue
>> have been fixed or
>> if there are ways to work around?
>>
>>> On Wed, 28 Jun 2017, Coly Li wrote:
>>>
>>>> On 2017/6/27 下午8:04, tang.junhui@xxxxxxxxxx wrote:
>>>>> Hello Eric, Coly,
>>>>>
>>>>> I use a 1400G SSD device a bcache cache device,
>>>>> and attach with 10 back-end devices,
>>>>> and run random small write IOs,
>>>>> when gc works, It takes about 15 seconds,
>>>>> and the up layer application IOs was suspended at this time,
>>>>> How could we bear such a long time IO stopping?
>>>>> Is there any way we can avoid this problem?
>>>>>
>>>>> I am very anxious about this question, any comment would be
>> valuable.
>>>>
>>>> I encounter same situation too.
>>>> Hmm, I assume there are some locking issue here, to prevent
>> application
>>>> to send request and insert keys in LSM tree, no matter in
>> writeback or
>>>> writethrough mode. This is a lazy and fast response, I need to
>> check the
>>>> code then provide an accurate reply :-)
>>>
>>
>> I encoutered even worse situation(8TB ssd cached for 4*10 TB disks) as
>> mail extracted above,
>> all usrer IOs are hung during bcache GC runs, my kernel is 4.18, while
>> I tested it with kernel 5.10,
>> it seems that situation is unchaged.
>>
>> Below are some logs for reference.
>> GC trace events:
>> [Wed Dec 16 15:08:40 2020]   ##48735 [046] .... 1632697.784097:
>> bcache_gc_start: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
>> [Wed Dec 16 15:09:01 2020]   ##48735 [034] .... 1632718.828510:
>> bcache_gc_end: 4ab63029-0c4a-42a8-8f54-e638358c2c6c
>>
>> and during which iostat shows like:
>> 12/16/2020 03:08:48 PM
>> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s
>> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
>> sdb               0.00     0.50 1325.00   27.00 169600.00 122.00
>> 251.07     0.32    0.24    0.24    0.02   0.13  17.90
>> sdc               0.00     0.00    0.00    0.00     0.00 0.00
>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> sdd               0.00     0.00    0.00    0.00     0.00 0.00
>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> sde               0.00     0.00    0.00    0.00     0.00 0.00
>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> sdf               0.00     0.00    0.00    0.00     0.00 0.00
>> 0.00     0.00    0.00    0.00    0.00   0.00   0.00
>> bcache0           0.00     0.00    1.00    0.00     4.00 0.00
>> 8.00    39.54    0.00    0.00    0.00 1000.00 100.00
>>
>> # grep .
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/*gc*
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_duration_ms:26539
>>
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_average_frequency_sec:8692
>>
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_last_sec:6328
>>
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/btree_gc_max_duration_ms:283405
>>
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/copy_gc_enabled:1
>>
>> /sys/fs/bcache/4ab63029-0c4a-42a8-8f54-e638358c2c6c/internal/gc_always_rewrite:1
>>
>>
>> Thanks and Best wishes!
>> linfeng
>>

