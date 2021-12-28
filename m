Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5EA480690
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhL1Fae (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:30:34 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60654 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbhL1F3h (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:29:37 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 933EE1F37E;
        Tue, 28 Dec 2021 05:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640669375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHUvetd/Be2ztHNB/8V0meFw6xTQOV+vgU5D7dhip9U=;
        b=IKALo8d6fl46K3+7oTxOCg3oje0L5a6FG+YffShUkhdUx6IWLWzKgmAsnRdFxviJNVFoiJ
        VwNCRJq1Zk2E1/Go1jWfTmiHTETBbJjCOxbDb5utbsXzqlRPqisF4xxp/DjX4Qe2A3k8mC
        tKhCQQuUIIVzYPd/Tu5jJATkBtiCPBA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640669375;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SHUvetd/Be2ztHNB/8V0meFw6xTQOV+vgU5D7dhip9U=;
        b=A4I2WKG0wm4XXPle0SzKKxTXBmXkObG2+A0X3mBcCL4HZkOJqnJNTxSBzdwMyMH22yFdH+
        ufHXJLVfgd2VHYCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC9E213A6D;
        Tue, 28 Dec 2021 05:29:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 06+hJ72gymHxFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:29:33 +0000
Message-ID: <9a327a4c-f000-629a-1a08-440ba76e80ae@suse.de>
Date:   Tue, 28 Dec 2021 13:29:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v13 05/12] bcache: bch_nvmpg_free_pages() of the buddy
 allocator
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-6-colyli@suse.de>
 <34997a50-52c0-33b8-a3ff-e0c02389f365@kernel.dk>
Content-Language: en-US
In-Reply-To: <34997a50-52c0-33b8-a3ff-e0c02389f365@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/13/21 4:16 AM, Jens Axboe wrote:
> On 12/12/21 10:05 AM, Coly Li wrote:
>> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
>> index a920779eb548..8ce0c4389b42 100644
>> --- a/drivers/md/bcache/nvmpg.c
>> +++ b/drivers/md/bcache/nvmpg.c
>> @@ -248,6 +248,57 @@ static int init_nvmpg_set_header(struct bch_nvmpg_ns *ns)
>>   	return rc;
>>   }
>>   
>> +static void __free_space(struct bch_nvmpg_ns *ns, unsigned long nvmpg_offset,
>> +			 int order)
>> +{
>> +	unsigned long add_pages = (1L << order);
>> +	pgoff_t pgoff;
>> +	struct page *page;
>> +	void *va;
>> +
>> +	if (nvmpg_offset == 0) {
>> +		pr_err("free pages on offset 0\n");
>> +		return;
>> +	}
>> +
>> +	page = bch_nvmpg_va_to_pg(bch_nvmpg_offset_to_ptr(nvmpg_offset));
>> +	WARN_ON((!page) || (page->private != order));
>> +	pgoff = page->index;
>> +
>> +	while (order < BCH_MAX_ORDER - 1) {
>> +		struct page *buddy_page;
>> +
>> +		pgoff_t buddy_pgoff = pgoff ^ (1L << order);
>> +		pgoff_t parent_pgoff = pgoff & ~(1L << order);
>> +
>> +		if ((parent_pgoff + (1L << (order + 1)) > ns->pages_total))
>> +			break;
>> +
>> +		va = bch_nvmpg_pgoff_to_ptr(ns, buddy_pgoff);
>> +		buddy_page = bch_nvmpg_va_to_pg(va);
>> +		WARN_ON(!buddy_page);
>> +
>> +		if (PageBuddy(buddy_page) && (buddy_page->private == order)) {
>> +			list_del((struct list_head *)&buddy_page->zone_device_data);
>> +			__ClearPageBuddy(buddy_page);
>> +			pgoff = parent_pgoff;
>> +			order++;
>> +			continue;
>> +		}
>> +		break;
>> +	}
>> +
>> +	va = bch_nvmpg_pgoff_to_ptr(ns, pgoff);
>> +	page = bch_nvmpg_va_to_pg(va);
>> +	WARN_ON(!page);
>> +	list_add((struct list_head *)&page->zone_device_data,
>> +		 &ns->free_area[order]);
>> +	page->index = pgoff;
>> +	set_page_private(page, order);
>> +	__SetPageBuddy(page);
>> +	ns->free += add_pages;
>> +}
> There are 3 WARN_ON's in here. If you absolutely must use a WARN_ON,
> then make them WARN_ON_ONCE(). Ditto in other spots in this patch.
>
>> +void bch_nvmpg_free_pages(unsigned long nvmpg_offset, int order,
>> +			  const char *uuid)
>> +{
>> +	struct bch_nvmpg_ns *ns;
>> +	struct bch_nvmpg_head *head;
>> +	struct bch_nvmpg_recs *recs;
>> +	int r;
>> +
>> +	mutex_lock(&global_nvmpg_set->lock);
>> +
>> +	ns = global_nvmpg_set->ns_tbl[BCH_NVMPG_GET_NS_ID(nvmpg_offset)];
>> +	if (!ns) {
>> +		pr_err("can't find namespace by given kaddr from namespace\n");
>> +		goto unlock;
>> +	}
>> +
>> +	head = find_nvmpg_head(uuid, false);
>> +	if (!head) {
>> +		pr_err("can't found bch_nvmpg_head by uuid\n");
>> +		goto unlock;
>> +	}
>> +
>> +	recs = find_nvmpg_recs(ns, head, false);
>> +	if (!recs) {
>> +		pr_err("can't find bch_nvmpg_recs by uuid\n");
>> +		goto unlock;
>> +	}
>> +
>> +	r = remove_nvmpg_rec(recs, ns->sb->this_ns, nvmpg_offset, order);
>> +	if (r < 0) {
>> +		pr_err("can't find bch_nvmpg_rec\n");
>> +		goto unlock;
>> +	}
>> +
>> +	__free_space(ns, nvmpg_offset, order);
>> +
>> +unlock:
>> +	mutex_unlock(&global_nvmpg_set->lock);
>> +}
> Again tons of useless error prints. Make them return a proper error
> instad of just making things void...

Copied. It will be improved as you suggested.


>> @@ -686,6 +835,7 @@ struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>>   	ns->pages_offset = sb->pages_offset;
>>   	ns->pages_total = sb->pages_total;
>>   	ns->sb = sb;
>> +	/* increase by __free_space() */
>>   	ns->free = 0;
>>   	ns->bdev = bdev;
>>   	ns->set = global_nvmpg_set;
> Does that hunk belong in here?
>

Could you please give me more detailed explanation of the above 
question? Do you mention the bch_register_namespace() function, or the 
code block which initializes members of ns?

Thank you.

Coly Li

