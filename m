Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00857EF3B6
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 03:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfKECtz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 21:49:55 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41068 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbfKECtz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 21:49:55 -0500
Received: by mail-pl1-f193.google.com with SMTP id d29so2281204plj.8
        for <linux-bcache@vger.kernel.org>; Mon, 04 Nov 2019 18:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T49R0h9T5fPg5hmMAjB311o5ZFPr6cvr6rmnaojgAKw=;
        b=d2tsn7Ao9KNemJ3MfMilEPAD7mzTnp42v2EVljOGcCUXUElErCUI8kIrJuJGNeGxtv
         AbYo0w4BaRWxpOJqUhZWje8w13RMmmOZ9b86SlB2GLcpd6l025BeGshwaMk0O/TlHLjc
         X1rJGS2nYPzOPGHC+iQihHc/lCImP6VgVfGTnnklcQhhTZb4SmoLc/iedDqee4Q4OjxU
         WLSr1orcuedTPpo+s3PbOE73be9bB6BSnbOK50u6ppJPyBqX7rmVciTKYCZz7ySlK4Xo
         Y8khaE/Tn6u1j1DpvLComiH2AGaRW0Z9HqlYkONQ/foc1W4it4IF4HHDftlYGdQGXNC2
         9CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T49R0h9T5fPg5hmMAjB311o5ZFPr6cvr6rmnaojgAKw=;
        b=nrAWo98yrSGqXih+LdAFUOztLWYZAKPV7G/OtKQgsUV/+tCOmOc9BOm/m6PR+5EJki
         zHXmLhsqAmrrxcMelBuGXxDBNKQkrG4Yw0EGZu6afJJm7DDZCgKIq6bTmQb91dUtpGai
         vUFbAs1/LqspgXnXM6yz8riz4hA939+lxx6ir2PXYw75t8VSnXqbNcaWzDil88zXP51b
         y6ylhFzqlbYvGgHsKOBm/0mJHjr+EYxqzEP+HU31usVTIghLFQzOhUjQQmnIBp4hrE+F
         ap2Y72GkasGxc7t+vnIrhnRuK8vRVW2BGjoLbltTdvm8RwDOVML+YvGAwzfEGIKdSrcr
         zIcw==
X-Gm-Message-State: APjAAAVEySyc44IJDETP78sbG7sSXuj7H9khlxTLt7eF+IouoWuRUO53
        dz/Hn9AeY0KvQTrBfwHlp+wB8jMPk5D0sQ==
X-Google-Smtp-Source: APXvYqx10sVrPPaUPWgS50ISuZzeLRJ7t1GyYI+51RBRb+WAEgCV1RgvpS2lDGS320UYTJNev5mbag==
X-Received: by 2002:a17:902:9045:: with SMTP id w5mr31131847plz.304.1572922192940;
        Mon, 04 Nov 2019 18:49:52 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id z18sm21667662pgv.90.2019.11.04.18.49.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 18:49:52 -0800 (PST)
Subject: Re: [PATCH V4] block: optimize for small block size IO
To:     Ming Lei <ming.lei@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Keith Busch <kbusch@kernel.org>,
        linux-bcache@vger.kernel.org
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel> <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel> <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan> <20191105022046.GF11436@ming.t460p>
 <20191105023002.GC18564@moria.home.lan> <20191105024641.GG11436@ming.t460p>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06fc1a0c-8c8b-e7ab-f343-3861db737776@kernel.dk>
Date:   Mon, 4 Nov 2019 19:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105024641.GG11436@ming.t460p>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/4/19 7:46 PM, Ming Lei wrote:
> On Mon, Nov 04, 2019 at 09:30:02PM -0500, Kent Overstreet wrote:
>> On Tue, Nov 05, 2019 at 10:20:46AM +0800, Ming Lei wrote:
>>> On Mon, Nov 04, 2019 at 09:11:30PM -0500, Kent Overstreet wrote:
>>>> On Tue, Nov 05, 2019 at 09:11:35AM +0800, Ming Lei wrote:
>>>>> On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
>>>>>> On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
>>>>>>> On 11/4/19 11:17 AM, Kent Overstreet wrote:
>>>>>>>> On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
>>>>>>>>> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
>>>>>>>>>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
>>>>>>>>>>> __blk_queue_split() may be a bit heavy for small block size(such as
>>>>>>>>>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
>>>>>>>>>>> multiple page. And only consider to try splitting this bio in case
>>>>>>>>>>> that the multiple page flag is set.
>>>>>>>>>>
>>>>>>>>>> So, back in the day I had an alternative approach in mind: get rid of
>>>>>>>>>> blk_queue_split entirely, by pushing splitting down to the request layer - when
>>>>>>>>>> we map the bio/request to sgl, just have it map as much as will fit in the sgl
>>>>>>>>>> and if it doesn't entirely fit bump bi_remaining and leave it on the request
>>>>>>>>>> queue.
>>>>>>>>>>
>>>>>>>>>> This would mean there'd be no need for counting segments at all, and would cut a
>>>>>>>>>> fair amount of code out of the io path.
>>>>>>>>>
>>>>>>>>> I thought about that to, but it will take a lot more effort.  Mostly
>>>>>>>>> because md/dm heavily rely on splitting as well.  I still think it is
>>>>>>>>> worthwhile, it will just take a significant amount of time and we
>>>>>>>>> should have the quick improvement now.
>>>>>>>>
>>>>>>>> We can do it one driver at a time - driver sets a flag to disable
>>>>>>>> blk_queue_split(). Obvious one to do first would be nvme since that's where it
>>>>>>>> shows up the most.
>>>>>>>>
>>>>>>>> And md/md do splitting internally, but I'm not so sure they need
>>>>>>>> blk_queue_split().
>>>>>>>
>>>>>>> I'm a big proponent of doing something like that instead, but it is a
>>>>>>> lot of work. I absolutely hate the splitting we're doing now, even
>>>>>>> though the original "let's work as hard as we add add page time to get
>>>>>>> things right" was pretty abysmal as well.
>>>>>>
>>>>>> Last I looked I don't think it was going to be that bad, just needed a bit of
>>>>>> finesse. We just need to be able to partially process a request in e.g.
>>>>>> nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as much as
>>>>>> will fit instead of popping an assertion.
>>>>>
>>>>> I think it may not be doable.
>>>>>
>>>>> blk_rq_map_sg() is called by drivers and has to work on single request, however
>>>>> more requests have to be involved if we delay the splitting to blk_rq_map_sg().
>>>>> Cause splitting means that two bios can't be submitted in single IO request.
>>>>
>>>> Of course it's doable, do I have to show you how?
>>>
>>> No, you don't have to, could you just point out where my above words is wrong?
>>
>> blk_rq_map_sg() _currently_ works on a single request, but as I said from the
>> start that this would involve changing it to only process as much of a request
>> as would fit on an sglist.
> 
>> Drivers will have to be modified, but the changes to driver code should be
>> pretty easy. What will be slightly trickier will be changing blk-mq to handle
>> requests that are only partially completed; that will be harder than it would
>> have been before blk-mq, since the old request queue code used to handle
>> partially completed requests - not much work would have to be done that code.
> 
> Looks you are suggesting partial request completion.
> 
> Then the biggest effect could be in performance, this change will cause the
> whole FS bio is handled part by part serially, instead of submitting all
> splitted bios(part) concurrently.
> 
> So sounds you are suggesting to fix one performance issue by causing new perf
> issue, is that doable?

It does seem like a rat hole of sorts. Because then you start adding code to
guesstimate how big the request could roughly be, and if you miss a bit,
you get a request that's tiny in between the normal sized ones.

Or you'd clone, and then you could still have them inflight in parallel.
But then you're paying the cost of that...

-- 
Jens Axboe

