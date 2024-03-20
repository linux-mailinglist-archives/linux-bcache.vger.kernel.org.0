Return-Path: <linux-bcache+bounces-322-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 871878809FA
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 03:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 162DFB23570
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 02:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E0C101EC;
	Wed, 20 Mar 2024 02:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jx5CodSg"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AD8F9E9;
	Wed, 20 Mar 2024 02:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903118; cv=none; b=D7BDhdkiKhIuAEzQfnSJN9Lo3RWuTRdRA9AVno1mqXAuDx7ZqtDtLczQOI2VlLIZgUEcxuq4B3AJr/qLKqXSZg24hrjU0rL3Lu+l2MhSwsjQNBRrQh+T8f0rHYVF6bzlxMFnIW6QIdQf9fP9gZ/7ccVhsfz9nRbdOgKXY3XCgaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903118; c=relaxed/simple;
	bh=Ozvz96oEDbbGhiLAGb3pU679lIZRAnAiVuKChCLc13g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIjp+fHyHXjTCcKQxlJD8yFJj7CXUaBEA8dbi9d60n02ikOXI8IM03j1SNdSBQBo10ghGqWgSqoluFk/4phAKWvCshT4m4O2KvYllRG/hTkS5WKt4m9PKuwBppm4n7F47e/lKCgYWtPrvcGTSD/nT5kN0DxF9huZhKyM/42O5ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jx5CodSg; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e696233f44so1039677b3a.0;
        Tue, 19 Mar 2024 19:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710903116; x=1711507916; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tOqBNIYKiH/8hqRbBxGjJO8n4CKUboE+5yISgprs/oE=;
        b=jx5CodSgJwe7HQW95qk1PgiS8Rdg47K6SX8JIln4VkewthS+OEQWMOuQ3e4yyRX5NS
         TcH1bt5SfsYgCbwrxW8qM7SrdihhvoVkgtC8DffO7hnQnhyBb96MUWz7j6m5Adac11qD
         /UfkTkfJSyvV4sKMNflNlpBQJnCdpxa6X4My/H8L+a1N8ca6wjXeV85Ca9DoLhcZce/C
         /AOL6Dcd7Lm23Nk62a9E279MrxLSGFqC3TP/v7wjpRWRfuvvCb6PKOrplsXw9TJ6PwCh
         fJPrjH//S2eZgRQz17V7fnxbN4l/RG5oPStN3oPiqUTG2N52sXQ+/o2N7N0AOLEBGEIY
         dCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710903116; x=1711507916;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOqBNIYKiH/8hqRbBxGjJO8n4CKUboE+5yISgprs/oE=;
        b=Q0Elpw8g+MINpnHt65kc5UUFXH1xQgCJTLz+XsCKlH1niU6uUiy8cNeXzDM8J2wJcB
         ASqKOAeox/saBmPy5Ws+DWFILOddt02wG66VFNvEHALNTTYaqQvzCyGUbvOv4FVQeV97
         oy9CW4L592Wc6ld3mBV3h7AkQdaiCU7w4Cxi9asBXUZ6itxO9sjpvGIb3hT8Pv7Om7/G
         VrLhzldYHQ6FKA2X2LbfOnlfYhuGhCvG2Wa8PgTZMx5svrhqasdb4gJkvP4TS42U+Fg1
         GA0zm0AZXsPu8OqFDdXJG8lZDyFDNnRKLBVgyoKhP34YVnl8HKhasmzVT6Y82DrMYBBc
         uiYw==
X-Forwarded-Encrypted: i=1; AJvYcCUIEgtGJ7rHl7unY5I2Xdzr5XtS8DkLF2ntL/dL2QAeBMpObTpowb5LLOGPEV9FfasGZmx9yh1uwQEESN6nK3ZxCXzyIHQeYtsKHfFKMIU2HU3QK8libypyiiERHLY2/8EXcdbGZbNrg2IQBgbc2SIOqFg2lJ5A1F3i6Ty6nwwIsfg1ue3dgCU4ya9ED/v8RmEccoUR1LfDUpr7FWIpltzbHp3r1dYRDYVzs+Qf
X-Gm-Message-State: AOJu0YzvOCHssPu32lbk4rXLiNo2DT2Y8vnkibAngcarL2HojoZWisV0
	Deu74YTMTf3mgGpLAd+3WQFFUP7SNCJgzB62JX6RIBhuVFNsvd+8
X-Google-Smtp-Source: AGHT+IFLF+sW1wqHw8Op+WICxDqpiWGU83Qoyf5GxbFCm3NED9V/egFahqM55WaQWsdQczbNJRdB8w==
X-Received: by 2002:a05:6a00:9a5:b0:6e7:4ac1:7f9 with SMTP id u37-20020a056a0009a500b006e74ac107f9mr2866611pfg.0.1710903116342;
        Tue, 19 Mar 2024 19:51:56 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id jw2-20020a056a00928200b006e703e0e2f7sm7105871pfb.194.2024.03.19.19.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 19:51:55 -0700 (PDT)
Date: Wed, 20 Mar 2024 10:51:51 +0800
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
Subject: Re: [PATCH 12/13] lib min_heap: Add min_heap_sift_up()
Message-ID: <ZfpPR1gRGnMwtdVC@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <20240319180005.246930-13-visitorckw@gmail.com>
 <CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP-5=fVcBAxt8Mw72=NCJPRJfjDaJcqk4rjbadgouAEAHz_q1A@mail.gmail.com>

On Tue, Mar 19, 2024 at 01:12:18PM -0700, Ian Rogers wrote:
> On Tue, Mar 19, 2024 at 11:01 AM Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> >
> > Add min_heap_sift_up() to sift up the element at index 'idx' in the
> > heap.
> 
> Normally sift up is used to implement the min heap but isn't part of
> the API, eg. there is a sift up in min_heap_push. Should min_heapify
> be renamed to min_heap_sift_down to align with this name?
> 

Sure, I can add a patch in v2 to rename min_heapify to min_heap_sift_down.

Regards,
Kuan-Wei

> 
> > Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> > ---
> >  include/linux/min_heap.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> > index ce085137fce7..586965977104 100644
> > --- a/include/linux/min_heap.h
> > +++ b/include/linux/min_heap.h
> > @@ -199,6 +199,26 @@ bool __min_heap_push(struct __min_heap *heap, const void *element, size_t elem_s
> >  #define min_heap_push(_heap, _element, _func, _args)   \
> >         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_heap), _func, _args)
> >
> > +/* Sift up ith element from the heap, O(log2(nr)). */
> > +static __always_inline
> > +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_t idx,
> > +               const struct min_heap_callbacks *func, void *args)
> > +{
> > +       void *data = heap->data;
> > +       size_t parent;
> > +
> > +       while (idx) {
> > +               parent = (idx - 1) / 2;
> > +               if (func->less(data + parent * elem_size, data + idx * elem_size, args))
> > +                       break;
> > +               func->swp(data + parent * elem_size, data + idx * elem_size, args);
> > +               idx = parent;
> > +       }
> > +}
> > +
> > +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> > +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _idx, _func, _args)
> > +
> >  /* Remove ith element from the heap, O(log2(nr)). */
> >  static __always_inline
> >  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t idx,
> > --
> > 2.34.1
> >

