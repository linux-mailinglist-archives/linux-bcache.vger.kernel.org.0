Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35E2173A091
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 14:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjFVMLh (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 08:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjFVMLg (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 08:11:36 -0400
X-Greylist: delayed 338 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 22 Jun 2023 05:11:35 PDT
Received: from out-22.mta1.migadu.com (out-22.mta1.migadu.com [IPv6:2001:41d0:203:375::16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE31171C
        for <linux-bcache@vger.kernel.org>; Thu, 22 Jun 2023 05:11:35 -0700 (PDT)
Date:   Thu, 22 Jun 2023 08:05:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687435554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8rkUE/aSRyT8xu6gUyTqZ5g8F1UXBLPAhf4NAP3fQPE=;
        b=niJeKL6y9h5TeHJg/SL0zW7OUBQWU2DEhPX1GMwiw6076qgI1yyf+AHfwOb4SO7Tjt0mdH
        ECmj8rWFLG5agAfS1BpbNQqSJX4uCE7/RSYng2Eey6FMXSzmIw1xigZyyoh2Dv8+8Vy46d
        RKuH8QJdNPaawLM1GFW9M2ZqbLYAljA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] bcache: Alloc holder object before async registration
Message-ID: <20230622120548.molmqze2whj7ykj5@moria.home.lan>
References: <20230621162024.29310-1-jack@suse.cz>
 <20230621162333.30027-1-jack@suse.cz>
 <20230621175659.ugkaawkuanlzt736@moria.home.lan>
 <20230622100954.6vx7725huqngbubb@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230622100954.6vx7725huqngbubb@quack3>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Thu, Jun 22, 2023 at 12:09:54PM +0200, Jan Kara wrote:
> On Wed 21-06-23 13:56:59, Kent Overstreet wrote:
> > On Wed, Jun 21, 2023 at 06:23:26PM +0200, Jan Kara wrote:
> > > Allocate holder object (cache or cached_dev) before offloading the
> > > rest of the startup to async work. This will allow us to open the block
> > > block device with proper holder.
> > 
> > This is a pretty big change for this fix, and we'd want to retest the
> > error paths - that's hard to do, because the fault injection framework I
> > was using for that never made it upstream.
> 
> I agree those are somewhat difficult to test. Although with memory
> allocation error injection, we can easily simulate failures in
> alloc_holder_object() or say later in bcache_device_init() if that's what
> you're after to give at least some testing to the error paths. Admittedly,
> I've just tested that registering and unregistering bcache devices works
> without giving warnings. Or are you more worried about the "reopen the
> block device" logic (and error handling) in the second patch?

All error paths need to be tested, yeah.

> > What about just exposing a proper API for changing the holder? Wouldn't
> > that be simpler?
> 
> It would be doable but frankly I'd prefer to avoid implementing the API for
> changing the holder just for bcache. For all I care bcache can also just
> generate random cookie (or an id from IDA) and pass it as a holder to
> blkdev_get_by_dev(). It would do the job as well and we then don't have to
> play games with changing the holder. It would just need to be propagated to
> the places doing blkdev_put(). Do you find that better?

Well, looking over the code it doesn't seem like it would really
simplify the fix, unfortunately.

bcachefs has the same issue, but in bcachefs we've already got a handle
object where we can allocate and stash a holder - analagous to the
bdev_handle you're working on.

> I'm now working on a changes that will make blkdev_get_by_dev() return
> bdev_handle (which contains bdev pointer but also other stuff we need to
> propagate to blkdev_put()) so when that is done, the cookie propagation
> will happen automatically.

bdev_handle definitely sounds like the right direction.

Just changing the holder really seems like it should be easiest to me,
and it can get deleted after bdev_handle lands, but maybe there's a new
wrinkle I'm not aware of?

Anyways, as the error paths get tested I'm ok with this patchset - it's
fine if it's done completely by hand (you can just add a goto fail in
the appropriate place and make sure nothing explodes).

Coli - we should talk about testing at some point. I've been working on
test infrastructure; it would be great to get the bcache tests in ktest
updated, I've now got a CI we could point at those tests.

Christoph - you really gotta start CCing people properly, the patch that
broke this didn't even it linux-bcache. No bueno.
