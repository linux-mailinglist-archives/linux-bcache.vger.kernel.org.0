Return-Path: <linux-bcache+bounces-757-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3A199C611
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 11:42:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D928287098
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 09:42:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3F815852F;
	Mon, 14 Oct 2024 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+JbMNz9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4635B158A19;
	Mon, 14 Oct 2024 09:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898891; cv=none; b=cCtL+dFa7J8SE+cPJZJgKRxn2qRti2traYhCW52JZkoFmOqY1F5ek/7zoOa56f651HnwZVNOJNJ75+h4fT5F3nQW3xS9DiNSKMfXHOhF829rHRIffaYbxu1s+mn41i4DbrmRNf1vfqWGNltD7wYc84KQALJH4OYDY6Cg+sSz+rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898891; c=relaxed/simple;
	bh=fUoNTEfvSq0GSvgYvtoYghMRMAOyjzVsb6fYfyavliI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odTm1qvxzVAC9x1ieSBdAGMPriUunMmOfdFAY2EdrGysWtJoNfeZFES5ttYil0pi1dlvbA1X1qjhTAzjL3hnXT6AKE7njqmlZe3Z//2IRValmonBpAJ9HX26Qj2ozItqmkDfQFKcUJg3VhVNaxjECLOEdBUwQhUopZ9ivVUPEZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+JbMNz9; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3e3dfc24a80so2155348b6e.2;
        Mon, 14 Oct 2024 02:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728898889; x=1729503689; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cnopLGGRHN4ho4J7qxXEPkj6nPnNlpB0jO6Hxh7Gbh0=;
        b=I+JbMNz9wb0nmWcf+a8R4LHG+LzIWKzLfdwUN7mQZudtnn3NnP59PIivLYdFQKrwP3
         Nf1j0QZzZo2hzEgdR5Yj4lx1WYwcskjPT7KmgXeat4FoHumwZmBRQyzGLxD9gtX1Iq8A
         xOoEDq1nD/eVOlqw5R8PsgXTqe7mzoXWQcBlyha/eZW6izj/rJONTZofKI+feXVjQzcP
         AFzxT+Gbn3Sw9CbJ1tt0pXeKAQBXFpqIb/mgoLpFa6nOPrpbYnGEgM/bRSxKwP56bgAu
         VCHN5lL7aHcI7JaReUGyN3rbiZSiLXT/cQpWsRZsKd/L6o5e4uzbXZtN9XWw4aE9Ggn0
         UFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728898889; x=1729503689;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cnopLGGRHN4ho4J7qxXEPkj6nPnNlpB0jO6Hxh7Gbh0=;
        b=Fuf4vCcVx4/+6PUAkBgACrvIdcH4A7ylrhlX91/jfZTPaX36blsec0dJqBGzxzGHen
         B+AXX3p2QO6ATvvVBi4OXp+aYmFe10Zf5m4H6bNnu3tUndyqrVeWaHvlmYkQ4by2R0IA
         0cm/upxPcHmQl6yGdGdR9k2baKR8OtOL+kk4UL9KXDxnCOPjYkRZ5f10JLsZ1lv6pel4
         TCiwWLzrQ4Tq8Q5/4SUv4VZXGsMqqwQ4WV0hTozOVliVbPFwh4sGFIddWDePDqSz4s3T
         69lFLJeXmGAD8dZzcfIzpkAOzoh2u7YCTJUcY2qx6Cs6B32iWaej23oD6n9iPmatmciB
         oqrw==
X-Forwarded-Encrypted: i=1; AJvYcCUsnB94kVprwVIjvl/TibvJIhpYCb0pKUNMHm0m8DF8kvMXeGf4/wQBVCK/SQQ96+s8zAW59AzVdfFc+GbpC7w=@vger.kernel.org, AJvYcCVO0yFRmeER7B61+IOPI0TI3SQBfsqGCFrZpzWUD32ZOudjlKiixEK68I0980aF9Y1TJXeq1yj7fZX7@vger.kernel.org, AJvYcCWEMwgRSoS7GTEeXvHS9n7fG2aYsJrJTRNmG5aldbCusfpafHOnwvhXNW6a5FDaBhhMsffWlbnhoqzh4xke@vger.kernel.org, AJvYcCX7v4xxOfAUdWgad8cy/UV74h1ft2awxq6n99WbKT1ALh93Nzr5eUHxGCG4J2v9ySBhQqVCUdcBrqB48Iw=@vger.kernel.org, AJvYcCXib6Kq3OtNpupoa6dR1fqgcSLgJAzIsz8WKW7itw3/qXms3VdyvhcPToN0aGceVEG4LSkv+UBwG41Ej3o9f7uUsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqufEhK+Zp7T6iTriAWk+cr5jGMSDLGu5/z4yAJmRxYoga82uT
	Gx2i0QlTudFrQH65gRMHP7A8L/MhbyglP59ed6BXq8wb0OTTE4AR
X-Google-Smtp-Source: AGHT+IHoeSOi/8gRIEfx92XexDiMptLlqh1jZyP8IvkieREy/d/trmJ2S/NsZy8dTSlUefXAs7OIeA==
X-Received: by 2002:a05:6808:3c89:b0:3e3:a1ae:6a1a with SMTP id 5614622812f47-3e5c90b5eaemr8267101b6e.4.1728898889039;
        Mon, 14 Oct 2024 02:41:29 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea69c2d9ecsm3389311a12.34.2024.10.14.02.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 02:41:28 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:41:23 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] lib/min_heap: Introduce non-inline versions of min
 heap API functions
Message-ID: <ZwznQzdZsg82KNT4@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <20241013184703.659652-2-visitorckw@gmail.com>
 <20241014081358.GS17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241014081358.GS17263@noisy.programming.kicks-ass.net>

On Mon, Oct 14, 2024 at 10:13:58AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 14, 2024 at 02:47:01AM +0800, Kuan-Wei Chiu wrote:
> > All current min heap API functions are marked with '__always_inline'.
> > However, as the number of users increases, inlining these functions
> > everywhere leads to a significant increase in kernel size.
> > 
> > In performance-critical paths, such as when perf events are enabled and
> > min heap functions are called on every context switch, it is important
> > to retain the inline versions for optimal performance. To balance this,
> > the original inline functions are kept, and additional non-inline
> > versions of the functions have been added in lib/min_heap.c.
> 
> The reason it is all __always_inline is because then the whole
> min_heap_callbacks thing can be constant propagated and the func->less()
> etc calls become direct calls.
> 
> Doing out of line for this stuff, makes them indirect calls, and
> indirect calls are super retarded expensive ever since spectre. But also
> things like kCFI add significant cost to indirect calls.
> 
> Something that would be a trivial subtract instruction becomes this
> giant mess of an indirect function call.
>
Yes, I also learned from reading the lib/sort.c git log that indirect
function calls can become especially expensive when
CONFIG_MITIGATION_RETPOLINE is enabled.

I'm not an expert in bcache, bcachefs, or dm-vdo, but when Andrew
previously suggested moving these functions to lib/min_heap, Kent
expressed his support. This led me to believe that in bcache and
bcachefs (which are the primary users of min_heap), these indirect
function calls are considered acceptable. However, that's just my
assumption — I'll wait for Kent to chime in on this.

> Given the whole min_heap thing is basically a ton of less() and swp()
> calls, I really don't think this trade off makes any kind of sense.

As for your point about min_heap being full of less() and swp() calls,
we could handle swp() the same way it's done in lib/sort.c by providing
a built-in swap function, which would help avoid indirect function
calls in places other than fs/bcachefs/ec.c. However, for less(), it
seems there might not be a way around it.

Regards,
Kuan-Wei

