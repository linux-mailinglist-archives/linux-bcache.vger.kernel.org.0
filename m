Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4BD739E0A
	for <lists+linux-bcache@lfdr.de>; Thu, 22 Jun 2023 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbjFVKJ6 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 22 Jun 2023 06:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjFVKJ5 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 22 Jun 2023 06:09:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2C1D3;
        Thu, 22 Jun 2023 03:09:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 26D3D2049A;
        Thu, 22 Jun 2023 10:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1687428595; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XRh+EIjE4fnCqVrMHw/oIS85+pMkZumnneIk0Hlcjx0=;
        b=ci+uh+IzwjDjXiI4b59HDAStIJA9l4prA8H9fBxpXcVwzjOmatUkwd3rIMr9yEYuK/SM0J
        Sahp1hC4vMHLRGLOUjcSbK6E9JvW/OpC4JE8jRjaRHpQ4FeugsmtS9mIHMsAgzLgx064CW
        Zmgsr1loDIfNPt1lnmbEAK+I3j+Rcfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1687428595;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XRh+EIjE4fnCqVrMHw/oIS85+pMkZumnneIk0Hlcjx0=;
        b=/Zl7yQ8RHzezxHTjIOJJBJysyjKJ4t7KvTuARM1lj5nCQkKgj91I7RUwpoETdoOETtx6n+
        m6HCnvEm/UsqD1Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 18BBA13905;
        Thu, 22 Jun 2023 10:09:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fJ4EBvMdlGTFNgAAMHmgww
        (envelope-from <jack@suse.cz>); Thu, 22 Jun 2023 10:09:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id A2A7EA075D; Thu, 22 Jun 2023 12:09:54 +0200 (CEST)
Date:   Thu, 22 Jun 2023 12:09:54 +0200
From:   Jan Kara <jack@suse.cz>
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org
Subject: Re: [PATCH 1/2] bcache: Alloc holder object before async registration
Message-ID: <20230622100954.6vx7725huqngbubb@quack3>
References: <20230621162024.29310-1-jack@suse.cz>
 <20230621162333.30027-1-jack@suse.cz>
 <20230621175659.ugkaawkuanlzt736@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230621175659.ugkaawkuanlzt736@moria.home.lan>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed 21-06-23 13:56:59, Kent Overstreet wrote:
> On Wed, Jun 21, 2023 at 06:23:26PM +0200, Jan Kara wrote:
> > Allocate holder object (cache or cached_dev) before offloading the
> > rest of the startup to async work. This will allow us to open the block
> > block device with proper holder.
> 
> This is a pretty big change for this fix, and we'd want to retest the
> error paths - that's hard to do, because the fault injection framework I
> was using for that never made it upstream.

I agree those are somewhat difficult to test. Although with memory
allocation error injection, we can easily simulate failures in
alloc_holder_object() or say later in bcache_device_init() if that's what
you're after to give at least some testing to the error paths. Admittedly,
I've just tested that registering and unregistering bcache devices works
without giving warnings. Or are you more worried about the "reopen the
block device" logic (and error handling) in the second patch?

> What about just exposing a proper API for changing the holder? Wouldn't
> that be simpler?

It would be doable but frankly I'd prefer to avoid implementing the API for
changing the holder just for bcache. For all I care bcache can also just
generate random cookie (or an id from IDA) and pass it as a holder to
blkdev_get_by_dev(). It would do the job as well and we then don't have to
play games with changing the holder. It would just need to be propagated to
the places doing blkdev_put(). Do you find that better?

I'm now working on a changes that will make blkdev_get_by_dev() return
bdev_handle (which contains bdev pointer but also other stuff we need to
propagate to blkdev_put()) so when that is done, the cookie propagation
will happen automatically.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
