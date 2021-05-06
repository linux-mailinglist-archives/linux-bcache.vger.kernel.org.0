Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B3B3751EE
	for <lists+linux-bcache@lfdr.de>; Thu,  6 May 2021 12:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhEFKFD (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 May 2021 06:05:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:58140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231194AbhEFKFD (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 May 2021 06:05:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9722FAEAA;
        Thu,  6 May 2021 10:04:04 +0000 (UTC)
Subject: Re: Kernel Oops: kernel BUG at block/bio.c:52
To:     Marco Rebhan <me@dblsaiko.net>
Cc:     linux-bcache@vger.kernel.org, victor@westerhu.is
References: <5607192.MhkbZ0Pkbq@invader>
 <104da4a6-61be-63f9-8670-6243e9625e5a@suse.de> <1783900.tdWV9SEqCh@invader>
From:   Coly Li <colyli@suse.de>
Message-ID: <4b6c9608-84e9-e20b-ac84-c4fd0a536f29@suse.de>
Date:   Thu, 6 May 2021 18:04:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <1783900.tdWV9SEqCh@invader>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 5/6/21 3:36 PM, Marco Rebhan wrote:
> On Thursday, 6 May 2021 04:50:06 CEST Coly Li wrote:
>> Could you please try the attached patch ?  If a suspicious bio
>> allocation happens, this patch will print out a warning kernel message
>> and avoid the BUG() panic.
> 
> Looks like the patch works. Here's a dmesg log that comes from starting
> up a game with a bunch of large files (which I'm guessing are what
> makes this happen more often?)
> 

Before 5.12, the allocation failure returns a NULL pointer, so such
issue was hidden. I will post a quick fix to emulate previous code logic
without bothering bio_alloc_bioset().

Thanks for the quick test and verification.

Coly Li


> [   39.284230] bcache: cached_dev_cache_miss() inserting bio is too large: 344 iovecs, not intsert.
> [   65.415896] bcache: cached_dev_cache_miss() inserting bio is too large: 282 iovecs, not intsert.
> [   65.446327] bcache: cached_dev_cache_miss() inserting bio is too large: 946 iovecs, not intsert.
> [   88.116826] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
> [   88.957691] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
> [   89.020544] bcache: cached_dev_cache_miss() inserting bio is too large: 332 iovecs, not intsert.
> [   90.531875] bcache: cached_dev_cache_miss() inserting bio is too large: 261 iovecs, not intsert.
> [  111.464124] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
> [  111.497049] bcache: cached_dev_cache_miss() inserting bio is too large: 262 iovecs, not intsert.
> [  111.638928] bcache: cached_dev_cache_miss() inserting bio is too large: 318 iovecs, not intsert.
> [  155.884142] bcache: cached_dev_cache_miss() inserting bio is too large: 447 iovecs, not intsert.
> [  156.146070] bcache: cached_dev_cache_miss() inserting bio is too large: 512 iovecs, not intsert.
> [  156.223795] bcache: cached_dev_cache_miss() inserting bio is too large: 277 iovecs, not intsert.
> [  156.326145] bcache: cached_dev_cache_miss() inserting bio is too large: 342 iovecs, not intsert.
> [  156.602906] bcache: cached_dev_cache_miss() inserting bio is too large: 290 iovecs, not intsert.
> [  156.646365] bcache: cached_dev_cache_miss() inserting bio is too large: 341 iovecs, not intsert.
> [  156.671285] bcache: cached_dev_cache_miss() inserting bio is too large: 501 iovecs, not intsert.
> [  157.216087] bcache: cached_dev_cache_miss() inserting bio is too large: 258 iovecs, not intsert.
> [  165.010961] bcache: cached_dev_cache_miss() inserting bio is too large: 413 iovecs, not intsert.
> [  165.386483] bcache: cached_dev_cache_miss() inserting bio is too large: 260 iovecs, not intsert.
> 
> Thanks,
> Marco
> 

