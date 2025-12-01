Return-Path: <linux-bcache+bounces-1305-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BA4FC95C48
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 07:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BD929342186
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 06:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4A381E7C03;
	Mon,  1 Dec 2025 06:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g4vc1rzC"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2405482899;
	Mon,  1 Dec 2025 06:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764569670; cv=none; b=I9YGeYRnoZ2L/TyB6LjGtGIOmEgHGJz6I8Q9aliEbAFWX+SC7mwhxy7VJkJlmMNQoUCQ/lOZws8ZUVfXe9MBJLxpRyq0PebH5Nd0mqYVuN3L/yNg0pSzTHsMWV1rx1tPp0UbpirpBme7v3eXxyslnDdAH01RiXAeOdRc8z6zsPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764569670; c=relaxed/simple;
	bh=oyTXK6WAV6tdak4lHgfK5RcZZLs1G5qoy3pkR+5R/yI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbueXugp/SPQuJVyS3ZL2M46WPdunnFn+vdaQEUhnASIeVrNw8Q+/Xsb9lW3bf0fofb6rk3Bv80mtCUvEAzmWDsctrcd+h1BpnXU1GmRfFklqMXlJ8YI+J/0Vv+DkoL4g2Ki98lkPmLyJV2xV0ElYzvwkvKzocwRRq95+5guers=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g4vc1rzC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z7JV6wsaK70ZsGmVq2rmLBIY3ZCbzGzzkfg6g/jP5uc=; b=g4vc1rzCoEArXPauwVrI1LcM71
	1TLulCUqVB7EtNqXd5fhMHV8uNTGvhHUcF+mjJoy+nm4dRQh3BSLwSZL99GmDWKajOG2kM78wC3oZ
	0dI9y+kSqA1jFf/91H/ISPIMQGxDexVjekcJ6TIJl/rwmRxAPtf67Xexf1J1pzacsBvvF0FAF7206
	ZQ7+MLLyu2YDjgQdB2mYmKq+lBJQLjHZodUPHePEfWhYgQdoGEdY87OtSjLXMI847HmlzcKC9bGxv
	6UM04gsXBJemejnqaJjMwo8ipWyj+LD+lHCewDwaJYsrv1VTEysoIeXU3AdydQ3AEQb0+Ml3F1cH2
	5IP1Kx3g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vPxAy-00000002xbh-0Swb;
	Mon, 01 Dec 2025 06:14:20 +0000
Date: Sun, 30 Nov 2025 22:14:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH v3 2/9] block: prohibit calls to bio_chain_endio
Message-ID: <aS0yPEDwoc7cGAoe@infradead.org>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-3-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-3-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Nov 29, 2025 at 05:01:15PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.

Note that we'll need to be prepared for a flame from Linus for
using BUG_ON, but I still think it is reasonable here.

Reviewed-by: Christoph Hellwig <hch@lst.de>


