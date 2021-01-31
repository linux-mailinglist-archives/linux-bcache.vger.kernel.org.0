Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBED309DC5
	for <lists+linux-bcache@lfdr.de>; Sun, 31 Jan 2021 17:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhAaP7c (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 31 Jan 2021 10:59:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:44280 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhAaP7G (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 31 Jan 2021 10:59:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 134E8ABD6;
        Sun, 31 Jan 2021 15:58:24 +0000 (UTC)
Subject: Re: [PATCH 13/29] bcache: Avoid comma separated statements
To:     Joe Perches <joe@perches.com>
Cc:     linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>
References: <cover.1598331148.git.joe@perches.com>
 <99ba798329f7d957e75a22c8551e8bd22f70c626.1598331149.git.joe@perches.com>
 <14e1e776ceac5d4e84675bc70532aa30530eb8ec.camel@perches.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <9df71a2c-fdd1-b6b4-3f6e-750e2b23d48c@suse.de>
Date:   Sun, 31 Jan 2021 23:58:17 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <14e1e776ceac5d4e84675bc70532aa30530eb8ec.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/31/21 2:59 AM, Joe Perches wrote:
> On Mon, 2020-08-24 at 21:56 -0700, Joe Perches wrote:
>> Use semicolons and braces.
> 
> ping?

It is in my for-next now, thanks for reminding.


Coly Li


> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> ---
>>  drivers/md/bcache/bset.c  | 12 ++++++++----
>>  drivers/md/bcache/sysfs.c |  6 ++++--
>>  2 files changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
>> index 67a2c47f4201..94d38e8a59b3 100644
>> --- a/drivers/md/bcache/bset.c
>> +++ b/drivers/md/bcache/bset.c
>> @@ -712,8 +712,10 @@ void bch_bset_build_written_tree(struct btree_keys *b)
>>  	for (j = inorder_next(0, t->size);
>>  	     j;
>>  	     j = inorder_next(j, t->size)) {
>> -		while (bkey_to_cacheline(t, k) < cacheline)
>> -			prev = k, k = bkey_next(k);
>> +		while (bkey_to_cacheline(t, k) < cacheline) {
>> +			prev = k;
>> +			k = bkey_next(k);
>> +		}
>>  
>>
>>  		t->prev[j] = bkey_u64s(prev);
>>  		t->tree[j].m = bkey_to_cacheline_offset(t, cacheline++, k);
>> @@ -901,8 +903,10 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
>>  	status = BTREE_INSERT_STATUS_INSERT;
>>  
>>
>>  	while (m != bset_bkey_last(i) &&
>> -	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0)
>> -		prev = m, m = bkey_next(m);
>> +	       bkey_cmp(k, b->ops->is_extents ? &START_KEY(m) : m) > 0) {
>> +		prev = m;
>> +		m = bkey_next(m);
>> +	}
>>  
>>
>>  	/* prev is in the tree, if we merge we're done */
>>  	status = BTREE_INSERT_STATUS_BACK_MERGE;
>> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
>> index ac06c0bc3c0a..1878c5ee53b6 100644
>> --- a/drivers/md/bcache/sysfs.c
>> +++ b/drivers/md/bcache/sysfs.c
>> @@ -1071,8 +1071,10 @@ SHOW(__bch_cache)
>>  			--n;
>>  
>>
>>  		while (cached < p + n &&
>> -		       *cached == BTREE_PRIO)
>> -			cached++, n--;
>> +		       *cached == BTREE_PRIO) {
>> +			cached++;
>> +			n--;
>> +		}
>>  
>>
>>  		for (i = 0; i < n; i++)
>>  			sum += INITIAL_PRIO - cached[i];
> 
> 

