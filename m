Return-Path: <linux-bcache+bounces-423-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E648B2DDE
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Apr 2024 02:14:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33D8281FF7
	for <lists+linux-bcache@lfdr.de>; Fri, 26 Apr 2024 00:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08CD37B;
	Fri, 26 Apr 2024 00:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmIrrAPJ"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F9364;
	Fri, 26 Apr 2024 00:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714090473; cv=none; b=SAYWmPpeXKFaFwMwRIyTYFZF8LacUQB6uiEyJl3cPeap/wHXzBFGgPC9UHhAsSTPrwfDmnLs2+IVE5orzrGuwnN+7qzpIs3DcW/D3yzJkFMO5I6adRKKk6vm2sQZTusGnnqNda5MCoCKQnH9Y7wBUdOZomdtrPmr5DY99gTxOpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714090473; c=relaxed/simple;
	bh=BNlz4p2+5Fzq2Xhe9VHkNPnVhu1O/EhyxSF3fvihfqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIccf6wCVQ+Hv6XjO5NQ5uRAOsStR83VEwBr3B/ji0ezGQwlWpRFkdwy9NWZ6eNFTjUptq83jtvfpYAMWLIKV4DmGQoOXfwhVvNcIdneoEUHmGM7dKwJU+XfVBbSwo91yTg839Jwf/rlXvHlSDlTvDRKhRoiVRYkQ06091u11Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LmIrrAPJ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2a2d37b8c4fso376350a91.1;
        Thu, 25 Apr 2024 17:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714090471; x=1714695271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SunWQ9HwSBJxyYvtsaZOJFSGcbd0R6AuBnmBsgWqMEg=;
        b=LmIrrAPJ0S9CeYUZtoDl1JDMAS/eCBukVS1N24OHOWFmzGoItNHVuw1hLKT+djx+aU
         eNBHzwFeW+xJRw3ddsTHAAgvhvTMuJqsmcwN/g4Al6oMAKya/qXr6QcOB0X3rvxd+Glf
         y/UFdYM6wUWU3giWdfJYQnuwxDvpLuWFOdIFphIdyACltAAaD0kQojUvNI9qiiqmIYWK
         axhzQr1DhA7I0msN3IitOwvuMdiWg6NzBof9RDlOjBH8GueM2NdBNS38XdkZl/arQmZS
         SPv9Tl4qW6MSRLY4Dzv/vIdtzWh5NGkIBqk9u0VcjD/5KO4UOYd2Di4ZcDRClvKN1BMz
         kJ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714090471; x=1714695271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SunWQ9HwSBJxyYvtsaZOJFSGcbd0R6AuBnmBsgWqMEg=;
        b=AP1x2bXaoC/rhz8LItYKY1vfOyKEr8/c+sgNtv2RRXszNRiyYg9St9LPZp/ym5nHdt
         Qu0StSmH3ZepEGX1Uay/6Ip1jIACCo7NWnUOReNucWeddEC2MM0Xb9V4HT/STcb0owhP
         zki37ygAee/kXxRK7TmHf+MW5PxGSUqKHhpOJkMVNT7OM0MrDxbYcRHA0EE/MQJvG4HS
         fntYgXpTzXVQPh4LmxLMg170FM25XmODt6TGv64+rubKGMGGmL+AdNF9py8R66mxEpR6
         AaloB6mfCbEUh3nWFtJRUgh8CIwwNQOjgcvctqVQ4Z27jEwnxSH1QTcOtw73bvVlXKnL
         SN+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwfqdMN/XB3MClvy9EJiYImP7GUvRf8V0p1QRqz+Z/7ZqboR/1MeULnclVcGTDZdeWMytyweHE2PU3tN8+28KcY1D5umwTkImRY6+wLDvvcI0gZNwu1WlCakFe9W4K6H4cXCxaLf1pN8czQWEpUqlVNcaUl0VXg4j3UeeWokjm8IRUkU91S9X4tFwWOWu1yG+d2u4pHIGNCplpAI9xZdhJHZNnJNwv/4DLbqb/
X-Gm-Message-State: AOJu0Ywxsl6pPknSHuzfHZ1oaCPjH1zwVtoIwzSt5OE8PY7U3JelhMe4
	pgCZVEaAw4G30q8/QV+RSYWHnSSR72l180YUtbw8qjUsJzGbCpra
X-Google-Smtp-Source: AGHT+IFhfYJmlZYX3JCY6d+4vobjo7z2a69ChmkVLT1hXUmpPBdCX2AmDP1EgXQSKYYW9pR9OczIEQ==
X-Received: by 2002:a05:6a00:880f:b0:6ec:ef1c:5c55 with SMTP id ho15-20020a056a00880f00b006ecef1c5c55mr1525090pfb.2.1714090471464;
        Thu, 25 Apr 2024 17:14:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id gm8-20020a056a00640800b006e740d23674sm14228279pfb.140.2024.04.25.17.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 17:14:30 -0700 (PDT)
Date: Fri, 26 Apr 2024 08:14:25 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, colyli@suse.de,
	msakai@redhat.com, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v4 00/16] treewide: Refactor heap related implementation
Message-ID: <Zirx4fCA8C6/hz8m@visitorckw-System-Product-Name>
References: <20240425141826.840077-1-visitorckw@gmail.com>
 <txga7kntgxylhmxqkzs3rdgmnjai2ftlstdezltkapdctn3ju6@ndyytejfyoc2>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <txga7kntgxylhmxqkzs3rdgmnjai2ftlstdezltkapdctn3ju6@ndyytejfyoc2>

On Thu, Apr 25, 2024 at 04:54:54PM -0400, Kent Overstreet wrote:
> Hey Stephen, I think this is ready for -next.
> 
> https://github.com/visitorckw/linux.git refactor-heap-v4
> 
> Kuan, please add my acked-by to the bcachefs patch as well.
> 
Acked-by tag has been added to the repository mentioned above and
pushed out.

Regards,
Kuan-Wei
> 
> On Thu, Apr 25, 2024 at 10:18:10PM +0800, Kuan-Wei Chiu wrote:
> > This patch series focuses on several adjustments related to heap
> > implementation. Firstly, a type-safe interface has been added to the
> > min_heap, along with the introduction of several new functions to
> > enhance its functionality. Additionally, the heap implementation for
> > bcache and bcachefs has been replaced with the generic min_heap
> > implementation from include/linux. Furthermore, several typos have been
> > corrected.
> > 
> > Previous discussion with Kent Overstreet:
> > https://lkml.kernel.org/ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu
> > 
> > Regards,
> > Kuan-Wei
> > 
> > ---
> > 
> > You can preview this patch series on the 'refactor-heap-v4' branch of
> > the repository at the following link:
> > 
> > https://github.com/visitorckw/linux.git
> > 
> > Changes in v4:
> > - Change struct initializations to use designated initializers.
> > - Replace memcpy() with func->swp() in heap_del() due to issues with
> >   set_backpointer in bcachefs when setting idx.
> > - Fix an error in ec_stripes_heap_swap() where
> >   ec_stripes_heap_set_backpointer() should be called after swapping.
> > 
> > Changes in v3:
> > - Avoid heap->heap.nr to eliminate the nested types.
> > - Add MIN_HEAP_PREALLOCATED macro for preallocating some elements.
> > - Use min_heap_sift_up() in min_heap_push().
> > - Fix a bug in heap_del() where we should copy the last element to
> >   'data + idx * element_size' instead of 'data'.
> > - Add testcases for heap_del().
> > - Fix bugs in bcache/bcachefs patches where the parameter types in
> >   some compare functions should have been 'type **', but were
> >   mistakenly written as 'type *'.
> > 
> > Changes in v2:
> > - Add attribute __always_unused to the compare and swap functions
> >   that do not use the args parameter.
> > - Rename min_heapify() to min_heap_sift_down().
> > - Update lib/test_min_heap.c to use min_heap_init().
> > - Refine the commit message for bcache and bcachefs.
> > - Adjust the order of patches in the patch series.
> > 
> > Link to v3: https://lore.kernel.org/20240406164727.577914-1-visitorckw@gmail.com
> > Link to v2: https://lore.kernel.org/20240320145417.336208-1-visitorckw@gmail.com
> > Link to v1: https://lkml.kernel.org/20240319180005.246930-1-visitorckw@gmail.com
> > 
> > Kuan-Wei Chiu (16):
> >   perf/core: Fix several typos
> >   bcache: Fix typo
> >   bcachefs: Fix typo
> >   lib min_heap: Add type safe interface
> >   lib min_heap: Add min_heap_init()
> >   lib min_heap: Add min_heap_peek()
> >   lib min_heap: Add min_heap_full()
> >   lib min_heap: Add args for min_heap_callbacks
> >   lib min_heap: Add min_heap_sift_up()
> >   lib min_heap: Add min_heap_del()
> >   lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
> >     values
> >   lib min_heap: Rename min_heapify() to min_heap_sift_down()
> >   lib min_heap: Update min_heap_push() to use min_heap_sift_up()
> >   lib/test_min_heap: Add test for heap_del()
> >   bcache: Remove heap-related macros and switch to generic min_heap
> >   bcachefs: Remove heap-related macros and switch to generic min_heap
> > 
> >  drivers/md/bcache/alloc.c      |  64 ++++++++---
> >  drivers/md/bcache/bcache.h     |   2 +-
> >  drivers/md/bcache/bset.c       |  84 ++++++++++-----
> >  drivers/md/bcache/bset.h       |  14 +--
> >  drivers/md/bcache/btree.c      |  17 ++-
> >  drivers/md/bcache/extents.c    |  53 ++++++----
> >  drivers/md/bcache/movinggc.c   |  41 +++++--
> >  drivers/md/bcache/sysfs.c      |   2 +
> >  drivers/md/bcache/util.c       |   2 +-
> >  drivers/md/bcache/util.h       |  67 +-----------
> >  drivers/md/bcache/writeback.c  |   3 +
> >  drivers/md/dm-vdo/repair.c     |  19 ++--
> >  drivers/md/dm-vdo/slab-depot.c |  14 +--
> >  fs/bcachefs/clock.c            |  43 ++++++--
> >  fs/bcachefs/clock_types.h      |   2 +-
> >  fs/bcachefs/ec.c               |  76 ++++++++-----
> >  fs/bcachefs/ec_types.h         |   2 +-
> >  fs/bcachefs/util.c             |   2 +-
> >  fs/bcachefs/util.h             | 118 +--------------------
> >  include/linux/min_heap.h       | 188 +++++++++++++++++++++++++--------
> >  kernel/events/core.c           |  29 ++---
> >  lib/test_min_heap.c            |  75 +++++++++----
> >  22 files changed, 522 insertions(+), 395 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 

