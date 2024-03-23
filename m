Return-Path: <linux-bcache+bounces-359-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3245488767C
	for <lists+linux-bcache@lfdr.de>; Sat, 23 Mar 2024 02:53:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93C6F1F2274D
	for <lists+linux-bcache@lfdr.de>; Sat, 23 Mar 2024 01:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D3710E5;
	Sat, 23 Mar 2024 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BNkqt7Dh"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CFA41;
	Sat, 23 Mar 2024 01:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711158797; cv=none; b=RS1imaWx+6WfsuRsqhrj3WVK5PQqqqs0+G09zQd2cB7raaJ1fIRFLuZ3C7IgwuXPRIAoLYbrBx4fTopa4CG3+UvE04mFV8LNj2Y5ABC8+26mBb5Yt8JYCxDIkHC8MUdVwir/fudx8iaQUh1DqJUvyRGds6WkWXZK64seHbOAiOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711158797; c=relaxed/simple;
	bh=aUTXFCFu3rAz7WtNUADGa0nIJgF5aAYmNcf+O0y1ZDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtG7MDnGP8mNtRfXnxutHzoeFcSYrRTEJ4/0ab32zZrVJd0oW5ZctAlBUz/L3czcsraffJyv9ZqblbyulX5vm39+uhCCBH16IuQWs1Bs5onkIBVALadO/IqKXIf9h8m3/2sqbJxjpr/wrjdW63F0fJQ8KXL9PI3UUYbl3JF6RbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BNkqt7Dh; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-55b5a37acb6so515693a12.0;
        Fri, 22 Mar 2024 18:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711158795; x=1711763595; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ih1G9Lq2QipoMXy+VgNWidEhR3T48e5NfyFZpAOMBk=;
        b=BNkqt7DhTRSyzbkhOkmcn0xIdMaZFEPAIlwv2IUeiWRTS/Ukh3Up8XbCtoytn9OhbT
         xfNBZ/zL1AW1iYAv9GyvGQqmdgLbjtEmb0F2/NwVao57p0s+S7QekF4jm+yng7LG5STA
         5PcVlJq6WyxyMNYQCb+nOnBJ8ys/lm+5T8j4s+M5eApwJARU92MMHSHi1v4YgM/v0xHV
         KFjflIP1g8KQO5iAmMFumo6SpUXi/8UUx+p2QE7cm5sPov4AXnuenT2tw6Y6mOrbzMhZ
         Xdh1dD2SmaZKkON93m+bqSJea/1aLQMJgvKc/ziS3zSGYb+YQRXFyOuqpBXWoBizVGFB
         vvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711158795; x=1711763595;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ih1G9Lq2QipoMXy+VgNWidEhR3T48e5NfyFZpAOMBk=;
        b=aMl1w8Gw3/buWSCBVzqVxEHfju+pFPu09FjGBC4v5CLlz+P7bIjHtm9vTjnwb8l18U
         MdKht4Qmk0uU/OkeRtUD48yjFsEgQCy1RJicNympS2cj2oKbIZqF1lImfcpcdss1tiFf
         ju4X3dSIGK1D3CbAFwHMTV+CnkvVe69FYthosjKBEiwtSva+mrjzbieKucl9BMoDn5Ht
         gObMRo/xk4+0/Q9M5+s7V8SktMdG8L5Ltm5HWFDu+HTnGyvWJNHr76rjFxeUym3F3AYW
         dSqrv3IGSVnbrlgOAzUDHyb9gZgNR8ej5PZVqouJzf/qOkFf/wG5y/yNcx1kER6n0Ojo
         REIg==
X-Forwarded-Encrypted: i=1; AJvYcCUAU0vAAuiv51qsKbiYoEnNU4y3eaIFOpgnJdO6HFp2vx5ao4mFBzUGJWAo5CVSTXSLmaqZ/+haHp2MfjFp7a403Y/8VYBKoiUH6IkA+1qdMGoPHuyLIk/EQmq3UaFQy21C95fVZDBLBxRDIcbaluPNQIuS+QrqealfvOEqH3x8wUBgFhXzL4wUfVWVZ4q4s6Z+l5AakxDpI10MXP2vaYO5JOaE2que/5X+xKgZ
X-Gm-Message-State: AOJu0Yxv2kTFLyzCor+pqfDcOAhnEgA4kbV8zrKwedpTTpZwJVdKFwT7
	lE3tzazxvRoBcsHiWByZk9ITgZcJB5+cQeqacyxu055h6vRDJ+Ep
X-Google-Smtp-Source: AGHT+IHJTjayi0fs3/rdLdc75kSxwhCSNIjCz3el8CQ6O8Wg+5iaMSPe+ohLniOuGZLh57+tPlvr/A==
X-Received: by 2002:a17:90a:ba98:b0:29c:7487:43b8 with SMTP id t24-20020a17090aba9800b0029c748743b8mr1232834pjr.1.1711158794474;
        Fri, 22 Mar 2024 18:53:14 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id g7-20020a17090ace8700b002a017061f6esm4463238pju.57.2024.03.22.18.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Mar 2024 18:53:13 -0700 (PDT)
Date: Sat, 23 Mar 2024 09:53:08 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 04/15] lib min_heap: Add type safe interface
Message-ID: <Zf42BA7EMCRI3hik@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <20240320145417.336208-5-visitorckw@gmail.com>
 <iz6wl3twuc72txd4ifxy73bbbfijo3ecy7izw3drsmcb2payeu@b2dusfoqobgu>
 <Zfwgu8+IeH/YqWYR@visitorckw-System-Product-Name>
 <mi3uq4gqvseubfiylslxfrnwupfzopz753md5f53v6brlgiamv@l5bxmctqnz6g>
 <Zf25pSI4p0d5pFXX@visitorckw-System-Product-Name>
 <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gx3skkrp6pfp7ch3dmludzmqrsyncsptzhlvuwqt2abdhcli5m@xsny7x4nkxv3>

On Fri, Mar 22, 2024 at 02:23:26PM -0400, Kent Overstreet wrote:
> On Sat, Mar 23, 2024 at 01:02:29AM +0800, Kuan-Wei Chiu wrote:
> > On Thu, Mar 21, 2024 at 05:22:14PM -0400, Kent Overstreet wrote:
> > > On Thu, Mar 21, 2024 at 07:57:47PM +0800, Kuan-Wei Chiu wrote:
> > > > On Wed, Mar 20, 2024 at 04:56:57PM -0400, Kent Overstreet wrote:
> > > > > On Wed, Mar 20, 2024 at 10:54:06PM +0800, Kuan-Wei Chiu wrote:
> > > > > > Introduce a type-safe interface for min_heap by adding small macro
> > > > > > wrappers around functions and using a 0-size array to store type
> > > > > > information. This enables the use of __minheap_cast and
> > > > > > __minheap_obj_size macros for type casting and obtaining element size.
> > > > > > The implementation draws inspiration from generic-radix-tree.h,
> > > > > > eliminating the need to pass element size in min_heap_callbacks.
> > > > > 
> > > > > let's avoid the heap->heap.nr - darray (fs/bcachefs/darray.h) has a
> > > > > trick for that. All heaps have the same memory layout, so we can just
> > > > > cast to a void pointer heap to get something the C code can use.
> > > > >
> > > > If I understand correctly, you're suggesting adding APIs similar to
> > > > darray_top(), darray_first(), and darray_last() within min_heap and
> > > > having them return a pointer. However, some users are using heap.nr in
> > > > conditional statements instead of utilizing heap.nr for memory
> > > > operations, so returning pointers may not be as convenient. What about
> > > > adding get and set functions for nr instead?
> > > 
> > > No, I mean not having separate inner and outer types. Want me to sketch
> > > something out?
> > 
> > Based on your suggestion, I've come up with the following code snippet:
> > 
> > #define MIN_HEAP_PREALLOCATED(_type, _name, _nr) \
> > struct _name {  \
> >     int nr; \
> >     int size;   \
> >     _type *data;    \
> >     _type preallocated[_nr];    \
> > };
> > 
> > #define MIN_HEAP(_type, _name) MIN_HEAP_PREALLOCATED(_type, _name, 0)
> > 
> > typdef MIN_HEAP(char, _) min_heap_char;
> > 
> > static __always_inline
> > void min_heap_init(min_heap_char *heap, void *data, int size)
> > {
> > 	heap->nr = 0;
> > 	heap->size = size;
> >     heap->data = size <= ARRAY_SIZE(heap->preallocated) ? heap->preallocated : data;
> > }
> > 
> > But I'm not sure how to implement other inline functions like
> > min_heap_push or min_heap_pop if I do that, unless they are rewritten
> > using macros. Also, I'm not sure how to make the less and swp functions
> > in the min_heap_callbacks not use void * type parameters. Or perhaps I
> > misunderstood your meaning again. If you could sketch out your idea or
> > have a better approach, it would be a great help to me. Any guidance
> > would be greatly appreciated.
> 
> No, you're on the right track. To call C functions on different types of
> heaps you have to cast them all to a common type, say HEAP(char), also
> pass the element size as a paremeter (which you had to do previously
> anyways).

The other question I want to ask is, I'm not sure how this relates to
avoiding the heap->heap.nr. In cases where we need to know the current
number of elements in the heap, don't we still need to use the same
method to determine the number of elements?

Regards,
Kuan-Wei

