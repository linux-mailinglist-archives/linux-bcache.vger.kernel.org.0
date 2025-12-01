Return-Path: <linux-bcache+bounces-1306-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B4BC95C5C
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 07:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4C4733427C8
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 06:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29071239E9B;
	Mon,  1 Dec 2025 06:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GRuurmJF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749471E5B71;
	Mon,  1 Dec 2025 06:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764569698; cv=none; b=eqp0Xd+gNC0/jX2uUmnhBSRO69vLk7QCxNa8zEgq5bzlNzYRsK20xX5UZxklsvr+S5DokK1usQb0yqPW9DKSqqpdURk42nRwoPNcf7edsyXRu6vEN54EU/gdPYo2hVRMz3oi2QpT9MXBmqXNzXhSuK9EuKvyB731gIx3DRjw6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764569698; c=relaxed/simple;
	bh=+hPPHyw2cLZaADymlqxOQxbAyjo2VNJCCLK+P+9NHRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZs9Ajz++g7UFeO9qRQoVx9bqanMf9VQv3VcqGiZ+GOnFGgvUSKGQOENolodlVsjeyiK8nadaLcBDCLtvL3ktKSWk92hABOzqUKHvZoU5DqzR+QzG4K0tXK1RxhYwM0rj0B9BdkZQun/T7PcV7aq0ZCIyx8PczyXXzsSQg5AitA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GRuurmJF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CVygV0hXzKvEjJ6QyLzL7WMdSuvnf20ataf/lIM2xEs=; b=GRuurmJFPyu6KIAZp8rsZh0MaX
	epX0lni6C1o7Qj3FIbTdxc7o2K5RegtpAvUrogotYl5ZtoGB+qQYpTBO/MVktzQYwbtRGefluiQ6m
	jK9yGFRCCx82SxHAxgZ21nz4W9tuFQ3qSSaQA9e5187ifi3Wb3EY5MXdH3/mIKqZzvbPo8AVBomul
	ItQh9LvaLcUM6i/J+tWuJocgBrwnVc2DmMDSn4JH308NQGc7tn0yFoG4DAe3cRjqEJkHNJnHEzPJZ
	7nPTYZyOwK9/9xhjhC6cxi2frTW5CXHMgt36vmidU2ScjzDdNMXGIkZ2vHP5/XvtqhI5j9qw7bxmA
	vNDUmR/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vPxBV-00000002xde-2r9G;
	Mon, 01 Dec 2025 06:14:53 +0000
Date: Sun, 30 Nov 2025 22:14:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn
Subject: Re: [PATCH v3 3/9] block: prevent race condition on bi_status in
 __bio_chain_endio
Message-ID: <aS0yXeoUFybWlTxc@infradead.org>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
 <20251129090122.2457896-4-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251129090122.2457896-4-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Nov 29, 2025 at 05:01:16PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Andreas point out that multiple completions can race setting
> bi_status.
> 
> The check (parent->bi_status) and the subsequent write are not an
> atomic operation. The value of parent->bi_status could have changed
> between the time you read it for the if check and the time you write
> to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


