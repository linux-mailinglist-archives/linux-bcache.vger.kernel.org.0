Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C503935433A
	for <lists+linux-bcache@lfdr.de>; Mon,  5 Apr 2021 17:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241467AbhDEPPC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 5 Apr 2021 11:15:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:53056 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236175AbhDEPPB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 5 Apr 2021 11:15:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D1AD7ADAA;
        Mon,  5 Apr 2021 15:14:53 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     Qiaowei Ren <qiaowei.ren@intel.com>,
        Jianpeng Ma <jianpeng.ma@intel.com>
Cc:     linux-bcache@vger.kernel.org
References: <20210317151029.40735-1-qiaowei.ren@intel.com>
 <20210317151029.40735-3-qiaowei.ren@intel.com>
 <f1bab0fa-e5cf-a0ca-5e89-b9dfdcff7988@suse.de>
Subject: Re: [bch-nvm-pages v7 2/6] bcache: initialize the nvm pages allocator
Message-ID: <466afba1-30ed-0a4c-15fa-1c192eb61d8a@suse.de>
Date:   Mon, 5 Apr 2021 23:14:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <f1bab0fa-e5cf-a0ca-5e89-b9dfdcff7988@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/29/21 1:54 PM, Coly Li wrote:
> On 3/17/21 11:10 PM, Qiaowei Ren wrote:
>> From: Jianpeng Ma <jianpeng.ma@intel.com>
>>
>> This patch define the prototype data structures in memory and initializes
>> the nvm pages allocator.
>>
>> The nv address space which is managed by this allocatior can consist of
>> many nvm namespaces, and some namespaces can compose into one nvm set,
>> like cache set. For this initial implementation, only one set can be
>> supported.
>>
>> The users of this nvm pages allocator need to call regiseter_namespace()
>> to register the nvdimm device (like /dev/pmemX) into this allocator as
>> the instance of struct nvm_namespace.
>>
>> Signed-off-by: Jianpeng Ma <jianpeng.ma@intel.com>
>> Co-authored-by: Qiaowei Ren <qiaowei.ren@intel.com>

[snipped]

>> -
>>  struct bch_pgalloc_rec {
>>  	__u64			pgoff:52;
>>  	__u64			order:12;
>>
> 
> BTW the above difinication of bit field is improper. You won't get what
> you wan't as a 64bit size record. But don't worry I fix it in other
> patches and the joint series will be posted soon after I integriate them
> together.

I withdraw the above comments. This is for NVDIMM, and libnvdimm depends
on PHYS_ADDR_T_64BIT, it implicitly indicates a 64bit kernel (64BIT=y).
So your method works.

I will take the above idea in my patch to define the meta data
structure. One more modification is, order:12 is too large, I will take
6 bits, and reserve the highest 6 bits.

Thanks.

Coly Li
