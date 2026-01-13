Return-Path: <linux-bcache+bounces-1360-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D5595D1756F
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 09:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 635A13016989
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 08:39:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0C2A350A0C;
	Tue, 13 Jan 2026 08:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ed7lBI7H"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E0B192B75
	for <linux-bcache@vger.kernel.org>; Tue, 13 Jan 2026 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768293587; cv=none; b=b8cuAZP/SB0MVGsJ9CYjHaSXJq1gpfvPK3fQFpo2ZHh2wgGapXFDWgsC72Z3qZ+OJINz3bYknbNB3TqiKe6tYGlLegPIjc7oiIgL+GfXsrxvBt9i0YWHezP97ynYkKZJq/OWZ7WzzvTaw97rXt3aYQhYcr6ZqGC74m5hH54iAwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768293587; c=relaxed/simple;
	bh=BA88x97kqUmJHsPc+12k+uT4uVmLRUqR7sLwJSb614w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kkrFr21VUGxoaI8kge9cK4HxvNxhRAAUF7Hgj6D7UbHeiaEs/vaAT+YK/IAQKL1DCObz+XNMXjbzGLpk/VskwfDjvg/SXPjGaxB20j/ik+Er9bjPj8b5Aziyt0kwZWVAkYeqGrk25aj5ViMRjYq4LyDulyhoEjX2fIivFqzEhPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ed7lBI7H; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 13 Jan 2026 03:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768293574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tCDnnkIFyZ1T2qgQ+HYmx6ua8y8oRnGOcsQeyAg1oPs=;
	b=Ed7lBI7HJGvBGZvq2V+Q3HCknd8V7r341BGYprndkCfCY8PFb5eQzPUp7OhKrKLpzlspQO
	eXIWzv0rVJu7xF5q7Amc8st1WQRYcI+76ch8eKm+esYoDeMBvNq0X9FrFbCqU7u2ukJ2dR
	TC0NmXqKD2+tRColfnDpSGLOaGjXnMI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: colyli@fnnas.com, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWYDySBBmQ01JQOk@moria.home.lan>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYDnKOdpT6gwL5b@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 13, 2026 at 12:34:36AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 03:30:41AM -0500, Kent Overstreet wrote:
> > On Tue, Jan 13, 2026 at 12:07:54AM -0800, Christoph Hellwig wrote:
> > > On Tue, Jan 13, 2026 at 02:09:39PM +0800, colyli@fnnas.com wrote:
> > > > From: Coly Li <colyli@fnnas.com>
> > > > 
> > > > This reverts commit 53280e398471f0bddbb17b798a63d41264651325.
> > > > 
> > > > The above commit tries to address the race in bio chain handling,
> > > > but it seems in detached_dev_end_io() simply using bio_endio() to
> > > > replace bio->bi_end_io() may introduce potential regression.
> > > > 
> > > > This patch revert the commit, let's wait for better fix from Shida.
> > > 
> > > That's a pretty vague commit message for reverting a clear API
> > > violation that has caused trouble.  What is the story here?
> > 
> > Christoph, you can't call bio_endio() on the same bio twice. You should
> > know this. Calling a bare bi_end_io function is the correct thing to do
> > when we're getting called from bio_endio().
> 
> Hi Kent,
> 
> indeed, calling bio_endio() twice is a very bad idea.  Nothing in the
> quoted commit log indicates that is the case, though.  If that is
> the problem it needs to be fixed, but calling ->bi_end_io directly
> is not the proper fix either.  That's eaxtly why I'm asking for the
> story behind this.

No. The original (buggy) patch has your name on it in the suggested-by,
you should have done your homework.

This almost made it into a bunch of stable releases, where it would have
exploded as soon as it hit actual users, and I would've gotten some of
those bug reports.

You need to reexamine your priorities here.

