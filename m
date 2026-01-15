Return-Path: <linux-bcache+bounces-1375-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FCED23A4B
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 10:41:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F28BA30ADD6B
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 09:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11A7A37F735;
	Thu, 15 Jan 2026 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lIWJs11J"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71835E52A;
	Thu, 15 Jan 2026 09:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768469351; cv=none; b=C41PTFPFrtcNOICIYLVlBFovk+abZdiREI0YNppoYZL2E1Qe2WdOk5ITxe+8ciRrAZo1MpK/lK+0ah/RhVGjOJLKYOn7Oh8iMTe2WllKKLg8NrxxCnGGMvXqmigRjMy4RHOZkR0kRoNyZhBQAv6kBRN4cNv+TqopjrC0zeG4XHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768469351; c=relaxed/simple;
	bh=o9Gz+RZZWm2w7WoZX+ucm7uTF6JtyzU7YNS/4s66CCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jv+W24rNPeaYPLxu6NP3V8IfDDQ683irmKAkd8beBpePHHI6qMdBhb79prUTokHoCh2wKt4G8CiJMjS+FmiKb9Tcjzxl6nuVzf7YCL9P4cB8PbYLieyxKpu5gCdOChX+S6giyytPpQcP6RIvGeg2ZRJXQxKc9LmLsZ+5ykXeGi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lIWJs11J; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 04:28:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768469345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AO4Ucko5piKblYopiPozNqTsmotIMbDXXIqqFyLYBe4=;
	b=lIWJs11Jo6gFv9b+JUuWe+ydJGgKp3xk7KsxmKqe0x9IKd0r4oAAmMsaTuFkNrDfD3DjIk
	k4UgpWY0e82udPMXi4UGr/x2FDXtZOMeSraDqqCyhV/TBxwDcGJoPRWUI8YmtTRNgTEPxm
	zoLyyHtU/iYhGq5oTQDYkAC+SsS3xOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: colyli@fnnas.com, axboe@kernel.dk, sashal@kernel.org, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, zhangshida@kylinos.cn, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aWiyx-tXTp81yfBx@moria.home.lan>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
 <aWiqMzQ9PIWFfyfP@moria.home.lan>
 <CANubcdXk5BHTJL+5J8n80r6O7pyhF0qOhEXBgvYo_UY_iUQYgg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdXk5BHTJL+5J8n80r6O7pyhF0qOhEXBgvYo_UY_iUQYgg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 05:17:39PM +0800, Stephen Zhang wrote:
> Kent Overstreet <kent.overstreet@linux.dev> 于2026年1月15日周四 16:59写道：
> >
> > On Thu, Jan 15, 2026 at 04:06:53PM +0800, Stephen Zhang wrote:
> > > zhangshida <starzhangzsd@gmail.com> 于2026年1月15日周四 15:48写道：
> > > >
> > > > From: Shida Zhang <zhangshida@kylinos.cn>
> > > >
> > > > Commit 53280e398471 ("bcache: fix improper use of bi_end_io") attempted
> > > > to fix up bio completions by replacing manual bi_end_io calls with
> > > > bio_endio(). However, it introduced a double-completion bug in the
> > > > detached_dev path.
> > > >
> > > > In a normal completion path, the call stack is:
> > > >    blk_update_request
> > > >      bio_endio(bio)
> > > >        bio->bi_end_io(bio) -> detached_dev_end_io
> > > >          bio_endio(bio)    <- BUG: second call
> > > >
> > > > To fix this, detached_dev_end_io() must manually call the next completion
> > > > handler in the chain.
> > > >
> > > > However, in detached_dev_do_request(), if a discard is unsupported, the
> > > > bio is rejected before being submitted to the lower level. In this case,
> > > > we can use the standard bio_endio().
> > > >
> > > >    detached_dev_do_request
> > > >      bio_endio(bio)        <- Correct: starts completion for
> > > >                                 unsubmitted bio
> > > >
> > > > Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> > > > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > > > ---
> > > >  drivers/md/bcache/request.c | 11 +++++++++--
> > > >  1 file changed, 9 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > > > index 82fdea7dea7..ec712b5879f 100644
> > > > --- a/drivers/md/bcache/request.c
> > > > +++ b/drivers/md/bcache/request.c
> > > > @@ -1104,7 +1104,14 @@ static void detached_dev_end_io(struct bio *bio)
> > > >         }
> > > >
> > > >         kfree(ddip);
> > > > -       bio_endio(bio);
> > > > +       /*
> > > > +        * This is an exception where bio_endio() cannot be used.
> > > > +        * We are already called from within a bio_endio() stack;
> > > > +        * calling it again here would result in a double-completion
> > > > +        * (decrementing bi_remaining twice). We must call the
> > > > +        * original completion routine directly.
> > > > +        */
> > > > +       bio->bi_end_io(bio);
> > > >  }
> > > >
> > > >  static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> > > > @@ -1136,7 +1143,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> > > >
> > > >         if ((bio_op(bio) == REQ_OP_DISCARD) &&
> > > >             !bdev_max_discard_sectors(dc->bdev))
> > > > -               detached_dev_end_io(bio);
> > > > +               bio_endio(bio);
> > > >         else
> > > >                 submit_bio_noacct(bio);
> > > >  }
> > > > --
> > > > 2.34.1
> > > >
> > >
> > > Hi,
> > >
> > > My apologies for the late reply due to a delay in checking my working inbox.
> > > I see the issue mentioned in:
> > > https://lore.kernel.org/all/aWU2mO5v6RezmIpZ@moria.home.lan/
> > > this was indeed an oversight on my part.
> > >
> > > To resolve this quickly, I've prepared a direct fix for the
> > > double-completion bug.
> > > I hope this is better than a full revert.
> >
> > In general, it's just safer, simpler and saner to revert, reverting a
> > patch is not something to be avoided. If there's _any_ new trickyness
> > required in the fix, it's better to just revert than rush things.
> >
> > I revert or kick patches out - including my own - all the time.
> >
> > That said, this patch is good, you've got a comment explaining what's
> > going on. Christoph's version of just always cloning the bio is
> > definitely cleaner, but that's a bigger change,
> 
> Thank you for the feedback.
> 
> I sincerely hope that Christoph's version can resolve this issue properly, and
> that it helps remedy the regression I introduced. I appreciate everyone's
> patience and the efforts to address this.
> 
> Let me know if there's anything further needed from my side.

Thanks for being attentive, no worries about any of it.

It looks like from your patch there was an actual bug you were trying to
fix - bio_endio() not being called at all in this case

> > > >         if ((bio_op(bio) == REQ_OP_DISCARD) &&
> > > >             !bdev_max_discard_sectors(dc->bdev))

That would have been good to highlight up front.

