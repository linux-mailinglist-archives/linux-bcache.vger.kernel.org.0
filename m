Return-Path: <linux-bcache+bounces-1379-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC9CD3A0F0
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 09:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D212B300B8AD
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 08:04:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BFD33AD9C;
	Mon, 19 Jan 2026 08:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zjd7Pefc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722A733AD9B;
	Mon, 19 Jan 2026 08:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768809856; cv=none; b=cfslvgbzeYUWkOeVJjH/dTbveR32//pAAxD3VKZoY4FEJW03R6p9vceBne/th4ucOnpEiHDNXb71IT4cfRgALm25IMOiHVRlwGP0Ew1Pt9zel5hji+2nV2P2cw+2HBFXMZD/OZegC1wS2cDQpYLQdKfza/U00SngTtbww82BkN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768809856; c=relaxed/simple;
	bh=Nb3zxS1fLYcd16TEF34S6HQVfMA0Y6uzSG1OOhQSLPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lv5hFpqotIIsxh2KB1h4RNk9WNTWonGhd4oV8gSuiJK5mOfHDREcYeriQVzdZqTtUvO8DuHv9eQVRCdFZD8sf+AgpxtI3qbjbC0Bp4YC6zkEO/lKtBgUJgTneinAocdc1Ww/Uh0nwfz6fUM5fL4b4BRpEgVzUB+olK+RQ2GLkxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zjd7Pefc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r5OeJh2vs9qFWQcv1LcfWtuYiD0p1l2KTwHsQCaPpPI=; b=zjd7PefcUsapvP31QJWfBHdFnX
	IltV2C6YpO55fBG8iIqyXg6ep7wRCq2Zr2P2PIYgadm0GkVMQabn+a1IhMbeAytrf1veIpeG8Lh6S
	73MkhMhqH15c75b+QtotwCO2YLlXFsnkOiRwCaJ1KJBwHzCBEv6g9twbnZg9ds0zcz1yioK3GqqKF
	LPEKp/UXt8ui//M0eTDuhP1bN1ri6TQlY9sTOtr8PlkFdXWoH+zwEaoj4DYbOowtHUSzKZHOS7vsd
	iveNFgdCzCYxPuGsVTXMU3e1DzYekdfR6X6VrqPIjWXH2TACxi8Lv/ebMJchlo+i9oE7YggYjW9N5
	aot/7ejQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhkF4-00000001XFu-3mO0;
	Mon, 19 Jan 2026 08:04:06 +0000
Date: Mon, 19 Jan 2026 00:04:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Coly Li <colyli@fnnas.com>, Christoph Hellwig <hch@infradead.org>,
	kent.overstreet@linux.dev, axboe@kernel.dk, sashal@kernel.org,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aW3ldtLV_IwIj9QR@infradead.org>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
 <aWilW0RKQiHJzpsZ@infradead.org>
 <aWzIU3ASp139lHNz@studio.local>
 <CANubcdWajHf_vJQpcsmLvU8U=Vd9Q2=9E4_mpncRy2A0iiMnWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdWajHf_vJQpcsmLvU8U=Vd9Q2=9E4_mpncRy2A0iiMnWQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 02:53:53PM +0800, Stephen Zhang wrote:
> > >       if (bio->bi_status) {
> > > -             struct cached_dev *dc = container_of(ddip->d,
> > > -                                                  struct cached_dev, disk);
> > > +             struct cached_dev *dc = bio->bi_private;
> > > +
> > >               /* should count I/O error for backing device here */
> > >               bch_count_backing_io_errors(dc, bio);
> > > +             orig_bio->bi_status = bio->bi_status;
> > >       }
> > >
> 
> bio_init_clone must be paired with a bio_uninit() call before the
> memory is freed?

Yes.  At least if you don't want leaks when using blk-group.

But as stated in my initial mail, as far as I can tell this path really
needs a bio_set to avoid spurious failures under memory pressure.  In
which case we'd then do a bio_put in the end_io path.


