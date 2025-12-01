Return-Path: <linux-bcache+bounces-1318-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BD3CC96E97
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 12:28:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 96097346AA0
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 11:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AB9308F1A;
	Mon,  1 Dec 2025 11:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w7uo8zdg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1923F3081AD;
	Mon,  1 Dec 2025 11:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588339; cv=none; b=D5s9YJY21b4gjV8yZ9d7eaRCDbejBH4ZVTG7T5gNx3V4yBw2AGnCog++ogDGN+QClAgJ/waX+ADAPQW+6gs7ao4EMC4pQGn6KIYmsOMpBVmjr1ipPaaIAPVmevFSStPuZbdBhq2CnozrYEsFT9DiSpitg8mPy0bM1XJOqiOfzw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588339; c=relaxed/simple;
	bh=s19EOy30cEcBtMemUITSn4C/LT7eo37QaXAmU0cRH1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTlmKtos//KHVfLuig5s4gJ0n6PzIawhH9IG8lix5KOJUeciTRFrUnMEgwVib9irP99vD+aFTU3km99O3poDUay+aaj+7v3+dVXoGIskZPn94EaX5Laxryvy2NT8ZmbWJhzf7QIJMBLe/+nUq2od5f4i8Uubrny4goU8b7tMrFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w7uo8zdg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mRwi5qsvlBCY7/vxWvMEmaxU1iW6+CdG65HdlqeXj+o=; b=w7uo8zdg+Vxz9CT6WFdpN6Xczb
	5bjMMxRiC8jZvKZ1oxNmZ/fRrvFBcmvJJuMzlRuJDOBcwggzLWoTahuTU2HYlTE4Y2th16WBHc8x0
	MR2hrNGl4zDArJ0AqRTXhb+6Kucqzy+nxhxphkL3Ozpm3t4Q9zmbnGpHysPtJP1VzWFKzpDsd/UZh
	R5z0tAFDAYx0zWNJ+Z9Xz4rVyy1pw+OOeF0UmKLPZ5OnvqMvT4Couo4GPXXqO7VZ1QGSPtmnpTtXO
	ESzk95uEAH2u+LXDoonsOMCcfQYRw3tfpHaVSXjrZnXBsNiagJhnia9KI8cDqs9w7ftsq17TPaIZI
	pcihecXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQ228-00000003SYE-3opa;
	Mon, 01 Dec 2025 11:25:32 +0000
Date: Mon, 1 Dec 2025 03:25:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
	hch@infradead.org, ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, colyli@fnnas.com,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 3/3] block: prevent race condition on bi_status in
 __bio_chain_endio
Message-ID: <aS17LOwklgbzNhJY@infradead.org>
References: <20251201090442.2707362-1-zhangshida@kylinos.cn>
 <20251201090442.2707362-4-zhangshida@kylinos.cn>
 <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU4o8Wv+6TQti4NZJRUQpGF9RWqiN9fO6j55p4xgysM_3g@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 01, 2025 at 11:22:32AM +0100, Andreas Gruenbacher wrote:
> > -       if (bio->bi_status && !parent->bi_status)
> > -               parent->bi_status = bio->bi_status;
> > +       if (bio->bi_status)
> > +               cmpxchg(&parent->bi_status, 0, bio->bi_status);
> 
> Hmm. I don't think cmpxchg() actually is of any value here: for all
> the chained bios, bi_status is initialized to 0, and it is only set
> again (to a non-0 value) when a failure occurs. When there are
> multiple failures, we only need to make sure that one of those
> failures is eventually reported, but for that, a simple assignment is
> enough here.

A simple assignment doesn't guarantee atomicy.  It also overrides
earlier with later status codes, which might not be desirable.


