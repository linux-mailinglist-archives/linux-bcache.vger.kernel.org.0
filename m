Return-Path: <linux-bcache+bounces-1368-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A23AD1A394
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 17:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D45BE300A92D
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80FF62ECD1D;
	Tue, 13 Jan 2026 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RTZAi3aU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE502DCC08;
	Tue, 13 Jan 2026 16:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321571; cv=none; b=E4MUlOAdrDusExYoQTrRvTcbn0Q2iREjXuMP/j2AuyUsUleJJ96/o1oUftls4O6ZcuJwKUBIroN1QWoCLiul4TDxPCCuupsrr3t4c3IEfW33oQqV8QWa9vmUZcRqTc33JvWnMVYa0PocplOLa4C2VZZnsVjo0atl0DyrAZQ93Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321571; c=relaxed/simple;
	bh=Gp3TAeR4/yoQhVDdnRrNMp7nWKumIKTVZDX6KTgyywE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDlHrynSxxnFT9vuIOHAgvO1BgISxC5vtTuSkOUGsvUU6nVCftR4t4rWnWsqzqoiRt1a8v2Jv4OdLXdrzuGGQWfQhxv8nKq7zxskmyD3eWNfyqmDoxnywDwDZ/wInx55PD2bkuvs8kiwx8jWccEChBPRbVz9goQFS3sd69tulRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RTZAi3aU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Pa2L29HZ92eBLYCYLwkMk8AmRoEtG74DchMp+V+G/5g=; b=RTZAi3aU3qnG/qpDHncPvACYsS
	uBYB1ot7CyQsWIUiCwRv4uoXmtkOegnhYZIuYbaUs6QKsKC5hDerh+n2WvGsvT6eEFONDVweOaNdN
	Xnn9OklWBBScX+SpEHL04E17mhVCL6JlQOUdORYVhMUdOnbsXFgjmnzQ+GnUn73U+nqY0O+P+48Ed
	visyKTUezVJPlm5Bt+mgFut6FiIUAePDWGzlYfcmv+eICgEaC46sX43gXRrrKQ3SwTChV4wn8qoeW
	jPj3X7gLccsDXKKR4cT+WUhjiNUxcZE74cTZdBaLDIAVGstFI/6U3XIlsDONEEQY3obWkQVf4pnMq
	EzOi7Yrw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfhDb-00000007T6X-3Zoy;
	Tue, 13 Jan 2026 16:26:07 +0000
Date: Tue, 13 Jan 2026 08:26:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Kent Overstreet <kent.overstreet@linux.dev>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWZyHz_eZWN-yQiD@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWZwBZaVVBC0otPd@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWZwBZaVVBC0otPd@studio.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 14, 2026 at 12:18:45AM +0800, Coly Li wrote:
> Hi Christoph,
> 
> This cloned bio method looks good. Could you please post a formal patch?
> Then I may replace the revert commit with your patch.

As usual with bcache I don't really know how to test it to confidently
submit it.  Is there an official test suite I can run now.


