Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E740C3B134A
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 07:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWFhn (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 01:37:43 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:40738 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhFWFhn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 01:37:43 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id AA34C21969;
        Wed, 23 Jun 2021 05:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624426525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAQABwzbXpR4HDM3l4jif3WzcGVy+nOquQGEf6For20=;
        b=lYJkqwKNymqSYQiohWh5HKKfa8yXe5T75+lFElaFHzQWSX7yXswkFubAZ4bSjFR+HeEHtI
        y0DV8jZwRhkK0b+c10RV1X8XDbnUZ9VRUHxY3uDiMvn8zcNm1cklzbT6UxV1LJ9b70eBsr
        tyvZIM0mllPz7ePPWfhwoGrER/ri3nY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624426525;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAQABwzbXpR4HDM3l4jif3WzcGVy+nOquQGEf6For20=;
        b=yR/y3QbNd1SUq4/D8d4W56HNFsG2fEO2EYnF/Sfw076/tFPcLSB6p/9PkJgkaD4UK2RthV
        uNhtaLsA0nT5EKAQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id D141D11A97;
        Wed, 23 Jun 2021 05:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624426525; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAQABwzbXpR4HDM3l4jif3WzcGVy+nOquQGEf6For20=;
        b=lYJkqwKNymqSYQiohWh5HKKfa8yXe5T75+lFElaFHzQWSX7yXswkFubAZ4bSjFR+HeEHtI
        y0DV8jZwRhkK0b+c10RV1X8XDbnUZ9VRUHxY3uDiMvn8zcNm1cklzbT6UxV1LJ9b70eBsr
        tyvZIM0mllPz7ePPWfhwoGrER/ri3nY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624426525;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NAQABwzbXpR4HDM3l4jif3WzcGVy+nOquQGEf6For20=;
        b=yR/y3QbNd1SUq4/D8d4W56HNFsG2fEO2EYnF/Sfw076/tFPcLSB6p/9PkJgkaD4UK2RthV
        uNhtaLsA0nT5EKAQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 4c9tJxvI0mCgUgAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 05:35:23 +0000
Subject: Re: [PATCH 05/14] bcache: initialization of the buddy
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, axboe@kernel.dk,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-6-colyli@suse.de>
 <bfa10634-b144-e180-c66a-5bf839c5ce71@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <e66262c1-7ce1-cd67-b48b-982b6d1ea1d1@suse.de>
Date:   Wed, 23 Jun 2021 13:35:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <bfa10634-b144-e180-c66a-5bf839c5ce71@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:45 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This nvm pages allocator will implement the simple buddy to manage the
>> nvm address space. This patch initializes this buddy for new namespace.
>>
> Please use 'buddy allocator' instead of just 'buddy'.

Will update in next post.


>
>> the unit of alloc/free of the buddy is page. DAX device has their
>> struct page(in dram or PMEM).
>>
>>         struct {        /* ZONE_DEVICE pages */
>>                 /** @pgmap: Points to the hosting device page map. */
>>                 struct dev_pagemap *pgmap;
>>                 void *zone_device_data;
>>                 /*
>>                  * ZONE_DEVICE private pages are counted as being
>>                  * mapped so the next 3 words hold the mapping, index,
>>                  * and private fields from the source anonymous or
>>                  * page cache page while the page is migrated to device
>>                  * private memory.
>>                  * ZONE_DEVICE MEMORY_DEVICE_FS_DAX pages also
>>                  * use the mapping, index, and private fields when
>>                  * pmem backed DAX files are mapped.
>>                  */
>>         };
>>
>> ZONE_DEVICE pages only use pgmap. Other 4 words[16/32 bytes] don't use.
>> So the second/third word will be used as 'struct list_head ' which list
>> in buddy. The fourth word(that is normal struct page::index) store pgoff
>> which the page-offset in the dax device. And the fifth word (that is
>> normal struct page::private) store order of buddy. page_type will be used
>> to store buddy flags.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/nvm-pages.c   | 156 +++++++++++++++++++++++++++++++-
>>  drivers/md/bcache/nvm-pages.h   |   6 ++
>>  include/uapi/linux/bcache-nvm.h |  10 +-
>>  3 files changed, 165 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
>> index 18fdadbc502f..804ee66e97be 100644
>> --- a/drivers/md/bcache/nvm-pages.c
>> +++ b/drivers/md/bcache/nvm-pages.c
>> @@ -34,6 +34,10 @@ static void release_nvm_namespaces(struct bch_nvm_set *nvm_set)
>>  	for (i = 0; i < nvm_set->total_namespaces_nr; i++) {
>>  		ns = nvm_set->nss[i];
>>  		if (ns) {
>> +			kvfree(ns->pages_bitmap);
>> +			if (ns->pgalloc_recs_bitmap)
>> +				bitmap_free(ns->pgalloc_recs_bitmap);
>> +
>>  			blkdev_put(ns->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXEC);
>>  			kfree(ns);
>>  		}
>> @@ -48,17 +52,130 @@ static void release_nvm_set(struct bch_nvm_set *nvm_set)
>>  	kfree(nvm_set);
>>  }
>>  
>> +static struct page *nvm_vaddr_to_page(struct bch_nvm_namespace *ns, void *addr)
>> +{
>> +	return virt_to_page(addr);
>> +}
>> +
>> +static void *nvm_pgoff_to_vaddr(struct bch_nvm_namespace *ns, pgoff_t pgoff)
>> +{
>> +	return ns->kaddr + (pgoff << PAGE_SHIFT);
>> +}
>> +
>> +static inline void remove_owner_space(struct bch_nvm_namespace *ns,
>> +					pgoff_t pgoff, u64 nr)
>> +{
>> +	while (nr > 0) {
>> +		unsigned int num = nr > UINT_MAX ? UINT_MAX : nr;
>> +
>> +		bitmap_set(ns->pages_bitmap, pgoff, num);
>> +		nr -= num;
>> +		pgoff += num;
>> +	}
>> +}
>> +
>> +#define BCH_PGOFF_TO_KVADDR(pgoff) ((void *)((unsigned long)pgoff << PAGE_SHIFT))
>> +
>>  static int init_owner_info(struct bch_nvm_namespace *ns)
>>  {
>>  	struct bch_owner_list_head *owner_list_head = ns->sb->owner_list_head;
>> +	struct bch_nvm_pgalloc_recs *sys_recs;
>> +	int i, j, k, rc = 0;
>>  
>>  	mutex_lock(&only_set->lock);
>>  	only_set->owner_list_head = owner_list_head;
>>  	only_set->owner_list_size = owner_list_head->size;
>>  	only_set->owner_list_used = owner_list_head->used;
>> +
>> +	/* remove used space */
>> +	remove_owner_space(ns, 0, div_u64(ns->pages_offset, ns->page_size));
>> +
>> +	sys_recs = ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET;
>> +	/* suppose no hole in array */
>> +	for (i = 0; i < owner_list_head->used; i++) {
>> +		struct bch_nvm_pages_owner_head *head = &owner_list_head->heads[i];
>> +
>> +		for (j = 0; j < BCH_NVM_PAGES_NAMESPACES_MAX; j++) {
>> +			struct bch_nvm_pgalloc_recs *pgalloc_recs = head->recs[j];
>> +			unsigned long offset = (unsigned long)ns->kaddr >> PAGE_SHIFT;
>> +			struct page *page;
>> +
>> +			while (pgalloc_recs) {
>> +				u32 pgalloc_recs_pos = (unsigned int)(pgalloc_recs - sys_recs);
>> +
>> +				if (memcmp(pgalloc_recs->magic, bch_nvm_pages_pgalloc_magic, 16)) {
>> +					pr_info("invalid bch_nvm_pages_pgalloc_magic\n");
>> +					rc = -EINVAL;
>> +					goto unlock;
>> +				}
>> +				if (memcmp(pgalloc_recs->owner_uuid, head->uuid, 16)) {
>> +					pr_info("invalid owner_uuid in bch_nvm_pgalloc_recs\n");
>> +					rc = -EINVAL;
>> +					goto unlock;
>> +				}
>> +				if (pgalloc_recs->owner != head) {
>> +					pr_info("invalid owner in bch_nvm_pgalloc_recs\n");
>> +					rc = -EINVAL;
>> +					goto unlock;
>> +				}
>> +
>> +				/* recs array can has hole */
> can have holes ?

It means the valid record is not always continuously stored in recs[]
from struct bch_nvm_pgalloc_recs. Because currently only 8 bytes write
to a 8 bytes aligned address on NVDIMM is stomic for power failure.

When a record is removed from the recs[] array by a block of NVDIMM pages
are freed, if the following valid records are moved forward to make all
records stored continuously, such memory movement is not atomic for power
failure. Then we need to design more complicated method to make sure the
meta data consistency for power failure.

Allowing hole (records can be non-continuously stored in recs[] array)
can make things much simpler here.

Thanks for your review.

Coly Li

