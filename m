Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0E632BD54
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 23:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCCPpN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Mar 2021 10:45:13 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:13044 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhCCBJn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 20:09:43 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DqwN50qMmzMfyp
        for <linux-bcache@vger.kernel.org>; Wed,  3 Mar 2021 08:48:21 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Wed, 3 Mar 2021
 08:50:19 +0800
Subject: Re: [PATCH] bcache-tools: fix potential memoryleak problem in,
 may_add_item()
To:     Coly Li <colyli@suse.de>
CC:     linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        <linux-bcache@vger.kernel.org>
References: <c475bf5f-d284-aea9-5898-6ef3581138fb@huawei.com>
 <9e68d3fe-52bc-a496-5cad-ec47c1d295c1@suse.de>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <b44a1360-6496-61bf-3b0e-b132b0645f56@huawei.com>
Date:   Wed, 3 Mar 2021 08:50:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9e68d3fe-52bc-a496-5cad-ec47c1d295c1@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Thank you for doing that.

Zhiqiang Liu

On 2021/3/2 21:33, Coly Li wrote:
> On 2/27/21 10:38 AM, Zhiqiang Liu wrote:
>>
>> In may_add_item(), it will directly return 1 without freeing
>> variable tmp and closing fd, when the return value of detail_base()
>> is not equal to 0. In addition, we do not check whether
>> allocating memory for tmp is successful.
>>
>> Here, we will check whether malloc() returns NULL, and
>> will free tmp and close fd when detail_base() fails.
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
>>  lib.c | 28 +++++++++++++++++-----------
>>  1 file changed, 17 insertions(+), 11 deletions(-)
>>
>> diff --git a/lib.c b/lib.c
>> index 6341c61..745dab6 100644
>> --- a/lib.c
>> +++ b/lib.c
>> @@ -382,7 +382,7 @@ int may_add_item(char *devname, struct list_head *head)
>>  	struct cache_sb sb;
>>  	char dev[512];
>>  	struct dev *tmp;
>> -	int ret;
>> +	int ret = 0;
>>
>>  	if (strcmp(devname, ".") == 0 || strcmp(devname, "..") == 0)
>>  		return 0;
>> @@ -392,27 +392,33 @@ int may_add_item(char *devname, struct list_head *head)
>>  	if (fd == -1)
>>  		return 0;
>>
>> -	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk)) {
>> -		close(fd);
>> -		return 0;
>> -	}
>> +	if (pread(fd, &sb_disk, sizeof(sb_disk), SB_START) != sizeof(sb_disk))
>> +		goto out;
>>
>> -	if (memcmp(sb_disk.magic, bcache_magic, 16)) {
>> -		close(fd);
>> -		return 0;
>> -	}
>> +	if (memcmp(sb_disk.magic, bcache_magic, 16))
>> +		goto out;
>>
>>  	to_cache_sb(&sb, &sb_disk);
>>
>>  	tmp = (struct dev *) malloc(DEVLEN);
>> +	if (tmp == NULL) {
>> +		fprintf(stderr, "Error: fail to allocate memory buffer\n");
>> +		ret = 1;
>> +		goto out;
>> +	}
>> +
>>  	tmp->csum = le64_to_cpu(sb_disk.csum);
>>  	ret = detail_base(dev, sb, tmp);
>>  	if (ret != 0) {
>>  		fprintf(stderr, "Failed to get information for %s\n", dev);
>> -		return 1;
>> +		free(tmp);
>> +		goto out;
>>  	}
>>  	list_add_tail(&tmp->dev_list, head);
>> -	return 0;
>> +
>> +out:
>> +	close(fd);
>> +	return ret;
>>  }
>>
>>  int list_bdevs(struct list_head *head)
>>
> 
> 
> .
> 

