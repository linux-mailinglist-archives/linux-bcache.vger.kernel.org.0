Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A3632BD62
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 23:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhCCPxR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Mar 2021 10:53:17 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12673 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhCCBKC (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 20:10:02 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DqwND092WzlR3B
        for <linux-bcache@vger.kernel.org>; Wed,  3 Mar 2021 08:48:28 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Wed, 3 Mar 2021
 08:50:25 +0800
Subject: Re: [PATCH] bcache-tools: check whether allocating memory fails in
 tree()
To:     Coly Li <colyli@suse.de>, <linux-bcache@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "lijinlin (A)" <lijinlin3@huawei.com>
References: <655607db-abc7-3241-cf14-e6efbec8331a@huawei.com>
 <66442e3c-7939-e4af-1924-2f742529383e@suse.de>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <35236da4-66cb-2477-c5b5-2e3185658c06@huawei.com>
Date:   Wed, 3 Mar 2021 08:50:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <66442e3c-7939-e4af-1924-2f742529383e@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thank you for doing that.

Zhiqiang Liu

On 2021/3/2 21:33, Coly Li wrote:
> On 2/27/21 10:35 AM, Zhiqiang Liu wrote:
>>
>> In tree(), we do not check whether malloc() returns NULL,
>> it may cause potential Null pointer dereference problem.
>> In addition, when we fail to list devices, we should free(out)
>> before return.
>>
>> Signed-off-by: ZhiqiangLiu <lzhq28@mail.ustc.edu.cn>
> 
> Applied. BTW, I change your above name string from ZhiqiangLiu to
> Zhiqiang Liu, because of the checkpatch.pl warning.
> 
> 
> Thanks.
> 
> Coly Li
> 
> 
>> ---
>>  bcache.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/bcache.c b/bcache.c
>> index 044d401..1c4cef9 100644
>> --- a/bcache.c
>> +++ b/bcache.c
>> @@ -174,7 +174,7 @@ void replace_line(char **dest, const char *from, const char *to)
>>
>>  int tree(void)
>>  {
>> -	char *out = (char *)malloc(4096);
>> +	char *out;
>>  	const char *begin = ".\n";
>>  	const char *middle = "├─";
>>  	const char *tail = "└─";
>> @@ -184,8 +184,15 @@ int tree(void)
>>  	INIT_LIST_HEAD(&head);
>>  	int ret;
>>
>> +	out = (char *)malloc(4096);
>> +	if (out == NULL) {
>> +		fprintf(stderr, "Error: fail to allocate memory buffer\n");
>> +		return 1;
>> +	}
>> +
>>  	ret = list_bdevs(&head);
>>  	if (ret != 0) {
>> +		free(out);
>>  		fprintf(stderr, "Failed to list devices\n");
>>  		return ret;
>>  	}
>>
> 
> 
> .
> 

