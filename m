Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B171936E860
	for <lists+linux-bcache@lfdr.de>; Thu, 29 Apr 2021 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhD2KGx (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 29 Apr 2021 06:06:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:33010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhD2KGw (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 29 Apr 2021 06:06:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 87C1CAF8C;
        Thu, 29 Apr 2021 10:06:05 +0000 (UTC)
Subject: Re: [PATCH -next] bcache: use DEFINE_MUTEX() for mutex lock
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210405101453.15096-1-zhengyongjun3@huawei.com>
 <42c3e33d-c20e-0fdd-f316-5084e33f9a3b@suse.de>
 <d7f70ce31f6f61a50c05a5d5ba03582054f144fe.camel@gmail.com>
 <0b4b7c5cc2f19d2d77a66c0d2ce42f63692174d9.camel@gmail.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <dab84e1a-ccc5-354e-9ef4-caf738da2faa@suse.de>
Date:   Thu, 29 Apr 2021 18:05:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <0b4b7c5cc2f19d2d77a66c0d2ce42f63692174d9.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/29/21 12:19 AM, Muhammad Usama Anjum wrote:
> On Tue, 2021-04-06 at 02:17 +0500, Muhammad Usama Anjum wrote:
>> On Mon, 2021-04-05 at 22:02 +0800, Coly Li wrote:
>>> On 4/5/21 6:14 PM, Zheng Yongjun wrote:
>>>> mutex lock can be initialized automatically with DEFINE_MUTEX()
>>>> rather than explicitly calling mutex_init().
>>>>
>>>> Reported-by: Hulk Robot <hulkci@huawei.com>
>>>> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
>>>
>>> NACK. This is not the first time people try to "fix" this location...
>>>
>>> Using DEFINE_MUTEX() does not gain anything for us, it will generate
>>> unnecessary extra size for the bcache.ko.
>>> ines.
>>
>> How can the final binary have larger size by just static declaration?
>> By using DEFINE_MUTEX, the mutex is initialized at compile time. It'll
>> save initialization at run time and one line of code will be less also
>> from text section. 
>>
>> #### with no change (dynamic initialization)
>> size drivers/md/bcache/bcache.ko
>>    text	   data	    bss	    dec	    hex	filename
>>  187792	  25310	    152	 213254	  34106	drivers/md/bcache/bcache.ko
>>
>> #### with patch applied (static initialization)
>>    text	   data	    bss	    dec	    hex	filename
>>  187751	  25342	    120	 213213	  340dd	drivers/md/bcache/bcache.ko
>>
>> Module's binary size has decreased by 41 bytes with the path applied
>> (x86_64 arch).
>>
> Anybody has any thoughts on it?
> 
> 


I am waiting for Yongjun's v4 patch to update the commit log, which was
suggested by Pavel Goran.

Coly Li
