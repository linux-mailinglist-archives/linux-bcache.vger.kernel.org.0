Return-Path: <linux-bcache+bounces-468-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3973A8CC969
	for <lists+linux-bcache@lfdr.de>; Thu, 23 May 2024 01:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 696B1B21762
	for <lists+linux-bcache@lfdr.de>; Wed, 22 May 2024 23:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 678B5145B14;
	Wed, 22 May 2024 23:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a0FbMVid"
X-Original-To: linux-bcache@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4319470;
	Wed, 22 May 2024 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716419450; cv=none; b=Hmxpg4/bNqXObWs095d0BHnQLtiu8LCGiiBFrkJIkICIPGxHK9n1+Hxsrqf+Mh1MTG39fG5XFPqAafc8DFt7rkOmb312swH8Vvm9hTAVtUDaUEuiAV1VV8gHWe5wD672DKAGA1H/1LzD/BspV+x47FNB39iK5U+FErKag1T1c/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716419450; c=relaxed/simple;
	bh=Z+7gGIV3RKzOZJXBZDX/o1LgEMBdIQufNV2XJHKqPZ0=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=i/snH5C4SiHTSJu+bhBx4sI3ZrkfszzkmtXyTBlq1jvgLEifpt98X23WrSkbZNDZ1lNLm6C8bPC3+jdgpe61+UCeRf8dSG4+KFaPSSW6ni+bE9661J8YZRXnS5/mbahwwZsEOQOc7QJPHZoDiifoN1ge9aX8OxFUG2ehU7/1nSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a0FbMVid; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D320CC2BBFC;
	Wed, 22 May 2024 23:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1716419449;
	bh=Z+7gGIV3RKzOZJXBZDX/o1LgEMBdIQufNV2XJHKqPZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=a0FbMVidQyKtR5EjVEFlLSaCMH+Y7NFs/eZtCb3Yxt+VUAje5+LSYtQzarq5Fms70
	 Y7u/ZzmIe6bDRz9MXy3fNFqpw4HTD4wAJIweTPTD0UTQ54x5A7w8NqMGt7uy4CFU1r
	 Y55tmBWUa6jgNovthIfsQGUY3prspIdbBitktdYY=
Date: Wed, 22 May 2024 16:10:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
 peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
 namhyung@kernel.org, bfoster@redhat.com, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com,
 adrian.hunter@intel.com, bagasdotme@gmail.com, jserv@ccns.ncku.edu.tw,
 linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 04/16] lib min_heap: Add type safe interface
Message-Id: <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org>
In-Reply-To: <20240514084724.557100-5-visitorckw@gmail.com>
References: <20240514084724.557100-1-visitorckw@gmail.com>
	<20240514084724.557100-5-visitorckw@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 May 2024 16:47:12 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Implement a type-safe interface for min_heap using strong type
> pointers instead of void * in the data field. This change includes
> adding small macro wrappers around functions, enabling the use of
> __minheap_cast and __minheap_obj_size macros for type casting and
> obtaining element size. This implementation removes the necessity of
> passing element size in min_heap_callbacks. Additionally, introduce the
> MIN_HEAP_PREALLOCATED macro for preallocating some elements.

I guess it's a nice change, although it's unclear how valuable all this
is.  Being able to remove the local implementations in bcache and
bcachefs is good.

> --- a/drivers/md/dm-vdo/repair.c
> +++ b/drivers/md/dm-vdo/repair.c
> @@ -51,6 +51,8 @@ struct recovery_point {
>  	bool increment_applied;
>  };
>  
> +MIN_HEAP(struct numbered_block_mapping, replay_heap);
>
> ...
>
> -struct min_heap {
> -	void *data;
> -	int nr;
> -	int size;
> -};
> +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
> +struct _name {	\
> +	int nr;	\
> +	int size;	\
> +	_type *data;	\
> +	_type preallocated[_nr];	\
> +}

I think that the MIN_HEAP() macro would be better named
DEFINE_MIN_HEAP().  There's a lot of precedent for this and it's
unclear whether "MIN_HEAP" actually implements storage.  I looked at
the repair.c addition and thought "hm, shouldn't that be static"!

>  /* Sift the element at pos down the heap. */
>  static __always_inline
> -void min_heapify(struct min_heap *heap, int pos,
> +void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
>  		const struct min_heap_callbacks *func)
>  {

It's a separate project, but min_heap.h has some crazily huge inlined
functions.  I expect we'd have a smaller and faster kernel if those
were moved into a new lib/min_heap.c.


