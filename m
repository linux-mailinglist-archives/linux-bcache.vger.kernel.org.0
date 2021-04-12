Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC1F35C74C
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Apr 2021 15:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbhDLNOS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 12 Apr 2021 09:14:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:58274 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241101AbhDLNOR (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Apr 2021 09:14:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2837AC6A;
        Mon, 12 Apr 2021 13:13:58 +0000 (UTC)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org
References: <20210411134316.80274-1-colyli@suse.de>
 <20210411134316.80274-8-colyli@suse.de> <20210412090600.GA8026@lst.de>
 <902e1ba6-cd73-b0e8-6c17-75fccbaeb9b4@suse.de>
 <caf688de-19f6-925e-3059-966fe0d8ce42@kernel.dk>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 7/7] bcache: fix a regression of code compiling failure in
 debug.c
Message-ID: <254414c0-8f5d-753e-edb1-e9d3805e7bfb@suse.de>
Date:   Mon, 12 Apr 2021 21:13:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <caf688de-19f6-925e-3059-966fe0d8ce42@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/12/21 8:50 PM, Jens Axboe wrote:
> On 4/12/21 3:53 AM, Coly Li wrote:
>> On 4/12/21 5:06 PM, Christoph Hellwig wrote:
>>> On Sun, Apr 11, 2021 at 09:43:16PM +0800, Coly Li wrote:
>>>> The patch "bcache: remove PTR_CACHE" introduces a compiling failure in
>>>> debug.c with following error message,
>>>>   In file included from drivers/md/bcache/bcache.h:182:0,
>>>>                    from drivers/md/bcache/debug.c:9:
>>>>   drivers/md/bcache/debug.c: In function 'bch_btree_verify':
>>>>   drivers/md/bcache/debug.c:53:19: error: 'c' undeclared (first use in
>>>>   this function)
>>>>     bio_set_dev(bio, c->cache->bdev);
>>>>                      ^
>>>> This patch fixes the regression by replacing c->cache->bdev by b->c->
>>>> cache->bdev.
>>>
>>> Why not fold this into the offending patch?
>>>
>>
>> I don't know whether I can do it without authorization or agreement from
>> original author. And I see other maintainers handling similar situation
>> by either re-write whole patch or appending an extra fix.
>>
>> If you have a suggested process, I can try it out next time for similar
>> situation.
> 
> What I generally do is just add a line between the SOB's for cases
> like this, ala:
> 
> commit 70aacfe66136809d7f080f89c492c278298719f4
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Mon Mar 1 13:02:15 2021 +0000
> 
>     io_uring: kill sqo_dead and sqo submission halting
>     
>     As SQPOLL task doesn't poke into ->sqo_task anymore, there is no need to
>     kill the sqo when the master task exits. Before it was necessary to
>     avoid races accessing sqo_task->files with removing them.
>     
>     Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>     [axboe: don't forget to enable SQPOLL before exit, if started disabled]
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 

This is a new skill to me. Thanks for the hint, I will use such method
to handle similar situation next time.

Coly Li
