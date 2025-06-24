Return-Path: <linux-bcache+bounces-1147-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EEE0BAE6514
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 14:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 709051885164
	for <lists+linux-bcache@lfdr.de>; Tue, 24 Jun 2025 12:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 488C2291C37;
	Tue, 24 Jun 2025 12:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojSo+A8K"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2459F291C08
	for <linux-bcache@vger.kernel.org>; Tue, 24 Jun 2025 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750768329; cv=none; b=UPs2Cp+ui70Nn796kdwvd7ZDT/cpVDGyU4lMODM1Ng/8lwlw5xmUrfUuRwpEn2Iv3+8kDIf301DHz9DY4OCo00LgMZUmOFC2qq7tdyEJ8w3drnNR4kgxtwmUvpoS76lm+u4qRl2aP317PLr7i/Xdm5G33zw+Xdw95etfpBUfiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750768329; c=relaxed/simple;
	bh=WF+x8dtszhpQyaM3VKwEIaKPZA68lp/X+i95O96jX64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cWjsb06kGpf2I9PoiaO/AqwuT2lRUNS12BPxsCRLM/r9Gxb4pYIj7fIaBmEDPXPJmQ8+FTg87eze7Wh/MJouecaWxAj6eNvhYHAxtdMZurMsHXKTcNG7LyxvddLgJgfJEi4kT9AjtPXJjDHe9boO2NmsD/oXaaMmeWQ7ZP2uB7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojSo+A8K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07040C4CEE3;
	Tue, 24 Jun 2025 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750768328;
	bh=WF+x8dtszhpQyaM3VKwEIaKPZA68lp/X+i95O96jX64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ojSo+A8K6b2d6NIflwWsKAXywycaTTicL0ZOW/Wc4ZK38S/x3yvXJEx0VQe6vkMG2
	 xobKQ3IRR73ojzue0vGQ1VXYdG+XjufLV3ul4wCZGnjn+dPoFFbkNtMOlVBbJ5+L3c
	 DeDbPoZxR3R/7jvwTPJMavtM7aBjLjjTv07NBNLSknTbiESRznPbKLR6GtldsPpU5s
	 nCS+Jd+7KLRPulbjWOc9XYbTh3IQUVuRmoo3mntOI5FUiK8XObdX0h0DfNudo/OatQ
	 O+f3ZLwBU5FpojYSkwtcyZuPCtIETQFV+BPkmoI8YkCRG3wiW2JAeZvz64J4xOIL5c
	 tT2so7F1PKrng==
Date: Tue, 24 Jun 2025 20:32:04 +0800
From: Coly Li <colyli@kernel.org>
To: Shaoxiong Li <dahefanteng@gmail.com>
Cc: linux-bcache@vger.kernel.org
Subject: Re: [PATCH] bcache-tools: fix strncpy compiler warning in
 replace_line()
Message-ID: <5tby4oc6ibrx3a5uxv6mgc3sfniocwtzmlujtljonhaqd7o2dy@nzrsnoxfysbn>
References: <20250624121940.8738-1-dahefanteng@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250624121940.8738-1-dahefanteng@gmail.com>

On Tue, Jun 24, 2025 at 08:19:40PM +0800, Shaoxiong Li wrote:
> The strncpy() call in replace_line() was using strlen(src) as the size
> parameter instead of the destination buffer size, causing a compiler
> warning about potential string truncation. use snprintf() instead.
> 
> Signed-off-by: Shaoxiong Li <dahefanteng@gmail.com>

Thanks for the fixup. Applied.

> ---
>  bcache.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/bcache.c b/bcache.c
> index f99d2dc..47d45e9 100644
> --- a/bcache.c
> +++ b/bcache.c
> @@ -142,7 +142,7 @@ int setlabel_usage(void)
>  	return EXIT_FAILURE;
>  }
>  
> -int version_usagee(void)
> +int version_usage(void)
>  {
>  	fprintf(stderr,
>  		"Usage: version		display software version\n");
> @@ -157,7 +157,7 @@ void replace_line(char **dest, const char *from, const char *to)
>  
>  	strcpy(sub, *dest);
>  	while (1) {
> -		char *tmp = strpbrk(sub, from);
> +		char *tmp = strstr(sub, from);
>  
>  		if (tmp != NULL) {
>  			strcpy(new, tmp);
> @@ -166,7 +166,7 @@ void replace_line(char **dest, const char *from, const char *to)
>  			break;
>  	}
>  	if (strlen(new) > 0) {
> -		strncpy(new, to, strlen(to));
> +		snprintf(new, sizeof(new), "%s", to);
>  		sprintf(*dest + strlen(*dest) - strlen(new), new, strlen(new));
>  	}
>  }
> @@ -453,7 +453,7 @@ int main(int argc, char **argv)
>  		return set_label(devname, argv[2]);
>  	} else if (strcmp(subcmd, "version") == 0) {
>  		if (argc != 1)
> -			return version_usagee();
> +			return version_usage();
>  		printf("bcache-tools %s\n", BCACHE_TOOLS_VERSION);
>  
>  		return 0;
> -- 
> 2.43.0
> 

-- 
Coly Li

