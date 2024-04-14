Return-Path: <linux-bcache+bounces-400-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ECDDB8A412D
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Apr 2024 10:24:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74A681F21EC6
	for <lists+linux-bcache@lfdr.de>; Sun, 14 Apr 2024 08:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0A421A19;
	Sun, 14 Apr 2024 08:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="othdOT1W"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7608C15E9B;
	Sun, 14 Apr 2024 08:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713083086; cv=none; b=QupputSaQjQgliVnQORG7wa5KS5grGfIOaaqhX16NsNlb0QelvH6aEAhuZ2EAD9VD+lAgmNvZ+Akj4CXAGdKAJamgDENhwcaNPTg1QL/vqQzTXmg+fl18HWl/3/QWaoYk8h9aqZHevi7KXF4kgrIVo4HncA1a813BHy0M4xyL2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713083086; c=relaxed/simple;
	bh=2Q+/4r+Qor5g10c5M5kZw06B/8Q720MWo5E/j+HaAsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o8P3zhB851Tl0DLPdbP13xW6sindEJf+tS8spC40X8NPSimSTd+0XTtFW89KImHI2LFVbTKU2QbKKuCt0r7XjDUjq2nucGpfWc4PI1XjlLVCLxmItkyuOcYo8q+TxRMVnwmmB8e3fQcEjSLK31r/2dnDFq+uebqP40nljtI3W+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=othdOT1W; arc=none smtp.client-ip=80.12.242.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.18] ([86.243.17.157])
	by smtp.orange.fr with ESMTPA
	id vvAGrTmGTUGsCvvAHrYZlA; Sun, 14 Apr 2024 10:24:41 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1713083081;
	bh=i9DFs5b+r7+eXYOXnNffp+stcM+i0qFnH109y2AB9uM=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=othdOT1WNg/8WuUl6wXonjNE6QyUHShE9M7LtjoSUC8cA+5fXG0VauLhqFnHh2RTb
	 CNTUSQ9cBlzJmIFT9K+eoG+ku/SF+tlZthI944dXWX46FRiaFGdcVQJoBWQJMQ3XpZ
	 JybprpFYD61xlQkh8gnS0WDfVotziVwp/L9W2E6CIC03o5G5KlDYX5LbO7fEDSIQzo
	 rYUCn6x/rcBOxS1pUbSL9BC1UHWZExbcSYsPehst3NWJafeog6QPAk3DhOJnRc/Gz2
	 u/En++pS81pp+6bA+YxYTJm0zDbbUPYYSB2EcaCyExazTh9p0FsvzFfYmFB3Ag8mI1
	 /q29lN+udhRHg==
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 14 Apr 2024 10:24:41 +0200
X-ME-IP: 86.243.17.157
Message-ID: <4230d015-d9b6-4753-8957-717eab00d5cb@wanadoo.fr>
Date: Sun, 14 Apr 2024 10:24:40 +0200
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] bcache: Remove usage of the deprecated ida_simple_xx()
 API
To: Coly Li <colyli@suse.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
 linux-bcache@vger.kernel.org
References: <2f038df3860c2f44d5c7f5d06d03ca663cdbc651.1705235398.git.christophe.jaillet@wanadoo.fr>
 <y2c3dt325d4xzcknmwtyd6gungco6jqucz3fsrm6lsyjtiwpp4@ozmsw6vp67jk>
Content-Language: en-MW
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <y2c3dt325d4xzcknmwtyd6gungco6jqucz3fsrm6lsyjtiwpp4@ozmsw6vp67jk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 14/01/2024 à 16:16, Coly Li a écrit :
> On Sun, Jan 14, 2024 at 01:30:16PM +0100, Christophe JAILLET wrote:
>> ida_alloc() and ida_free() should be preferred to the deprecated
>> ida_simple_get() and ida_simple_remove().
>>
>> Note that the upper limit of ida_simple_get() is exclusive, but the one of
>> ida_alloc_max() is inclusive. So a -1 has been added when needed.
>>
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> It looks good to me. Add this patch into my testing directory.
> 
> Thanks.
> 
> Coly Li

Hi,

polite reminder ;-)

CJ

> 
> 
>> ---
>>   drivers/md/bcache/super.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
>> index dc3f50f69714..a2eecd1db126 100644
>> --- a/drivers/md/bcache/super.c
>> +++ b/drivers/md/bcache/super.c
>> @@ -881,8 +881,8 @@ static void bcache_device_free(struct bcache_device *d)
>>   		bcache_device_detach(d);
>>   
>>   	if (disk) {
>> -		ida_simple_remove(&bcache_device_idx,
>> -				  first_minor_to_idx(disk->first_minor));
>> +		ida_free(&bcache_device_idx,
>> +			 first_minor_to_idx(disk->first_minor));
>>   		put_disk(disk);
>>   	}
>>   
>> @@ -926,8 +926,8 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>>   	if (!d->full_dirty_stripes)
>>   		goto out_free_stripe_sectors_dirty;
>>   
>> -	idx = ida_simple_get(&bcache_device_idx, 0,
>> -				BCACHE_DEVICE_IDX_MAX, GFP_KERNEL);
>> +	idx = ida_alloc_max(&bcache_device_idx, BCACHE_DEVICE_IDX_MAX - 1,
>> +			    GFP_KERNEL);
>>   	if (idx < 0)
>>   		goto out_free_full_dirty_stripes;
>>   
>> @@ -980,7 +980,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>>   out_bioset_exit:
>>   	bioset_exit(&d->bio_split);
>>   out_ida_remove:
>> -	ida_simple_remove(&bcache_device_idx, idx);
>> +	ida_free(&bcache_device_idx, idx);
>>   out_free_full_dirty_stripes:
>>   	kvfree(d->full_dirty_stripes);
>>   out_free_stripe_sectors_dirty:
>> -- 
>> 2.43.0
>>
> 


