Return-Path: <linux-bcache+bounces-1357-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B51D17337
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 09:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EED730239F7
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 08:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A5F378D83;
	Tue, 13 Jan 2026 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CSfnMGjA"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062E1BC08F;
	Tue, 13 Jan 2026 08:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768291679; cv=none; b=n2gjQvtNGm2A1t9oQoIjxc0T9hzhczVHpd/y4OOPDq8q9ZKarmtOBkZs+2Cjna8l93FNif3UTBCJuOc/LP0mr04NL5ya/RxcOAE8Vp+7Yzhbit1oyt2xQhhCB7opwd8o9KSSKgWbExjE/E5/qdXhHZAh06zNQ3SMFJAJYW8T1m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768291679; c=relaxed/simple;
	bh=Jttjp4llnqNKqLNVBlQxRNNc6Nl3d3UJjfoHesdvHvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a8Z2JNT6QVnlzvpoyiehdBimvJ49BGDQVZcL/dec/TaiLuLXpCgxdzzEIZg6P6GicVEGFfM6oqjC6LGplNfSSF7KPGOuTw10xyVhLnG36ReTau1S+nt3qJX/E6Oxg+TwdpJzbDfs8kMO4902Y4sca8JFtwLV9L8xWtZeSeFQ7LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CSfnMGjA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t1RK42qtThkMwBhfSe3JGjLoX6B22qckFjSCSqBswO0=; b=CSfnMGjAr5AoT40z84KZH8Xz2o
	iTIx+sak3pNkJ6F2xzJr2MPz+devCXsrKO73ymKSt2fRqFUnTiBBMFjwuc8Eykc2nzg0n33YltfkW
	UxWl7utFDVFw97+26fhnw2jDUgDgpb2E3yyOTIYLdLOiwnnwbw/tV+leog9hl6//OBTS9dUemLXsK
	LTOOXosmebFMZmgObHkSNW60gfRl6Y+ldNbeoldvP05OKOQtn864HLfBnI2KSgjzETD9KESKppQT3
	/8C198f3A8NWHu712xmJRJLbwvCzWgOisq6+rRtwp+4N6dXQdqr3Svt0eupmhMYeRf2gQ+0fj+/oP
	SBfuvPAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfZRS-00000006hr8-0min;
	Tue, 13 Jan 2026 08:07:54 +0000
Date: Tue, 13 Jan 2026 00:07:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: colyli@fnnas.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Shida Zhang <zhangshida@kylinos.cn>,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWX9WmRrlaCRuOqy@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113060940.46489-1-colyli@fnnas.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 13, 2026 at 02:09:39PM +0800, colyli@fnnas.com wrote:
> From: Coly Li <colyli@fnnas.com>
> 
> This reverts commit 53280e398471f0bddbb17b798a63d41264651325.
> 
> The above commit tries to address the race in bio chain handling,
> but it seems in detached_dev_end_io() simply using bio_endio() to
> replace bio->bi_end_io() may introduce potential regression.
> 
> This patch revert the commit, let's wait for better fix from Shida.

That's a pretty vague commit message for reverting a clear API
violation that has caused trouble.  What is the story here?


