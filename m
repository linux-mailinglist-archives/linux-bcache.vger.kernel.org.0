Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72569361FBE
	for <lists+linux-bcache@lfdr.de>; Fri, 16 Apr 2021 14:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbhDPM1S (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 16 Apr 2021 08:27:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:52074 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhDPM1S (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 16 Apr 2021 08:27:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5DC28B036;
        Fri, 16 Apr 2021 12:26:52 +0000 (UTC)
Subject: Re: [PATCH 00/13] bcache patches for Linux v5.13 -- 2nd wave
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        jianpeng.ma@intel.com, qiaowei.ren@intel.com
References: <20210414054648.24098-1-colyli@suse.de>
 <241da7b5-65d3-e3dd-83e7-39ba85e8dc9f@kernel.dk>
From:   Coly Li <colyli@suse.de>
Message-ID: <10bba861-9163-3088-896f-0aeaddaa2c5b@suse.de>
Date:   Fri, 16 Apr 2021 20:26:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <241da7b5-65d3-e3dd-83e7-39ba85e8dc9f@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/16/21 8:02 PM, Jens Axboe wrote:
> On 4/13/21 11:46 PM, Coly Li wrote:
>> Hi Jens,
>>
>> This is the 2nd wave of bcache patches for Linux v5.13. This series are
>> patches to use NVDIMM to store bcache journal, which is the first effort
>> to support NVDIMM for bcache [EXPERIMENTAL].
>>
>> All concerns from Linux v5.12 merge window are fixed, especially the
>> data type defined in include/uapi/linux/bcache-nvm.h. And in this
>> series, all the lists defined in bcache-nvm.h uapi file are stored and
>> accessed directly on NVDIMM as memory objects.
>>
>> Intel developers Jianpeng Ma and Qiaowei Ren compose the initial code of
>> nvm-pages, the related patches are,
>> - bcache: initialize the nvm pages allocator
>> - bcache: initialization of the buddy
>> - bcache: bch_nvm_alloc_pages() of the buddy
>> - bcache: bch_nvm_free_pages() of the buddy
>> - bcache: get allocated pages from specific owner
>> All the code depends on Linux libnvdimm and dax drivers, the bcache nvm-
>> pages allocator can be treated as user of these two drivers.
>>
>> The nvm-pages allocator is a buddy-like allocator, which allocates size
>> in power-of-2 pages from the NVDIMM namespace. User space tool 'bcache'
>> has a new added '-M' option to format a NVDIMM namespace and register it
>> via sysfs interface as a bcache meta device. The nvm-pages kernel code
>> does a DAX mapping to map the whole namespace into system's memory
>> address range, and allocating the pages to requestion like typical buddy
>> allocator does. The major difference is nvm-pages allocator maintains
>> the pages allocated to each requester by a owner list which stored on
>> NVDIMM too. Owner list of different requester is tracked by a pre-
>> defined UUID, all the pages tracked in all owner lists are treated as
>> allocated busy pages and won't be initialized into buddy system after
>> the system reboot.
>>
>> I modify the bcache code to recognize the nvm meta device feature,
>> initialize journal on NVDIMM, and do journal I/Os on NVDIMM in the
>> following patches,
>> - bcache: add initial data structures for nvm pages
>> - bcache: use bucket index to set GC_MARK_METADATA for journal buckets
>>   in bch_btree_gc_finish()
>> - bcache: add BCH_FEATURE_INCOMPAT_NVDIMM_META into incompat feature set
>> - bcache: initialize bcache journal for NVDIMM meta device
>> - bcache: support storing bcache journal into NVDIMM meta device
>> - bcache: read jset from NVDIMM pages for journal replay
>> - bcache: add sysfs interface register_nvdimm_meta to register NVDIMM
>>   meta device
>> - bcache: use div_u64() in init_owner_info()
>>
>> The bcache journal code may request a block of power-of-2 size pages
>> from the nvm-pages allocator, normally it is a range of 256MB or 512MB
>> continuous pages range. During meta data journaling, the in-memory jsets
>> go into the calculated nvdimm pages location by kernel memcpy routine.
>> So the journaling I/Os won't go into block device (e.g. SSD) anymore,
>> the write and read for journal jsets happen on NVDIMM.
>>
>> The whole series is testing for a while and all addressed issues are
>> verified to be fixed. Now it is time to consider this series as an
>> initial code base of a commnity cooperation and have them in bcache
>> upstream for future development.
>>
>> Thanks in advance for taking this. 
> 
> Applied, with 13/13 folded in.
> 

Thank you for doing this.

Coly Li
