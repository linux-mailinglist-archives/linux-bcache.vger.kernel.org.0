Return-Path: <linux-bcache+bounces-1363-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF1BD19B25
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 16:02:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B0CED301D2D1
	for <lists+linux-bcache@lfdr.de>; Tue, 13 Jan 2026 15:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845EF2EBDD3;
	Tue, 13 Jan 2026 15:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dK6Q0Umj"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CF02E2665;
	Tue, 13 Jan 2026 15:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768316410; cv=none; b=qZhSuU7DJFwj4CYKBskFpqS2uxb4WQRpNpXnkw88jZPulWtXfjr3ErkdYCeXjvK05PqgwsAaK0LPul6gIQTlrcNB2v5q3NIvd8NVHLT6BC7zcf5nM8X1TGQdXfkNuw7A0knJZVMMBBx2Np5s0WycrZ3oL1oeLkWkCF4sSo58DSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768316410; c=relaxed/simple;
	bh=WZjYyxEXNfb0G6BP32MqdY+H0KBZSMku95YWUo+ebyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nn6HNqBCTAaV3ghZxMU1KKB8XG2CDYRfhd+bQmN2It//g5j8/pWL+zG13Ln656kL/CYM+W52s3q5Z0F+z0Ml6BEgQW2lxdGsMY/v6KKErqhMYO76UZShuaJ82iWaSRtkkvIdWEHl0PsTw5l23ZR1iBRmtK34VuAJJYI1zBnd+2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dK6Q0Umj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+fuxlbJlUYfXOxWEs5TdvrBNHebtJpsq9L9QFtFHmYA=; b=dK6Q0UmjovhgfIXbwPb36+2+do
	med8zrKmxrIb/keFIzltbEhogntaItG9wDiVR/6/v/xbgPw+NDOl6q4NskeHMtm8oS3u4c0F5NWSH
	+xkPi6BKkqVNtdq4QV4IoC+Llw0A8iJDn3DMIhSOPrIGqfA2c4jcdMfvPqxRkG0dbkTNKywaxE9dr
	Kjyp5s3UdDEShGMIrhiT6xkT2zyQUb/707IDJUryo2miAkGJcHg6lhwN8Fiut8eE5m9M8IxbEqao3
	jgjsOVTPjpwo9Bdwuq0f+jQAW2gk3ISaNEpRNq6CDPL/FbuzgaOhqx4TotSp8Y2CoSg+NQPROOYvJ
	PlwE6lDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vffsJ-00000007JE2-23X2;
	Tue, 13 Jan 2026 15:00:03 +0000
Date: Tue, 13 Jan 2026 07:00:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, colyli@fnnas.com,
	axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, Shida Zhang <zhangshida@kylinos.cn>
Subject: Re: [PATCH] Revert "bcache: fix improper use of bi_end_io"
Message-ID: <aWZd8xCPXV7Djx7J@infradead.org>
References: <20260113060940.46489-1-colyli@fnnas.com>
 <aWX9WmRrlaCRuOqy@infradead.org>
 <aWYCe-MJKFaS__vi@moria.home.lan>
 <aWYDnKOdpT6gwL5b@infradead.org>
 <aWYDySBBmQ01JQOk@moria.home.lan>
 <aWYJRsxQcLfEXJlu@infradead.org>
 <aWYL9x5s1nB_B1Ho@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYL9x5s1nB_B1Ho@moria.home.lan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 13, 2026 at 04:27:19AM -0500, Kent Overstreet wrote:
> It's not being a dick to tell someone they need to slow down and be more
> careful when they're doing something broken and arguing over the revert.

Yes, you are.  I did not actually do anything here but point out that
bcache is broken.  If that fix made things worse it would be useful
if one of the maintainers or a CI system spots it.  You need to do your
job as maintainer instead of constantly attacking others.

Start with that, and then just try being a little nice to people.  Most
folks will respond nicely to questions, but less so when you start out
with an attack.  And until you learn that I have absolutely no interest
in wasting any further time on arguing with you in any form.


