Return-Path: <linux-bcache+bounces-325-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 082F2880A08
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 04:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49D431F23B05
	for <lists+linux-bcache@lfdr.de>; Wed, 20 Mar 2024 03:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B7E101E8;
	Wed, 20 Mar 2024 03:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gMpbKCiy"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B9E1364;
	Wed, 20 Mar 2024 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710903694; cv=none; b=mdHw0MW3atEFZ4re8HWYV7Q5lEP5wIGx1Gbc1OfW7X1e84nUEPLXq4s5gVvU08t0TinnqZoecjyYTcO+GE2wZ35DgFpZCmsl5JMr+opXVrAKz2fspsBPvdoZmznVMSy3GAardHMk+pxovcJcYRKA2CXIWPXptvL2YOf8J0jkys0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710903694; c=relaxed/simple;
	bh=TyLpdxJTBr3425nDHzYBQd+Ij8cler9kgdT3/QEAlqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NYaeNeY47CNKzkTVTkyLSPojs/6dxfrtdQJOvSSdeIEg/3eW7XvbfkV16fvwi72vrC5AwNdnfvJ3qar6GIVpUH8crdfjYn7oPluBAZbEmZ0p+/krCCPInp2AgsZq+YDayTmP0Rq95aZXA/S9Wy4PaOMQsEB+bghV1Y+hjxMcMAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gMpbKCiy; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-29d51cdde7eso1914173a91.0;
        Tue, 19 Mar 2024 20:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710903692; x=1711508492; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=35rpOMt9N0PQI1HtZYax5BoW4EBNkuuGWd0M4cm/nKw=;
        b=gMpbKCiyshPdSSVFfx2n678ICLyt+DPM4PBWIXRwXcOxTaBuGBg/y+2h05Nqr3H/IG
         yGFSrb7oE/8IWe6/pCXxkqAynVxXrbo+vWUPf4/vysVZxwHsq17IjAkBJXcw5/Hu/3SD
         A2Bd2q32AntyK34r9TUBZ7KgK12QMcgsNZUmhaeF3Km5SdDNgJz7pseaaWrjTlHk7WyR
         xG4sAGh+85DEVl4psS+HTfXbNWYOsYuNdJZAU1b/jfUDKxw4VByfDU/sTWeaBk+440B6
         SVlHNs1uN7g1LBV5Y8BMiNJy8e0M9xHK0hmev782+HPveB3X+Y8KSiKVqkgV8w39veeZ
         vlxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710903692; x=1711508492;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=35rpOMt9N0PQI1HtZYax5BoW4EBNkuuGWd0M4cm/nKw=;
        b=maaDFC4XzeW54jRAfzsId5P4rbFQ/xC69HMdi++lF3wMQvTlPQvc40HqQUGBLvfDHd
         6PvmkMrXla2bh4UMV3Sqm4hWthgcN4nt4UeWjuP/uynpgeJxhf335ao15rRQU73Mkwbl
         DcKhsah1N7hz45ZaTNbm83eBNr0IbY5Wj0xpTA/HENfC9i6O8qYzt+vv/OqZynjS3rrn
         1d6Hj/UrIxhryIjn5c6EowLtryjljBFa55STScqFiQq7P1HNnZ7dGCS7fYY9TCS/OmAL
         SVq34w/2o9GIHxmhansoq6aQFkHmy2hqRP7pyp47K8WAW9foy12BLO9NDPzjM6YqCITb
         xYRA==
X-Forwarded-Encrypted: i=1; AJvYcCU6rVn9uCwiLKEK8zODdaN/yV1P/WUJEim1x1DVVls0So1BA5swKjiJ9umR+RSotSnrhEcWRFk6QLMtB4P+WTO3hO7B9QxFQdXMTv+PC4BmnOMfq3b37QKCwKS9mrO/aJR/pHRpiVN36BMnvVPgVvVYF+6Am0dYtjIva0nb2mWXtNkeLF4pJm26OZtt4MDiM4JP9Q5ZL8epI5O1z/TzNdkf4tM/00K5ZnrSYIWk
X-Gm-Message-State: AOJu0YzE3To3T9KP4y9W19Q/KYLqGGaAbODeQG6fQVXWAdf7zQlzzyQu
	EFNgrylhaZVSHF+hg0STer5ta0MS/oElx3si5xCWlUdoDyKFLF+H
X-Google-Smtp-Source: AGHT+IE2pZ+9Hs3pLB7GNfVXiBAJR9GLVUQZAmgXsl3JRbC6bSvpked11TQIwgYq2A8lQ95xjs/DLg==
X-Received: by 2002:a05:6a20:7f8f:b0:1a3:4721:ded3 with SMTP id d15-20020a056a207f8f00b001a34721ded3mr4617995pzj.1.1710903692352;
        Tue, 19 Mar 2024 20:01:32 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b001db2b8b2da7sm12206955plk.122.2024.03.19.20.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 20:01:31 -0700 (PDT)
Date: Wed, 20 Mar 2024 11:01:27 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] treewide: Refactor heap related implementation
Message-ID: <ZfpRh1pcab4PFLiw@visitorckw-System-Product-Name>
References: <20240319180005.246930-1-visitorckw@gmail.com>
 <4t6kkvswhacphbjloh3fps7twqp5d3wgxv7yrkvthb5u3uzaoe@6pf7mnvsv3rm>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4t6kkvswhacphbjloh3fps7twqp5d3wgxv7yrkvthb5u3uzaoe@6pf7mnvsv3rm>

On Tue, Mar 19, 2024 at 06:12:17PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 01:59:52AM +0800, Kuan-Wei Chiu wrote:
> > Hello,
> > 
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
> 
> Hey, thanks for doing this. Can you post a git repo link? I'll point my
> CI at it.
>
Here is the link to my GitHub repository:
https://github.com/visitorckw/linux.git

The patch series can be found on the 'refactor-heap' branch.

Regards,
Kuan-Wei

> > 
> > Regards,
> > Kuan-Wei
> > 
> > Kuan-Wei Chiu (13):
> >   perf/core: Fix several typos
> >   bcache: Fix typo
> >   bcachefs: Fix typo
> >   lib min_heap: Add type safe interface
> >   lib min_heap: Add min_heap_init()
> >   lib min_heap: Add min_heap_peek()
> >   lib min_heap: Add min_heap_full()
> >   lib min_heap: Add args for min_heap_callbacks
> >   lib min_heap: Update min_heap_push() and min_heap_pop() to return bool
> >     values
> >   bcache: Remove heap-related macros and switch to generic min_heap
> >   lib min_heap: Add min_heap_del()
> >   lib min_heap: Add min_heap_sift_up()
> >   bcachefs: Remove heap-related macros and switch to generic min_heap
> > 
> >  drivers/md/bcache/alloc.c      |  66 ++++++++----
> >  drivers/md/bcache/bcache.h     |   2 +-
> >  drivers/md/bcache/bset.c       |  73 ++++++++-----
> >  drivers/md/bcache/bset.h       |  38 ++++---
> >  drivers/md/bcache/btree.c      |  27 ++++-
> >  drivers/md/bcache/extents.c    |  44 ++++----
> >  drivers/md/bcache/movinggc.c   |  40 ++++++--
> >  drivers/md/bcache/super.c      |  16 +++
> >  drivers/md/bcache/sysfs.c      |   3 +
> >  drivers/md/bcache/util.c       |   2 +-
> >  drivers/md/bcache/util.h       |  81 +--------------
> >  drivers/md/dm-vdo/repair.c     |  29 +++---
> >  drivers/md/dm-vdo/slab-depot.c |  21 ++--
> >  fs/bcachefs/clock.c            |  53 +++++++---
> >  fs/bcachefs/clock_types.h      |   2 +-
> >  fs/bcachefs/ec.c               |  99 +++++++++++-------
> >  fs/bcachefs/ec_types.h         |   2 +-
> >  fs/bcachefs/util.c             |   2 +-
> >  fs/bcachefs/util.h             | 127 ++---------------------
> >  include/linux/min_heap.h       | 180 ++++++++++++++++++++++++++-------
> >  kernel/events/core.c           |  53 +++++-----
> >  lib/test_min_heap.c            |  75 +++++++-------
> >  22 files changed, 565 insertions(+), 470 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 

