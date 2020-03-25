Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72241191F14
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Mar 2020 03:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCYCcu (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Mar 2020 22:32:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:58362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727262AbgCYCcu (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 22:32:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5679CAE07;
        Wed, 25 Mar 2020 02:32:48 +0000 (UTC)
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        kbuild test robot <lkp@intel.com>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
 <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
Date:   Wed, 25 Mar 2020 10:32:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/25 9:57 上午, Jens Axboe wrote:
> On 3/24/20 7:30 PM, Coly Li wrote:
>> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
>> into btree.h") makes two duplicated declaration into btree.h,
>> 	typedef int (btree_map_keys_fn)();
>> 	int bch_btree_map_keys();
>>
>> The kbuild test robot <lkp@intel.com> detects and reports this
>> problem and this patch fixes it by removing the duplicated ones.
>>
>> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")
> 
> Applied, but I fixed up the commit sha, not sure where yours is from?
> 

I should use the sha from your tree, not mine. I just realize with your
SOB the sha number should change. Sorry for the inconvenience, and I
will notice such condition next time.

BTW, you still find such issue by your own eyes, without any extra tool?

Thanks.
-- 

Coly Li
