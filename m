Return-Path: <linux-bcache+bounces-469-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2CA8CC9B6
	for <lists+linux-bcache@lfdr.de>; Thu, 23 May 2024 01:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 122BA1F216A3
	for <lists+linux-bcache@lfdr.de>; Wed, 22 May 2024 23:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4484514C59C;
	Wed, 22 May 2024 23:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="es04Benw"
X-Original-To: linux-bcache@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDB2146A6E
	for <linux-bcache@vger.kernel.org>; Wed, 22 May 2024 23:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716420793; cv=none; b=DRh81gid5RUcWA0vLSfZIajn+mJsdHj5GnNEDaqFHNVgI8tRMO6aM3000+kkNIWL6iHsxhuVOBefkkUtj/NxPnEIb28m7RZu+AVjp46Krela6HT6rti02hHvgalFCNpLU9sghUwoLLiw65WdR8XArtkZfYDVfYyfg7VZBBZSXyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716420793; c=relaxed/simple;
	bh=NT/ii8eaSJtuJOqeYSgC8cyd1idzt+7Q6oGZaAaQSDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBWZa+7n3pfrHchZL5b7NsoMqKrgyVxiUsstktJTCBAzVQvKgTgPP4WOX+jzWYwpRX/vCAxkQr52F6+eNUoU6p8J1Tv+9ymxrpRggfx9zOce7Rz2Dm9oajW4BQmbDp7RF55mwx+1n3LQwMGlYFPQOugTpqE7eQQK10V/gZzf59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=es04Benw; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: akpm@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1716420789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AJj3qTPEcDcXe8j2iV1Bt2UrJ9C9nF1bY3bOTkAluxo=;
	b=es04BenwY5QAh2vvRy7s4tEAhNY1TxREQPsrLBcXkBFSKNVU2jDJtfmVY78FausPMpkaPB
	pN+YJ3u9px+6D4u7+Q+dVDLDo3yWTv0zYwy63BLkkDmKWRxpU/g8oUx30vWdl9zz+FdU01
	v/sBa0tnymS5K/Rv5z2nifbxXcfmqn8=
X-Envelope-To: visitorckw@gmail.com
X-Envelope-To: colyli@suse.de
X-Envelope-To: msakai@redhat.com
X-Envelope-To: peterz@infradead.org
X-Envelope-To: mingo@redhat.com
X-Envelope-To: acme@kernel.org
X-Envelope-To: namhyung@kernel.org
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: mark.rutland@arm.com
X-Envelope-To: alexander.shishkin@linux.intel.com
X-Envelope-To: jolsa@kernel.org
X-Envelope-To: irogers@google.com
X-Envelope-To: adrian.hunter@intel.com
X-Envelope-To: bagasdotme@gmail.com
X-Envelope-To: jserv@ccns.ncku.edu.tw
X-Envelope-To: linux-bcache@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: dm-devel@lists.linux.dev
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-perf-users@vger.kernel.org
Date: Wed, 22 May 2024 19:33:04 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de, 
	msakai@redhat.com, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com, 
	bagasdotme@gmail.com, jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 04/16] lib min_heap: Add type safe interface
Message-ID: <gch7c2merdegxvqwpbb5ean7uj35tnh62fyviggjglftlfjs3i@jhbnllco5kau>
References: <20240514084724.557100-1-visitorckw@gmail.com>
 <20240514084724.557100-5-visitorckw@gmail.com>
 <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Wed, May 22, 2024 at 04:10:48PM -0700, Andrew Morton wrote:
> On Tue, 14 May 2024 16:47:12 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > Implement a type-safe interface for min_heap using strong type
> > pointers instead of void * in the data field. This change includes
> > adding small macro wrappers around functions, enabling the use of
> > __minheap_cast and __minheap_obj_size macros for type casting and
> > obtaining element size. This implementation removes the necessity of
> > passing element size in min_heap_callbacks. Additionally, introduce the
> > MIN_HEAP_PREALLOCATED macro for preallocating some elements.
> 
> I guess it's a nice change, although it's unclear how valuable all this
> is.  Being able to remove the local implementations in bcache and
> bcachefs is good.

Yes, and now the standard kernel version is type safe. I suggested it to
Kuan as a good starting project, I find (well picked) refactorings and
cleanups are a great place for people to start.

> 
> > --- a/drivers/md/dm-vdo/repair.c
> > +++ b/drivers/md/dm-vdo/repair.c
> > @@ -51,6 +51,8 @@ struct recovery_point {
> >  	bool increment_applied;
> >  };
> >  
> > +MIN_HEAP(struct numbered_block_mapping, replay_heap);
> >
> > ...
> >
> > -struct min_heap {
> > -	void *data;
> > -	int nr;
> > -	int size;
> > -};
> > +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)	\
> > +struct _name {	\
> > +	int nr;	\
> > +	int size;	\
> > +	_type *data;	\
> > +	_type preallocated[_nr];	\
> > +}
> 
> I think that the MIN_HEAP() macro would be better named
> DEFINE_MIN_HEAP().  There's a lot of precedent for this and it's
> unclear whether "MIN_HEAP" actually implements storage.  I looked at
> the repair.c addition and thought "hm, shouldn't that be static"!

Agreed

> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> > -void min_heapify(struct min_heap *heap, int pos,
> > +void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
> >  		const struct min_heap_callbacks *func)
> >  {
> 
> It's a separate project, but min_heap.h has some crazily huge inlined
> functions.  I expect we'd have a smaller and faster kernel if those
> were moved into a new lib/min_heap.c.

good thought - Kuan, want to do that too? Since we missed the merge
window, may as well :)

