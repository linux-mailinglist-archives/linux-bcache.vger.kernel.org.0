Return-Path: <linux-bcache+bounces-1156-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 105E6AF8502
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jul 2025 02:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD186540C53
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jul 2025 00:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0951E4BE;
	Fri,  4 Jul 2025 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RpVI+XE2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FC61E4A9;
	Fri,  4 Jul 2025 00:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751589925; cv=none; b=DTB86DEYoQbnJ0hVth/1woLsp4CxuSj+00bVyEdrEP87U8sp3Ok4OALQAt2OxwmrJCUZCWlRrV8GKL48XXBBUK26LPH58DZfKnWvPTscIdVCPUM013aasELnDp86dbwMwAJyYn3/bCdhM6DxzPduQySCl96BoD52Sd0JG3SW+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751589925; c=relaxed/simple;
	bh=k26Ea3cuMt8hwubtRp47mgUQrP0aEYUTNEaV6IprOQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMpQLS6FC8j3E0xd2n9NMU8fyGRdpYiBye8UdjjfSXtYJ/ETGsos6/wa5iKAxNSV/EJTD1/NxfGVs3Nr8yTzQ0IDyGNdxXC8b7ws6VTry42I4gLb4N4t2yff5zN1PysLW4SuWOosQ8ebgrnWPbznvP8RU9qYYihx0/4lxKd6+LI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RpVI+XE2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEE9C4CEE3;
	Fri,  4 Jul 2025 00:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751589925;
	bh=k26Ea3cuMt8hwubtRp47mgUQrP0aEYUTNEaV6IprOQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RpVI+XE25GDQ58qLXZOaQkcg+qF+MOfs/tKH0VxsLvgZJCfSt3OEQGG16VJoMCpyU
	 +KsrYetSHPXmFXqFZYxPSpAU33dnlK0cRkxMbF93KTLvMtwwszKbdxDHSrSi1C/Wgi
	 Y8Bbv3dRfhn54UKsSlhpSFbwCc4q2rfn3NHMu7MYPUDfyIlBudzsiO+4BKtmn+hfy/
	 jtUH3ygj2AE390bQ3fbwb4SFHs839ysRNNU/UMztMoWk+G0FzJpyMTcrxrf1EsExj7
	 mxkUAETBzORrobO8iKXs+POCy/0IlZT89nBtGHbRURMejvSjeGI5Utiu2A23jcVik9
	 ONpSVkcwPUaQw==
Date: Fri, 4 Jul 2025 08:45:21 +0800
From: Coly Li <colyli@kernel.org>
To: Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bcache: fix "for/take a while" typos
Message-ID: <n6svt7l67blzqrrkrq5kys673yyyrvll5wj5lh3y7dcukkhtiw@luvs2a6fcyi3>
References: <vabrss3eucpl4xhvyrqflqj4rgtpzhv76wjtlqldlafdonkgjr@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <vabrss3eucpl4xhvyrqflqj4rgtpzhv76wjtlqldlafdonkgjr@tarta.nabijaczleweli.xyz>

On Thu, Jul 03, 2025 at 08:21:18PM +0800, Ahelenia Ziemiańska wrote:
> Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>

Acked-by: Coly Li <colyli@kernel.org>

Thanks.

> ---
> v1: https://lore.kernel.org/lkml/h2ieddqja5jfrnuh3mvlxt6njrvp352t5rfzp2cvnrufop6tch@tarta.nabijaczleweli.xyz/t/#u
> 
>  drivers/md/bcache/bcache.h  | 2 +-
>  drivers/md/bcache/request.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 1d33e40d26ea..7318d9800370 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -499,7 +499,7 @@ struct gc_stat {
>   * won't automatically reattach).
>   *
>   * CACHE_SET_STOPPING always gets set first when we're closing down a cache set;
> - * we'll continue to run normally for awhile with CACHE_SET_STOPPING set (i.e.
> + * we'll continue to run normally for a while with CACHE_SET_STOPPING set (i.e.
>   * flushing dirty data).
>   *
>   * CACHE_SET_RUNNING means all cache devices have been registered and journal
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde1..87b4341cb42c 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -257,7 +257,7 @@ static CLOSURE_CALLBACK(bch_data_insert_start)
>  
>  	/*
>  	 * But if it's not a writeback write we'd rather just bail out if
> -	 * there aren't any buckets ready to write to - it might take awhile and
> +	 * there aren't any buckets ready to write to - it might take a while and
>  	 * we might be starving btree writes for gc or something.
>  	 */
>  
> -- 
> 2.39.5



-- 
Coly Li

