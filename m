Return-Path: <linux-bcache+bounces-237-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D098356C0
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 17:56:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91FEEB21952
	for <lists+linux-bcache@lfdr.de>; Sun, 21 Jan 2024 16:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79426376F1;
	Sun, 21 Jan 2024 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jnz1UWRN"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A18C22069;
	Sun, 21 Jan 2024 16:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705856157; cv=none; b=dEtPuQkny7HvGvohLd3D3HVQDIVlATGNajj458U3Ge99Xy9Mk+z/CvUT9zuNCJfTvVFwPLgY6s+c9EqKu7AJLFqhxim8X6a3/dHmy2AV3oqXZrkWuDsPPwLC0x9a62MIw2QncGBwy5RzYHm6Slao2fnnqIPR8Y8IiLeVt/DrXZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705856157; c=relaxed/simple;
	bh=kumixTM6360WqBwZFdhho8/NoG8cRtPG/9EeX1y6SAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gk3C3NoNntuG9wUJE6GI3qWczIEmsJiYvIAyaAEjtI8Y/4CK1u0QZW8otsoo2uEBf9abkMYE7QsVdkab/8vZzaeJSmc/Q+P3dQ5wZDpaCxLf4cfN9kGnpT6/Os77aT7j+zOiYmM74EN1ohu6dYeRTJ/aZfw7K6lEbkmvedhSsos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jnz1UWRN; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6d9b41a3cb7so851332b3a.0;
        Sun, 21 Jan 2024 08:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705856155; x=1706460955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D2qDc9wgDSyAGImg6/v/xfY6zLUU7ybAJpIFSFgZNto=;
        b=Jnz1UWRNnDWt9ZHPRA1ZCruF83SLVlHkXDVDcNEfUNtwRdt6AbpkXfUCIGfWQOj3Xf
         S0fbhioOmScTvsFZN+GfizXkIM1eDgLo+wTaPOAh7t4aQDbgylxMbCspAspTf2vpEUZQ
         ugx/vzPPhnPjm9umg5rG+ZJVCSv8i1uXbvsk49szVwynQIMUKYFkSZXrmM5L+5yGD5iw
         ruTIO8uklEI+qmksl101opV04YNp5xAVakJxfANdFzD3Cw95IIzkOU9TdvCb+dXt37he
         xEblc7ibEe6VlO12bEmOu/d47eX/vqI1swWq6CBpgvDGA4/KWxpzURWhoPjke072K3yy
         JiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705856155; x=1706460955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2qDc9wgDSyAGImg6/v/xfY6zLUU7ybAJpIFSFgZNto=;
        b=W3Qo1lAfll7/rPUcUyyBy1gXfduzs30ERC6V4vrZn+cKeHUVGs9oPD+eavf91twARe
         9IgeQbDPkPk0FsesleYnIqLIRinpnuHMb5nxe4q7dtjcbNIoVDVdAN4N0D4buSsEcboX
         0zW7SZUfqS4HivTt/Hj0SY0t3HDpnPAt9I5kyaZpXvMJ+8V9hbe2ZgslttetakNiRfJ8
         2IDXJ7sgBaX1COg+Gp54db+kO1iV6G2SgiHkr07TrZHbPvb9BeuPvFMLDW/dbKiqRTnH
         RiBDgFkXrtFc1aEWDXZxqFjIfsNmJV4YtwGWWprc1o2jAPCz/6zQZhwFpTqImBJqPm72
         VW3Q==
X-Gm-Message-State: AOJu0YygEIlUuq8dhFLv6bXp60K+Gi2iSNh6v7I3myjD9z86Bc2HN/VA
	vlRTjg0gs3E5AFEr07CdXMsXZ0D5BeCs+UJHL6MPb56YjhymSASC
X-Google-Smtp-Source: AGHT+IFRvxoZ5dtEx4AylSL8Ys8d212UfSH7n2aIcy/pCr0Z2W/jVrjwWlL/NcBZRZT4K5V+JU6o0A==
X-Received: by 2002:a17:902:b097:b0:1d7:51b3:491d with SMTP id p23-20020a170902b09700b001d751b3491dmr1125026plr.2.1705856155291;
        Sun, 21 Jan 2024 08:55:55 -0800 (PST)
Received: from visitorckw-System-Product-Name (IP-216-168.cs.nctu.edu.tw. [140.113.216.168])
        by smtp.gmail.com with ESMTPSA id jc9-20020a17090325c900b001d7233f1a92sm3878577plb.221.2024.01.21.08.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 08:55:54 -0800 (PST)
Date: Mon, 22 Jan 2024 00:55:51 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>

On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > Hello,
> > 
> > The existing implementations of heap/heapsort follow the conventional
> > textbook approach, where each heapify operation requires approximately
> > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > that reduces the number of comparisons during heapify operations to
> > approximately log2(n), while maintaining the same number of swap
> > operations.
> > 
> > Thanks,
> > Kuan-Wei
> > 
> > Kuan-Wei Chiu (5):
> >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> >   bcachefs: Introduce parent function for sort_cmp_size()
> >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> >   bcachefs: Optimize number of comparisons in heap_sift_down
> >   bcache: Optimize number of comparisons in heap_sift
> > 
> >  drivers/md/bcache/util.h |  23 +++++----
> >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> >  fs/bcachefs/util.h       |  23 +++++----
> >  3 files changed, 98 insertions(+), 57 deletions(-)
> 
> Good stuff
> 
> While we're looking at this code, we should be doing some cleanup too -
> there's no reason for the heap code to be duplicated in bcache and
> bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> moved to include/linux and bcache converted to use it.
> 
> I also would not be surprised if there's another heap implementation in
> include/linux; we'll want to check for that and if there is decide which
> is worth keeping.
>
Yes, we have 'min_heap.h' in include/linux.

> Would you or Coli be interested in taking that on as well?

