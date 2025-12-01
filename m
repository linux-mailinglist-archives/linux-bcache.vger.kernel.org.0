Return-Path: <linux-bcache+bounces-1307-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 549FDC95C6E
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 07:15:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9F1B3A2C77
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 06:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CDFB207A20;
	Mon,  1 Dec 2025 06:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WGktu9Av"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1B1A9FB0;
	Mon,  1 Dec 2025 06:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764569747; cv=none; b=IdI1NZMISiHTq1A/iBKjZsY48Ahnp//10F7nSwGreJj5DFXmJli81b0hH3HSZ3ZRSkgycvp/WX3JavvBvw/Mry+sd5uaNWYespdidFVMEDNS/s0PHzNMjXwvxwgSVhlo64Hv24RkzhLMrWxdyJ2/v3JlEpj8Ogn6J9sMe9MIZuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764569747; c=relaxed/simple;
	bh=8BeP7dCRLUpJbdAnQWZOc328WL4PHqtN2z6xx/aoD+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEDspUNIkwj3nK3st5QshkD8wCEyoOcqsBwEGcBxxCmxSaoOwGTIbef9HmDvlGG2P+wGiRxDGMzV5rBasvTaG2DMP6TWSmAXMy3Ehs45bc4UEsx7MvKjh0CLhKKGjanAyLjy1WR7TmeTLWhpESXz9zEZVt1Kj2KGk4xPfhfnA9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WGktu9Av; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8BeP7dCRLUpJbdAnQWZOc328WL4PHqtN2z6xx/aoD+o=; b=WGktu9Av2hQifd3jzigEM1xiJF
	vkDhkAaEJYFMCVm+Btx07+CTpEG4PBlomAxEU2vsRpVcC0lWiSZqoB/RF4TwhbQ+gdo5j/C6vddEX
	1B+E1kC7/YCZ/DsvpteDJlyFI0yWKQAwiuzQfgUAuihKzuveYrLTIZKGAH4Z0Xg95Kt5SzPI3RwNR
	tU6Q2wKCmYpEWpCig0iXSDuXGy5xpWaYYATs+AmsLgm7wZydA65aZNoIc8zbRISPOeZE3C7G/8EhK
	U9j7gTAqv3iNgjaRZNu+XrlgW0KeNMEEuHhJd1PDGkjOTzhQUkUKxvq5mI+9fpnOMc6xB2zEup61F
	tDrg9YoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vPxCF-00000002xgA-0chY;
	Mon, 01 Dec 2025 06:15:39 +0000
Date: Sun, 30 Nov 2025 22:15:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH v3 4/9] block: export bio_chain_and_submit
Message-ID: <aS0yizTv8hTzXPAQ@infradead.org>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-5-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-5-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please split this and the remainder into a separate series, to be
resubmitted after -rc1.


