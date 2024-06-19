Return-Path: <linux-bcache+bounces-680-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D153790F9B2
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Jun 2024 01:17:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A19C1F235E2
	for <lists+linux-bcache@lfdr.de>; Wed, 19 Jun 2024 23:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A787C15B107;
	Wed, 19 Jun 2024 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6LFsmmt"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD99762C1;
	Wed, 19 Jun 2024 23:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718839050; cv=none; b=tPbBOenylJPXstG8ds9LW6FTIamJrBmvUI3uhy2PlZ/hmxVGjpzDb654RM4wiHfJyu+9G5Oc3hzuekk3Xrj6VAzySd43n85DL/y885oxrRUCLdqdjFErWdNMHf7iFppVeuAAtg/4hnkCmjhcUPpzZYU4oYCu5F/Bu+Gy/4/MYW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718839050; c=relaxed/simple;
	bh=af6OC184Aeh5hIidHpvhRsVZ27ISBkvr6kMN7hxhuik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oFKx1qS8hrrxhxf1XMVbwyiCD7v68J47DWvotvtJz46KagOVgSPWUL2Pb9UF8Sn6coPagcYAHkSmUYhKuRIj83RU6WY2QsHaTVX4huiTcw2hzfxjo3C4y1DcM9jh3UFzNyK7uRR0cv520VCW6cVVI9S5KF2gO53Hf0RMgVK/xgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6LFsmmt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269F7C2BBFC;
	Wed, 19 Jun 2024 23:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718839050;
	bh=af6OC184Aeh5hIidHpvhRsVZ27ISBkvr6kMN7hxhuik=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F6LFsmmt8D0ioXd0NB9FNQFhS6wy1IkuhEF7CWIMxtZrX3reYb4ZWkQi947eT13ma
	 Lk2lUOXCb29Mtg5+Wmz1lXk7hG/7UtSmESo5WIFGCTpJoU12b78cHwuTOf9dSJZjBD
	 VCU52TKpBA4n3seKoAeAiciSZaVFVpjXiv+hE+IxGyFeACUQHEZpr5170v078i95fl
	 twFSUgYxw2fBi3ivGbCXrIcCMwW6cBz7EVNwCmL2JathMrTLu34ID7+0nDgkLzeNkO
	 mrR9XnTvc3U+3NT3zim2Z0S+YHucVmoJ0jYv0f7Kl9V47RjEhsRYwPm+sP5+iW53LR
	 W5kHiih2P9q+A==
Message-ID: <74c0d236-b84e-479d-b163-07897cdcb0f0@kernel.org>
Date: Thu, 20 Jun 2024 08:17:28 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] block: fix spelling and grammar for in
 writeback_cache_control.rst
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org
References: <20240619154623.450048-1-hch@lst.de>
 <20240619154623.450048-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240619154623.450048-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/24 00:45, Christoph Hellwig wrote:
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

You can remove "for" in the commit title. Other than that, looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> ---
>  Documentation/block/writeback_cache_control.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/block/writeback_cache_control.rst b/Documentation/block/writeback_cache_control.rst
> index c575e08beda8e3..c3707d07178045 100644
> --- a/Documentation/block/writeback_cache_control.rst
> +++ b/Documentation/block/writeback_cache_control.rst
> @@ -70,8 +70,8 @@ flag in the features field of the queue_limits structure.
>  Implementation details for bio based block drivers
>  --------------------------------------------------
>  
> -For bio based drivers the REQ_PREFLUSH and REQ_FUA bit are simplify passed on
> -to the driver if the drivers sets the BLK_FEAT_WRITE_CACHE flag and the drivers
> +For bio based drivers the REQ_PREFLUSH and REQ_FUA bit are simply passed on to
> +the driver if the driver sets the BLK_FEAT_WRITE_CACHE flag and the driver
>  needs to handle them.
>  
>  *NOTE*: The REQ_FUA bit also gets passed on when the BLK_FEAT_FUA flags is
> @@ -89,7 +89,7 @@ When the BLK_FEAT_WRITE_CACHE flag is set, REQ_OP_WRITE | REQ_PREFLUSH requests
>  with a payload are automatically turned into a sequence of a REQ_OP_FLUSH
>  request followed by the actual write by the block layer.
>  
> -When the BLK_FEAT_FUA flags is set, the REQ_FUA bit simplify passed on for the
> +When the BLK_FEAT_FUA flags is set, the REQ_FUA bit is simply passed on for the
>  REQ_OP_WRITE request, else a REQ_OP_FLUSH request is sent by the block layer
>  after the completion of the write request for bio submissions with the REQ_FUA
>  bit set.

-- 
Damien Le Moal
Western Digital Research


