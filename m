Return-Path: <linux-bcache+bounces-777-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D949A9B182D
	for <lists+linux-bcache@lfdr.de>; Sat, 26 Oct 2024 14:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63D4B282860
	for <lists+linux-bcache@lfdr.de>; Sat, 26 Oct 2024 12:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 253AA1D5CC2;
	Sat, 26 Oct 2024 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h9U2TMv9"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BFB1D2F67;
	Sat, 26 Oct 2024 12:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729946678; cv=none; b=cNRN+fIZMQ5pTjYdvvicz6fCJToKWMGRKvMeMd+PXDo17zpf9C3pCgnL7E26UjQ6afnqCl1j+1j8qtvJPPTwevHChb3lcch8B5XGVIkMUcKhTeLYhcuAUc2W1USWCwp++y2VdKCrfoyYG7jhfjvX8t8f56AkKH/GZpPKZhB9br8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729946678; c=relaxed/simple;
	bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsGeenDXmwzcdCTgBncf9Y61mLoNrdsZc5kUdfSUXjyQcv6rVRZ5moOnp1MqJY5i20ZNf2y3a/VAlSztUHuedSZuME7qulAowGiGLadMVp3LZCeEzmj+hJb4ozd7wnTGKc58k3mTExCfII87SxWNkFnlgRB6/8mkP9Yjaf7UDZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h9U2TMv9; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2e2bd0e2c4fso2292414a91.3;
        Sat, 26 Oct 2024 05:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729946674; x=1730551474; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
        b=h9U2TMv9QVHvOUOwiCtzmMA1nB3eS6vE3exOH6Boer6qZx5D+TT0XxZ9Wr0h1Hpkru
         49hoRzxstQsvlrJ4oTRPc8ajLactezSNuL3wkHLRvWn41eV37DE1ZN/u+W+Sji6esKqM
         JLEk86pNrqX5JVNEz6kQ9v8aNyPJR4c3WVmDy4jxDMLNTCY16sT/u5Bq/mnIFGT+wtek
         cUgulqHXVQpXgRsNGpOKLT3SOB86JyW+9ArNCRRdM0H1ml2vw0ymLwDmC+3c7TkmONEJ
         DnMMavFOmHs7gcUMvjUGbLU9I7vANa2hnj1ksrT+P0kdjY1VAr2R+29XWO12+pvjX8ka
         zeZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729946674; x=1730551474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hlYMxGuvPb703Lut6KKMmkeksJOnNiX3d4CG1prtUWA=;
        b=ggK012TCOeAMYwRTiAGN2ptEB4fprWcHiRl3YztMK3gf4Yur2MWN6LjJcqfjk6MIWq
         J5S3XVdFXxnbKxUyRnbtVAr+9u/yAz5Zs0JuUi/Xx+1RUhtbMchXndeZxMYmAdArBG5z
         +xkOG6444I7rywAd31We5sJ5iUvMMrpPRlqi8RmSR4DlzT8X9RL0Jt8DsydBNQeZajB+
         /yxH8qD9gPENxapmbiuLMUq6JxNSfSlFtAdfrj/Ofgi74Y/t8xWXz/VsZfuCrMxcGs8K
         VDVag1UfsVITO0LB/ZX7SDalmE8YxwL/Vv62GSyr76Hl7bx4+tH/tVylKX+mQOSJXoJ1
         QoyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYzfkNf7+yy3HyvTyySRiyRChN/UhMKzKKM1EkPPiLLvkMac7d9mqDTDtlx2NnDMSjEAXrk6ZrbgPKa5k5@vger.kernel.org, AJvYcCWgoGGBJd/z+8vXxvWH5F9W+7afq7yG/ZBXuBm0yfJrWJAHEVrHihmZRCtrGO/1bzSShFsgCF9+MyLo@vger.kernel.org, AJvYcCX/VovJ/WTTJnjsHVG5nuhs2lu8dRQgGjv0x8QKe5Co9HVc01V8Hu+RZLMDh3Z4Ga9HfrLO5g6A1tGs1PPitYzcEw==@vger.kernel.org, AJvYcCXA78WdN4yi9i8FplitnsC1YPqBNgbx2q1/xqcsiiXey7X+n8CDS7Dpfp4KtPcbbU3HVdSxLyDCRPFM68Ny2QI=@vger.kernel.org, AJvYcCXWjiZaWbDbtMBFT/v8WoQKwYLI0509NmUcVBJJ2eTSSqUstAyoCPF9HR+n/LzOIsDnqVPmAKqz7xAGkmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YytYc7wORegP32vxcr41pTF2JNeZ/KjuMQYEYKkg6iyQAxkJraL
	Sdt/kfdcEbzsEXtH7trHwe05yG7vLI/Xhiz73vTVOAjDIp+w8kmY
X-Google-Smtp-Source: AGHT+IG5ZhDGETx6o3Y/ScrrP5AVxts1TmCd+x6OU8AF59dnaIuGpNAB6tw4k+6hqYITHYo+ZCSzTA==
X-Received: by 2002:a17:90b:1c07:b0:2e7:89df:858c with SMTP id 98e67ed59e1d1-2e8f0f52f70mr2797590a91.6.1729946674353;
        Sat, 26 Oct 2024 05:44:34 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e77e5a4ec4sm5396093a91.54.2024.10.26.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 05:44:33 -0700 (PDT)
Date: Sat, 26 Oct 2024 20:44:28 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: kent.overstreet@linux.dev
Cc: mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org, colyli@suse.de, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxzkLJmhn3a/1ALQ@visitorckw-System-Product-Name>
References: <20241020040200.939973-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241020040200.939973-1-visitorckw@gmail.com>

On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> Add non-inline versions of the min heap API functions in lib/min_heap.c
> and updates all users outside of kernel/events/core.c to use these
> non-inline versions. To mitigate the performance impact of indirect
> function calls caused by the non-inline versions of the swap and
> compare functions, a builtin swap has been introduced that swaps
> elements based on their size. Additionally, it micro-optimizes the
> efficiency of the min heap by pre-scaling the counter, following the
> same approach as in lib/sort.c. Documentation for the min heap API has
> also been added to the core-api section.
>
Hi Kent,

FWIW, here are the bcachefs CI test results for this patch series:
https://evilpiepirate.org/~testdashboard/ci?user=visitorckw&branch=min-heap-update

Regards,
Kuan-Wei

