Return-Path: <linux-bcache+bounces-855-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B7833A7F3D3
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 06:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B54117806E
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Apr 2025 04:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D0E1CAA89;
	Tue,  8 Apr 2025 04:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NNOnLy29"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B1423AD;
	Tue,  8 Apr 2025 04:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744088118; cv=none; b=gKPX1N4cTutS2hjgML5N/WjR22B/54mgT+jPQ7WkU0votpRQa7hvjjDR7p1w/leB9Sv5SvCdbtlvy22vFtod79YO6olnv56P+DiLDdfGZQK+f0b1YEPi4ITsQgZpbz/ECX6gz8aL9x5SaUO4JNyQ6MfaSjscyp9R81i6cZaKDwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744088118; c=relaxed/simple;
	bh=/0ZuFfuotMs9byNxCq+GVMW6tAKZAVyZQSFYb7/UdKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMcJNkt5tfL2P6c8uF+5HfaAwM9IrKe/kpoqk4fE+AJz3ufxCV4/8hPXifWBAxGL3XoMy8ucuOdg1Zhe47U9KSxN1yYJcpr+X56NHeiSNUlXEsHN+edhJSdCGOWtCaQHOxi9O65mqRryD4nT0gsM9pP/ycsz2z1q5GaNwg9Cx10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NNOnLy29; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651FFC4CEE5;
	Tue,  8 Apr 2025 04:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744088117;
	bh=/0ZuFfuotMs9byNxCq+GVMW6tAKZAVyZQSFYb7/UdKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NNOnLy29R0zcdGEmVM0P+gKVxBNkU0dVruOAk7XtM4FJXbjNJiFpp+MnuytQ9MjlV
	 om5ltprKxzCOBvoZutxS9TdTACKbaKSS11bXy1bLFyXfM5pDgIhFL+nrWqgfWD1Z2g
	 YHE6KoO4WHtWFzDsM4jHVyTnc/2FJnRhxEH4laDq2OGWz62SuvjX8biUzJV6UN+J0C
	 tvh0egRImxtl91rqInCNbFJPr/FIBsPz2eBo8lxiSgyEDVyc5bdd68IcqGqZw6/5s6
	 FmSoD6it9lskqIuV9lxlh3XItxTm14ketpZVPf1KnWN9iTwKXmRvwf1Os6xQ2wfNqs
	 EiVtk1qYYAJjg==
Date: Tue, 8 Apr 2025 12:55:13 +0800
From: Coly Li <colyli@kernel.org>
To: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, 
	kernelmentees@lists.linuxfoundation.org
Subject: Re: [PATCH 1/2] bcache: Fix undeclared symbol warning for
 bcache_is_reboot
Message-ID: <6s4hsqctezmwk73bgz4u6clielbbndijfk6hpciqfbjc53yzhq@hm4ybp4splhl>
References: <20250408033322.401680-1-gshahrouzi@gmail.com>
 <20250408033322.401680-2-gshahrouzi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408033322.401680-2-gshahrouzi@gmail.com>

On Mon, Apr 07, 2025 at 11:33:21PM +0800, Gabriel Shahrouzi wrote:
> Add extern declaration for bcache_is_reboot to bcache.h. Ensure proper
> visibility for use across multiple files (super.c, sysfs.c) and follow
> the declaration pattern for other forward declarations.
> 
> Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
> ---
>  drivers/md/bcache/bcache.h | 1 +
>  drivers/md/bcache/sysfs.c  | 2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 785b0d9008fac..531933351b8b8 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -1007,6 +1007,7 @@ extern struct workqueue_struct *bch_journal_wq;
>  extern struct workqueue_struct *bch_flush_wq;
>  extern struct mutex bch_register_lock;
>  extern struct list_head bch_cache_sets;
> +extern bool bcache_is_reboot;
>  

NACK. It is uncessary to make more .c files to be aware of
bcache_is_reboot. Current code is in better form IMHO.


>  extern const struct kobj_type bch_cached_dev_ktype;
>  extern const struct kobj_type bch_flash_dev_ktype;
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index e8f696cb58c05..47ef0167b9d23 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -17,8 +17,6 @@
>  #include <linux/sort.h>
>  #include <linux/sched/clock.h>
>  
> -extern bool bcache_is_reboot;
> -
>  /* Default is 0 ("writethrough") */
>  static const char * const bch_cache_modes[] = {
>  	"writethrough",
> -- 
> 2.43.0
> 

-- 
Coly Li

