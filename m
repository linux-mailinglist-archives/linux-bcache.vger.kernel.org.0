Return-Path: <linux-bcache+bounces-1373-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D136D23534
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 10:01:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB914306529E
	for <lists+linux-bcache@lfdr.de>; Thu, 15 Jan 2026 08:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E3133EAE7;
	Thu, 15 Jan 2026 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y1Ff7YNJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DE626A1B9
	for <linux-bcache@vger.kernel.org>; Thu, 15 Jan 2026 08:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768467563; cv=none; b=seZjthP9h4b4KDCJSI3FdgIkPykjsq7mkjdyW5r7gkK8qRe1SXhBWHLwu5VdAMIQYxBJN/GYKc3/67aU8Amq4UzgHLQDcjhOwlgWpdkNLMAUp1CXSnudIwPB4NT3qBKs19regmWrjkebXdHC2q4WqPj5ZnaUQMKMqx4sj0L8Lns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768467563; c=relaxed/simple;
	bh=hzjj4i2y5JR0cCDsIa3Bt9P8vmHu/4z2zyLVlsBYWJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JSB2933fjlL1wXWwD/mBkRFv3GaILACTk2a8WqtivcPBlhbrTqqJvntrZEDFrQewbnmuJ833HpOf1RPe+XaW6t2Cjxw78midPm/uxef529vOIiDnhXCfJIBTfyEdxchKRpOxuZhsusTiUFfPpPl6i4lINOzSPqdUX7Pzd4u9J3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y1Ff7YNJ; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 03:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768467549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eXd6dImZzuejUm3joJ1/Mw8fwSDdGn59T33qhmdg8Vc=;
	b=Y1Ff7YNJXrirFn0I5hzbihp6AFjhdqxYh9CKzEZqv0nxT6VUbG2qAMeokGvFh0nS4cETPW
	cxYGdGLRpizyoPdMwMSQH7dAXcDJQOPpOaEu2mSyWKGJLYW6LjTnWubx0rLao/UaU2+iMX
	66E/DopYEUQ7Qbi0aogTLca9upjDqEA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: colyli@fnnas.com, axboe@kernel.dk, sashal@kernel.org, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aWiqMzQ9PIWFfyfP@moria.home.lan>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 15, 2026 at 04:06:53PM +0800, Stephen Zhang wrote:
> zhangshida <starzhangzsd@gmail.com> 于2026年1月15日周四 15:48写道：
> >
> > From: Shida Zhang <zhangshida@kylinos.cn>
> >
> > Commit 53280e398471 ("bcache: fix improper use of bi_end_io") attempted
> > to fix up bio completions by replacing manual bi_end_io calls with
> > bio_endio(). However, it introduced a double-completion bug in the
> > detached_dev path.
> >
> > In a normal completion path, the call stack is:
> >    blk_update_request
> >      bio_endio(bio)
> >        bio->bi_end_io(bio) -> detached_dev_end_io
> >          bio_endio(bio)    <- BUG: second call
> >
> > To fix this, detached_dev_end_io() must manually call the next completion
> > handler in the chain.
> >
> > However, in detached_dev_do_request(), if a discard is unsupported, the
> > bio is rejected before being submitted to the lower level. In this case,
> > we can use the standard bio_endio().
> >
> >    detached_dev_do_request
> >      bio_endio(bio)        <- Correct: starts completion for
> >                                 unsubmitted bio
> >
> > Fixes: 53280e398471 ("bcache: fix improper use of bi_end_io")
> > Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> > ---
> >  drivers/md/bcache/request.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> > index 82fdea7dea7..ec712b5879f 100644
> > --- a/drivers/md/bcache/request.c
> > +++ b/drivers/md/bcache/request.c
> > @@ -1104,7 +1104,14 @@ static void detached_dev_end_io(struct bio *bio)
> >         }
> >
> >         kfree(ddip);
> > -       bio_endio(bio);
> > +       /*
> > +        * This is an exception where bio_endio() cannot be used.
> > +        * We are already called from within a bio_endio() stack;
> > +        * calling it again here would result in a double-completion
> > +        * (decrementing bi_remaining twice). We must call the
> > +        * original completion routine directly.
> > +        */
> > +       bio->bi_end_io(bio);
> >  }
> >
> >  static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> > @@ -1136,7 +1143,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> >
> >         if ((bio_op(bio) == REQ_OP_DISCARD) &&
> >             !bdev_max_discard_sectors(dc->bdev))
> > -               detached_dev_end_io(bio);
> > +               bio_endio(bio);
> >         else
> >                 submit_bio_noacct(bio);
> >  }
> > --
> > 2.34.1
> >
> 
> Hi,
> 
> My apologies for the late reply due to a delay in checking my working inbox.
> I see the issue mentioned in:
> https://lore.kernel.org/all/aWU2mO5v6RezmIpZ@moria.home.lan/
> this was indeed an oversight on my part.
> 
> To resolve this quickly, I've prepared a direct fix for the
> double-completion bug.
> I hope this is better than a full revert.

In general, it's just safer, simpler and saner to revert, reverting a
patch is not something to be avoided. If there's _any_ new trickyness
required in the fix, it's better to just revert than rush things.

I revert or kick patches out - including my own - all the time.

That said, this patch is good, you've got a comment explaining what's
going on. Christoph's version of just always cloning the bio is
definitely cleaner, but that's a bigger change, 

