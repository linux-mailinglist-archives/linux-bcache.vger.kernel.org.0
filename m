Return-Path: <linux-bcache+bounces-1359-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6616ED17554
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 09:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3A42F300B81F
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 08:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C112C37FF72;
	Tue, 13 Jan 2026 08:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gk7HkGXS"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4AF29BD8C;
	Tue, 13 Jan 2026 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768293284; cv=none; b=fcf7e6h4swVXLgS6cBaQazJgZfae1EwwxLp0eGk1f4dMN/VIiQ7msQ9XYPW/pdApUiuiVq73970Z0wcShaglPSATqgEcDppWjy9bX9ZUdCE/+6gGI0/2lxggtTiak6QoT6xiPOxNYJSxwEBO2f53pzpW8e4vOm4Uhc4jFI5NkU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768293284; c=relaxed/simple;
	bh=4mcNSbWlbsSlg1szWGC+CXFT/TWeMvBO2wVw8k/2Htc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kugYCxxZlp9syuetT0Ev4A7QWffZjV5xf1E92ErRUbuLLEtesyiUmm56i3euw3vsfx4zL9WwEmHtPtQHHHD1r6yLaMLfoAduHx1lX2c8bfj7dZMmzYtVnEPs59dGJL+I5HnPG8cGTJdxOiIU50mvo/JSn6F+Atm7Mk/I0c9dR6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gk7HkGXS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=E2cvGxwegAVeZQrrxZoBwBBP9+7aMbuFt+NWpUf27hY=; b=Gk7HkGXSuPRyFEK1dM8GEeDbPg
	ELOP95JWI7bpiB5K49Q398QGVPnVo+79J1oONXpkeWW9cMYyIlJEzEma+C3ZyVibIMqi8GqNDVLII
	Bo27Ql9Apao9IQmID+E6HN2qCAcGTOyN+BOVkBSLYGGYZmX0bCJX8tL65SATeoXltcmJ5q9ELIzqI
	Qe8HbTqIo/C/gCfRNIddWRO1pbKp+7lf3O97UGo+SWGXL/7yRrJCpfFqkP7JIJ7twkO5pCWmWWI23
	zxFuXEjKJLMvFnZU2cg/5FHBXqB3SKRjGtgO7Rp1WpJamJ0VntIS0BWu+R51Q7gt7qu2ogTJRKUri
	hzi+GMGw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfZrI-00000006lIX-1KWu;
	Tue, 13 Jan 2026 08:34:36 +0000
Date: Tue, 13 Jan 2026 00:34:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, colyli@fnnas.com,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWYDnKOdpT6gwL5b@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYCe-MJKFaS__vi@moria.home.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 13, 2026 at 03:30:41AM -0500, Kent Overstreet wrote:
> On Tue, Jan 13, 2026 at 12:07:54AM -0800, Christoph Hellwig wrote:
> > On Tue, Jan 13, 2026 at 02:09:39PM +0800, colyli@fnnas.com wrote:
> > > From: Coly Li <colyli@fnnas.com>
> > > 
> > > This reverts commit 53280e398471f0bddbb17b798a63d41264651325.
> > > 
> > > The above commit tries to address the race in bio chain handling,
> > > but it seems in detached_dev_end_io() simply using bio_endio() to
> > > replace bio->bi_end_io() may introduce potential regression.
> > > 
> > > This patch revert the commit, let's wait for better fix from Shida.
> > 
> > That's a pretty vague commit message for reverting a clear API
> > violation that has caused trouble.  What is the story here?
> 
> Christoph, you can't call bio_endio() on the same bio twice. You should
> know this. Calling a bare bi_end_io function is the correct thing to do
> when we're getting called from bio_endio().

Hi Kent,

indeed, calling bio_endio() twice is a very bad idea.  Nothing in the
quoted commit log indicates that is the case, though.  If that is
the problem it needs to be fixed, but calling ->bi_end_io directly
is not the proper fix either.  That's eaxtly why I'm asking for the
story behind this.

