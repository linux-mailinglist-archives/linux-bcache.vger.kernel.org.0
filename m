Return-Path: <linux-bcache+bounces-1334-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BBA69CA30B8
	for <lists+linux-bcache@lfdr.de>; Thu, 04 Dec 2025 10:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F539302014F
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Dec 2025 09:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D5A306B0C;
	Thu,  4 Dec 2025 09:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ten7Krd9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790C3074A2;
	Thu,  4 Dec 2025 09:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764841218; cv=none; b=L7BD/IEYekrXd0Eha7Qn6onF6NIP+mMpY9pjj7TXHNowdvcyHDl094XheaLtZkKL3jMfsP4/pBEwQbDKT8oe0J2Q8M9kovG2gXkpPA+7cPhN5syZCl+5w/666uVjPR8v9F44YqW+mgFWFrieFBCG2p8Hwm/xpYtpf31psQpKHcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764841218; c=relaxed/simple;
	bh=xU4ZylTOrmPyj05Bwgg8Mg1MQqsBgCOEXMkR+M5Ykag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DdjZYDrPUp8eUuiIBbkx6HT2VLBg3yUZTh4yoYrMJraNKQeWWdPQetUV9a49XjYYYzKBYOzeYIzi8GXRqbOOdRfFHAIHm/jVKBkF/6nOnp1zU5NbG/ROo1t2nv6IUoAEt++vjDdEcsVW3Kxd2MVP79t+vV8/G51hYQUAQGBPxTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ten7Krd9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UGnpLRYpYfInLzJFrdQ3LmfcmgWbcVsX7E0IlUYnxP0=; b=Ten7Krd9C3wCmflq7lBSI6kabb
	QoO36JE3ho+fL09E+OR/IWQ8gkjEwP8pXTTK+vuSHwfFyhwSKhGpYXQHCWS2sFn/w4CJz3YJona5d
	DEcIATXSJySXK8IJ0DLAqKmbOx1O8P4sxc/J/o+W/ykyG5HMtCFEAmYcvyAJ5CsbOIXBMbcYGxbqO
	HJWbuZ1TDWmxMUVEeN0Ajg74Hw5OryvChdLLbMTqg83cXzwY6L6U/HRLMxysit+nOSI/GNQjo3z9j
	3iuywFuK0TQaLLrGbN2yiKYRx8R+1MjCKZsY7of4+ZWsElcBC4uAHjQvXpatfGUbSU7/SiXl+q1B5
	1267Kx0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR5os-00000007mQe-0Q2c;
	Thu, 04 Dec 2025 09:40:14 +0000
Date: Thu, 4 Dec 2025 01:40:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: zhangshida <starzhangzsd@gmail.com>
Cc: Johannes.Thumshirn@wdc.com, hch@infradead.org, agruenba@redhat.com,
	ming.lei@redhat.com, hsiangkao@linux.alibaba.com,
	csander@purestorage.com, colyli@fnnas.com,
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhangshida@kylinos.cn
Subject: Re: [PATCH v5 2/3] block: prohibit calls to bio_chain_endio
Message-ID: <aTFW_gdWmXmCP5fd@infradead.org>
References: <20251204024748.3052502-1-zhangshida@kylinos.cn>
 <20251204024748.3052502-3-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204024748.3052502-3-zhangshida@kylinos.cn>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Dec 04, 2025 at 10:47:47AM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Now that all potential callers of bio_chain_endio have been
> eliminated, completely prohibit any future calls to this function.
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  block/bio.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index b3a79285c27..cfb751dfcf5 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -320,9 +320,13 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>  	return parent;
>  }
>  
> +/**
> + * This function should only be used as a flag and must never be called.
> + * If execution reaches here, it indicates a serious programming error.
> + */

This is not a kerneldoc comment and thus should not use /** to start
the comment, otherwise the kerneldoc script will complain about
missing kernel doc elelemts.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

