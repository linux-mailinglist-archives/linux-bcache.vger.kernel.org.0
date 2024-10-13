Return-Path: <linux-bcache+bounces-750-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7A699BCB9
	for <lists+linux-bcache@lfdr.de>; Mon, 14 Oct 2024 01:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CE681F2161D
	for <lists+linux-bcache@lfdr.de>; Sun, 13 Oct 2024 23:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F62F153BF8;
	Sun, 13 Oct 2024 23:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YTezTIT2"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43E51494DC;
	Sun, 13 Oct 2024 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728862034; cv=none; b=fYA3oSn2mecw6x2r58rh8cSaErO+zA13g0FLcvygiP3Nji5d5IQE71RSrf0NOwJ9vqjYoc6g22jphbE8QCh6dUfn63TW8vUVMAyVibmRQqZ9BHOdaW3NTjKNgKi7fDw7NJmLZp2pmKrCjN40MqyRsu8Jy5LecYz8ssXA4Io9wqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728862034; c=relaxed/simple;
	bh=x1AeHO6z+Gq3K+5u3Vu6K8cR4pygOM5cB68LNibQ02Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b5Eo+ojFYaMG6u0qCrD19S6g396FFIJJmobgMsQ8orehN9dmD7Iw0Uqp64Wa4V4odKNnTinW2WMpgVTcvEWWF3FIye6MenZXhh1ht5uEh11Ua8BeXGIwWb00zpOav5bBNgVTgF6DEkfi+CApKt8YRo0NSRGgK6QVwh5p/RCjjVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YTezTIT2; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20c805a0753so29909555ad.0;
        Sun, 13 Oct 2024 16:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728862032; x=1729466832; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2rSKa9+mEkifyzS0w5ryHoMsoCNMgNahi+iBN2veXQ=;
        b=YTezTIT28E1QfTWbiEEBH1yhTUj9JW44KQWmrVNzUkcCssAx7+II5csORfFuig0hk0
         o1hGqKiEcPVZfOnFsqIeALJv90PC23BzFbBnuQgWFKmcDWgO0NdY4iQZrfNLFbFdIEXe
         NTFoNkAWu20kY0QUUkd67CSCx191tDPkVirV0PfoktpNar+z1O8P6oowMPeWDdVhKlw1
         aumavf5VMwXS2yUEYu30jg84vjPYuj6j6WUJwmfrTASAF3V5RwWHO+1TVKy8RxV8APng
         esXJL++Cxyf2uiubJnFPmsCcJb64ShYteaJYDODE5vLCsOsj4TBA+qNDwXRqwh8A7kEA
         E6PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728862032; x=1729466832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y2rSKa9+mEkifyzS0w5ryHoMsoCNMgNahi+iBN2veXQ=;
        b=LkdCAaBCOiEQOSQzzu7umL/HaJN2t2I5jo0iusaeRosY9VhVvmLbBdqYJWL2bT7WP8
         B1+QmCkQhPSBnpvGBTaWQy8yNoI1CsDnFtH5+MOV6ddFwVasRuyRkMdl2yU7V9yg1N/O
         47Z3R4lXOTX9lGmbS+OyZdp1Qi4BLsL5VMTzb2QsYO92TZnZHaxXtyBbL4bSn0wkggv3
         nh/zniXo5yOWeipTbjc9SJYGAfF6SpONoBwSmLu9RNrTJsRAPS9rtNjNnud4cRb3/0lE
         1jJuU9U8QQVIlvLZd+2MBoZMkpN253x9t6fXzhGn+v0ehHRx8tRGaf96QhpXuWyDbFs1
         TBLA==
X-Forwarded-Encrypted: i=1; AJvYcCU/qwkLdk4rUPfJxHSMIJd1X6auoFcARb4dVqSvQZtEUZ2UncM514a7DjHLL6GQCXNvS+Spvjf79g+dyjI=@vger.kernel.org, AJvYcCVGjmZvd1lj6hyor5A9vLDjnuT4ty4Mg+Qg1CBzJDz3DQOWGZEFvLLlB6+DIXwOaVegbi85c64LqbQEZdFY@vger.kernel.org, AJvYcCWpirW6gmBRw964ozcUjmMTfFBWOd180cfC4YD2RPONIM5K00/T7lQyrojKyC/z6PrycIUoJXmpG8XJ@vger.kernel.org, AJvYcCXAkrIoyRnxsbJQGd3xfrxxy0Q+LaQ9/WfH87wCtG91FVStfLskPNBA5mVZ5o+IeLLzfXyd16I+uT24/dFmuTE=@vger.kernel.org, AJvYcCXzeGrP3MRQ4WSf1G5pekKp0cpLKg9NuElqJZmthFitV01h+9eTcfVCbcXMv2MSvWXlkycWfGjmIP0E7zmxVF2CgA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUHxROiwLH7f++Fzq8UBb7R5YrSwQHaRLLiEeLfSC8ib7B+ij1
	xLcKg1Q4dVhWVVZlDAYUg1gbmGu8Wq6DDUap0XWJpsFiyrPw/TkFxyrXdA==
X-Google-Smtp-Source: AGHT+IG9csZOuoI5wdgjpNu6THb+F7nhX6QQINmEa+/VhE4rnsfyxwCbx3kULQGZMbNsshtxsBWiGA==
X-Received: by 2002:a17:902:d4cb:b0:20c:e2ff:4a50 with SMTP id d9443c01a7336-20ce2ff4c5bmr44129945ad.9.1728862031943;
        Sun, 13 Oct 2024 16:27:11 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c312133sm55177455ad.197.2024.10.13.16.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 16:27:11 -0700 (PDT)
Date: Mon, 14 Oct 2024 07:27:06 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, corbet@lwn.net, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, jserv@ccns.ncku.edu.tw,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] Enhance min heap API with non-inline functions and
 optimizations
Message-ID: <ZwxXSje3n6lMTbjj@visitorckw-System-Product-Name>
References: <20241013184703.659652-1-visitorckw@gmail.com>
 <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uisaqjn2ttzhohe3a5qrdw4x6m7rhuoxxuhfoz5szufynuz5fz@4wicz52jydwz>

On Sun, Oct 13, 2024 at 07:05:38PM -0400, Kent Overstreet wrote:
> On Mon, Oct 14, 2024 at 02:47:00AM GMT, Kuan-Wei Chiu wrote:
> > Add non-inline versions of the min heap API functions in lib/min_heap.c
> > and updates all users outside of kernel/events/core.c to use these
> > non-inline versions. Additionally, it micro-optimizes the efficiency of
> > the min heap by pre-scaling the counter, following the same approach as
> > in lib/sort.c. Documentation for the min heap API has also been added
> > to the core-api section.
> 
> Nice, has it been tested - do you need a CI account?
> 
> I'd like to start seeing links to CI results in patch postings (and I
> need to tweak the CI to add git fetch links, as well).
>
It would be nice to have a CI account to test my patches. Is there any
guide available on how to use it?

Regards,
Kuan-Wei

> Coly, there's ktest tests for bcache that need to be updated - if you
> wanted to take that on it'd be lovely to consolidate how our subsystems
> are getting tested; I can give you a CI account as well.
> 
> > 
> > Regards,
> > Kuan-Wei
> > 
> > Kuan-Wei Chiu (3):
> >   lib/min_heap: Introduce non-inline versions of min heap API functions
> >   lib min_heap: Optimize min heap by prescaling counters for better
> >     performance
> >   Documentation/core-api: Add min heap API introduction
> > 
> >  Documentation/core-api/index.rst    |   1 +
> >  Documentation/core-api/min_heap.rst | 291 ++++++++++++++++++++++++++++
> >  drivers/md/bcache/Kconfig           |   1 +
> >  drivers/md/dm-vdo/Kconfig           |   1 +
> >  fs/bcachefs/Kconfig                 |   1 +
> >  include/linux/min_heap.h            | 202 ++++++++++++-------
> >  kernel/events/core.c                |   6 +-
> >  lib/Kconfig                         |   3 +
> >  lib/Kconfig.debug                   |   1 +
> >  lib/Makefile                        |   1 +
> >  lib/min_heap.c                      |  70 +++++++
> >  11 files changed, 508 insertions(+), 70 deletions(-)
> >  create mode 100644 Documentation/core-api/min_heap.rst
> >  create mode 100644 lib/min_heap.c
> 

