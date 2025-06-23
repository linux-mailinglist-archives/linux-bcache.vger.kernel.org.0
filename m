Return-Path: <linux-bcache+bounces-1144-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0035AAE4DC9
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Jun 2025 21:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 997D9189C298
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Jun 2025 19:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3DF2D3A9C;
	Mon, 23 Jun 2025 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ikWPuFiH"
X-Original-To: linux-bcache@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2245B3FD4;
	Mon, 23 Jun 2025 19:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750708575; cv=none; b=NQkamw84snzYvWAxSXa6UhsA0GTrgQ4sjzwMy3Xd7TnLH+RN84u7oWPUn9KOGvEOV6bzqs9AQQo3DjLtQg1+Q/Nvvo1nG/DSKutgj/f4rLrXqxrD6wyVXwVNmdPjiex8sK/4Jl0IDTv1703lz6AoZKY7LChP451mZ3i0Acu2dic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750708575; c=relaxed/simple;
	bh=ja/IGByDJSE/kK5VwdtaPZq7fHx57hzmSdS8DnSrwHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UPj1F9DvaAmNQ/fjn7B0//L6RfFwf6KCosBUIDufEBzeeUUJUNQaP3GBa9xP5XP3v7tGdX/rqhs5k/OPqXOLcGcqF1wUxTv7X6naY4TUUXbQTkwGy8H5EhZe0jIckR/3Zf4IpzqoOEpEEaM+v1j+5n8tmMYxMP10VwXkw00O8hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ikWPuFiH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TnCU9gKm02A5+LL/N1qNyd3gOClWsH6K5/1/GtvLDWY=; b=ikWPuFiHlVOSFKAW86Fx9Chajx
	5JyDP7vm1u3kBcd7sJhkzifJfL0nBXrIqFV0yIsJScZ4uO8BVT9caKYEwSo8fecWy/fsgLjHRApr0
	Zp3NdIYdIRDx0gknK8ChVioXLq/yh5pFfla4PTWqv8QRZRVeqFHJc11/QJtIaX1TgdTMlSvCTLIbb
	haCNrY5/a20t/1Xo/7qSBwYPkwgpvoWXSrc/3yIS4Vtqe350msYqtXz+NgGbKALDKTFp1G+mWrGE9
	cGgtnzvJ9fhi5m9ER+06xSR7wCITwxKf1rx8ZzoF0o7PERRtBQr5r2jVcJUg8hH6PdOCp08ILHXip
	El3Kni6g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uTnH1-00000004STx-1G90;
	Mon, 23 Jun 2025 19:56:11 +0000
Date: Mon, 23 Jun 2025 20:56:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Coly Li <colyli@kernel.org>
Cc: linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] bcache: Use a folio
Message-ID: <aFmxW_KFTavunvmu@casper.infradead.org>
References: <20250613191942.3169727-1-willy@infradead.org>
 <avp5ecscfzz2ekasr3qr6fvyhxwijkwn5k3z6lq5emrcdagpyc@qvzxjtc3uetx>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avp5ecscfzz2ekasr3qr6fvyhxwijkwn5k3z6lq5emrcdagpyc@qvzxjtc3uetx>

On Fri, Jun 20, 2025 at 07:58:56PM +0800, Coly Li wrote:
> On Fri, Jun 13, 2025 at 08:19:39PM +0800, Matthew Wilcox (Oracle) wrote:
> > Retrieve a folio from the page cache instead of a page.  Removes a
> > hidden call to compound_head().  Then be sure to call folio_put()
> > instead of put_page() to release it.  That doesn't save any calls
> > to compound_head(), just moves them around.
> > 
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
> Acked-back: Coly Li <colyli@kernel.org>
> 
> The patch looks fine and works well. If you want this patch to go upstream
> by your path, please add my Acked-by.
> 
> Otherwise I can submit it to Jens with my Signed-off-by.

Please submit it to Jens; it's not part of a specific series at this
point (though obviously I'm working towards killing off all the page
infrastructure).  Easiest to work through maintainer trees at this point.

