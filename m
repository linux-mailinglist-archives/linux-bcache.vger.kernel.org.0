Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDDC114E1C
	for <lists+linux-bcache@lfdr.de>; Fri,  6 Dec 2019 10:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbfLFJXB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 6 Dec 2019 04:23:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:38168 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726088AbfLFJXB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 6 Dec 2019 04:23:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 06DB3B299;
        Fri,  6 Dec 2019 09:22:57 +0000 (UTC)
Subject: Re: [RFC PATCH] bcache: enable zoned device support
To:     Damien Le Moal <Damien.LeMoal@wdc.com>, Coly Li <colyli@suse.de>,
        Eric Wheeler <bcache@lists.ewheeler.net>
Cc:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
References: <20191205152543.73885-1-colyli@suse.de>
 <alpine.LRH.2.11.1912060012380.11561@mx.ewheeler.net>
 <BYAPR04MB5816090B934A7CA17EFA688AE75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <a21ce3de-5591-198f-56bf-8dc3aee6c926@suse.de>
 <66345af3-fad6-3079-1604-3b0e9d2779ce@suse.de>
 <BYAPR04MB5816E7F7741B3DC8D1B3B759E75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <c44e1f50-8c3e-fc30-8ead-2cc044350555@suse.de>
Date:   Fri, 6 Dec 2019 10:22:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB5816E7F7741B3DC8D1B3B759E75F0@BYAPR04MB5816.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 12/6/19 8:42 AM, Damien Le Moal wrote:
> On 2019/12/06 16:09, Hannes Reinecke wrote:
[ .. ]
>> So having bcache running on top of those will be a clear win.
>> But in this scenario the cache device will be a normal device (typically
>> an SSD), and we shouldn't need much modification here.
> 
> I agree. That should work mostly as is since the user will be zone aware
> and already be issuing sequential writes. bcache write-through only
> needs to follow the same pattern, not reordering any write, and
> write-back only has to replay the same.
> 
Bcache really should just act as a block-based cache; the only trick
here is to ensure to align the internal bcache buckets with zone sizes,
so that in the optimal case only full zones will be written.

>> In fact, a good testcase would be the btrfs patches which got posted
>> earlier this week. With them you should be able to create a btrfs
>> filesystem on the SMR drive, and use an SSD as a cache device.
>> Getting this scenario to run would indeed be my primary goal, and I
>> guess your patches should be more or less sufficient for that.
> 
> + Will need the zone revalidation and zone type & write lock bitmaps to
> prevent reordering from the block IO stack, unless bcache is a BIO
> driver ? My knowledge of bcache is limited. Would need to look into the
> details a little more to be able to comment.
> 
bcache is a bio-based driver, so it won't do a request reordering itself.
So from that perspective we should be fine.

>> 2) Using a SMR drive as a _cache_ device. This seems to be contrary to
>> the above statement of SMR drive not being fast, but then the NVMe WG is
>> working on a similar mechanism for flash devices called 'ZNS' (zoned
>> namespaces). And for those it really would make sense to have bcache
>> being able to handle zoned devices as a cache device.
>> But this is to my understanding really in the early stages, with no real
>> hardware being available. Damien might disagree, though :-)
> 
> Yes, that would be another potential use case and ZNS indeed could fit
> this model, assuming that zone sizes align (multiples) between front and
> back devices.
> 
Indeed, but I would defer to my friendly drive manufacturer to figure
that out :-)

>> And the implementation is still on the works on the linux side, so it's
>> more of a long-term goal.>
>> But the first use-case is definitely something we should be looking at;
>> SMR drives are available _and_ with large capacity, so any speedup there
>> would be greatly appreciated.
> 
> Yes. And what I was talking about in my earlier email is actually a
> third use case:
> 3) SMR drive as backend + regular SSD as frontend and the resulting
> bcache device advertising itself as a regular disk, hiding all the zone
> & sequential write constraint to the user. Since bcache already has some
> form of indirection table for cached blocks, I thought we could hijack
> this to implement a sort of FTL that would allow serializing random
> writes to the backend with the help of the frontend as a write staging
> buffer. Doing so, we get full random write capability with the benefit
> of "hot" blocks staying in the cache. But again, not knowing enough
> details about bcache, I may be talking too lightly here. Not sure if
> that is reasonably easily feasible with the current bcache code.
> 
That, however, will be tricky, as the underlying drive will _still_ have
to contain a normal filesystem.
While this mode of operation should be trivial for btrfs with the
hmzoned patches, others like ext4 or xfs will be ... interesting.
I wouldn't discount it out of hand, but there's a fair chance that it'll
lead to intense cache-trashing as we'd need to cover up for random
writes within zones, _and_ would have to read-in entire zones.
But sure, worth a shot anyway.

Once we get the btrfs case working, that it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
