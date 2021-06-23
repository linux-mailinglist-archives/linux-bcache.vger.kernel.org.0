Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0602B3B139D
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFWGEi (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:04:38 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35556 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWGEi (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:04:38 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 528031FD36;
        Wed, 23 Jun 2021 06:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWk6le9FRAizxeadNLdLbixQVm+jrO/gjcltElqv7g0=;
        b=eQYf4ipAYlIDtj4REefDayU2jlKFACqBuSol6TxYZwVx2tvRwc3E98nRfSPrRpEdgrhxZJ
        liX7muEwSzdsw3w2iFW/kbOVz+787n0gfGHkYGv+4iRb+h4odG9GVBd2BHbYMiWO2GQ3Tt
        6r1o4gAGxycmH61p1h2HdkvjFnBZKgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428140;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWk6le9FRAizxeadNLdLbixQVm+jrO/gjcltElqv7g0=;
        b=5vh8sJle1cu6FNdnskSlxFXV1zFTLQ/hIH/gP45n5+xLn0SH/fOR3UZ8sg+Wd4C/FHT9S6
        CMVUqQ2tNQYZ0tBQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 2118611A97;
        Wed, 23 Jun 2021 06:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWk6le9FRAizxeadNLdLbixQVm+jrO/gjcltElqv7g0=;
        b=eQYf4ipAYlIDtj4REefDayU2jlKFACqBuSol6TxYZwVx2tvRwc3E98nRfSPrRpEdgrhxZJ
        liX7muEwSzdsw3w2iFW/kbOVz+787n0gfGHkYGv+4iRb+h4odG9GVBd2BHbYMiWO2GQ3Tt
        6r1o4gAGxycmH61p1h2HdkvjFnBZKgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428140;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KWk6le9FRAizxeadNLdLbixQVm+jrO/gjcltElqv7g0=;
        b=5vh8sJle1cu6FNdnskSlxFXV1zFTLQ/hIH/gP45n5+xLn0SH/fOR3UZ8sg+Wd4C/FHT9S6
        CMVUqQ2tNQYZ0tBQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id lgFsOWrO0mACXAAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:02:18 +0000
Subject: Re: [PATCH 06/14] bcache: bch_nvm_alloc_pages() of the buddy
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-7-colyli@suse.de>
 <34dc388c-ccbf-3b09-8254-188d183c3d26@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <e5b642b5-47d1-ce30-7931-817d4ec4cbdc@suse.de>
Date:   Wed, 23 Jun 2021 14:02:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <34dc388c-ccbf-3b09-8254-188d183c3d26@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:51 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This patch implements the bch_nvm_alloc_pages() of the buddy.
>> In terms of function, this func is like current-page-buddy-alloc.
>> But the differences are:
>> a: it need owner_uuid as parameter which record owner info. And it
>> make those info persistence.
>> b: it don't need flags like GFP_*. All allocs are the equal.
>> c: it don't trigger other ops etc swap/recycle.
>>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>>  drivers/md/bcache/nvm-pages.c   | 174 ++++++++++++++++++++++++++++++++
>>  drivers/md/bcache/nvm-pages.h   |   6 ++
>>  include/uapi/linux/bcache-nvm.h |   6 +-
>>  3 files changed, 184 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/nvm-pages.c b/drivers/md/bcache/nvm-pages.c
>> index 804ee66e97be..5d095d241483 100644
>> --- a/drivers/md/bcache/nvm-pages.c
>> +++ b/drivers/md/bcache/nvm-pages.c
>> @@ -74,6 +74,180 @@ static inline void remove_owner_space(struct bch_nvm_namespace *ns,
>>  	}
>>  }
>>  
>> +/* If not found, it will create if create == true */
>> +static struct bch_nvm_pages_owner_head *find_owner_head(const char *owner_uuid, bool create)
>> +{
>> +	struct bch_owner_list_head *owner_list_head = only_set->owner_list_head;
>> +	struct bch_nvm_pages_owner_head *owner_head = NULL;
>> +	int i;
>> +
>> +	if (owner_list_head == NULL)
>> +		goto out;
>> +
>> +	for (i = 0; i < only_set->owner_list_used; i++) {
>> +		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16)) {
>> +			owner_head = &(owner_list_head->heads[i]);
>> +			break;
>> +		}
>> +	}
>> +
> Please, don't name is 'heads'. If this is supposed to be a linked list,
> use the standard list implementation and initialize the pointers correctly.
> If it isn't use an array (as you know in advance how many array entries
> you can allocate).

heads is an array to store the heads of all owner lists. Each element in
array heads[] is a head of an owner list.

An owner is identified by its uuid. When allocating nvm pages from the
nvm-pages allocator, the owner's uuid is provided. And all its allocated
nvm pages are tracked by this owner's owner list. Typically the owner is
a device driver using nvm pages like bcache.

After reboot, bcache will ask the nvm-pages allocator to return the whole
owner list to it by the previous provided uuid of bcache driver. Then it
is bcache driver's duty to restore all data layout from all the nvm pages
which are tracked by the returned owner list.

So heads is named for an array to store all the heads of all the owner list.


>> +	if (!owner_head && create) {
>> +		u32 used = only_set->owner_list_used;
>> +
>> +		if (only_set->owner_list_size > used) {
>> +			memcpy_flushcache(owner_list_head->heads[used].uuid, owner_uuid, 16);
>> +			only_set->owner_list_used++;
>> +
>> +			owner_list_head->used++;
>> +			owner_head = &(owner_list_head->heads[used]);
>> +		} else
>> +			pr_info("no free bch_nvm_pages_owner_head\n");
>> +	}
>> +
>> +out:
>> +	return owner_head;
>> +}
>> +
>> +static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void)
>> +{
>> +	unsigned int start;
>> +	struct bch_nvm_namespace *ns = only_set->nss[0];
>> +	struct bch_nvm_pgalloc_recs *recs;
>> +
>> +	start = bitmap_find_next_zero_area(ns->pgalloc_recs_bitmap, BCH_MAX_PGALLOC_RECS, 0, 1, 0);
>> +	if (start > BCH_MAX_PGALLOC_RECS) {
>> +		pr_info("no free struct bch_nvm_pgalloc_recs\n");
>> +		return NULL;
>> +	}
>> +
>> +	bitmap_set(ns->pgalloc_recs_bitmap, start, 1);
>> +	recs = (struct bch_nvm_pgalloc_recs *)(ns->kaddr + BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET)
>> +		+ start;
>> +	return recs;
>> +}
>> +
>> +static struct bch_nvm_pgalloc_recs *find_nvm_pgalloc_recs(struct bch_nvm_namespace *ns,
>> +		struct bch_nvm_pages_owner_head *owner_head, bool create)
>> +{
>> +	int ns_nr = ns->sb->this_namespace_nr;
>> +	struct bch_nvm_pgalloc_recs *prev_recs = NULL, *recs = owner_head->recs[ns_nr];
>> +
>> +	/* If create=false, we return recs[nr] */
>> +	if (!create)
>> +		return recs;
>> +
>> +	/*
>> +	 * If create=true, it mean we need a empty struct bch_pgalloc_rec
>> +	 * So we should find non-empty struct bch_nvm_pgalloc_recs or alloc
>> +	 * new struct bch_nvm_pgalloc_recs. And return this bch_nvm_pgalloc_recs
>> +	 */
>> +	while (recs && (recs->used == recs->size)) {
>> +		prev_recs = recs;
>> +		recs = recs->next;
>> +	}
>> +
>> +	/* Found empty struct bch_nvm_pgalloc_recs */
>> +	if (recs)
>> +		return recs;
>> +	/* Need alloc new struct bch_nvm_galloc_recs */
>> +	recs = find_empty_pgalloc_recs();
>> +	if (recs) {
>> +		recs->next = NULL;
>> +		recs->owner = owner_head;
>> +		memcpy_flushcache(recs->magic, bch_nvm_pages_pgalloc_magic, 16);
>> +		memcpy_flushcache(recs->owner_uuid, owner_head->uuid, 16);
>> +		recs->size = BCH_MAX_RECS;
>> +		recs->used = 0;
>> +
>> +		if (prev_recs)
>> +			prev_recs->next = recs;
>> +		else
>> +			owner_head->recs[ns_nr] = recs;
>> +	}
>> +
> Wouldn't it be easier if the bitmap covers the entire range, and not
> just the non-empty ones?
> Eventually (ie if the NVM set becomes full) it'll cover it anyway, so
> can't we save ourselves some time to allocate a large enough bitmap
> upfront and only use it do figure out empty recs?

Yes we will do it later. We don't do it now is because a struct
bch_nvm_pgalloc_recs may contain 1000+ records and all current
code only use 1 record for bcache journal. Later when I star to
store bcache btree nodes on NVDIMM, then I can use the suggested
bitmap optimization with real workload to test.

Thanks for the suggestion.


>
>> +	return recs;
>> +}
>> +
>> +static void add_pgalloc_rec(struct bch_nvm_pgalloc_recs *recs, void *kaddr, int order)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < recs->size; i++) {
>> +		if (recs->recs[i].pgoff == 0) {
>> +			recs->recs[i].pgoff = (unsigned long)kaddr >> PAGE_SHIFT;
>> +			recs->recs[i].order = order;
>> +			recs->used++;
>> +			break;
>> +		}
>> +	}
>> +	BUG_ON(i == recs->size);
>> +}
>> +
>> +void *bch_nvm_alloc_pages(int order, const char *owner_uuid)
>> +{
>> +	void *kaddr = NULL;
>> +	struct bch_nvm_pgalloc_recs *pgalloc_recs;
>> +	struct bch_nvm_pages_owner_head *owner_head;
>> +	int i, j;
>> +
>> +	mutex_lock(&only_set->lock);
>> +	owner_head = find_owner_head(owner_uuid, true);
>> +
>> +	if (!owner_head) {
>> +		pr_err("can't find bch_nvm_pgalloc_recs by(uuid=%s)\n", owner_uuid);
>> +		goto unlock;
>> +	}
>> +
>> +	for (j = 0; j < only_set->total_namespaces_nr; j++) {
>> +		struct bch_nvm_namespace *ns = only_set->nss[j];
>> +
>> +		if (!ns || (ns->free < (1L << order)))
>> +			continue;
>> +
>> +		for (i = order; i < BCH_MAX_ORDER; i++) {
>> +			struct list_head *list;
>> +			struct page *page, *buddy_page;
>> +
>> +			if (list_empty(&ns->free_area[i]))
>> +				continue;
>> +
>> +			list = ns->free_area[i].next;
> list_first_entry()?

Copied. It will be updated in next post.

Thanks for your review.

Coly Li




