Return-Path: <linux-bcache+bounces-1377-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE21D39EE8
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 07:47:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5B8CA3005B81
	for <lists+linux-bcache@lfdr.de>; Mon, 19 Jan 2026 06:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEE8274FE8;
	Mon, 19 Jan 2026 06:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="s4drGUdU"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9EF25F96B;
	Mon, 19 Jan 2026 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768805039; cv=none; b=DwwM71PJdQfKxeXDoTglI8UhYKXVKGzkVHLsOypJSQaD9VssmoczH+PbI/5ymXc4hmwfvhQAenUEVBB/h7T7ygSwxtyLBmmS1LUJurvgU7YLsgNOZ3ZqxCMePhJlXdMeIA7cvcFnCWV9GrDf5cRneSeahQoEmyQ9HGriKcDWa04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768805039; c=relaxed/simple;
	bh=SBC42YlTiSSHipCOoKyO0qBEXslfa02Xybyz0dSvUOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPaxSZsXtzmZUyz4LaZnbU6Ljc1xrLkDaGB93u5s37KQ3SHyGcVU0pSzsyrPw+hd88EcUoXbofYYGPl2GabwN1vOmVcajL2E+vDKyOYxZr/7DXnaebobJP/LdWI4bZ2vjmKZf8z145zkKLHxs8/uPhYh0Q0Vcjy2HTVPoCVYTAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=s4drGUdU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jIp2nvPmYYdGEFhmVd3RKCQNu+W6j+CCihtmJ/tid9o=; b=s4drGUdUYxuyt3+sZRYemiensW
	6iqHnvJUJWO6IbBIEeDyXBm4h0/2ly1V65N1qbiwtZw51oRiN0PcIXPvqQpmu83pJm0Vha4OOFzlr
	twPXjvZwieHco7dbyzn/CmRsCdk2Wt5bLI6+uSC/BIj84cuPVlXsC2aobtgiCPt9nGe4Bb9TVsHeP
	vc9+cAfrAUbf0E5Gw+196ultWWEXSREFNZmWGNwh2lSdiXGdYN0/bSELalJG/oZXyTVm+htv2r+H4
	byN2zBdBMxkskSnIv1ldBYsqyamp8QRbj6xy7cuFDWyX0N36z6KCpmXnk269PyKDUy6qt3EpmGLD5
	bZUEymng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vhizT-00000001Qbq-2X1X;
	Mon, 19 Jan 2026 06:43:55 +0000
Date: Sun, 18 Jan 2026 22:43:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Coly Li <colyli@fnnas.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Stephen Zhang <starzhangzsd@gmail.com>, kent.overstreet@linux.dev,
	axboe@kernel.dk, sashal@kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH] bcache: fix double bio_endio completion in
 detached_dev_end_io
Message-ID: <aW3Sq4H_OosPVaNe@infradead.org>
References: <20260115074811.230807-1-zhangshida@kylinos.cn>
 <CANubcdUdQ9gJ7uQELc80h0+FpurR5f2COmB3hBEDejavfFZJ9g@mail.gmail.com>
 <aWilW0RKQiHJzpsZ@infradead.org>
 <aWzIU3ASp139lHNz@studio.local>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWzIU3ASp139lHNz@studio.local>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jan 18, 2026 at 07:49:36PM +0800, Coly Li wrote:
> Shida,
> can you also test it and confirm? We need to get the fix in within 6.19 cycle.
> 
> Yes, we need to make a dicision ASAP.
> I prefer the clone bio solution, and it looks fine to me.

Do you have any maintainer QA that exercises this?  For basically any
other maintained subsystem we'd have a maintainer jump on verity fixes
like this ASAP and test them.


