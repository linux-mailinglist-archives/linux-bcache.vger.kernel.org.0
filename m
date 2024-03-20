Return-Path: <linux-bcache+bounces-324-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD95880A01
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 03:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BAC21F23A7E
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 02:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC81101E8;
	Wed, 20 Mar 2024 02:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HtWff0Og"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0295AF9E8;
	Wed, 20 Mar 2024 02:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903414; cv=none; b=fd5MFW+ztTv5AEnXHmgq+GlrvRJWnDbdRAOm53M8j8+U6Avn15xPnsTq0rHMCvzY1PfCQZxJbU7s0d2PYzien5bK1nk8vWMRHi5wMP0xeo+ns7U89ao/5mDi+EANw26iUIWoceJ0DBzzG+B+GhoXk8KQhSylhcYAL5gbpsf/kUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903414; c=relaxed/simple;
	bh=QB2rQUbSStW7n4EoQ3DbUud+Rx1zHt6q2tLkyIr7z1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5OqkoqhekQhd4m6YU2WxuaVtcN6yJiJs9/KSZjP6IDx3xGT9HkHr+7rqKWeWmwtysBrm8PGO+jL3vEw4sLxwEeL1FwyBFER55c9arMuQwZ92iPuO1PCY15hWrimEFrrvJTDFNpnT86xlPV+LJsayoqLasS9oTbQDZYgYwPPaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HtWff0Og; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so2028260a91.1;
        Tue, 19 Mar 2024 19:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710903412; x=1711508212; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qsOh/COH4UX9LhObfLCurk23uZsxjWsmdSmkDaZcSnQ=;
        b=HtWff0OgxBnv31Tt5r1rFJY9SBLtraXOSTsWdfP7o1lCNZghJBDIh2mhHVRDOXFHXw
         6ItZtqrLhXDSXwRHrkF3sQkHBCTUqUNsgkQES8zrPfoW0vqhfUiBPW9g23lOFxazl+/o
         lL4DesuEa9seYvoGhakW4p1P/xCQJ/NrUTlmj9O03cCm+V8Ge82bGVBtCUj3HM1gz7Hb
         9GSR2AkKFfQuD8IJ2X0lvIvlkyFO9k+StKqVr/HGlKID1dnxk3bw/jl2iHTgn3ySsgd7
         bVDSR4OKsS7W0ntPwKt6ujBq8WSdueXXvQ01xDPk3Gg2TLzgRSLrtMh7dWPArBxGt03k
         31+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710903412; x=1711508212;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsOh/COH4UX9LhObfLCurk23uZsxjWsmdSmkDaZcSnQ=;
        b=J2hYYWkBgphE5JeCLz1wnRryWnaX8Ah00hyGz8CBLDyTOx82utaGZ9lJc6gObEG8LN
         94KIgpiCegDhDz0FhzJab8rxdjDWPKbRuBtwaPD2cChgemnhUcXNH5UdcZ5z+SMBCeIi
         bMWio9ojHNE8I7viav/3HcV0cGNPCF+YsLD6m/r0Hj+IY4L2JwHVNUtbMMUPre8IIpue
         uICLwqvKx7Mm2fYEV4aR9zPxH+zmMx2maoRNAv8Ym1ZQPU7CwSRgVQeiXXbWpUBs/lyy
         chzYLpbalAD6QKr4CLPWxR9vyXrrzbY8447uKLLM5ec2J8KeDLyrPk4lpd0qvP6pdYrP
         VJFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWetiGOnm224C3f/JLyCFGDimsY3kebhs0BV49L9QJmlHun/q2jM/Jf2aZNyGrvcn+KdPw+SANy4J6EeEkiNZi9Dxg732tVtH1qJSNDtboRo8CpNi+kjF+/bINh4kKbV6TbS/5dxDw+gE08aW3jvZ1reLFRAWaHdZcKmT6YbTpfJ72ZLRrkNzmr3LuhVvDAQcARYyVtHxt4LG1wZqy2oIAwDLlm40aH0K4gwbVM
X-Gm-Message-State: AOJu0YyRbw6mKnoftjj6V/Y9ncJdsT/umZsO26J8rHTUA2deYaS2HdCe
	lXgVr3TGf1Uix1I3X3c+UgdYXhasmbNjNyGyMJ47o+oWG66kyCkQ
X-Google-Smtp-Source: AGHT+IHON3JpsXmHcnij8cE/0UE7WaDDQfaaHZl92iiO5QXsXfhWhM3/bmKt9lip9VyfiDYzo4pKoQ==
X-Received: by 2002:a17:90a:bf0b:b0:296:db75:c240 with SMTP id c11-20020a17090abf0b00b00296db75c240mr3863223pjs.1.1710903412309;
        Tue, 19 Mar 2024 19:56:52 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id m10-20020a17090a7f8a00b0029c13f9bd7fsm330388pjl.34.2024.03.19.19.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 19:56:51 -0700 (PDT)
Date: Wed, 20 Mar 2024 10:56:47 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Ian Rogers <irogers@google.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
	namhyung@kernel.org, akpm@linux-foundation.org, bfoster@redhat.com,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] lib min_heap: Add min_heap_init()
Message-ID: <ZfpQbxFrTNCmhEVK@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <20240319180005.246930-6-visitorckw@gmail.com>
 <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fW+FvUu8JL+KrtVv5uC++4AW=VhyEOgmdWzpH1mswQNzw@mail.gmail.com>

On Tue, Mar 19, 2024 at 12:51:22PM -0700, Ian Rogers wrote:
> On Tue, Mar 19, 2024 at 11:00 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add min_heap_init() for initializing heap with data, nr, and size.
> >
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> 
> Should this change update lib/test_min_heap.c to use min_heap_init?
> 
Sure, will do that in v2.

Regards,
Kuan-Wei
> 
> > ---
> >  include/linux/min_heap.h | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index c3635a7fdb88..ed462f194b88 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -44,6 +44,18 @@ struct min_heap_callbacks {
> >         void (*swp)(void *lhs, void *rhs);
> >  };
> >
> > +/* Initialize a min-heap. */
> > +static __always_inline
> > +void __min_heap_init(struct __min_heap *heap, void *data, int size)
> > +{
> > +       heap->data = data;
> > +       heap->nr = 0;
> > +       heap->size = size;
> > +}
> > +
> > +#define min_heap_init(_heap, _data, _size)     \
> > +       __min_heap_init(&(_heap)->heap, _data, _size)
> > +
> >  /* Sift the element at pos down the heap. */
> >  static __always_inline
> >  void __min_heapify(struct __min_heap *heap, int pos, size_t elem_size,
> > --
> > 2.34.1
> >

