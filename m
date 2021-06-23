Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041363B1465
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 09:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWHLg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 03:11:36 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39116 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhFWHLc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 03:11:32 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BD2A11FD65;
        Wed, 23 Jun 2021 07:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624432154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=giNVOVWzXsjFUZGjymRsZ3+/FJtJl/IEp3dwFDb/DHs=;
        b=FKCRJlT/p3iwzXfOBpk1zVHjZrMh/OVp6ylm7rD4Ddsf8hltFCbsya5icsOUuLvghMY5Vv
        j9ae/VEuEyZWxhCknXIK2G1mCj485VK3yzSGonveVn1GIn98mHsLU1wQKdZP9HrishYZ9/
        7+PeaDIMe8zfGMXJfW7jtPTgmIcRTK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624432154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=giNVOVWzXsjFUZGjymRsZ3+/FJtJl/IEp3dwFDb/DHs=;
        b=3DLtbvY3uhWpZ6uInIJjPT9FF64cuZeK9V20zBu83kBp9ey/OXZkaxwwpYAM8oJ973l0oI
        +gVxiTS9atGu5XDw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9384211A97;
        Wed, 23 Jun 2021 07:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624432154; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=giNVOVWzXsjFUZGjymRsZ3+/FJtJl/IEp3dwFDb/DHs=;
        b=FKCRJlT/p3iwzXfOBpk1zVHjZrMh/OVp6ylm7rD4Ddsf8hltFCbsya5icsOUuLvghMY5Vv
        j9ae/VEuEyZWxhCknXIK2G1mCj485VK3yzSGonveVn1GIn98mHsLU1wQKdZP9HrishYZ9/
        7+PeaDIMe8zfGMXJfW7jtPTgmIcRTK8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624432154;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=giNVOVWzXsjFUZGjymRsZ3+/FJtJl/IEp3dwFDb/DHs=;
        b=3DLtbvY3uhWpZ6uInIJjPT9FF64cuZeK9V20zBu83kBp9ey/OXZkaxwwpYAM8oJ973l0oI
        +gVxiTS9atGu5XDw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id gZyiGhne0mCKdQAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 07:09:13 +0000
Subject: Re: [PATCH 03/14] bcache: add initial data structures for nvm pages
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-bcache@vger.kernel.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-4-colyli@suse.de>
 <6ce89fa5-860b-9fe7-1a8f-e422798f8bcc@suse.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <7e79ac91-e591-823e-2a8e-bde6c42cf072@suse.de>
Date:   Wed, 23 Jun 2021 15:09:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6ce89fa5-860b-9fe7-1a8f-e422798f8bcc@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/22/21 6:19 PM, Hannes Reinecke wrote:
> On 6/15/21 7:49 AM, Coly Li wrote:
>> This patch initializes the prototype data structures for nvm pages
>> allocator,
>>
>> - struct bch_nvm_pages_sb
>> This is the super block allocated on each nvdimm namespace. A nvdimm
>> set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used
>> to mark which nvdimm set this name space belongs to. Normally we will
>> use the bcache's cache set UUID to initialize this uuid, to connect this
>> nvdimm set to a specified bcache cache set.
>>
>> - struct bch_owner_list_head
>> This is a table for all heads of all owner lists. A owner list records
>> which page(s) allocated to which owner. After reboot from power failure,
>> the ownwer may find all its requested and allocated pages from the owner
> owner

Fixed for next post.


>
>> list by a handler which is converted by a UUID.
>>
>> - struct bch_nvm_pages_owner_head
>> This is a head of an owner list. Each owner only has one owner list,
>> and a nvm page only belongs to an specific owner. uuid[] will be set to
>> owner's uuid, for bcache it is the bcache's cache set uuid. label is not
>> mandatory, it is a human-readable string for debug purpose. The pointer
>> *recs references to separated nvm page which hold the table of struct
>> bch_nvm_pgalloc_rec.
>>
>> - struct bch_nvm_pgalloc_recs
>> This struct occupies a whole page, owner_uuid should match the uuid
>> in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
>> allocated records.
>>
>> - struct bch_nvm_pgalloc_rec
>> Each structure records a range of allocated nvm pages.
>>   - Bits  0 - 51: is pages offset of the allocated pages.
>>   - Bits 52 - 57: allocaed size in page_size * order-of-2
>>   - Bits 58 - 63: reserved.
>> Since each of the allocated nvm pages are power of 2, using 6 bits to
>> represent allocated size can have (1<<(1<<64) - 1) * PAGE_SIZE maximum
>> value. It can be a 76 bits width range size in byte for 4KB page size,
>> which is large enough currently.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Jianpeng Ma <jianpeng.ma@intel.com>
>> Cc: Qiaowei Ren <qiaowei.ren@intel.com>
>> ---
>>  include/uapi/linux/bcache-nvm.h | 200 ++++++++++++++++++++++++++++++++
>>  1 file changed, 200 insertions(+)
>>  create mode 100644 include/uapi/linux/bcache-nvm.h
>>
>> diff --git a/include/uapi/linux/bcache-nvm.h b/include/uapi/linux/bcache-nvm.h
>> new file mode 100644
>> index 000000000000..5094a6797679
>> --- /dev/null
>> +++ b/include/uapi/linux/bcache-nvm.h
>> @@ -0,0 +1,200 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +
>> +#ifndef _UAPI_BCACHE_NVM_H
>> +#define _UAPI_BCACHE_NVM_H
>> +
>> +#if (__BITS_PER_LONG == 64)
>> +/*
>> + * Bcache on NVDIMM data structures
>> + */
>> +
>> +/*
>> + * - struct bch_nvm_pages_sb
>> + *   This is the super block allocated on each nvdimm namespace. A nvdimm
>> + * set may have multiple namespaces, bch_nvm_pages_sb->set_uuid is used to mark
>> + * which nvdimm set this name space belongs to. Normally we will use the
>> + * bcache's cache set UUID to initialize this uuid, to connect this nvdimm
>> + * set to a specified bcache cache set.
>> + *
>> + * - struct bch_owner_list_head
>> + *   This is a table for all heads of all owner lists. A owner list records
>> + * which page(s) allocated to which owner. After reboot from power failure,
>> + * the ownwer may find all its requested and allocated pages from the owner
>> + * list by a handler which is converted by a UUID.
>> + *
>> + * - struct bch_nvm_pages_owner_head
>> + *   This is a head of an owner list. Each owner only has one owner list,
>> + * and a nvm page only belongs to an specific owner. uuid[] will be set to
>> + * owner's uuid, for bcache it is the bcache's cache set uuid. label is not
>> + * mandatory, it is a human-readable string for debug purpose. The pointer
>> + * recs references to separated nvm page which hold the table of struct
>> + * bch_pgalloc_rec.
>> + *
>> + *- struct bch_nvm_pgalloc_recs
>> + *  This structure occupies a whole page, owner_uuid should match the uuid
>> + * in struct bch_nvm_pages_owner_head. recs[] is the real table contains all
>> + * allocated records.
>> + *
>> + * - struct bch_pgalloc_rec
>> + *   Each structure records a range of allocated nvm pages. pgoff is offset
>> + * in unit of page size of this allocated nvm page range. The adjoint page
>> + * ranges of same owner can be merged into a larger one, therefore pages_nr
>> + * is NOT always power of 2.
>> + *
>> + *
>> + * Memory layout on nvdimm namespace 0
>> + *
>> + *    0 +---------------------------------+
>> + *      |                                 |
>> + *  4KB +---------------------------------+
>> + *      |         bch_nvm_pages_sb        |
>> + *  8KB +---------------------------------+ <--- bch_nvm_pages_sb.bch_owner_list_head
>> + *      |       bch_owner_list_head       |
>> + *      |                                 |
>> + * 16KB +---------------------------------+ <--- bch_owner_list_head.heads[0].recs[0]
>> + *      |       bch_nvm_pgalloc_recs      |
>> + *      |  (nvm pages internal usage)     |
>> + * 24KB +---------------------------------+
>> + *      |                                 |
>> + *      |                                 |
>> + * 16MB  +---------------------------------+
>> + *      |      allocable nvm pages        |
>> + *      |      for buddy allocator        |
>> + * end  +---------------------------------+
>> + *
>> + *
>> + *
>> + * Memory layout on nvdimm namespace N
>> + * (doesn't have owner list)
>> + *
>> + *    0 +---------------------------------+
>> + *      |                                 |
>> + *  4KB +---------------------------------+
>> + *      |         bch_nvm_pages_sb        |
>> + *  8KB +---------------------------------+
>> + *      |                                 |
>> + *      |                                 |
>> + *      |                                 |
>> + *      |                                 |
>> + *      |                                 |
>> + *      |                                 |
>> + * 16MB  +---------------------------------+
>> + *      |      allocable nvm pages        |
>> + *      |      for buddy allocator        |
>> + * end  +---------------------------------+
>> + *
>> + */
>> +
>> +#include <linux/types.h>
>> +
>> +/* In sectors */
>> +#define BCH_NVM_PAGES_SB_OFFSET			4096
>> +#define BCH_NVM_PAGES_OFFSET			(16 << 20)
>> +
>> +#define BCH_NVM_PAGES_LABEL_SIZE		32
>> +#define BCH_NVM_PAGES_NAMESPACES_MAX		8
>> +
>> +#define BCH_NVM_PAGES_OWNER_LIST_HEAD_OFFSET	(8<<10)
>> +#define BCH_NVM_PAGES_SYS_RECS_HEAD_OFFSET	(16<<10)
>> +
>> +#define BCH_NVM_PAGES_SB_VERSION		0
>> +#define BCH_NVM_PAGES_SB_VERSION_MAX		0
>> +
>> +static const unsigned char bch_nvm_pages_magic[] = {
>> +	0x17, 0xbd, 0x53, 0x7f, 0x1b, 0x23, 0xd6, 0x83,
>> +	0x46, 0xa4, 0xf8, 0x28, 0x17, 0xda, 0xec, 0xa9 };
>> +static const unsigned char bch_nvm_pages_pgalloc_magic[] = {
>> +	0x39, 0x25, 0x3f, 0xf7, 0x27, 0x17, 0xd0, 0xb9,
>> +	0x10, 0xe6, 0xd2, 0xda, 0x38, 0x68, 0x26, 0xae };
>> +
>> +/* takes 64bit width */
>> +struct bch_pgalloc_rec {
>> +	__u64	pgoff:52;
>> +	__u64	order:6;
>> +	__u64	reserved:6;
>> +};
>> +
>> +struct bch_nvm_pgalloc_recs {
>> +union {
> Indentation.

Copied. It will be updated in next post.

>
>> +	struct {
>> +		struct bch_nvm_pages_owner_head	*owner;
>> +		struct bch_nvm_pgalloc_recs	*next;
>> +		unsigned char			magic[16];
>> +		unsigned char			owner_uuid[16];
>> +		unsigned int			size;
>> +		unsigned int			used;
>> +		unsigned long			_pad[4];
>> +		struct bch_pgalloc_rec		recs[];
>> +	};
>> +	unsigned char				pad[8192];
>> +};
>> +};
>> +
> Consider using __u64 and friends when specifying a structure with a
> fixed alignment; that also removes the need of the BITS_PER_LONG ifdef
> at the top.

It _WAS_ the first version how we did. But Jens didn't agree with this:

"This doesn't look right in a user header, any user API should be 32-bit
and 64-bit agnostic."

My following explanation was not convinced, then I change all the
__u32, __u64 stuffs into unsigned int, and unsigned long.

Considering nvm-pages allocator works only for both register word and
physical address are all 64 bits width, unsigned long will exactly
match 64bit and unsigned int will exactly match 32bit, I am fine to
use any of the forms. Jens is the upper layer maintainer, I choose to
listen to him.


>> +#define BCH_MAX_RECS					\
>> +	((sizeof(struct bch_nvm_pgalloc_recs) -		\
>> +	 offsetof(struct bch_nvm_pgalloc_recs, recs)) /	\
>> +	 sizeof(struct bch_pgalloc_rec))
>> +
> What _are_ you doing here?

BCH_MAX_RECS is a consistent value, to indicate how many elements can
be stored in array recs[] from struct bch_nvm_pgalloc_recs.

> You're not seriously using the 'pad' field as a placeholder to size the
> structure accordingly?

The code is in the way as you expected. The 8KB pad forces struct
bch_nvm_pgalloc_recs to be
two 4K pages, which is an ordered size from the nvm-pages buddy allocator.


> Also, what is the size of the 'bch_nvm_pgalloc_recs' structure?
> 8k + header size?

struct  bch_nvm_pgalloc_recs is exactly 8K. The header is inside the 8K
space.


> That is very awkward, as the page allocator won't be able to handle it
> efficiently.
> Please size it to either 8k or 16k overall.
> And if you do that you can simplify this define.

In memory layout of struct bch_nvm_pgalloc_recs is

|<------------ 8K ----------->|
[header] [recs ...............]
         |<-- BCH_MAX_RECS -->|


So the code works same as your expectation.

>
>> +struct bch_nvm_pages_owner_head {
>> +	unsigned char			uuid[16];
>> +	unsigned char			label[BCH_NVM_PAGES_LABEL_SIZE];
>> +	/* Per-namespace own lists */
>> +	struct bch_nvm_pgalloc_recs	*recs[BCH_NVM_PAGES_NAMESPACES_MAX];
>> +};
>> +
>> +/* heads[0] is always for nvm_pages internal usage */
>> +struct bch_owner_list_head {
>> +union {
>> +	struct {
>> +		unsigned int			size;
>> +		unsigned int			used;
>> +		unsigned long			_pad[4];
>> +		struct bch_nvm_pages_owner_head	heads[];
>> +	};
>> +	unsigned char				pad[8192];
>> +};
>> +};
>> +#define BCH_MAX_OWNER_LIST				\
>> +	((sizeof(struct bch_owner_list_head) -		\
>> +	 offsetof(struct bch_owner_list_head, heads)) /	\
>> +	 sizeof(struct bch_nvm_pages_owner_head))
>> +
> Same here.
> Please size it that the 'bch_owner_list_head' structure fits into either
> 8k or 16k.

It works as you expected. But I realize maybe the indent is misleading.
I should add a blank before offsetof(), like this,

163 #define BCH_MAX_OWNER_LIST                              \
164         ((sizeof(struct bch_owner_list_head) -          \
165           offsetof(struct bch_owner_list_head, heads)) /\
166          sizeof(struct bch_nvm_pages_owner_head))

It means (8K - header_size) / sizeof(struct bch_nvm_pages_owner_head).

>
>> +/* The on-media bit order is local CPU order */
>> +struct bch_nvm_pages_sb {
>> +	unsigned long				csum;
>> +	unsigned long				ns_start;
>> +	unsigned long				sb_offset;
>> +	unsigned long				version;
>> +	unsigned char				magic[16];
>> +	unsigned char				uuid[16];
>> +	unsigned int				page_size;
>> +	unsigned int				total_namespaces_nr;
>> +	unsigned int				this_namespace_nr;
>> +	union {
>> +		unsigned char			set_uuid[16];
>> +		unsigned long			set_magic;
>> +	};
>> +
>> +	unsigned long				flags;
>> +	unsigned long				seq;
>> +
>> +	unsigned long				feature_compat;
>> +	unsigned long				feature_incompat;
>> +	unsigned long				feature_ro_compat;
>> +
>> +	/* For allocable nvm pages from buddy systems */
>> +	unsigned long				pages_offset;
>> +	unsigned long				pages_total;
>> +
>> +	unsigned long				pad[8];
>> +
>> +	/* Only on the first name space */
>> +	struct bch_owner_list_head		*owner_list_head;
>> +
>> +	/* Just for csum_set() */
>> +	unsigned int				keys;
>> +	unsigned long				d[0];
>> +};
>>

Thanks for your review. I will update all addressed locations except for
the __u32/__u64 stuffs, because Jens
didn't want them.

Coly Li

