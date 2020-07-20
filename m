Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE92255B7
	for <lists+linux-bcache@lfdr.de>; Mon, 20 Jul 2020 04:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgGTCC2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 19 Jul 2020 22:02:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8328 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726225AbgGTCC1 (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 19 Jul 2020 22:02:27 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 70072127977A10258C6E;
        Mon, 20 Jul 2020 10:02:25 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.91) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 10:02:20 +0800
Subject: Re: [PATCH -next] memory: Convert to DEFINE_SHOW_ATTRIBUTE
To:     Pavel Machek <pavel@denx.de>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        <linux-bcache@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200716090303.13154-1-miaoqinglang@huawei.com>
 <20200717211420.GA4140@amd>
From:   miaoqinglang <miaoqinglang@huawei.com>
Message-ID: <55762551-4f14-b7f8-c2ae-e93e75ef3299@huawei.com>
Date:   Mon, 20 Jul 2020 10:02:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200717211420.GA4140@amd>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.91]
X-CFilter-Loop: Reflected
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



在 2020/7/18 5:14, Pavel Machek 写道:
> On Thu 2020-07-16 17:03:03, Qinglang Miao wrote:
>> From: Yongqiang Liu <liuyongqiang13@huawei.com>
>>
>> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>>
>> Signed-off-by: Yongqiang Liu <liuyongqiang13@huawei.com>
>> ---
>>   drivers/memory/emif.c               | 22 ++--------------------
>>   drivers/memory/tegra/tegra124-emc.c | 14 +-------------
>>   2 files changed, 3 insertions(+), 33 deletions(-)
>>
>> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
>> index 58a82eea5..aab8ddad7 100644
>> --- a/drivers/memory/emif.c
>> +++ b/drivers/memory/emif.c
>> @@ -131,16 +131,7 @@ static int emif_regdump_show(struct seq_file *s, void *unused)
>>   	return 0;
>>   }
>>   
>> -static int emif_regdump_open(struct inode *inode, struct file *file)
>> -{
>> -	return single_open(file, emif_regdump_show, inode->i_private);
>> -}
>> -
>> -static const struct file_operations emif_regdump_fops = {
>> -	.open			= emif_regdump_open,
>> -	.read_iter			= seq_read_iter,
>> -	.release		= single_release,
>> -};
>> +DEFINE_SHOW_ATTRIBUTE(emif_regdump);
> 
> This is not equivalent (and I guess changelog should mention that).
> 
> Along with other changes, we get:
> 
>          .owner          = THIS_MODULE,
>          .llseek         = seq_lseek,
> 
> . Is that okay thing to add?
> 									Pavel
> 
Hi Pavel,

​You're right, I should of mention it in changelog.

​There's no impact theoretically with these two changes. Here's my thoughs:

1. The llseek method is used to change the current read/write position 
in a file which can be ignored if you don't use it.
2. The owner is not even a method. Instead, it is a pointer to the 
module that “owns” this structure; it is used by the kernel to maintain 
the module's usage count which I believe can be ignored.

If you don't mind I can send a new patch with more specific changelog.

​Thanks.

Qinglang

.



