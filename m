Return-Path: <linux-bcache+bounces-1314-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0AF9C96546
	for <lists+linux-bcache@lfdr.de>; Mon, 01 Dec 2025 10:08:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834873A3D29
	for <lists+linux-bcache@lfdr.de>; Mon,  1 Dec 2025 09:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF99231842;
	Mon,  1 Dec 2025 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="U7rcZ2v6"
X-Original-To: linux-bcache@vger.kernel.org
Received: from sg-1-40.ptr.blmpb.com (sg-1-40.ptr.blmpb.com [118.26.132.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194C1F463E
	for <linux-bcache@vger.kernel.org>; Mon,  1 Dec 2025 09:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764580111; cv=none; b=Csxlq5BjVp+zmvZ0iiqN/i2iHmb2MNznyGTRY751P7w3GbsWm5wK8G34sT7huJniMNO+qjioObDyfaLZz76xNUDFIbTC+XSVabfQx4TAqWdc0NDP9WcjwtKqmw3ib8DjMG2mQ1QGTjWGFCruLcz482/5q0KZYCMioLVwBz6g0BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764580111; c=relaxed/simple;
	bh=trVQE4PC6il3vSKiNbXVZ7T1f7N0BsICd2ElIcQjZ0A=;
	h=In-Reply-To:Content-Type:Content-Disposition:From:Subject:Date:
	 Message-Id:Cc:Mime-Version:To:References; b=Z9WPCvVLm62wSzIeEu7jkaEhp3t78obzsqLY5HO4EfICU3GqvXBjMw0j4HiNRgGJrQ/6jXBbcr5GeWpvKM/3shDIOnANgvJDKXu/T/q1Ym0v/bmSkVF5AvuyITM1VkhKMxOqsjEVv06pXqG9XCv8eCud+BnzBG7iiqdLmyCO7TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=U7rcZ2v6; arc=none smtp.client-ip=118.26.132.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764580101;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=hgkJQ3PQE/6598gAxptdMWoKRhgO+ciZhSMHPbjcE/o=;
 b=U7rcZ2v6PZ3fUkGeqELrRTh3bzo4YeVVTZQx55j9Jvg4VQizTCfo+qQwTq5vqtDCozrf0Q
 F2/5CJ6RfYJdn+bgqctFv0FN6DpByeU3l0eS7YPm/emCV7X2nZ8Bro0BsXdZwox57YncYu
 +LW4xSJKRM8TlXUgDbVGfTR1mbMWepqvtu19uOH9F4PBW+mDVJfWspm02DXVWzcSOx7g0H
 q4lmTGpMpEW6qRVCL3BQ94rKjB+iF8+voBgSTAvKGRpn5zJEPOSXN2m4P2A6ilMGutmEfT
 g6pFyHWbWmDW1vWnsTx9wTPHR7DT2uJ5cd/XNf7wvB1Yh9OV8i8ZjXWokVxaBQ==
In-Reply-To: <20251201082611.2703889-1-zhangshida@kylinos.cn>
Content-Transfer-Encoding: 7bit
Received: from studio.local ([120.245.66.121]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 17:08:19 +0800
X-Lms-Return-Path: <lba+2692d5b04+61dcc5+vger.kernel.org+colyli@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
From: "Coly Li" <colyli@fnnas.com>
Subject: Re: [PATCH] bcache: fix improper use of bi_end_io
Date: Mon, 1 Dec 2025 17:08:18 +0800
Message-Id: <rjhla7utyfh5khnj3rumuw2tlelribiphotaz5v5olpe6jcavk@hytopklmihjk>
Cc: <linux-bcache@vger.kernel.org>, <zhangshida@kylinos.cn>, 
	"Christoph Hellwig" <hch@infradead.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Coly Li <colyli@fnnas.com>
To: "zhangshida" <starzhangzsd@gmail.com>
References: <20251201082611.2703889-1-zhangshida@kylinos.cn>

On Mon, Dec 01, 2025 at 04:26:11PM +0800, zhangshida wrote:
> From: Shida Zhang <zhangshida@kylinos.cn>
> 
> Don't call bio->bi_end_io() directly. Use the bio_endio() helper
> function instead, which handles completion more safely and uniformly.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---

The patch is fine, I take it for next submit. Thanks.

Coly Li


>  drivers/md/bcache/request.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde..82fdea7dea7 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
>  	}
>  
>  	kfree(ddip);
> -	bio->bi_end_io(bio);
> +	bio_endio(bio);
>  }
>  
>  static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
> @@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>  	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
>  	if (!ddip) {
>  		bio->bi_status = BLK_STS_RESOURCE;
> -		bio->bi_end_io(bio);
> +		bio_endio(bio);
>  		return;
>  	}
>  
> @@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
>  
>  	if ((bio_op(bio) == REQ_OP_DISCARD) &&
>  	    !bdev_max_discard_sectors(dc->bdev))
> -		bio->bi_end_io(bio);
> +		detached_dev_end_io(bio);
>  	else
>  		submit_bio_noacct(bio);
>  }
> -- 
> 2.34.1

