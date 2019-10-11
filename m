Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C04D38B6
	for <lists+linux-bcache@lfdr.de>; Fri, 11 Oct 2019 07:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfJKFgR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 11 Oct 2019 01:36:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:34810 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfJKFgQ (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 11 Oct 2019 01:36:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0E4C9AD12;
        Fri, 11 Oct 2019 05:36:15 +0000 (UTC)
Subject: Re: [PATCH v3] bcache: fix deadlock in bcache_allocator
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190807103806.GA15450@xps-13>
 <1360a7e6-9135-6f3e-fc30-0834779bcf69@suse.de>
 <20191010152124.GA25334@xps-13>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Message-ID: <734d5e9b-cde0-07ec-3162-e502a73752b6@suse.de>
Date:   Fri, 11 Oct 2019 13:36:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010152124.GA25334@xps-13>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/10 11:21 下午, Andrea Righi wrote:
> On Wed, Aug 07, 2019 at 09:53:46PM +0800, Coly Li wrote:
>> On 2019/8/7 6:38 下午, Andrea Righi wrote:
>>> bcache_allocator can call the following:
>>>
>>>  bch_allocator_thread()
>>>   -> bch_prio_write()
>>>      -> bch_bucket_alloc()
>>>         -> wait on &ca->set->bucket_wait
>>>
>>> But the wake up event on bucket_wait is supposed to come from
>>> bch_allocator_thread() itself => deadlock:
>>>
>>> [ 1158.490744] INFO: task bcache_allocato:15861 blocked for more than 10 seconds.
>>> [ 1158.495929]       Not tainted 5.3.0-050300rc3-generic #201908042232
>>> [ 1158.500653] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> [ 1158.504413] bcache_allocato D    0 15861      2 0x80004000
>>> [ 1158.504419] Call Trace:
>>> [ 1158.504429]  __schedule+0x2a8/0x670
>>> [ 1158.504432]  schedule+0x2d/0x90
>>> [ 1158.504448]  bch_bucket_alloc+0xe5/0x370 [bcache]
>>> [ 1158.504453]  ? wait_woken+0x80/0x80
>>> [ 1158.504466]  bch_prio_write+0x1dc/0x390 [bcache]
>>> [ 1158.504476]  bch_allocator_thread+0x233/0x490 [bcache]
>>> [ 1158.504491]  kthread+0x121/0x140
>>> [ 1158.504503]  ? invalidate_buckets+0x890/0x890 [bcache]
>>> [ 1158.504506]  ? kthread_park+0xb0/0xb0
>>> [ 1158.504510]  ret_from_fork+0x35/0x40
>>>
>>> Fix by making the call to bch_prio_write() non-blocking, so that
>>> bch_allocator_thread() never waits on itself.
>>>
>>> Moreover, make sure to wake up the garbage collector thread when
>>> bch_prio_write() is failing to allocate buckets.
>>>
>>> BugLink: https://bugs.launchpad.net/bugs/1784665
>>> BugLink: https://bugs.launchpad.net/bugs/1796292
>>> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
>>
>> OK, I add this version into my for-test directory. Once you have a new
>> version, I will update it. Thanks.
>>
>> Coly Li
> 
> Hi Coly,
> 
> any news about this patch? We're still using it in Ubuntu and no errors

It has been testing on your side for quite long time, and I don't have
better idea on the fix. It looks solid enough, and indeed I have it in
my development patches already with more testing.

> have been reported so far. Do you think we can add this to linux-next?

Yes, this is my plan. It is in my testing queue with other developing
patches.

Thanks.

-- 

Coly Li
