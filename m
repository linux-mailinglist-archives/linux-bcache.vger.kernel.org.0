Return-Path: <linux-bcache+bounces-404-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 577528AE11E
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Apr 2024 11:35:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BD011C21BCB
	for <lists+linux-bcache@lfdr.de>; Tue, 23 Apr 2024 09:35:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A440E5914A;
	Tue, 23 Apr 2024 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBYT+9p1"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517B021345;
	Tue, 23 Apr 2024 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713864933; cv=none; b=bvAwTymFBc/41gGU41T6AQAnK8QSIObJeaSsDX44uVquJuPQO4HDFWSrH/WyyrlbQ9YeD2tNLxI0eP5FcTnSCI2Lkn7i7FtXmayh6sgZNDNpoVEj8gP0tiCUoaHDBFROQEii59ibx5ieyWMN6QbfmohMg3fi8f9lbw7XM9o3vhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713864933; c=relaxed/simple;
	bh=lmZDN1auKETKyKSuC5BzhmI7ealw0CEjcswaHx2FnzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wd45Yb6VLbn5UEDgpGYpbp1i1Gus8zXZD7PFfH1MjLcQKTGoLJU8L/tZeOcVEXS7q/WFze9W1NvcGFfeJfrlkCE8ObZsJP1FgkvKhFa2d8VmZ+jeQ+SvxdUe2JWxo3lU0pKrIiY9y7dVX5KFvgwrIph0U+LPA/ggcF6Bv+SOwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBYT+9p1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2aa0f3625aeso892242a91.1;
        Tue, 23 Apr 2024 02:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713864930; x=1714469730; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oPmiyJcchVI8HLZhgn5CHh5M2cAjQnCFOUQBbNrRH7o=;
        b=aBYT+9p1YN9vqbo3GjxujTWfoIfCbV+ZN0fnHsZsBQMkpu8ufZPRS8I58ahJgQbn1t
         cRxVdM5eb5TsvnvFskbT9OUcdVK6jezRmRnLzwXeOCErAkAoKRFEEWE7ziYtRKJy7f2b
         g3JMNGFqYeuR8TH6J+s167h1eMudVlFGKjYFzvImksmV+875D/Vz4TjjE1igEEcPYGV7
         74BB6agGZbWARQaR4PymYfFzGc5oO9O35K21PUUiG0MPuJdBBFjR2HhViAZ5w5weO8nS
         oxd1wSUg1/rm0ZkLdq/EaCGTXpcR6r6ioVYA6eE1osCk8pqQSVtb9+sGSopRl0McZb+d
         lZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713864930; x=1714469730;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oPmiyJcchVI8HLZhgn5CHh5M2cAjQnCFOUQBbNrRH7o=;
        b=vtCX8jUqR074A3Q8Rgf/FrDOF0ew1ST4Of4G1GWtJeUBmPRfWZRZZM2sJ7FTVxt/6S
         0ncRmrXq+E1/ilre+8b6G7bgmWqTDI5EiuRXQotcJgmoTY5i3Xf1zhZkGr3xw9pZiNnZ
         FjdKhdXLsPkF5jqralOd4labThv117o5a9mDbfx0gdT8nfX+fbGzSj3CDTyZL+4k0RYN
         ZEbvaw9PDLPQXb2yYcDMd9pq5fUu9ib28y9+iGqfLAE8lSPzFiIpcWxu/TjMIZETw9dw
         TmvNcF0KbIQUPrp3SbXucbXuOzA0w86G6l0kWHukIbCXp9OmU5XGK2MYSf2VBo4d2zfJ
         dFGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYQlKjT66i4dJibo+hK5PSwDOeovbvh2VpbCobjemnboAae+o+r19zw+Iu4lPOrw0RBnAXVI1Xb2xeQzlLko84zAnBXdVd8RBWjeB5ZIJkRI1pyr/1AgyMn6aUz8KDSHQplAJHZSjuPDlKyVJsu1JEBuiQ/KAHYso6t5tClvCeu+aUKcG0ox7dq7OnEFJbhWFjjnQ1v+9Mc2xNBgWkaWFSzelLU/4rER3V9Hnd
X-Gm-Message-State: AOJu0YxjLQt47BxnCngTwUam/tKkQONO+dxF/fRZ3k90uySmeIev1m9H
	EX/H5sVV64z5pem2Ggc503YZF/TmpmQKHrdraboeeKIizNDQ10+X
X-Google-Smtp-Source: AGHT+IFareQ3oNnnfoiJvzFkOIOjDeBgcWDV4pURl0CaslgJ7AnZPPu6SxQPxRszdJm0n18LAg9KWw==
X-Received: by 2002:aa7:838f:0:b0:6f0:6d93:2089 with SMTP id u15-20020aa7838f000000b006f06d932089mr15098329pfm.1.1713864930443;
        Tue, 23 Apr 2024 02:35:30 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id fq5-20020a056a0060c500b006ed2709ada6sm9204624pfb.65.2024.04.23.02.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Apr 2024 02:35:28 -0700 (PDT)
Date: Tue, 23 Apr 2024 17:35:21 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v3 00/17] treewide: Refactor heap related implementation
Message-ID: <ZieA2aabHr7vF2a4@visitorckw-System-Product-Name>
References: <20240406164727.577914-1-visitorckw@gmail.com>
 <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asgiyolfhg2sfwarkrexbcx3y6mborcxklnncz4cn2g6ffubku@vhoumzvwdpzp>

On Mon, Apr 22, 2024 at 04:20:28PM -0400, Kent Overstreet wrote:
> On Sun, Apr 07, 2024 at 12:47:10AM +0800, Kuan-Wei Chiu wrote:
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
> 
> We need to get this into -next, where are you at with v4?

Apologies for the delay; I've just returned from a long trip to Seattle
where I attended the Open Source Summit. After reviewing the bcachefs
CI testing results for v3, it appears that my patch has caused some
Kernel panic and soft lockup issues in bcachefs. However, I haven't
been able to reproduce these problems in my qemu testing environment,
so I'm unsure where I went wrong to cause these errors.

Regards,
Kuan-Wei


