Return-Path: <linux-bcache+bounces-243-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 034A5836D45
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 18:27:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 877ADB24F8D
	for <lists+linux-bcache@lfdr.de>; Mon, 22 Jan 2024 17:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013D751013;
	Mon, 22 Jan 2024 16:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Enx1HGIs"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7760150279;
	Mon, 22 Jan 2024 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705940629; cv=none; b=AvNKdQGlqOgbps+SJ/pI2JLMdJKoB8g9z41UuPIcRxBe+NDP4sQn6rxjbARe53GCDLLiFMuEOZlSFARfamldkd8s5NOM2X/zV3T7GNUO4tuuawy5RaY18DEN2LX/j+Yuc4+9w9R9CkDh50D/ebGvs1PFzrJ768tZlMfGiY+AlSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705940629; c=relaxed/simple;
	bh=ctEaKNZFDGbsSXqRw8IOY9JUurhEb6JZdXGmd/zRjxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZwCiCbNHyOaLXoC/fgeUDKZqo4a8ipIgaYXJgHjcWn95mchHynQlYrBfkBFIKmsAiTJOJuGltBr9XwLwjKe4CcRek84rGRLf57uh00AtIytXjVmGvbut91zAv5z6CY+fsbBNSeg65cRwvIy7yPjIZDIcN4oNl1j+/5ggdHmaBUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Enx1HGIs; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36275c1f11bso116575ab.1;
        Mon, 22 Jan 2024 08:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705940627; x=1706545427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Mfx2hahF3mSU03cNx8bFJW8kznthWgLM/hhXHRDnxI=;
        b=Enx1HGIsEfU3DzCHtEYX/zvbJsSrMEkQ1VxmvjeBTVrgPBgP2Vs7YFJ7uD1Q2bMv1Z
         vXwFnvWXOGGtAy6MYJcEtavb5bGoH7Y6AvAWdR5j9WhuAim12c5qKgyjCvnitn+2AYui
         zKzi9K7gpKPvU9JpXx8y+bi/YTOXtCpEJP/9UhPbDx9/ywGtAos2+Au1xPYTWNPiWeb5
         lMgH48nvWQQC1rgZr7Wyxl2sbILZRHI9czlv2nJCIjXGW3WYsKk1xoYQmtYovUXKS7F4
         M1BQBXbXNyDlCj+a9GNWniPd/xwNklDcQwoOvECIBjDEklZy5DtoEDumyYHGIa+AdOEE
         p8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705940627; x=1706545427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Mfx2hahF3mSU03cNx8bFJW8kznthWgLM/hhXHRDnxI=;
        b=OqvaX7OYTGA3O2Qb3hIau75Ypcpv/4i1Go6ujGUr8r1l3hkDsIR0fDYZDblWcvsOU5
         3qPZNXO0mwdWvr9+UgeH50pJPMwIqLpzWvAXFCRIO5ZK3ngtC4+aS2UX4ZrfOHXZ2fGu
         R+CllSDI5TQ9luC59ACZoZ3LKW2JcMzaU6T4HAwsjVlLqGWtSAOs3JHEgIq1tes8r9nF
         +AxmqV4vpJOSNOLXHuieGkQN16CStHieUSiwJZg+G258EPbhOfjUEYfZjpG5bYKlSGsb
         8CMl3dT2HW3GTkCR7g+I7Q3p95gnZXR3ntZteetdZTu2DijmBxduOfuXXSc15F190LpS
         osNQ==
X-Gm-Message-State: AOJu0Yzh4faLWc+zQDBBtQnfymcX19SXID7tdMmZAZQdiFA9AzP2k1t0
	w51BhIjM4knfMxvuRZRSppNhdch2H3UHRzLayhk0ELyV04NbbU6rTwXbbqIy
X-Google-Smtp-Source: AGHT+IG6BLYd5D1AcOz1m3V0gy6/cTz5Q8nZuwLgDP3aHWZW79Gac93IIbSggDEw97xq9QyE5ZZHMw==
X-Received: by 2002:a05:6e02:1c2f:b0:35f:f59f:9f4c with SMTP id m15-20020a056e021c2f00b0035ff59f9f4cmr7339058ilh.1.1705940627467;
        Mon, 22 Jan 2024 08:23:47 -0800 (PST)
Received: from visitorckw-System-Product-Name (IP-216-168.cs.nctu.edu.tw. [140.113.216.168])
        by smtp.gmail.com with ESMTPSA id f1-20020a63dc41000000b005c6617b52e6sm8766104pgj.5.2024.01.22.08.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 08:23:47 -0800 (PST)
Date: Tue, 23 Jan 2024 00:23:43 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw,
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <Za6Wj1730cqvoYaQ@visitorckw-System-Product-Name>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
 <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
 <Za1Ml/ZUBXdYXOIt@visitorckw-System-Product-Name>
 <ioyfizrzq7w7mjrqcadtzsfgpuntowtjdw5pgn4qhvsdp4mqqg@nrlek5vmisbu>
 <Za6EjshZWFUPLJef@visitorckw-System-Product-Name>
 <zwcm35flig23fttyybenorsu27ki3dsurqjkjxhrlbnk5zg3n7@vmagssufbuy2>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zwcm35flig23fttyybenorsu27ki3dsurqjkjxhrlbnk5zg3n7@vmagssufbuy2>

On Mon, Jan 22, 2024 at 11:06:39AM -0500, Kent Overstreet wrote:
> On Mon, Jan 22, 2024 at 11:06:54PM +0800, Kuan-Wei Chiu wrote:
> > On Sun, Jan 21, 2024 at 12:41:55PM -0500, Kent Overstreet wrote:
> > > On Mon, Jan 22, 2024 at 12:55:51AM +0800, Kuan-Wei Chiu wrote:
> > > > On Sun, Jan 21, 2024 at 11:21:06AM -0500, Kent Overstreet wrote:
> > > > > On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> > > > > > Hello,
> > > > > > 
> > > > > > The existing implementations of heap/heapsort follow the conventional
> > > > > > textbook approach, where each heapify operation requires approximately
> > > > > > 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> > > > > > that reduces the number of comparisons during heapify operations to
> > > > > > approximately log2(n), while maintaining the same number of swap
> > > > > > operations.
> > > > > > 
> > > > > > Thanks,
> > > > > > Kuan-Wei
> > > > > > 
> > > > > > Kuan-Wei Chiu (5):
> > > > > >   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
> > > > > >   bcachefs: Introduce parent function for sort_cmp_size()
> > > > > >   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
> > > > > >   bcachefs: Optimize number of comparisons in heap_sift_down
> > > > > >   bcache: Optimize number of comparisons in heap_sift
> > > > > > 
> > > > > >  drivers/md/bcache/util.h |  23 +++++----
> > > > > >  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
> > > > > >  fs/bcachefs/util.h       |  23 +++++----
> > > > > >  3 files changed, 98 insertions(+), 57 deletions(-)
> > > > > 
> > > > > Good stuff
> > > > > 
> > > > > While we're looking at this code, we should be doing some cleanup too -
> > > > > there's no reason for the heap code to be duplicated in bcache and
> > > > > bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
> > > > > moved to include/linux and bcache converted to use it.
> > > > > 
> > > > > I also would not be surprised if there's another heap implementation in
> > > > > include/linux; we'll want to check for that and if there is decide which
> > > > > is worth keeping.
> > > > >
> > > > Yes, we have 'min_heap.h' in include/linux.
> > > 
> > > So that has the advantage of more readable code - functions instead of
> > > macros - whereas my version has the type safe interface.
> > > 
> > > We could combine the two approaches, and put a type-safe interface on
> > > top of the min_heap.h code with some small macro wrappers - see
> > > generic-radix-tree.h for an example of how that's done.
> > 
> > Without modifying the interface provided by min_heap.h, it seems
> > challenging to implement the functionality of heap_add due to the
> > relationship with heap_setbackpointer.
> 
> min_heap.h has the same functionality, different interface - updating
> the callers for an interface change is fine.
>
OK, I'll take some time to do these cleanups.
> > 
> > Additionally, when looking into the code in generic-radix-tree.h,
> > should we replace type[0] with type[]? This is because zero-length
> > arrays are deprecated language features mentioned in document [1].
> 
> Zero length arrays are deprecated as VLAs, but this isn't a VLA - we're
> not storing anything there, the variable is just so that macros have
> access to the type.
> 
> > Link: https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-length-and-one-element-arrays [1]
> > > 
> > > min_heap.h has only one user though? I don't think I can quite believe
> > > that's the only other code in the kernel using a heap, there must be
> > > more open coded out there...
> > 
> > I'm not sure why, but it seems that in the kernel, other places using
> > the heap implement their own subsystem-specific solutions rather than
> > utilizing a generic heap interface. For instance,
> > kernel/sched/cpudeadline.c and net/sched/sch_cake.c both have their own
> > implementations.
> 
> Sounds like a fun cleanup project :)

