Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0440135C317
	for <lists+linux-bcache@lfdr.de>; Mon, 12 Apr 2021 12:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhDLJ5e (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 12 Apr 2021 05:57:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:52624 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242842AbhDLJyM (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 12 Apr 2021 05:54:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DEE4CAF1A;
        Mon, 12 Apr 2021 09:53:53 +0000 (UTC)
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20210411134316.80274-1-colyli@suse.de>
 <20210411134316.80274-8-colyli@suse.de> <20210412090600.GA8026@lst.de>
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 7/7] bcache: fix a regression of code compiling failure in
 debug.c
Message-ID: <902e1ba6-cd73-b0e8-6c17-75fccbaeb9b4@suse.de>
Date:   Mon, 12 Apr 2021 17:53:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210412090600.GA8026@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/12/21 5:06 PM, Christoph Hellwig wrote:
> On Sun, Apr 11, 2021 at 09:43:16PM +0800, Coly Li wrote:
>> The patch "bcache: remove PTR_CACHE" introduces a compiling failure in
>> debug.c with following error message,
>>   In file included from drivers/md/bcache/bcache.h:182:0,
>>                    from drivers/md/bcache/debug.c:9:
>>   drivers/md/bcache/debug.c: In function 'bch_btree_verify':
>>   drivers/md/bcache/debug.c:53:19: error: 'c' undeclared (first use in
>>   this function)
>>     bio_set_dev(bio, c->cache->bdev);
>>                      ^
>> This patch fixes the regression by replacing c->cache->bdev by b->c->
>> cache->bdev.
> 
> Why not fold this into the offending patch?
> 

I don't know whether I can do it without authorization or agreement from
original author. And I see other maintainers handling similar situation
by either re-write whole patch or appending an extra fix.

If you have a suggested process, I can try it out next time for similar
situation.

Coly Li
