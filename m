Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4B91B712E
	for <lists+linux-bcache@lfdr.de>; Fri, 24 Apr 2020 11:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDXJty (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 24 Apr 2020 05:49:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:59438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgDXJty (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 24 Apr 2020 05:49:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 220DDAECE;
        Fri, 24 Apr 2020 09:49:51 +0000 (UTC)
Subject: Re: Request For Suggestion: how to handle udevd timeout for bcache
 registration
To:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>
Cc:     linux-block@vger.kernel.org
References: <7c92cd67-8e62-7d55-c520-345c30513bfa@suse.de>
 <140de6d9-b5ff-0736-ddbd-5b9e1ae70f5b@kernel.dk>
 <b2cf1d0e-b710-4e11-7ea8-f01364986c4a@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <569e5b5b-bc4d-8882-51f2-a295dfe6c1b6@suse.de>
Date:   Fri, 24 Apr 2020 11:49:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <b2cf1d0e-b710-4e11-7ea8-f01364986c4a@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/24/20 10:57 AM, Coly Li wrote:
> On 2020/4/23 23:08, Jens Axboe wrote:
>> On 4/23/20 5:23 AM, Coly Li wrote:
>>> Hi folk,
>>>
>>> I want to listen to your suggestion on how to handle the udevd timeout
>>> for bcache registration.
>>>
>>> First of all let me introduce the background of this timeout problem.
>>>
>>> Now the bcache registration is synchronized, the registering process
>>> will be blocked until the whole registration done. In boot up time, such
>>> registration can be initiated from a bcache udev rule. Normally it won't
>>> be problem, but for very large cached data size there might be a large
>>> internal btree on the cache device. During the registration checking all
>>> the btree nodes may take 50+ minutes as a udev task, it exceeds 180
>>> seconds timeout and udevd will kill it. The killing signal will make
>>> kthread_create() fail during bcache initialization, then the automatic
>>> bcache registration in boot up time will fail.
>>>
>>> The above text describes the problem I need to solve: make boot up time
>>> automatic bache registration always success no mater how long it will take.
>>>
>>> I know there are several solutions to solve such problem, I do
>>> appreciate if you may share the solution so that I may learn good ideas
>>> from them.
>>>
>>> Thank you in advance for the information sharing of my request of
>>> suggestion.
>>
>> The way I see it, you have only two choices:
>>
>> 1) Make the registration async (or lazy), so that starting the device is
>>     fast, but the btree verification happens on-demand or in the
>>     background.
>>
> 
> Yes, this is what I plan to do now, make whole initialization to be
> asynchronous.
> 
> Currently there are points not clear to me.
> - During the boot up time, if a bcache device is listed in /etc/fstab.
> How can I block the fs mount step before the bcache device
> /dev/bcache<N> shows up. I guess it should be done in systemd, and not
> sure whether there is another timeout value.
In short: you don't.

Asynchronous initialization means that the device node /dev/bcache<N>
only shows up once registration is complete.

> - When the bcache device registration done and /dev/bcache<N> show up,
> if it is listed in /etc/fstab, how to only mount this bcache device only
> and not touch other mount points.
> 
That's done by systemd, and typically nothing to worry about.
If we can stick with the udev rules and start initialization from an 
udev event everything should 'just work' (tm).

> udev rules and systemd are both magic to me at this moment. If anybody
> may give a hint, or some similar example to learn and understand, it
> will be very helpful.
> 
The proposed sequence of events is:

- backing device generates uevent
-> udev rule triggers bcache initialisation
    -> bcache driver starts initialistion workqueue
    -> bcache driver returns
-> udev event completed

bcache initialisation workqueue starts
    -> bcache driver registers backing device

- cache device generates uevent
-> udev rule triggers bcache initialisation
   -> bcache driver starts initialisation workqueue
   -> bcache driver returns

- bcache initialisation workqueue starts
-> bcache driver registers cache device
   -> bcache driver starts bcache initialisation
     -> bcache driver registers /dev/bcache<N>


With that the uevent handling / bcache userspace initialisation
just submits a workqueue element, and the uevent won't be held off
by an overly long initialisation process.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
