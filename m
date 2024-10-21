Return-Path: <linux-bcache+bounces-776-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F0D9A6AF1
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2024 15:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 970761C236E7
	for <lists+linux-bcache@lfdr.de>; Mon, 21 Oct 2024 13:48:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2686A1F707F;
	Mon, 21 Oct 2024 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mypYa7AF"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15F146BA;
	Mon, 21 Oct 2024 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729518475; cv=none; b=Q71R1FCOGEd6EVuKNn5IS50QMguPS16Nb7SYXOw5gOWDmT1idZuE/2XU7rw9Z5SybL0H7owd3VWHZkAQaZRfYOYM5hoAldAWBn1K2qRiZQRDCRbnlRTIg2vmGNbv8YTAmYMylMT20WHFm2JaDAsn2hySZNLVSPijbUyNO/K3tbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729518475; c=relaxed/simple;
	bh=aUw4WJZmdSfNhxDFuiH2LCXSrIkyodmCvTqA3zgVJps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7skpGBLveR1URqZI5cteMEgnPeoxs8k6AOTIvkRX0L86i3qMvcjdZtvpUtXOfQwJsvkfryEx4mSP+rEtaK7OGnnjCsgjaPspAEp/BkfjR9PynMtLqJQ9tCIiksZk5EEfd2zN+lxs5p3dLeWDxi3C2qn628BWezrnmAgQQiUpJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mypYa7AF; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-20cb89a4e4cso30739965ad.3;
        Mon, 21 Oct 2024 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729518471; x=1730123271; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nD+KqOyffsNNyL4338nxmJl3FPWZED5MQGf79DLqDV4=;
        b=mypYa7AFgrWz+0wQG3I0xNXqdvJpZkKLddJ1Yhe8IHbP24QvbheVMSYRRsxSITAxid
         tp87djKzwgzJVHKser1X3RJFSQCRravKREm1Nyr82cstOKcKLS9nW38q1NJgs3pW/9M3
         tGvN8ohVI7vnF5aoxBhEp5NT03/ibWW/xkuH6NjzhztawJTJWHBJoMCmeC7OCzYPgp+y
         GgEwCfWICt1SB9oO6SAUogtBadu/O272/ySEnoVlMYFBDB1/UEr+IH/PSaAEwtbWBPaB
         gQzOhde2+waT05vgaUjjocqDVGzml9Jxvw/MZnqx91zkKA0AzJ0NwhzMk2UjcDH/GXUr
         Nzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729518471; x=1730123271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nD+KqOyffsNNyL4338nxmJl3FPWZED5MQGf79DLqDV4=;
        b=gH0MgGsc4jVvJEDPjnwtkl+/NVFlKJ1H88uOisp0dr/hcR2GQjEzW/77jA0c6VoPHb
         +IwJZ4nc109E7NoDH9JbPiSA8zfkOE2xByPOET1R8CBPQsyZjTSSEMa8PuZLvCuhddfu
         XWoQBNkXV4MRA09abpJp0atr9QQP0tvqP4K14/+nRZs/OFrzY0G4ib80KzIDqhkknfF1
         P1VQk5BQkJ6pqxYy9Z+2eWNppBuucVbrWcAtdznOD7lg0aohaER+DveadlQqk+oVr77S
         U0if69ZdWstsm0PL3dkxjwbA62NzYqNXEJOiWKdduySz6iuh+8Jb1S8xLmNwlvDHpL1w
         FCJg==
X-Forwarded-Encrypted: i=1; AJvYcCUfeTuGLnCNW8bdAQeAs4atsLGeHMDsE7qxw5x48648KQA9tBv9tRhnIBMhwloe7Wgk+vU90Cq2p8Bt@vger.kernel.org, AJvYcCUyENcnlZsIY/9CFYUD5XC+x/tgKn3be0ngWhMYuT6az5lUrxxDiz3T88+gW6xM/gjJ7LAGKLX9PtxL+dQ=@vger.kernel.org, AJvYcCVe8ywqOLvJgmdG18ckehmkYFuIVHI7xeFkY8xa9RO4Htf28/5cCUYDl8GyjRENFYLBoj5EI22z7PmPc134e/K8dA==@vger.kernel.org, AJvYcCW3DGux/nPU5UOqsFUDK/K9EiiMcwOijE9KflYfX/vNVkvVGTo3J1aHusrZ/xBSM5YzR9fsqQJZ+0wcQcDG@vger.kernel.org, AJvYcCWJtbjoDVKY7/Ov7Xj2jBxJExCbTpkglmNzNuJDaPXiAbz57rjgAxkNu2umkExmxRFR2vJHcjSS2ezL4abhsH8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmxR3WIcnTHap+4ZgEv4MKqSf+L1SwTVY/brMJ1RHVQmSuGaDB
	7ON0+ZQUP7Y2F/ZQfSc/FBZ9YAE3ITWd5bqXzpt8+dSX7/9fJzNz
X-Google-Smtp-Source: AGHT+IGpQioQQSjVna+u0kcFMLLDGy8gnz92x4raQ8iP4uL9jWeq86xdAWB9VASoS23M74pBaQs88w==
X-Received: by 2002:a17:902:ec83:b0:20b:9f8c:e9de with SMTP id d9443c01a7336-20e5a7529f1mr179366035ad.13.1729518471094;
        Mon, 21 Oct 2024 06:47:51 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bd2b8sm25853735ad.159.2024.10.21.06.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 06:47:50 -0700 (PDT)
Date: Mon, 21 Oct 2024 21:47:45 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com,
	corbet@lwn.net, peterz@infradead.org, mingo@redhat.com,
	acme@kernel.org, namhyung@kernel.org, akpm@linux-foundation.org,
	mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
	jolsa@kernel.org, irogers@google.com, adrian.hunter@intel.com,
	kan.liang@linux.intel.com, willy@infradead.org,
	jserv@ccns.ncku.edu.tw, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Enhance min heap API with non-inline functions
 and optimizations
Message-ID: <ZxZbgWc2IsztAOOx@visitorckw-System-Product-Name>
References: <20241020040200.939973-1-visitorckw@gmail.com>
 <ZxYf8VvQIZv9_Y1j@archie.me>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxYf8VvQIZv9_Y1j@archie.me>

On Mon, Oct 21, 2024 at 04:33:37PM +0700, Bagas Sanjaya wrote:
> On Sun, Oct 20, 2024 at 12:01:50PM +0800, Kuan-Wei Chiu wrote:
> > Add non-inline versions of the min heap API functions in lib/min_heap.c
> > and updates all users outside of kernel/events/core.c to use these
> > non-inline versions. To mitigate the performance impact of indirect
> > function calls caused by the non-inline versions of the swap and
> > compare functions, a builtin swap has been introduced that swaps
> > elements based on their size. Additionally, it micro-optimizes the
> > efficiency of the min heap by pre-scaling the counter, following the
> > same approach as in lib/sort.c. Documentation for the min heap API has
> > also been added to the core-api section.
> 
> What tree (and commit) this series is based on?
> 
> Confused...
> 
This patchset is based on Linus' tree, commit 715ca9dd687f ("Merge tag
'io_uring-6.12-20241019' of git://git.kernel.dk/linux"). Since it
touches multiple subsystems, I'm not entirely sure which tree I should
base it on. Should it be linux-next, perhaps?

Regards,
Kuan-Wei


