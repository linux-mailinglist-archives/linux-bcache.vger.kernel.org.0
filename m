Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5A73EF377
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Nov 2019 03:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbfKECaH (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 4 Nov 2019 21:30:07 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39529 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729760AbfKECaH (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 4 Nov 2019 21:30:07 -0500
Received: by mail-qt1-f195.google.com with SMTP id t8so27227161qtc.6;
        Mon, 04 Nov 2019 18:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Z53mfV1l3JG82jMpPqK+svB/4/9pDt88UI124+HxGaU=;
        b=d++TWgV65zub79/YhC04HqZ0XaU4dyRhZlflrS7omdZ7A9e/EkCFp+PVqR2AIMmAg5
         To/2iP5vY/r9oM+Y1M8cFTguffO02NN1KLUsd7jOLHup0PqxkxYgJ7er4PsFvBwdBTHE
         cLs9fePRwsRQnniorgmOgVFP24RCOhPxr4EXIem5HJD0g0GTfUEv2N2ntub+gjPz9LSj
         98IK8XAIoyAXb8qRKYi3zC4NWy2XGYTPAqlIZH7cCCKc39a9TF+6CtwRM2Cwwp4OMNN2
         nwjJoqs424iWCfRxv2zf4EXZCUCYM1pvkmfG6jSuYdu2t4j3RuawsvsqceCilprPYI1K
         ofoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Z53mfV1l3JG82jMpPqK+svB/4/9pDt88UI124+HxGaU=;
        b=aivyZyiTejy9qpf2S63ASZAmGhopMQvNAGuTfY9GBnBxlYronWWMmVCSMi9s7UQpOo
         r0x7wRel1mmrhx28yRSyLXFMOmxr378/R8lWlm4AZKu+x4D74rG4+/xPSZRsfhCyoX7H
         F8kX8b6dGzRwoZqe4RC48e07uU9BGcVN4yr4OhGGn8b5WfC3g2qF8IvPSYin2Z0UIc7l
         ZzNaCWo3uzEFUP3Iw34HDcEgoUg0S+0aGzUT8kb91Mz014Y1zawaQgaaVDuW2J42mAKd
         h6XDCMy6fDb81pu7mKxjVtqrpGWk0j4qCuTz3pt1ErjOQJSjQ6unbZDV8mQ/wT4+XkXG
         w9Mg==
X-Gm-Message-State: APjAAAWzM5SaJDIdbQvYJLQQe++O5yazRKPuyubuiP1vakiuDXpqwBFx
        5Fb0xanwC7REfMDxo/sZ1w==
X-Google-Smtp-Source: APXvYqzC9UtDzV8tJLTiKupMtzgJ5PUVaJgYHTSK7ND49ewnUHTCDWrT0NU9Rcr4wvkrKuqIsbDgaQ==
X-Received: by 2002:aed:3467:: with SMTP id w94mr15927980qtd.166.1572921005412;
        Mon, 04 Nov 2019 18:30:05 -0800 (PST)
Received: from moria.home.lan ([2601:19b:c500:a1:7285:c2ff:fed5:c918])
        by smtp.gmail.com with ESMTPSA id j4sm8950573qkf.116.2019.11.04.18.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 18:30:04 -0800 (PST)
Date:   Mon, 4 Nov 2019 21:30:02 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
Subject: Re: [PATCH V4] block: optimize for small block size IO
Message-ID: <20191105023002.GC18564@moria.home.lan>
References: <20191102072911.24817-1-ming.lei@redhat.com>
 <20191104181403.GA8984@kmo-pixel>
 <20191104181541.GA21116@infradead.org>
 <20191104181742.GC8984@kmo-pixel>
 <f7fab4e0-58e4-76e4-a503-bb535b2a3da6@kernel.dk>
 <20191104184217.GD8984@kmo-pixel>
 <20191105011135.GD11436@ming.t460p>
 <20191105021130.GB18564@moria.home.lan>
 <20191105022046.GF11436@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105022046.GF11436@ming.t460p>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Nov 05, 2019 at 10:20:46AM +0800, Ming Lei wrote:
> On Mon, Nov 04, 2019 at 09:11:30PM -0500, Kent Overstreet wrote:
> > On Tue, Nov 05, 2019 at 09:11:35AM +0800, Ming Lei wrote:
> > > On Mon, Nov 04, 2019 at 01:42:17PM -0500, Kent Overstreet wrote:
> > > > On Mon, Nov 04, 2019 at 11:23:42AM -0700, Jens Axboe wrote:
> > > > > On 11/4/19 11:17 AM, Kent Overstreet wrote:
> > > > > > On Mon, Nov 04, 2019 at 10:15:41AM -0800, Christoph Hellwig wrote:
> > > > > >> On Mon, Nov 04, 2019 at 01:14:03PM -0500, Kent Overstreet wrote:
> > > > > >>> On Sat, Nov 02, 2019 at 03:29:11PM +0800, Ming Lei wrote:
> > > > > >>>> __blk_queue_split() may be a bit heavy for small block size(such as
> > > > > >>>> 512B, or 4KB) IO, so introduce one flag to decide if this bio includes
> > > > > >>>> multiple page. And only consider to try splitting this bio in case
> > > > > >>>> that the multiple page flag is set.
> > > > > >>>
> > > > > >>> So, back in the day I had an alternative approach in mind: get rid of
> > > > > >>> blk_queue_split entirely, by pushing splitting down to the request layer - when
> > > > > >>> we map the bio/request to sgl, just have it map as much as will fit in the sgl
> > > > > >>> and if it doesn't entirely fit bump bi_remaining and leave it on the request
> > > > > >>> queue.
> > > > > >>>
> > > > > >>> This would mean there'd be no need for counting segments at all, and would cut a
> > > > > >>> fair amount of code out of the io path.
> > > > > >>
> > > > > >> I thought about that to, but it will take a lot more effort.  Mostly
> > > > > >> because md/dm heavily rely on splitting as well.  I still think it is
> > > > > >> worthwhile, it will just take a significant amount of time and we
> > > > > >> should have the quick improvement now.
> > > > > > 
> > > > > > We can do it one driver at a time - driver sets a flag to disable
> > > > > > blk_queue_split(). Obvious one to do first would be nvme since that's where it
> > > > > > shows up the most.
> > > > > > 
> > > > > > And md/md do splitting internally, but I'm not so sure they need
> > > > > > blk_queue_split().
> > > > > 
> > > > > I'm a big proponent of doing something like that instead, but it is a
> > > > > lot of work. I absolutely hate the splitting we're doing now, even
> > > > > though the original "let's work as hard as we add add page time to get
> > > > > things right" was pretty abysmal as well.
> > > > 
> > > > Last I looked I don't think it was going to be that bad, just needed a bit of
> > > > finesse. We just need to be able to partially process a request in e.g.
> > > > nvme_map_data(), and blk_rq_map_sg() needs to be modified to only map as much as
> > > > will fit instead of popping an assertion.
> > > 
> > > I think it may not be doable.
> > > 
> > > blk_rq_map_sg() is called by drivers and has to work on single request, however
> > > more requests have to be involved if we delay the splitting to blk_rq_map_sg().
> > > Cause splitting means that two bios can't be submitted in single IO request.
> > 
> > Of course it's doable, do I have to show you how?
> 
> No, you don't have to, could you just point out where my above words is wrong?

blk_rq_map_sg() _currently_ works on a single request, but as I said from the
start that this would involve changing it to only process as much of a request
as would fit on an sglist.

Drivers will have to be modified, but the changes to driver code should be
pretty easy. What will be slightly trickier will be changing blk-mq to handle
requests that are only partially completed; that will be harder than it would
have been before blk-mq, since the old request queue code used to handle
partially completed requests - not much work would have to be done that code.

I'm not very familiar with the blk-mq code, so Jens would be better qualified to
say how best to change that code. The basic idea would probably be the same as
how bios how have a refcount - bi_remaining - to track splits/completions. If
requests (in blk-mq land) don't have such a refcount (they don't appear to), it
will have to be added.

From a quick glance, blk_mq_complete_request() is where the refcount put will
have to be added. I haven't found where requests are popped off the request
queue in blk-mq land yet - the code will have to be changed to only do that once
the request has been fully mapped and submitted by the driver.

