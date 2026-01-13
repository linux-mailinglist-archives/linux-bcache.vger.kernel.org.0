Return-Path: <linux-bcache+bounces-1367-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 27A7FD1A439
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 17:30:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B51D30A0D81
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0B32F0692;
	Tue, 13 Jan 2026 16:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BEcvThoG"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A22D8797;
	Tue, 13 Jan 2026 16:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321504; cv=none; b=kGVK8mgm19xUD/FjcHJixjcyrJi+OWJy93VY7+mQruipYomJzkcifQdiUZZDazlqcemRobuhHn1Bh93j61OCHYO6y8flRol5Ze0A/iGSAV+fbXojJjqNYmL+4gTXkkPTiW0ke+SNxre+SjSAsE97m6Kcho2CUmYOYcZPlgSf98Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321504; c=relaxed/simple;
	bh=wUyLeBCCLDGxivvphknD7EYwCae2RETgOnJub7pPSoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XCBlA2xCJK1t+BX2uzRXQpLq2GVLFNIUzwb7wUGKmS566nzo25Dmn5GbbWIHLxk+yvdwry9k/aDhOrngSgxMATxaCahY+ex+QyC+W3JOrcgBwOdKNiZQoIUZ/ZMCiqOrFtSHEyQp+qfXfO0YJdt0MxDqXmiXBiISeDy4Qeo5Y/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BEcvThoG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zKsoLPTGK+s4PIa5qVRS8valtMMH5EF9UiMcXJVcEPE=; b=BEcvThoGyjqdRlRQb/ev5qF9kr
	YT1C+2ihBBbaZfYIm2U1rQwTCAgzNcERlBedSiObJTcZqJJrs3BC+8B2tIlKnhLPimkPaF569wBo9
	vMYP8XSGcVxnOXOeJsWHaBPywIV+EZ+RJIGZHkbuLe5TKdXVqqAUX60xnZebTp4Lnc1rmX70VjA63
	VpmGj3ojueRF8PfSceEkVUfJPTPAICsQISiHuA05he88jbXd7xpgtuhDN+FMvSxvyJ6B7dQ4UjCTO
	SuaOaZy+C92mNXLYNngP55qj3gwhm0GjdHhkWSJABlMC4QL8gCFq0Cz0Cz2ScNH741Quw2LWqVWu1
	Wb4M+2Qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfhCX-00000007T0Q-2Snb;
	Tue, 13 Jan 2026 16:25:01 +0000
Date: Tue, 13 Jan 2026 08:25:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	Shida Zhang <zhangshida@kylinos.cn>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWZx3R_02TDgMCPU@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWZwlE0JdtEvhh9g@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZwlE0JdtEvhh9g@studio.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 14, 2026 at 12:22:56AM +0800, Coly Li wrote:
> On Tue, Jan 13, 2026 at 12:07:54AM +0800, Christoph Hellwig wrote:
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
> > 
> 
> The discussion happens in stable mailing list. Also I admitted my fault.
> Though I didn't ack commit 53280e398471 ("bcache: fix improper use of
> bi_end_io"), I read it and overlooked the bio_endio() duplicated entry
> issue.

Please try to document the rationale in the commit logs, the current
one was extremely vague.

