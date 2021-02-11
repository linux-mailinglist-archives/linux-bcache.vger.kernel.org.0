Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87EB318424
	for <lists+linux-bcache@lfdr.de>; Thu, 11 Feb 2021 05:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbhBKD7L (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 10 Feb 2021 22:59:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:44476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhBKD7J (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 10 Feb 2021 22:59:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B2EBEAC69;
        Thu, 11 Feb 2021 03:58:26 +0000 (UTC)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210210050742.31237-1-colyli@suse.de>
 <20210210050742.31237-8-colyli@suse.de>
 <76adf7d2-821b-c7a5-426e-4d3963d36455@kernel.dk>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 07/20] bcache: add initial data structures for nvm pages
Message-ID: <e2b05bd8-8129-73f1-2f17-00eb95ce5184@suse.de>
Date:   Thu, 11 Feb 2021 11:58:23 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <76adf7d2-821b-c7a5-426e-4d3963d36455@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/10/21 11:09 PM, Jens Axboe wrote:
> On 2/9/21 10:07 PM, Coly Li wrote:
>> +struct bch_nvm_pgalloc_recs {
>> +union {
>> +	struct {
>> +		struct bch_nvm_pages_owner_head	*owner;
>> +		struct bch_nvm_pgalloc_recs	*next;
>> +		__u8				magic[16];
>> +		__u8				owner_uuid[16];
>> +		__u32				size;
>> +		__u32				used;
>> +		__u64				_pad[4];
>> +		struct bch_pgalloc_rec		recs[];
>> +	};
>> +	__u8	pad[8192];
>> +};
>> +};
> 

Hi Jens,

> This doesn't look right in a user header, any user API should be 32-bit
> and 64-bit agnostic.

The above data structure is stored in NVDIMM as allocator's meta data.
It is designed to be directly accessed (in future update) as in-memory
object, but stored on non-volatiled memory like on-disk data structure.

To me, it is fine to use unsigned int/long/long long to define the
members, because nvdimm driver only works on 64bit platform. It is just
unclear to me which form/style I should use to define such data
structure. On one side they are stores as non-volatiled media, on other
side they are accessed directly as in-memory object...


> 
>> +struct bch_nvm_pages_owner_head {
>> +	__u8			uuid[16];
>> +	char			label[BCH_NVM_PAGES_LABEL_SIZE];
>> +	/* Per-namespace own lists */
>> +	struct bch_nvm_pgalloc_recs	*recs[BCH_NVM_PAGES_NAMESPACES_MAX];
>> +};
> 
> Same here.

For the above pointer, it is the same reason. In later version, such
object on NVDIMM will be referenced directly by an in-memory pointer
like we normally do for an in-memory object.

Therefore I do treat the data structure as in-memory object after the
DAX mapping accomplished. If not define it as an in-memory pointer, I
have to cast it into (void *) every time when I use it.


> 
>> +/* heads[0] is always for nvm_pages internal usage */
>> +struct bch_owner_list_head {
>> +union {
>> +	struct {
>> +		__u32				size;
>> +		__u32				used;
>> +		__u64				_pad[4];
>> +		struct bch_nvm_pages_owner_head	heads[];
>> +	};
>> +	__u8	pad[8192];
>> +};
>> +};
> 
> And here.
> 
>> +#define BCH_MAX_OWNER_LIST				\
>> +	((sizeof(struct bch_owner_list_head) -		\
>> +	 offsetof(struct bch_owner_list_head, heads)) /	\
>> +	 sizeof(struct bch_nvm_pages_owner_head))
>> +
>> +/* The on-media bit order is local CPU order */
>> +struct bch_nvm_pages_sb {
>> +	__u64			csum;
>> +	__u64			ns_start;
>> +	__u64			sb_offset;
>> +	__u64			version;
>> +	__u8			magic[16];
>> +	__u8			uuid[16];
>> +	__u32			page_size;
>> +	__u32			total_namespaces_nr;
>> +	__u32			this_namespace_nr;
>> +	union {
>> +		__u8		set_uuid[16];
>> +		__u64		set_magic;
>> +	};
> 
> This doesn't look like it packs right either.

This is my mimicry from bcache code, which uses the least significant 8
bytes from the randomly generated UUID as a magic number. It is solid
and not changed during the whole life cycle for the nvm pages set.


> 
>> +
>> +	__u64			flags;
>> +	__u64			seq;
>> +
>> +	__u64			feature_compat;
>> +	__u64			feature_incompat;
>> +	__u64			feature_ro_compat;
>> +
>> +	/* For allocable nvm pages from buddy systems */
>> +	__u64			pages_offset;
>> +	__u64			pages_total;
>> +
>> +	__u64			pad[8];
>> +
>> +	/* Only on the first name space */
>> +	struct bch_owner_list_head	*owner_list_head;
> 
> And here's another pointer...
> 

Same reason for I use it as an in-memory pointer.

The above definition is just using all the structures as in-memory
object, the difference is just they are non-volatiled after reboot.

Thanks.

Coly Li
