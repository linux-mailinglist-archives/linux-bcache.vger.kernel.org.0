Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F03E3764E6
	for <lists+linux-bcache@lfdr.de>; Fri,  7 May 2021 14:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhEGMNE (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 7 May 2021 08:13:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:56306 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235823AbhEGMND (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 7 May 2021 08:13:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6074B186;
        Fri,  7 May 2021 12:11:52 +0000 (UTC)
To:     Kai Krakow <kai@kaishome.de>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        =?UTF-8?B?5ZC05pys5Y2/KOS6keahjOmdoiDnpo/lt54p?= 
        <wubenqing@ruijie.com.cn>
References: <82A10A71B70FF2449A8AD233969A45A101CCE29C5B@FZEX5.ruijie.com.cn>
 <CAC2ZOYugQAw9NbMk_oo_2iC5GsZUN=uTO5FuvdRTMy9M6ASNEg@mail.gmail.com>
 <CAC2ZOYtg4P_CYrTH6kQM1vCuU4Bai7v8K3Nmu3Yz7fNuHfEnRw@mail.gmail.com>
 <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com>
From:   Coly Li <colyli@suse.de>
Subject: Re: Dirty data loss after cache disk error recovery
Message-ID: <70b9cdd0-ace9-9ee7-19c7-5c47a4d2fce9@suse.de>
Date:   Fri, 7 May 2021 20:11:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAC2ZOYuBhFbpZeRnnc-1-Vt-tV_3iwkf3i21+YjVukYkx7J7YQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/29/21 2:51 AM, Kai Krakow wrote:
>> I think this behavior was introduced by https://lwn.net/Articles/748226/
>>
>> So above is my late review. ;-)
>>
>> (around commit 7e027ca4b534b6b99a7c0471e13ba075ffa3f482 if you cannot
>> access LWN for reasons[tm])
> 
> The problem may actually come from a different code path which retires
> the cache on metadata error:
> 
> commit 804f3c6981f5e4a506a8f14dc284cb218d0659ae
> "bcache: fix cached_dev->count usage for bch_cache_set_error()"
> 
> It probably should consider if there's any dirty data. As a first
> step, it may be sufficient to run a BUG_ON(there_is_dirty_data) (this
> would kill the bcache thread, may not be a good idea) or even freeze
> the system with an unrecoverable error, or at least stop the device to
> prevent any IO with possibly stale data (because retiring throws away
> dirty data). A good solution would be if the "with dirty data" error
> path could somehow force the attached file system into read-only mode,
> maybe by just reporting IO errors when this bdev is accessed through
> bcache.


There is an option to panic the system when cache device failed. It is
in errors file with available options as "unregister" and "panic". This
option is default set to "unregister", if you set it to "panic" then
panic() will be called.

If the cache set is attached, read-only the bcache device does not
prevent the meta data I/O on cache device (when try to cache the reading
data), if the cache device is really disconnected that will be
problematic too.

The "auto" and "always" options are for "unregister" error action. When
I enhance the device failure handling, I don't add new error action, all
my work was to make the "unregister" action work better.

Adding a new "stop" error action IMHO doesn't make things better. When
the cache device is disconnected, it is always risky that some caching
data or meta data is not updated onto cache device. Permit the cache
device to be re-attached to the backing device may introduce "silent
data loss" which might be worse....  It was the reason why I didn't add
new error action for the device failure handling patch set.

Thanks.

Coly Li
