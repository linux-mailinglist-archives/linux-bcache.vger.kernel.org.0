Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34380EF392
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 03:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfKECis (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 21:38:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44562 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729717AbfKECis (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 21:38:48 -0500
Received: by mail-pg1-f193.google.com with SMTP id f19so3819495pgk.11
        for <linux-bcache@vger.kernel.org>; Mon, 04 Nov 2019 18:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PMK3bi1BZwSHPTMfPiTgmL2umGEqO55gEHSQ6R5QvWw=;
        b=PQu7v4TJnkBlWpreoDe1b7hJbTh+s7I4/5X7sDk6e8Ws6elmQ8OWaZYZB5t6cDkBDi
         phSmdp72MA68Z9x97W+laEPgOqiEnBtHBb8BN6uuv0pXf2M1nigp3l1gEhPQXUerJJrO
         5v64UerWx1qKXungkC5hAxxlgfMm2ws/8edQlPrhdLc+OVi598gfXzt4/AifQFUTFeFP
         yMbwVsumQtHJd4O4YvyzKaKQCznHC91nfYb+bBh5CFysfe2UHjyq9atqlxe8lqw4cuci
         6oQROrzoJGGjQekZpnT6pkvQoVL2cthN/JdoARLpj5r9QPBmQ9FBhg4LH/oLCBGfLtnK
         sbNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PMK3bi1BZwSHPTMfPiTgmL2umGEqO55gEHSQ6R5QvWw=;
        b=eeY/7fTGigiaQ12KMmHAHd5GltcpTJgwqOa0pI8ugmKAC1spLolteedBr/Qs6En2jD
         EP5RMtgpZG/CpkYnq0Rji2l1oAlprDYott/TB/2iUs75NJIEtQaFcB+wvT5NZCw+MlnV
         Ie3WzDuLy6BEUp73KCQtUzZMfSPFkuU+i2H+e2+9lRabqPP2ym8yHDMUM38EM48Y/GWz
         i79qT4ue4LEeh3cHnkXleRBFy62dHMvzS1+u4yH+ueKSFbAo6H+Fj6tOSwNcUyamOlnp
         yobjgPRlPysKQXynGxuPd8uVGxFxm+xbAgShQFsPQDSZJ7aSvGCNQ2wBClXRGjRVuMKV
         culQ==
X-Gm-Message-State: APjAAAWmAnJwEN0FrmFVMMAkCcD1Q9/+oo1sYpzPjq154ZyOQljgpme7
        Vqr6U81vUZ8+ieQHjN5yM2kui2c0nSxMxQ==
X-Google-Smtp-Source: APXvYqzOcl56ztezL2RO7k3ubRNucNqZ0E9Cbk0gzBGoM6fJSZ64zolNNySNX6x+bUC+gAr6gtRRJQ==
X-Received: by 2002:a62:ea0b:: with SMTP id t11mr19210363pfh.182.1572921526479;
        Mon, 04 Nov 2019 18:38:46 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id g6sm10121077pfh.125.2019.11.04.18.38.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Nov 2019 18:38:45 -0800 (PST)
Subject: Re: [PATCH V4] block: optimize for small block size IO
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        Coly Li <colyli@suse.de>, Keith Busch <kbusch@kernel.org>,
        linux-bcache@vger.kernel.org
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel> <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel> <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan> <20191105022046.GF11436@ming.t460p>
 <20191105023002.GC18564@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c41fd177-21e7-7e36-960f-fb1f7808f3e2@kernel.dk>
Date:   Mon, 4 Nov 2019 19:38:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105023002.GC18564@moria.home.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/4/19 7:30 PM, Kent Overstreet wrote:
> On Tue, Nov 05, 2019 at 10:20:46AM +0800, Ming Lei wrote:
>> On Mon, Nov 04, 2019 at 09:11:30PM -0500, Kent Overstreet wrote:
>>> On Tue, Nov 05, 2019 at 09:11:35AM +0800, Ming Lei wrote:
>>>> On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
>>>>> On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
>>>>>> On 11/4/19 11:17 AM, Kent Overstreet wrote:
>>>>>>> On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
>>>>>>>> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
>>>>>>>>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
>>>>>>>>>> __blk_queue_split() may be a bit heavy for small block size(such as
>>>>>>>>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
>>>>>>>>>> multiple page. And only consider to try splitting this bio in case
>>>>>>>>>> that the multiple page flag is set.
>>>>>>>>>
>>>>>>>>> So, back in the day I had an alternative approach in mind: get rid of
>>>>>>>>> blk_queue_split entirely, by pushing splitting down to the request layer - when
>>>>>>>>> we map the bio/request to sgl, just have it map as much as will fit in the sgl
>>>>>>>>> and if it doesn't entirely fit bump bi_remaining and leave it on the request
>>>>>>>>> queue.
>>>>>>>>>
>>>>>>>>> This would mean there'd be no need for counting segments at all, and would cut a
>>>>>>>>> fair amount of code out of the io path.
>>>>>>>>
>>>>>>>> I thought about that to, but it will take a lot more effort.  Mostly
>>>>>>>> because md/dm heavily rely on splitting as well.  I still think it is
>>>>>>>> worthwhile, it will just take a significant amount of time and we
>>>>>>>> should have the quick improvement now.
>>>>>>>
>>>>>>> We can do it one driver at a time - driver sets a flag to disable
>>>>>>> blk_queue_split(). Obvious one to do first would be nvme since that's where it
>>>>>>> shows up the most.
>>>>>>>
>>>>>>> And md/md do splitting internally, but I'm not so sure they need
>>>>>>> blk_queue_split().
>>>>>>
>>>>>> I'm a big proponent of doing something like that instead, but it is a
>>>>>> lot of work. I absolutely hate the splitting we're doing now, even
>>>>>> though the original "let's work as hard as we add add page time to get
>>>>>> things right" was pretty abysmal as well.
>>>>>
>>>>> Last I looked I don't think it was going to be that bad, just needed a bit of
>>>>> finesse. We just need to be able to partially process a request in e.g.
>>>>> nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as much as
>>>>> will fit instead of popping an assertion.
>>>>
>>>> I think it may not be doable.
>>>>
>>>> blk_rq_map_sg() is called by drivers and has to work on single request, however
>>>> more requests have to be involved if we delay the splitting to blk_rq_map_sg().
>>>> Cause splitting means that two bios can't be submitted in single IO request.
>>>
>>> Of course it's doable, do I have to show you how?
>>
>> No, you don't have to, could you just point out where my above words is wrong?
> 
> blk_rq_map_sg() _currently_ works on a single request, but as I said
> from the start that this would involve changing it to only process as
> much of a request as would fit on an sglist.
> 
> Drivers will have to be modified, but the changes to driver code
> should be pretty easy. What will be slightly trickier will be changing
> blk-mq to handle requests that are only partially completed; that will
> be harder than it would have been before blk-mq, since the old request
> queue code used to handle partially completed requests - not much work
> would have to be done that code.
> 
> I'm not very familiar with the blk-mq code, so Jens would be better
> qualified to say how best to change that code. The basic idea would
> probably be the same as how bios how have a refcount - bi_remaining -
> to track splits/completions. If requests (in blk-mq land) don't have
> such a refcount (they don't appear to), it will have to be added.
> 
>  From a quick glance, blk_mq_complete_request() is where the refcount
>  put will have to be added. I haven't found where requests are popped
>  off the request queue in blk-mq land yet - the code will have to be
>  changed to only do that once the request has been fully mapped and
>  submitted by the driver.

This is where my knee jerk at the initial "partial completions" and
"should be trivial" start to kick in. I don't think they are necessarily
hard, but they aren't free either. And you'd need to be paying that
atomic_dec cost for every IO. Maybe that's cheaper than the work we
currently have to do, maybe not... If it's a clear win, then it'd be an
interesting path to pursue. But we probably won't have that answer until
at least a hacky version is done as proof of concept.

On the upside, it'd simplify things to just have the mapping in one
place, when the request is setup. Though until all drivers do that
(which I worry will be never), then we'd be stuck with both. Maybe
that's a bit to pessimistic, should be easier now since we just have
blk-mq.

-- 
Jens Axboe

