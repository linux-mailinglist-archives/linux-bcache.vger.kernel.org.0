Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118748068E
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhL1F3d (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:29:33 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60640 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhL1F3d (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:29:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 22F2D1F37E;
        Tue, 28 Dec 2021 05:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640669372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oc4Bkwe1+Zewrlz30CChjxDu3BtrMm6edt0Bazc82LA=;
        b=a6tPXvxddigT3jIMZ6I9B3inZnd5QuZIWNB3DEEENIXD2JV4Cv76z0qwUXTpYg7Um0uYSZ
        UXyfcRBHnx87mumCf/pIaXIymzJbDnZr53sBWNMgIk/V7LAdIiqRpgBI0lurEbFd3n7d7L
        d79+U8Xoq2XjkDIuZ2pgf9ibGmNzNOA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640669372;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oc4Bkwe1+Zewrlz30CChjxDu3BtrMm6edt0Bazc82LA=;
        b=B8nTklDYsfpg7mBpNmWXqF51qYEHIzD4S+qaPJo2/T2SjEJT3IjmURtYO5JOweHMCSmrRx
        aRY5hqHKITogPUBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0D7C913A6D;
        Tue, 28 Dec 2021 05:29:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SSg+MrmgymHtFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:29:29 +0000
Message-ID: <cd994749-21fb-796c-4d9a-c9de3334ebbf@suse.de>
Date:   Tue, 28 Dec 2021 13:29:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v13 04/12] bcache: bch_nvmpg_alloc_pages() of the buddy
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-5-colyli@suse.de>
 <22d13a6d-4ac7-18e5-13cd-84e6353755be@kernel.dk>
Content-Language: en-US
In-Reply-To: <22d13a6d-4ac7-18e5-13cd-84e6353755be@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/13/21 4:14 AM, Jens Axboe wrote:
> On 12/12/21 10:05 AM, Coly Li wrote:
>> +/* If not found, it will create if create == true */
>> +static struct bch_nvmpg_head *find_nvmpg_head(const char *uuid, bool create)
>> +{
>> +	struct bch_nvmpg_set_header *set_header = global_nvmpg_set->set_header;
>> +	struct bch_nvmpg_head *head = NULL;
>> +	int i;
>> +
>> +	if (set_header == NULL)
>> +		goto out;
>> +
>> +	for (i = 0; i < set_header->size; i++) {
>> +		struct bch_nvmpg_head *h = &set_header->heads[i];
>> +
>> +		if (h->state != BCH_NVMPG_HD_STAT_ALLOC)
>> +			continue;
>> +
>> +		if (!memcmp(uuid, h->uuid, 16)) {
>> +			head = h;
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (!head && create) {
>> +		u32 used = set_header->used;
>> +
>> +		if (set_header->size > used) {
>> +			head = &set_header->heads[used];
>> +			memset(head, 0, sizeof(struct bch_nvmpg_head));
>> +			head->state = BCH_NVMPG_HD_STAT_ALLOC;
>> +			memcpy(head->uuid, uuid, 16);
>> +			global_nvmpg_set->heads_used++;
>> +			set_header->used++;
>> +		} else
>> +			pr_info("No free bch_nvmpg_head\n");
>> +	}
> Use {} consistently. Again probably just some printk that should go
> away.

Copied.

>> +static struct bch_nvmpg_recs *find_nvmpg_recs(struct bch_nvmpg_ns *ns,
>> +					      struct bch_nvmpg_head *head,
>> +					      bool create)
>> +{
>> +	int ns_id = ns->sb->this_ns;
>> +	struct bch_nvmpg_recs *prev_recs = NULL, *recs = NULL;
>> +
>> +	recs = bch_nvmpg_offset_to_ptr(head->recs_offset[ns_id]);
>> +
>> +	/* If create=false, we return recs[nr] */
>> +	if (!create)
>> +		return recs;
> Would this be cleaner to handle in the caller?

Cure, I will suggest Jianpeng and Qiaowei to change this.

>> +static void add_nvmpg_rec(struct bch_nvmpg_ns *ns,
>> +			  struct bch_nvmpg_recs *recs,
>> +			  unsigned long nvmpg_offset,
>> +			  int order)
>> +{
>> +	int i, ns_id;
>> +	unsigned long pgoff;
>> +
>> +	pgoff = bch_nvmpg_offset_to_pgoff(nvmpg_offset);
>> +	ns_id = ns->sb->this_ns;
>> +
>> +	for (i = 0; i < recs->size; i++) {
>> +		if (recs->recs[i].pgoff == 0) {
>> +			recs->recs[i].pgoff = pgoff;
>> +			recs->recs[i].order = order;
>> +			recs->recs[i].ns_id = ns_id;
>> +			recs->used++;
>> +			break;
>> +		}
>> +	}
>> +	BUG_ON(i == recs->size);
> No BUG_ON's, please. It only truly belongs in core code for cases where
> error handling isn't possible, does not apply here.

It is because currently only 1 single record allocated for bcache 
journal, and if i == recs->size happens it means the on-NVDIMM struct 
bch_nvmpg_recs is corrupted.

Currently we are working on storing Btree nodes on NVDIMM, such BUG_ON() 
is dropped.


>> diff --git a/drivers/md/bcache/nvmpg.h b/drivers/md/bcache/nvmpg.h
>> index 55778d4db7da..d03f3241b45a 100644
>> --- a/drivers/md/bcache/nvmpg.h
>> +++ b/drivers/md/bcache/nvmpg.h
>> @@ -76,6 +76,9 @@ struct bch_nvmpg_set {
>>   /* Indicate which field in bch_nvmpg_sb to be updated */
>>   #define BCH_NVMPG_TOTAL_NS	0	/* total_ns */
>>   
>> +#define BCH_PGOFF_TO_KVADDR(pgoff)					\
>> +	((void *)((unsigned long)(pgoff) << PAGE_SHIFT))
> Pretty sure we have a general kernel helper for this, better to use that
> rather than duplicate it.
>
>
Copied. Thank for pointing out this.

Coly Li
