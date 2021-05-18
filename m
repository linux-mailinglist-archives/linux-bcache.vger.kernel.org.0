Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB85386FFC
	for <lists+linux-bcache@lfdr.de>; Tue, 18 May 2021 04:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240564AbhERCrG (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 May 2021 22:47:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:41854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240178AbhERCrG (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 May 2021 22:47:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C6334B154;
        Tue, 18 May 2021 02:45:47 +0000 (UTC)
Subject: Re: [bch-nvm-pages v9 4/6] bcache: bch_nvm_alloc_pages() of the buddy
To:     "Ma, Jianpeng" <jianpeng.ma@intel.com>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
References: <20210428213952.197504-1-qiaowei.ren@intel.com>
 <20210428213952.197504-5-qiaowei.ren@intel.com>
 <0a3540c1-1af2-7b06-0e1c-634ab57c62b6@suse.de>
 <BN7PR11MB26091DC8806AC6203E83EFDFFD2C9@BN7PR11MB2609.namprd11.prod.outlook.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <16489e1a-40ac-5627-4e3d-bf8cf916e5ea@suse.de>
Date:   Tue, 18 May 2021 10:45:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BN7PR11MB26091DC8806AC6203E83EFDFFD2C9@BN7PR11MB2609.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/18/21 10:27 AM, Ma, Jianpeng wrote:
>> -----Original Message-----
>> From: Coly Li <colyli@suse.de>
>> Sent: Tuesday, May 11, 2021 8:49 PM
>> To: Ren, Qiaowei <qiaowei.ren@intel.com>; Ma, Jianpeng
>> <jianpeng.ma@intel.com>
>> Cc: linux-bcache@vger.kernel.org
>> Subject: Re: [bch-nvm-pages v9 4/6] bcache: bch_nvm_alloc_pages() of the
>> buddy
>>
>> On 4/29/21 5:39 AM, Qiaowei Ren wrote:
>>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>>
>>> This patch implements the bch_nvm_alloc_pages() of the buddy.
>>> In terms of function, this func is like current-page-buddy-alloc.
>>> But the differences are:
>>> a: it need owner_uuid as parameter which record owner info. And it
>>> make those info persistence.
>>> b: it don't need flags like GFP_*. All allocs are the equal.
>>> c: it don't trigger other ops etc swap/recycle.
>>>
>>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>>> Co-developed-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>> Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
>>> [colyli: fix typo in commit log]
>>
>> Once you fixed the typo in this version, you may remove the above line from
>> this patch. Such comment is used when I submit patches to mainline kernel.
>>
>>> Signed-off-by: Coly Li <colyli@suse.de>
>>
>> And this is maintainer's SOB not author's, you may remove it from all rested
>> patches except for the first one of this series.
>>
>>
>>> ---
>>>  drivers/md/bcache/nvm-pages.c | 172
>> ++++++++++++++++++++++++++++++++++
>>>  drivers/md/bcache/nvm-pages.h |   6 ++
>>>  2 files changed, 178 insertions(+)
>>>
>>> diff --git a/drivers/md/bcache/nvm-pages.c
>>> b/drivers/md/bcache/nvm-pages.c index 810f65cf756a..2647ff997fab
>>> 100644
>>> --- a/drivers/md/bcache/nvm-pages.c
>>> +++ b/drivers/md/bcache/nvm-pages.c
>>> @@ -68,6 +68,178 @@ static inline void remove_owner_space(struct
>> bch_nvm_namespace *ns,
>>>  	bitmap_set(ns->pages_bitmap, pgoff, nr);  }
>>>
>>> +/* If not found, it will create if create == true */ static struct
>>> +bch_nvm_pages_owner_head *find_owner_head(const char
>> *owner_uuid,
>>> +bool create) {
>>> +	struct bch_owner_list_head *owner_list_head = only_set-
>>> owner_list_head;
>>> +	struct bch_nvm_pages_owner_head *owner_head = NULL;
>>> +	int i;
>>> +
>>> +	if (owner_list_head == NULL)
>>> +		goto out;
>>> +
>>> +	for (i = 0; i < only_set->owner_list_used; i++) {
>>> +		if (!memcmp(owner_uuid, owner_list_head->heads[i].uuid, 16))
>> {
>>> +			owner_head = &(owner_list_head->heads[i]);
>>> +			break;
>>> +		}
>>> +	}
>>> +
>>> +	if (!owner_head && create) {
>>> +		int used = only_set->owner_list_used;
>>> +
>>> +		BUG_ON((used > 0) && (only_set->owner_list_size == used));
>>
>>
>> It seems the above condition may happen when owner_list is full? Maybe
>> return NULL for a full-occupied owner header list can be better?
>>
>>
>>> +		memcpy_flushcache(owner_list_head->heads[used].uuid,
>> owner_uuid, 16);
>>> +		only_set->owner_list_used++;
>>> +
>>> +		owner_list_head->used++;
>>> +		owner_head = &(owner_list_head->heads[used]);
>>> +	}
>>> +
>>> +out:
>>> +	return owner_head;
>>> +}
>>> +
>>> +static struct bch_nvm_pgalloc_recs *find_empty_pgalloc_recs(void) {
>>> +	unsigned int start;
>>> +	struct bch_nvm_namespace *ns = only_set->nss[0];
>>> +	struct bch_nvm_pgalloc_recs *recs;
>>> +
>>> +	start = bitmap_find_next_zero_area(ns->pgalloc_recs_bitmap,
>>> +BCH_MAX_PGALLOC_RECS, 0, 1, 0);
>>
>> We cannot assume all space in [BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET,
>> BCH_NVM_PAGES_OFFSET) are dedicated to recs structures.
>>
>> Right now each bch_nvm_pgalloc_recs is 8KB, we can assume the
>> BCH_MAX_PGALLOC_RECS to be 64, that means 512KB space starts at
>> BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET. we won't exceed the limition in
>> next
>> 12 months at least.
>>
>>
>>> +	if (start > BCH_MAX_PGALLOC_RECS) {
>>> +		pr_info("no free struct bch_nvm_pgalloc_recs\n");
>>> +		return NULL;
>>> +	}
>>> +
>>> +	bitmap_set(ns->pgalloc_recs_bitmap, start, 1);
>>> +	recs = (struct bch_nvm_pgalloc_recs *)(ns->kaddr +
>> BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET)
>>> +		+ start;
>>> +	return recs;
>>> +}
>>> +
>>> +static struct bch_nvm_pgalloc_recs *find_nvm_pgalloc_recs(struct
>> bch_nvm_namespace *ns,
>>> +		struct bch_nvm_pages_owner_head *owner_head, bool create)
>> {
>>> +	int ns_nr = ns->sb->this_namespace_nr;
>>> +	struct bch_nvm_pgalloc_recs *prev_recs = NULL, *recs =
>>> +owner_head->recs[ns_nr];
>>> +
>>> +	/* If create=false, we return recs[nr] */
>>> +	if (!create)
>>> +		return recs;
>>> +
>>
>> I assume when create == false, at least the first non-full recs structure should
>> be returned before iterated all the list nodes. How about return recs by the
>> way in my next comment.
> 
> Hi Coly:
>    For create == false,  it mean find the recs and find the rec(when free page or list all rec).
>   So we return the firstly recs(iterated based on address do in other function, you can see patch5).
> 

Aha, yes you are right :-) Please ignore my noise here.

Thanks.

Coly Li
