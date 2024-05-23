Return-Path: <linux-bcache+bounces-471-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 316DC8CD72E
	for <lists+linux-bcache@lfdr.de>; Thu, 23 May 2024 17:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54D811C215C6
	for <lists+linux-bcache@lfdr.de>; Thu, 23 May 2024 15:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9741175A5;
	Thu, 23 May 2024 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fz1fx/uY"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A82414A82;
	Thu, 23 May 2024 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478514; cv=none; b=ZqBreL+lR9kquaCH7ZEzV5fswhC+/75+KTvg3Cm6ZbBaq6ipOSMEB7AVtf4x1BXVFah/R6cguc9mFtBDTpyvONmCdvm1PNflkrdsdxCxS6YepbBDkOtwjRV/ayTO7t6MafE9iOnlIAySxoEEdMTjlT65nncORJ5KO2QAO8PqDx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478514; c=relaxed/simple;
	bh=wdxKfjjLUk84a/tGuQYvrmqaFy9ZW/mj1pQCdE0YSj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HCgDoHLD2fwlwl2802X3HgYauzgH0+Ms3DrsVV9VazdfveLdlPn6pfdPKrvimC1rFKKOYi47C+U2+UxDXVzTMMSH282nI2eGQ5stGsch4/oJg6Tc8jhEwat5StryCg+scC+gC78gWZqCZLC6UuBamgnxY9kLwAe1s5I0HqlfLjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fz1fx/uY; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1f34d742ff8so417895ad.2;
        Thu, 23 May 2024 08:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716478511; x=1717083311; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C2MfGbJLhBeGeMBRL5E+PaOkpQOo7Wuw1ls15958h4U=;
        b=fz1fx/uYAT0SwqgncFiaqJSzHZvBn6gRkoTEsVfj1zH3KMcwq9rrEimtLgt8gID4/Z
         AaXGXeQ+n9d98T5QYG0duSrUC9W47d0gsQHTKaZuKEIBMwN5UfpfZzKpEmP8rMz4rHTs
         PtxZmo5okn6GuK/Vr0OYLX9hNVv8y/tO9nnYNlcHE1WFwCZdIgKRyhVD0GCIa4xoaec3
         88xKudIloBIa6PUAJzm9HeGaOp+477/PD3gKIuZ4dg6U28BBwfrob/fQr5HEDEdLZvBc
         nqBMmGu6VceLFx0AAJO61kyY/uWzOAjmpo6NApTLy0rCz34FvKpruGXUWC1Sy9KskEsO
         Jhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716478511; x=1717083311;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C2MfGbJLhBeGeMBRL5E+PaOkpQOo7Wuw1ls15958h4U=;
        b=oiK11xppNWxk+FKfgbaHcgiciLDFszXwVrcmkLDuXHBQCuRl0RW3b7lmmBk6n1+HAT
         4wheODgNWe1+a1opv9ZKXJhNJw6chuMy8vKfX6qgfHSVyAlnRHla4zmQRMn4CjwoZtrF
         kHZy7vPKrv6DEpap9T88+x1JZ7Q9j/pqoZOqj0uadOR0TauZzno87S1vDigZx4N3ltw2
         csb5FDdAswNLig4j4Bk31S4M2UyN+rf6IRrRHH74aSeLSOg1eefyxQ6qxAfzFOyux8YV
         +s3lPBMPGYVyNrI6W0+sWVg1x+B7mlBqm6YiO3+krmU4vJRRji3KcgmiPzJ9AyDpiysT
         +JHg==
X-Forwarded-Encrypted: i=1; AJvYcCUb6y1h8Icg2viG00BrFdVS34ovF07rFrK2EZl1pPzL0h5C9BupQXbe1V1ZDXyx4Ypg0vCcXbhaZVOk2zucbs0m3n+Zr6KOTM4eSEoAhDROSG00iYMzyF+bolrMW6J0UBa9jewUR2L2oiyvAQD9Iza0CxyAcJyTLvXygFd1GG7V96423cRjviL3a2jyROlanip/2yOiVJdTfKXD+Py50yjb4Ubpoio17SBqjMcL
X-Gm-Message-State: AOJu0YxAgiD4MsP0PuA9bEBHzRcHmsIBivLxR5asakwwPnGxrhAVEPqi
	fJqRh5/UDXhkGFEtL9tj1SKyYGTzuW8vDkb6f02LVZvq+c+FVAKU
X-Google-Smtp-Source: AGHT+IHkI5Ag6ABIYhzsCAV6jWiQywV28rXKTT8C0iDOse037T9i6PohK5hkxxdwVCFRk3QopDFa2Q==
X-Received: by 2002:a17:902:c94d:b0:1f3:453:2c82 with SMTP id d9443c01a7336-1f31ca5f2afmr56496085ad.4.1716478511499;
        Thu, 23 May 2024 08:35:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f3044a81c9sm69555845ad.43.2024.05.23.08.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 08:35:10 -0700 (PDT)
Date: Thu, 23 May 2024 23:35:05 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, bagasdotme@gmail.com,
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [RESEND PATCH v5 04/16] lib min_heap: Add type safe interface
Message-ID: <Zk9iKUhv7Oew6Lsh@visitorckw-System-Product-Name>
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
>
I will update this in the next version.

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
> 
Moving these inline functions to lib/min_heap.c to reduce kernel size
seems reasonable. However, I saw Ian mention that perf event's min_heap
is used during context switches. Since I'm unsure about the performance
impact of making these functions non-inline, I'd like to discuss this
further before actually moving them to lib/min_heap.c.


