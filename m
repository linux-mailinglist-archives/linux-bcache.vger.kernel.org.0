Return-Path: <linux-bcache+bounces-1389-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CC71ED3C001
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 08:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C8FCD502880
	for <lists+linux-bcache@lfdr.de>; Tue, 20 Jan 2026 06:55:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39E930DEA6;
	Tue, 20 Jan 2026 06:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yubG3vMQ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9EB6387346;
	Tue, 20 Jan 2026 06:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892037; cv=none; b=ExlgnjavGD1FE4XaWdU1EiECpVlciIDB+K019zMPvPLaWfKqs08GftoCMoCHPk2TueRmy+xLlcpypE9y5CD4+DfwQaU0IotHi+qmW2RAnlg/QnB0eVFR8BkQC4NCLZ6w3mEDY1V/elmi8mgDjg7gPBcj0gAv9/p5BXa/br+Lnek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892037; c=relaxed/simple;
	bh=Awliux2bLmETg8vlvJBc5MvcAsWL1gNEFbkFl4aYBKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gM9qAqPXn0Y8ICtdxsmt0rLCbPsanMPmJf0dwiDrunnd3AZcQqQ2G3chV3Z4wqxlpH+H4xMAfb7nWwDLwp9wzOte720TWNW9EDqio+U6TMPv+LPMPMoD3Vcgyt8VQ2sXQ95XOS42JU4gcD7727StZlxihgVmvEVDVLtqSnTWSRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yubG3vMQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Awliux2bLmETg8vlvJBc5MvcAsWL1gNEFbkFl4aYBKE=; b=yubG3vMQz6OgvuRE+oRXXZwOiY
	1sL1nhcm2eJnw5ZtBPBxDaIXppKfueWhfzo0ELJhq+ppcdJuQszyxS0wrhZ6cVhbGU4vvoImamQSv
	PfbNYuItuALamiXuTL3jUIynkZqgj1cMsXMoEmY014qCgL+0/6nrNdb8bUGE9H/wCW4UiUj6DahkQ
	0ZD1mnXJfH2IcKIi4Uu88+qgOTVBsaImCh/Fbq1PJYHCGRlt6VDbLeVAmbXMywM3TjIoxBPcfMnOE
	UgCtmygwS/3hO/kvdBlLqngA7T8iuG60U6FiguEBlVfMiumKeIqsPA0wrJSOFo6/kqy3PdtmttgzF
	hNw4ZBkg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vi5cQ-00000003IwT-3Umo;
	Tue, 20 Jan 2026 06:53:38 +0000
Date: Mon, 19 Jan 2026 22:53:38 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Coly Li <colyli@fnnas.com>, Kent Overstreet <kent.overstreet@linux.dev>,
	axboe@kernel.dk, Sasha Levin <sashal@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, linux-bcache@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	zhangshida <zhangshida@kylinos.cn>
Subject: Re: Fwd: [PATCH v2] bcache: use bio cloning for detached device
 requests
Message-ID: <aW8mcsZzELt_Gzui@infradead.org>
References: <20260120023535.9109-1-zhangshida@kylinos.cn>
 <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANubcdXsWsdueYf_aN9FSm+hnE-rpXx_hHhwP9_Z1ni1YGEH9Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks good to me, thanks!


