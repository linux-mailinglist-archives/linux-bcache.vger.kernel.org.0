Return-Path: <linux-bcache+bounces-1381-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B34D3A1A9
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 09:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B430D302B756
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 08:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2F7D33D6D2;
	Mon, 19 Jan 2026 08:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ORgZQxqc"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3E333CE8C;
	Mon, 19 Jan 2026 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768811396; cv=none; b=aULNACNtzRapziTxl7ZxLfm8uqHB/H06wU2vHbUDRw8gJdFuEZNPtx4czVvSPwgWNIThpTPa5C77Eh7RWagbyiex0rO/YYul3K1po1IS5xfohnQ/CtZ1a5nExdGq7UpOSteXKBNnQjF7GEPp0CDpV4EdR2Yatap0s2lcfVW/K5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768811396; c=relaxed/simple;
	bh=y/6u3raTbnyNPQ380AwhoORROheeIZLwXc9j5gCuFD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s80PbPjov+/VTjWOoTrTfZCO0NqGLK2Wm/PM+9ht19JthQm9EygR4pSzeFD3TmPzfHB/LRz1PkZPuRbXh1fDhkaQArekqBB0zxp+Dv/DiL4XIvZCYA8pzbgQklBlvVtH4in0rZPf94CkNcRNQ99rVY+g3QcPSE1SczBS3Wz4s4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ORgZQxqc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I2FtSZUqqP0Bd1aHdDm5D7gWOQeBTLgsbHrZOO6/nsY=; b=ORgZQxqcQly2I5CgN8AFnTXdsr
	bzs6/CyfWHv43maJfElg9R66+etJjCF/+myaPqZ3+j1S866pOmXI/g7SwmMh/mn+ayXiljAtPS/UD
	n7QKYvAaCHhowJecCoeoXpeyTEVRYHkJdC9tctZjTJknNsj5a3bs/iF0JBzraSkqc3ryt/K/iSjMb
	S19jqI0llTpgd1Ygx259uzn/+T2D+VUbctMLvPfjWVVzVT7BLvOVysiJp0Txn25TZnaBy3GoOFB8K
	c8LIkRCBcP60wwe4nJwqCVMYyz7cCaCfnHdBFPcjpL/etK9drGuOgmk+9Yk/a61OAUFTCsTCh5fwX
	iN2uTC+Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhkdw-00000001Z4X-2mYh;
	Mon, 19 Jan 2026 08:29:48 +0000
Date: Mon, 19 Jan 2026 00:29:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>, kent.overstreet@linux.dev,
	axboe@kernel.dk, sashal@kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aW3rfPoloviR1Rp9@infradead.org>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
 <aWilW0RKQiHJzpsZ@infradead.org>
 <aWzIU3ASp139lHNz@studio.local>
 <aW3Sq4H_OosPVaNe@infradead.org>
 <aW3nzb2lOSVSbqQZ@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW3nzb2lOSVSbqQZ@studio.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jan 19, 2026 at 04:19:38PM +0800, Coly Li wrote:
> Before I work on it, I want to know the author already ran and tested the
> patch firstly. Normally I won't test any patches posted on mailing list.

Without a published test suite that can be used for that, that is a very
high demand.  Maintainers of code that can't easily be tested by a
drive by contributor (or contributor to the parent subsystems for that
matter) need to help with testing, otherwise we would not get anything
done in the kernel.


