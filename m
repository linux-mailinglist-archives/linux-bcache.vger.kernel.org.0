Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE9348068A
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Dec 2021 06:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhL1F3Y (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 28 Dec 2021 00:29:24 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60624 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhL1F3X (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 28 Dec 2021 00:29:23 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B3A3D1F37E;
        Tue, 28 Dec 2021 05:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1640669362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/JU7OI1y6yzK28A8VRSvW/ZjVyVAhFVbtpdUjVMy6g=;
        b=smzwd8KM76qWKq2kOlqK0vY006eFZj4qb+waOYxHdz5piF+8e5+Bg8LJTcHZrIhcYECb6p
        n7xN9eOcKm7hzxGwRYRBRIJzSMz/SmdCfuIbpJ++gsjUQMv3ATT3IA6Yu6Jk9dVqAzwLDV
        4ceatzmzYcYO+RUZcVgxfgCRWHMF4hY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1640669362;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u/JU7OI1y6yzK28A8VRSvW/ZjVyVAhFVbtpdUjVMy6g=;
        b=afvkYiX6lj14EZndnjJorz7spKp9OVB8ILphgl2bGaByCTm6MtjrUo4IDC6w2wIoNmZldI
        ZyeXpbRNVGCLrhDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B172413A6D;
        Tue, 28 Dec 2021 05:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OX0zIbCgymHgFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Dec 2021 05:29:20 +0000
Message-ID: <105cc271-ad77-c317-bd1d-69d00685f7cf@suse.de>
Date:   Tue, 28 Dec 2021 13:29:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH v13 02/12] bcache: initialize the nvm pages allocator
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.de>
References: <20211212170552.2812-1-colyli@suse.de>
 <20211212170552.2812-3-colyli@suse.de>
 <db3fe961-020a-1d0d-bfb8-d5229b50474f@kernel.dk>
Content-Language: en-US
In-Reply-To: <db3fe961-020a-1d0d-bfb8-d5229b50474f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Jens,

Thank you for review the patches. I was in travel for a week when you 
replied the email and after the travel I was sick for one more week. 
Just being able to sit in front of my laptop now.

I reply inline bellow your comments.

On 12/13/21 3:34 AM, Jens Axboe wrote:
> On 12/12/21 10:05 AM, Coly Li wrote:
>> diff --git a/drivers/md/bcache/nvmpg.c b/drivers/md/bcache/nvmpg.c
>> new file mode 100644
>> index 000000000000..b654bbbda03e
>> --- /dev/null
>> +++ b/drivers/md/bcache/nvmpg.c
>> @@ -0,0 +1,340 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Nvdimm page-buddy allocator
>> + *
>> + * Copyright (c) 2021, Intel Corporation.
>> + * Copyright (c) 2021, Qiaowei Ren<qiaowei.ren@intel.com>.
>> + * Copyright (c) 2021, Jianpeng Ma<jianpeng.ma@intel.com>.
>> + */
>> +
>> +#include "bcache.h"
>> +#include "nvmpg.h"
>> +
>> +#include <linux/slab.h>
>> +#include <linux/list.h>
>> +#include <linux/mutex.h>
>> +#include <linux/dax.h>
>> +#include <linux/pfn_t.h>
>> +#include <linux/libnvdimm.h>
>> +#include <linux/mm_types.h>
>> +#include <linux/err.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/bitmap.h>
>> +#include <linux/blkdev.h>
>> +
[snipped]
>> +	expected_csum = csum_set(sb);
>> +	if (expected_csum != sb->csum) {
>> +		pr_info("csum is not match with expected one\n");
> "Checksum mismatch"

Copied, it will be fixed.


> would be more correct english, should it print the checksums as well?

This is the style following bcache code to report bad check sum, like,
super.c:718:                pr_warn("bad csum reading priorities\n");
journal.c:141:                pr_info("%u: bad csum, %zu bytes, offset 
%u\n",

There might be fine to only notice the bad csum status.

>> +		goto put_page;
>> +	}
>> +
>> +	if (memcmp(sb->magic, bch_nvmpg_magic, 16)) {
>> +		pr_info("invalid bch_nvmpg_magic\n");
>> +		goto put_page;
>> +	}
>> +
>> +	if (sb->sb_offset !=
>> +	    BCH_NVMPG_OFFSET(sb->this_ns, BCH_NVMPG_SB_OFFSET)) {
>> +		pr_info("invalid superblock offset 0x%llx\n", sb->sb_offset);
>> +		goto put_page;
>> +	}
>> +
>> +	r = -EOPNOTSUPP;
>> +	if (sb->total_ns != 1) {
>> +		pr_info("multiple name space not supported yet.\n");
>> +		goto put_page;
>> +	}
> Please use namespace consistently.

Copied, it will be fixed.

>> +struct bch_nvmpg_ns *bch_register_namespace(const char *dev_path)
>> +{
>> +	struct bch_nvmpg_ns *ns = NULL;
>> +	struct bch_nvmpg_sb *sb = NULL;
>> +	char buf[BDEVNAME_SIZE];
>> +	struct block_device *bdev;
>> +	pgoff_t pgoff;
>> +	int id, err;
>> +	char *path;
>> +	long dax_ret = 0;
>> +
>> +	path = kstrndup(dev_path, 512, GFP_KERNEL);
>> +	if (!path) {
>> +		pr_err("kstrndup failed\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
> Really don't think we need that piece of information. Same for a lot of
> other places, you have a ton of pr_err() stuff that looks mostly like
> debugging.

Hmm, I think I need your guidance here. When I review the code, IMHO the 
error message is necessary but don't print them in run time code. Such 
place is in NVDIMM namespace registration code path, therefore I 
accepted it. This is what I was trained for long time....

Could you please give me some hint to judge whether a printk message 
should be avoided? Then I will use it in future code review and my own 
coding work.


>> +	ns->page_size = sb->page_size;
>> +	ns->pages_offset = sb->pages_offset;
>> +	ns->pages_total = sb->pages_total;
>> +	ns->sb = sb;
>> +	ns->free = 0;
>> +	ns->bdev = bdev;
>> +	ns->set = global_nvmpg_set;
>> +
>> +	err = attach_nvmpg_set(ns);
>> +	if (err < 0)
>> +		goto free_ns;
>> +
>> +	mutex_init(&ns->lock);
>> +
>> +	err = init_nvmpg_set_header(ns);
>> +	if (err < 0)
>> +		goto free_ns;
> Does this error path need to un-attach?

Detach or un-attach is not implemented in this series, because it is 
related to how to flush the whole NVDIMM namespace during un-attach. It 
is planed to posted with the NVDIMM support for Bcache B+tree node.

For current bcache code only with SSD, if a flush request received from 
upper layer, it is synchronously sent to backing device and 
asynchronously sent to cache device with journal flush. But for NVDIMM 
namespace, such operation is to flush last level cache, we have 3 
candidate methods to handle,
1) flush cache for the whole dax mapped linear address range (like 
nvdimm_flush() in libnvdimm)
2) flush cache for the only allocated NVDIMM ranges in the nvmpg 
allocator for selected requesters (uuids).
3) maintain a list of dirty NVDIMM pages, and only flush cache for these 
linear address ranges.

We are still testing the performance and not make decision yet. So the 
detach code path is not posted in this series and we un-attach the 
NVDIMM namespace by unloading bcache kernel module currently.

>> +int __init bch_nvmpg_init(void)
>> +{
>> +	global_nvmpg_set = kzalloc(sizeof(*global_nvmpg_set), GFP_KERNEL);
>> +	if (!global_nvmpg_set)
>> +		return -ENOMEM;
>> +
>> +	global_nvmpg_set->total_ns = 0;
>> +	mutex_init(&global_nvmpg_set->lock);
>> +
>> +	pr_info("bcache nvm init\n");
> Another useless pr debug print, just get rid of it (and others).

Copied, it will be dropped.

>> +void bch_nvmpg_exit(void)
>> +{
>> +	release_nvmpg_set(global_nvmpg_set);
>> +	pr_info("bcache nvm exit\n");
>> +}
> Ditto

Copied.

Thanks for your comments.

Coly Li
