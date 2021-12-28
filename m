Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312A148068C
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhL1F33 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:29:29 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56268 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhL1F32 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:29:28 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83707210FD;
        Tue, 28 Dec 2021 05:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640669367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMHjwPHAsFvypeGV4U7tgeYVA3dWv9sCKkoxocFOKzA=;
        b=zCojyjAD4UbPUOcThvWMqg+1r3Kxne4uzRtThgJWjd4RnQxkgEokD8BJIB6M/TW5G1AdLQ
        1xNnXQX6XchurdCbh+uUheTb7ZWA+XEoLFrHqLi7qVYYigjkfCE8ZvYnxOOUsjITM/ntkS
        i7bAgt2rvwInHhCBS1sq6BiY48gXOHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640669367;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yMHjwPHAsFvypeGV4U7tgeYVA3dWv9sCKkoxocFOKzA=;
        b=vYEgHHrBHHR107fo7Us4uXViN/xWaEpASIAuCeYe2a689zE2V7VIVYIwr1362krBQkxUpP
        nqhh4Bnz2JjN0ICA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 580EE13A6D;
        Tue, 28 Dec 2021 05:29:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2H+pC7WgymHnFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:29:25 +0000
Message-ID: <99a94c06-f38f-5986-eee2-d89594a88b7a@suse.de>
Date:   Tue, 28 Dec 2021 13:29:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v13 03/12] bcache: initialization of the buddy
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-4-colyli@suse.de>
 <9e578d54-296d-813a-876f-45881ce5a1ba@kernel.dk>
Content-Language: en-US
In-Reply-To: <9e578d54-296d-813a-876f-45881ce5a1ba@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/13/21 4:10 AM, Jens Axboe wrote:
>> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
>> index b654bbbda03e..2b70ee4a6028 100644
>> --- a/drivers/md/bcache/nvmpg.c
>> +++ b/drivers/md/bcache/nvmpg.c
>> @@ -50,6 +50,36 @@ unsigned long bch_nvmpg_ptr_to_offset(struct bch_nvmpg_ns *ns, void *ptr)
>>   	return BCH_NVMPG_OFFSET(ns_id, offset);
>>   }
>>   
>> +static struct page *bch_nvmpg_va_to_pg(void *addr)
>> +{
>> +	return virt_to_page(addr);
>> +}
> What's the purpose of this helper?

This is used for the simplified buddy-like allocator. When releasing a 
bulk of continuous NVDIMM pages, what we record in nvmpg metadata is the 
offset value (combined with NVDIMM namespace ID and the in-namespace 
offset). The offset value can be converted into a DAX mapped linear 
address of the allocated continuous NVDIMM pages, bch_nvmpg_va_to_pg() 
is to find the header page and release the continuous pages into the 
page list of specific order in the buddy-like pages allocator.

A typical usage for bch_nvmpg_va_pg() is in bch_nvmpg_alloc_pages(), 
after the buddy-like allocator chooses a bulk of continuous pages, what 
we have is only the in-namespace offset of the first page, we need to 
find the corresponding struct page by,
     bch_nvmpg_va_pg(dax-mapped-base-address + header-page-index << 
page-size-bits)
Then we set buddy-like allocator related information into the header page.

>> +static inline void reserve_nvmpg_pages(struct bch_nvmpg_ns *ns,
>> +				       pgoff_t pgoff, u64 nr)
>> +{
>> +	while (nr > 0) {
>> +		unsigned int num = nr > UINT_MAX ? UINT_MAX : nr;
> Surely UINT_MAX isn't anywhere near a valid limit?

Hmm, do you mean whether UINT_MAX is too large, or too small?

The while() loop here I took it as a paranoid oversize handling and no 
real effect indeed, so I was fine with it as the first version. The idea 
method should be an extent tree to record all the reserved area which 
may save a lot of system memory space than bitmap does.

I will suggest Qiaowen and Jianpeng to use extent tree to record the 
free and allocated areas from the NVDIMM namespace and drop the bitmap 
method now.


>> @@ -76,10 +110,73 @@ static void release_nvmpg_set(struct bch_nvmpg_set *set)
>>   	kfree(set);
>>   }
>>   
>> +static int validate_recs(int ns_id,
>> +			 struct bch_nvmpg_head *head,
>> +			 struct bch_nvmpg_recs *recs)
>> +{
>> +	if (memcmp(recs->magic, bch_nvmpg_recs_magic, 16)) {
>> +		pr_err("Invalid bch_nvmpg_recs magic\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (memcmp(recs->uuid, head->uuid, 16)) {
>> +		pr_err("Invalid bch_nvmpg_recs uuid\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (recs->head_offset !=
>> +	    bch_nvmpg_ptr_to_offset(global_nvmpg_set->ns_tbl[ns_id], head)) {
>> +		pr_err("Invalid recs head_offset\n");
>> +		return -EINVAL;
>> +	}
> Same comments here on the frivilous error messaging, other places in
> this file too. Check all the other patches as well, please.

This is the error message style we try to follow from bcache code, and 
IMHO it is necessary. Any of the above error condition means meta data 
might be corrupted, which is critical.

[snipped]
>>   static int attach_nvmpg_set(struct bch_nvmpg_ns *ns)
>> @@ -200,7 +371,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>>   	char buf[BDEVNAME_SIZE];
>>   	struct block_device *bdev;
>>   	pgoff_t pgoff;
>> -	int id, err;
>> +	int id, i, err;
>>   	char *path;
>>   	long dax_ret = 0;
>>   
>> @@ -304,13 +475,48 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>>   
>>   	mutex_init(&ns->lock);
>>   
>> +	/*
>> +	 * parameters of bitmap_set/clear are unsigned int.
>> +	 * Given currently size of nvm is far from exceeding this limit,
>> +	 * so only add a WARN_ON message.
>> +	 */
>> +	WARN_ON(BITS_TO_LONGS(ns->pages_total) > UINT_MAX);
> Does this really need to be a WARN_ON()? Looks more like an -EINVAL
> condition.

This is because currently the free and allocated areas are recorded by 
bitmap during the buddy system initialization. As I said after the 
bitmap is switched to an extent tree, such limitation check will 
disappear. After Qiaowen and Jianpeng replace the bitmap by extent tree, 
people won't see the limitation.

Thanks for your review.

Coly Li
